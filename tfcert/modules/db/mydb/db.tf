variable "ami_id" {
    type = string
}

variable "dbname" {
    type = string
}


resource "aws_instance" "my_dbserver" { 
    ami = var.ami_id
    instance_type = "t3.micro"
    tags = {
        name = var.dbname
        type = "backend"
    }
}