FROM public.ecr.aws/docker/library/node:18-alpine as base

ARG GITHUB_TOKEN
RUN apk add --no-cache --upgrade meson \
	gobject-introspection-dev \
	ninja \
	pkgconfig \
    build-base \
	cmake \
	autoconf \
	automake \
	libtool \
	bc \
	zlib-dev \
	libxml2-dev \
	jpeg-dev \
	tiff-dev \
	glib-dev \
	gdk-pixbuf-dev \
	sqlite-dev \
	libjpeg-turbo-dev \
	libexif-dev \
	lcms2-dev \
	fftw-dev \
	giflib-dev \
	libpng-dev \
	libwebp-dev \
	orc-dev \
	poppler-dev \
	librsvg-dev \
	libgsf-dev \
	openexr-dev \
	gtk-doc \
    ca-certificates \
    fontconfig \
    openssl && \
    rm -rf /var/cache/apk/*

WORKDIR /home/node/app

ARG VIPS_VERSION=8.14.2
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.xz \
	&& tar xf vips-${VIPS_VERSION}.tar.xz \
	&& cd vips-${VIPS_VERSION} \
	&& meson setup build-dir \
	&& cd build-dir \
	&& ninja \
	&& ninja test \
	&& ninja install 

ARG OPENJPEG_VERSION=2.3.1
ARG OPENJPEG_URL=https://github.com/uclouvain/openjpeg/archive

RUN wget ${OPENJPEG_URL}/v${OPENJPEG_VERSION}.tar.gz \
	&& tar xf v${OPENJPEG_VERSION}.tar.gz \
	&& cd openjpeg-${OPENJPEG_VERSION} \
	&& mkdir build \
	&& cd build \
	&& cmake .. \
	&& make \
	&& make install 

ARG MAGICK_VERSION=7.1.1-8
ARG MAGICK_URL=https://github.com/ImageMagick/ImageMagick/archive

RUN wget ${MAGICK_URL}/${MAGICK_VERSION}.tar.gz \
	&& tar xf ${MAGICK_VERSION}.tar.gz \
	&& cd ImageMagick-${MAGICK_VERSION} \
	&& ./configure \
	&& make V=0 \
	&& make install

# COPY package.json yarn.lock ./
# RUN yarn install
#
# FROM base as build
#
# ARG BUILD_VERSION
# ARG GITHUB_TOKEN
# ENV GITHUB_TOKEN=$GITHUB_TOKEN \
#     BUILD_VERSION="$BUILD_VERSION"
#
# COPY . .
# RUN yarn --frozen-lockfile && \
#     yarn build
# COPY infrastructure/docker-entrypoint.sh /docker-entrypoint.sh
#
# RUN chmod a+x /docker-entrypoint.sh
#
# ENTRYPOINT [ "docker-entrypoint.sh" ]
#
# FROM base as deploy
#
# ARG BUILD_VERSION
# ENV BUILD_VERSION="$BUILD_VERSION"
# LABEL version="$BUILD_VERSION"
#
# COPY --from=build --chown=node:node /home/node/app/build /home/node/app/build
# COPY infrastructure/docker-entrypoint.sh /docker-entrypoint.sh
# RUN chmod a+x /docker-entrypoint.sh
#
# USER node
#
# ENTRYPOINT [ "docker-entrypoint.sh" ]
# CMD [ "node", "./build/index.js" ]
