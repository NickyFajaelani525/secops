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
  region = "ap-southeast-1"
}

# 1. Mengambil AMI spesifik sesuai request: ubuntu-noble-24.04-amd64-server-20251022
data "aws_ami" "ubuntu_noble" {
  most_recent = true
  owners      = ["099720109477"] # ID Canonical (Pembuat Ubuntu)

  filter {
    name   = "name"
    # Menggunakan nama spesifif agar tepat sasaran
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. Security Group (Wajib ada agar bisa SSH)
resource "aws_security_group" "secops_sg" {
  name        = "secops-allow-ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from World"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.188.169.160/32"] # ip public gueh sajah
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Instance EC2 (Real Creation)
resource "aws_instance" "server_hasil_jenkins" {
  ami           = data.aws_ami.ubuntu_noble.id
  instance_type = "t3.micro"
  
  # Pastikan Key Pair ini SUDAH dibuat di AWS Console Anda
  key_name      = "projek-secops-key" 

  vpc_security_group_ids = [aws_security_group.secops_sg.id]

  tags = {
    Name = "Server-Ubuntu-Noble"
    Project = "Final-SecOps"
  }
}
