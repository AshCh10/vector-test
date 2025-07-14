/*
locals {
  vector_config_var  = "VECTOR_CONFIG_PATH"
  vector_config_dir  = "/etc/vector/"
  vector_config_path = "${local.vector_config_dir}vector.yaml"
  activate_apis = [
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com"
  ]
  domain_parts                 = split(".", var.vector_domain)
  cookie_domain                = join(".", slice(local.domain_parts, 1, length(local.domain_parts))) # Assumes vector is running on a subdomain and the cookie should be on root
  system_env_base              = "${var.system}-${var.env}-"
  artifact_repository          = "${local.system_env_base}repository"
  artifact_registry_location   = "${var.gcp_region}-docker.pkg.dev"
  artifact_registry_root       = "${local.artifact_registry_location}/${var.gcp_project}"
  artifact_registry_repository = "${local.system_env_base}repository"
  vector_image                 = "${local.artifact_registry_root}/${local.artifact_registry_repository}/my-vector-local:latest"
  service_name                 = "${local.system_env_base}collector"
  config                       = "${local.system_env_base}config"
}
*/

locals {
  system_env_base              = "${var.system}-${var.env}-"
  artifact_repository          = "${var.system}-${var.env}-repository"
  artifact_registry_location   = "${var.gcp_region}-docker.pkg.dev"
  artifact_registry_root       = "${local.artifact_registry_location}/${var.gcp_project}"
  artifact_registry_repository = local.artifact_repository
  vector_image                 = "${local.artifact_registry_root}/${local.artifact_registry_repository}/my-vector-local:${var.image_tag}"
  service_name                 = "${local.system_env_base}collector"
  config                       = "${var.system}-${var.env}-config"

  # Config path for Vector
  vector_config_var  = "VECTOR_CONFIG_PATH"
  vector_config_dir  = "/etc/vector/"
  vector_config_path = "${local.vector_config_dir}vector.yaml"

  # Optional domain parsing
  domain_parts    = var.vector_domain != "" ? split(".", var.vector_domain) : []
  cookie_domain   = length(local.domain_parts) > 1 ? join(".", slice(local.domain_parts, 1, length(local.domain_parts))) : ""

  activate_apis = [
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

locals {
  rendered_vector_config = templatefile("${path.module}/../../products/${var.system}/vector.yaml.tmpl", {
    gcp_project        = var.gcp_project
    pubsub_topic_name = google_pubsub_topic.vector_topic.name
  })
}

