terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}


provider "aws" {
  # configuration options
  region = var.region
}

resource "aws_s3_bucket" "demo-bucket" {
  bucket = "static-hosting-tf-bucket"
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.demo-bucket.bucket
  source = "./index.html"
  key    = "index.html"
}

resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.demo-bucket.bucket
  source = "./styles.css"
  key    = "styles.css"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.demo-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "mywebapp" {
  bucket = aws_s3_bucket.demo-bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid = "PublicReadGetObject",
          Effect = "Allow",
          Principal = "*",
          Action = [
            "s3:GetObject"
          ],
          Resource = [
            "arn:aws:s3:::${aws_s3_bucket.demo-bucket.id}/*"
          ]
        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "mywebapp" {
  bucket = aws_s3_bucket.demo-bucket.id

  index_document {
    suffix = "index.html"
  }
}
