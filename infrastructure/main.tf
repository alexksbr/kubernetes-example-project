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

resource "helm_release" "metrics-server" {
  name = "metrics-server"
  namespace = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart = "metrics-server"
  version = "6.2.2"

  set {
    name = "extraArgs"
    value = "{--kubelet-insecure-tls}"
  }

  set {
    name = "apiService.create"
    value = true
  }
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

resource "kubernetes_service" "demo" {
  metadata {
    name = "demo"
  }

  spec {
    selector = {
      App = kubernetes_deployment.demo-service.spec.0.template.0.metadata[0].labels.App
    }

    port {
      node_port   = 30201
      port        = 4000
      target_port = 4000
    }

    type = "NodePort"
  }
}