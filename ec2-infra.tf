resource "aws_security_group" "sydney_web_security_group"{
	#configuration for security group for Ec2 instance of Sydneybreeze
	name = "Sydney Breeze Web SG"
	description = "Secirity Group associated with Web Tier of SydneyBreeze application"
	vpc_id = aws_vpc.sydney_vpc.id
	tags = {
		Name = "Sydney-Web-SG",
		environment = "development",
		department = "training",
		Application = "SydneyBreeze"
	}
}
resource "aws_vpc_security_group_ingress_rule" "sydney_web_allow_ingress_ssh"{
	security_group_id = aws_security_group.sydney_web_security_group.id
	description = "Ingress from Internet"
	cidr_ipv4 = "0.0.0.0/0"
	from_port = 22
	ip_protocol = "tcp"
	to_port = 22
	tags = {
		Name = "Sydney-Web-Allow-Ingress-SSH"
	}
}
resource "aws_vpc_security_group_egress_rule" "sydney_web_allow_egress_internet"{
	security_group_id = aws_security_group.sydney_web_security_group.id
	description = "Egress to Internet"
	cidr_ipv4 = "0.0.0.0/0"
	from_port = -1
	ip_protocol = -1
	to_port = -1
	tags = {
		Name = "Sydney-Web-Allow-Egress-Internet"
	}
}

resource "aws_instance" "sydney_web_ec2"{
	instance_type = var.ec2_instance_type
	ami = var.ec2_ami_id
	key_name = var.ec2_key_pair
	subnet_id = aws_subnet.sydney_subnet.id
	vpc_security_group_ids = [aws_security_group.sydney_web_security_group.id]
	associate_public_ip_address = true
	tags = {
		Name = "Sydney-Web-Ec2",
		environment = "development",
		department = "training",
		Application = "SydneyBreeze"
	}

}
