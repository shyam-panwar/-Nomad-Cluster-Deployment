<<<<<<< HEAD
# Set up a Nomad cluster on the major cloud platforms

This repo is a companion to the [Cluster Setup](https://developer.hashicorp.com/nomad/tutorials/cluster-setup) collection of tutorials, containing configuration files to create a Nomad cluster with ACLs enabled on GCP.


# Nomad GCP Cluster Deployment

## Overview
This repository contains all necessary scripts, Terraform code, and Nomad job files to deploy a **secure, scalable HashiCorp Nomad cluster on GCP**. It includes:

- **Nomad Server(s)**: Manage cluster state and API/UI
- **Nomad Client(s)**: Run containerized workloads
- **Sample jobs**: 
  - hello-world HTTP echo
  - nginx web server

---

## Architecture & Design Choices

- **Server/Client Separation**: Servers handle orchestration; clients run tasks.
- **Docker Driver**: Chosen for containerized workload simplicity.
- **Network & Ports**: Specific ports defined per task in Nomad HCL (`http:5678` for hello-world, `http:8080` for nginx).
- **Security**:
  - Nomad ACLs enabled
  - Firewall rules restricting traffic to necessary ports
  - Only trusted Docker images
- **Observability**: 
  - Nomad telemetry enabled
  - Logs available via `nomad alloc logs`
  - Optional: Prometheus/Grafana for metrics

---

## Prerequisites

- GCP account with Compute Engine access
- Terraform >= 1.6.0
- Nomad CLI installed locally
- Docker installed on VMs

---

## Deployment Steps

### 1. Provision Infrastructure

```bash
cd gcp
terraform init
terraform apply -var-file="variables.hcl"
nomad_ui = 35.193.143.48:4646  # add Port[4646] at last
Secret_id = 96f7ba53-8982-51f3-1133-5c3318bafac2
=======
# -Nomad-Cluster-Deployment
>>>>>>> 1cda924410523e327f9e7f3e630273a94689d59b
