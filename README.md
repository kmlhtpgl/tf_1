## Definition

This is the readme of  a repository which deploys a simple Apache web server instance on Amazon Linuz 2 in AWS using Terraform v0.14.6. The instances are created in private subnets by Auto Scaling Groups. Application Load Balancer automatically distributes the incoming traffic across them through public subnet. The tfstate file is stored in an S3 bucket securely

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.asg_attachment](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.asg1](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/autoscaling_group) | resource |
| [aws_eip.nat_eip](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/eip) | resource |
| [aws_internet_gateway.internet_gw](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/internet_gateway) | resource |
| [aws_key_pair.key_tf](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/key_pair) | resource |
| [aws_launch_configuration.asg-launch-config-sample](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/launch_configuration) | resource |
| [aws_lb.sample](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/lb) | resource |
| [aws_lb_listener.my-test-alb-listner](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.example-tg](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/lb_target_group) | resource |
| [aws_nat_gateway.nat_gw](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/nat_gateway) | resource |
| [aws_route.private_internet_route](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/route) | resource |
| [aws_route.public_internet_route](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/route) | resource |
| [aws_route_table.private_subnets_route_table](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/route_table) | resource |
| [aws_route_table.public_subnets_route_table](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private_internet_route_table_associations](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_internet_route_table_associations](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/route_table_association) | resource |
| [aws_security_group.elb-sg](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/security_group) | resource |
| [aws_security_group.my_sg](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/security_group) | resource |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/subnet) | resource |
| [aws_subnet.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/4.3.0/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional resource tags | `map(string)` | `{}` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to be used by subnets | `list(any)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b"<br>]</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name to use for all the cluster resources | `string` | `"kemal"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The desired number of EC2 Instances in the ASG | `number` | `2` | no |
| <a name="input_elb_port"></a> [elb\_port](#input\_elb\_port) | The port the elb will be listening | `number` | `80` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of EC2 Instances to run (e.g. t2.micro) | `string` | `"t2.micro"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum number of EC2 Instances in the ASG | `number` | `5` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum number of EC2 Instances in the ASG | `number` | `2` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for resources on AWS | `string` | `"kemal"` | no |
| <a name="input_private_subnets_cidrs_per_availability_zone"></a> [private\_subnets\_cidrs\_per\_availability\_zone](#input\_private\_subnets\_cidrs\_per\_availability\_zone) | List of CIDRs to use on each availability zone for private subnets | `list(any)` | <pre>[<br>  "10.0.32.0/19",<br>  "10.0.64.0/18"<br>]</pre> | no |
| <a name="input_public_subnets_cidrs_per_availability_zone"></a> [public\_subnets\_cidrs\_per\_availability\_zone](#input\_public\_subnets\_cidrs\_per\_availability\_zone) | List of CIDRs to use on each availability zone for public subnets | `list(any)` | <pre>[<br>  "10.0.0.0/20",<br>  "10.0.16.0/20"<br>]</pre> | no |
| <a name="input_server_port"></a> [server\_port](#input\_server\_port) | The port the web server will be listening | `number` | `80` | no |
| <a name="input_single_nat"></a> [single\_nat](#input\_single\_nat) | enable single NAT Gateway | `bool` | `false` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | AWS VPC CIDR Block | `string` | `"10.0.0.0/17"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | The name of the Auto Scaling Group |
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | List of availability zones used by subnets |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | ID of the generated Internet Gateway |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | The domain name of the load balancer |
| <a name="output_nat_gw_ids"></a> [nat\_gw\_ids](#output\_nat\_gw\_ids) | List with the IDs of the NAT Gateways created on public subnets to provide internet to private subnets |
| <a name="output_private_subnets_ids"></a> [private\_subnets\_ids](#output\_private\_subnets\_ids) | List with the Private Subnets IDs |
| <a name="output_private_subnets_route_table_id"></a> [private\_subnets\_route\_table\_id](#output\_private\_subnets\_route\_table\_id) | ID of the Route Table used on Private networks |
| <a name="output_public_subnets_ids"></a> [public\_subnets\_ids](#output\_public\_subnets\_ids) | List with the Public Subnets IDs |
| <a name="output_public_subnets_route_table_id"></a> [public\_subnets\_route\_table\_id](#output\_public\_subnets\_route\_table\_id) | ID of the Route Tables used on Public networks |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
