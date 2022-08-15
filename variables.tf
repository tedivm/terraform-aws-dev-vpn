
variable "identifier" {
  description = "Used to name resources."
  type        = string
}

variable "subnet_ids" {
  description = "The subnets to attach the VPN to. These have to be reachable via the internet. Each one costs $.10/hour."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Additional Security Groups to add to the VPN endpoint."
  default     = []
}

variable "tags" {
  default = {}
}

locals {
  common_tags = merge(var.tags, { "Name" : var.identifier })
}
