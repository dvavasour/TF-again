variable "ssh_location" {
    default = "0.0.0.0/0"
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "example" {
  ami = "ami-1a7f6d7e"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  key_name = "EC2_Dunstan"
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y busybox
              echo "Hello World" > index.html
              nohup busybox httpd -f -p 80 &
              EOF
  
  tags {
    Name = "terraform-example"
  }
}
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

    egress {
	from_port       = 0
	to_port         = 0
	protocol        = "-1"
	cidr_blocks     = ["${var.ssh_location}"]
    }

  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.ssh_location}"]
  }
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.ssh_location}"]
  }
}
