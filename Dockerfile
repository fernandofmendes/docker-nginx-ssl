FROM        debian
MAINTAINER  Fernando Mendes "fernando.mendes@webca.com.br"

# Update the package repository
RUN apt-get update;

# Configure timezone and locale
RUN apt-get install -y wget curl locales

RUN echo "America/Sao_Paulo" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata
RUN export LANGUAGE=en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	export LC_ALL=en_US.UTF-8 && \
	locale-gen en_US.UTF-8 && \
	DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install Nginx + PHP
RUN apt-get install -y nginx php5-fpm php5-cli php5 php5-mcrypt php5-curl php5-mysql php5-gd php-pear php-net-smtp php-net-socket php-mdb2-driver-mysql php-mdb2 php-mail-mimedecode php-mail-mime

# Configure PHP TimeZone
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Sao_Paulo/g' /etc/php5/cli/php.ini
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Sao_Paulo/g' /etc/php5/fpm/php.ini

# Configure PHP Error log
RUN sed -i 's/\;error_log\ \=\ php_errors\.log/error_log\ \=\ \/var\/www\/html\/logs\/php_errors\.log/g' /etc/php5/fpm/php.ini

# Configure Short Tag
RUN sed -i 's/short_open_tag\ \=\ Off/short_open_tag\ \=\ On/g' /etc/php5/fpm/php.ini

# Enable PHP IONCUBE
ADD ./ioncube_loader_lin_5.6.so /etc/php5/ioncube/ioncube_loader_lin_5.6.so
RUN echo 'zend_extension = /etc/php5/ioncube/ioncube_loader_lin_5.6.so' >> /etc/php5/fpm/php.ini
RUN echo 'zend_extension = /etc/php5/ioncube/ioncube_loader_lin_5.6.so' >> /etc/php5/cli/php.ini

# Add configuration files
RUN rm /etc/nginx/sites-enabled/default
ADD ./default /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Add phpinfo para debug
# ADD ./info.php /var/www/html/

EXPOSE 80
EXPOSE 443

ADD ./start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "start.sh"]