FROM infocity/gdal

ADD build.sh /tmp
ADD ms.patch /tmp
RUN /tmp/build.sh
