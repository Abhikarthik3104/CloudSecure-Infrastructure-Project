# ========================================
# Get Latest Amazon Linux AMI
# ========================================

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ========================================
# Web Server (Public Subnet)
# ========================================

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_server.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.web_server.name

  # Encrypted EBS volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "${var.project_name}-web-volume"
    }
  }

  # Auto-install web server when EC2 starts
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>CloudSecure Web Server</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "${var.project_name}-web-server"
    Type = "WebServer"
  }
}

# ========================================
# Bastion Host (Public Subnet)
# ========================================

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = var.key_name

  # Encrypted EBS volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "${var.project_name}-bastion-volume"
    }
  }

  tags = {
    Name = "${var.project_name}-bastion-host"
    Type = "BastionHost"
  }
}

# ========================================
# App Server (Private Subnet)
# ========================================

resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.app_server.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.app_server.name 

  # Encrypted EBS volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "${var.project_name}-app-volume"
    }
  }

  tags = {
    Name = "${var.project_name}-app-server"
    Type = "AppServer"
  }
}
