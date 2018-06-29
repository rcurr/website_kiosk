#!/bin/bash
# Simple script to make a deb for website-kiosk.

set -e

if [ -z "$BUILDDIR" ];then
  TMPDIR=$(mktemp -d)
  BUILDDIR=$TMPDIR/build
fi

mkdir -p $BUILDDIR

VERSION=$(grep -oP '^Version:\s+\K(.+)' DEBIAN/control)
DEBNAME="website-kiosk_${VERSION}_all.deb"

test -d $BUILDDIR || mkdir -p $BUILDDIR
git archive master | tar -x --exclude 'make_deb.sh' -C $BUILDDIR

fakeroot dpkg-deb -b $BUILDDIR $DEBNAME

# clean up
if [ ! -z "$TMPDIR" ] && [ -d $TMPDIR ];then
  rm -r $TMPDIR
fi
