# Používá oficiální PHP image s Apachem jako základ pro webový server.
FROM php:8.2-apache

## Instalace systémových závislostí a PHP rozšíření
# Aktualizuje balíčky a instaluje potřebné systémové knihovny a nástroje (např. curl, git, unzip, zip) a vývojové knihovny pro PHP rozšíření.
# Po instalaci smaže cache balíčků pro menší image.
# Následně instaluje PHP rozšíření potřebná pro běh aplikace (např. pdo_mysql pro MySQL, mbstring pro práci s řetězci, gd pro práci s obrázky).
RUN apt-get update && apt-get install -y \
    curl \
    git \
    libonig-dev \
    libpng-dev \
    libxml2-dev \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instalace Composeru (PHP správce balíčků)
# Zkopíruje Composer z oficiálního Composer image do tohoto image. Tento způsob je doporučený, protože Composer image je vždy aktuální a bezpečný.
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Nastaví pracovní adresář v kontejneru na /var/www/html, což je výchozí root pro Apache.
WORKDIR /var/www/html

# Nejprve zkopíruje pouze composer.json, což umožňuje lepší využití cache při instalaci závislostí.
COPY composer.json ./

# Nainstaluje PHP závislosti definované v composer.json bez vývojových balíčků a optimalizuje autoloader.
# Nepoužívá composer.lock, aby se předešlo konfliktům při různých prostředích.
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress --prefer-dist

# Zkopíruje zbytek aplikace do image, kromě složek/souborů ignorovaných v .dockerignore (např. vendor).
COPY . .

# Nastaví vlastnictví a oprávnění pro Apache uživatele (www-data), aby mohl správně číst a zapisovat.
# Povolení modulu rewrite v Apache pro podporu přepisování URL (např. pro frameworky).
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && a2enmod rewrite

# Otevře port 80, aby byl webový server dostupný zvenčí kontejneru.
EXPOSE 80