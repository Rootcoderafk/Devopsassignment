terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Remote state configuration
  # backend "s3" {
  #   bucket         = "fintech-terraform-state"
  #   key            = "prod/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-lock"
  # }
}

provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

module "vpc_primary" {
  source             = "./modules/vpc"
  providers          = { aws = aws.primary }
  vpc_cidr           = "10.0.0.0/16"
  region             = var.primary_region
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones = ["${var.primary_region}a", "${var.primary_region}b"]
  environment        = var.environment
}

module "eks_primary" {
  source          = "./modules/eks"
  providers       = { aws = aws.primary }
  cluster_name    = "${var.cluster_name}-primary"
  subnet_ids      = module.vpc_primary.private_subnet_ids
  environment     = var.environment
  node_group_name = "primary-nodes"
}

module "db_primary" {
  source      = "./modules/db"
  providers   = { aws = aws.primary }
  db_name     = "fintech"
  db_user     = "postgres"
  db_password = var.db_password
  subnet_ids  = module.vpc_primary.private_subnet_ids
  environment = var.environment
}

# Secondary region for failover
module "vpc_secondary" {
  source             = "./modules/vpc"
  providers          = { aws = aws.secondary }
  vpc_cidr           = "10.1.0.0/16"
  region             = var.secondary_region
  public_subnets     = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets    = ["10.1.10.0/24", "10.1.11.0/24"]
  availability_zones = ["${var.secondary_region}a", "${var.secondary_region}b"]
  environment        = var.environment
}

# EKS in secondary region
module "eks_secondary" {
  source          = "./modules/eks"
  providers       = { aws = aws.secondary }
  cluster_name    = "${var.cluster_name}-secondary"
  subnet_ids      = module.vpc_secondary.private_subnet_ids
  environment     = var.environment
  node_group_name = "secondary-nodes"
}

# DB Replica in secondary region
# In a real scenario, use cross-region replication
module "db_secondary_replica" {
  source      = "./modules/db"
  providers   = { aws = aws.secondary }
  db_name     = "fintech"
  db_user     = "postgres"
  db_password = var.db_password
  subnet_ids  = module.vpc_secondary.private_subnet_ids
  environment = var.environment
  # replica_mode = true # Hypothetical flag for module
}
