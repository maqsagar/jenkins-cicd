## Deploy Flask and Express on a Single EC2 Instance

🚀 Objective:
Deploy both the Flask backend and the Express frontend on a single Amazon EC2 instance.
Steps:
Provisioning the EC2 Instance:
Launch an EC2 instance on AWS (you can use a free-tier eligible instance).
SSH into the instance and install the following dependencies:
Python for Flask.
Node.js for Express.
Git for pulling the application code.

🚀 Application Setup:
Clone the Flask and Express repositories onto the EC2 instance.
Install the required dependencies for both applications using pip and npm.
Configure both applications to run on different ports (e.g., Flask on port 5000 and Express on port 3000).
Start the applications using process managers like pm2 or systemd to ensure they remain active.

🚀 Deliverables:
A running EC2 instance with Flask and Express accessible via the instance's public IP.
A description or diagram of the deployed architecture.



Full-Stack Docker App (Express + Flask + MongoDB)

This project is a simple full-stack application demonstrating how to connect an Express frontend, a Flask backend, and MongoDB using Docker Compose.

🚀 Features

Node.js + Express Frontend
Displays a form and sends user input to the backend.

Flask Backend API
Receives data, processes it, and stores it in MongoDB.

MongoDB Database
Stores form submissions.

Dockerized Architecture

Separate containers for frontend, backend, and MongoDB

Shared internal Docker network

Easy one-command startup
 
Backend Run 
python3 -m venv venv
source venv/bin/activate
pip install flask
python3 app.py

pip3 install flask
pip3 install flask-cors
pip3 install pymongo

python3 app.py


for frontend

npm install express
node server.js
