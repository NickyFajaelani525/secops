terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Dummy resource (tidak akan di-apply)
resource "aws_s3_bucket" "example" {
  bucket = "shiftleft-example-bucket-tod"
}

# --- SIMULASI SECURITY GROUP TIDAK AMAN ---
resource "aws_security_group" "bad_sg" {
  name        = "security_group_jebakan"
  description = "Security group ini sengaja dibuat tidak aman"

  # Bahaya: Membuka SSH ke seluruh dunia (0.0.0.0/0)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
