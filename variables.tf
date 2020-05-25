# ElastiCache
variable "cache_cluster_name" {
  type        = string
  description = "The replication group identifier. This parameter is stored as a lowercase string."
}
variable "number_cache_clusters" {
  type        = number
  description = "Number of nodes for the cluster"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}

# Notification
variable "sqs_name" {
  default     = "elasticache-auto-scaler-sqs"
  type        = string
  description = "SQS queue name"
}
variable "sns_name" {
  default     = "elasticache-auto-scaler-sns"
  type        = string
  description = "SNS topic name"
}

# Alarm
variable "alarm_name_up" {
  default     = "elasticache-auto-scaler-alarm-up"
  type        = string
  description = "CloudWatch alarm name used for scaling out"
}
variable "alarm_name_down" {
  default     = "elasticache-auto-scaler-alarm-down"
  type        = string
  description = "CloudWatch alarm name used for scaling in"
}
variable "alarm_metric_name" {
  default     = "NetworkPacketsOut"
  type        = string
  description = "Metrics name used for mornitoring. e.g. NetworkPacketsOut"
}

variable "alarm_up_threshold" {
  default     = 60000
  type        = number
  description = "Threadhold for scaling out the ElastiCache replicas"
}
variable "alarm_down_threshold" {
  default     = 30000
  type        = number
  description = "Threadhold for scaling down the ElastiCache replicas"
}
variable "alarm_evaluation_periods" {
  default     = 3
  type        = number
  description = "Freqency of cloudwatch alarm evaluation in minutes"
}
variable "alarm_period" {
  default     = 60
  type        = number
  description = "Duration for the underlying alarm evaluation in seconds"
}

