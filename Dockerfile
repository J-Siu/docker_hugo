FROM alpine:edge

LABEL version="0.152.2-r1"
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="hugo"
LABEL usage="https://github.com/J-Siu/docker_hugo/blob/master/README.md"
LABEL description="Docker - Hugo site generator used in CI/CD"
LABEL blog="[Jenkins Blog Automation](//johnsiu.com/blog/jenkins-blog-automation/)"

COPY README.md start.sh /
RUN apk --no-cache add \
	ca-certificates \
	ca-certificates-bundle \
	git \
	hugo=0.152.2-r1 \
	tzdata \
	&& git config --global pull.rebase false \
	&& chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
