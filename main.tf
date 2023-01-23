provider "hcp" {}

provider "aws" {
  # Configuration options
}

#Retrieves the TLS Certificate to allow TFC to be an OIDC provider
data "tls_certificate" "tfc_certificate" {
  url = "https://app.terraform.io"
}

#establishes TFC as an OIDC provider
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = "https://app.terraform.io"
  client_id_list  = ["aws.workload.identity"]
  thumbprint_list = ["${data.tls_certificate.tfc_certificate.certificates.0.sha1_fingerprint}"]
}

#creates a role for the OIDC TFC provider
resource "aws_iam_role" "role" {
  name = "test-role"

  #this policy only allows the OIDC provider to assume the role if the aud (audience) field of the JWT is aws.workload.identity
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.tfc_provider.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringLike": {
          "app.terraform.io:aud": "${one(aws_iam_openid_connect_provider.tfc_provider.client_id_list)}",
          "app.terraform.io:sub": "organization:carlos-demos:workspace:aws-wl-identity-demo:run_phase:*"
        }
      }
    }
  ]
}
EOF
}

#creates a policy
resource "aws_iam_policy" "policy" {
  name        = "allow-all-policy"
  description = "A test policy that allows everything"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

#attaches policy to the role
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
#***************************************************************


data "hcp_packer_iteration" "hashicat" {
  bucket_name = "hashicat-demo"
  channel     = "production"
}

data "hcp_packer_image" "hashicat_image" {
  bucket_name    = "hashicat-demo"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.hashicat.ulid
  region         = "us-east-1"
}

#creates hashicat module
#ami-02c932ab9e2245e47
#data.hcp_packer_image.hashicat_image.cloud_image_id
module "hashicat" {
  source  = "app.terraform.io/cesteban-demos/hashicat/aws"
  version = "1.9.1"
  instance_type = var.instance_type
  region = var.region
  instance_ami = "ami-02c932ab9e2245e47"

}