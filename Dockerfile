FROM alpine:edge
ARG APP="hugo"
ARG VER="0.169.0-r1"
ARG USR="https://github.com/J-Siu"
LABEL version=${VER}
LABEL maintainers="[John Sing Dao Siu](${USR})"
LABEL name=${APP}
LABEL usage="${USR}/docker_${APP}/blob/master/README.md"
LABEL description="Docker - Hugo site generator used in CI/CD"
LABEL blog="[Jenkins Blog Automation](//johnsiu.com/blog/jenkins-blog-automation/)"

COPY README.md start.sh /
RUN apk --no-cache add \
${APP}=${VER} \
ca-certificates \
ca-certificates-bundle \
tzdata \
git \
&& git config --global pull.rebase false \
&& chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
