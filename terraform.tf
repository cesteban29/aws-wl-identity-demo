terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.51.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.23.1"
    }
  }
}