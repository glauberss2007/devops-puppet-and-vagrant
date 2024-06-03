#!/bin/bash

# Update the package list
apt-get update 

# Install Puppet and the Apache module from Puppet Labs
apt-get -y install puppet && puppet module install puppetlabs-apache

# Print a message indicating that Puppet has been installed
echo "Puppet installed!"
