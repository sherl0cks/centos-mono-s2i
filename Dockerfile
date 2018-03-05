FROM centos/s2i-base-centos7:latest

ENV XBUILD_OPTIONS='' \
    NUGET_RESTORE=true

RUN rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" && \
    curl https://download.mono-project.com/repo/centos7-stable.repo | tee /etc/yum.repos.d/mono-centos7-stable.repo && \
    INSTALL_PKGS="mono-devel nuget" && \
    yum install $INSTALL_PKGS -y && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

USER 1001

# Set the default CMD to print the usage of the language image.
CMD $STI_SCRIPTS_PATH/usage