# Data source for current AWS account
data "aws_caller_identity" "current" {}

# Datadog AWS Integration
resource "datadog_integration_aws" "main" {
  account_id = data.aws_caller_identity.current.account_id
  role_name  = aws_iam_role.datadog_role.name
}

# IAM Role for Datadog
resource "aws_iam_role" "datadog_role" {
  name = "datadog-integration-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::464622532012:root" # Datadog's AWS account
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = datadog_integration_aws.main.external_id
          }
        }
      }
    ]
  })
}

# IAM Policy for Datadog
resource "aws_iam_policy" "datadog_policy" {
  name        = "datadog-policy"
  description = "Policy for Datadog AWS integration"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "apigateway:GET",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "cloudfront:GetDistribution",
          "cloudfront:GetDistributionConfig",
          "cloudfront:ListDistributions",
          "cloudfront:ListTagsForResource",
          "cloudtrail:DescribeTrails",
          "cloudtrail:GetTrailStatus",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "dynamodb:DescribeTable",
          "dynamodb:ListTables",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeReservedInstances",
          "ec2:DescribeReservedInstancesOfferings",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSnapshots",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs",
          "elasticache:DescribeCacheClusters",
          "elasticache:DescribeCacheParameterGroups",
          "elasticache:DescribeCacheParameters",
          "elasticache:DescribeCacheSubnetGroups",
          "elasticache:DescribeEngineDefaultParameters",
          "elasticache:DescribeEvents",
          "elasticache:DescribeReplicationGroups",
          "elasticache:DescribeReservedCacheNodes",
          "elasticache:DescribeReservedCacheNodesOfferings",
          "elasticache:DescribeSnapshots",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticmapreduce:DescribeCluster",
          "elasticmapreduce:DescribeJobFlows",
          "elasticmapreduce:ListClusters",
          "elasticmapreduce:ListInstances",
          "elasticmapreduce:ListSteps",
          "es:DescribeElasticsearchDomain",
          "es:DescribeElasticsearchDomains",
          "es:ListDomainNames",
          "es:ListTags",
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:ListShards",
          "kinesis:ListStreams",
          "kinesis:ListTagsForStream",
          "lambda:GetFunction",
          "lambda:GetFunctionConfiguration",
          "lambda:ListFunctions",
          "lambda:ListTags",
          "rds:DescribeDBClusters",
          "rds:DescribeDBInstances",
          "rds:DescribeDBParameterGroups",
          "rds:DescribeDBParameters",
          "rds:DescribeDBSecurityGroups",
          "rds:DescribeDBSnapshots",
          "rds:DescribeDBSubnetGroups",
          "rds:DescribeEngineDefaultParameters",
          "rds:DescribeEvents",
          "rds:DescribeReservedDBInstances",
          "rds:DescribeReservedDBInstancesOfferings",
          "redshift:DescribeClusters",
          "redshift:DescribeEvents",
          "redshift:DescribeReservedNodes",
          "redshift:DescribeReservedNodeOfferings",
          "route53:GetHealthCheck",
          "route53:GetHealthCheckStatus",
          "route53:ListHealthChecks",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource",
          "s3:GetBucketLocation",
          "s3:GetBucketLogging",
          "s3:GetBucketNotification",
          "s3:GetBucketTagging",
          "s3:GetBucketVersioning",
          "s3:GetBucketWebsite",
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:ListBucketVersions",
          "s3:ListMultipartUploadParts",
          "s3:ListObjects",
          "s3:ListObjectsV2",
          "sns:GetTopicAttributes",
          "sns:ListSubscriptions",
          "sns:ListSubscriptionsByTopic",
          "sns:ListTopics",
          "sqs:GetQueueAttributes",
          "sqs:ListQueues",
          "sqs:ListQueueTags"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "datadog_policy_attachment" {
  role       = aws_iam_role.datadog_role.name
  policy_arn = aws_iam_policy.datadog_policy.arn
}

# Datadog Dashboard
resource "datadog_dashboard" "aws_infrastructure" {
  title         = "AWS Infrastructure Monitoring"
  description   = "Dashboard for monitoring AWS infrastructure with Datadog"
  layout_type   = "ordered"
  is_read_only  = false

  widget {
    widget_layout {
      x      = 0
      y      = 0
      width  = 47
      height = 15
    }
    timeseries_definition {
      title = "EC2 CPU Utilization"
      request {
        q = "avg:aws.ec2.cpuutilization{*} by {instance-id}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "CPU %"
        scale = "linear"
      }
      time = {
        live_span = "1h"
      }
    }
  }

  widget {
    widget_layout {
      x      = 48
      y      = 0
      width  = 47
      height = 15
    }
    timeseries_definition {
      title = "EC2 Memory Utilization"
      request {
        q = "avg:aws.ec2.memoryutilization{*} by {instance-id}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Memory %"
        scale = "linear"
      }
      time = {
        live_span = "1h"
      }
    }
  }

  widget {
    widget_layout {
      x      = 0
      y      = 16
      width  = 47
      height = 15
    }
    timeseries_definition {
      title = "EC2 Network Traffic"
      request {
        q = "avg:aws.ec2.networkin{*} by {instance-id}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      request {
        q = "avg:aws.ec2.networkout{*} by {instance-id}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "dashed"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Bytes/sec"
        scale = "linear"
      }
      time = {
        live_span = "1h"
      }
    }
  }

  widget {
    widget_layout {
      x      = 48
      y      = 16
      width  = 47
      height = 15
    }
    timeseries_definition {
      title = "EC2 Disk Usage"
      request {
        q = "avg:aws.ec2.diskusage{*} by {instance-id}"
        display_type = "line"
        style {
          palette = "dog_classic"
          line_type = "solid"
          line_width = "normal"
        }
      }
      yaxis {
        label = "Disk %"
        scale = "linear"
      }
      time = {
        live_span = "1h"
      }
    }
  }
}

# Datadog Monitor for High CPU
resource "datadog_monitor" "high_cpu" {
  name               = "High CPU Usage Alert"
  type               = "metric alert"
  query              = "avg(last_5m):avg:aws.ec2.cpuutilization{*} by {instance-id} > 80"
  message            = "CPU usage is high on {{instance-id.name}}"
  escalation_message = "CPU usage is critically high on {{instance-id.name}}"

  monitor_thresholds {
    warning  = 70
    critical = 80
  }

  notify_audit = false
  timeout_h    = 0
  include_tags = true
  tags         = ["env:production", "service:aws"]
}

# Datadog Monitor for High Memory
resource "datadog_monitor" "high_memory" {
  name               = "High Memory Usage Alert"
  type               = "metric alert"
  query              = "avg(last_5m):avg:aws.ec2.memoryutilization{*} by {instance-id} > 85"
  message            = "Memory usage is high on {{instance-id.name}}"
  escalation_message = "Memory usage is critically high on {{instance-id.name}}"

  monitor_thresholds {
    warning  = 75
    critical = 85
  }

  notify_audit = false
  timeout_h    = 0
  include_tags = true
  tags         = ["env:production", "service:aws"]
}
