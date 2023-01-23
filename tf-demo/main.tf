terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.30.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "hashicat" {
  source  = "app.terraform.io/cesteban-demos/hashicat/aws"
  version = "1.9.1"
  instance_type = var.instance_type
  region = var.region
  instance_ami = "ami-02c932ab9e2245e47"

}
