# devops-puppet-and-vagrant
The given Vagrant and Puppet configuration sets up an architecture involving both local and AWS-based virtual machines (VMs) for deploying a web application.

## Vagrant Configuration

The Vagrant configuration defines two distinct environments:

### AWS Environment (`aws_web`)

- Uses AWS as the provider.
- Configures AWS credentials (`access_key_id` and `secret_access_key`), AMI (Amazon Machine Image), security groups, and SSH key pair.
- Utilizes a dummy box as a placeholder since AWS is used directly.
- Sets up a synced folder for file synchronization.
- Tags the AWS instance with the name "MusicJungle (vagrant)".
- Provisions the instance using a shell script (`manifests/bootstrap.sh`) and a Puppet manifest (`web.pp`).

### Local Environment (`web`)

- Uses VirtualBox as the provider.
- Deploys an Ubuntu 18.04 (`ubuntu/bionic64`) VM.
- Configures a private network with a static IP address (`192.168.50.10`).
- Provisions the instance using the same shell script and Puppet manifest as the AWS environment.

## Puppet Configuration (`web.pp`)

The Puppet manifest automates the installation and configuration of the necessary software for the web application:

### Update the package list

- Executes `apt-get update` to refresh the list of available packages.

### Install required packages

- Installs `vim`, `openjdk-8-jre`, `tomcat8`, and `mariadb-server`.

### Configure and manage MariaDB service

- Ensures the MariaDB service is running and enabled to start on boot.
- Creates a database named `musicjungle`.
- Creates a database user `admin` with appropriate permissions on the `musicjungle` database.

### Configure and manage Tomcat service

- Ensures the Tomcat service is running and enabled to start on boot.
- Deploys the `vraptor-musicjungle.war` application to Tomcat.
- Sets the production environment variable for Tomcat in its default configuration file.


## To deploy the environment using the Vagrant and Puppet configuration provided

### Local

Deploy the Local VirtualBox Environment (Execute it inside this repository  "local-deployment" folder):

```
vagrant up web
```

Verify the Deployment:
```
vagrant ssh web
```

Destroy the Local VirtualBox Environment:
```
vagrant destroy -f web
```

### AWS

Install the Vagrant AWS plugin:
```
vagrant plugin install vagrant-aws
```

Add the dummy box for AWS provider:
```
vagrant box add --force dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
```

Deploy the AWS environment (Execute it inside this repository "aws-cloud-deployment" folder):
```
vagrant up aws_web --provider=aws
```

To destroy the AWS environment when no longer needed:
```
vagrant destroy -f aws_web
```


## References

1. [Vagrant Documentation](https://www.vagrantup.com/docs)
2. [Vagrant AWS Plugin](https://github.com/hashicorp/vagrant-aws)
3. [VirtualBox](https://www.virtualbox.org/)
4. [Ubuntu Boxes for Vagrant](https://app.vagrantup.com/ubuntu)
5. [Puppet Documentation](https://puppet.com/docs/)
6. [Puppet Forge - puppetlabs-apache module](https://forge.puppet.com/puppetlabs/apache)
7. [Amazon EC2 AMIs](https://aws.amazon.com/marketplace/search/results/?searchTerms=ubuntu%2018.04)
8. [MySQL Documentation](https://dev.mysql.com/doc/)
9. [Tomcat Documentation](https://tomcat.apache.org/tomcat-8.5-doc/index.html)
10. [Vraptor Framework](https://www.vraptor.org/en/)
11. [Caelum - Vraptor Documentation](https://www.caelum.com.br/apostila-vraptor/)

