# 1. Get Availability zones
# 2. Set VPC
# 3. Set Gateway
# 4. Set Subnet
# 5. Set Routing Table
# 6. Associat routing table to public subnet 

# Get Availability zones

data "aws_availability_zones" "available" {}

# VPC

resource "aws_vpc" "qa_loadVPClb" {
  cidr_block        = "10.0.0.0/16"
  tags {
    Name            = "qa_loadVPClb"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "qa_loadIG" {
  vpc_id            = "${aws_vpc.qa_loadVPClb.id}"
  tags {
    Name            = "qa_loadIG"
  }
}

# Route table

resource "aws_route_table" "qa_loadPubSN0-0RT" {
  vpc_id            = "${aws_vpc.qa_loadVPClb.id}"
  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = "${aws_internet_gateway.qa_loadIG.id}"
  }
  tags {
    Name            = "qa_loadPubSN0-0RT"
  }
}

# Subnet

resource "aws_subnet" "qa_loadPubSN0-0" {
  vpc_id            = "${aws_vpc.qa_loadVPClb.id}"
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  tags {
    Name            = "qa_loadPubSN0-0"
  }
}

# Associating routing table to public subnet

resource "aws_route_table_association" "loadPubSN0-0RTAssn" {
  subnet_id         = "${aws_subnet.qa_loadPubSN0-0.id}"
  route_table_id    = "${aws_route_table.qa_loadPubSN0-0RT.id}"
}