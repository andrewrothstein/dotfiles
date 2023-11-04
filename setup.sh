#!/bin/env bash
set -e

install_task() {
    local -r task_bin_dir="${1:-~/.local/bin}";
    local -r task_exe="${task_bin_dir}/task";
    if [ ! -e "${task_exe}" ];
    then
        echo "installing task to ${task_bin_dir}";
        sh \
            -c "$(curl --location https://taskfile.dev/install.sh)" \
            -- \
            -d \
            -b "${task_bin_dir}";
    fi;
    "${task_exe}" --version
}

clone_tasks() {
    tasks_dir="${1:-~/.tasks}";
    if [ ! -d "${tasks_dir}" ];
    then
        git clone \
            https://github.com/andrewrothstein/tasks.git \
            "${tasks_dir}";
    fi;
    echo "tasks git status:";
    git status "file://${tasks_dir}";
}

install_brew() {
    local -r brew_exe="/home/linuxbrew/.linuxbrew/bin/brew";
    if [ ! -e "${brew_exe}" ];
    then
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi;
}

activate_brew() {
    local -r brew_exe="/home/linuxbrew/.linuxbrew/bin/brew";
    eval "$(${brew_exe} shellenv)"
}

install_brewfile() {
    local -r brewfile="${1:-Brewfile}"
    if [ -e "${brewfile}" ];
    then
        echo "installing from ${brewfile}";
        brew bundle install;
    else
        echo "no Brewfile";
    fi
}

dump_versions() {
    gh --version;

    go version;
    goreleaser --version;

    kind --version;

    k3d --version;

    cilium version;

    echo "pack version: $(pack --version)";
}

install_task;
clone_tasks;

install_brew;
activate_brew;
install_brewfile;

brew tap;
brew list;

dump_versions;

