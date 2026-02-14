# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Outputs
output "public_subnet_id" {
  description = "ID of public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of private subnet"
  value       = aws_subnet.private.id
}

# EC2 Outputs
output "web_server_public_ip" {
  description = "Public IP of web server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_private_ip" {
  description = "Private IP of web server"
  value       = aws_instance.web_server.private_ip
}

output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = aws_instance.bastion.public_ip
}

output "app_server_private_ip" {
  description = "Private IP of app server"
  value       = aws_instance.app_server.private_ip
}

# Web Server URL
output "web_server_url" {
  description = "URL to access web server"
  value       = "http://${aws_instance.web_server.public_ip}"
}

# SSH Commands
output "ssh_to_bastion" {
  description = "SSH command to connect to bastion"
  value       = "ssh -i ~/.ssh/cloudsecure-key ec2-user@${aws_instance.bastion.public_ip}"
}

output "ssh_to_app_via_bastion" {
  description = "SSH to app server via bastion"
  value       = "ssh -i ~/.ssh/cloudsecure-key -J ec2-user@${aws_instance.bastion.public_ip} ec2-user@${aws_instance.app_server.private_ip}"
}

# S3 Outputs
output "s3_bucket_name" {
  description = "Name of S3 bucket"
  value       = aws_s3_bucket.app_storage.id
}

output "s3_bucket_arn" {
  description = "ARN of S3 bucket"
  value       = aws_s3_bucket.app_storage.arn
}

# Monitoring Outputs
output "sns_topic_arn" {
  description = "ARN of SNS alerts topic"
  value       = aws_sns_topic.alerts.arn
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.app_logs.name
}
