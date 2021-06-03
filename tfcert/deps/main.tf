provider "aws" {
    region = "us-west-2"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
    }
    owners = ["137112412989"]
}

resource "aws_instance" "my_webserver" { 
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    tags = {
        type = "frontend"
    }
    depends_on = [aws_instance.my_db]
}

resource "aws_instance" "my_db" { 
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    tags = {
        Name = "backend"
    }
}

data "aws_instance" "zonename" {
    filter {
        name = "tag:Name"
        values = ["backend"]
    }
}

output "aws_backend_instance_zone" {
    value = data.aws_instance.zonename.availability_zone
}

output "aws_backend_instance_security_groups" {
    value = data.aws_instance.zonename.security_groups
}

