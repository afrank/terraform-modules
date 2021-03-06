output "vpc_id" {
  value = module.vpc.vpc_id
}

# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = [module.vpc.vpc_cidr_block]
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = [module.vpc.nat_public_ips]
}

# Cluster Security Groups ID
output "cluster_security_group_id" {
  description = "Cluster security groups ID. Used by workers"
  value       = module.vpc.default_vpc_default_security_group_id
}

