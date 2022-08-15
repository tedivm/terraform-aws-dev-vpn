
resource "aws_ec2_client_vpn_network_association" "vpn_subnets" {
  count = length(var.subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = var.subnet_ids[count.index]
  security_groups        = concat([aws_security_group.vpn_access.id], var.security_group_ids)

  lifecycle {
    # This is a bug workaround- https://github.com/hashicorp/terraform-provider-aws/issues/14717
    ignore_changes = [subnet_id]
  }
}
