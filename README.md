# AWS Infrastructure to Terraform (AWS-2-TF)

## Requirements

1. AWS CLI
2. Terraform
3. Terraformer

### Install requirements

#### Download installation script

```bash
wget https://raw.githubusercontent.com/shaban00/aws-infrastructure-to-terraform/main/install.sh
```

#### Change file permission

```bash
chmod +x install.sh
```

#### Run installation script

```bash
sudo ./install.sh
```

#### Configure AWS CLI

```bash
aws configure
```

__AWS Access Key ID [None]__: paste access key
__AWS Secret Access Key [None]__: paste secrete key
__Default region name [None]__: enter region
__Default output format [None]__: enter format. Eg. __json__


#### AWS CLI help

```bash
aws --no-pager help
```

#### Terraformer AWS Help

```bash
terraformer import aws --help
```

#### Run terraformer

```bash
terraformer import aws --resources=iam
```

__NOTE__: More resources can be added. Eg: __--resources=iam,cognito-identity,ec2__

#### Import all resources

```bash
terraformer import aws --resources="*"
```

#### Result

After the script runs succesfully, it creates a `generated` directory in the current directory with all the results

---

#### Add PoC Ubuntu Docker

##### Pull Ubuntu image

```bash
docker pull ubuntu
```

##### Run ubuntu container

```bash
docker run -it ubuntu:latest /bin/bash
```

##### Create less privileged user

```bash
apt-get update
apt-get upgrade
apt-get install -y curl gnupg unzip nano sudo wget groff mandoc
useradd -m shaban
echo "shaban:password" | chpasswd
usermod -aG sudo shaban
su - shaban
```

Default password: __password__

##### Follow the initial steps above to download, install and run script