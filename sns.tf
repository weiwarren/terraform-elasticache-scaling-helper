# Create the SNS Topic resource
resource "aws_sns_topic" "default" {
  name = var.sns_name
  tags = merge({ "Name" = var.cache_cluster_name }, var.tags)
}