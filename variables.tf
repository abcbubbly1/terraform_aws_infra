variable "vpc_cidr" {
	default = "10.1.0.0/16"
	description = "CIDR range of the VPC"
}
variable "subnet_cidr" {
	default = "10.1.1.0/24"
	description = "CIDR range of the Subnet"
}
variable "ec2_key_pair" {
	default= "sydneybreeze-key-pair"
	description = "keypair for sydney breeze application ec2"
}
variable "ec2_instance_type" {
	default = "t2.micro"
	description = "instance type of Ec2 instance"
}
variable "availability_zone" {
	default = "us-east-1a"
	description = "default AZ of Ec2 instance"
}
variable "ec2_ami_id" {
	default = "ami-0e449927258d45bc4"
	description = "AMI ID of ec2 instance"
}

