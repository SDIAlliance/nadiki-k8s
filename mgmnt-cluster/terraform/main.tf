
# Network
#########
resource "hcloud_network" "internal_management" {
  name     = "internal-management"
  ip_range = "10.10.0.0/16"
}

resource "hcloud_network_subnet" "internal_vswitch" {
  count        = var.enable_vswitch ? 1 : 0
  network_id   = hcloud_network.internal_management.id
  type         = "vswitch"
  network_zone = "eu-central"
  ip_range     = "10.10.0.0/24"
  vswitch_id   = "25804"
}

resource "hcloud_network_subnet" "internal_cloud" {
  network_id   = hcloud_network.internal_management.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "${var.internal_subnet_prefix}.0/24"
}



#######################################################################
# Management Cluster
#######################################################################

# Load Balancer
###############
resource "hcloud_load_balancer" "kubernetes_api" {
  name               = "${var.role}-kubernetes-api"
  load_balancer_type = "lb11"
  location           = "fsn1"
}

resource "hcloud_load_balancer_network" "kubernetes_api" {
  load_balancer_id = hcloud_load_balancer.kubernetes_api.id
  network_id       = hcloud_network.internal_management.id
  ip               = "${var.internal_subnet_prefix}.9"
}

resource "hcloud_load_balancer_service" "kubernetes_api" {
  load_balancer_id = hcloud_load_balancer.kubernetes_api.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

resource "hcloud_load_balancer_target" "kubernetes_api" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.kubernetes_api.id
  label_selector   = "kaas/cluster=${var.role}"
  use_private_ip   = true
  depends_on = [
    hcloud_load_balancer.kubernetes_api, hcloud_load_balancer_network.kubernetes_api
  ]
}

# Primary IPs
#############
resource "hcloud_primary_ip" "control1" {
  name          = "control1"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  datacenter    = "fsn1-dc14"
}

resource "hcloud_primary_ip" "control2" {
  name          = "control2"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  datacenter    = "fsn1-dc14"
}

resource "hcloud_primary_ip" "control3" {
  name          = "control3"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  datacenter    = "fsn1-dc14"
}

# Servers
#########

# control1
resource "hcloud_server" "control1" {
  name        = "control1.${var.role}.fsn1.tantlinger.io"
  image       = var.image_id
  server_type = var.server_type
  location    = "fsn1"
  ssh_keys    = ["tantlinger"]
  labels = {
    "kaas/group" : "control",
    "kaas/cluster" : "${var.role}"
  }
  depends_on = [
    hcloud_network_subnet.internal_cloud, hcloud_primary_ip.control1
  ]
  # user_data = file("userdata/hcloud-control1.yaml")
  # user_data = file("userdata/default.yaml")
  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.control1.id
    ipv6_enabled = false
  }
}
resource "hcloud_server_network" "control1" {
  server_id = hcloud_server.control1.id
  subnet_id = hcloud_network_subnet.internal_cloud.id
  ip        = "${var.internal_subnet_prefix}.10"
  depends_on = [
    hcloud_network_subnet.internal_cloud
  ]
}

# control2
resource "hcloud_server" "control2" {
  name        = "control2.${var.role}.fsn1.tantlinger.io"
  image       = var.image_id
  server_type = var.server_type
  location    = "fsn1"
  ssh_keys    = ["tantlinger"]
  labels = {
    "kaas/group" : "control",
    "kaas/cluster" : "${var.role}"
  }
  depends_on = [
    hcloud_network_subnet.internal_cloud, hcloud_primary_ip.control2
  ]
  # user_data = file("userdata/hcloud-control1.yaml")
  # user_data = file("userdata/default.yaml")
  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.control2.id
    ipv6_enabled = false
  }
}
resource "hcloud_server_network" "control2" {
  server_id = hcloud_server.control2.id
  subnet_id = hcloud_network_subnet.internal_cloud.id
  ip        = "${var.internal_subnet_prefix}.11"
  depends_on = [
    hcloud_network_subnet.internal_cloud
  ]
}

# control3
resource "hcloud_server" "control3" {
  name        = "control3.${var.role}.fsn1.tantlinger.io"
  image       = var.image_id
  server_type = var.server_type
  location    = "fsn1"
  ssh_keys    = ["tantlinger"]
  labels = {
    "kaas/group" : "control",
    "kaas/cluster" : "${var.role}"
  }
  depends_on = [
    hcloud_network_subnet.internal_cloud, hcloud_primary_ip.control3
  ]
  # user_data = file("userdata/hcloud-control1.yaml")
  # user_data = file("userdata/default.yaml")
  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.control3.id
    ipv6_enabled = false
  }
}
resource "hcloud_server_network" "control3" {
  server_id = hcloud_server.control3.id
  subnet_id = hcloud_network_subnet.internal_cloud.id
  ip        = "${var.internal_subnet_prefix}.12"
  depends_on = [
    hcloud_network_subnet.internal_cloud
  ]
}

