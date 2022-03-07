
resource "tls_private_key" "client" {
  algorithm = "RSA"
}

resource "tls_cert_request" "client" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.client.private_key_pem

  subject {
    common_name  = "${var.identifier}.client.vpn"
    organization = "Prodigy Broker"
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem   = tls_cert_request.client.cert_request_pem
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 365 * 24 * 1
  early_renewal_hours   = 180 * 24 * 1

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}

resource "aws_acm_certificate" "client" {
  private_key       = tls_private_key.client.private_key_pem
  certificate_body  = tls_locally_signed_cert.client.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem
  tags              = merge(local.common_tags, { "Name" : "${var.identifier}.client.vpn" })
}
