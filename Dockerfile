FROM node:24-bookworm-slim

ARG AWS_CLI_VERSION=2.36.43

RUN apt-get update \
    && apt-get install --no-install-recommends --yes ca-certificates curl unzip groff-base less \
    && case "$(dpkg --print-architecture)" in \
         amd64) aws_arch="x86_64" ;; \
         arm64) aws_arch="aarch64" ;; \
         *) echo "Unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
       esac \
    && curl --fail --silent --show-error --location \
         "https://awscli.amazonaws.com/awscli-exe-linux-${aws_arch}-${AWS_CLI_VERSION}.zip" \
         --output /tmp/awscliv2.zip \
    && unzip -q /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install \
    && apt-get purge --auto-remove --yes curl unzip \
    && rm -rf /tmp/aws /tmp/awscliv2.zip /var/lib/apt/lists/*

WORKDIR /workspace
RUN chown node:node /workspace \
    && install -d -o node -g node /workspace/node_modules \
    && install -d -m 700 -o node -g node /home/node/.aws

USER node

CMD ["bash"]
