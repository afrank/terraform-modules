provider "helm" {
  version = "~> 1"

  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}

data "helm_repository" "eks" {
  name = "eks"
  url  = "https://aws.github.io/eks-charts"
}

data "helm_repository" "fluxcd" {
  count = var.enable_flux ? 1 : 0
  name  = "fluxcd"
  url   = "https://charts.fluxcd.io"
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

data "helm_repository" "vmware_tanzu" {
  count = var.enable_velero ? 1 : 0
  name  = "vmware-tanzu"
  url   = "https://vmware-tanzu.github.io/helm-charts"
}

resource "helm_release" "node_drain" {
  name       = "aws-node-termination-handler"
  repository = data.helm_repository.eks.metadata.0.name
  chart      = "eks/aws-node-termination-handler"
  namespace  = "kube-system"

  depends_on = [module.eks]
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/metrics-server"
  namespace  = "kube-system"

  depends_on = [module.eks]
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/cluster-autoscaler"
  namespace  = "kube-system"

  dynamic "set" {
    iterator = item
    for_each = local.cluster_autoscaler_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.eks]
}

resource "helm_release" "reloader" {
  name       = "reloader"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/reloader"
  namespace  = "kube-system"

  dynamic "set" {
    iterator = item
    for_each = local.reloader_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.eks]
}

resource "helm_release" "flux_helm_operator" {
  count      = var.enable_flux ? 1 : 0
  name       = "helm-operator"
  repository = data.helm_repository.fluxcd.0.name
  chart      = "fluxcd/helm-operator"
  namespace  = "fluxcd"

  dynamic "set" {
    iterator = item
    for_each = local.flux_helm_operator_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.eks]
}

resource "helm_release" "fluxcd" {
  count      = var.enable_flux ? 1 : 0
  name       = "flux"
  repository = data.helm_repository.fluxcd.0.name
  chart      = "fluxcd/flux"
  namespace  = "fluxcd"

  dynamic "set" {
    iterator = item
    for_each = local.flux_settings

    content {
      name  = item.key
      value = item.value
    }
  }

}

resource "helm_release" "velero" {
  count      = var.enable_velero ? 1 : 0
  name       = "velero"
  repository = data.helm_repository.vmware_tanzu.0.name
  chart      = "vmware-tanzu/velero"
  namespace  = "velero"

  dynamic "set" {
    iterator = item
    for_each = local.velero_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.eks]
}