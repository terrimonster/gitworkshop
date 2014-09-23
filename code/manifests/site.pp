filebucket { 'main':
  server => $::servername,
  path   => false,
}

File { backup => 'main' }

Package {
  allow_virtual => true,
}

node /^master/ {
  include pc_puppet::master
}

node /^gitlab/ {
  include pc_puppet::gitlab
}

node default {
  #include mymotd
}

