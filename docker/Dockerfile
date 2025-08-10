FROM amazonlinux:2

RUN rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 \
    && yum update -y && yum install -y curl vim telnet unzip mysql amazon-ssm-agent

COPY run.sh /run.sh

CMD ["/bin/bash", "/run.sh"]