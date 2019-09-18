FROM alpine

LABEL maintainer="Ramene Anthony <ramene.anthony@gmail.com>"

# NOTE: Adapted for GitHub Actions, inspired by and derived from https://github.com/lachie83/k8s-kubectl 
# ARG VCS_REF
# ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$GITHUB_SHA \ 
      org.label-schema.vcs-url="http://github.com/ramene/aws/kubectl" \
      # org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

LABEL com.github.actions.name="GitHub Actions for kubectl" \
      com.github.actions.description="Stores a kubectl config" \
      com.github.actions.icon="box" \
      com.github.actions.color="black" 

COPY LICENSE README.md THIRD_PARTY_NOTICE.md /

ENV KUBE_LATEST_VERSION="v1.15.3"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl gnupg \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["kubectl"]
CMD ["help"]