# --------------------------------------
# provider設定
# --------------------------------------

terraform {
  backend "gcs" {
    # Stateファイルを保存するGCSバケット名をここに固定する
    bucket = "test-bucket-202509121525" 
    prefix = "test/terraform.tfstate"
  }
  required_version = "= 1.8.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 6.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "< 6.0.0"
    }
  }
}

locals {
  project = "ca-nakano-jb-build-test"
  region  = "asia-northeast1"
  bucket  = "test-bucket-202509121630"
}

provider "google" {
  project = local.project
  region  = local.region
}

# 180秒間待機するだけのシンプルなリソース
resource "time_sleep" "wait_for_3_minutes" {
  # `terraform apply` を実行した際に、この期間だけ待機します。
  create_duration = "190s"
}

# # --------------------------------------
# # Cloud Storage
# # --------------------------------------

# # バケット作成
# resource "google_storage_bucket" "default" {
#   name     = local.bucket
#   location = local.region
# }

# # バックエンドサービスのステータス変更待機
# resource "time_sleep" "test" {
#   depends_on      = [google_storage_bucket.default]
#   create_duration = "180s"
# }

# # サンプルコンテンツのアップロード
# resource "google_storage_bucket_object" "image_txt" {
#   name   = "image/test.txt"
#   bucket = google_storage_bucket.default.name
#   source = "./image/test.txt"
# }

# resource "google_storage_bucket_object" "image_png" {
#   name   = "image/kitten.png"
#   bucket = google_storage_bucket.default.name
#   source = "./image/kitten.png"
# }