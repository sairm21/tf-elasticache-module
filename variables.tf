variable "component" {}
variable "env" {}
variable "subnet_ids" {}
variable "tags" {}
variable "kms_key_id" {}
variable "vpc_id" {}
variable "sg_subnet_cidr" {}
variable "port" {
  default = 6379
}
variable "node_type" {}
variable "parameter_group_name" {}
variable "engine_version" {}
variable "engine" {}
