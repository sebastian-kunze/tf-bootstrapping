variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "tags" {
  default     = {}
  description = "The list of tags to associate with all resources."
  type        = map
}
