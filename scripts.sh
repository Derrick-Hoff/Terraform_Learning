#!/bin/bash

# Update the package list
echo "Updating package list..."
sudo apt-get update -y

# Install dependencies
echo "Installing dependencies..."
sudo apt-get install -y curl git gh

# Install GitHub CLI
echo "Installing GitHub CLI..."
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo apt-get install apt-transport-https
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Update and install GitHub CLI
sudo apt-get update -y
sudo apt-get install gh -y

# Verify installation of GitHub CLI
echo "Verifying GitHub CLI installation..."
gh --version

# Install Git if not already installed
echo "Installing Git..."
sudo apt-get install git -y

# GitHub CLI authentication (this requires your GitHub credentials to be set up)
echo "Authenticating with GitHub..."
gh auth login --with-token <<< "{Token}"

# Clone your GitHub repository
echo "Cloning your GitHub repository..."
git clone https://github.com/Derrick-Hoff/Terraform_Learning.git /home/ubuntu/DerrickRepo

# Navigate to the repository directory
cd /home/ubuntu/DerrickRepo

# Optional: Run commands to set up your repo, e.g., install dependencies
# Example for Node.js repo:
# npm install

echo "GitHub repository cloned successfully."