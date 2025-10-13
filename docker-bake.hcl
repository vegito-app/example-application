variable "VERSION" {
  description = "current git tag or commit version"
  default     = "local"
}
variable "VEGITO_EXAMPLE_APPLICATION_DIR" {
  default = "."
}
variable "INFRA_ENV" {
  description = "production, staging or dev"
  default     = "dev"
}

variable "VEGITO_EXAMPLE_PUBLIC_IMAGES_BASE" {
  default = "${VEGITO_PUBLIC_REPOSITORY}/vegito-example"
}

variable "VEGITO_EXAMPLE_PRIVATE_IMAGES_BASE" {
  default = "${VEGITO_PRIVATE_REPOSITORY}/vegito-example"
}
group "example-application" {
  targets = [
    "example-application-backend",
    "example-application-mobile",
  ]
}
group "example-application-ci" {
  targets = [
    "example-application-backend-ci",
    "example-application-mobile-ci",
  ]
}
