#!/bin/sh

if [ -z "$REPO_LINK" ]; then 
	echo -e "\033[1;91mERROR:\033[0m REPO_LINK env variable is required"
	exit 1
fi

if [ -z "$REPO_BRANCH" ]; then 
	export REPO_BRANCH=master
fi

if [ -z "$REPO_KEY" ]; then 
	export REPO_KEY=id_rsa
fi

echo "repository : $REPO_LINK"
echo "branch     : $REPO_BRANCH"
echo "tag        : $REPO_TAG"
echo "revision   : $REPO_REVISION"

# check if credentials files exist
if [[ -f "/key/$REPO_KEY" ]] ; then 
	echo "key file   : $REPO_KEY"
	cp /key/$REPO_KEY /home/git/.ssh/id_rsa
	chmod 600 /home/git/.ssh/id_rsa
	ssh-keyscan -H gitlab.com >> /home/git/.ssh/known_hosts
fi

if [ ! -z "$REPO_USER" ] && [ ! -z "$REPO_PASS" ]; then 
	# clone with repository username & password
	echo "credentials: username and password"
	git clone -b $REPO_BRANCH https://$REPO_USER:$REPO_PASS@$REPO_LINK /repository
else
    if [[ ! -f "/home/git/.ssh/id_rsa" ]] ; then
	    echo -e "\033[1;93mWARNING:\033[0m REPO_USER, REPO_PASS env variables or SSH deployment key missing"
	else
	    # clone public repository or using ssh deployment key
	    echo "credentials: RSA key"
	fi
	git clone -b $REPO_BRANCH $REPO_LINK /repository
fi

if [ ! -z "$REPO_TAG" ]; then 
	cd /repository && \
	echo "checking out repository tag: $REPO_TAG"
	git checkout tags/$REPO_TAG
fi

if [ ! -z "$REPO_REVISION" ]; then
	cd /repository && \
	echo "checking out repository revision: $REPO_REVISION"
	git checkout $REPO_REVISION
fi
