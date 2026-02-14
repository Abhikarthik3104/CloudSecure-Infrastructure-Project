variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "CloudSecure-Infrastructure"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "owner_name" {
  description = "Owner/creator name"
  type        = string
  default     = "Abhi"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone for subnets"
  type        = string
  default     = "us-east-1a"
}

variable "key_name" {
  description = "Name of SSH key pair"
  type        = string
  default     = "cloudsecure-key"
}

# Alert Email (for CloudWatch notifications)
variable "alert_email" {
  description = "Email address for CloudWatch alerts"
  type        = string
  default     = "abhikarthik3104@gmail.com"  
}