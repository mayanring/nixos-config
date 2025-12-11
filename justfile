set shell := ["fish", "-c"]

alias a := apply

default:
    just --list

@apply:
    git add .
    sudo nixos-rebuild switch --flake ~/.nixos-config#

@build:
    nixos-rebuild build --flake ~/.nixos-config#
