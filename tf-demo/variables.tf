variable "instance_type" {
  description = "the size of the ec2 instance that you are provisioning"
  default = "t2.micro"
}

variable "region" {
  default = "us-east-1"
}