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

resource "aws_db_parameter_group" "example" {
  name   = "my-pg"
  family = "postgres13"

  parameter {
    name  = "enabled_cloudwatch_logs_exports"
    value = "audit,error,general,slowquery"
  }

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_rds_cluster" "default" {
  parameter_group_name    = aws_db_parameter_group.example.name
  apply_immediately       = true
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  availability_zones      = ["us-west-2a", "us-west-2b", "us-west-2c"]
  database_name           = "mydb"
  master_username         = "foo"
  master_password         = "bar"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}

