FROM fedora:32
RUN dnf update -y \
    && dnf install -y httpd-tools \
    && dnf clean all \
    && rm -rf /var/cache/yum \
    && useradd ansible -m
COPY ansible_sudoers.conf /etc/sudoers.d/ansible
WORKDIR /home/ansible
USER ansible
CMD sleep 7200
