terraform {
  required_version = ">= 0.12"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 2"
    }
  }
}

provider "google" {
  project = "nomad-cluster-project"
  region  = "us-central1"
  zone    = "us-central1-c"
}