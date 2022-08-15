
resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "${var.identifier}.ca.vpn"
    organization = "Developer VPN"
  }

  validity_period_hours = 24 * 365 * 1
  early_renewal_hours   = 24 * 182 * 1
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
}

resource "aws_acm_certificate" "ca" {
  private_key      = tls_private_key.ca.private_key_pem
  certificate_body = tls_self_signed_cert.ca.cert_pem
  tags             = merge(local.common_tags, { "Name" : "${var.identifier}.ca.vpn" })
}
