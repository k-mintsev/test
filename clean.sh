#!/bin/sh

rm -vrf Binaries Intermediate Saved 
rm -vrf ./Plugins/*/Binaries ./Plugins/*/Intermediate

git lfs prune
