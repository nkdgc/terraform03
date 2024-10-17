# module "vpc" {
#   source      = "../../modules/vpc"
#   name-prefix = local.name-prefix
# }
# 
# module "web-server" {
#   source      = "../../modules/web-server"
#   name-prefix = local.name-prefix
#   subnet-id   = module.vpc.private-subnet01-id
#   vpc-id      = module.vpc.vpc-id
# }

module "network" {
  source   = "../../modules/network"
  vpc-name = "vpc01dev-vpc"
  igw-name = "vpc01dev-igw"
}
