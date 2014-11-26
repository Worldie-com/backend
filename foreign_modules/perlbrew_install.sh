#!/bin/sh

if [ "x${PERLBREWURL}" == "x" ]; then
    PERLBREWURL=http://gugod.github.io/App-perlbrew/perlbrew
fi

if [ -z "$TMPDIR" ]; then
    if [ -d "/tmp" ]; then
        TMPDIR="/tmp"
    else
        TMPDIR="."
    fi
fi

cd $TMPDIR || exit 1

LOCALINSTALLER="perlbrew-$$"

echo
if type curl >/dev/null 2>&1; then
  PERLBREWDOWNLOAD="curl -f -k -sS -Lo $LOCALINSTALLER $PERLBREWURL"
elif type fetch >/dev/null 2>&1; then
  PERLBREWDOWNLOAD="fetch --no-verify-peer -o $LOCALINSTALLER $PERLBREWURL"
elif type wget >/dev/null 2>&1; then
  PERLBREWDOWNLOAD="wget -nv --no-check-certificate -O $LOCALINSTALLER $PERLBREWURL"
else
  echo "Need wget or curl to use $0"
  exit 1
fi

clean_exit () {
  [ -f $LOCALINSTALLER ] && rm $LOCALINSTALLER
  exit $1
}

echo "## Download the latest perlbrew"
$PERLBREWDOWNLOAD || clean_exit 1

echo
echo "## Installing perlbrew"
chmod +x $LOCALINSTALLER
/usr/bin/perl $LOCALINSTALLER self-install || clean_exit 1

echo "## Installing patchperl"
/usr/bin/perl $LOCALINSTALLER -f -q install-patchperl || clean_exit 1

echo
echo "## Done."
rm ./$LOCALINSTALLER

