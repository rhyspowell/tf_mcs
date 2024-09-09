terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
    }

    rhcs = {
      source  = "terraform-redhat/rhcs"
      version = ">=1.6.3"
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

module "cluster" {
  source  = "terraform-redhat/rosa-hcp/rhcs"
  version = "1.6.3"

  cluster_name      = var.cluster_name
  openshift_version = "4.16.8"
  aws_subnet_ids    = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  replicas          = 3

  // STS configuration
  create_account_roles  = true
  account_role_prefix   = var.account_role_prefix
  create_oidc           = true
  create_operator_roles = true
  operator_role_prefix  = var.operator_role_prefix

  # Cluster Admin User
  # create_admin_user          = true
  # admin_credentials_username = var.admin_credentials_username
  # admin_credentials_password = var.admin_credentials_password
}

module "htpasswd_idp" {
  source     = "terraform-redhat/rosa-hcp/rhcs//modules/idp"
  version    = "1.6.3"
  cluster_id = module.cluster.cluster_id

  name               = "starter-idp"
  idp_type           = "htpasswd"
  htpasswd_idp_users = [{ username = var.admin_credentials_username, password = var.admin_credentials_password }]
}

resource "rhcs_group_membership" "admin" {
  cluster = module.cluster.cluster_id

  user  = var.admin_credentials_username
  group = "cluster-admins"
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

output "password" {
  value     = random_password.password.result
  sensitive = true
}
