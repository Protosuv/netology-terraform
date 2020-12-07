variable "aws-region" {
  default = "us-east-1"
  description = "Default Amazon region"
}

locals {
web_instance_type_map = {
  stage = "t2.micro"
  prod = "t2.large"
  default = "t2.micro"
}
web_instance_count_map = {
  stage = 1
  prod = 2
  default = 0
}
instances = {
  "t3.micro" = data.aws_ami.ubuntu.id
  "t3.large" = data.aws_ami.ubuntu.id
  "t2.micro" = data.aws_ami.ubuntu.id
}
}