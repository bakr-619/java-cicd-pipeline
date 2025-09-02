# Java CI/CD Pipeline

![GitHub Actions Build](https://img.shields.io/github/workflow/status/yourusername/java-cicd-app/Java%20CI/CD%20Pipeline?label=Build&style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/bakr619/myapp?label=Docker%20Pulls&style=flat-square)
![License](https://img.shields.io/github/license/yourusername/java-cicd-app?label=License&style=flat-square)
![Java Version](https://img.shields.io/badge/Java-11-blue?style=flat-square)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.7.18-green?style=flat-square)

A robust Java application with a fully automated CI/CD pipeline using GitHub Actions, Maven, Docker, Trivy, and Discord notifications. The project demonstrates a Spring Boot REST API with unit tests, Dockerized deployment, and automated workflows for feature branches, pull requests, staging, and production environments.

## Table of Contents
- [Features](#features)
- [Technologies](#technologies)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Running the Application](#running-the-application)
- [CI/CD Pipeline](#cicd-pipeline)
- [Testing](#testing)
- [Security Scanning](#security-scanning)
- [Notifications](#notifications)
- [Contributing](#contributing)
- [License](#license)

## Features
- **RESTful API**: A Spring Boot application with a `/health` endpoint for monitoring.
- **Automated CI/CD**:
  - Builds and tests on feature branch pushes and pull requests.
  - Deploys to staging and production environments with Docker.
  - Rolls back to a stable image on deployment failure.
- **Testing**: Unit and integration tests using JUnit and Spring Boot Test.
- **Security**: Docker image scanning with Trivy for vulnerabilities.
- **Notifications**: Success and failure notifications via Discord webhooks.
- **Code Quality**: Optional SonarQube integration for static code analysis.
- **Containerization**: Dockerized app for consistent deployments.

## Technologies
- **Java 11**: Core programming language (Temurin distribution).
- **Spring Boot 2.7.18**: Framework for building the REST API.
- **Maven**: Build and dependency management.
- **Docker**: Containerization for deployment.
- **GitHub Actions**: CI/CD pipeline automation.
- **Trivy**: Security scanning for Docker images.
- **SonarQube** (optional): Code quality and security analysis.
- **Discord**: Webhook-based deployment notifications.

## Prerequisites
- **Java 11**: Install via `brew install --cask temurin@11` (macOS) or equivalent.
- **Maven**: Install via `brew install maven`.
- **Docker**: Install Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop).
- **Git**: Install via `brew install git`.
- **DockerHub Account**: For pushing Docker images (e.g., `bakr619/myapp`).
- **Discord Webhook**: For CI/CD notifications.
- **GitHub Repository**: With secrets configured (`DOCKER_USERNAME`, `DOCKER_PASSWORD`, `DISCORD_WEBHOOK`).

## Setup
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/java-cicd-app.git
   cd java-cicd-app
   ```

2. **Install Dependencies**:
   ```bash
   mvn clean install
   ```

3. **Configure GitHub Secrets**:
   - Go to your GitHub repo > **Settings > Secrets and variables > Actions**.
   - Add:
     - `DOCKER_USERNAME`: Your DockerHub username (e.g., `bakr619`).
     - `DOCKER_PASSWORD`: DockerHub access token (from hub.docker.com > Account Settings > Security).
     - `DISCORD_WEBHOOK`: Discord webhook URL (from Discord > Channel > Integrations > Create Webhook).

4. **Create DockerHub Repository**:
   - Log in to [hub.docker.com](https://hub.docker.com).
   - Create a repository named `myapp` (e.g., `bakr619/myapp`).

## Running the Application
1. **Build the JAR**:
   ```bash
   mvn clean package
   ```

2. **Run Locally**:
   ```bash
   java -jar target/myapp-0.0.1-SNAPSHOT.jar
   ```
   - Access the health endpoint: `curl http://localhost:8080/health` (returns `OK`).

3. **Run with Docker**:
   ```bash
   docker build -t bakr619/myapp:latest .
   docker run -d -p 8080:8080 bakr619/myapp:latest
   ```
   - Test: `curl http://localhost:8080/health`.

## CI/CD Pipeline
The pipeline (`/.github/workflows/ci-cd.yml`) automates the following:

### Feature Branches and Pull Requests
- **Trigger**: Push to `feature/*` branches or PRs to `main`.
- **Actions**:
  - Builds the Java app with Maven (`mvn clean package`).
  - Runs unit tests (`mvn test`).
  - Builds a Docker image tagged with the commit SHA.

### Staging Environment
- **Trigger**: Push to `staging` branch.
- **Actions**:
  - Runs unit tests.
  - Builds and scans Docker image (`bakr619/myapp:staging`) with Trivy.
  - Pushes image to DockerHub.
  - Deploys to a simulated staging environment.
  - Runs smoke tests (`/health` endpoint).
  - Sends Discord notifications on success or failure.
  - Rolls back to `bakr619/myapp:stable` if deployment fails, with smoke tests and notifications.
  - Updates `stable` tag on success.

### Production Environment
- **Trigger**: Push to `main` branch (after `staging` succeeds).
- **Actions**: Similar to staging, but uses `bakr619/myapp:prod` tag.

## Testing
- **Unit Tests**:
  - Located in `src/test/java/com/example/AppTest.java`.
  - Run: `mvn test`.
- **Integration Tests** (optional):
  - Located in `src/test/java/com/example/AppIntegrationTest.java`.
  - Run: `mvn verify`.
- **Smoke Tests**:
  - CI/CD pipeline checks the `/health` endpoint post-deployment.

## Security Scanning
- **Trivy**: Scans Docker images for critical/high vulnerabilities in `staging` and `production` jobs.
- **SonarQube** (optional): Add to workflow for code quality analysis:
  ```yaml
  - name: SonarQube Scan
    uses: sonarsource/sonarqube-scan-action@master
    env:
      SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    with:
      args: >
        -Dsonar.projectKey=myapp
        -Dsonar.organization=your-org
        -Dsonar.host.url=https://sonarcloud.io
  ```

## Notifications
- **Discord Webhooks**: Configured in GitHub Secrets (`DISCORD_WEBHOOK`).
- Sends messages for:
  - Successful deployments.
  - Failed deployments with rollback details.

## Contributing
1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/my-new-feature`.
3. Commit changes: `git commit -m "Add new feature"`.
4. Push: `git push origin feature/my-new-feature`.
5. Open a pull request to `main`.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.