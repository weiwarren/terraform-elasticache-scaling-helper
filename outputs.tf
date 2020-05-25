output "aws_sns_topic" {
  value = aws_sns_topic.default.name
}

output "aws_sqs_queue" {
  value = aws_sqs_queue.default.id
}

output "aws_cloudwatch_alarm_up" {
  value = var.alarm_name_up
}

output "aws_cloudwatch_alarm_down" {
  value = var.alarm_name_down
}