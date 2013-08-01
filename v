#!/usr/bin/env sh

if [ $# -eq 0 ]; then
  mvim .
else
  mvim $@
fi
