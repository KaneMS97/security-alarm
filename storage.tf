resource "aws_s3_bucket" "security_bucket" {
  bucket        = "kane-stephens-security-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "security_bucket_blocks" {
  bucket = aws_s3_bucket.security_bucket.id

  block_public_policy     = true
  block_public_acls       = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}




