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
  bucket  = "test-bucket-202509121600"
}

provider "google" {
  project = local.project
  region  = local.region
}

# --------------------------------------
# Cloud Storage
# --------------------------------------

# バケット作成
resource "google_storage_bucket" "default" {
  name     = local.bucket
  location = local.region
}

# バックエンドサービスのステータス変更待機
resource "time_sleep" "test" {
  depends_on      = [google_storage_bucket.default]
  create_duration = "300s" # 待機する (環境や負荷に応じて調整が必要)
}