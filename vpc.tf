resource "aws_vpc" "provider" {
  cidr_block       = "10.220.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Provider"
  }
}

resource "aws_subnet" "private-01" {
  vpc_id     = aws_vpc.provider.id
  cidr_block = "10.220.22.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private-01"
  }
}
resource "aws_subnet" "private-02" {
  vpc_id     = aws_vpc.provider.id
  cidr_block = "10.220.23.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-02"
  }
}
resource "aws_subnet" "public-01" {
  vpc_id     = aws_vpc.provider.id
  cidr_block = "10.220.220.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-01"
  }
}
resource "aws_subnet" "public-02" {
  vpc_id     = aws_vpc.provider.id
  cidr_block = "10.220.221.0/24"
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "public-02"
  }
}