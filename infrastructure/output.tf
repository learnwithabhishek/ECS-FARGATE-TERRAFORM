output "vpc_id" {
  value = aws_vpc.production-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.production-vpc.cidr_block
}

output "public_subnet1_id" {
  value = aws_subnet.public-subnet-1.id
}

output "public_subnet2_id" {
  value = aws_subnet.public-subnet-2.id
}

output "public_subnet3_id" {
  value = aws_subnet.public-subnet-3.id
}

output "private_subnet1_id" {
  value = aws_subnet.private-subnet-1.id
}

output "private_subnet2_id" {
  value = aws_subnet.private-subnet-2.id
}

output "private_subnet3_id" {
  value = aws_subnet.private-subnet-3.id
}

output "public_subnets" {
  value = [aws_subnet.public-subnet-1, aws_subnet.public-subnet-2, aws_subnet.public-subnet-3]
}

output "private_subnets" {
  value = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id, aws_subnet.private-subnet-3.id]
}