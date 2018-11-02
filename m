Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35704 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbeKCCis (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 22:38:48 -0400
Message-ID: <3d25edc55cfd6e3448a2beb48eafbc45d64bdc1f.camel@collabora.com>
Subject: Re: [RFC v2 1/4] media: Introduce helpers to fill pixel format
 structs
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Tomasz Figa <tfiga@chromium.org>
Date: Fri, 02 Nov 2018 13:30:46 -0400
In-Reply-To: <20181102155206.13681-2-ezequiel@collabora.com>
References: <20181102155206.13681-1-ezequiel@collabora.com>
         <20181102155206.13681-2-ezequiel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-ovTe79iqXN4+nvFNjC9L"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ovTe79iqXN4+nvFNjC9L
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 02 novembre 2018 =C3=A0 12:52 -0300, Ezequiel Garcia a =C3=A9cr=
it :
> Add two new API helpers, v4l2_fill_pixfmt and v4l2_fill_pixfmt_mp,
> to be used by drivers to calculate plane sizes and bytes per lines.
>=20
> Note that driver-specific paddig and alignment are not yet
> taken into account.
>=20
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/v4l2-core/Makefile      |  2 +-
>  drivers/media/v4l2-core/v4l2-common.c | 66 +++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-fourcc.c | 93 +++++++++++++++++++++++++++
>  include/media/v4l2-common.h           |  5 ++
>  include/media/v4l2-fourcc.h           | 53 +++++++++++++++
>  5 files changed, 218 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-fourcc.c
>  create mode 100644 include/media/v4l2-fourcc.h
>=20
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/M=
akefile
> index 9ee57e1efefe..bc23c3407c17 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -7,7 +7,7 @@ tuner-objs	:=3D	tuner-core.o
> =20
>  videodev-objs	:=3D	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
>  			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
> -			v4l2-async.o
> +			v4l2-async.o v4l2-fourcc.o
>  ifeq ($(CONFIG_COMPAT),y)
>    videodev-objs +=3D v4l2-compat-ioctl32.o
>  endif
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-c=
ore/v4l2-common.c
> index 50763fb42a1b..97bb51d15188 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -61,6 +61,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-fourcc.h>
> =20
>  #include <linux/videodev2.h>
> =20
> @@ -455,3 +456,68 @@ int v4l2_s_parm_cap(struct video_device *vdev,
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_s_parm_cap);
> +
> +void v4l2_fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt, int pixe=
lformat, int width, int height)

My first impression is that this code expects width/height to be
aligned to the sub-sampling. Hence, I don't think it works for odd
width/height. It would be nice to document the constraint, specially
that this will lead to under-allocation due to the lack of round up.

> +{
> +	const struct v4l2_format_info *info;
> +	struct v4l2_plane_pix_format *plane;
> +	int i;
> +
> +	info =3D v4l2_format_info(pixelformat);
> +	if (!info)
> +		return;
> +
> +	pixfmt->width =3D width;
> +	pixfmt->height =3D height;
> +	pixfmt->pixelformat =3D pixelformat;
> +
> +	if (info->has_contiguous_planes) {
> +		pixfmt->num_planes =3D 1;
> +		plane =3D &pixfmt->plane_fmt[0];
> +		plane->bytesperline =3D info->is_compressed ?
> +					0 : width * info->cpp[0];
> +		plane->sizeimage =3D info->header_size;
> +		for (i =3D 0; i < info->num_planes; i++) {
> +			unsigned int hsub =3D (i =3D=3D 0) ? 1 : info->hsub;
> +			unsigned int vsub =3D (i =3D=3D 0) ? 1 : info->vsub;
> +
> +			plane->sizeimage +=3D width * height * info->cpp[i] / (hsub * vsub);
> +		}
> +	} else {
> +		pixfmt->num_planes =3D info->num_planes;
> +		for (i =3D 0; i < info->num_planes; i++) {
> +			unsigned int hsub =3D (i =3D=3D 0) ? 1 : info->hsub;
> +			unsigned int vsub =3D (i =3D=3D 0) ? 1 : info->vsub;
> +
> +			plane =3D &pixfmt->plane_fmt[i];
> +			plane->bytesperline =3D width * info->cpp[i] / hsub;
> +			plane->sizeimage =3D width * height * info->cpp[i] / (hsub * vsub);
> +		}
> +	}
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt_mp);
> +
> +void v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat, i=
nt width, int height)
> +{
> +	const struct v4l2_format_info *info;
> +	char name[32];
> +	int i;
> +
> +	pixfmt->width =3D width;
> +	pixfmt->height =3D height;
> +	pixfmt->pixelformat =3D pixelformat;
> +
> +	info =3D v4l2_format_info(pixelformat);
> +	if (!info)
> +		return;
> +	pixfmt->bytesperline =3D info->is_compressed ? 0 : width * info->cpp[0]=
;
> +
> +	pixfmt->sizeimage =3D info->header_size;
> +	for (i =3D 0; i < info->num_planes; i++) {
> +		unsigned int hsub =3D (i =3D=3D 0) ? 1 : info->hsub;
> +		unsigned int vsub =3D (i =3D=3D 0) ? 1 : info->vsub;
> +
> +		pixfmt->sizeimage +=3D width * height * info->cpp[i] / (hsub * vsub);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt);
> diff --git a/drivers/media/v4l2-core/v4l2-fourcc.c b/drivers/media/v4l2-c=
ore/v4l2-fourcc.c
> new file mode 100644
> index 000000000000..4e8a15525b58
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-fourcc.c
> @@ -0,0 +1,93 @@
> +/*
> + * Copyright (c) 2018 Collabora, Ltd.
> + *
> + * Based on drm-fourcc:
> + * Copyright (c) 2016 Laurent Pinchart <laurent.pinchart@ideasonboard.co=
m>
> + *
> + * Permission to use, copy, modify, distribute, and sell this software a=
nd its
> + * documentation for any purpose is hereby granted without fee, provided=
 that
> + * the above copyright notice appear in all copies and that both that co=
pyright
> + * notice and this permission notice appear in supporting documentation,=
 and
> + * that the name of the copyright holders not be used in advertising or
> + * publicity pertaining to distribution of the software without specific=
,
> + * written prior permission.  The copyright holders make no representati=
ons
> + * about the suitability of this software for any purpose.  It is provid=
ed "as
> + * is" without express or implied warranty.
> + *
> + * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOF=
TWARE,
> + * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN N=
O
> + * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT=
 OR
> + * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS O=
F USE,
> + * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHE=
R
> + * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERF=
ORMANCE
> + * OF THIS SOFTWARE.
> + */
> +
> +#include <linux/ctype.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-fourcc.h>
> +#include "../platform/vicodec/codec-fwht.h"
> +
> +#if 0
> +static char printable_char(int c)
> +{
> +	return isascii(c) && isprint(c) ? c : '?';
> +}
> +
> +static const char *v4l2_get_format_name(uint32_t format, char *buf, size=
_t len)
> +{
> +	snprintf(buf, len,
> +		 "%c%c%c%c %s-endian (0x%08x)",
> +		 printable_char(format & 0xff),
> +		 printable_char((format >> 8) & 0xff),
> +		 printable_char((format >> 16) & 0xff),
> +		 printable_char((format >> 24) & 0x7f),
> +		 format & BIT(31) ? "big" : "little",
> +		 format);
> +
> +	return buf;
> +}
> +#endif
> +
> +const struct v4l2_format_info *v4l2_format_info(u32 format)
> +{
> +	static const struct v4l2_format_info formats[] =3D {
> +		/* RGB formats */
> +		{ .format =3D V4L2_PIX_FMT_BGR24,		.num_planes =3D 1, .cpp =3D { 3, 0,=
 0 }, .hsub =3D 1, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_RGB24,		.num_planes =3D 1, .cpp =3D { 3, 0,=
 0 }, .hsub =3D 1, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_BGR32,		.num_planes =3D 1, .cpp =3D { 4, 0,=
 0 }, .hsub =3D 1, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_XBGR32,	.num_planes =3D 1, .cpp =3D { 4, 0,=
 0 }, .hsub =3D 1, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_RGB32,		.num_planes =3D 1, .cpp =3D { 4, 0,=
 0 }, .hsub =3D 1, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_XRGB32,	.num_planes =3D 1, .cpp =3D { 4, 0,=
 0 }, .hsub =3D 1, .vsub =3D 1 },
> +
> +		/* YUV formats */
> +		{ .format =3D V4L2_PIX_FMT_YUV420,	.num_planes =3D 3, .cpp =3D { 1, 1,=
 1 }, .hsub =3D 2, .vsub =3D 2 },
> +		{ .format =3D V4L2_PIX_FMT_YVU420,	.num_planes =3D 3, .cpp =3D { 1, 1,=
 1 }, .hsub =3D 2, .vsub =3D 2 },
> +		{ .format =3D V4L2_PIX_FMT_YUV422P,	.num_planes =3D 3, .cpp =3D { 1, 1=
, 1 }, .hsub =3D 2, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_NV12,		.num_planes =3D 2, .cpp =3D { 1, 2, =
0 }, .hsub =3D 2, .vsub =3D 2 },
> +		{ .format =3D V4L2_PIX_FMT_NV21,		.num_planes =3D 2, .cpp =3D { 1, 2, =
0 }, .hsub =3D 2, .vsub =3D 2 },
> +		{ .format =3D V4L2_PIX_FMT_NV16,		.num_planes =3D 2, .cpp =3D { 1, 2, =
0 }, .hsub =3D 2, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_NV61,		.num_planes =3D 2, .cpp =3D { 1, 2, =
0 }, .hsub =3D 2, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_NV24,		.num_planes =3D 2, .cpp =3D { 1, 2, =
0 }, .hsub =3D 1, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_NV42,		.num_planes =3D 2, .cpp =3D { 1, 2, =
0 }, .hsub =3D 1, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_YUYV,		.num_planes =3D 1, .cpp =3D { 2, 0, =
0 }, .hsub =3D 2, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_YVYU,		.num_planes =3D 1, .cpp =3D { 2, 0, =
0 }, .hsub =3D 2, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_UYVY,		.num_planes =3D 1, .cpp =3D { 2, 0, =
0 }, .hsub =3D 2, .vsub =3D 1 },
> +		{ .format =3D V4L2_PIX_FMT_VYUY,		.num_planes =3D 1, .cpp =3D { 2, 0, =
0 }, .hsub =3D 2, .vsub =3D 1 },
> +
> +		/* Compressed formats */
> +		{ .format =3D V4L2_PIX_FMT_FWHT,		.num_planes =3D 1, .cpp =3D { 3, 0, =
0 }, .header_size =3D sizeof(struct fwht_cframe_hdr), .is_compressed =3D tr=
ue },
> +	};
> +
> +	unsigned int i;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(formats); ++i) {
> +		if (formats[i].format =3D=3D format)
> +			return &formats[i];
> +	}
> +
> +	pr_warn("Unsupported V4L 4CC format (%08x)\n", format);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(v4l2_format_info);
> +
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 82715645617b..45959a6e140e 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -396,4 +396,9 @@ int v4l2_g_parm_cap(struct video_device *vdev,
>  int v4l2_s_parm_cap(struct video_device *vdev,
>  		    struct v4l2_subdev *sd, struct v4l2_streamparm *a);
> =20
> +void v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat,
> +		      int width, int height);
> +void v4l2_fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt, int pixe=
lformat,
> +			 int width, int height);
> +
>  #endif /* V4L2_COMMON_H_ */
> diff --git a/include/media/v4l2-fourcc.h b/include/media/v4l2-fourcc.h
> new file mode 100644
> index 000000000000..9f6c1ba8907e
> --- /dev/null
> +++ b/include/media/v4l2-fourcc.h
> @@ -0,0 +1,53 @@
> +/*
> + * Copyright (c) 2018 Collabora, Ltd.
> + *
> + * Based on drm-fourcc:
> + * Copyright (c) 2016 Laurent Pinchart <laurent.pinchart@ideasonboard.co=
m>
> + *
> + * Permission to use, copy, modify, distribute, and sell this software a=
nd its
> + * documentation for any purpose is hereby granted without fee, provided=
 that
> + * the above copyright notice appear in all copies and that both that co=
pyright
> + * notice and this permission notice appear in supporting documentation,=
 and
> + * that the name of the copyright holders not be used in advertising or
> + * publicity pertaining to distribution of the software without specific=
,
> + * written prior permission.  The copyright holders make no representati=
ons
> + * about the suitability of this software for any purpose.  It is provid=
ed "as
> + * is" without express or implied warranty.
> + *
> + * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOF=
TWARE,
> + * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN N=
O
> + * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT=
 OR
> + * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS O=
F USE,
> + * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHE=
R
> + * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERF=
ORMANCE
> + * OF THIS SOFTWARE.
> + */
> +#ifndef __V4L2_FOURCC_H__
> +#define __V4L2_FOURCC_H__
> +
> +#include <linux/types.h>
> +
> +/**
> + * struct v4l2_format_info - information about a V4L2 format
> + * @format: 4CC format identifier (V4L2_PIX_FMT_*)
> + * @header_size: Size of header, optional and used by compressed formats
> + * @num_planes: Number of planes (1 to 3)
> + * @cpp: Number of bytes per pixel (per plane)
> + * @hsub: Horizontal chroma subsampling factor
> + * @vsub: Vertical chroma subsampling factor
> + * @is_compressed: Is it a compressed format?
> + */
> +struct v4l2_format_info {
> +	u32 format;
> +	u32 header_size;
> +	u8 num_planes;
> +	u8 cpp[3];
> +	u8 hsub;
> +	u8 vsub;
> +	bool is_compressed;
> +	bool has_contiguous_planes;
> +};
> +
> +const struct v4l2_format_info *v4l2_format_info(u32 format);
> +
> +#endif

--=-ovTe79iqXN4+nvFNjC9L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW9yJxgAKCRBxUwItrAao
HH5UAKC7KaNz8TYQ01+43mJr1a3QaWb66gCgmxrxjCx/IejeHIao645NqB1EKk0=
=FX8V
-----END PGP SIGNATURE-----

--=-ovTe79iqXN4+nvFNjC9L--
