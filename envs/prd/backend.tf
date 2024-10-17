terraform {
  backend "s3" {
    bucket         = "ndeguchi-terraform03prd"
    key            = "tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "ndeguchi-terraform03prd"
  }
}
