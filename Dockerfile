FROM public.ecr.aws/docker/library/node:18-bullseye-slim

RUN apt-get update && apt-get install -y build-essential pkg-config libglib2.0-dev libgirepository1.0-dev libexpat1-dev libtiff5-dev libgsf-1-dev build-essential autoconf automake libtool nasm unzip wget git pkg-config curl cmake meson

RUN apt-get install -y libopenjp2-7-dev

ARG OPENJPEG_VERSION=2.4.0
ARG OPENJPEG_URL=https://github.com/uclouvain/openjpeg/archive

RUN wget ${OPENJPEG_URL}/v${OPENJPEG_VERSION}.tar.gz \
	&& tar xf v${OPENJPEG_VERSION}.tar.gz \
	&& cd openjpeg-${OPENJPEG_VERSION} \
	&& mkdir build \
	&& cd build \
	&& cmake .. -DCMAKE_BUILD_TYPE=Release \
	&& make \
	&& make install 

ARG MAGICK_VERSION=7.1.1-8
ARG MAGICK_URL=https://github.com/ImageMagick/ImageMagick/archive

RUN wget ${MAGICK_URL}/${MAGICK_VERSION}.tar.gz \
	&& tar xf ${MAGICK_VERSION}.tar.gz \
	&& cd ImageMagick-${MAGICK_VERSION} \
	&& ./configure --with-modules --with-jp2 \
	&& make V=0 \
	&& make install \
	&& ldconfig

RUN cd /usr/local/src

ARG VIPS_VERSION=8.14.2
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.xz \
	&& tar xf vips-${VIPS_VERSION}.tar.xz \
	&& cd vips-${VIPS_VERSION} \
	&& meson setup build-dir -Djp2k=true -Dopenjpeg=enabled \
	&& cd build-dir \
	&& ninja \
	&& ninja install
