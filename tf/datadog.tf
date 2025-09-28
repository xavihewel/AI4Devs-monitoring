# Data source for current AWS account
data "aws_caller_identity" "current" {}

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
            "sts:ExternalId" = "temporary-placeholder"
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
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs",
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:ListObjects"
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

  widget {
        widget_layout {
          x      = 0
          y      = 0
          width  = 12
          height = 15
        }
    timeseries_definition {
      title = "EC2 CPU Utilization"
      request {
        q = "avg:aws.ec2.cpuutilization{*} by {instance-id}"
        display_type = "line"
      }
    }
  }

  widget {
        widget_layout {
          x      = 0
          y      = 16
          width  = 12
          height = 15
        }
    timeseries_definition {
      title = "EC2 Memory Utilization"
      request {
        q = "avg:aws.ec2.memoryutilization{*} by {instance-id}"
        display_type = "line"
      }
    }
  }

  widget {
        widget_layout {
          x      = 0
          y      = 32
          width  = 12
          height = 15
        }
    timeseries_definition {
      title = "EC2 Network Traffic"
      request {
        q = "avg:aws.ec2.networkin{*} by {instance-id}"
        display_type = "line"
      }
      request {
        q = "avg:aws.ec2.networkout{*} by {instance-id}"
        display_type = "line"
      }
    }
  }

  widget {
        widget_layout {
          x      = 0
          y      = 48
          width  = 12
          height = 15
        }
    timeseries_definition {
      title = "EC2 Disk Usage"
      request {
        q = "avg:aws.ec2.diskusage{*} by {instance-id}"
        display_type = "line"
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

  monitor_thresholds {
    warning  = 75
    critical = 85
  }

  notify_audit = false
  timeout_h    = 0
  include_tags = true
  tags         = ["env:production", "service:aws"]
}
