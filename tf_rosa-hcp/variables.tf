variable "vpc_name" {
  type        = string
  description = "The Name of the VPC as applied to AWS"
  default     = "rhys-vpc"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Value of the CIDR block to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "aws_region" {
  type        = string
  description = "THe region you want all of this to run in"
  default     = "eu-west-2"
}
variable "availability_zones" {
  type        = list(any)
  description = "The specific availability zones that you want to use"
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "private_subnet_cidrs" {
  type        = list(any)
  description = "VPC privatge subnets"
  default     = []
}

variable "public_subnet_cidrs" {
  type        = list(any)
  description = "VPC public subnets"
  default     = []
}
variable "single_nat_gateway" {
  type        = bool
  description = "Do you want one of a gatgeway for each subnet"
  default     = false
}

variable "cluster_name" {
  type        = string
  description = "the name you want to give the cluster"
}

variable "account_role_prefix" {
  type        = string
  description = "The prefix that the accoutn role should have"
  default     = "account-role"
}

variable "operator_role_prefix" {
  type        = string
  description = "The prefix that should be applied to the operators"
  default     = "operator-role"
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags for AWS resources as required"
  default = {
    "Owner" = "Rhys"
  }
}

variable "admin_credentials_username" {
  type        = string
  description = "First cluster admin user name"
  default     = "cluster-admin"
}

variable "admin_credentials_password" {
  type        = string
  description = "the password to go with the first cluster admin"
}
