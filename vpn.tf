
resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "${var.identifier} Client VPN"
  client_cidr_block      = cidrsubnet("172.16.0.0/12", 5, 10)
  split_tunnel           = true
  server_certificate_arn = aws_acm_certificate.server.arn

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.client.arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.main.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.main.name
  }

  tags = local.common_tags
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = data.aws_vpc.main.cidr_block
  authorize_all_groups   = true
  depends_on = [
    aws_ec2_client_vpn_network_association.vpn_subnets
  ]
}
