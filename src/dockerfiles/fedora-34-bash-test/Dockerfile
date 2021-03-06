# Base image
FROM docker.io/library/fedora:34

# Image Metadata
LABEL \
    container64.os-name="fedora" \
    container64.os-version="34.0" \
    container64.image-version="0.4.0" \
    container64.image-content="bash,bats-core" \
    org.opencontainers.image.description="Purpose: Bash scripts testing - Packages: Bash, Bats Core, Bash Core plugins, OS utilities"

# Prepare package installer
ENV container="docker"

# Download BashLib64
COPY loader/bashlib64.bash /cmd

# Prepare environment
ARG BL64_LIB_CMD="1"
ARG BL64_LIB_VERBOSE="2"
ARG CNT64_TEST_USER="test"
ARG CNT64_BATSCORE_VOLUME="/test"
ARG CNT64_HELPERS="sudo git diffutils hostname wget python3-pip findutils unzip"
RUN \
    /bin/chmod 755 /cmd && \
    /cmd bl64_pkg_deploy ${CNT64_HELPERS} && \
    /cmd bl64_iam_user_add ${CNT64_TEST_USER} && \
    /cmd bl64_rbac_add_root ${CNT64_TEST_USER} && \
    /cmd bl64_fs_mkdir_full ${CNT64_BATSCORE_VOLUME}

# Install Bats-Core
ARG CNT64_BATSCORE_REPO="https://github.com/bats-core"
ARG CNT64_BATSCORE_COMPONENT_NAME="bats-core"
ARG CNT64_BATSCORE_COMPONENT_PATH="/opt"
ARG CNT64_BATSCORE_HELPERS="${CNT64_BATSCORE_COMPONENT_PATH}/${CNT64_BATSCORE_COMPONENT_NAME}/test_helper"

RUN \
    /cmd bl64_vcs_git_clone ${CNT64_BATSCORE_REPO}/${CNT64_BATSCORE_COMPONENT_NAME}.git ${CNT64_BATSCORE_COMPONENT_PATH} 'master' && \
    /cmd bl64_fs_mkdir_full $CNT64_BATSCORE_HELPERS

# Install plugins
ARG CNT64_BATSCORE_COMPONENT_PATH="$CNT64_BATSCORE_HELPERS"
ARG CNT64_BATSCORE_COMPONENT_NAME="bats-support"
RUN /cmd bl64_vcs_git_clone ${CNT64_BATSCORE_REPO}/${CNT64_BATSCORE_COMPONENT_NAME}.git ${CNT64_BATSCORE_COMPONENT_PATH} 'master'

ARG CNT64_BATSCORE_COMPONENT_NAME="bats-assert"
RUN /cmd bl64_vcs_git_clone ${CNT64_BATSCORE_REPO}/${CNT64_BATSCORE_COMPONENT_NAME}.git ${CNT64_BATSCORE_COMPONENT_PATH} 'master'

ARG CNT64_BATSCORE_COMPONENT_NAME="bats-file"
RUN /cmd bl64_vcs_git_clone ${CNT64_BATSCORE_REPO}/${CNT64_BATSCORE_COMPONENT_NAME}.git ${CNT64_BATSCORE_COMPONENT_PATH} 'master'

# Cleanup
RUN \
    /cmd bl64_fs_cleanup_full && \
    rm /cmd

# Run bats-core against /test
CMD [ "/test" ]
USER ${CNT64_TEST_USER}
ENTRYPOINT [ "/opt/bats-core/bin/bats" ]
