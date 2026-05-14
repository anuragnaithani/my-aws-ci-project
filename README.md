# AWS Ultimate CI/CD Pipeline Project

## Project Overview

This project demonstrates a complete AWS CI/CD pipeline using GitHub, AWS CodePipeline, AWS CodeBuild, Docker, Docker Hub, AWS CodeDeploy, and Amazon EC2.

The goal of this project is to automatically:

* Detect code changes from GitHub
* Build a Docker image automatically
* Push the Docker image to Docker Hub
* Deploy the application automatically on an EC2 instance using CodeDeploy

This project simulates a real-world DevOps deployment workflow used in production environments.

---

# Architecture

```text
Developer
   ↓
GitHub Repository
   ↓
AWS CodePipeline
   ↓
AWS CodeBuild
   ↓
Docker Hub
   ↓
AWS CodeDeploy
   ↓
Amazon EC2
```

---

# AWS Services Used

| Service                         | Purpose                           |
| ------------------------------- | --------------------------------- |
| GitHub                          | Source code management            |
| CodePipeline                    | CI/CD orchestration               |
| CodeBuild                       | Build Docker image                |
| Docker Hub                      | Store Docker image                |
| CodeDeploy                      | Deploy application                |
| EC2                             | Host the application              |
| Systems Manager Parameter Store | Store Docker credentials securely |
| IAM                             | Manage permissions                |

---

# Project Files

## app.py

Simple Flask application.

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hello Anurag DevOps Project"

app.run(host='0.0.0.0', port=5000)
```

---

## requirements.txt

Contains Python dependencies.

```text
flask
```

---

## Dockerfile

Creates a Docker image for the Flask application.

```dockerfile
FROM python:3.9

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

---

## buildspec.yml

AWS CodeBuild instruction file.

```yaml
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging into Docker Hub
      - docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

  build:
    commands:
      - echo Build started
      - docker build -t simple-python-flask-app .
      - docker tag simple-python-flask-app anuragnaithani018/simple-python-flask-app:latest

  post_build:
    commands:
      - echo Pushing image to Docker Hub
      - docker push anuragnaithani018/simple-python-flask-app:latest
```

---

## appspec.yml

CodeDeploy deployment configuration file.

```yaml
version: 0.0
os: linux

hooks:
  ApplicationStop:
    - location: scripts/stop_container.sh
      timeout: 300
      runas: root

  AfterInstall:
    - location: scripts/start_container.sh
      timeout: 300
      runas: root
```

---

## scripts/start_container.sh

Starts Docker container.

```bash
#!/bin/bash
set -e

docker pull anuragnaithani018/simple-python-flask-app:latest

docker run -d -p 5000:5000 --name flask-app anuragnaithani018/simple-python-flask-app:latest
```

---

## scripts/stop_container.sh

Stops old Docker container.

```bash
#!/bin/bash

docker stop flask-app || true
docker rm flask-app || true
```

---

# Step-by-Step Project Workflow

## Step 1: Create GitHub Repository

A GitHub repository was created to store the application source code.

Files uploaded:

* app.py
* requirements.txt
* Dockerfile
* buildspec.yml
* appspec.yml
* deployment scripts

---

## Step 2: Store Docker Credentials in Parameter Store

AWS Systems Manager Parameter Store was used to securely store Docker Hub credentials.

Parameters created:

```text
/myapp/docker-credentials/username
/myapp/docker-credentials/password
/myapp/docker-registry/url
```

This prevents sensitive credentials from being stored directly in source code.

---

## Step 3: Create CodeBuild Project

A CodeBuild project named:

```text
sample-python-flask-service
```

was created.

CodeBuild responsibilities:

* Pull source code from GitHub
* Build Docker image
* Login to Docker Hub
* Push Docker image

Important settings:

* Ubuntu environment
* Privileged mode enabled
* buildspec.yml selected

---

## Step 4: Create Docker Hub Repository

Docker Hub repository created:

```text
anuragnaithani018/simple-python-flask-app
```

CodeBuild pushes the latest Docker image here.

---

## Step 5: Create EC2 Instance

An Ubuntu EC2 instance was launched.

Important configurations:

* Security Group opened on port 5000
* IAM role attached
* Docker installed
* CodeDeploy agent installed

---

## Step 6: Create IAM Roles

### CodeDeploy Service Role

Role:

```text
codedeploy-service-role
```

Policies:

* AWSCodeDeployRole
* AmazonS3ReadOnlyAccess

### EC2 Instance Role

Role:

```text
ec2-codedeploy-instance-role
```

Policies:

* AmazonEC2RoleforAWSCodeDeploy
* AmazonS3ReadOnlyAccess

---

## Step 7: Create CodeDeploy Application

CodeDeploy application created:

```text
sample-python-flask-app
```

Deployment group created:

```text
sample-python-app
```

Deployment type:

```text
In-place
```

---

## Step 8: Create CodePipeline

Pipeline created:

```text
sample-python-app-v2
```

Pipeline stages:

### Source Stage

* GitHub repository connected

### Build Stage

* CodeBuild project executed

### Deploy Stage

* CodeDeploy deployment triggered

---

# Deployment Flow

```text
Code pushed to GitHub
        ↓
CodePipeline triggered automatically
        ↓
CodeBuild starts
        ↓
Docker image builds
        ↓
Docker image pushed to Docker Hub
        ↓
CodeDeploy deployment starts
        ↓
EC2 pulls latest Docker image
        ↓
Container starts automatically
        ↓
Application becomes live
```

---

# Final Output

Application URL:

```text
http://3.81.13.191:5000
```

Output:

```text
Hello Anurag DevOps Project
```

---

# Screenshots

Add screenshots here:

* GitHub Repository
* Parameter Store
* CodeBuild Success Logs
* Docker Hub Repository
* CodeDeploy Deployment Success
* CodePipeline Success
* EC2 Instance
* Final Browser Output

---

# Key Learnings

* CI/CD pipeline concepts
* Docker image automation
* AWS CodeBuild integration
* AWS CodeDeploy deployment flow
* IAM role permissions
* Docker Hub integration
* Real-world deployment troubleshooting
* Infrastructure automation workflow

---

# Common Errors Solved

During this project, several real DevOps troubleshooting scenarios were solved:

* IAM permission errors
* S3 artifact access errors
* CloudWatch Logs permissions
* Docker authentication issues
* GitHub connection issues
* CodeDeploy lifecycle hook failures
* Missing appspec.yml
* EC2 IAM role issues
* Docker container deployment issues

---

# Create README Using cat Command

```bash
cat > README.md <<'EOF'
# Paste the complete README content here
EOF
```

You can copy the complete README content from this document and paste it between `EOF` and `EOF` in your terminal.

---

# Conclusion

This project successfully demonstrates a complete AWS DevOps CI/CD pipeline using modern cloud-native deployment practices.

The application deployment process is fully automated from GitHub commit to live EC2 deployment using AWS services.

This workflow is similar to production deployment architectures used in real companies.

