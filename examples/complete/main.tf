module "elasticache_redis" {
  source                = "git@github.com:weiwarren/terraform-aws-elasticache-redis.git?ref=tags/v0.1"
  name                  = "iconic-dev-elasticache"
  number_cache_clusters = 2
  node_type             = "cache.m3.medium"
  engine_version             = "5.0.0"
  port                       = 56379
  maintenance_window         = "mon:10:40-mon:11:40"
  snapshot_window            = "09:10-10:10"
  snapshot_retention_limit   = 1
  automatic_failover_enabled = false
  at_rest_encryption_enabled = false
  transit_encryption_enabled = false
  apply_immediately          = true
  family                     = "redis5.0"
  description                = "This is a testing cluster"
  notification_topic_arn     = module.elasticache_scaling_helper.aws_sns_arn
  subnet_ids         = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id
  source_cidr_blocks = [module.vpc.vpc_cidr_block]
   tags = {
    Application = "elasticache-auto-scaler"
    Owner       = "Devops"
    Environment = "dev"
    Project     = "elasticache-auto-scaler"
  }
}

module "elasticache_scaling_helper"{
  source                = "../../"
  cache_cluster_name    = "iconic-dev-elasticache"
  number_cache_clusters        = 2
  sqs_name = "elasticache-auto-scaler-sqs"
  sns_name = "elasticache-auto-scaler-sns"
  alarm_name_up="elasticache-auto-scaler-alarm-up"
  alarm_name_down="elasticache-auto-scaler-alarm-down"
  tags = {
    Application = "elasticache-auto-scaler"
    Owner       = "Devops"
    Environment = "dev"
    Project     = "elasticache-auto-scaler"
  }
}

module "vpc" {
  source                    = "git::https://github.com/tmknom/terraform-aws-vpc.git?ref=tags/2.0.1"
  cidr_block                = local.cidr_block
  name                      = "vpc-elasticache-redis"
  public_subnet_cidr_blocks = [cidrsubnet(local.cidr_block, 8, 0), cidrsubnet(local.cidr_block, 8, 1)]
  public_availability_zones = data.aws_availability_zones.available.names
}

locals {
  cidr_block = "10.255.0.0/16"
}

data "aws_availability_zones" "available" {}

