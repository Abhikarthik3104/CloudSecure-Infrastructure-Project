# ========================================
# S3 Bucket for Application Storage
# ========================================

resource "aws_s3_bucket" "app_storage" {
  bucket = "${lower(var.project_name)}-storage-${random_string.bucket_suffix.result}"

  tags = {
    Name = "${var.project_name}-storage"
    Type = "ApplicationStorage"
  }
}

# Random suffix to make bucket name unique
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# ========================================
# Block ALL Public Access
# ========================================

resource "aws_s3_bucket_public_access_block" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ========================================
# Enable Encryption
# ========================================

resource "aws_s3_bucket_lifecycle_configuration" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id

  rule {
    id     = "cleanup-old-versions"
    status = "Enabled"

    filter {} # REQUIRED

    # Move old versions after 30 days (minimum allowed)
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    # Delete old versions after 90 days
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}
