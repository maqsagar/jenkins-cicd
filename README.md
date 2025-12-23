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

1. Create a EC2 Account with security group, subnet etc.
2. open ports to 
    SSH → 22
    Express → 3000
    Flask → 5000
3. Steps SSh to EC2
4. sudo apt update && sudo apt upgrade -y
5. sudo apt install git -y
6. clone git from git@github.com:maqsagar/ci-cd1.git
7. Backend

sudo apt install python3 python3-pip python3-venv -y
python3 --version
pip3 --version

8. frontend

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y

node -v
npm -v

9. cd /home/ubuntu
git clone directory(ci-cd1)
cd ci-cd there are 2 folders frontend and backend

10. in backend -- cd backend

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

edit the submit link to the running ip

run python app.py

check the browser http://ip:5000/

11. for frontend  --  cd ../fronend

npm install
node server.js or npm start

check the browser http://ip:3000/

## running PM2 steps

1. sudo npm install -g pm2

cd ~/ci-cd1/backend
source venv/bin/activate
pm2 start app.py --name flask-backend --interpreter python3

cd ~/ci-cd1/frontend
pm2 start server.js --name express-frontend

pm2 save
pm2 startup

pm2 startup
[PM2] Init System found: systemd
[PM2] To setup the Startup Script, copy/paste the following command:
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu


pm2 status

then 

check the browser http://ip:5000/
check the browser http://ip:3000/

Data is storing is Mongodb