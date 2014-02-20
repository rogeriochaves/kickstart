# Set $kickstart_pkg to "apt-get" or "yum", or abort.
if which apt-get >/dev/null 2>&1; then
  export kickstart_pkg=apt-get
elif which yum >/dev/null 2>&1; then
  export kickstart_pkg=yum
fi

if [ "$kickstart_pkg" = '' ]; then
  echo 'kickstart only supports apt-get or yum!' >&2
  exit 1
fi

kickstart.package.installed() {
  if [ "$kickstart_pkg" = 'apt-get' ]; then
    dpkg -s $@ >/dev/null 2>&1
  elif [ "$kickstart_pkg" = 'yum' ]; then
    rpm -qa | grep $@ >/dev/null
  fi
  return $?
}

kickstart.package.install() {
  if kickstart.package.installed "$@"; then
    echo "$@ already installed"
    return 1
  else
    echo "No packages found matching $@. Installing..."
    kickstart.mute "$kickstart_pkg -y install $@"
    return 0
  fi
}