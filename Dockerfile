FROM innovanon/doom-base as builder-02
COPY --from=innovanon/zlib        /tmp/zlib.txz          /tmp/
COPY --from=innovanon/bzip2       /tmp/bzip2.txz         /tmp/
COPY --from=innovanon/xz          /tmp/xz.txz            /tmp/
COPY --from=innovanon/libpng      /tmp/libpng.txz        /tmp/
COPY --from=innovanon/jpeg-turbo  /tmp/jpeg-turbo.txz    /tmp/
COPY --from=innovanon/sdl         /tmp/sdl.txz           /tmp/
COPY --from=xtrans                /tmp/libxtrans.txz     /tmp/
COPY --from=libX11                /tmp/libX11.txz        /tmp/
COPY --from=libXext               /tmp/libXext.txz       /tmp/
COPY --from=libFS                 /tmp/libFS.txz         /tmp/
COPY --from=libICE                /tmp/libICE.txz        /tmp/
COPY --from=libSM                 /tmp/libSM.txz         /tmp/
COPY --from=libXScrnSaver         /tmp/libXScrnSaver.txz /tmp/
COPY --from=libXt                 /tmp/libXt.txz         /tmp/
COPY --from=libXmu                /tmp/libXmu.txz        /tmp/
COPY --from=libXpm                /tmp/libXpm.txz        /tmp/
COPY --from=libXaw                /tmp/libXaw.txz        /tmp/
COPY --from=libXfixes             /tmp/libXfixes.txz     /tmp/
COPY --from=libXcomposite         /tmp/libXcomposite.txz /tmp/
COPY --from=libXrender            /tmp/libXrender.txz    /tmp/
COPY --from=libXcursor            /tmp/libXcursor.txz    /tmp/
COPY --from=libXdamage            /tmp/libXdamage.txz    /tmp/
COPY --from=libfontenc            /tmp/libfontenc.txz    /tmp/
COPY --from=libXfont2             /tmp/libXfont2.txz     /tmp/
COPY --from=libXft                /tmp/libXft.txz        /tmp/
COPY --from=libXi                 /tmp/libXi.txz         /tmp/
COPY --from=libXinerama           /tmp/libXinerama.txz   /tmp/
COPY --from=libXrandr             /tmp/libXrandr.txz     /tmp/
COPY --from=libXres               /tmp/libXres.txz       /tmp/
COPY --from=libXtst               /tmp/libXtst.txz       /tmp/
COPY --from=libXv                 /tmp/libXv.txz         /tmp/
COPY --from=libXvMC               /tmp/libXvMC.txz       /tmp/
COPY --from=libXxf86dga           /tmp/libXxf86dga.txz   /tmp/
COPY --from=libXxf86vm            /tmp/libXxf86vm.txz    /tmp/
COPY --from=libdmx                /tmp/libdmx.txz        /tmp/
COPY --from=libpciaccess          /tmp/libpciaccess.txz  /tmp/
COPY --from=libxkbfile            /tmp/libxkbfile.txz    /tmp/
COPY --from=libxshmfence          /tmp/libxshmfence.txz  /tmp/
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

