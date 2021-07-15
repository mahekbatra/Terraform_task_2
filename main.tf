provider "aws" {
	region     = "ap-south-1"
	profile    = "default"
}

#step 1:Create a key pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa XXXXXXXXXXXX"
}

#Step2: create a security group
resource "aws_security_group" "sgroup" {

  name        = "sgroup"
  ingress {
   
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
 }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }
}



#Step3:create an instance
resource "aws_instance" "os1" {
  
  ami           = "ami-011c99152163a87ae"
  instance_type = "t2.micro"
  security_groups   = ["sgroup"]
  key_name          = "deployer-key"
	tags = {
		  "Name" = "My OS"
	  }
}

#Step4:create an ebs volume
resource "aws_ebs_volume" "st1" {
   availability_zone = aws_instance.os1.availability_zone 
   size              =  1

  tags = {
    Name = "HelloWorld"
  }
}

#Step5:Attach the volume to the instance
resource "aws_volume_attachment" "v1" {
  device_name = "/dev/sdh"
  volume_id   =  aws_ebs_volume.st1.id
  instance_id =  aws_instance.os1.id
}
