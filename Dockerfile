ARG DOCKER_REGISTRY

FROM ${DOCKER_REGISTRY:+${DOCKER_REGISTRY}/}alpine

ENV \
	TERRAFORM_VERSION=1.5.1

RUN \
	echo "Installing basic tooling" \
		&& apk add --update --no-cache \
			aws-cli \
			bash \
			curl \
			git \
			jq \
			openssl \
	&& OS_NAME=$(uname -o | tr '[:upper:]' '[:lower:]') \
    && ARCH_NAME=$(uname -m) \
      && ARCH_NAME=${ARCH_NAME/aarch64/arm64} \
      && ARCH_NAME=${ARCH_NAME/x86_64/amd64} \
	&& echo "Installing terraform version ${TERRAFORM_VERSION#v}" \
    && curl -fL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${OS_NAME}_${ARCH_NAME}.zip \
      --output /tmp/terraform.zip \
      --no-progress-meter \
    && unzip -q /tmp/terraform.zip terraform -d /usr/local/bin \
    && rm /tmp/terraform.zip

WORKDIR /var/workspace
