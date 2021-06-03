terraform {
    backend "s3" {
        bucket = "terraformstatebackendnakul"
        key = "state/terraform.tfstate"
        region = "us-west-2"
    }
}

provider "aws" {
    region = "us-west-2"
}

variable "vpcname" {
  type = string
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = var.vpcname
    }
}

resource "aws_vpc" "myvpc2" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = var.vpcname
    }
}