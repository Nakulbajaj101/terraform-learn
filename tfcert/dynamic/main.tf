variable "location" {
    type = string 
    default = "us-west-2"
}

variable "ingress_rules" {
    type = set(object({
        port = number
        description = string 
    })) 
    default = [{
        port = 443
        description = "Port 443"
    },
    {
        port = 80
        description = "Port 80"
    },
    {
        port = 8080
        description = "Port 8080"
    }
    ]
}


variable "egress_rules" {
    type = set(object({
        port = number
        description = string 
    })) 
    default = [{
        port = 443
        description = "Port 443"
    },
    {
        port = 8443
        description = "Port 80"
    }
    ]
}


provider "aws" {
    region = var.location
}

data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
    }
    owners = ["137112412989"]
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
}

resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/16"
}

resource "aws_instance" "myinstance" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.web_traffic.id]
    subnet_id = aws_subnet.mysubnet.id

    tags = {
        Name = "DB Server"
    }
}


resource "aws_security_group" "web_traffic" {
    name = "Secured Traffic"
    description = "Allows secured web traffic only"
    vpc_id = aws_vpc.myvpc.id     

    dynamic "ingress" {
        iterator = port 
        for_each = var.ingress_rules 
        content {
            from_port = port.value.port
            to_port = port.value.port 
            protocol = "TCP"
            cidr_blocks = [aws_vpc.myvpc.cidr_block]
        }
    }

    dynamic "egress" {
        iterator = port 
        for_each = var.egress_rules 
        content {
            from_port = port.value.port
            to_port = port.value.port 
            protocol = "TCP"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
}

