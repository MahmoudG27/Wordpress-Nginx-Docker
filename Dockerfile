FROM php:fpm

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        libzip-dev \
        zip \
        unzip \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd zip mysqli

# Download and extract WordPress

RUN curl -o wordpress.tar.gz -SL http://wordpress.org/latest.tar.gz && \
    tar -xzf wordpress.tar.gz --strip-components=1 && \
    rm wordpress.tar.gz && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html && \
    mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php && \
    sed -i "s/database_name_here/wp_db/g" /var/www/html/wp-config.php && \
    sed -i "s/username_here/wp_user/g" /var/www/html/wp-config.php && \
    sed -i "s/password_here/P@ssw0rd123@/g" /var/www/html/wp-config.php && \
    sed -i "s/localhost/mysql/g" /var/www/html/wp-config.php

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]