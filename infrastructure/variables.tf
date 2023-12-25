variable "region" {
  default = "us-east-1"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "Public subnet 1 Cidr block"
}

variable "public_subnet_2_cidr" {
  description = "Public subnet 2 Cidr block"
}

variable "public_subnet_3_cidr" {
  description = "Public subnet 3 cidr block"
}

variable "private_subnet_1_cidr" {
  description = "Private Subnet 1 cidr block"
}

variable "private_subnet_2_cidr" {
  description = "Private Subnet 2 cidr block"
}

variable "private_subnet_3_cidr" {
  description = "Private Subnet 3 cidr block"
}

variable "ecs_cluster_name" {}
variable "ecs_service_name" {}  
variable "docker_image_url" {}
variable "memory" {}
variable "desired_task_number" {}