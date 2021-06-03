output "myinstance_privateip" {
    value = aws_instance.my_dbserver.private_ip
}