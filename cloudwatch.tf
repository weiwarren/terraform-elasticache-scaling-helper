# Cloudwatch alarms for triggering scaling

# Since there is no cluster level metrics for elasticache, number of metric queries are
# added based on the number of nodes in the cluster in order to get the average stats. When nodes are
# added or removed the from the cluster, they are programatically updated via the python helper class.

# Alarm for scaling up
resource "aws_cloudwatch_metric_alarm" "auto-scaling-up" {
  # alarm_name for alert on high threashold
  alarm_name                = var.alarm_name_up

  # alarm evaluation periods
  evaluation_periods        = var.alarm_evaluation_periods

  # threahold value
  threshold                 = var.alarm_up_threshold

  # comparision operator
  comparison_operator       = "GreaterThanThreshold"

  # description
  alarm_description         = "auto-scaling-up alarm for elasticache"

  # trigger actions enabled
  actions_enabled           = "true"

  # push notification to sns on alarm
  alarm_actions             = [aws_sns_topic.default.arn]

  insufficient_data_actions = []
  
  # num of meitrc query = number of cluaster nodes
  dynamic "metric_query" {
    for_each = range(var.number_cache_clusters)
    content {
      id = "m${metric_query.key + 1}"

      metric {
        metric_name = var.alarm_metric_name
        namespace   = "AWS/ElastiCache"
        period      = var.alarm_period
        stat        = "Average"
        unit        = "Count"

        dimensions = {
          CacheClusterId = "${var.cache_cluster_name}-00${metric_query.key + 1}"
        }
      }
    }
  }
  metric_query {
    id          = "e1"
    expression  = "AVG(METRICS())"
    label       = "Average"
    return_data = "true"
  }
}


# Alarm for scaling down
resource "aws_cloudwatch_metric_alarm" "auto-scaling-down" {
  alarm_name                = var.alarm_name_down
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = var.alarm_evaluation_periods
  threshold                 = var.alarm_down_threshold
  alarm_description         = "auto-scaling-down alarm for elasticache"
  actions_enabled           = "true"
  alarm_actions             = [aws_sns_topic.default.arn]
  insufficient_data_actions = []

  dynamic "metric_query" {
    for_each = range(var.number_cache_clusters)
    content {
      id = "m${metric_query.key + 1}"

      metric {
        metric_name = var.alarm_metric_name
        namespace   = "AWS/ElastiCache"
        period      = var.alarm_period
        stat        = "Average"
        unit        = "Count"

        dimensions = {
          CacheClusterId = "${var.cache_cluster_name}-00${metric_query.key + 1}"
        }
      }
    }
  }

  metric_query {
    id          = "e1"
    expression  = "AVG(METRICS())"
    label       = "Average"
    return_data = "true"
  }
}
