# node-docker-pipeline
# Cloud-Native Node.js API with DevSecOps CI/CD Pipeline

This repository serves as a proof-of-concept for modern cloud-native infrastructure, demonstrating the end-to-end operational lifecycle of a Node.js/Express backend. It highlights the integration of application development with enterprise-grade DevSecOps practices, featuring a fully automated, parallel CI/CD pipeline and an optimized, secure Docker container deployment.

## Architecture & Workflow

The infrastructure is defined entirely as code (IaC) and automated via GitHub Actions.

1. **Continuous Integration (CI):** On every push to the `main` branch, a cloud runner initializes the Node.js environment, installs dependencies, and executes the backend test suite.
2. **Shift-Left Security (DevSecOps):** Running in parallel with the test suite, Aqua Trivy scans the filesystem and `Dockerfile` for high and critical vulnerabilities, misconfigurations, and hardcoded secrets. 
3. **Quality Gates:** The pipeline enforces strict dependency rules (`needs: [test, security]`). If either the tests fail or a vulnerability is detected, the deployment is immediately blocked.
4. **Continuous Delivery (CD):** Upon passing all quality and security gates, the pipeline builds the Docker image, tags it, and securely publishes it to the GitHub Container Registry (GHCR) as an immutable artifact ready for cloud deployment.

## Key Engineering Practices Implemented

### 1. Container Optimization & Security
*   **Minimal Base Image:** Utilizes `node:20-alpine` to drastically reduce the container attack surface and minimize image weight (reducing CI pipeline build times).
*   **Layer Caching:** Optimizes the `Dockerfile` by copying `package.json` and running `npm install` prior to copying the application logic, allowing Docker to cache the heavy dependency layer unless explicitly modified.
*   **Privilege Drop (Remediation):** Remediates standard Docker container escape vulnerabilities by explicitly dropping root privileges and running the application under the restricted `node` user profile.

### 2. Automated Pipeline Efficiency
*   **Parallel Execution:** Configured GitHub Actions to run the CI testing job and the DevSecOps scanning job simultaneously, optimizing runner usage and reducing feedback loop time for developers.
*   **Zero-Touch Deployment:** Automates authentication and artifact publishing to GHCR using temporary GitHub tokens (`${{ secrets.GITHUB_TOKEN }}`), removing the need for manual credential management.

## Technology Stack

*   **Backend:** Node.js, Express
*   **Containerization:** Docker
*   **CI/CD Automation:** GitHub Actions
*   **Security Scanning:** Aqua Trivy
*   **Artifact Registry:** GitHub Container Registry (GHCR)

## Running the API

This containerized API is completely portable and can be executed on any machine running the Docker daemon, independent of the host operating system.

**1. Pull and run the container in the background:**
```bash
docker run -d -p 3000:3000 ghcr.io/<YOUR_GITHUB_USERNAME>/node-docker-pipeline/node-api:latest
