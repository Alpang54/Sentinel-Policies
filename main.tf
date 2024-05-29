terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "example" {
  bucket = "example"
}

resource "aws_iam_policy" "policy" {
  name        = "sample-policy"
  description = "My test policy"
  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Deny",
      "Action": [
        "s3:DeleteBucketPolicy",
        "s3:PutBucketAcl",
        "s3:PutBucketPolicy",
        "s3:PutEncryptionConfiguration",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::*"
      ],
      "Condition": {
        "StringNotEquals": {
          "aws:ResourceAccount": "${data.aws_caller_identity.current.account_id}"
        }
      }
    }
  ]
}
EOT
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id
  policy = aws_iam_policy.policy.arn
}
