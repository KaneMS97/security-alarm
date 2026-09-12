locals {
  trail_name = "cloudtrail-log"
}

resource "aws_cloudtrail" "logging" {
  depends_on                    = [aws_s3_bucket_policy.cloudtrail_s3_policy]
  name                          = local.trail_name
  s3_bucket_name                = aws_s3_bucket.logging_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}

resource "aws_s3_bucket" "logging_bucket" {
  bucket        = "kane-stephens-logging-08"
  force_destroy = true
}
resource "aws_s3_bucket_public_access_block" "logging_bucket" {
  bucket = aws_s3_bucket.logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cloudtrail_s3_policy" {
  bucket = aws_s3_bucket.logging_bucket.id
  policy = data.aws_iam_policy_document.cloudtrail_s3_policy.json
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}