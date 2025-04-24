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

