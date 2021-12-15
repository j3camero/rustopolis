# This Terraform file defines a Rust game server.
provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "rustsg" {
  name = "rust-game-servers"
  ingress {
    from_port   = 28015
    to_port     = 28015
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 28016
    to_port     = 28016
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 28015
    to_port     = 28015
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 28016
    to_port     = 28016
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "solo" {
  ami           = "ami-074251216af698218"
  instance_type = "c5.xlarge"
  vpc_security_group_ids = [aws_security_group.rustsg.id]
  user_data = <<-EOF
              #!/bin/bash
	      git clone https://github.com/j3camero/rustopolis
              sh rustopolis/solo.sh
              EOF
  tags = {
    Name = "solo"
  }
}
