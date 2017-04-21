#!/bin/bash
/usr/sbin/php5-fpm --fpm-config /etc/php5/fpm/php-fpm.conf &> /dev/null
/usr/sbin/nginx -g 'daemon off;'