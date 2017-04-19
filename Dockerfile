FROM alpine:3.5

ENV GLIBC_VERSN 2.25-r0
ENV GLIBC_SH512 d376aa230b78935c144d4a30526b693ae039c66cf29e2510aae82468c240d0059ec279c6ade18160d98954274882576982eb1b6a62df47d8e3e5f008f5e91a3a

#
# BASE PACKAGES + DOWNLOAD GLIBC
#
COPY ./vendor-keys/sgerrand.rsa.pub /etc/apk/keys/
RUN apk add --no-cache \
            bash \
            ca-certificates \
            curl \
            gzip \
            tar && \
    mkdir /opt/ && \
    echo "=== INSTALLING GLIBC =========================" && \
    echo "${GLIBC_SH512}  /opt/glibc-${GLIBC_VERSN}.apk" > /opt/glibc-${GLIBC_VERSN}.apk.sha512 && \
    curl -jkSL -o /opt/glibc-${GLIBC_VERSN}.apk \
        https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSN}/glibc-${GLIBC_VERSN}.apk && \
    sha512sum -c /opt/glibc-${GLIBC_VERSN}.apk.sha512 && \
    apk add /opt/glibc-${GLIBC_VERSN}.apk && \
    rm -rf /tmp/* /var/cache/apk/*
