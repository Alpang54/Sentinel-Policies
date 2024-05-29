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

data "template_file" "s3_bucket_policy" {
  template = file("./bucket_iam_policy_block_other_accounts.json")  // Path to your policy template file
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id
  policy = data.template_file.s3_bucket_policy
}
