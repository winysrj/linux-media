Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34332 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbdEARh5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 May 2017 13:37:57 -0400
Received: by mail-io0-f180.google.com with SMTP id a103so123914270ioj.1
        for <linux-media@vger.kernel.org>; Mon, 01 May 2017 10:37:57 -0700 (PDT)
Message-ID: <1493660273.17990.4.camel@ndufresne.ca>
Subject: Re: [PATCH v2 3/3] libv4l-codecparsers: add GStreamer mpeg2 parser
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hugues Fruchet <hugues.fruchet@st.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Date: Mon, 01 May 2017 13:37:53 -0400
In-Reply-To: <1493391752-22429-4-git-send-email-hugues.fruchet@st.com>
References: <1493391752-22429-1-git-send-email-hugues.fruchet@st.com>
         <1493391752-22429-4-git-send-email-hugues.fruchet@st.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-houRi0CakQSBlRR2jOzl"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-houRi0CakQSBlRR2jOzl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 28 avril 2017 =C3=A0 17:02 +0200, Hugues Fruchet a =C3=A9crit=
=C2=A0:
> Add the mpeg2 codecparser backend glue which will
> call the GStreamer parsing functions.
>=20
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
> =C2=A0configure.ac=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A021 ++
> =C2=A0lib/libv4l-codecparsers/Makefile.am=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A014 +-
> =C2=A0lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c | 375
> ++++++++++++++++++++++++
> =C2=A0lib/libv4l-codecparsers/libv4l-cparsers.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A04 +
> =C2=A04 files changed, 413 insertions(+), 1 deletion(-)
> =C2=A0create mode 100644 lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c
>=20
> diff --git a/configure.ac b/configure.ac
> index 9ce7392..ce43f18 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -273,6 +273,25 @@ fi
> =C2=A0
> =C2=A0AC_SUBST([JPEG_LIBS])
> =C2=A0
> +# Check for GStreamer codecparsers
> +
> +gst_codecparsers_pkgconfig=3Dfalse
> +PKG_CHECK_MODULES([GST], [gstreamer-1.0 >=3D 1.8.0],
> [gst_pkgconfig=3Dtrue], [gst_pkgconfig=3Dfalse])
> +if test "x$gst_pkgconfig" =3D "xfalse"; then
> +=C2=A0=C2=A0=C2=A0AC_MSG_WARN(GStreamer library is not available)
> +else
> +=C2=A0=C2=A0=C2=A0PKG_CHECK_MODULES([GST_BASE], [gstreamer-base-1.0 >=3D=
 1.8.0],
> [gst_base_pkgconfig=3Dtrue], [gst_base_pkgconfig=3Dfalse])
> +=C2=A0=C2=A0=C2=A0if test "x$gst_base_pkgconfig" =3D "xfalse"; then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0AC_MSG_WARN(GStreamer base library i=
s not available)
> +=C2=A0=C2=A0=C2=A0else
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0PKG_CHECK_MODULES(GST_CODEC_PARSERS,=
 [gstreamer-codecparsers-
> 1.0 >=3D 1.8.0], [gst_codecparsers_pkgconfig=3Dtrue],=20

You should only check for the codecparser library. The rest are
dependencies which will be pulled automatically by pkg-config. If for
some reason you needed multiple libs, that don't depend on each others,
notice the S in PKG_CHECK_MODULES. You can do a single invocation.

> [gst_codecparsers_pkgconfig=3Dfalse])
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if test "x$gst_codecparsers_pkgconfi=
g" =3D "xfalse"; then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0AC_MSG_WARN(GStrea=
mer codecparser library is not available)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0fi
> +=C2=A0=C2=A0=C2=A0fi
> +fi
> +AM_CONDITIONAL([HAVE_GST_CODEC_PARSERS], [test
> x$gst_codecparsers_pkgconfig =3D xtrue])
> +
> =C2=A0# Check for pthread
> =C2=A0
> =C2=A0AS_IF([test x$enable_shared !=3D xno],
> @@ -477,6 +496,7 @@ AM_COND_IF([WITH_V4L2_CTL_LIBV4L],
> [USE_V4L2_CTL=3D"yes"], [USE_V4L2_CTL=3D"no"])
> =C2=A0AM_COND_IF([WITH_V4L2_CTL_STREAM_TO], [USE_V4L2_CTL=3D"yes"],
> [USE_V4L2_CTL=3D"no"])
> =C2=A0AM_COND_IF([WITH_V4L2_COMPLIANCE_LIBV4L],
> [USE_V4L2_COMPLIANCE=3D"yes"], [USE_V4L2_COMPLIANCE=3D"no"])
> =C2=A0AS_IF([test "x$alsa_pkgconfig" =3D "xtrue"], [USE_ALSA=3D"yes"],
> [USE_ALSA=3D"no"])
> +AS_IF([test "x$gst_codecparsers_pkgconfig" =3D "xtrue"],
> [USE_GST_CODECPARSERS=3D"yes"], [USE_GST_CODECPARSERS=3D"no"])
> =C2=A0
> =C2=A0AC_OUTPUT
> =C2=A0
> @@ -497,6 +517,7 @@ compile time options summary
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pthread=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0: $have_pthread
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0QT version=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0: $QT_VERSION
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ALSA support=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0: $USE_ALSA
> +=C2=A0=C2=A0=C2=A0=C2=A0GST codecparsers=C2=A0=C2=A0=C2=A0=C2=A0: $USE_G=
ST_CODECPARSERS
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0build dynamic libs=C2=A0=C2=A0: $enable_sha=
red
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0build static libs=C2=A0=C2=A0=C2=A0: $enabl=
e_static
> diff --git a/lib/libv4l-codecparsers/Makefile.am b/lib/libv4l-
> codecparsers/Makefile.am
> index a9d6c8b..61f4730 100644
> --- a/lib/libv4l-codecparsers/Makefile.am
> +++ b/lib/libv4l-codecparsers/Makefile.am
> @@ -1,9 +1,21 @@
> =C2=A0if WITH_V4L_PLUGINS
> +if HAVE_GST_CODEC_PARSERS
> +
> =C2=A0libv4l2plugin_LTLIBRARIES =3D libv4l-codecparsers.la
> -endif
> =C2=A0
> =C2=A0libv4l_codecparsers_la_SOURCES =3D libv4l-cparsers.c libv4l-cparser=
s.h
> =C2=A0
> =C2=A0libv4l_codecparsers_la_CPPFLAGS =3D $(CFLAG_VISIBILITY)
> -I$(top_srcdir)/lib/libv4l2/ -I$(top_srcdir)/lib/libv4lconvert/
> =C2=A0libv4l_codecparsers_la_LDFLAGS =3D -avoid-version -module -shared
> -export-dynamic -lpthread
> =C2=A0libv4l_codecparsers_la_LIBADD =3D ../libv4l2/libv4l2.la
> +
> +# GStreamer codecparsers library
> +libv4l_codecparsers_la_CFLAGS =3D $(GST_CFLAGS) -DGST_USE_UNSTABLE_API
> +libv4l_codecparsers_la_LDFLAGS +=3D $(GST_LIB_LDFLAGS)
> +libv4l_codecparsers_la_LIBADD +=3D $(GLIB_LIBS) $(GST_LIBS)
> $(GST_BASE_LIBS) $(GST_CODEC_PARSERS_LIBS) $(NULL)
> +
> +# MPEG-2 parser back-end
> +libv4l_codecparsers_la_SOURCES +=3D libv4l-cparsers-mpeg2.c
> +
> +endif
> +endif
> diff --git a/lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c
> b/lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c
> new file mode 100644
> index 0000000..3456b73
> --- /dev/null
> +++ b/lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c
> @@ -0,0 +1,375 @@
> +/*
> + * libv4l-cparsers-mpeg2.c
> + *
> + * Copyright (C) STMicroelectronics SA 2017
> + * Authors: Hugues Fruchet <hugues.fruchet@st.com>
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Tifaine In=
guere <tifaine.inguere@st.com>
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for STMicr=
oelectronics.
> + *
> + * This program is free software; you can redistribute it and/or
> modify
> + * it under the terms of the GNU Lesser General Public License as
> published by
> + * the Free Software Foundation; either version 2.1 of the License,
> or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=C2=A0=C2=A0See t=
he GNU
> + * Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Suite 500, Boston,
> MA=C2=A0=C2=A002110-1335=C2=A0=C2=A0USA
> + */
> +
> +#include <errno.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <stdbool.h>
> +
> +#include "libv4l2.h"
> +#include "libv4l2-priv.h"
> +#include "libv4l-cparsers.h"
> +
> +#include <gst/codecparsers/gstmpegvideoparser.h>
> +#include <gst/base/gstbitreader.h>
> +
> +/*
> + * parsing metadata ids and their associated control ids.
> + * keep in sync both enum and array, this is used to index
> metas[<meta id>]
> + */
> +enum mpeg2_meta_id {
> +	SEQ_HDR,
> +	SEQ_EXT,
> +	SEQ_DISPLAY_EXT,
> +	SEQ_MATRIX_EXT,
> +	PIC_HDR,
> +	PIC_HDR1,/* 2nd field decoding of interlaced stream */
> +	PIC_EXT,
> +	PIC_EXT1,/* 2nd field decoding of interlaced stream */
> +};
> +
> +static const struct v4l2_ext_control mpeg2_metas_store[] =3D {
> +	{
> +	.id =3D V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR,
> +	.size =3D sizeof(struct v4l2_mpeg_video_mpeg2_seq_hdr),
> +	},
> +	{
> +	.id =3D V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT,
> +	.size =3D sizeof(struct v4l2_mpeg_video_mpeg2_seq_ext),
> +	},
> +	{
> +	.id =3D V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT,
> +	.size =3D sizeof(struct
> v4l2_mpeg_video_mpeg2_seq_display_ext),
> +	},
> +	{
> +	.id =3D V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT,
> +	.size =3D sizeof(struct v4l2_mpeg_video_mpeg2_seq_matrix_ext),
> +	},
> +	{
> +	.id =3D V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR,
> +	.size =3D sizeof(struct v4l2_mpeg_video_mpeg2_pic_hdr),
> +	},
> +	{/* 2nd field decoding of interlaced stream */
> +	.id =3D V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR,
> +	.size =3D sizeof(struct v4l2_mpeg_video_mpeg2_pic_hdr),
> +	},
> +	{
> +	.id =3D V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT,
> +	.size =3D sizeof(struct v4l2_mpeg_video_mpeg2_pic_ext),
> +	},
> +	{/* 2nd field decoding of interlaced stream */
> +	.id =3D V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT,
> +	.size =3D sizeof(struct v4l2_mpeg_video_mpeg2_pic_ext),
> +	},
> +};
> +
> +guint8 get_extension_code(const GstMpegVideoPacket *packet)
> +{
> +	GstBitReader br;
> +	unsigned char extension_code;
> +
> +	gst_bit_reader_init(&br, &packet->data[packet->offset],
> packet->size);
> +	if (!gst_bit_reader_get_bits_uint8(&br, &extension_code, 4))
> {
> +		V4L2_LOG_ERR("failed to read extension code");
> +		return GST_MPEG_VIDEO_PACKET_NONE;
> +	}
> +
> +	return extension_code;
> +}
> +
> +unsigned int mpeg2_parse_metas(struct cparsers_au *au,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct v4l2_ext_control *me=
tas,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int *nb_of_metas)
> +{
> +	unsigned char extension_code;
> +	bool startcode_found =3D false;
> +	bool meta_found =3D false;
> +	GstMpegVideoPacket packet_data;
> +	unsigned int slice_index =3D 0;
> +	GstMpegVideoSequenceHdr gst_seq_hdr;
> +	GstMpegVideoSequenceExt gst_seq_ext;
> +	GstMpegVideoSequenceDisplayExt gst_seq_display_ext;
> +	GstMpegVideoQuantMatrixExt gst_seq_matrix_ext;
> +	GstMpegVideoPictureHdr gst_pic_hdr;
> +	GstMpegVideoPictureExt gst_pic_ext;
> +	struct v4l2_mpeg_video_mpeg2_seq_hdr *seq_hdr;
> +	struct v4l2_mpeg_video_mpeg2_seq_ext *seq_ext;
> +	struct v4l2_mpeg_video_mpeg2_seq_display_ext
> *seq_display_ext;
> +	struct v4l2_mpeg_video_mpeg2_seq_matrix_ext *seq_matrix_ext;
> +	struct v4l2_mpeg_video_mpeg2_pic_hdr *pic_hdrs[2];
> +	struct v4l2_mpeg_video_mpeg2_pic_ext *pic_exts[2];
> +
> +	if ((!au->addr) || (!au->bytesused) || (!au->metas_store) ||
> (!metas)) {
> +		V4L2_LOG_ERR("%s: invalid input: au->addr=3D%p, au-
> >bytesused=3D%d, au->metas_store=3D%p, metas=3D%p\n",
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__func__, au->addr, au->bytesused, au-
> >metas_store, metas);
> +		return 0;
> +	}
> +
> +	seq_hdr =3D au->metas_store[SEQ_HDR].ptr;
> +	seq_ext =3D au->metas_store[SEQ_EXT].ptr;
> +	seq_display_ext =3D au->metas_store[SEQ_DISPLAY_EXT].ptr;
> +	seq_matrix_ext =3D au->metas_store[SEQ_MATRIX_EXT].ptr;
> +	pic_hdrs[0] =3D au->metas_store[PIC_HDR].ptr;
> +	pic_hdrs[1] =3D au->metas_store[PIC_HDR + 1].ptr;
> +	pic_exts[0] =3D au->metas_store[PIC_EXT].ptr;
> +	pic_exts[1] =3D au->metas_store[PIC_EXT + 1].ptr;
> +
> +	memset(&packet_data, 0, sizeof(packet_data));
> +
> +	while (((packet_data.offset + 4) < au->bytesused)) {
> +		V4L2_LOG("%s: parsing input from offset=3D%d\n",
> __func__,
> +			=C2=A0packet_data.offset);
> +		startcode_found =3D gst_mpeg_video_parse(&packet_data,
> au->addr, au->bytesused, packet_data.offset);
> +		if (!startcode_found) {
> +			V4L2_LOG("%s: parsing is over\n", __func__);
> +			break;
> +		}
> +		/*
> +		=C2=A0* gst_mpeg_video_parse compute packet size by
> searching for next
> +		=C2=A0* startcode, but if next startcode is not found
> (end of access unit),
> +		=C2=A0* packet size is set to -1. We fix this here and
> set packet size
> +		=C2=A0* to remaining size in this case.
> +		=C2=A0*/
> +		if (packet_data.size < 0)
> +			packet_data.size =3D au->bytesused -
> packet_data.offset;
> +
> +		V4L2_LOG("%s: found startcode 0x%02x @offset=3D%u,
> size=3D%d\n",
> +			=C2=A0__func__, packet_data.type,
> packet_data.offset - 4, packet_data.size);
> +
> +		switch (packet_data.type) {
> +		case GST_MPEG_VIDEO_PACKET_PICTURE:
> +			if
> (gst_mpeg_video_packet_parse_picture_header
> +			=C2=A0=C2=A0=C2=A0=C2=A0(&packet_data, &gst_pic_hdr)) {
> +				struct v4l2_mpeg_video_mpeg2_pic_hdr
> *pic_hdr =3D pic_hdrs[slice_index];
> +
> +				metas[(*nb_of_metas)++] =3D au-
> >metas_store[PIC_HDR + slice_index];
> +
> +				memset(pic_hdr, 0,
> sizeof(*pic_hdr));
> +				pic_hdr->tsn =3D gst_pic_hdr.tsn;
> +				pic_hdr->pic_type =3D
> gst_pic_hdr.pic_type;
> +				pic_hdr->full_pel_forward_vector =3D
> gst_pic_hdr.full_pel_forward_vector;
> +				pic_hdr->full_pel_backward_vector =3D
> gst_pic_hdr.full_pel_backward_vector;
> +				memcpy(&pic_hdr->f_code,
> &gst_pic_hdr.f_code, sizeof(pic_hdr->f_code));
> +
> +				V4L2_LOG("%s: PICTURE HEADER\n",
> __func__);
> +				meta_found =3D true;
> +			}
> +			break;
> +
> +		case GST_MPEG_VIDEO_PACKET_SLICE_MIN:
> +			/* New slice encountered */
> +			if (slice_index > 1) {
> +				V4L2_LOG_ERR("%s: more than 2 slices
> detected @offset=3D%d, ignoring this slice...\n",
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__func__,
> packet_data.offset);
> +				break;
> +			}
> +			/* store its offset, including startcode */
> +			pic_hdrs[slice_index]->offset =3D
> packet_data.offset - 4;
> +			slice_index++;
> +
> +			V4L2_LOG("%s: START OF SLICE @ offset=3D%d\n",
> __func__, packet_data.offset);
> +			meta_found =3D true;
> +			goto done;
> +
> +			break;
> +
> +		case GST_MPEG_VIDEO_PACKET_USER_DATA:
> +			/* not implemented : do nothing */
> +			V4L2_LOG("%s: USER DATA, not implemented\n",
> __func__);
> +			break;
> +
> +		case GST_MPEG_VIDEO_PACKET_SEQUENCE:
> +			if
> (gst_mpeg_video_packet_parse_sequence_header
> +			=C2=A0=C2=A0=C2=A0=C2=A0(&packet_data, &gst_seq_hdr)) {
> +				metas[(*nb_of_metas)++] =3D au-
> >metas_store[SEQ_HDR];
> +
> +				memset(seq_hdr, 0,
> sizeof(*seq_hdr));
> +				seq_hdr->width =3D gst_seq_hdr.width;
> +				seq_hdr->height =3D
> gst_seq_hdr.height;
> +				seq_hdr->load_intra_quantiser_matrix=20
> =3D 1;
> +				memcpy(&seq_hdr-
> >intra_quantiser_matrix,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&gst_seq_hdr.intra_quantiz=
er_
> matrix,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sizeof(seq_hdr-
> >intra_quantiser_matrix));
> +				seq_hdr-
> >load_non_intra_quantiser_matrix =3D 1;
> +				memcpy(&seq_hdr-
> >non_intra_quantiser_matrix,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&gst_seq_hdr.non_intra_qua=
nti
> zer_matrix,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sizeof(seq_hdr-
> >non_intra_quantiser_matrix));
> +
> +				V4L2_LOG("%s: SEQUENCE HEADER\n",
> __func__);
> +				meta_found =3D true;
> +			}
> +			break;
> +
> +		case GST_MPEG_VIDEO_PACKET_EXTENSION:
> +			extension_code =3D
> get_extension_code(&packet_data);
> +			V4L2_LOG("%s: extension code=3D0x%02x=C2=A0=C2=A0\n",
> __func__, extension_code);
> +
> +			switch (extension_code) {
> +			case GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE:
> +				if
> (gst_mpeg_video_packet_parse_sequence_extension
> +				=C2=A0=C2=A0=C2=A0=C2=A0(&packet_data, &gst_seq_ext)) {
> +					metas[(*nb_of_metas)++] =3D
> au->metas_store[SEQ_EXT];
> +
> +					memset(seq_ext, 0,
> sizeof(*seq_ext));
> +					seq_ext->profile =3D
> gst_seq_ext.profile;
> +					seq_ext->level =3D
> gst_seq_ext.level;
> +					seq_ext->progressive =3D
> gst_seq_ext.progressive;
> +					seq_ext->chroma_format =3D
> gst_seq_ext.chroma_format;
> +					seq_ext->horiz_size_ext =3D
> gst_seq_ext.horiz_size_ext;
> +					seq_ext->vert_size_ext =3D
> gst_seq_ext.vert_size_ext;
> +
> +					V4L2_LOG("%s: SEQUENCE
> EXTENSION\n", __func__);
> +					meta_found =3D true;
> +				}
> +				break;
> +
> +			case
> GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_DISPLAY:
> +				if
> (gst_mpeg_video_packet_parse_sequence_display_extension
> +				=C2=A0=C2=A0=C2=A0=C2=A0(&packet_data,
> &gst_seq_display_ext)) {
> +					metas[(*nb_of_metas)++] =3D
> au->metas_store[SEQ_DISPLAY_EXT];
> +
> +					memset(seq_display_ext, 0,
> sizeof(*seq_display_ext));
> +					seq_display_ext-
> >video_format =3D gst_seq_display_ext.video_format;
> +					seq_display_ext-
> >colour_description_flag =3D
> gst_seq_display_ext.colour_description_flag;
> +					seq_display_ext-
> >colour_primaries =3D gst_seq_display_ext.colour_primaries;
> +					seq_display_ext-
> >transfer_characteristics =3D
> gst_seq_display_ext.transfer_characteristics;
> +					seq_display_ext-
> >matrix_coefficients =3D gst_seq_display_ext.matrix_coefficients;
> +					seq_display_ext-
> >display_horizontal_size =3D
> gst_seq_display_ext.display_horizontal_size;
> +					seq_display_ext-
> >display_vertical_size =3D gst_seq_display_ext.display_vertical_size;
> +
> +					V4L2_LOG("%s: SEQUENCE
> DISPLAY EXTENSION\n", __func__);
> +					meta_found =3D true;
> +				}
> +				break;
> +
> +			case GST_MPEG_VIDEO_PACKET_EXT_QUANT_MATRIX:
> +				if
> (gst_mpeg_video_packet_parse_quant_matrix_extension
> +				=C2=A0=C2=A0=C2=A0=C2=A0(&packet_data,
> &gst_seq_matrix_ext)) {
> +					metas[(*nb_of_metas)++] =3D
> au->metas_store[SEQ_DISPLAY_EXT];
> +
> +					memset(seq_matrix_ext, 0,
> sizeof(*seq_matrix_ext));
> +					seq_matrix_ext-
> >load_intra_quantiser_matrix =3D
> +						gst_seq_matrix_ext.l
> oad_intra_quantiser_matrix;
> +					memcpy(&seq_matrix_ext-
> >intra_quantiser_matrix,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&gst_seq_matrix_ext.i
> ntra_quantiser_matrix,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sizeof(seq_matrix_ext
> ->intra_quantiser_matrix));
> +					seq_matrix_ext-
> >load_non_intra_quantiser_matrix =3D
> +						gst_seq_matrix_ext.l
> oad_non_intra_quantiser_matrix;
> +					memcpy(&seq_matrix_ext-
> >non_intra_quantiser_matrix,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&gst_seq_matrix_ext.n
> on_intra_quantiser_matrix,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sizeof(seq_matrix_ext
> ->non_intra_quantiser_matrix));
> +					seq_matrix_ext-
> >load_chroma_intra_quantiser_matrix =3D
> +						gst_seq_matrix_ext.l
> oad_chroma_intra_quantiser_matrix;
> +					memcpy(&seq_matrix_ext-
> >chroma_intra_quantiser_matrix,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&gst_seq_matrix_ext.c
> hroma_intra_quantiser_matrix,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sizeof(seq_matrix_ext
> ->chroma_intra_quantiser_matrix));
> +					seq_matrix_ext-
> >load_chroma_non_intra_quantiser_matrix =3D
> +						gst_seq_matrix_ext.l
> oad_chroma_non_intra_quantiser_matrix;
> +					memcpy(&seq_matrix_ext-
> >chroma_non_intra_quantiser_matrix,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&gst_seq_matrix_ext.c
> hroma_non_intra_quantiser_matrix,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sizeof(seq_matrix_ext
> ->chroma_non_intra_quantiser_matrix));
> +
> +					V4L2_LOG("%s: SEQUENCE
> MATRIX EXTENSION\n", __func__);
> +					meta_found =3D true;
> +				}
> +				break;
> +
> +			case
> GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_SCALABLE:
> +				/* not implemented : do nothing */
> +				V4L2_LOG("%s: SEQUENCE SCALABLE
> EXTENSION, not implemented\n", __func__);
> +				break;
> +
> +			case GST_MPEG_VIDEO_PACKET_EXT_PICTURE:
> +				if
> (gst_mpeg_video_packet_parse_picture_extension
> +				=C2=A0=C2=A0=C2=A0=C2=A0(&packet_data, &gst_pic_ext)) {
> +					struct
> v4l2_mpeg_video_mpeg2_pic_ext *pic_ext =3D pic_exts[slice_index];
> +
> +					metas[(*nb_of_metas)++] =3D
> au->metas_store[PIC_EXT + slice_index];
> +
> +					memset(pic_ext, 0,
> sizeof(*pic_ext));
> +					memcpy(&pic_ext->f_code,
> &gst_pic_ext.f_code, sizeof(pic_ext->f_code));
> +					pic_ext->intra_dc_precision
> =3D gst_pic_ext.intra_dc_precision;
> +					pic_ext->picture_structure =3D
> gst_pic_ext.picture_structure;
> +					pic_ext->top_field_first =3D
> gst_pic_ext.top_field_first;
> +					pic_ext-
> >frame_pred_frame_dct =3D gst_pic_ext.frame_pred_frame_dct;
> +					pic_ext-
> >concealment_motion_vectors =3D gst_pic_ext.concealment_motion_vectors;
> +					pic_ext->q_scale_type =3D
> gst_pic_ext.q_scale_type;
> +					pic_ext->intra_vlc_format =3D
> gst_pic_ext.intra_vlc_format;
> +					pic_ext->alternate_scan =3D
> gst_pic_ext.alternate_scan;
> +					pic_ext->repeat_first_field
> =3D gst_pic_ext.repeat_first_field;
> +					pic_ext->chroma_420_type =3D
> gst_pic_ext.chroma_420_type;
> +					pic_ext->progressive_frame =3D
> gst_pic_ext.progressive_frame;
> +					pic_ext->composite_display =3D
> gst_pic_ext.composite_display;
> +					pic_ext->v_axis =3D
> gst_pic_ext.v_axis;
> +					pic_ext->field_sequence =3D
> gst_pic_ext.field_sequence;
> +					pic_ext->sub_carrier =3D
> gst_pic_ext.sub_carrier;
> +					pic_ext->burst_amplitude =3D
> gst_pic_ext.burst_amplitude;
> +					pic_ext->sub_carrier_phase =3D
> gst_pic_ext.sub_carrier_phase;
> +
> +					V4L2_LOG("%s: PICTURE
> EXTENSION, top_field_first=3D%d\n",
> +						=C2=A0__func__,
> pic_exts[slice_index]->top_field_first);
> +					meta_found =3D true;
> +				}
> +				break;
> +
> +			default:
> +				break;
> +			}
> +			break;
> +
> +		case GST_MPEG_VIDEO_PACKET_SEQUENCE_END:
> +			V4L2_LOG("%s: END OF PACKET SEQUENCE\n",
> __func__);
> +			break;
> +
> +		case GST_MPEG_VIDEO_PACKET_GOP:
> +			V4L2_LOG("%s: GOP\n", __func__);
> +			break;
> +
> +		default:
> +			V4L2_LOG("%s: unknown/unsupported header
> %02x\n",
> +				=C2=A0__func__, packet_data.type);
> +			break;
> +		}
> +	}
> +
> +done:
> +	return meta_found;
> +}
> +
> +const struct meta_parser mpeg2parse =3D {
> +	.name =3D "mpeg2",
> +	.streamformat =3D V4L2_PIX_FMT_MPEG2,
> +	.parsedformat =3D V4L2_PIX_FMT_MPEG2_PARSED,
> +	.nb_of_metas =3D sizeof(mpeg2_metas_store) /
> sizeof(mpeg2_metas_store[0]),
> +	.metas_store =3D mpeg2_metas_store,
> +	.parse_metas =3D mpeg2_parse_metas,
> +};
> +
> +const struct meta_parser mpeg1parse =3D {
> +	.name =3D "mpeg1",
> +	.streamformat =3D V4L2_PIX_FMT_MPEG1,
> +	.parsedformat =3D V4L2_PIX_FMT_MPEG1_PARSED,
> +	.nb_of_metas =3D sizeof(mpeg2_metas_store) /
> sizeof(mpeg2_metas_store[0]),
> +	.metas_store =3D mpeg2_metas_store,
> +	.parse_metas =3D mpeg2_parse_metas,
> +};
> diff --git a/lib/libv4l-codecparsers/libv4l-cparsers.c b/lib/libv4l-
> codecparsers/libv4l-cparsers.c
> index af59f50..4e8ae31 100644
> --- a/lib/libv4l-codecparsers/libv4l-cparsers.c
> +++ b/lib/libv4l-codecparsers/libv4l-cparsers.c
> @@ -46,7 +46,11 @@
> =C2=A0#endif
> =C2=A0
> =C2=A0/* available parsers */
> +extern const struct meta_parser mpeg1parse;
> +extern const struct meta_parser mpeg2parse;
> =C2=A0const struct meta_parser *parsers[] =3D {
> +	&mpeg1parse,
> +	&mpeg2parse,
> =C2=A0};
> =C2=A0
> =C2=A0static void *plugin_init(int fd)
--=-houRi0CakQSBlRR2jOzl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlkHcnIACgkQcVMCLawGqBzj6gCeO5jImKuNfjNpOg7t1zqNAaHt
nwEAoM0de043xy1q/mc41BC1ATRxCUtf
=tUb7
-----END PGP SIGNATURE-----

--=-houRi0CakQSBlRR2jOzl--
