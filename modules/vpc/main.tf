# VPCの作成
resource "aws_vpc" "vpc01" {
  cidr_block           = "10.200.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name-prefix}-vpc"
  }
}

# インターネットゲートウェイの作成
resource "aws_internet_gateway" "igw01" {
  vpc_id = aws_vpc.vpc01.id
  tags = {
    Name = "${var.name-prefix}-igw01"
  }
}

# NAT ゲートウェイの作成
resource "aws_eip" "eip-natgw01" {
  # count  = 1  // 作成するEIPの数
  domain = "vpc" // VPC内でEIPを使用（vpc = trueの代わりに）
}

resource "aws_nat_gateway" "natgw01" {
  allocation_id = aws_eip.eip-natgw01.id
  subnet_id     = aws_subnet.public-subnet01.id

  tags = {
    Name = "${var.name-prefix}-natgw01"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw01]
}


# -----------------------------------------------------------
# Subnet
# -----------------------------------------------------------

# public01
resource "aws_subnet" "public-subnet01" {
  vpc_id                  = aws_vpc.vpc01.id
  cidr_block              = "10.200.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name-prefix}-public-subnet01"
  }
}

# public02
resource "aws_subnet" "public-subnet02" {
  vpc_id                  = aws_vpc.vpc01.id
  cidr_block              = "10.200.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name-prefix}-public-subnet02"
  }
}

# private01
resource "aws_subnet" "private-subnet01" {
  vpc_id                  = aws_vpc.vpc01.id
  cidr_block              = "10.200.10.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name-prefix}-private-subnet01"
  }
}

# private02
resource "aws_subnet" "private-subnet02" {
  vpc_id                  = aws_vpc.vpc01.id
  cidr_block              = "10.200.11.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name-prefix}-private-subnet02"
  }
}

# -----------------------------------------------------------
# Route Table
# -----------------------------------------------------------

# public用のルートテーブル作成
resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.vpc01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw01.id
  }
  tags = {
    Name = "${var.name-prefix}-rtb-public"
  }
}

# public用のルートテーブルを puclic01 subnet に紐付け
resource "aws_route_table_association" "subnet-rtb-public-assoc-01" {
  subnet_id      = aws_subnet.public-subnet01.id
  route_table_id = aws_route_table.rtb-public.id
}

# public用のルートテーブルを puclic02 subnet に紐付け
resource "aws_route_table_association" "subnet-rtb-public-assoc-02" {
  subnet_id      = aws_subnet.public-subnet02.id
  route_table_id = aws_route_table.rtb-public.id
}

# private用のルートテーブル作成
resource "aws_route_table" "rtb-private" {
  vpc_id = aws_vpc.vpc01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw01.id
  }
  tags = {
    Name = "${var.name-prefix}-rtb-private"
  }
}

# private用のルートテーブルを private01 subnet に紐付け
resource "aws_route_table_association" "subnet-rtb-private-assoc-01" {
  subnet_id      = aws_subnet.private-subnet01.id
  route_table_id = aws_route_table.rtb-private.id
}

# private用のルートテーブルを private02 subnet に紐付け
resource "aws_route_table_association" "subnet-rtb-private-assoc-02" {
  subnet_id      = aws_subnet.private-subnet02.id
  route_table_id = aws_route_table.rtb-private.id
}


