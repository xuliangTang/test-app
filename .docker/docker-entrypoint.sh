#!/bin/sh
set -e

php artisan config:clear && php artisan config:cache
