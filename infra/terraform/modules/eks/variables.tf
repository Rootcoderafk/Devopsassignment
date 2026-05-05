variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_group_name" {
  type = string
}
