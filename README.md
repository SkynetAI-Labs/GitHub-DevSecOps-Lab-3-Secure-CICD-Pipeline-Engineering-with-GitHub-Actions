![Lab 03 — Secure CI/CD Pipeline Engineering](skynet-lab-03.png)

# GitHub DevSecOps Lab 03 — Secure CI/CD Pipeline Engineering with GitHub Actions

[![CI Pipeline](https://github.com/SkynetAI-Labs/lab-03-secure-cicd-pipeline/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/SkynetAI-Labs/lab-03-secure-cicd-pipeline/actions/workflows/ci.yml)

A hands-on DevSecOps project by **SkynetAI-Labs**, demonstrating automated testing, security scanning, protected pull requests, and controlled container delivery.

---

## Project Objective

Build a pipeline that checks application code and container dependencies before publishing a container image. Demonstrate both a blocked security check and successful recovery.

The application is deliberately small: a Python function returns a health status. The focus is pipeline engineering rather than application complexity.

## Pipeline Architecture

```mermaid
flowchart TD
    A[Push or pull request] --> B[Python unit tests]
    A --> C[Bandit code security scan]
    A --> D[Build and run container]
    D --> E[Trivy vulnerability scan]
    E --> F[On main: save scanned image]
    B --> G[Delivery gate]
    C --> G
    F --> G
    G --> H[On main push only: publish same image to GHCR]
```

Pull requests run the tests and security scans without publishing. On pushes to `main`, delivery waits for all three check jobs to succeed.

## Tools and Technologies

- **GitHub Actions** — CI and container delivery
- **Python 3.12 / unittest** — application and automated testing
- **Bandit** — Python security analysis
- **Docker** — container build and execution
- **Python Alpine** — container base image
- **Trivy** — container vulnerability scanning
- **GitHub Container Registry (GHCR)** — container image publishing
- **Ubuntu / WSL** — local development environment

## Security Controls

| Control | Implementation |
|---|---|
| Protected main branch | Pull requests and passing unit, code security, and container checks required |
| Administrator enforcement | Branch protection configured to prevent bypassing |
| Action version integrity | Direct workflow action references pinned to full commit SHAs |
| Limited permissions | Read-only repository access by default; package write access limited to delivery |
| Checkout credentials | Credential persistence disabled |
| Container execution | Application runs as an unprivileged user |
| Vulnerability policy | Trivy fails on HIGH or CRITICAL findings, including unfixed findings |
| Delivery gate | Publishing depends on successful tests, Bandit, and container scanning |
| Image continuity | Delivery loads and publishes the scanned image without rebuilding |
| Image identification | Published images tagged with the Git commit SHA |
| Authentication | GitHub supplies the workflow credential; no manually managed registry token |
| Artifact retention | Scanned image transfer artifact retained for one day |

## Validation Evidence

### 1. Unsafe Code Detection and Recovery

An isolated demonstration branch introduced an unsafe `eval()` call without executing it.

Bandit reported **B307**, with medium severity and high confidence, causing the security job to fail.

- [Expected security failure](https://github.com/SkynetAI-Labs/lab-03-secure-cicd-pipeline/actions/runs/39068127558)
- [Successful run after removing the unsafe example](https://github.com/SkynetAI-Labs/lab-03-secure-cicd-pipeline/actions/runs/39068386964)

The unsafe example was removed from the demonstration branch and was not merged into `main`.

### 2. Container Vulnerability Remediation

The initial Debian-based image scan reported **44 HIGH findings**.

Remediation included:

1. Replacing the Debian-based container image with Python Alpine.
2. Applying available Alpine package updates.
3. Retaining the existing vulnerability failure policy.
4. Rebuilding and rescanning the container.

The revised image passed the checks.

- [Container build and remediation pull request](https://github.com/SkynetAI-Labs/lab-03-secure-cicd-pipeline/pull/2)

### 3. Controlled Container Delivery

The main-branch workflow successfully completed:

- Python unit tests
- Bandit security analysis
- Docker build and execution
- Trivy vulnerability scanning
- Gated image publishing to GHCR

Evidence:

- [Successful delivery run](https://github.com/SkynetAI-Labs/lab-03-secure-cicd-pipeline/actions/runs/39071760350)
- [Delivery implementation](https://github.com/SkynetAI-Labs/lab-03-secure-cicd-pipeline/pull/3)
- [Action and runner maintenance](https://github.com/SkynetAI-Labs/lab-03-secure-cicd-pipeline/pull/4)

## Run the Tests Locally

From the repository root:

```bash
python3 -m unittest discover -s tests -v
```

## Build and Run Locally

These commands require a running Docker engine.

```bash
docker build --pull -t secure-cicd-demo:local .
docker run --rm secure-cicd-demo:local
```

The container prints its health status and exits. It does not run a web server.

## Published Container Image

```text
ghcr.io/skynetai-labs/secure-cicd-pipeline-github-actions:<full-commit-sha>
```

Replace the tag with the full `main` branch commit SHA from a successful delivery run.

Registry access depends on the package's visibility and permissions.

## Repository Structure

```text
lab-03-secure-cicd-pipeline/
├── .github/
│   └── workflows/
│       └── ci.yml
├── app/
│   └── health.py
├── tests/
│   └── test_health.py
├── Dockerfile
├── .dockerignore
├── .gitignore
├── skynet-lab-03.png
└── README.md
```

## Scope and Limitations

This lab demonstrates continuous integration and container delivery to a registry. It does **not** deploy an application to a live environment.

A passing vulnerability scan means no findings matched the configured failure policy at scan time. It does not guarantee that an image is free of vulnerabilities.

Lower-severity vulnerabilities do not fail the container job.

Action pins, scanner versions, base images, and vulnerability findings require ongoing maintenance. The base image uses a version tag rather than an immutable image digest.

## Skills Demonstrated

- Secure CI/CD pipeline engineering
- GitHub Actions workflow design
- Python automated testing
- Static application security testing
- Container vulnerability scanning
- Docker container hardening
- Vulnerability remediation
- GitHub branch protection
- Pull request security workflows
- Least-privilege permissions
- Gated container image delivery
- GHCR integration

---

**Organisation:** SkynetAI-Labs  
**Portfolio:** GitHub DevSecOps Labs  
**Project:** Lab 03 — Secure CI/CD Pipeline Engineering

Part of the [SkynetAI-Labs GitHub portfolio](https://github.com/SkynetAI-Labs).
