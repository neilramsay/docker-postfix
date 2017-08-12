FROM neilramsay/syslog-stdout

# Get Postfix, ca-certificates and openssl (for TLS), and gettext (for config file updates)
RUN set -ex \
    && apk add --no-cache bash gettext openssl ca-certificates postfix \
    && chown root /var/spool/postfix \
    && chown root /var/spool/postfix/pid \
    && mkdir /docker-entry.d

COPY docker-entrypoint.sh docker-utils.sh /usr/local/bin/

VOLUME ["/var/spool/postfix"]

EXPOSE 25/tcp 587/tcp
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/lib/postfix/master", "-d"]
