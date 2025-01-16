# Infrastructure Deployment and Monitoring Guide

## Table of Contents

1.  Introduction
    
2.  Deployment Instructions
    
3.  Triggering the CI/CD Pipeline
    
4.  Setting Up Monitoring and Alerts
    
5.  Design Decisions and Trade-offs
    
6.  Architectural Diagram

7. Setting up HTTPS with Let's Encrypt for Secure Communication  
    

----------

## Introduction

This guide provides a step-by-step process to deploy the AWS infrastructure using Terraform, trigger the CI/CD pipeline, and set up monitoring and alerts. Additionally, it explains the design decisions and trade-offs involved in the infrastructure.

## Deployment Instructions

1.  **Prerequisites:**
    
    -   Install Terraform: Download Terraform
        
    -   Configure AWS CLI with credentials: `aws configure`
        
    -   Ensure you have sufficient IAM permissions to create resources such as VPCs, ECS clusters, RDS instances, and load balancers.
        
2.  **Clone the repository:**
    
    ```
    git clone <repository_url>
    cd <repository_folder>
    ```
    
3.  **Initialize Terraform:**
    
    ```
    terraform init
    ```
    
4.  **Review the plan:**
    
    ```
    terraform plan
    ```
    
    -   Ensure the output matches your expectations. Any changes will be displayed here.
        
5.  **Apply the configuration:**
    
    ```
    terraform apply
    ```
    
    -   Confirm the execution by typing `yes` when prompted.
        
6.  **Outputs:**
    
    -   After successful deployment, Terraform will display outputs such as the load balancer DNS name and the database endpoint.
        

## Triggering the CI/CD Pipeline

1.  **Configure the CI/CD Pipeline:**
    
    -   Add your code repository to a CI/CD tool (e.g., GitHub Actions, GitLab CI, or Jenkins).
        
    -   Use the `main` branch as the deployment trigger.
        
2.  **Modify the pipeline configuration file:**
    
    -   Ensure the configuration file (e.g., `.github/workflows/deploy.yml`) includes steps to:
        
        -   Build and test the application.
            
        -   Push the container image to a registry (e.g., Amazon ECR).
            
        -   Deploy the new image to the ECS service.
            
3.  **Trigger the pipeline:**
    
    -   Push a commit to the repository's main branch:
        
        ```
        git add .
        git commit -m "Trigger pipeline"
        git push origin main
        ```
        
    -   The pipeline will automatically build, test, and deploy your application.


## Setting Up Monitoring and Alerts

1.  **CloudWatch Metrics:**
    
    -   Enable AWS CloudWatch metrics for ECS, RDS, and the load balancer.
        
    -   Key metrics to monitor:
        
        -   ECS: CPU and memory utilization
            
        -   RDS: CPU, connections, and storage usage
            
        -   Load Balancer: Request count and latency
            
2.  **CloudWatch Alarms:**
    
    -   Set up alarms for critical metrics. For example:
        
        -   ECS CPU Utilization > 75%
            
        -   RDS Connections > 80% of the limit
            
        -   Load Balancer 5xx Errors > 10
            
3.  **Notification Configuration:**
    
    -   Use AWS SNS to send notifications when alarms are triggered.
        
    -   Subscribe email or SMS endpoints to the SNS topic.
        
4.  **Third-party Monitoring Tools:**
    
    -   Integrate tools like Datadog or New Relic for advanced monitoring and dashboards.    
        

## Design Decisions and Trade-offs

1.  **VPC Design:**
    
    -   A single VPC with public and private subnets ensures secure isolation of resources while allowing external access via the load balancer.
        
2.  **Fargate for ECS:**
    
    -   Chosen for its serverless nature, eliminating the need to manage EC2 instances.
        
    -   Trade-off: Slightly higher costs compared to EC2-based ECS clusters.
        
3.  **Auto-scaling:**
    
    -   Auto-scaling ensures the system can handle traffic spikes efficiently.
        
    -   Trade-off: Requires careful tuning of thresholds to avoid unnecessary scaling events.
        
4.  **Managed Database (RDS):**
    
    -   Simplifies database management with automated backups and patching.
        
    -   Trade-off: Limited control over database configurations compared to self-managed databases.
        
5.  **Monitoring and Alerts:**
    
    -   CloudWatch provides native integration with AWS services for efficient monitoring.
        
    -   Trade-off: Advanced analytics require third-party tools or custom solutions.
        

## Architectural Diagram

Below is an architectural diagram illustrating the interaction between components:

```
                    +---------------------+
                    |      Clients        |
                    +---------+-----------+
                              |
                              v
                    +---------------------+
                    |  Application Load   |
                    |      Balancer       |
                    +---------+-----------+
                              |
                    +---------------------+
                    |      Public         |
                    |      Subnets        |
                    +---------+-----------+
                              |
               +--------------+--------------+
               |                             |
+-------------------------+     +-------------------------+
|   ECS Fargate Service   |     |       RDS Instance      |
|   (Web Application)     |     |   (Managed Database)    |
+-------------------------+     +-------------------------+
```

The public subnets host the application load balancer, while the private subnets host the ECS services and the RDS database for improved security.

----------


## Deploying application locally

- building the docker image
```
docker build -t <imagename> .
```

- Once the build is completed. Run the container locally.



```
docker-compose up -d
```

- Open the browser and hit the URL http://localhost:8000/




### 1. **Setting up HTTPS with Let's Encrypt for Secure Communication**

You'll need to obtain a free SSL/TLS certificate from Let's Encrypt and configure your web server (e.g., Nginx or Apache) to use HTTPS.

-   **Step 1:** Install Certbot (Let's Encrypt client) on your server:
    
    On Ubuntu:
    
    bash
    
    CopyEdit
    
    `sudo apt update
    sudo apt install certbot python3-certbot-nginx` 
    
-   **Step 2:** Request a certificate for your domain:
    
    bash
    
    CopyEdit
    
    `sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com` 
    
-   **Step 3:** Set up automatic certificate renewal: Certbot automatically sets up a cron job to renew certificates, but you can verify this with:
    
    bash
    
    CopyEdit
    
    `sudo certbot renew --dry-run` 
    
-   **Step 4:** Verify HTTPS: Access your site at `https://yourdomain.com` to ensure it uses the new SSL certificate.
    

### 2. **Restricting SSH Access with Security Groups or Firewall Rules**

You can limit SSH access using security groups (if using a cloud provider like AWS, GCP, or Azure) or firewall rules on the server itself.

#### **AWS Security Group (Example)**

-   Go to the EC2 console and select your instance.
-   Under "Security" settings, edit the security group.
-   Restrict the inbound rule for SSH (port 22) to only allow connections from specific IP addresses:
    -   Select "SSH" and set the source to your trusted IPs, e.g., `203.0.113.0/32`.

#### **Firewall (UFW) Example on Ubuntu**

If you're managing a local server, use UFW to restrict SSH access:

bash

CopyEdit

`sudo ufw allow from 203.0.113.0 to any port 22
sudo ufw enable
sudo ufw status` 

### 3. **Using Environment Variables or a Secrets Manager to Store Sensitive Information**

Instead of hardcoding sensitive information (e.g., API keys, database passwords), use environment variables or a secrets manager like AWS Secrets Manager or HashiCorp Vault.

#### **Using Environment Variables**

-   Store sensitive information in a `.env` file (don't commit it to version control):
    
    makefile
    
    CopyEdit
    
    `DB_PASSWORD=mysecretpassword
    API_KEY=myapikey`

