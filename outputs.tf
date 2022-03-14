
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "availability_zones" {
  description = "List of availability zones used by subnets"
  value       = var.availability_zones
}

output "internet_gateway_id" {
  description = "ID of the generated Internet Gateway"
  value       = aws_internet_gateway.internet_gw.id
}

output "public_subnets_ids" {
  description = "List with the Public Subnets IDs"
  value       = aws_subnet.public_subnets.*.id
}

output "public_subnets_route_table_id" {
  description = "ID of the Route Tables used on Public networks"
  value       = aws_route_table.public_subnets_route_table.*.id
}

output "nat_gw_ids" {
  description = "List with the IDs of the NAT Gateways created on public subnets to provide internet to private subnets"
  value       = aws_nat_gateway.nat_gw.*.id
}

output "private_subnets_ids" {
  description = "List with the Private Subnets IDs"
  value       = aws_subnet.private_subnets.*.id
}

output "private_subnets_route_table_id" {
  description = "ID of the Route Table used on Private networks"
  value       = aws_route_table.private_subnets_route_table.*.id
}

output "lb_dns_name" {
  value       = aws_lb.sample.dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.asg1.name
  description = "The name of the Auto Scaling Group"
}