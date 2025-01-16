resource "aws_vpc" "safle" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "safle"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.safle.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.safle.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone = "${var.region}a"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.safle.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.safle.id
  cidr_block        = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone = "${var.region}b"
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "aws_vpc.safle.id"
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.safle.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "safle-public-rt"
  }
}

resource "aws_route_table_association" "public_subnet" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet1" {
    subnet_id      = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.public_rt.id
}
