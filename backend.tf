terraform {
  backend "s3" {
    bucket         = "aaditya-tf-state-bucket"
    key            = "multi-region/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}
