provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test-ec2" {
  ami           = "ami-0747bdcabd34c712a"
  instance_type = "t2.micro"
}
