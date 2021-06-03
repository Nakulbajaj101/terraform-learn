provider "aws" {
    region = "us-west-1"
}

provider "aws" {
    region = "us-west-2"
    alias = "oregon"
}

resource "aws_vpc" "orgvpc" {
    cidr_block = "10.0.0.0/16"
    provider = aws.oregon
}

resource "aws_vpc" "calvpc" {
    cidr_block = "10.0.0.0/16"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    provider = aws.oregon
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
    }
    owners = ["137112412989"]
}

resource "aws_instance" "my_webserver" { 
    ami = data.aws_ami.ubuntu.id
    provider = aws.oregon
    instance_type = "t3.micro"
    tags = {
        type = "frontend"
    }

    provisioner "local-exec" {
        command = "echo Zone is ${self.availability_zone}  having public ip ${self.public_ip} >> instance.txt" 
    }
}