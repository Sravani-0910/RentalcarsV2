locals {
	  vpc_id           = "vpc-09f6df513c48fdef7"
	  subnet_id        = "subnet-06733639e38978678"
	  ssh_user         = "ubuntu"
	  key_name         = "project"
	  private_key_path = "/var/lib/jenkins/.ssh/project.pem"
	}


	provider "aws" {
	  region = "us-west-1"
	}


	resource "aws_security_group" "tomcat" {
	  name   = "tomcat_access"
	  vpc_id = local.vpc_id


	  ingress {
	    from_port   = 22
	    to_port     = 22
	    protocol    = "tcp"
	    cidr_blocks = ["0.0.0.0/0"]
	  }


	  ingress {
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
	}


	resource "aws_instance" "tomcat" {
	  ami                         = "ami-085284d24fe829cd0"
	  subnet_id                   = "subnet-06733639e38978678"
	  instance_type               = "t2.micro"
	  associate_public_ip_address = true
	  security_groups             = [aws_security_group.tomcat.id]
	  key_name                    = local.key_name


	  provisioner "remote-exec" {
	    inline = ["echo 'Wait until SSH is ready'"]


	    connection {
	      type        = "ssh"
	      user        = local.ssh_user
	      private_key = file(local.private_key_path)
	      host        = aws_instance.tomcat.public_ip
	    }
	  }
	  provisioner "local-exec" {
	    command = "ansible-playbook  -i ${aws_instance.tomcat.public_ip}, --private-key ${local.private_key_path} tomcat.yaml"
	  }
	}


	output "tomcat_ip" {
	  value = aws_instance.tomcat.public_ip
	}

