resource "google_storage_bucket" "main" {
  name          = "ca-nakano-jb-tag-test-prd_static_website_bucket_test2"
  location      = "asia-northeast1"
  storage_class = "STANDARD"
  website {
    main_page_suffix = "index.html"
  }
}

# resource "google_storage_bucket" "test" {
#   name          = "ca-nakano-jb-tag-test-prd_bucket_actions_test"
#   location      = "asia-northeast1"
#   storage_class = "STANDARD"
# }

# 30秒間待つためのリソース
resource "time_sleep" "wait_for_300_seconds" {
  create_duration = "300s"
}

resource "google_storage_bucket_object" "main" {
  name         = "index.html"
  content      = "<html><body>Hello World!</body></html>"
  content_type = "text/html"
  bucket       = google_storage_bucket.main.id

  # time_sleepリソースが完了するまでこのリソースの作成を待つ
  depends_on = [
    time_sleep.wait_for_300_seconds
  ]
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=5.33.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.9.1"
    }
  }
  required_version = "1.8.5"
}

# # local 定義
# locals {
#     github_repository           = "nakano-ca/cloud-build-cicd-test"
#     project_id                  = "ca-nakano-jb-tag-test-prd"
#     region                      = "asia-northeast1"
#     terraform_service_account   = "terraform@ca-nakano-jb-tag-test-prd.iam.gserviceaccount.com"
    
#     # api 有効化用
#     services = toset([                         # Workload Identity 連携用
#         "iam.googleapis.com",                  # IAM
#         "cloudresourcemanager.googleapis.com", # Resource Manager
#         "iamcredentials.googleapis.com",       # Service Account Credentials
#         "sts.googleapis.com"                   # Security Token Service API
#     ])
# }
  
# # provider 設定
# terraform {
#     required_providers {
#         google  = {
#             source  = "hashicorp/google"
#             version = ">= 4.0.0"
#         }
#     }
#     required_version = ">= 1.3.0"
#     backend "gcs" {
#         bucket = "myproject_terraform_tfstate"
#         prefix = "terraform/state"
#     }
# }
  
# ## API の有効化(Workload Identity 用)
# resource "google_project_service" "enable_api" {
#   for_each                   = local.services
#   project                    = local.project_id
#   service                    = each.value
#   disable_dependent_services = true
# }
    
# # Workload Identity Pool 設定
# resource "google_iam_workload_identity_pool" "mypool" {
#     provider                  = google-beta
#     project                   = local.project_id
#     workload_identity_pool_id = "mypool"
#     display_name              = "mypool"
#     description               = "GitHub Actions で使用"
# }
  
# # Workload Identity Provider 設定
# resource "google_iam_workload_identity_pool_provider" "myprovider" {
#     provider                           = google-beta
#     project                            = local.project_id
#     workload_identity_pool_id          = google_iam_workload_identity_pool.mypool.workload_identity_pool_id
#     workload_identity_pool_provider_id = "myprovider"
#     display_name                       = "myprovider"
#     description                        = "GitHub Actions で使用"
    
#     attribute_mapping = {
#         "google.subject"       = "assertion.sub"
#         "attribute.repository" = "assertion.repository"
#     }
    
#     oidc {
#         issuer_uri = "https://token.actions.githubusercontent.com"
#     }
# }
  
# # GitHub Actions が借用するサービスアカウント
# data "google_service_account" "terraform_sa" {
#     account_id = local.terraform_service_account
# }
  
# # サービスアカウントの IAM Policy 設定と GitHub リポジトリの指定
# resource "google_service_account_iam_member" "terraform_sa" {
#     service_account_id = data.google_service_account.terraform_sa.id
#     role               = "roles/iam.workloadIdentityUser"
#     member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.mypool.name}/attribute.repository/${local.github_repository}"
# }