provider "aws" {
	region = "ap-south-1"
	profile = "admin"
}

resource "aws_key_pair" "tsk1key" {
  key_name   = "task1key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAlNyCrq7cKb2CzTe9EeQfJ079Fq+HvDAYrKuxoYZZ897j366YDrRhgPRp6LcYZosMoHzEs4ExwBIJ0A3UhCXKM/YUzkLo9VIaTfcPajiVI//pBGGOqMtS/WApU9kMk7JvfxCnpKxJ8fWzkQtarB9WQixGnAcrajBqiwC2J7t1XqqYb6uofeyhiSu2XXghavz6cZzQN+ZTb0qQsVqkVEq7LfItckMu5JRBVaumj+sHQQm6OddkwiV4OgrmO4B3V2CGyiabgC3NuwZYLgH/md2jwDKoZj1FN6KvxqzvLw0Zts2Otsw1yLLRJ1zAB0AkUsdadqXK6RwBJaiH6DnLSWrf+w== rsa-key-20200613"
}

resource "aws_security_group" "task1sg" {
  name        = "task1sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-5be6fb33"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task1sg"
  }
}

resource "aws_instance" "task1-instance" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name      = "task1key"
  security_groups = [ "task1sg" ]
  
  

  tags = {
    Name = "task1-instance"
  }
}

resource "aws_ebs_volume" "task1-ebs" {
  availability_zone = "ap-south-1a"
  size              = 1

  tags = {
    Name = "task1-ebs"
  }
}

resource "aws_volume_attachment" "task1-attach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.task1-ebs.id
  instance_id = aws_instance.task1-instance.id
}