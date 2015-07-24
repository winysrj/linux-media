Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34539 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125AbbGXO4z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 10:56:55 -0400
Message-ID: <55B251EB.3030701@xs4all.nl>
Date: Fri, 24 Jul 2015 16:55:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>,
	Ian Molton <imolton@ad-holdings.co.uk>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
	Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v3 4/5] [media] imx-ipu: Add ipu media common code
References: <1437063883-23981-1-git-send-email-p.zabel@pengutronix.de> <1437063883-23981-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1437063883-23981-5-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philip,

A quick review:

On 07/16/2015 06:24 PM, Philipp Zabel wrote:
> From: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Add video4linux API routines common to drivers for units that
> accept or provide video data via the i.MX IPU IDMAC channels,
> such as scaler or deinterlacer drivers.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/Kconfig       |   2 +
>  drivers/media/platform/Makefile      |   1 +
>  drivers/media/platform/imx/Kconfig   |   2 +
>  drivers/media/platform/imx/Makefile  |   1 +
>  drivers/media/platform/imx/imx-ipu.c | 313 +++++++++++++++++++++++++++++++++++
>  drivers/media/platform/imx/imx-ipu.h |  35 ++++

A MAINTAINERS entry is needed.

>  6 files changed, 354 insertions(+)
>  create mode 100644 drivers/media/platform/imx/Kconfig
>  create mode 100644 drivers/media/platform/imx/Makefile
>  create mode 100644 drivers/media/platform/imx/imx-ipu.c
>  create mode 100644 drivers/media/platform/imx/imx-ipu.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index f6bed19..66c8d91 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -29,6 +29,8 @@ config VIDEO_VIA_CAMERA
>  
>  source "drivers/media/platform/davinci/Kconfig"
>  
> +source "drivers/media/platform/imx/Kconfig"
> +
>  source "drivers/media/platform/omap/Kconfig"
>  
>  source "drivers/media/platform/blackfin/Kconfig"
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 114f9ab..c3438c2 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -46,6 +46,7 @@ obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
>  
>  obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
>  
> +obj-y	+= imx/
>  obj-y	+= omap/
>  
>  obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
> diff --git a/drivers/media/platform/imx/Kconfig b/drivers/media/platform/imx/Kconfig
> new file mode 100644
> index 0000000..a90c973
> --- /dev/null
> +++ b/drivers/media/platform/imx/Kconfig
> @@ -0,0 +1,2 @@
> +config VIDEO_IMX_IPU_COMMON
> +	tristate
> diff --git a/drivers/media/platform/imx/Makefile b/drivers/media/platform/imx/Makefile
> new file mode 100644
> index 0000000..5de119c
> --- /dev/null
> +++ b/drivers/media/platform/imx/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_IMX_IPU_COMMON)	+= imx-ipu.o
> diff --git a/drivers/media/platform/imx/imx-ipu.c b/drivers/media/platform/imx/imx-ipu.c
> new file mode 100644
> index 0000000..c1b8637
> --- /dev/null
> +++ b/drivers/media/platform/imx/imx-ipu.c
> @@ -0,0 +1,313 @@
> +/*
> + * i.MX IPUv3 common v4l2 support
> + *
> + * Copyright (C) 2011 Sascha Hauer, Pengutronix
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/module.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include "imx-ipu.h"
> +
> +static struct ipu_fmt ipu_fmt_yuv[] = {
> +	{
> +		.fourcc = V4L2_PIX_FMT_YUV420,
> +		.name = "YUV 4:2:0 planar, YCbCr",
> +		.bytes_per_pixel = 1,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YVU420,
> +		.name = "YUV 4:2:0 planar, YCrCb",
> +		.bytes_per_pixel = 1,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUV422P,
> +		.name = "YUV 4:2:2 planar, YCbCr",
> +		.bytes_per_pixel = 1,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV12,
> +		.name = "YUV 4:2:0 partial interleaved, YCbCr",
> +		.bytes_per_pixel = 1,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_UYVY,
> +		.name = "4:2:2, packed, UYVY",
> +		.bytes_per_pixel = 2,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUYV,
> +		.name = "4:2:2, packed, YUYV",
> +		.bytes_per_pixel = 2,

Drop .name from this struct. The v4l2 core will fill this in ensuring consistent
naming.

> +	},
> +};
> +
> +static struct ipu_fmt ipu_fmt_rgb[] = {
> +	{
> +		.fourcc = V4L2_PIX_FMT_RGB32,
> +		.name = "RGB888",
> +		.bytes_per_pixel = 4,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_RGB24,
> +		.name = "RGB24",
> +		.bytes_per_pixel = 3,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_BGR24,
> +		.name = "BGR24",
> +		.bytes_per_pixel = 3,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_RGB565,
> +		.name = "RGB565",
> +		.bytes_per_pixel = 2,
> +	},
> +	{
> +		.fourcc = V4L2_PIX_FMT_BGR32,
> +		.name = "BGR888",
> +		.bytes_per_pixel = 4,
> +	},
> +};
> +
> +struct ipu_fmt *ipu_find_fmt_yuv(unsigned int pixelformat)
> +{
> +	struct ipu_fmt *fmt;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ipu_fmt_yuv); i++) {
> +		fmt = &ipu_fmt_yuv[i];
> +		if (fmt->fourcc == pixelformat)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(ipu_find_fmt_yuv);
> +
> +struct ipu_fmt *ipu_find_fmt_rgb(unsigned int pixelformat)
> +{
> +	struct ipu_fmt *fmt;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ipu_fmt_rgb); i++) {
> +		fmt = &ipu_fmt_rgb[i];
> +		if (fmt->fourcc == pixelformat)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(ipu_find_fmt_rgb);
> +
> +static struct ipu_fmt *ipu_find_fmt(unsigned long pixelformat)
> +{
> +	struct ipu_fmt *fmt;
> +
> +	fmt = ipu_find_fmt_yuv(pixelformat);
> +	if (fmt)
> +		return fmt;
> +	fmt = ipu_find_fmt_rgb(pixelformat);
> +
> +	return fmt;
> +}
> +EXPORT_SYMBOL_GPL(ipu_find_fmt);
> +
> +int ipu_try_fmt(struct file *file, void *fh,
> +		struct v4l2_format *f)
> +{
> +	struct ipu_fmt *fmt;
> +
> +	v4l_bound_align_image(&f->fmt.pix.width, 8, 4096, 2,
> +			      &f->fmt.pix.height, 2, 4096, 1, 0);
> +
> +	f->fmt.pix.field = V4L2_FIELD_NONE;
> +
> +	fmt = ipu_find_fmt(f->fmt.pix.pixelformat);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	f->fmt.pix.bytesperline = f->fmt.pix.width * fmt->bytes_per_pixel;
> +	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * f->fmt.pix.height;
> +	if (fmt->fourcc == V4L2_PIX_FMT_YUV420 ||
> +	    fmt->fourcc == V4L2_PIX_FMT_YVU420 ||
> +	    fmt->fourcc == V4L2_PIX_FMT_NV12)
> +		f->fmt.pix.sizeimage = f->fmt.pix.sizeimage * 3 / 2;
> +	else if (fmt->fourcc == V4L2_PIX_FMT_YUV422P)
> +		f->fmt.pix.sizeimage *= 2;

Do you need to set colorspace as well? Or will that be done by the driver
that calls this function?

> +
> +	f->fmt.pix.priv = 0;

The priv assignment is no longer needed and can be dropped.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_try_fmt);
> +
> +int ipu_try_fmt_rgb(struct file *file, void *fh,
> +		struct v4l2_format *f)
> +{
> +	struct ipu_fmt *fmt;
> +
> +	fmt = ipu_find_fmt_rgb(f->fmt.pix.pixelformat);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	return ipu_try_fmt(file, fh, f);
> +}
> +EXPORT_SYMBOL_GPL(ipu_try_fmt_rgb);
> +
> +int ipu_try_fmt_yuv(struct file *file, void *fh,
> +		struct v4l2_format *f)
> +{
> +	struct ipu_fmt *fmt;
> +
> +	fmt = ipu_find_fmt_yuv(f->fmt.pix.pixelformat);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	return ipu_try_fmt(file, fh, f);
> +}
> +EXPORT_SYMBOL_GPL(ipu_try_fmt_yuv);
> +
> +int ipu_enum_fmt_rgb(struct file *file, void *fh,
> +		struct v4l2_fmtdesc *f)
> +{
> +	struct ipu_fmt *fmt;
> +
> +	if (f->index >= ARRAY_SIZE(ipu_fmt_rgb))
> +		return -EINVAL;
> +
> +	fmt = &ipu_fmt_rgb[f->index];
> +
> +	strlcpy(f->description, fmt->name, sizeof(f->description));

Drop this, there is no more need to fill in the description.

> +	f->pixelformat = fmt->fourcc;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_enum_fmt_rgb);
> +
> +int ipu_enum_fmt_yuv(struct file *file, void *fh,
> +		struct v4l2_fmtdesc *f)
> +{
> +	struct ipu_fmt *fmt;
> +
> +	if (f->index >= ARRAY_SIZE(ipu_fmt_yuv))
> +		return -EINVAL;
> +
> +	fmt = &ipu_fmt_yuv[f->index];
> +
> +	strlcpy(f->description, fmt->name, sizeof(f->description));

Ditto.

> +	f->pixelformat = fmt->fourcc;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_enum_fmt_yuv);
> +
> +int ipu_enum_fmt(struct file *file, void *fh,
> +		struct v4l2_fmtdesc *f)
> +{
> +	struct ipu_fmt *fmt;
> +	int index = f->index;
> +
> +	if (index >= ARRAY_SIZE(ipu_fmt_yuv)) {
> +		index -= ARRAY_SIZE(ipu_fmt_yuv);
> +		if (index >= ARRAY_SIZE(ipu_fmt_rgb))
> +			return -EINVAL;
> +		fmt = &ipu_fmt_rgb[index];
> +	} else {
> +		fmt = &ipu_fmt_yuv[index];
> +	}
> +
> +	strlcpy(f->description, fmt->name, sizeof(f->description));
> +	f->pixelformat = fmt->fourcc;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_enum_fmt);
> +
> +int ipu_s_fmt(struct file *file, void *fh,
> +		struct v4l2_format *f, struct v4l2_pix_format *pix)
> +{
> +	int ret;
> +
> +	ret = ipu_try_fmt(file, fh, f);
> +	if (ret)
> +		return ret;
> +
> +	pix->width = f->fmt.pix.width;
> +	pix->height = f->fmt.pix.height;
> +	pix->pixelformat = f->fmt.pix.pixelformat;
> +	pix->bytesperline = f->fmt.pix.bytesperline;
> +	pix->sizeimage = f->fmt.pix.sizeimage;
> +	pix->colorspace = f->fmt.pix.colorspace;

Why not do *pix = f->fmt.pix?

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_s_fmt);
> +
> +int ipu_s_fmt_rgb(struct file *file, void *fh,
> +		struct v4l2_format *f, struct v4l2_pix_format *pix)
> +{
> +	struct ipu_fmt *fmt;
> +
> +	fmt = ipu_find_fmt_rgb(f->fmt.pix.pixelformat);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	return ipu_s_fmt(file, fh, f, pix);
> +}
> +EXPORT_SYMBOL_GPL(ipu_s_fmt_rgb);
> +
> +int ipu_s_fmt_yuv(struct file *file, void *fh,
> +		struct v4l2_format *f, struct v4l2_pix_format *pix)
> +{
> +	struct ipu_fmt *fmt;
> +
> +	fmt = ipu_find_fmt_yuv(f->fmt.pix.pixelformat);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	return ipu_s_fmt(file, fh, f, pix);
> +}
> +EXPORT_SYMBOL_GPL(ipu_s_fmt_yuv);
> +
> +int ipu_g_fmt(struct v4l2_format *f, struct v4l2_pix_format *pix)
> +{
> +	f->fmt.pix.field = V4L2_FIELD_NONE;
> +	f->fmt.pix.pixelformat = pix->pixelformat;
> +	f->fmt.pix.bytesperline = pix->bytesperline;
> +	f->fmt.pix.width = pix->width;
> +	f->fmt.pix.height = pix->height;
> +	f->fmt.pix.sizeimage = pix->sizeimage;
> +	f->fmt.pix.colorspace = pix->colorspace;
> +	f->fmt.pix.priv = 0;

Why not do f->fmt.pix = *pix?

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_g_fmt);
> +
> +int ipu_enum_framesizes(struct file *file, void *fh,
> +			struct v4l2_frmsizeenum *fsize)
> +{
> +	struct ipu_fmt *fmt;
> +
> +	if (fsize->index != 0)
> +		return -EINVAL;
> +
> +	fmt = ipu_find_fmt(fsize->pixel_format);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	fsize->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
> +	fsize->stepwise.min_width = 1;
> +	fsize->stepwise.min_height = 1;
> +	fsize->stepwise.max_width = 4096;
> +	fsize->stepwise.max_height = 4096;
> +	fsize->stepwise.step_width = fsize->stepwise.step_height = 1;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_enum_framesizes);
> +
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/platform/imx/imx-ipu.h b/drivers/media/platform/imx/imx-ipu.h
> new file mode 100644
> index 0000000..51c0982
> --- /dev/null
> +++ b/drivers/media/platform/imx/imx-ipu.h
> @@ -0,0 +1,35 @@
> +#ifndef __MEDIA_IMX_IPU_H
> +#define __MEDIA_IMX_IPU_H
> +#include <linux/videodev2.h>
> +
> +struct ipu_fmt {
> +	u32 fourcc;
> +	const char *name;
> +	int bytes_per_pixel;
> +};
> +
> +int ipu_enum_fmt(struct file *file, void *fh,
> +		struct v4l2_fmtdesc *f);
> +int ipu_enum_fmt_rgb(struct file *file, void *fh,
> +		struct v4l2_fmtdesc *f);
> +int ipu_enum_fmt_yuv(struct file *file, void *fh,
> +		struct v4l2_fmtdesc *f);
> +struct ipu_fmt *ipu_find_fmt_rgb(unsigned int pixelformat);
> +struct ipu_fmt *ipu_find_fmt_yuv(unsigned int pixelformat);
> +int ipu_try_fmt(struct file *file, void *fh,
> +		struct v4l2_format *f);
> +int ipu_try_fmt_rgb(struct file *file, void *fh,
> +		struct v4l2_format *f);
> +int ipu_try_fmt_yuv(struct file *file, void *fh,
> +		struct v4l2_format *f);
> +int ipu_s_fmt(struct file *file, void *fh,
> +		struct v4l2_format *f, struct v4l2_pix_format *pix);
> +int ipu_s_fmt_rgb(struct file *file, void *fh,
> +		struct v4l2_format *f, struct v4l2_pix_format *pix);
> +int ipu_s_fmt_yuv(struct file *file, void *fh,
> +		struct v4l2_format *f, struct v4l2_pix_format *pix);
> +int ipu_g_fmt(struct v4l2_format *f, struct v4l2_pix_format *pix);
> +int ipu_enum_framesizes(struct file *file, void *fh,
> +			struct v4l2_frmsizeenum *fsize);
> +
> +#endif /* __MEDIA_IMX_IPU_H */
> 

Regards,

	Hans
