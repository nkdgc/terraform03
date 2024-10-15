# IAM Role - EC2RoleforSSM
resource "aws_iam_role" "EC2RoleforSSM" {
    name = "${var.name-prefix}-EC2RoleforSSM"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
}

# Instance Profile
resource "aws_iam_instance_profile" "EC2RoleforSSM-instance-profile" {
  name = "${var.name-prefix}-EC2RoleforSSM-instance-profile"
  role = aws_iam_role.EC2RoleforSSM.name
}
# セキュリティグループの作成
resource "aws_security_group" "ubuntu-web-server-sg" {
  name   = "${var.name-prefix}-ubuntu-web-server-sg"
  vpc_id = var.vpc-id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.ubuntu-web-server-alb-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2インスタンス作成
resource "aws_instance" "ubuntu-web-server" {
  ami                    = "ami-0b20f552f63953f0e" # Ubuntu Server 24.04
  instance_type          = "t2.small"
  iam_instance_profile   = aws_iam_instance_profile.EC2RoleforSSM-instance-profile.name
  subnet_id              = var.subnet-id
  vpc_security_group_ids = [aws_security_group.ubuntu-web-server-sg.id]
  user_data              = <<EOF
#! /bin/bash
# sudo dnf install -y httpd
# sudo systemctl start httpd
# sudo systemctl enable httpd
date > /boot.txt
whoami >> /boot.txt
sudo su - ubuntu -c "wget https://raw.githubusercontent.com/nkdgc/server-setup/main/ubuntu/24.04/setup.sh && chmod 755 setup.sh && ./setup.sh ${var.name-prefix}-ubuntu-web-server --silent |& tee setup.sh.log"
EOF
  tags = {
    Name = "${var.name-prefix}-ubuntu-web-server"
  }
}
