
data "aws_subnet" "first" {
  id = var.subnet_ids[0]
}

data "aws_vpc" "main" {
  id = data.aws_subnet.first.vpc_id
}

