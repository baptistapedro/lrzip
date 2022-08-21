FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libz-dev libbz2-dev liblzo2-dev liblz4-dev coreutils
RUN  git clone   https://github.com/ckolivas/lrzip
WORKDIR /lrzip
RUN ./autogen.sh
RUN ./configure CC=afl-clang CXX=afl-clang++
RUN make
RUN make install
RUN mkdir /lrzCorpus
RUN wget  http://ck.kolivas.org/apps/lrzip/lrzip-0.17.tar.lrz
RUN wget  http://ck.kolivas.org/apps/lrzip/lrzip-0.40.tar.lrz
RUN wget http://ck.kolivas.org/apps/lrzip/lrzip-0.5.tar.lrz
RUN  wget http://ck.kolivas.org/apps/lrzip/lrzip-0.45.tar.lrz
RUN mv *.lrz /lrzCorpus


ENTRYPOINT ["afl-fuzz", "-t", "5000+", "-i", "/lrzCorpus", "-o", "/lrzOut"]
CMD  ["/lrzip/lrzip", "-d", "@@"]
