# This version of Alma Linux 8 was picked arbitrarily; it was the
# latest available when this Dockerfile was initially written.
FROM almalinux/8-base:8.7-20221201

# Add the packages we need to build
RUN \
    dnf install -y epel-release \
    && dnf install -y mock rpm-build

RUN \
    adduser builder \
    && usermod -a -G mock builder \
    && mkdir /out \
    && chown -R builder: /out

USER builder

COPY --chown=builder:builder . /home/builder/rpmbuild/

RUN \
    cd /home/builder/rpmbuild \
    && rpmbuild -bs SPECS/pam.spec

# 3 hours -- should be more than enough time to run commands in a
# container generated from this image.
ENTRYPOINT sleep 10880
