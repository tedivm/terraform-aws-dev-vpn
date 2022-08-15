# Terraform AWS Dev VPN Module

This module spins up an AWS VPN in the specified subnets and creates a local configuration file to access it.

This module does some magic- it creates the entire Certificate Authority and various certs needed for the VPN to function, including the client certificate that gets embedded in the opvn file created when run.

This is not meant to be a production VPN with a lot of traffic- rather, this module exists to allow developers to easily and quickly access environments they're developing.

## Usage

### Example

The client configuration file is returned as output from this module. To create the VPN and connect to it you'll need to save the configuration file to disk.

```terraform
module "vpn" {
  source  = "tedivm/dev-vpn/aws"
  version = "~> 1.0"

  identifier         = "${local.identifier}-vpn"
  subnet_ids         = module.vpc.subnets.public[*].id
  security_group_ids = [aws_security_group.optional.id]
  tags               = local.common_tags
}

resource "local_file" "client_config" {
  content  = module.vpn.client_config
  filename = "${path.root}/vpn_config.opvn"
}

```

From the root of the terraform workspace run the following command-

```
openvpn -c vpn_config.opvn
```

### Notes on Pricing

This service is expensive, especially as more users get added to it. For development purposes where only one user will be connected it is worth the money though.

To keep it cheap-

* Only connect to a single subnet. You will be able to route to the others.
* Turn it off when not in use (literally destroy it- make it a countable resource so it can be toggled with a variable).


### Outputs

* client_config - a string containing the Client VPN settings, in opvn format.


## Resources Affected

* Certificate Authority
* ACM Resources
* Cloudwatch logs
* AWS VPN and Subnet Associations
* Security Group
