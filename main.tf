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

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.example.json
}


data "aws_iam_policy_document" "example" {
  statement {
    sid = "1"

    actions = [
      "s3:DeleteBucketPolicy",
      "s3:PutBucketAcl",
      "s3:PutBucketPolicy",
      "s3:PutEncryptionConfiguration",
      "s3:PutObjectAcl"
    ]

    effect = "Deny"

    resources = [
      "arn:aws:s3:::*",
    ]

    Condition = {
        "StringNotEquals": {
          "aws:ResourceAccount": [
            data.aws_caller_identity.current.account_id

  }

}

