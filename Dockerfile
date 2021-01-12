FROM innovanon/doom-base as builder-02
USER root
COPY --from=innovanon/zlib       /tmp/zlib.txz       /tmp/
COPY --from=innovanon/bzip2      /tmp/bzip2.txz      /tmp/
COPY --from=innovanon/xz         /tmp/xz.txz         /tmp/
COPY --from=innovanon/libpng     /tmp/libpng.txz     /tmp/
COPY --from=innovanon/jpeg-turbo /tmp/jpeg-turbo.txz /tmp/
RUN extract.sh

FROM builder-02 as fltk
ARG LFS=/mnt/lfs
USER lfs
RUN sleep 31 \
 && command -v strip.sh                 \
 && git clone --depth=1 --recursive       \
      https://github.com/fltk/fltk.git      \
 && cd                      fltk          \
 && ./autogen.sh                          \
 && ./configure                           \
      --disable-shared --enable-static    \
      "${CONFIG_OPTS[@]}"                 \
 && make                                  \
 && make DESTDIR=/tmp/fltk install        \
 && cd           /tmp/fltk                \
 && strip.sh .                            \
 && tar acf        ../fltk.txz .          \
 && rm -rf        $LFS/sources/fltk

FROM scratch as final
COPY --from=fltk /tmp/fltk.txz /tmp/

