resource "aws_vpc" "vpc01-vpc" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = "10.0.0.0/16"
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  tags = {
    "Name" = "${var.vpc-name}"
  }
}

resource "aws_subnet" "public-subnet01" {
  vpc_id                                         = aws_vpc.vpc01-vpc.id
  assign_ipv6_address_on_creation                = false
  availability_zone                              = "ap-northeast-1a"
  cidr_block                                     = "10.0.0.0/20"
  customer_owned_ipv4_pool                       = null
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_cidr_block                                = null
  ipv6_cidr_block_association_id                 = null
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  outpost_arn                                    = null
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    "Name" = "vpc01-subnet-public1-ap-northeast-1a"
  }
}

resource "aws_internet_gateway" "igw01" {
  vpc_id = aws_vpc.vpc01-vpc.id
  tags = {
    "Name" = "vpc01-igw"
  }
}

resource "aws_route_table" "rtb-public" {
  vpc_id           = aws_vpc.vpc01-vpc.id
  propagating_vgws = []
  route = [
    {
      carrier_gateway_id         = null
      cidr_block                 = "0.0.0.0/0"
      core_network_arn           = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      gateway_id                 = aws_internet_gateway.igw01.id
      ipv6_cidr_block            = null
      local_gateway_id           = null
      nat_gateway_id             = null
      network_interface_id       = null
      transit_gateway_id         = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
    },
  ]
  tags = {
    "Name" = "vpc01-rtb-public"
  }
}