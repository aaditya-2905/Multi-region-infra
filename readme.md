# 🚀 Multi-Region AWS Infrastructure using Terraform Wrappers & GitLab CI/CD

## 📌 Project Overview

This project demonstrates how to design and deploy a **multi-region, multi-AZ infrastructure** on AWS using **Terraform modules (wrappers)** and automate deployments using **GitLab CI/CD pipelines**.

The infrastructure is deployed across:

* 🌏 **ap-south-1 (Mumbai)**
* 🌎 **us-east-1 (US)**

Each region contains a complete stack including:

* VPC
* Public & Private Subnets
* Security Groups
* EC2 Instances
* Application Load Balancer (ALB)

---

## 🧱 Architecture

```
Region 1 (Mumbai)
VPC → Subnets → SG → EC2 → ALB → Target Group

Region 2 (US)
VPC → Subnets → SG → EC2 → ALB → Target Group
```

---

## 🛠️ Tech Stack

* **Terraform** (Infrastructure as Code)
* **AWS** (Cloud Provider)
* **GitLab CI/CD** (Pipeline automation)
* **S3 + DynamoDB** (Remote backend & state locking)

---

## 📂 Project Structure

```
multi-region-infra/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── backend.tf
├── .gitlab-ci.yml
```

---

## 🔁 Reusability (Wrappers Concept)

This project uses **custom Terraform modules (wrappers)** published on Terraform Registry:

* VPC Module
* EC2 Module
* ALB Module
* Security Group Module

👉 Same modules are reused across multiple regions with different inputs.

---

## 🌍 Multi-Region Deployment

Terraform provider aliases are used:

```hcl
provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}
```

---

## ⚙️ Remote Backend Setup

### 🔹 Step 1: Create S3 Bucket

```bash
aws s3api create-bucket \
  --bucket aaditya-tf-state-bucket \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1
```

---

### 🔹 Step 2: Create DynamoDB Table

```bash
aws dynamodb create-table \
  --table-name terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1
```

---

### 🔹 Step 3: Configure Backend

```hcl
terraform {
  backend "s3" {
    bucket         = "aaditya-tf-state-bucket"
    key            = "multi-region/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}
```

---

## 🚀 How to Run Locally

### 1️⃣ Initialize Terraform

```bash
terraform init
```

---

### 2️⃣ Validate

```bash
terraform validate
```

---

### 3️⃣ Plan

```bash
terraform plan
```

---

### 4️⃣ Apply

```bash
terraform apply -auto-approve
```

---

### 5️⃣ Destroy

```bash
terraform destroy -auto-approve
```

---

## 🔄 GitLab CI/CD Pipeline

### Pipeline Stages

* ✅ Validate
* 🚀 Deploy Mumbai
* 🚀 Deploy US
* 💣 Destroy (Manual)

---

## 📌 Example `.gitlab-ci.yml`

```yaml
stages:
  - Validate
  - Deploy_Mumbai
  - Deploy_US

variables:
  TF_ROOT: "."

before_script:
  - apt-get update -y
  - apt-get install -y unzip curl
  - curl -fsSL https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip -o terraform.zip
  - unzip terraform.zip
  - mv terraform /usr/local/bin/
  - terraform version

validate:
  stage: validate
  script:
    - terraform init
    - terraform validate
    - terraform plan

deploy_mumbai:
  stage: deploy_mumbai
  script:
    - terraform init
    - terraform plan
    - terraform apply -target=module.vpc_mumbai \
                      -target=module.sg_mumbai \
                      -target=module.ec2_mumbai \
                      -target=module.alb_mumbai \
                      -auto-approve
  only:
    - main

deploy_us:
  stage: deploy_us
  script:
    - terraform init
    - terraform plan
    - terraform apply -target=module.vpc_us \
                      -target=module.sg_us \
                      -target=module.ec2_us \
                      -target=module.alb_us \
                      -auto-approve
  only:
    - main
```

---

## 🔐 GitLab CI/CD Variables

Add in GitLab:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

---

## 🎯 Key Features

* ✅ Multi-region deployment
* ✅ Multi-AZ architecture
* ✅ Modular Terraform design
* ✅ Wrapper-based reusable modules
* ✅ CI/CD automation using GitLab
* ✅ Remote backend with state locking
* ✅ Manual destroy pipeline for safety

---

## 🧠 Learnings

* Terraform module design & reuse
* Provider aliasing for multi-region
* Handling Terraform state in CI/CD
* GitLab pipeline design
* AWS infrastructure provisioning

---

## 👨‍💻 Author

**Aadityasinh Zala**

---

## ⭐ Final Outcome

This project demonstrates a **real-world DevOps workflow**:

✔ Infrastructure as Code
✔ Multi-region deployment
✔ CI/CD automation
✔ Safe resource management

---
