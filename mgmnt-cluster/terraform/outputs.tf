
output "network_id_internal" {
  value = hcloud_network.internal_management.id
}

output "hcloud_primary_ip_control1" {
  value = hcloud_primary_ip.control1.ip_address
}

output "hcloud_primary_ip_control2" {
  value = hcloud_primary_ip.control2.ip_address
}

output "hcloud_primary_ip_control3" {
  value = hcloud_primary_ip.control3.ip_address
}
