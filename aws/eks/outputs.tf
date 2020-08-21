output "cluster_id" {
  value = module.eks.cluster_id
  depends_on = [module.eks]
}

output "cluster_version" {
  value = module.eks.cluster_version
  depends_on = [module.eks]
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
  depends_on = [module.eks]
}

output "cluster_arn" {
  value = module.eks.cluster_arn
  depends_on = [module.eks]
}

output "cluster_primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
  depends_on = [module.eks]
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
  depends_on = [module.eks]
}

output "worker_asg_names" {
  value = module.eks.workers_asg_names
  depends_on = [module.eks]
}

output "worker_iam_role_arn" {
  value = module.eks.worker_iam_role_arn
  depends_on = [module.eks]
}

output "worker_security_group_id" {
  value = module.eks.worker_security_group_id
  depends_on = [module.eks]
}

output "cluster_iam_role_name" {
  value = module.eks.cluster_iam_role_name
  depends_on = [module.eks]
}

output "cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
  depends_on = [module.eks]
}

output "node_groups" {
  value = module.eks.node_groups
  depends_on = [module.eks]
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
  depends_on = [module.eks]
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
  depends_on = [module.eks]
}

output "kubeconfig" {
  value = module.eks.kubeconfig
  depends_on = [module.eks]
}
