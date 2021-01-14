FROM innovanon/doom-base as builder-02
USER root
# doom
COPY --from=innovanon/zlib        /tmp/zlib.txz          /tmp/
COPY --from=innovanon/bzip2       /tmp/bzip2.txz         /tmp/
COPY --from=innovanon/xz          /tmp/xz.txz            /tmp/
COPY --from=innovanon/libpng      /tmp/libpng.txz        /tmp/
COPY --from=innovanon/jpeg-turbo  /tmp/jpeg-turbo.txz    /tmp/
COPY --from=innovanon/sdl         /tmp/sdl.txz           /tmp/
# xorg
COPY --from=innovanon/util-macros /tmp/util-macros.txz /tmp/
COPY --from=innovanon/xorgproto   /tmp/xorgproto.txz   /tmp/
COPY --from=innovanon/libxau      /tmp/libXau.txz      /tmp/
COPY --from=innovanon/libxdmcp    /tmp/libXdmcp.txz    /tmp/
COPY --from=innovanon/xcb-proto   /tmp/xcbproto.txz    /tmp/
COPY --from=innovanon/libxcb      /tmp/libxcb.txz      /tmp/
COPY --from=innovanon/freetype    /tmp/freetype2.txz   /tmp/
COPY --from=innovanon/fontconfig  /tmp/fontconfig.txz  /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libxtrans.txz     /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libX11.txz        /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXext.txz       /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libFS.txz         /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libICE.txz        /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libSM.txz         /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXScrnSaver.txz /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXt.txz         /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXmu.txz        /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXpm.txz        /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXaw.txz        /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXfixes.txz     /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXcomposite.txz /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXrender.txz    /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXcursor.txz    /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXdamage.txz    /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libfontenc.txz    /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXfont2.txz     /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXft.txz        /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXi.txz         /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXinerama.txz   /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXrandr.txz     /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXres.txz       /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXtst.txz       /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXv.txz         /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXvMC.txz       /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXxf86dga.txz   /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libXxf86vm.txz    /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libdmx.txz        /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libpciaccess.txz  /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libxkbfile.txz    /tmp/
COPY --from=innovanon/xorg-libs   /tmp/libxshmfence.txz  /tmp/
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
 && tar  pacf        ../fltk.txz .          \
 && rm -rf        $LFS/sources/fltk

FROM scratch as final
COPY --from=fltk /tmp/fltk.txz /tmp/

