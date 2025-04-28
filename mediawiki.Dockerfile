FROM mediawiki:1.43
ARG PLUGGABLEAUTH_VERSION=7.5.0
ARG OPENIDCONNECT_VERSION=8.3.0

RUN curl -sSL -o - "https://github.com/composer/getcomposer.org/raw/refs/heads/main/web/installer" | php -- --2.2 --install-dir=/usr/local/bin/ --filename=composer

RUN git clone --depth 1 --branch REL1_43 "https://github.com/wikimedia/mediawiki-extensions-MobileFrontend.git" /var/www/html/extensions/MobileFrontend
RUN git clone --depth 1 --branch REL1_43 "https://github.com/wikimedia/mediawiki-extensions-UniversalLanguageSelector.git" /var/www/html/extensions/UniversalLanguageSelector
RUN git clone --depth 1 --branch REL1_43 --recurse-submodules "https://github.com/NetherRealmSpigot/mediawiki-extensions-Wikibase.git" /var/www/html/extensions/Wikibase
RUN git clone --depth 1 "https://github.com/edwardspec/mediawiki-aws-s3.git" /var/www/html/extensions/AWS
RUN git clone --depth 1 --branch $PLUGGABLEAUTH_VERSION "https://github.com/wikimedia/mediawiki-extensions-PluggableAuth.git" /var/www/html/extensions/PluggableAuth
RUN git clone --depth 1 --branch $OPENIDCONNECT_VERSION "https://github.com/wikimedia/mediawiki-extensions-OpenIDConnect.git" /var/www/html/extensions/OpenIDConnect

RUN <<EOS

cat << EOF > /var/www/html/composer.local.json
{
	"extra": {
		"merge-plugin": {
			"include": [
				"extensions/OpenIDConnect/composer.json",
                "extensions/Wikibase/composer.json",
				"extensions/AWS/composer.json"
			]
		}
	}
}
EOF

cd /var/www/html
composer update --no-dev
composer install --no-dev
composer clear-cache

EOS