# Configure the AWS Provider
provider "aws" {
  region                  = var.aws-region
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
}

  data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_caller_identity" "current" {}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  count = local.web_instance_count_map[terraform.workspace]

  tags = {
    Name = "Netology-test"
  }
  instance_initiated_shutdown_behavior = "stop"
  associate_public_ip_address = "true"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    delete_on_termination = "false"
    volume_size = 8
  }

}
//
//resource "aws_instance" "proxy" {
//  for_each = local.instances
//  ami = each.value
//  instance_type = each.key
//}

//resource "aws_instance" "fileserver" {
//  ami = data.aws_ami.ubuntu.id
//  instance_type = "t3.micro"
//  tags = {
//    "project": "main"
//  }
//  lifecycle {
//    create_before_destroy = true
//    prevent_destroy = true
//    ignore_changes = [tags]
//  }
//}

resource "aws_s3_bucket" "netology-test-bucket" {
  bucket = "netology-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Testing"
  }
}
