module "vpc" {
  source = "./modules/vpc"
  # Provide variables if defined in vpc/variables.tf
  vpc_cidr = var.vpc_cidr
}