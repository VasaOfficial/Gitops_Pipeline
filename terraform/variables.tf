variable "region" {
  default = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "172.16.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  default     = ["172.16.1.0/24", "172.16.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  default     = ["172.16.10.0/24", "172.16.11.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "instance_type" {
  description = "Instance type for the Auto Scaling Group"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for accessing EC2 instances"
  default     = "my-key-pair"
}

variable "desired_capacity" {
  description = "Desired capacity for the Auto Scaling Group"
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  default     = 3
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  default     = 1
}
