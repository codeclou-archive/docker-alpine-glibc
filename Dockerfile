FROM alpine:3.7

ENV GLIBC_VERSN 2.26-r0
ENV GLIBC_SH512 c52263ae9c834f48ea509cfaaf9ffc568ab7504d2566b18f694f8d76513aafc03c764b9787c7e067c5e973dd3cc5262acc35eb337ba60538be8aa50db250c30f

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
