# Docker PHP7 for Wordpress

Example of Docker image based on official [php-fpm] for running [Wordpress] on PHP7. This image does *not* include [Wordpress] itself.

Libs in Alpine variant (~100 MB):

* mysqli
* phpredis
* opcache
* mcrypt
* zip
* gd
* iconv

Libs in full variant (~800 MB):

* mysqli
* imagick
* phpredis
* xfonts
* opcache
* mcrypt
* zip
* gd
* iconv

[php-fpm]: https://hub.docker.com/_/php/
[Wordpress]: https://wordpress.org/
