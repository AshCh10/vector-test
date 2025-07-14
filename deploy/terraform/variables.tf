variable "gcp_project" {
  description = "GCloud Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCloud Region"
  type        = string
  default     = "europe-west3"
}

variable "system" {
  description = "The name of the Vector implementation. \n\nExample: vector"
  type        = string
  default     = "vector"
}

variable "env" {
  description = "The name of the Vector environment. \n\nExample: development/staging/production"
  type        = string
}

variable "vector_domain" {
  description = "The subdomain to map Vector to. \n\nExample: track.yourdomain.com"
  type        = string
}

variable "vector_version" {
  description = "The version of Vector to run."
  type        = string
  default     = "v0.18.5"
}

variable "vector_service_timeout_seconds" {
  description = "The service timeout in seconds"
  type        = number
  default     = 300 # Cloud Run default
}

variable "vector_service_container_concurrency" {
  description = "The service container concurrency"
  type        = number
  default     = 1000
}

variable "vector_service_cpu_limit" {
  description = "The service cpu limit"
  type        = string
  default     = "1" # Cloud Run default
}

variable "vector_service_memory_limit" {
  description = "The service memory limit"
  type        = string
  default     = "512Mi" # Cloud Run default
}

variable "vector_service_gomemlimit_pct" {
  description = "Percentage of the cloud run memory limit to specify in GOMEMLIMIT env variable."
  type        = number
  default     = 0.9
}

variable "vector_service_container_port" {
  description = "The service container port"
  type        = number
  default     = 8080
}

variable "image_tag" {
  description = "The tag of the Docker image to deploy"
  type        = string
}

variable "pubsub_topic_name" {
  description = "Pub/Sub topic name for Vector sink"
  type        = string
}