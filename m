Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBAFC169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C783D2175B
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfBFKnd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 05:43:33 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:56354 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbfBFKnd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Feb 2019 05:43:33 -0500
Received: from [IPv6:2001:983:e9a7:1:d87d:799b:abeb:e52d] ([IPv6:2001:983:e9a7:1:d87d:799b:abeb:e52d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id rKfsgeF7NNR5yrKftguNb3; Wed, 06 Feb 2019 11:43:30 +0100
Subject: Re: [PATCH 01/10] media: Introduce helpers to fill pixel format
 structs
To:     Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>
References: <20190205202417.16555-1-ezequiel@collabora.com>
 <20190205202417.16555-2-ezequiel@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <79ad7cf7-90d5-9542-06ea-e28ddeb14e94@xs4all.nl>
Date:   Wed, 6 Feb 2019 11:43:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190205202417.16555-2-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNRoonQhnsTxkLXFwQownDjjh379GpS+jXRHm+GvQq6wg9+7QXDgjwbUicJTejdPSmnCGN1bDYZiNcAAp2KjRw9eUIi4S6C7U/3wuFSkcPlMv7IU9Jes
 tlHCQAO8uKesodW5FOVQvp/QM+o0c2ZWnOIX5zDp8TRG8TKo9ql34dC9D3DZrQBde1cTIFAI3iElCQ3PujcsD8iRMhHr8BZz3sOSyiR0gUW9P36fYgeqDoUh
 YKX3nU7s1ghskc7Hzlxx0TzUCzJxG54L38D3djEPFTM1I99Na61RB7hZlFmitplNVRs53NbBC+HtMyIbfLO+VsFknRd3BkrDgdvO/PFHeTGUvMcM/0OuItwc
 4XWjR3zCWZCONuiYsuFsejgZHl10//8MCb/2FF8zj+7swI6d30h/fvA7Rv5mBWU3g7lJzFrmydvTvdswadbrRYENvRbz0gQtbtXzgi3fOWjoYC7B07CPqoOu
 Q41HDJv194IJPWX0FzQcFqbIaiVMwQZZS2aSoFl7S231CVJzRxVh66sJHMtVlsUJImbTkHzOGFEnYIYf
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Ezequiel,

A quick review below. This looks really useful, BTW.

On 2/5/19 9:24 PM, Ezequiel Garcia wrote:
> Add two new API helpers, v4l2_fill_pixfmt and v4l2_fill_pixfmt_mp,
> to be used by drivers to calculate plane sizes and bytes per lines.
> 
> Note that driver-specific paddig and alignment are not

paddig -> padding

> taken into account, and must be done by drivers using this API.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/v4l2-core/Makefile      |   2 +-
>  drivers/media/v4l2-core/v4l2-common.c |  71 +++++++++++++++++
>  drivers/media/v4l2-core/v4l2-fourcc.c | 109 ++++++++++++++++++++++++++
>  include/media/v4l2-common.h           |   5 ++
>  include/media/v4l2-fourcc.h           |  53 +++++++++++++
>  5 files changed, 239 insertions(+), 1 deletion(-)
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
> index 50763fb42a1b..39d86a389cae 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -61,6 +61,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-fourcc.h>

Either create a v4l2-fourcc.c source using this header, or move the
contents of v4l2-fourcc.h to v4l2-common.h.

Creating a new header but not a new source is a bit weird.

>  
>  #include <linux/videodev2.h>
>  
> @@ -455,3 +456,73 @@ int v4l2_s_parm_cap(struct video_device *vdev,
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_s_parm_cap);
> +
> +void v4l2_fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt,
> +			 int pixelformat, int width, int height)
> +{
> +	const struct v4l2_format_info *info;
> +	struct v4l2_plane_pix_format *plane;
> +	int i;
> +
> +	info = v4l2_format_info(pixelformat);
> +	if (!info)
> +		return;

You should return a bool or something to indicate whether or not
the pixelformat was known.

> +
> +	pixfmt->width = width;
> +	pixfmt->height = height;
> +	pixfmt->pixelformat = pixelformat;
> +
> +	if (!info->multiplanar) {

It would make much more sense if multiplanar contained the number of
planes to use (i.e. equal to pixfmt->num_planes).

See more about this below.

> +		pixfmt->num_planes = 1;
> +		plane = &pixfmt->plane_fmt[0];
> +		plane->bytesperline = width * info->cpp[0];
> +		plane->sizeimage = 0;
> +		for (i = 0; i < info->num_planes; i++) {
> +			unsigned int hsub = (i == 0) ? 1 : info->hsub;
> +			unsigned int vsub = (i == 0) ? 1 : info->vsub;
> +
> +			plane->sizeimage += info->cpp[i] *
> +				DIV_ROUND_UP(width, hsub) *
> +				DIV_ROUND_UP(height, vsub);
> +		}
> +	} else {
> +		pixfmt->num_planes = info->num_planes;
> +		for (i = 0; i < info->num_planes; i++) {
> +			unsigned int hsub = (i == 0) ? 1 : info->hsub;
> +			unsigned int vsub = (i == 0) ? 1 : info->vsub;
> +
> +			plane = &pixfmt->plane_fmt[i];
> +			plane->bytesperline =
> +				info->cpp[i] * DIV_ROUND_UP(width, hsub);
> +			plane->sizeimage =
> +				plane->bytesperline * DIV_ROUND_UP(height, vsub);
> +		}
> +	}
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt_mp);
> +
> +void v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat, int width, int height)
> +{
> +	const struct v4l2_format_info *info;
> +	int i;
> +
> +	info = v4l2_format_info(pixelformat);
> +	if (!info)
> +		return;

You have to check if pixelformat was a multiplanar format and reject it.

> +
> +	pixfmt->width = width;
> +	pixfmt->height = height;
> +	pixfmt->pixelformat = pixelformat;
> +	pixfmt->bytesperline = width * info->cpp[0];
> +	pixfmt->sizeimage = 0;
> +
> +	for (i = 0; i < info->num_planes; i++) {
> +		unsigned int hsub = (i == 0) ? 1 : info->hsub;
> +		unsigned int vsub = (i == 0) ? 1 : info->vsub;
> +
> +		pixfmt->sizeimage += info->cpp[i] *
> +			DIV_ROUND_UP(width, hsub) *
> +			DIV_ROUND_UP(height, vsub);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt);
> diff --git a/drivers/media/v4l2-core/v4l2-fourcc.c b/drivers/media/v4l2-core/v4l2-fourcc.c
> new file mode 100644
> index 000000000000..982c0ffa1a66
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-fourcc.c
> @@ -0,0 +1,109 @@
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
> +
> +static char printable_char(int c)
> +{
> +	return isascii(c) && isprint(c) ? c : '?';
> +}
> +
> +const char *v4l2_get_format_name(uint32_t format)

This should be called v4l2_get_fourcc_name. The format name is what ENUMFMT returns.

> +{
> +	static char buf[4];
> +
> +	snprintf(buf, 4,
> +		 "%c%c%c%c",
> +		 printable_char(format & 0xff),
> +		 printable_char((format >> 8) & 0xff),
> +		 printable_char((format >> 16) & 0xff),
> +		 printable_char((format >> 24) & 0x7f));

If bit 31 is set, then add a '-BE' suffix to indicate that this is a
big endian variant of the same pixelformat with bit 31 set to 0.

See also v4l_fill_fmtdesc() in v4l2-ioctl.c.

> +
> +	return buf;
> +}
> +EXPORT_SYMBOL(v4l2_get_format_name);

I remember that Sakari tried to make a macro for this in a public header, but
it was either rejected or fizzled out:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg128702.html

> +
> +const struct v4l2_format_info *v4l2_format_info(u32 format)
> +{
> +	static const struct v4l2_format_info formats[] = {
> +		/* RGB formats */
> +		{ .format = V4L2_PIX_FMT_BGR24,		.num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_RGB24,		.num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_HSV24,		.num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_BGR32,		.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_XBGR32,	.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_RGB32,		.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_XRGB32,	.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_HSV32,		.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_ARGB32,	.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_ABGR32,	.num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_GREY,		.num_planes = 1, .cpp = { 1, 0, 0 }, .hsub = 1, .vsub = 1 },
> +
> +		/* YUV formats */
> +		{ .format = V4L2_PIX_FMT_YUYV,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_YVYU,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_UYVY,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_VYUY,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
> +
> +		{ .format = V4L2_PIX_FMT_NV12,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2 },
> +		{ .format = V4L2_PIX_FMT_NV21,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2 },
> +		{ .format = V4L2_PIX_FMT_NV16,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_NV61,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_NV24,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 1, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_NV42,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 1, .vsub = 1 },
> +
> +		{ .format = V4L2_PIX_FMT_YUV410,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 4, .vsub = 4 },
> +		{ .format = V4L2_PIX_FMT_YVU410,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 4, .vsub = 4 },
> +		{ .format = V4L2_PIX_FMT_YUV411P,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 4, .vsub = 1 },
> +		{ .format = V4L2_PIX_FMT_YUV420,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2 },
> +		{ .format = V4L2_PIX_FMT_YVU420,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2 },
> +		{ .format = V4L2_PIX_FMT_YUV422P,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 1 },
> +
> +		{ .format = V4L2_PIX_FMT_YUV420M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
> +		{ .format = V4L2_PIX_FMT_YVU420M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
> +		{ .format = V4L2_PIX_FMT_YUV422M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 1, .multiplanar = 1 },
> +		{ .format = V4L2_PIX_FMT_YVU422M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 1, .multiplanar = 1 },
> +		{ .format = V4L2_PIX_FMT_YUV444M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 1, .vsub = 1, .multiplanar = 1 },
> +		{ .format = V4L2_PIX_FMT_YVU444M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 1, .vsub = 1, .multiplanar = 1 },
> +
> +		{ .format = V4L2_PIX_FMT_NV12M,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
> +		{ .format = V4L2_PIX_FMT_NV21M,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
> +		{ .format = V4L2_PIX_FMT_NV16M,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1, .multiplanar = 1 },
> +		{ .format = V4L2_PIX_FMT_NV61M,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 1, .multiplanar = 1 },
> +
> +	};
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
> +		if (formats[i].format == format)
> +			return &formats[i];
> +	}

No need for {}

> +
> +	pr_warn("Unsupported V4L 4CC format %s (%08x)\n", v4l2_get_format_name(format), format);

Make this a pr_dev or remove it altogether. I prefer the latter.

> +	return NULL;
> +}
> +EXPORT_SYMBOL(v4l2_format_info);
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 0c511ed8ffb0..6461ce747d90 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -327,6 +327,11 @@ void v4l_bound_align_image(unsigned int *width, unsigned int wmin,
>  			   unsigned int hmax, unsigned int halign,
>  			   unsigned int salign);
>  
> +void v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat,
> +		      int width, int height);
> +void v4l2_fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt, int pixelformat,
> +			 int width, int height);
> +
>  /**
>   * v4l2_find_nearest_size - Find the nearest size among a discrete
>   *	set of resolutions contained in an array of a driver specific struct.
> diff --git a/include/media/v4l2-fourcc.h b/include/media/v4l2-fourcc.h
> new file mode 100644
> index 000000000000..3d24f442aaf5
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

Should be an SPDX ID.

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

This is actually 1-4 since there may be an alpha channel as well. Not that we have
such formats since the only formats with an alpha channel are interleaved formats,
but it is possible.

So this value is 2 for both NV12 and NV12M.

> + * @cpp: Number of bytes per pixel (per plane)

cpp? Shouldn't that be bpp?

Note that this can differ per plane (see e.g. NV24).

> + * @hsub: Horizontal chroma subsampling factor
> + * @vsub: Vertical chroma subsampling factor

A bit too cryptic IMHO. I would prefer hdiv or hsubsampling. 'hsub' suggests
subtraction :-)

> + * @multiplanar: Is it a multiplanar variant format? (e.g. NV12M)

This should, I think, be renamed to num_non_contig_planes to indicate how many
non-contiguous planes there are in the format.

So this value is 1 for NV12 and 2 for NV12M. For V4L2_PIX_FMT_YUV444M it is 3.

You can stick this value directly into pixfmt_mp->num_planes.

As an aside: perhaps we should start calling the 'multiplanar API' the
'multiple non-contiguous planes API', at least in the documentation. It's the
first time that I found a description that actually covers the real meaning.

> + */
> +struct v4l2_format_info {
> +	u32 format;
> +	u32 header_size;
> +	u8 num_planes;
> +	u8 cpp[3];
> +	u8 hsub;
> +	u8 vsub;
> +	u8 multiplanar;
> +};
> +
> +const struct v4l2_format_info *v4l2_format_info(u32 format);
> +const char *v4l2_get_format_name(u32 format);
> +
> +#endif
> 

Regards,

	Hans
