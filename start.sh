#!/bin/sh

[ -z ${MY_GIT_DIR} ] && MY_GIT_DIR=/hugo
[ -z ${MY_THM_DIR} ] && MY_THM_DIR=/theme

HUGO_ARG=$@

echo MY_TZ:${MY_TZ}
echo MY_GIT_DIR:${MY_GIT_DIR}
echo MY_GIT_URL:${MY_GIT_URL}
echo MY_GIT_SUB:${MY_GIT_SUB}
echo MY_HUG_DIR:${MY_HUG_DIR}
echo MY_PUB_DIR:${MY_PUB_DIR}
echo MY_THM_DIR:${MY_THM_DIR}
echo MY_THM_URL:${MY_THM_URL}
echo GIT_SSL_NO_VERIFY:${GIT_SSL_NO_VERIFY}

# Run cmd with error check
RUN_CMD() {
	CMD=$1
	$CMD
	RTN=$?
	if [ ${RTN} -ne 0 ]; then
		echo \"$CMD\" error:${RTN}
		exit ${RTN}
	fi
	return ${RTN}
}

GIT_CLONE_PULL() {
	MY_URL=$1
	MY_DIR=$2
	# --- GIT Clone/Pull
	if [ ! -d ${MY_DIR} ]; then
		# Create directory. This take care of path creation
		# MY_DIR does not exist, do git clone
		RUN_CMD "mkdir -p ${MY_DIR}"
		echo ${MY_DIR} created ...
	fi
	# MY_GIT_DIR exist ...
	echo ${MY_DIR} exist ...
	if [ "$(ls -A ${MY_DIR})" ]; then
		{
			echo ... not empty
			if [ -d ${MY_DIR}/.git ]; then
				echo ... is repo
				RUN_CMD "cd ${MY_DIR}"
				# Check if remote same as MY_URL
				REMOTE=$(git remote -v | grep \(fetch\))
				case "${REMOTE}" in
				*"${MY_URL}"*)
					echo ... pull
					RUN_CMD "git pull"
					;;
				*)
					echo MY_URL:${MY_URL} not same as repo remote: ${REMOTE}
					exit 1
					;;
				esac
			else
				echo ... not repo, don\'t touch, exit
				echo ${MY_DIR} exist but not empty and not a git repo.
				exit 1
			fi
		}
	else
		{
			# MY_GIT_DIR exist but empty
			echo ... empty
			RUN_CMD "git clone ${MY_GIT_URL} ${MY_GIT_DIR}"
		}
	fi
}

# --- TZ
if [ "${#MY_TZ}" -gt "0" ]; then
	TZ="/usr/share/zoneinfo/${MY_TZ}"
	if [ -f "${TZ}" ]; then
		cp ${TZ} /etc/localtime
		echo "${MY_TZ}" >/etc/timezone
	fi
fi

# --- GIT Clone/Pull Site
GIT_CLONE_PULL ${MY_GIT_URL} ${MY_GIT_DIR}

# --- GIT Clone/Pull Theme
[ ! -z ${MY_THM_URL} ] && GIT_CLONE_PULL ${MY_THM_DIR} ${MY_THM_URL}

# --- CD into repo
RUN_CMD "cd ${MY_GIT_DIR}"

# --- GIT Sub-module
if [ ! -z ${MY_GIT_SUB} ]; then
	RUN_CMD "git submodule update --init --recursive"
fi

# --- Prepare publish directory
if [ ! -z ${MY_PUB_DIR} ]; then
	[ ! -d ${MY_PUB_DIR} ] && RUN_CMD "mkdir -p ${MY_PUB_DIR}"
	HUGO_ARG="${HUGO_ARG} --destination ${MY_PUB_DIR}"
fi

# --- CD into Hugo dir
RUN_CMD "cd ${MY_GIT_DIR}/${MY_HUG_DIR}"

# ---
echo HUGO_ARG:$@

# --- Hugo
RUN_CMD "hugo ${HUGO_ARG}"

exit 0
