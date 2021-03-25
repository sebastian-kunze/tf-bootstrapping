module "state" {
  source = "../modules/state"

  project_name = var.project_name
  tags         = {}
}
