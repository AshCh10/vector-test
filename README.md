# Vector on Google Cloud Run with Terraform

This repository sets up [Vector](https://vector.dev/) on **Google Cloud Run** using **Terraform**. It builds and deploys a containerized Vector instance, storing configuration securely in **Google Secret Manager**.

## Deployment Steps

### 1️ **Initialize Terraform**
```bash
terraform init
terraform apply
```

This will:

- Build and push the Docker image to Google Artifact Registry
- Deploy Vector as a Cloud Run service
- Mount vector.yaml securely from Secret Manager
