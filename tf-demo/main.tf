terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.30.0"
    }
    environment = {
      source = "EppO/environment"
      version = "1.3.3"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "environment" {
  # Configuration options
}

module "hashicat" {
  source  = "app.terraform.io/cesteban-demos/hashicat/aws"
  version = "1.9.1"
  instance_type = var.instance_type
  region = var.region
  instance_ami = "ami-02c932ab9e2245e47"

}
