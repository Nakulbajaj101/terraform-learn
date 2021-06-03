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
}

module "dbserver" {
    source = "./db/mydb"
    ami_id = data.aws_ami.ubuntu.id
    dbname = "Hello World"
}

output "mydbprivateIp" {
    value = module.dbserver.myinstance_privateip
}