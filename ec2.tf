resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  

  network_interface {
    network_interface_id = aws_network_interface.web01-interface.id
    device_index         = 0
    
  }
  tags = {
    Name = "web-01"
  }
}


resource "aws_network_interface" "web01-interface" {
  subnet_id   = aws_subnet.private-01.id
  security_groups = [aws_security_group.allow_web.id]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.provider.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}