#!/bin/bash
set -e
echo "Start"
cd /home/sumit-ranjan-jha/flask-react-template
git pull origin main

# React Frontend
npm ci
npm run build
sudo cp -r dist/* /var/www/html/
echo "Frontend Deployed"

# Python Backend
python3 -m venv venv
venv/bin/pip install pipenv
venv/bin/pipenv install 
echo "Backend done"

pkill gunicorn || true
~/.local/share/virtualenvs/flask-react-template-9ALZKhU7/bin/gunicorn --bind unix:/tmp/app.sock app:app --daemon
echo "Gunicorn start"

sudo nginx -s reload
echo "Done site is live"
