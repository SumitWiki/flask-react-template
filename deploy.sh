#!/bin/bash
set -e
echo "Start"
cd /home/ubuntu/flask-react-template
git fetch origin main
git reset --hard origin/main

# React Frontend
NODE_OPTIONS="--max-old-space-size=2048" npm ci
NODE_OPTIONS="--max-old-space-size=2048" npm run build
sudo cp -r dist/public/* /var/www/html/
echo "Frontend Deployed"

# Python Backend
python3 -m venv venv
venv/bin/pip install pipenv
venv/bin/pipenv install
echo "Backend done"

pkill gunicorn || true
venv/bin/pipenv run gunicorn --bind unix:/tmp/app.sock app:app --daemon
echo "Gunicorn start"

sudo nginx -s reload
echo "Done site is live"
