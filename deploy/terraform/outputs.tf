output "gcp_project" {
  value = var.gcp_project
}

output "gcp_region" {
  value = var.gcp_region
}

output "vector_domain" {
  value = var.vector_domain
}

output "vector_version" {
  value = var.vector_version
}

output "vector_service_id" {
  value = google_cloud_run_service.vector.id
}

output "vector_service_status" {
  value = google_cloud_run_service.vector.status
}

