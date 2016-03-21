#
# Docker entrypoint script.
#
# Setup default permissions on web root directory: 
# allow Wordpress full access to web root dir.
#

#!/bin/bash
set -e

target_dir=/var/www/html

mkdir -p "$target_dir"
chown -R www-data:www-data "$target_dir"

exec "$@"
