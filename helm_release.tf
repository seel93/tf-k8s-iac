resource "helm_release" "helm_db" {
  name       = "mysql-db"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mysql"
  version    = "9.16.2"
  namespace = "api"
  create_namespace = true
  values = [
    file("./helm/db_values.yaml")
  ]
}


resource "helm_release" "helm_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.9.0"
  namespace = "ingress"
  create_namespace = true
  values = [
    file("./helm/ingress_values.yaml")
  ]
}

resource "helm_release" "minio" {
  name       = "minio"
  repository = "https://helm.min.io/"
  chart      = "minio"
  version    = "8.0.10"  # Use the appropriate version
  namespace = "storage"
  create_namespace = true

  set {
    name  = "accessKey"
    value = "YOURACCESSKEY"
  }

  set {
    name  = "secretKey"
    value = "YOURSECRETKEY"
  }

  # Additional configuration can be added here
}
