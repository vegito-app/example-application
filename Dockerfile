FROM builder

USER root

ARG non_root_user=dev

ARG uid=1000
ARG gid=1000

# 👤 Rename non root user
RUN usermod -l ${non_root_user} ${USER} \
    && groupmod -n ${non_root_user} ${USER} \
    && \
    echo "${non_root_user}:${non_root_user}" | chpasswd && \
    adduser ${non_root_user} sudo && \
    echo "${non_root_user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${non_root_user} && \
    chmod 0440 /etc/sudoers.d/${non_root_user}

USER ${non_root_user}
ENV USER=${non_root_user}

WORKDIR /home/debian/example-application

ENV GOMODCACHE=/home/${non_root_user}/go/pkg/mod
ENV GOCACHE=/home/${non_root_user}/.cache/go-build
ENV GOFLAGS="-mod=readonly -trimpath"

COPY backend/go.mod backend/go.sum ./backend/

RUN go work init \
    ./backend 

USER root
RUN  --mount=type=cache,id=vegito-go-mod,target=/home/${non_root_user}/go/pkg/mod,sharing=locked,uid=${uid},gid=${gid} \
    --mount=type=cache,id=vegito-go-build,target=/home/${non_root_user}/.cache/go-build,sharing=locked,uid=${uid},gid=${gid} \
    chown -R ${non_root_user}:${non_root_user} \
    /home/${non_root_user}/go/pkg/mod \
    /home/${non_root_user}/.cache/go-build \
    && mkdir -p /home/${non_root_user}/go/pkg/mod \
    && chown -R ${non_root_user}:${non_root_user} \
    /home/${non_root_user}/go/pkg/mod \
    /home/${non_root_user}/.cache/go-build

USER ${non_root_user}

RUN  --mount=type=cache,id=vegito-go-mod,target=/home/${non_root_user}/go/pkg/mod,sharing=locked,uid=${uid},gid=${gid} \
    --mount=type=cache,id=vegito-go-build,target=/home/${non_root_user}/.cache/go-build,sharing=locked,uid=${uid},gid=${gid} \
    go work sync && \
    go mod download all && \
    go build -buildmode=archive \
    ./backend/...