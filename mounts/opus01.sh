#!/bin/bash
set -e
set -x
t=`mktemp -d /tmp/opus.XXXXXX`
mount -t tmpfs zdtm $t
cd $t

mkdir A B
mount -t tmpfs --make-shared zdtmA A
mkdir A/a
mount -t tmpfs zdtmA A/a
mkdir A/a/zdtmA

mount --bind A B
mount -t tmpfs zdtmB B/a
mkdir B/a/zdtmB

cat /proc/self/mountinfo | grep zdtm
echo "Two mounts are connected to one parent"

ls -l A/a
ls -l B/a

test -d A/a/zdtmA
test -d B/a/zdtmB
echo Why A/a/zdtmA was not overmounted?

umount A/a
cat /proc/self/mountinfo | grep zdtm
test -d A/a/zdtmB
echo Two different mounts were detached from A/a and B/a
