variable "aws_region" {
  type    = string
  default = "ap-southeast-1" #Singapore
}

variable "availability_zones" {
  type    = list
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16" #2^16 maximum host
}

variable "public_subnet_cidr_block" {
  type    = list
  default = ["10.0.0.0/26", "10.0.1.0/26"]
}

variable "private_subnet_cidr_block" {
  type    = list
  default = ["10.0.2.0/26", "10.0.3.0/26"]
}