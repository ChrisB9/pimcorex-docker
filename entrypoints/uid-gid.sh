#!/usr/bin/env bash

if [[ -v OVERRIDE_APPLICATION_GID ]] && ! getent group ${OVERRIDE_APPLICATION_GID} >/dev/null 2>&1; then
    export APPLICATION_GID=$OVERRIDE_APPLICATION_GID
    groupmod -g ${APPLICATION_GID} application
fi

if [[ -v OVERRIDE_APPLICATION_UID ]] && ! id ${OVERRIDE_APPLICATION_UID} >/dev/null 2>&1; then
    export APPLICATION_UID=$OVERRIDE_APPLICATION_UID
    usermod -u ${APPLICATION_UID} application
fi
