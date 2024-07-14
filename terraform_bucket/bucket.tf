// Create Service Account
resource "yandex_iam_service_account" "servacc-for-terraform" {
    name      = "servacc-for-terraform"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "terraform-editor" {
    folder_id = var.folder_id
    role      = "editor"
    member    = "serviceAccount:${yandex_iam_service_account.servacc-for-terraform.id}"
    depends_on = [yandex_iam_service_account.servacc-for-terraform]
}

resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
    folder_id = var.folder_id
    role      = "storage.editor"
    member    = "serviceAccount:${yandex_iam_service_account.servacc-for-terraform.id}"
    depends_on = [yandex_iam_service_account.servacc-for-terraform]
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "servacc-static-key" {
    service_account_id = yandex_iam_service_account.servacc-for-terraform.id
    description        = "static access key for bucket"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "tanker72-tfstate-bucket" {
  access_key = yandex_iam_service_account_static_access_key.servacc-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.servacc-static-key.secret_key
  bucket = "tanker72-tfstate-bucket"
  max_size   = 1048576
}

