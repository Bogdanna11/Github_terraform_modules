resource "aws_subnet" "public_eu_west_1c" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "Public Subnet"
  }
}

