#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

# Wait for cloud-init & apt locks
while fuser /var/lib/dpkg/lock >/dev/null 2>&1; do sleep 5; done

# Update system
apt update -y

# Install dependencies
apt install -y python3 python3-pip git curl

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Switch to ubuntu user
cd /home/ubuntu

# Clone your repo (CHANGE THIS URL)
git clone https://github.com/maqsagar/fb-terraform-single-ec2.git app

# Backend
cd app/backend
pip3 install -r requirements.txt
nohup python3 app.py > backend.log 2>&1 &

# Frontend
cd ../frontend
npm install
nohup npm start > frontend.log 2>&1 &

chown -R ubuntu:ubuntu /home/ubuntu/app
