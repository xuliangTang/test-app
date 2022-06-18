#!/bin/sh
set -e

php artisan config:clear && php artisan config:cache && /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
