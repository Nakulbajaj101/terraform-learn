provider "aws" {
    region = "us-west-2"
}

variable "vpcname" {
    type = string
    default = "myvpc"
}

variable "sshport" {
    type = number
    default = 22
}

variable "enabled" {
    default = true
}

variable "mylist" {
    type = list(string)
    default = ["Value1","Value2"]
}

variable "mymap" {
    type = map
    default = {
        key1 = "Value1"
        key2 = "Value2"
    }
}

variable "mytuple" {
    type = tuple([number, string])
    default = [8080, "name"]
}

variable "myobject" {
    type = object({
        port = list(number)
        description = string
        })
    default = {
        port = [80,8080],
        description = "port numbers"
    }
}

variable "inputname" {
    type = string 
    description = "Set the name of VPC"
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = var.vpcname
        Alias = var.mymap["key1"]
    }
}


output "myoutput" {
    description = "The id of the VPC"
    value = aws_vpc.myvpc.id
} 