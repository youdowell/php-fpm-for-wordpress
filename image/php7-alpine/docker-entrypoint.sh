#!/bin/bash
#
# Docker entrypoint script.
#
# Setup default permissions on web root directory: 
# allow Wordpress full access to web root dir.
#

set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

if [ "$1" = 'php-fpm' -a "$(id -u)" = '0' ]; then
    target_dir=/var/www/html
	mkdir -p "${target_dir}"
    chown -R www-data:www-data "${target_dir}"
fi

exec "$@"
