data "aws_ami" "amaznlinux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = ["al2023-ami-2023.5.20241001.*"]
  }
  
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }

}


resource "aws_instance" "apache_web_server" {
  ami             = data.aws_ami.amaznlinux.id
  instance_type   = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_web.id]

  tags = {
    Name = "Apache Web Server"
  }

  user_data = file("${path.module}/user_data.sh")
}

resource "aws_security_group" "sg_web" {
  name        = "sg_web"
  description = "Allow port 80"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_s3_bucket" "amazn-bucket" {
  bucket = "amazn-bucket-prj-13-hsanchez-386"

  tags = {
    Terraform = "True"
  }
}

resource "aws_db_instance" "mydb" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "admin123456"
  parameter_group_name   = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.sg_db.id]
  skip_final_snapshot    = true
}

resource "aws_security_group" "sg_db" {
  name = "rds_sg"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


output "public_ip_web_server" {
    value = aws_instance.apache_web_server.public_ip
  
}

output "endpoint_db" {
    value = aws_db_instance.mydb.endpoint
  
}

output "connection_string" {
  value = aws_db_instance.mydb.domain_fqdn
}