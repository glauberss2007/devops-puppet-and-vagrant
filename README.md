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
