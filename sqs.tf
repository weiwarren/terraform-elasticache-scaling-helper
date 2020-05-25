
# Create the SQS Queue
resource "aws_sqs_queue" "default" {
  name = var.sqs_name
  tags = merge({ "Name" = var.cache_cluster_name }, var.tags)
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = "${aws_sqs_queue.default.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.default.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.default.arn}"
        }
      }
    }
  ]
}
POLICY
}

# Add the SQS as a subscription to the SNS Topic
resource "aws_sns_topic_subscription" "default" {
  topic_arn            = aws_sns_topic.default.arn
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.default.arn
  raw_message_delivery = true // this has to be true for the message subscriber to work
}