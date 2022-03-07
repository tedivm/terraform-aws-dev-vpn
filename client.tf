
output "client_config" {
  value = templatefile("${path.module}/templates/client-config.opvn", {
    "dns_name" : aws_ec2_client_vpn_endpoint.vpn.dns_name
    "ca_cert" : tls_self_signed_cert.ca.cert_pem
    "client_cert" : tls_locally_signed_cert.client.cert_pem
    "client_key" : tls_private_key.client.private_key_pem
  })
}
