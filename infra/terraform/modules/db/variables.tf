variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "subnet_ids" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "replicate_source_db" {
  description = "Identifier of the source DB to replicate from (for cross-region)"
  type        = string
  default     = null
}
