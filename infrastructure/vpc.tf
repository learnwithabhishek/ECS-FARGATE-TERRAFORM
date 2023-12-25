provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "production-vpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Production-VPC"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.production-vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.production-vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "public-subnet-3" {
  vpc_id            = aws_vpc.production-vpc.id
  cidr_block        = var.public_subnet_3_cidr
  availability_zone = "us-east-1c"
  tags = {
    Name = "public-subnet-3"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.production-vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.production-vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-3" {
  vpc_id            = aws_vpc.production-vpc.id
  cidr_block        = var.private_subnet_3_cidr
  availability_zone = "us-east-1c"
  tags = {
    Name = "private-subnet-3"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_1_route_table_association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public_subnet_2_route_table_association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}

resource "aws_route_table_association" "public_subnet_3_route_table_association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-3.id
}

resource "aws_route_table_association" "private_subnet_1_route_table_association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private_subnet_2_route_table_association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2.id
}

resource "aws_route_table_association" "private_subnet_3_route_table_association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-3.id
}

resource "aws_eip" "eip_for_nat_gw" {
  domain                    = "vpc"
  associate_with_private_ip = "10.0.0.5"
  tags = {
    Name = "Production EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = aws_subnet.public-subnet-1.id
  allocation_id = aws_eip.eip_for_nat_gw.id
  tags = {
    Name = "Production Nat GW"
  }
  depends_on = [aws_eip.eip_for_nat_gw]
}

resource "aws_route" "nat_gw_route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "Production-IGW"
  }
}

resource "aws_route" "public_igw_route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.production-igw.id
  destination_cidr_block = "0.0.0.0/0"
}
