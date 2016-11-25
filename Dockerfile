FROM ubuntu:14.04.5
RUN sed -i "s/archive/cn.archive/g" /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y apache2 subversion libapache2-svn websvn \
    && sed -i "s/'UTF-8', 'ISO/'GBK', 'UTF-8', 'ISO/g" /usr/share/websvn/include/command.php \
	&& apt-get autoclean && apt-get clean && apt-get autoremove \
   	&& a2enmod auth_digest
ENV	SERVER_NAME=localhost \
	APACHE_RUN_USER=www-data \
	APACHE_RUN_GROUP=www-data \
	APACHE_PID_FILE=/var/run/apache2/apache2.pid \
	APACHE_RUN_DIR=/var/run/apache2 \
	APACHE_LOCK_DIR=/var/lock/apache2 \
	APACHE_LOG_DIR=/var/log/apache2 \
	APACHE_LOG_LEVEL=warn
COPY buildtime/apache2-foreground /usr/local/bin/
COPY buildtime/default.conf /etc/apache2/sites-available/000-default.conf
CMD ["apache2-foreground"]
