# This Terraform file defines a Rust game server.
provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "rustsg" {
  name = "rust-game-servers"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

resource "aws_key_pair" "rustopolis" {
  key_name   = "rustopolis-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBD8CEPjXEF/N0f3xHsjHc9XqazXchPwVMCWtuiv3pEU9jTE8Se04SvMR/i1+bD6x1gMR8npMvghnseJdRYXLxcNZcT5LYHygApZN1FrxeM5OLIqeRNg/x+lO/q71GFkxT27cu0co8wpkhQk+ptuOg1dTLPxrtHhVvkFhfJN68lEEaRhvS5hfiRTMHHDJO/JY5CJVl+8exeAD6dtWM5IhA35ljd9AjteIuCiwCuNRIkmIX0e21IaGnkYbr7Do01SdrY12S4T5fycCxP7aZMv3Kq0VjrdBs3vzIO9gKNDwRdZAA2Ko/Jw9BepmcHfRTc3zMF3po8+YSZ6b8bcMzrc9j"
}

resource "aws_instance" "solo" {
  ami = "ami-074251216af698218"
  associate_public_ip_address = true
  instance_type = "c5.xlarge"
  key_name = "rustopolis-key"
  root_block_device {
    volume_size = 20
  }
  user_data = <<-EOF
              #!/bin/bash
	      echo "Test test 123" > testing.txt
	      git clone https://github.com/j3camero/rustopolis
              sh rustopolis/solo.sh
              EOF
  tags = {
    Name = "solo"
  }
  vpc_security_group_ids = [aws_security_group.rustsg.id]
}

output "server_ip" {
  description = "The public ip of the game server."
  value = aws_instance.solo.public_ip
}
