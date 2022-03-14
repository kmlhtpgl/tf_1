
variable "name_prefix" {
  description = "Name prefix for resources on AWS"
  default = "kemal"
}

variable "vpc_cidr_block" {
  description = "AWS VPC CIDR Block"
  default = "10.0.0.0/17"
}

variable "availability_zones" {
  type        = list(any)
  description = "List of availability zones to be used by subnets"
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets_cidrs_per_availability_zone" {
  type        = list(any)
  description = "List of CIDRs to use on each availability zone for public subnets"
  default = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_subnets_cidrs_per_availability_zone" {
  type        = list(any)
  description = "List of CIDRs to use on each availability zone for private subnets"
  default = ["10.0.32.0/19", "10.0.64.0/18"]
}

variable "single_nat" {
  type        = bool
  default     = false
  description = "enable single NAT Gateway"
}

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

variable "server_port" {
  description = "The port the web server will be listening"
  type        = number
  default     = 80
}

variable "elb_port" {
  description = "The port the elb will be listening"
  type        = number
  default     = 80
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
  default     = "kemal"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default = "t2.micro"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default     = 5
}

variable "desired_capacity" {
  description = "The desired number of EC2 Instances in the ASG"
  type        = number
  default     = 2
}

/* variable "private_subnets_ids" {
  description = "List with the Private Subnets IDs"
  type        = string
}

variable "public_subnets_ids" {
  description = "List with the Public Subnets IDs"
  type        = string
}
 */