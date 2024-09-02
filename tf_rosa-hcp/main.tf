terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway   = true
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.additional_tags
}

output "cluster-private-subnets" {
  value       = module.vpc.private_subnets
  description = "List of private subnet IDs created."
}

output "cluster-public-subnets" {
  value       = module.vpc.public_subnets
  description = "List of private subnet IDs created."
}

output "cluster-subnets-string" {
  value       = join(",", concat(module.vpc.public_subnets, module.vpc.private_subnets))
  description = "Comma-separated string of all subnet IDs created for this cluster."
}
