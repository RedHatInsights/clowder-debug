FROM fedora:34

RUN curl -sL https://github.com/RedHatInsights/app-common-bash/releases/download/v0.1/app-common-bash > /usr/bin/app-common-bash && chmod +x /usr/bin/app-common-bash
USER 0
RUN dnf install -y postgresql jq
