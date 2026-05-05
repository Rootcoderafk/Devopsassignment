# Fintech Microservices Deployment

This project implements a highly available, scalable, and secure infrastructure for a fintech application using AWS, Kubernetes (EKS), and modern DevOps practices.

## Project Overview

The application is split into a frontend UI (serving the user interface) and a backend API (handling business logic). All data is persisted in a PostgreSQL database managed by AWS RDS. The entire setup is automated via Terraform and deployed using a GitOps workflow.

---

## Assignment Technical Responses

### (a) Architecture Design
For this project, I opted for a standard AWS VPC architecture spread across multiple Availability Zones to ensure high availability. The public subnets host the Application Load Balancer (ALB) and NAT Gateways, while the private subnets house our EKS worker nodes and RDS database. This 'private-by-default' approach ensures that our sensitive application logic and data are never directly exposed to the open internet.

To handle region-wide failures, the design supports a secondary region (e.g., us-west-2) where a mirror of the environment exists. We use Route 53 with failover routing policies to redirect users if the primary region goes down.

### (b) Terraform Strategy
I organized the infrastructure into reusable modules for the VPC, EKS, and Database. This makes the code dry and easy to maintain. We use an S3 backend with DynamoDB for state locking, which is essential for team collaboration to prevent two people from making changes at once.

For environment separation, I recommend using a folder-based approach (e.g., /environments/dev and /environments/prod). This provides better isolation than workspaces for production environments.

### (c) Docker & Image Strategy
Security and speed were my main priorities here. I used multi-stage Docker builds to keep the final production images as small as possible (using node:20-slim). This doesn't just save storage—it also reduces the attack surface. Images are tagged with the Git Commit SHA for perfect traceability, meaning we always know exactly which code is running in production.

### (d) Kubernetes Deployment
The app is deployed with a RollingUpdate strategy to ensure zero-downtime releases. I also configured Horizontal Pod Autoscalers (HPA) to scale our replicas up or down based on CPU load. Secrets aren't hardcoded; instead, they are managed via Kubernetes Secrets, which pull values securely from our environment configuration.

### (e) CI/CD Pipeline
I built a two-part pipeline:
1. **GitHub Actions**: Handles the 'CI' part. It builds the Docker images, tags them, and pushes them to Amazon ECR whenever code is pushed to the master branch.
2. **Argo CD**: Handles the 'CD' part. It watches our Kubernetes manifests and ensures the cluster always matches what is in the repository. If a deployment fails, we can easily revert the commit in Git to trigger an automatic rollback.

### (f) Failover Scenario
If our primary region fails, Route 53 health checks will detect the downtime and automatically point our domain to the ALB in our secondary region. For data consistency, we use RDS Cross-Region Read Replicas, which can be promoted to a master database within minutes to restore full service with minimal data loss.

---

## How to Run This Project

### 1. Infrastructure
  
Terraform initialized in an empty directory!

The directory has no Terraform configuration files. You may begin working
with Terraform immediately by creating Terraform configuration files.
  

### 2. Create Image Repositories
  
  

### 3. Build & Push Images
Build and push your images to ECR using the provided  logic or manually using Docker.

### 4. Deploy to Kubernetes
Added new context arn:aws:eks:us-east-1:396913730682:cluster/fintech-primary to /home/aditya/.kube/config  
deployment.apps/backend created
service/backend created
deployment.apps/frontend created
service/frontend created
horizontalpodautoscaler.autoscaling/backend-hpa created
horizontalpodautoscaler.autoscaling/frontend-hpa created
secret/db-secret created  
