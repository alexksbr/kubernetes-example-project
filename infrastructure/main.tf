terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
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

resource "kubernetes_deployment" "demo-service" {
  metadata {
    name = "demo-service"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "DemoService"
      }
    }

    template {
      metadata {
        labels = {
          App = "DemoService"
        }
      }

      spec {
        container {
          image = "localhost:5001/demo-service:latest"
          name  = "demo-service"
        }
      }
    }
  }
}