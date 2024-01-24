# create s3 bucket
resource "aws_s3_bucket" "mys3" {

        bucket = var.bucketname

}

resource "aws_s3_bucket_ownership_controls" "mys3" {
  bucket = aws_s3_bucket.mys3.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "mys3" {
  bucket = aws_s3_bucket.mys3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "mys3" {
  depends_on = [
    aws_s3_bucket_ownership_controls.mys3,
    aws_s3_bucket_public_access_block.mys3,
  ]

  bucket = aws_s3_bucket.mys3.id
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "index" {
  bucket = var.bucketname
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error" {
  bucket = var.bucketname
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}


resource "aws_s3_bucket_website_configuration" "webiste" {

        bucket = aws_s3_bucket.mys3.id
        index_document{
                suffix = "index.html"
        }

        error_document{
                key = "error.html"
        }

        depends_on = [ aws_s3_bucket_acl.mys3 ]
}
