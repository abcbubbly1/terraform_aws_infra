resource "aws_vpc" "sydney_vpc"{
	#configuration setting for vpc
	cidr_block = var.vpc_cidr
	enable_dns_support = "true"
	enable_dns_hostnames = "true"
	tags = {
		Name = "Sydney-Terra-Vpc",
		environment = "development",
		department = "training",
		Application = "SydneyBreeze"
	}
}
resource "aws_subnet" "sydney_subnet"{
	#configuration setting for subnet
	vpc_id= aws_vpc.sydney_vpc.id
	cidr_block = var.subnet_cidr
	availability_zone = var.availability_zone
	depends_on = [aws_vpc.sydney_vpc]
	tags = {
		Name = "Sydney-Terra-Subnet",
		environment = "development",
		department = "training",
		Application = "SydneyBreeze"
	}
}
resource "aws_internet_gateway" "sydney_internet_gateway"{
	#configuration setting for Internet Gateway
	vpc_id = aws_vpc.sydney_vpc.id
	tags = {
		Name = "Sydney-Terra-IG",
		environment = "development",
		department = "training",
		Application = "SydneyBreeze"
	}
}
resource "aws_route_table" "sydney_route_table"{
	#configuration setting for Route Table and Routes 
	vpc_id = aws_vpc.sydney_vpc.id
	depends_on = [aws_vpc.sydney_vpc]
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.sydney_internet_gateway.id
	}
	route {
		cidr_block = var.vpc_cidr
		gateway_id = "local"
	}
	tags = {
		Name = "Sydney-Terra-RouteTable",
		environment = "development",
		department = "training",
		Application = "SydneyBreeze"
	}
}
resource "aws_route_table_association" "sydney_subnet_route_association"{
	#configuration setting for associating route table with the subnet
	subnet_id = aws_subnet.sydney_subnet.id
	route_table_id = aws_route_table.sydney_route_table.id
	depends_on = [aws_subnet.sydney_subnet, aws_route_table.sydney_route_table]
}
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
