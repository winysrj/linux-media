Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45642 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbeKJVE0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 16:04:26 -0500
Message-ID: <be100a8561c73cfac2d0c6bff8bd3856e435ac7c.camel@collabora.com>
Subject: Re: [RFC v2 1/4] media: Introduce helpers to fill pixel format
 structs
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>
Date: Sat, 10 Nov 2018 08:19:37 -0300
In-Reply-To: <20181102155206.13681-2-ezequiel@collabora.com>
References: <20181102155206.13681-1-ezequiel@collabora.com>
         <20181102155206.13681-2-ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-11-02 at 12:52 -0300, Ezequiel Garcia wrote:
> Add two new API helpers, v4l2_fill_pixfmt and v4l2_fill_pixfmt_mp,
> to be used by drivers to calculate plane sizes and bytes per lines.
> 
> Note that driver-specific paddig and alignment are not yet
> taken into account.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---

Heads-up: I plan to submit a new version of this patch, as part of
the VPU JPEG patchset.

Thanks,
Ezequiel

>  drivers/media/v4l2-core/Makefile      |  2 +-
>  drivers/media/v4l2-core/v4l2-common.c | 66 +++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-fourcc.c | 93 +++++++++++++++++++++++++++
>  include/media/v4l2-common.h           |  5 ++
>  include/media/v4l2-fourcc.h           | 53 +++++++++++++++
>  5 files changed, 218 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-fourcc.c
>  create mode 100644 include/media/v4l2-fourcc.h
> 
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index 9ee57e1efefe..bc23c3407c17 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -7,7 +7,7 @@ tuner-objs	:=	tuner-core.o
>  
>  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
>  			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
> -			v4l2-async.o
> +			v4l2-async.o v4l2-fourcc.o
>  ifeq ($(CONFIG_COMPAT),y)
>    videodev-objs += v4l2-compat-ioctl32.o
>  endif
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index 50763fb42a1b..97bb51d15188 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -61,6 +61,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-fourcc.h>
>  
>  #include <linux/videodev2.h>
>  
> @@ -455,3 +456,68 @@ int v4l2_s_parm_cap(struct video_device *vdev,
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_s_parm_cap);
> +
> +void v4l2_fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt, int pixelformat, int width, int height)
> +{
> +	const struct v4l2_format_info *info;
> +	struct v4l2_plane_pix_format *plane;
> +	int i;
> +
> +	info = v4l2_format_info(pixelformat);
> +	if (!info)
> +		return;
> +
> +	pixfmt->width = width;
> +	pixfmt->height = height;
> +	pixfmt->pixelformat = pixelformat;
> +
> +	if (info->has_contiguous_planes) {
> +		pixfmt->num_planes = 1;
> +		plane = &pixfmt->plane_fmt[0];
> +		plane->bytesperline = info->is_compressed ?
> +					0 : width * info->cpp[0];
> +		plane->sizeimage = info->header_size;
> +		for (i = 0; i < info->num_planes; i++) {
> +			unsigned int hsub = (i == 0) ? 1 : info->hsub;
> +			unsigned int vsub = (i == 0) ? 1 : info->vsub;
> +
> +			plane->sizeimage += width * height * info->cpp[i] / (hsub * vsub);
> +		}
> +	} else {
> +		pixfmt->num_planes = info->num_planes;
> +		for (i = 0; i < info->num_planes; i++) {
> +			unsigned int hsub = (i == 0) ? 1 : info->hsub;
> +			unsigned int vsub = (i == 0) ? 1 : info->vsub;
> +
> +			plane = &pixfmt->plane_fmt[i];
> +			plane->bytesperline = width * info->cpp[i] / hsub;
> +			plane->sizeimage = width * height * info->cpp[i] / (hsub * vsub);
> +		}
> +	}
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt_mp);
> +
> +void v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat, int width, int height)
> +{
> +	const struct v4l2_format_info *info;
> +	char name[32];
> +	int i;
> +
> +	pixfmt->width = width;
> +	pixfmt->height = height;
> +	pixfmt->pixelformat = pixelformat;
> +
> +	info = v4l2_format_info(pixelformat);
> +	if (!info)
> +		return;
> +	pixfmt->bytesperline = info->is_compressed ? 0 : width * info->cpp[0];
> +
> +	pixfmt->sizeimage = info->header_size;
> +	for (i = 0; i < info->num_planes; i++) {
> +		unsigned int hsub = (i == 0) ? 1 : info->hsub;
> +		unsigned int vsub = (i == 0) ? 1 : info->vsub;
> +
> +		pixfmt->sizeimage += width * height * info->cpp[i] / (hsub * vsub);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt);
> diff --git a/drivers/media/v4l2-core/v4l2-fourcc.c b/drivers/media/v4l2-core/v4l2-fourcc.c
> new file mode 100644
> index 000000000000..4e8a15525b58
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-fourcc.c
> @@ -0,0 +1,93 @@
> +/*
> + * Copyright (c) 2018 Collabora, Ltd.
> + *
> + * Based on drm-fourcc:
> + * Copyright (c) 2016 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * Permission to use, copy, modify, distribute, and sell this software and its
> + * documentation for any purpose is hereby granted without fee, provided that
> + * the above copyright notice appear in all copies and that both that copyright
> + * notice and this permission notice appear in supporting documentation, and
> + * that the name of the copyright holders not be used in advertising or
> + * publicity pertaining to distribution of the software without specific,
> + * written prior permission.  The copyright holders make no representations
> + * about the suitability of this software for any purpose.  It is provided "as
> + * is" without express or implied warranty.
> + *
> + * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
> + * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
> + * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
> + * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
> + * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
> + * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
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
> +static const char *v4l2_get_format_name(uint32_t format, char *buf, size_t len)
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
> +	static const struct v4l2_format_info formats[] = {
> +		/* RGB formats */
> +		{ .format = V4L2_PIX_FMT_BGR24,		.num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_RGB24,		.num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_BGR32,		.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_XBGR32,	.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_RGB32,		.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_XRGB32,	.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +
> +		/* YUV formats */
> +		{ .format = V4L2_PIX_FMT_YUV420,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2 },
> +		{ .format = V4L2_PIX_FMT_YVU420,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2 },
> +		{ .format = V4L2_PIX_FMT_YUV422P,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_NV12,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2 },
> +		{ .format = V4L2_PIX_FMT_NV21,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2 },
> +		{ .format = V4L2_PIX_FMT_NV16,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_NV61,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_NV24,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_NV42,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_YUYV,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_YVYU,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_UYVY,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_VYUY,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
> +
> +		/* Compressed formats */
> +		{ .format = V4L2_PIX_FMT_FWHT,		.num_planes = 1, .cpp = { 3, 0, 0 }, .header_size = sizeof(struct fwht_cframe_hdr),
> .is_compressed = true },
> +	};
> +
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
> +		if (formats[i].format == format)
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
>  
> +void v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat,
> +		      int width, int height);
> +void v4l2_fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt, int pixelformat,
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
> + * Copyright (c) 2016 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * Permission to use, copy, modify, distribute, and sell this software and its
> + * documentation for any purpose is hereby granted without fee, provided that
> + * the above copyright notice appear in all copies and that both that copyright
> + * notice and this permission notice appear in supporting documentation, and
> + * that the name of the copyright holders not be used in advertising or
> + * publicity pertaining to distribution of the software without specific,
> + * written prior permission.  The copyright holders make no representations
> + * about the suitability of this software for any purpose.  It is provided "as
> + * is" without express or implied warranty.
> + *
> + * THE COPYRIGHT HOLDERS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
> + * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
> + * EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
> + * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
> + * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
> + * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
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
