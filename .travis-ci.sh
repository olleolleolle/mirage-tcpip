wget https://raw.githubusercontent.com/samoht/ocaml-travisci-skeleton/master/.travis-opam.sh
PACKAGE=tcpip sh .travis-opam.sh

export OPAMYES=1
opam remote add mirage git://github.com/mirage/mirage-dev
eval `opam config env`
prefix=`opam config var prefix`

./configure --prefix=$prefix --enable-tests
make
make test

opam install tcpip
opam install mirage-www

git clone git://github.com/mirage/mirage-www
cd mirage-www
make MODE=xen configure
make MODE=xen build
