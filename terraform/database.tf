# resource "aws_db_instance" "safle_db" {
#   allocated_storage    = 20
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   db_name              = "safledb" 
#   username             = "admin"
#   password             = var.db_password
#   parameter_group_name = "default.mysql8.0"
#   skip_final_snapshot  = true

#   #vpc_security_group_ids = [aws_security_group.safle.id]
#   db_subnet_group_name   = aws_db_subnet_group.safle.name
# }

# resource "aws_db_subnet_group" "safle" {
#   name       = "safle"
#   subnet_ids = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
# }
