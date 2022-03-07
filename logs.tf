
resource "aws_cloudwatch_log_group" "main" {
  name = var.identifier
  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "main" {
  name           = var.identifier
  log_group_name = aws_cloudwatch_log_group.main.name
}
