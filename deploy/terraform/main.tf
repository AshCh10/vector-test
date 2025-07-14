data "google_project" "project" {}


# Trigger plan workflow


resource "google_secret_manager_secret" "vector_config" {
  secret_id = local.config

  replication {
    user_managed {
      replicas {
        location = var.gcp_region
      }
    }
  }

}

/*
resource "google_secret_manager_secret_version" "vector_config" {
  secret = google_secret_manager_secret.vector_config.id
  secret_data = file("${path.module}/../../products/${var.system}/vector.yaml")
}
*/

resource "google_secret_manager_secret_version" "vector_config" {
  secret      = google_secret_manager_secret.vector_config.id
  secret_data = local.rendered_vector_config
}


/*
resource "google_artifact_registry_repository" "vector_repository" {
  location      = var.gcp_region
  repository_id = local.artifact_repository
  format        = "DOCKER"

}
*/


resource "google_project_iam_binding" "vector_config_secret_access" {
  project = var.gcp_project
  role    = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  ]

  depends_on = [
    google_secret_manager_secret_version.vector_config
  ]
}

resource "google_cloud_run_service" "vector" {
  name                       = local.service_name
  location                   = var.gcp_region
  autogenerate_revision_name = true

  template {
    spec {
      timeout_seconds       = var.vector_service_timeout_seconds
      container_concurrency = var.vector_service_container_concurrency

      volumes {
        name = local.config
        secret {
          secret_name = google_secret_manager_secret.vector_config.secret_id
          items {
            key  = "latest"
            path = "vector.yaml"
          }
        }
      }

      containers {
        image = local.vector_image

        resources {
          limits = {
            cpu    = var.vector_service_cpu_limit
            memory = var.vector_service_memory_limit
          }
        }

        ports {
          container_port = var.vector_service_container_port
        }

        env {
          name  = "GOMEMLIMIT"
          value = "512MiB"
        }

        volume_mounts {
          name       = local.config
          mount_path = local.vector_config_dir
        }
      }
    }
  }

#  depends_on = [
    #null_resource.tag_and_push_image,
#  ]
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.vector.location
  project  = google_cloud_run_service.vector.project
  service  = google_cloud_run_service.vector.name

  policy_data = data.google_iam_policy.noauth.policy_data
}


resource "google_pubsub_topic" "vector_topic" {
  name    = var.pubsub_topic_name
  project = var.gcp_project
}
