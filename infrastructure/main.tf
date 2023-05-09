terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_subnet" "public_subnet" {
  vpc_id = "vpc-0340562e60e3b5032"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_instance" "ec2_instance" {
  ami = "ami-02f97949d306b597a"
  instance_type = "t2.micro"
  key_name = "keypair"
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  
  tags = {
    Name = "ec2-instance"
  }
}

resource "aws_security_group" "instance_security_group" {
  name = "instance_security_group"
  vpc_id = "vpc-0340562e60e3b5032"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance_security_group"
  }
}

resource "aws_security_group_rule" "egress_rule" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance_security_group.id
}

resource "aws_security_group_rule" "ingress_rule" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance_security_group.id
}

data "aws_iam_policy_document" "cloudtrail_policy" {
  statement {
    actions = [
      "cloudtrail:CreateTrail",
      "cloudtrail:DescribeTrails",
      "cloudtrail:StartLogging",
      "cloudtrail:StopLogging",
      "cloudtrail:UpdateTrail"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudtrail_policy" {
  name   = "cloudtrail_policy"
  policy = data.aws_iam_policy_document.cloudtrail_policy.json
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  policy_arn = aws_iam_policy.cloudtrail_policy.arn
  role       = aws_iam_role.ec2_role.name
}
