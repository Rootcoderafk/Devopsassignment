variable "primary_region" {
  description = "The primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "The secondary AWS region for failover"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "prod"
}

variable "db_password" {
  description = "The password for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "fintech"
}
