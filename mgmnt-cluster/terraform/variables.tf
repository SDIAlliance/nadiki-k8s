variable "role" {
  type = string
}

variable "internal_subnet_prefix" {
  type = string
}

variable "server_type" {
  type    = string
  default = "cpx21"
}

variable "image_id" {
  type    = string
  default = "ubuntu-20.04"
}

variable "enable_vswitch" {
  type    = bool
  default = false
}
