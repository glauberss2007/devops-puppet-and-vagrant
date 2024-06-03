# Update the package list
exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

# Install required packages: vim, OpenJDK 8, Tomcat 8, and MariaDB server
package { ["vim", "openjdk-8-jre", "tomcat8", "mariadb-server"]:
  ensure  => installed,
  require => Exec["apt-update"]
}

# Ensure the MariaDB service is running and enabled to start on boot
service { "mariadb":
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  require    => Package["mariadb-server"]
}

# Create the 'musicjungle' database in MariaDB
exec { "musicjungle":
  command => "mysqladmin -uroot create musicjungle",
  unless  => "mysql -u root musicjungle",
  path    => "/usr/bin",
  require => Service["mariadb"]
}

# Create a database user 'admin' with appropriate permissions on the 'musicjungle' database
exec { "user_mariadb":
  command => "/bin/echo \"CREATE USER 'admin'@'localhost';GRANT USAGE on *.* TO 'admin'@'localhost';GRANT ALL privileges ON musicjungle.* TO 'admin'@'localhost';FLUSH PRIVILEGES;\" |  /usr/bin/mysql -u root",
  require => Exec["musicjungle"]
}

# Ensure the Tomcat service is running and enabled to start on boot
service { "tomcat8":
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  require    => Package["tomcat8"]
}

# Deploy the 'vraptor-musicjungle.war' application to Tomcat
file { "/var/lib/tomcat8/webapps/vraptor-musicjungle.war":
  source  => "/vagrant/manifests/vraptor-musicjungle.war",
  owner   => "tomcat8",
  group   => "tomcat8",
  mode    => "0644",
  require => Package["tomcat8"],
  notify  => Service["tomcat8"]
}

# Set the production environment variable for Tomcat
file_line { "production":
  path    => "/etc/default/tomcat8",
  line    => "JAVA_OPTS=\"\$JAVA_OPTS -Dbr.com.caelum.vraptor.environment=production\"",
  require => Package["tomcat8"],
  notify  => Service["tomcat8"]
}
