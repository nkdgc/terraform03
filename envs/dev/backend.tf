terraform {
  backend "s3" {
    bucket         = "ndeguchi-terraform03dev"
    key            = "tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "ndeguchi-terraform03dev"
  }
}
