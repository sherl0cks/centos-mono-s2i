# inspired by https://github.com/sclorg/s2i-python-container/tree/master/3.6
FROM centos/s2i-base-centos7:latest

ENV XBUILD_OPTIONS='' \
    NUGET_RESTORE=true \
    BUILD_DIRECTORY_TO_RUN=build/bin/Debug \
    MONO_RUN_OPTIONS=''

RUN rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" && \
    curl https://download.mono-project.com/repo/centos7-stable.repo | tee /etc/yum.repos.d/mono-centos7-stable.repo && \
    INSTALL_PKGS="mono-devel nuget" && \
    yum install $INSTALL_PKGS -y && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# - In order to drop the root user, we have to make some directories world
#   writable as OpenShift default security model is to run the container
#   under random UID.
RUN chown -R 1001:0 ${APP_ROOT} && \
    fix-permissions ${APP_ROOT} -P

USER 1001

EXPOSE 8080

# Set the default CMD to print the usage of the language image.
CMD $STI_SCRIPTS_PATH/usage