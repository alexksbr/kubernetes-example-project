resource "helm_release" "message_mongodb" {
  repository = "https://charts.helm.sh/stable/"
  chart  = "mongodb"
  name = "message-mongodb"
  version = "7.8.10"
}

resource "kubernetes_deployment" "message_service" {
  metadata {
    name = "message-service"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "message-service"
      }
    }

    template {
      metadata {
        labels = {
          App = "message-service"
        }
      }

      spec {
        container {
          image = "localhost:5001/message-service:latest"
          name  = "message-service"

          resources {
            limits = {
              cpu = "500m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "message" {
  metadata {
    name = "message"
  }

  spec {
    selector = {
      App = kubernetes_deployment.message_service.spec.0.template.0.metadata[0].labels.App
    }

    port {
      node_port   = 30201
      port        = 4000
      target_port = 4000
    }

    type = "NodePort"
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "message-autoscaler" {
  metadata {
    name = "message-autoscaler"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = "message-service"
    }

    min_replicas = 1
    max_replicas = 16

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}