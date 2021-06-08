provider "aws" {
  region = "us-east-1"
}

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}
variable "availability_zone" {
  description = "availability zone to create subnet"
  default     = "us-east-1b"
}
variable "key_name" {
  description = "PEM key name"
  default     = "simplilearn_test"
}
variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default     = "ami-0b0af3577fe5e3532"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default     = "t2.medium"
}
variable "environment_tag" {
  description = "Environment tag"
  default     = "Simplilearn Project 1"
}

resource "aws_vpc" "sl-prj1-vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "sl-prj1-igw" {
  vpc_id = aws_vpc.sl-prj1-vpc.id
}

resource "aws_subnet" "sl-prj1-subnet-public" {
  vpc_id                  = aws_vpc.sl-prj1-vpc.id
  cidr_block              = var.cidr_subnet
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone
}

resource "aws_route_table" "sl-prj1-rtb-public" {
  vpc_id = aws_vpc.sl-prj1-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sl-prj1-igw.id
  }
}

resource "aws_route_table_association" "sl-prj1-rta-subnet-public" {
  subnet_id      = aws_subnet.sl-prj1-subnet-public.id
  route_table_id = aws_route_table.sl-prj1-rtb-public.id
}

# TODO: Rename security group
resource "aws_security_group" "sl-prj1-sg-22" {
  name   = "sg_22"
  vpc_id = aws_vpc.sl-prj1-vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "sl-prj1-k8s-master" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.sl-prj1-subnet-public.id
  vpc_security_group_ids = [aws_security_group.sl-prj1-sg-22.id]
  key_name               = var.key_name
  tags = {
    Name  = "k8s-master"
    Group = "master"
  }
}

resource "aws_instance" "sl-prj1-k8s-worker2" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.sl-prj1-subnet-public.id
  vpc_security_group_ids = [aws_security_group.sl-prj1-sg-22.id]
  key_name               = var.key_name
  tags = {
    Name  = "k8s-worker1"
    Group = "worker"
  }
}

resource "aws_instance" "sl-prj1-k8s-worker2" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.sl-prj1-subnet-public.id
  vpc_security_group_ids = [aws_security_group.sl-prj1-sg-22.id]
  key_name               = var.key_name
  tags = {
    Name  = "k8s-worker2"
    Group = "worker"
  }
}
