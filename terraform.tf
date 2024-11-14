terraform {
  cloud {
    organization = "terraform-cert-lab"

    workspaces {
      project = "DevOps Automation"
    }
  }
}
