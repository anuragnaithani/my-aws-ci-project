#!/bin/bash
set -e

docker pull anuragnaithani018/simple-python-flask-app:latest
docker run -d -p 5000:5000 --name flask-app anuragnaithani018/simple-python-flask-app:latest


