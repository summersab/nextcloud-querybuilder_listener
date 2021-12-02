#!/bin/bash

cp -r /var/www/nextcloud/lib/composer \
      /var/www/nextcloud/apps/querybuilder_listener/

# autoload_classmap.php
file="/var/www/nextcloud/apps/querybuilder_listener/composer/composer/autoload_classmap.php"
sed -i "s%\$vendorDir = dirname(dirname(__FILE__));%\$vendorDir = dirname(dirname(__FILE__)) . '/../../../..';%g" "$file"
#sed -i "s%\$baseDir = dirname(dirname(\$vendorDir));%\$baseDir = dirname(dirname(\$vendorDir)) . '/../../../..';%g" "$file"
sed -i "s%'OC\\\\\\\\DB\\\\\\\\QueryBuilder\\\\\\\\QueryBuilder'.*%'OC\\\\\\\\DB\\\\\\\\QueryBuilder\\\\\\\\QueryBuilder' => \$baseDir . '/apps/querybuilder_listener/lib/private/DB/QueryBuilder/QueryBuilder.php',%g" "$file"

# autoload_static.php
file="/var/www/nextcloud/apps/querybuilder_listener/composer/composer/autoload_static.php"
sed -i "s%0 => __DIR__ . '/../../..'%0 => __DIR__ . '/../../../..'%g" "$file"
sed -i "s%' => __DIR__ . '/..%' => __DIR__ . '/../../../../lib/composer/composer' . '/..%g" "$file"
sed -i "s%'OC\\\\\\\\DB\\\\\\\\QueryBuilder\\\\\\\\QueryBuilder'.*%'OC\\\\\\\\DB\\\\\\\\QueryBuilder\\\\\\\\QueryBuilder' => __DIR__ . '/../../../..' . '/apps/querybuilder_listener/lib/private/DB/QueryBuilder/QueryBuilder.php',%g" "$file"
find /var/www/nextcloud/apps/querybuilder_listener/composer/composer/ -type f | xargs sed -i 's%ComposerStaticInit[a-f0-9]\+%ComposerStaticInitQueryBuilderListener%g'
find /var/www/nextcloud/apps/querybuilder_listener/composer/composer/ -type f | xargs sed -i 's%ComposerAutoloaderInit[a-f0-9]\+%ComposerAutoloaderInitQueryBuilderListener%g'

# QueryBuilder.php
file="/var/www/nextcloud/apps/querybuilder_listener/lib/private/DB/QueryBuilder/QueryBuilder.php"
cp /var/www/nextcloud/lib/private/DB/QueryBuilder/QueryBuilder.php \
   "$file"

patch "$file" /var/www/nextcloud/apps/querybuilder_listener/lib/private/DB/QueryBuilder/QueryBuilder.patch
mv /var/www/nextcloud/apps/querybuilder_listener/autoload.config.php /var/www/nextcloud/config/autoload.config.php
rm /var/www/nextcloud/apps/querybuilder_listener/install.sh
rm /var/www/nextcloud/apps/querybuilder_listener/lib/private/DB/QueryBuilder/QueryBuilder.patch