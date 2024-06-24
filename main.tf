provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "flask_instance" {
  ami           = "ami-08a0d1e16fc3f61ea"
  instance_type = "t2.micro"

  tags = {
    Name = "FlaskInstance"
  }

  vpc_security_group_ids = [aws_security_group.flask_security_group.id]

  key_name = "devopswithsyed_ssh_key"
  provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "sudo yum install -y git python3 python3-pip",
      "sudo git clone https://github.com/syednadeembe/demo_ai.git",
      "cd demo_ai", 
      "sudo pip3 install flask",
      "sudo python3 app.py"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"                                                     // or the appropriate user for your AMI
      private_key = file("/Users/syednadeem/Downloads/devopswithsyed_ssh_key.pem") // Update with your private key path
      host        = self.public_ip
    }
  }
}

resource "aws_security_group" "flask_security_group" {
  name        = "FlaskSecurityGroup"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
