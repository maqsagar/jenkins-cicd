provider "aws" {
  region     = var.region
}

# --------------------
# VPC
# --------------------
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "flask-express-vpc"
  }
}

# --------------------
# Public Subnet
# --------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "public-subnet"
  }
}

# --------------------
# Internet Gateway
# --------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "app-igw"
  }
}

# --------------------
# Route Table
# --------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# --------------------
# Security Group
# --------------------
resource "aws_security_group" "app_sg" {
  name        = "flask-express-sg"
  description = "Allow SSH, Flask and Express"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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

# --------------------
# EC2 Instance
# --------------------
resource "aws_instance" "app" {
  ami                    = "ami-0f5ee92e2d63afc18" # Ubuntu 22.04 ap-south-1
  instance_type          = "t3.micro"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]


  tags = {
    Name = "flask-express-ec2"
  }
}

resource "null_resource" "backend" {
  depends_on = [aws_instance.app]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = aws_instance.app.public_ip
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      # wait for cloud-init & dpkg lock
      "while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do sleep 5; done",

      "export DEBIAN_FRONTEND=noninteractive",

      "sudo apt update -y",
      "sudo apt install -y python3 python3-pip",

      "mkdir -p /home/ubuntu/backend"
    ]
  }

  provisioner "file" {
    source      = "../backend/"
    destination = "/home/ubuntu/backend"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/backend",
      "pip3 install -r requirements.txt",
      "nohup python3 app.py > backend.log 2>&1 &"
    ]
  }
}


resource "null_resource" "frontend" {
  depends_on = [null_resource.backend]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = aws_instance.app.public_ip
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      # wait for cloud-init & dpkg lock
      "while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do sleep 5; done",

      "export DEBIAN_FRONTEND=noninteractive",

      "sudo apt update -y",
      "sudo apt install -y nodejs npm",

      "sudo npm install -g pm2",
      "mkdir -p /home/ubuntu/frontend"
    ]
  }

  provisioner "file" {
    source      = "../frontend/"
    destination = "/home/ubuntu/frontend"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/frontend",
      "npm install",
      "pm2 start npm --name frontend -- start",
      "pm2 save"
    ]
  }
}

