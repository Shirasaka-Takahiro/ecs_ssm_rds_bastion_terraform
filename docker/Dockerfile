FROM amazonlinux:2

RUN rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 \
    && yum update -y && yum install -y curl vim telnet unzip mysql-community-client amazon-ssm-agent

COPY run.sh /run.sh

ENTRYPOINT ["/bin/bash", "/run.sh"]