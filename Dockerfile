FROM alpine:edge

LABEL version="0.78.0-r0"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="hugo"
LABEL usage="https://github.com/J-Siu/docker_hugo/blob/master/README.md"
LABEL description="Docker - Hugo site generator used in CI/CD"

RUN apk --no-cache add ca-certificates ca-certificates-bundle tzdata
RUN apk --no-cache add git hugo=0.78.0-r0 && \
git config --global pull.rebase false

COPY README.md start.sh /
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]