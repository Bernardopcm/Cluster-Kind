terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
  }
}

provider "null" {}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Recurso para criar o cluster KinD
resource "null_resource" "create_kind_cluster" {
  provisioner "local-exec" {
    command = "kind create cluster --name=my-cluster"
  }
}

resource "null_resource" "wait_for_cluster" {
  depends_on = [null_resource.create_kind_cluster]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "null_resource" "get_cluster_credentials" {
  depends_on = [null_resource.wait_for_cluster]

  provisioner "local-exec" {
    command = "kind get kubeconfig --name=my-cluster > kubeconfig.yaml"
  }
}

resource "null_resource" "add_helm_repo" {
  depends_on = [null_resource.get_cluster_credentials]

  provisioner "local-exec" {
    command = "helm repo add my-helm-repo https://charts.helm.sh/stable"
  }
}