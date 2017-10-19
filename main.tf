provider "aws" {
	region = "eu-west-2"
}

resource "aws_instance" "example" {
	ami = "ami-1a7f6d7e"
	instance_type = "t2.micro"
	tags {
	     Name = "terraform-example"
	     }
}
