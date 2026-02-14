# IAM Role for Web Server
resource "aws_iam_role" "web_server" {
  name = "${var.project_name}-web-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-web-server-role"
  }
}

# Web Server Policy - Only what it needs
resource "aws_iam_role_policy" "web_server" {
  name = "${var.project_name}-web-server-policy"
  role = aws_iam_role.web_server.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Can write logs to CloudWatch
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.app_logs.arn}:*"
      },
      {
        # Can read/write only to app storage bucket
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.app_storage.arn}/*"
      },
      {
        # SSM for session manager access
        Effect = "Allow"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

# Instance Profile (links role to EC2)
resource "aws_iam_instance_profile" "web_server" {
  name = "${var.project_name}-web-server-profile"
  role = aws_iam_role.web_server.name
}

# IAM Role for App Server
resource "aws_iam_role" "app_server" {
  name = "${var.project_name}-app-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-app-server-role"
  }
}

# App Server Policy - Minimal permissions
resource "aws_iam_role_policy" "app_server" {
  name = "${var.project_name}-app-server-policy"
  role = aws_iam_role.app_server.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Logs only to security log group
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.security_logs.arn}:*"
      },
      {
        # SSM access
        Effect = "Allow"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

# Instance Profile for App Server
resource "aws_iam_instance_profile" "app_server" {
  name = "${var.project_name}-app-server-profile"
  role = aws_iam_role.app_server.name
}