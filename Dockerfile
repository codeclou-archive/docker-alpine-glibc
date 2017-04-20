FROM alpine:3.5

ENV GLIBC_VERSN 2.25-r0
ENV GLIBC_SH512 d376aa230b78935c144d4a30526b693ae039c66cf29e2510aae82468c240d0059ec279c6ade18160d98954274882576982eb1b6a62df47d8e3e5f008f5e91a3a
ENV GLIBC_BIN_SH512 e496f2131ce6b1eb927029ce6a9aa9f4e600b75778deba84b480e3eb15eea8a3cd0f7b50eca23a13426bf1443ca0700994cb719d6d7ce786bb68a22067de970a
ENV GLIBC_I18N_SH512 dd449133e9dec6c0bba2047e0622160ed7a6569389d19efb5334b17bd4c4f5ffc2c531c2d2674d347ebd6265c14ea52a5f3e4ab36c137381b2c796566f98d1d8
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
    echo "=== INSTALLING GLIBC-BIN AND I18N ============" && \
    echo "${GLIBC_BIN_SH512}  /opt/glibc-bin-${GLIBC_VERSN}.apk" > /opt/glibc-bin-${GLIBC_VERSN}.apk.sha512 && \
    curl -jkSL -o /opt/glibc-bin-${GLIBC_VERSN}.apk \
        https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSN}/glibc-bin-${GLIBC_VERSN}.apk && \
    sha512sum -c /opt/glibc-bin-${GLIBC_VERSN}.apk.sha512 && \
    echo "${GLIBC_I18N_SH512}  /opt/glibc-i18n-${GLIBC_VERSN}.apk" > /opt/glibc-i18n-${GLIBC_VERSN}.apk.sha512 && \
    curl -jkSL -o /opt/glibc-i18n-${GLIBC_VERSN}.apk \
        https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSN}/glibc-i18n-${GLIBC_VERSN}.apk && \
    sha512sum -c /opt/glibc-i18n-${GLIBC_VERSN}.apk.sha512 && \
    apk add --no-cache /opt/glibc-bin-${GLIBC_VERSN}.apk /opt/glibc-i18n-${GLIBC_VERSN}.apk && \
    rm -rf /tmp/* /var/cache/apk/* /opt/glibc*  && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    echo "export LANG=en_US.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib


ENV LANG en_US.UTF-8


