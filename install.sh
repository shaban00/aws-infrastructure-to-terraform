#!/bin/bash

# Function to install AWS CLI on Linux
install_aws_cli_linux() {
  if command -v aws &>/dev/null; then
    echo "AWS CLI is already installed."
  else
    # Download the AWS CLI v2 zip file
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

    # Unzip the AWS CLI installation files
    unzip -u awscliv2.zip

    # Install the AWS CLI v2 to /usr/local/aws-cli and add it to the /usr/local/bin directory
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin

    # Check the version of the AWS CLI
    aws --version

    # Clean up downloaded files
    rm -rf awscliv2.zip aws/
  fi
}

# Function to install AWS CLI on macOS
install_aws_cli_macos() {
  if command -v aws &>/dev/null; then
    echo "AWS CLI is already installed."
  else
    # Download the AWS CLI v2 pkg file for macOS
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"

    # Install the AWS CLI v2 using the pkg installer
    sudo installer -pkg AWSCLIV2.pkg -target /

    # Check the version of the AWS CLI
    aws --version

    # Clean up downloaded files
    rm -f AWSCLIV2.pkg
  fi
}

# Function to install Terraform on Linux
install_terraform_linux() {
  if command -v terraform &>/dev/null; then
    echo "Terraform is already installed."
  else
    # Install prerequisites
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

    # Download and add HashiCorp GPG key
    wget -O- https://apt.releases.hashicorp.com/gpg | \
      gpg --dearmor | \
      sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

    # Verify the key
    gpg --no-default-keyring \
      --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
      --fingerprint

    # Add the HashiCorp repository to the sources list
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
      sudo tee /etc/apt/sources.list.d/hashicorp.list

    # Update the apt package list
    sudo apt update

    # Install Terraform
    sudo apt-get install -y terraform

    # Check the version of Terraform
    terraform --version
  fi
}

# Function to install Terraform on macOS
install_terraform_macos() {
  if command -v terraform &>/dev/null; then
    echo "Terraform is already installed."
  else
    # Use Homebrew to install Terraform on macOS
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform

    # Check the version of Terraform
    terraform --version
  fi
}

# Function to install Terraformer on Linux
install_terraformer_linux() {
  if command -v terraformer &>/dev/null; then
    echo "Terraformer is already installed."
  else
    export PROVIDER=all
    curl -LO "https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64"
    chmod +x terraformer-${PROVIDER}-linux-amd64
    sudo mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer

    # Check the version of Terraformer
    terraformer --version
  fi
}

# Function to install Terraformer on macOS
install_terraformer_macos() {
  if command -v terraformer &>/dev/null; then
    echo "Terraformer is already installed."
  else
    export PROVIDER=all
    curl -LO "https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-darwin-amd64"
    chmod +x terraformer-${PROVIDER}-darwin-amd64
    sudo mv terraformer-${PROVIDER}-darwin-amd64 /usr/local/bin/terraformer

    # Check the version of Terraformer
    terraformer --version
  fi
}

# Function to create the versions.tf file
create_versions_tf() {
  echo "Creating versions.tf file..."
  cat <<EOL > versions.tf
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.13"
}
EOL
}

# Function to initialize Terraform
initialize_terraform() {
  echo "Running terraform init..."
  terraform init
}

# Check if the system is macOS or Linux
if [[ "$(uname)" == "Darwin" ]]; then
  echo "Detected macOS. Installing AWS CLI, Terraform, and Terraformer for macOS..."
  install_aws_cli_macos
  install_terraform_macos
  install_terraformer_macos
  create_versions_tf
  initialize_terraform
else
  echo "Detected Linux. Installing AWS CLI, Terraform, and Terraformer for Linux..."
  install_aws_cli_linux
  install_terraform_linux
  install_terraformer_linux
  create_versions_tf
  initialize_terraform
fi
