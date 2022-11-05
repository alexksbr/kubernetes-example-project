terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.15.0"
    }
    helm = {
      version = "2.7.1"
    }
  }
}

variable "host" {
  type = string
}

variable "client_certificate" {
  type = string
}

variable "client_key" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

provider "kubernetes" {
  host = var.host

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "messages" {
  source = "./modules/message"
}

resource "helm_release" "metrics-server" {
  name = "metrics-server"
  namespace = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart = "metrics-server"
  version = "6.2.2"

  set {
    name = "extraArgs"
    value = "{--kubelet-insecure-tls,--metric-resolution=15s}"
  }

  set {
    name = "apiService.create"
    value = true
  }
}