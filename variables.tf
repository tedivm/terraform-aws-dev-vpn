
variable "identifier" {
  description = "Used to name resources."
  type        = string
}

variable "subnet_ids" {
  description = "The subnets to attach the VPN to. These have to be reachable via the internet. Each one costs $.10/hour."
  type        = list(string)
}

variable "tags" {
  default = {}
}

locals {
  common_tags = merge(var.tags, { "Name" : var.identifier })
}
