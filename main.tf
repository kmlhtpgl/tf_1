terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "kml"
}
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "kemal-tfstate"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    
  }
}

resource "aws_key_pair" "key_tf" {
  key_name = "key_tf"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXgCRW6PY//P4MML7C+JWlbdOKeQF/QXJRe9qgiW8lEBzGRxbbYq0+ez/80cfDi4HxNvNOqXoVopzRHMIaaddjnsVL/MVik4q0MTTlnsYugU5Z/PB1i78CfQYxuxwB+Y5yzLxVx/jqwvk0zJJfI9PV7JvWxme0CmtWGjz7pQBrlqXtRYvEYrzPkyWXjU6qjGdyNrDZrf5RQckiGeLtc5+JUV6WoHqxznFfyOj1BczDvcOCUpu6AkFwl+WmHGU7hLwDjsVjRMRj/uM0DQI5PZ0mxbe7jZiH7SlwRM1V0sGdCXqWLrBYz77GywXa8XR2QGZOgkP2of8jNOX8CY8+PPDz ec2-user@ip-172-31-80-75.ec2.internal"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name_prefix}-vpc"
    },
  )

}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name_prefix}-internet-gw"
    },
  )
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(var.availability_zones, count.index)
  cidr_block              = element(var.public_subnets_cidrs_per_availability_zone, count.index)
  map_public_ip_on_launch = true
  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name_prefix}-public-net-${element(var.availability_zones, count.index)}"
    },
  )
}

resource "aws_eip" "nat_eip" {
  count = var.single_nat ? 1 : length(var.availability_zones)
  vpc   = true
  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name_prefix}-nat-eip-${element(var.availability_zones, count.index)}"
    },
  )
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.single_nat ? 1 : length(var.availability_zones)
  allocation_id = var.single_nat ? aws_eip.nat_eip.0.id : element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = var.single_nat ? aws_subnet.public_subnets.0.id : element(aws_subnet.public_subnets.*.id, count.index)

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name_prefix}-nat-gw-${element(var.availability_zones, count.index)}"
    },
  )

  depends_on = [
    aws_internet_gateway.internet_gw
  ]
}

resource "aws_route_table" "public_subnets_route_table" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name_prefix}-public-rt-${element(var.availability_zones, count.index)}"
    },
  )
}

resource "aws_route" "public_internet_route" {
  count = length(var.availability_zones)
  depends_on = [
    aws_internet_gateway.internet_gw,
    aws_route_table.public_subnets_route_table,
  ]
  route_table_id         = element(aws_route_table.public_subnets_route_table.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gw.id
}

resource "aws_route_table_association" "public_internet_route_table_associations" {
  count          = length(var.public_subnets_cidrs_per_availability_zone)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.public_subnets_route_table.*.id, count.index)
}


resource "aws_subnet" "private_subnets" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(var.availability_zones, count.index)
  cidr_block              = element(var.private_subnets_cidrs_per_availability_zone, count.index)
  map_public_ip_on_launch = false
  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name_prefix}-private-net-${element(var.availability_zones, count.index)}"
    },
  )
}

resource "aws_route_table" "private_subnets_route_table" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.additional_tags,
    {
      Name = "${var.name_prefix}-private-rt-${element(var.availability_zones, count.index)}"
    },
  )
}

resource "aws_route" "private_internet_route" {
  count = length(var.availability_zones)
  depends_on = [
    aws_internet_gateway.internet_gw,
    aws_route_table.private_subnets_route_table,
  ]
  route_table_id         = element(aws_route_table.private_subnets_route_table.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat ? aws_nat_gateway.nat_gw.0.id : element(aws_nat_gateway.nat_gw.*.id, count.index)
}

resource "aws_route_table_association" "private_internet_route_table_associations" {
  count     = length(var.private_subnets_cidrs_per_availability_zone)
  subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(
    aws_route_table.private_subnets_route_table.*.id,
    count.index,
  )
}

resource "aws_launch_configuration" "asg-launch-config-sample" {
  image_id          = "ami-0e1d30f2c40c4c701"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.my_sg.id]
  key_name = "key_tf"
  user_data = <<-EOF
  #!/bin/sh
  sudo su
  yum update -y
  yum install -y httpd.x86_64
  systemctl start httpd.service
  systemctl enable httpd.service
  echo "Hello World TF challenge is done" > /var/www/html/index.html
  EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_sg" {
  name = "${var.cluster_name}-my_sg"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb-sg" {
  name = "${var.cluster_name}-elb-sg"
  vpc_id      = aws_vpc.vpc.id
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "asg1" {
  launch_configuration = aws_launch_configuration.asg-launch-config-sample.id
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = [for subnet in aws_subnet.private_subnets : subnet.id]
  health_check_grace_period = 300
  health_check_type    = "EC2"
  force_delete              = true
  target_group_arns         = [aws_lb_target_group.example-tg.arn]
  initial_lifecycle_hook {
    name                 = "foobar"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 2000
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

    notification_metadata = <<EOF
      {
        "foo": "bar"
      }
    EOF
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = true
  }
}
#Webserver
resource "aws_lb" "sample" {
  name               = "${var.cluster_name}-asg-elb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb-sg.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]

}

resource "aws_lb_target_group" "example-tg" {
   health_check {
    protocol            = "HTTP"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
   name     = "example-tg"
   port     = 80
   protocol = "HTTP"
   target_type = "instance"
   vpc_id   = aws_vpc.vpc.id
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg1.id
  lb_target_group_arn   = aws_lb_target_group.example-tg.arn
}
resource "aws_lb_listener" "my-test-alb-listner" {
  load_balancer_arn = "${aws_lb.sample.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.example-tg.arn}"
  }
}