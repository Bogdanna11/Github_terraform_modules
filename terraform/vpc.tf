module "my_vpc" {

 source = "./my_vpc"
 name = "my own vpc"

}


module "public_subnet" {

 source = "./public_subnet"
 name = "public subnet"

}


module "private_subnet" {

 source = "./private_subnet"
 name = "private subnet"

}


module "route_table" {

 source = "./route_table"
 name = "route table"

}

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My VPC - Internet Gateway"
  }
}



resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_sg"
  description = "Allow SSH inbound connections"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   } 
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_sg"
  }
}

output "instance_public_ip" {
  value = "${aws_instance.app_instance.public_ip}"
}


resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound connections"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP Security Group"
  }
}

module "key" {
 source = "./key"
 resource "aws_launch_configuration" "eng114_bogdana" {
  name_prefix = "web-"

  image_id = "ami-0b47105e3d7fc023e"
  instance_type = "t2.micro"
  associate_public_ip_address = true


  security_groups = [aws_security_group.allow_ssh.id ]
  
  connection {
   type = "ssh"
   host = self.public_ip
   user = "ec2-user"
   private_key = file(key_name)
}


  lifecycle {
    create_before_destroy = true
  }
}
}


