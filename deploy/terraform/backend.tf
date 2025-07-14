terraform {
  backend "gcs" {
    bucket = "vector-datadog-tfstate" # your existing bucket
    prefix = "vector/${var.system}-${var.env}"
  }
}
