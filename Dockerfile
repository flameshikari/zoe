FROM zyclonite/zerotier:1.14.2

ARG TARGETPLATFORM 

RUN TARGET=$(mktemp) && \
    ZTE_VER=0.2.1 && \
    case ${TARGETPLATFORM} in \
         linux/amd64) ARCH='x86_64';  LIB='musl' ;; \
         linux/arm64) ARCH='aarch64'; LIB='musl' ;; \
         linux/arm/v7) ARCH='arm'; LIB='musleabi' ;; \
         linux/arm/v6) ARCH='arm'; LIB='musleabihf' ;; \
    esac && \
    FILENAME=zerotier-edge-${ARCH}-unknown-linux-${LIB}-v${ZTE_VER}.tar.gz && \
    wget -O $TARGET https://github.com/mokeyish/zerotier-edge/releases/download/v${ZTE_VER}/${FILENAME} && \
    tar ft $TARGET | grep '/zerotier-edge$' | xargs tar fvxz $TARGET --strip-components=1 -C /usr/sbin && \
    rm -fv $TARGET

CMD entrypoint.sh -U -d; sleep 2; \
    exec zerotier-edge -H 0.0.0.0 -P 9994
