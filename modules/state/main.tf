resource "aws_kms_key" "key" {
  description = "The KMS CMK to encrypt the terraform state bucket."

  enable_key_rotation = true

  tags = var.tags
}

resource "aws_kms_alias" "key_alias" {
  name          = "alias/${var.project_name}-state-key"
  target_key_id = aws_kms_key.key.arn
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project_name}-state"
  acl    = "private"

  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.key.arn
      }
    }
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "table" {
  name = "${var.project_name}-state"

  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.key.arn
  }

  tags = var.tags
}
