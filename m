Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1044 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3HSNG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 09:06:28 -0400
Message-ID: <52121844.3030300@xs4all.nl>
Date: Mon, 19 Aug 2013 15:06:12 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com, posciak@google.com, arun.kk@samsung.com
Subject: Re: [PATCH v2 2/5] [media] exynos-mscl: Add core functionality for
 the M-Scaler driver
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com> <1376909932-23644-3-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1376909932-23644-3-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2013 12:58 PM, Shaik Ameer Basha wrote:
> This patch adds the core functionality for the M-Scaler driver.

Some more comments below...

> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  drivers/media/platform/exynos-mscl/mscl-core.c | 1312 ++++++++++++++++++++++++
>  drivers/media/platform/exynos-mscl/mscl-core.h |  549 ++++++++++
>  2 files changed, 1861 insertions(+)
>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-core.c
>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-core.h
> 
> diff --git a/drivers/media/platform/exynos-mscl/mscl-core.c b/drivers/media/platform/exynos-mscl/mscl-core.c
> new file mode 100644
> index 0000000..4a3a851
> --- /dev/null
> +++ b/drivers/media/platform/exynos-mscl/mscl-core.c
> @@ -0,0 +1,1312 @@
> +/*
> + * Copyright (c) 2013 - 2014 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Samsung EXYNOS5 SoC series M-Scaler driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,
> + * or (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>
> +#include <linux/pm_runtime.h>
> +
> +#ifdef CONFIG_EXYNOS_IOMMU
> +#include <asm/dma-iommu.h>
> +#endif
> +
> +#include "mscl-core.h"
> +
> +#define MSCL_CLOCK_GATE_NAME	"mscl"
> +
> +static const struct mscl_fmt mscl_formats[] = {
> +	{
> +		.name		= "YUV 4:2:0 non-contig. 2p, Y/CbCr",
> +		.pixelformat	= V4L2_PIX_FMT_NV12M,
> +		.depth		= { 8, 4 },
> +		.color		= MSCL_YUV420,
> +		.corder		= MSCL_CBCR,
> +		.num_planes	= 2,
> +		.num_comp	= 2,
> +		.mscl_color	= MSCL_YUV420_2P_Y_UV,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +
> +	}, {
> +		.name		= "YUV 4:2:0 contig. 2p, Y/CbCr",
> +		.pixelformat	= V4L2_PIX_FMT_NV12,
> +		.depth		= { 12 },
> +		.color		= MSCL_YUV420,
> +		.corder		= MSCL_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 2,
> +		.mscl_color	= MSCL_YUV420_2P_Y_UV,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:0 n.c. 2p, Y/CbCr tiled",
> +		.pixelformat	= V4L2_PIX_FMT_NV12MT_16X16,
> +		.depth		= { 8, 4 },
> +		.color		= MSCL_YUV420,
> +		.corder		= MSCL_CBCR,
> +		.num_planes	= 2,
> +		.num_comp	= 2,
> +		.mscl_color	= MSCL_YUV420_2P_Y_UV,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC),
> +		.is_tiled	= true,
> +	}, {
> +		.name		= "YUV 4:2:2 contig. 2p, Y/CbCr",
> +		.pixelformat	= V4L2_PIX_FMT_NV16,
> +		.depth		= { 16 },
> +		.color		= MSCL_YUV422,
> +		.corder		= MSCL_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 2,
> +		.mscl_color	= MSCL_YUV422_2P_Y_UV,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:4:4 contig. 2p, Y/CbCr",
> +		.pixelformat	= V4L2_PIX_FMT_NV24,
> +		.depth		= { 24 },
> +		.color		= MSCL_YUV444,
> +		.corder		= MSCL_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 2,
> +		.mscl_color	= MSCL_YUV444_2P_Y_UV,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "RGB565",
> +		.pixelformat	= V4L2_PIX_FMT_RGB565X,
> +		.depth		= { 16 },
> +		.color		= MSCL_RGB,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.mscl_color	= MSCL_RGB565,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "XRGB-1555, 16 bpp",
> +		.pixelformat	= V4L2_PIX_FMT_RGB555,
> +		.depth		= { 16 },
> +		.color		= MSCL_RGB,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.mscl_color	= MSCL_ARGB1555,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "XRGB-8888, 32 bpp",
> +		.pixelformat	= V4L2_PIX_FMT_RGB32,
> +		.depth		= { 32 },
> +		.color		= MSCL_RGB,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.mscl_color	= MSCL_ARGB8888,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:2 packed, YCrYCb",
> +		.pixelformat	= V4L2_PIX_FMT_YVYU,
> +		.depth		= { 16 },
> +		.color		= MSCL_YUV422,
> +		.corder		= MSCL_CRCB,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
> +		.mscl_color	= MSCL_YUV422_1P_YVYU,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:2 packed, YCbYCr",
> +		.pixelformat	= V4L2_PIX_FMT_YUYV,
> +		.depth		= { 16 },
> +		.color		= MSCL_YUV422,
> +		.corder		= MSCL_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
> +		.mscl_color	= MSCL_YUV422_1P_YUYV,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:2 packed, CbYCrY",
> +		.pixelformat	= V4L2_PIX_FMT_UYVY,
> +		.depth		= { 16 },
> +		.color		= MSCL_YUV422,
> +		.corder		= MSCL_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
> +		.mscl_color	= MSCL_YUV422_1P_UYVY,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "XRGB-4444, 16 bpp",
> +		.pixelformat	= V4L2_PIX_FMT_RGB444,
> +		.depth		= { 16 },
> +		.color		= MSCL_RGB,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.mscl_color	= MSCL_ARGB4444,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:0 non-contig. 2p, Y/CrCb",
> +		.pixelformat	= V4L2_PIX_FMT_NV21M,
> +		.depth		= { 8, 4 },
> +		.color		= MSCL_YUV420,
> +		.corder		= MSCL_CRCB,
> +		.num_planes	= 2,
> +		.num_comp	= 2,
> +		.mscl_color	= MSCL_YUV420_2P_Y_VU,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:0 contig. 2p, Y/CrCb",
> +		.pixelformat	= V4L2_PIX_FMT_NV21,
> +		.depth		= { 12 },
> +		.color		= MSCL_YUV420,
> +		.corder		= MSCL_CRCB,
> +		.num_planes	= 1,
> +		.num_comp	= 2,
> +		.mscl_color	= MSCL_YUV420_2P_Y_VU,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:2 contig. 2p, Y/CrCb",
> +		.pixelformat	= V4L2_PIX_FMT_NV61,
> +		.depth		= { 16 },
> +		.color		= MSCL_YUV422,
> +		.corder		= MSCL_CRCB,
> +		.num_planes	= 1,
> +		.num_comp	= 2,
> +		.mscl_color	= MSCL_YUV422_2P_Y_VU,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:4:4 contig. 2p, Y/CrCb",
> +		.pixelformat	= V4L2_PIX_FMT_NV42,
> +		.depth		= { 24 },
> +		.color		= MSCL_YUV444,
> +		.corder		= MSCL_CRCB,
> +		.num_planes	= 1,
> +		.num_comp	= 2,
> +		.mscl_color	= MSCL_YUV444_2P_Y_VU,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:0 contig. 3p, YCbCr",
> +		.pixelformat	= V4L2_PIX_FMT_YUV420,
> +		.depth		= { 12 },
> +		.color		= MSCL_YUV420,
> +		.corder		= MSCL_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 3,
> +		.mscl_color	= MSCL_YUV420_3P_Y_U_V,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:0 contig. 3p, YCrCb",
> +		.pixelformat	= V4L2_PIX_FMT_YVU420,
> +		.depth		= { 12 },
> +		.color		= MSCL_YUV420,
> +		.corder		= MSCL_CRCB,
> +		.num_planes	= 1,
> +		.num_comp	= 3,
> +		.mscl_color	= MSCL_YUV420_3P_Y_U_V,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:0 non-contig. 3p, Y/Cb/Cr",
> +		.pixelformat	= V4L2_PIX_FMT_YUV420M,
> +		.depth		= { 8, 2, 2 },
> +		.color		= MSCL_YUV420,
> +		.corder		= MSCL_CBCR,
> +		.num_planes	= 3,
> +		.num_comp	= 3,
> +		.mscl_color	= MSCL_YUV420_3P_Y_U_V,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:0 non-contig. 3p, Y/Cr/Cb",
> +		.pixelformat	= V4L2_PIX_FMT_YVU420M,
> +		.depth		= { 8, 2, 2 },
> +		.color		= MSCL_YUV420,
> +		.corder		= MSCL_CRCB,
> +		.num_planes	= 3,
> +		.num_comp	= 3,
> +		.mscl_color	= MSCL_YUV420_3P_Y_U_V,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	}, {
> +		.name		= "YUV 4:2:2 contig. 3p, Y/Cb/Cr",
> +		.pixelformat	= V4L2_PIX_FMT_YUV422P,
> +		.depth		= { 16 },
> +		.color		= MSCL_YUV422,
> +		.corder		= MSCL_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 3,
> +		.mscl_color	= MSCL_YUV422_3P_Y_U_V,
> +		.mscl_color_fmt_type = (MSCL_FMT_SRC | MSCL_FMT_DST),
> +	},
> +
> +	/* [TBD] support pixel formats, corresponds to these mscl_color formats
> +	 * MSCL_L8A8, MSCL_RGBA8888, MSCL_L8 etc
> +	 */
> +};
> +
> +const struct mscl_fmt *mscl_get_format(int index)
> +{
> +	if (index >= ARRAY_SIZE(mscl_formats))
> +		return NULL;
> +
> +	return (struct mscl_fmt *)&mscl_formats[index];
> +}
> +
> +const struct mscl_fmt *mscl_find_fmt(u32 *pixelformat,
> +				u32 *mbus_code, u32 index)
> +{
> +	const struct mscl_fmt *fmt, *def_fmt = NULL;
> +	unsigned int i;
> +
> +	if (index >= ARRAY_SIZE(mscl_formats))
> +		return NULL;
> +
> +	for (i = 0; i < ARRAY_SIZE(mscl_formats); ++i) {
> +		fmt = mscl_get_format(i);
> +		if (pixelformat && fmt->pixelformat == *pixelformat)
> +			return fmt;
> +		if (mbus_code && fmt->mbus_code == *mbus_code)
> +			return fmt;
> +		if (index == i)
> +			def_fmt = fmt;
> +	}
> +
> +	return def_fmt;
> +}
> +
> +void mscl_set_frame_size(struct mscl_frame *frame, int width, int height)
> +{
> +	frame->f_width	= width;
> +	frame->f_height	= height;
> +	frame->crop.width = width;
> +	frame->crop.height = height;
> +	frame->crop.left = 0;
> +	frame->crop.top = 0;
> +}
> +
> +int mscl_enum_fmt_mplane(struct v4l2_fmtdesc *f)
> +{
> +	const struct mscl_fmt *fmt;
> +
> +	fmt = mscl_find_fmt(NULL, NULL, f->index);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	/* input supports all mscl_formats but all mscl_formats are not
> +	 * supported for output. don't return the unsupported formats for output
> +	 */
> +	if (!(V4L2_TYPE_IS_OUTPUT(f->type) &&
> +		(fmt->mscl_color_fmt_type & MSCL_FMT_SRC)))
> +		return -EINVAL;

Confusing layout. It's better to align it like this:

	if (!(V4L2_TYPE_IS_OUTPUT(f->type) &&
	    (fmt->mscl_color_fmt_type & MSCL_FMT_SRC)))
		return -EINVAL;

> +
> +	strlcpy(f->description, fmt->name, sizeof(f->description));
> +	f->pixelformat = fmt->pixelformat;
> +
> +	return 0;
> +}
> +
> +static u32 get_plane_info(struct mscl_frame *frm, u32 addr, u32 *index)
> +{
> +	if (frm->addr.y == addr) {
> +		*index = 0;
> +		return frm->addr.y;
> +	} else if (frm->addr.cb == addr) {
> +		*index = 1;
> +		return frm->addr.cb;
> +	} else if (frm->addr.cr == addr) {
> +		*index = 2;
> +		return frm->addr.cr;
> +	} else {
> +		pr_debug("Plane address is wrong");
> +		return -EINVAL;
> +	}

Since all the statement blocks above end with a 'return' the 'else' keyword.
isn't necessary.

So just do:

	if (frm->addr.y == addr) {
		*index = 0;
		return frm->addr.y;
	}
	if (frm->addr.cb == addr) {
		*index = 1;
		return frm->addr.cb;
	}
	if (frm->addr.cr == addr) {
		*index = 2;
		return frm->addr.cr;
	}
	pr_debug("Plane address is wrong");
	return -EINVAL;


> +}
> +
> +void mscl_set_prefbuf(struct mscl_dev *mscl, struct mscl_frame *frm)
> +{
> +	u32 f_chk_addr, f_chk_len, s_chk_addr, s_chk_len;
> +	f_chk_addr = f_chk_len = s_chk_addr = s_chk_len = 0;
> +
> +	f_chk_addr = frm->addr.y;
> +	f_chk_len = frm->payload[0];
> +	if (frm->fmt->num_planes == 2) {
> +		s_chk_addr = frm->addr.cb;
> +		s_chk_len = frm->payload[1];
> +	} else if (frm->fmt->num_planes == 3) {
> +		u32 low_addr, low_plane, mid_addr, mid_plane;
> +		u32 high_addr, high_plane;
> +		u32 t_min, t_max;
> +
> +		t_min = min3(frm->addr.y, frm->addr.cb, frm->addr.cr);
> +		low_addr = get_plane_info(frm, t_min, &low_plane);
> +		t_max = max3(frm->addr.y, frm->addr.cb, frm->addr.cr);
> +		high_addr = get_plane_info(frm, t_max, &high_plane);
> +
> +		mid_plane = 3 - (low_plane + high_plane);
> +		if (mid_plane == 0)
> +			mid_addr = frm->addr.y;
> +		else if (mid_plane == 1)
> +			mid_addr = frm->addr.cb;
> +		else if (mid_plane == 2)
> +			mid_addr = frm->addr.cr;
> +		else
> +			return;
> +
> +		f_chk_addr = low_addr;
> +		if (mid_addr + frm->payload[mid_plane] - low_addr >
> +		    high_addr + frm->payload[high_plane] - mid_addr) {
> +			f_chk_len = frm->payload[low_plane];
> +			s_chk_addr = mid_addr;
> +			s_chk_len = high_addr +
> +					frm->payload[high_plane] - mid_addr;
> +		} else {
> +			f_chk_len = mid_addr +
> +					frm->payload[mid_plane] - low_addr;
> +			s_chk_addr = high_addr;
> +			s_chk_len = frm->payload[high_plane];
> +		}
> +	}
> +	dev_dbg(&mscl->pdev->dev,
> +		"f_addr = 0x%08x, f_len = %d, s_addr = 0x%08x, s_len = %d\n",
> +		f_chk_addr, f_chk_len, s_chk_addr, s_chk_len);
> +}
> +
> +int mscl_try_fmt_mplane(struct mscl_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct mscl_dev *mscl = ctx->mscl_dev;
> +	struct device *dev = &mscl->pdev->dev;
> +	struct mscl_variant *variant = mscl->variant;
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
> +	const struct mscl_fmt *fmt;
> +	u32 max_w, max_h, mod_w = 0, mod_h = 0;
> +	u32 min_w, min_h, tmp_w, tmp_h;
> +	int i;
> +	struct mscl_frm_limit *frm_limit;
> +
> +	dev_dbg(dev, "user put w: %d, h: %d",
> +			pix_mp->width, pix_mp->height);
> +
> +	fmt = mscl_find_fmt(&pix_mp->pixelformat, NULL, 0);
> +	if (!fmt) {
> +		dev_dbg(dev, "pixelformat format (0x%X) invalid\n",
> +						pix_mp->pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	if (pix_mp->field == V4L2_FIELD_ANY)
> +		pix_mp->field = V4L2_FIELD_NONE;
> +	else if (pix_mp->field != V4L2_FIELD_NONE) {
> +		dev_dbg(dev, "Not supported field order(%d)\n", pix_mp->field);
> +		return -EINVAL;

Don't return an error, just always map field to FIELD_NONE.

> +	}
> +
> +	if (V4L2_TYPE_IS_OUTPUT(f->type))
> +		frm_limit = variant->pix_out;
> +	else
> +		frm_limit = variant->pix_in;
> +
> +	max_w = frm_limit->max_w;
> +	max_h = frm_limit->max_h;
> +	min_w = frm_limit->min_w;
> +	min_h = frm_limit->min_h;
> +
> +	/* Span has to be even number for YCbCr422-2p or YCbCr420 format */
> +	if (is_yuv422_2p(fmt) || is_yuv420(fmt))
> +		mod_w = 1;
> +
> +	dev_dbg(dev, "mod_w: %d, mod_h: %d, max_w: %d, max_h = %d",
> +			mod_w, mod_h, max_w, max_h);
> +
> +	/* To check if image size is modified to adjust parameter against
> +	   hardware abilities */
> +	tmp_w = pix_mp->width;
> +	tmp_h = pix_mp->height;
> +
> +	v4l_bound_align_image(&pix_mp->width, min_w, max_w, mod_w,
> +		&pix_mp->height, min_h, max_h, mod_h, 0);
> +	if (tmp_w != pix_mp->width || tmp_h != pix_mp->height)
> +		dev_info(dev,
> +			 "Image size has been modified from %dx%d to %dx%d",
> +			 tmp_w, tmp_h, pix_mp->width, pix_mp->height);
> +
> +	pix_mp->num_planes = fmt->num_planes;
> +
> +	/* nothing mentioned about the colorspace in m2m-scaler
> +	 * default value is set to V4L2_COLORSPACE_REC709
> +	 */
> +	pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> +
> +	for (i = 0; i < pix_mp->num_planes; ++i) {
> +		int bpl = (pix_mp->width * fmt->depth[i]) >> 3;
> +		pix_mp->plane_fmt[i].bytesperline = bpl;
> +		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
> +
> +		dev_dbg(dev, "[%d]: bpl: %d, sizeimage: %d",
> +				i, bpl, pix_mp->plane_fmt[i].sizeimage);
> +	}
> +
> +	return 0;
> +}
> +
> +int mscl_g_fmt_mplane(struct mscl_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct mscl_frame *frame;
> +	struct v4l2_pix_format_mplane *pix_mp;
> +	int i;
> +
> +	frame = ctx_get_frame(ctx, f->type);
> +	if (IS_ERR(frame))
> +		return PTR_ERR(frame);
> +
> +	pix_mp = &f->fmt.pix_mp;
> +
> +	pix_mp->width		= frame->f_width;
> +	pix_mp->height		= frame->f_height;
> +	pix_mp->field		= V4L2_FIELD_NONE;
> +	pix_mp->pixelformat	= frame->fmt->pixelformat;
> +	pix_mp->colorspace	= V4L2_COLORSPACE_REC709;
> +	pix_mp->num_planes	= frame->fmt->num_planes;
> +
> +	for (i = 0; i < pix_mp->num_planes; ++i) {
> +		pix_mp->plane_fmt[i].bytesperline = (frame->f_width *
> +			frame->fmt->depth[i]) / 8;
> +		pix_mp->plane_fmt[i].sizeimage =
> +			 pix_mp->plane_fmt[i].bytesperline * frame->f_height;
> +	}
> +
> +	return 0;
> +}
> +
> +void mscl_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h)
> +{
> +	if (tmp_w != *w || tmp_h != *h) {
> +		pr_info("Cropped size has been modified from %dx%d to %dx%d",
> +							*w, *h, tmp_w, tmp_h);
> +		*w = tmp_w;
> +		*h = tmp_h;
> +	}
> +}
> +
> +int mscl_g_crop(struct mscl_ctx *ctx, struct v4l2_crop *cr)
> +{
> +	struct mscl_frame *frame;
> +
> +	frame = ctx_get_frame(ctx, cr->type);
> +	if (IS_ERR(frame))
> +		return PTR_ERR(frame);
> +
> +	cr->c = frame->crop;
> +
> +	return 0;
> +}
> +
> +int mscl_try_crop(struct mscl_ctx *ctx, struct v4l2_crop *cr)
> +{
> +	struct mscl_frame *f;
> +	const struct mscl_fmt *fmt;
> +	struct mscl_dev *mscl = ctx->mscl_dev;
> +	struct device *dev = &mscl->pdev->dev;
> +	struct mscl_variant *variant = mscl->variant;
> +	u32 mod_w = 0, mod_h = 0, tmp_w, tmp_h;
> +	u32 min_w, min_h, max_w, max_h;
> +	struct mscl_frm_limit *frm_limit;
> +
> +	if (cr->c.top < 0 || cr->c.left < 0) {
> +		dev_dbg(dev, "doesn't support negative values\n");
> +		return -EINVAL;
> +	}
> +	dev_dbg(dev, "user requested width: %d, height: %d",
> +					cr->c.width, cr->c.height);
> +
> +	f = ctx_get_frame(ctx, cr->type);
> +	if (IS_ERR(f))
> +		return PTR_ERR(f);
> +
> +	fmt = f->fmt;
> +	tmp_w = cr->c.width;
> +	tmp_h = cr->c.height;
> +
> +	if (V4L2_TYPE_IS_OUTPUT(cr->type))
> +		frm_limit = variant->pix_out;
> +	else
> +		frm_limit = variant->pix_in;
> +
> +	max_w = f->f_width;
> +	max_h = f->f_height;
> +	min_w = frm_limit->min_w;
> +	min_h = frm_limit->min_h;
> +
> +	if (V4L2_TYPE_IS_OUTPUT(cr->type)) {
> +		if (is_yuv420(fmt)) {
> +			mod_w = ffs(variant->pix_align->dst_w_420) - 1;
> +			mod_h = ffs(variant->pix_align->dst_h_420) - 1;
> +		} else if (is_yuv422(fmt)) {
> +			mod_w = ffs(variant->pix_align->dst_w_422) - 1;
> +		}
> +	} else {
> +		if (is_yuv420(fmt)) {
> +			mod_w = ffs(variant->pix_align->src_w_420) - 1;
> +			mod_h = ffs(variant->pix_align->src_h_420) - 1;
> +		} else if (is_yuv422(fmt)) {
> +			mod_w = ffs(variant->pix_align->src_w_422) - 1;
> +		}
> +
> +		if (ctx->ctrls_mscl.rotate->val == 90 ||
> +		    ctx->ctrls_mscl.rotate->val == 270) {
> +			max_w = f->f_height;
> +			max_h = f->f_width;
> +			tmp_w = cr->c.height;
> +			tmp_h = cr->c.width;
> +		}
> +	}
> +
> +	dev_dbg(dev, "mod_x: %d, mod_y: %d, min_w: %d, min_h = %d",
> +					mod_w, mod_h, min_w, min_h);
> +	dev_dbg(dev, "tmp_w : %d, tmp_h : %d", tmp_w, tmp_h);
> +
> +	v4l_bound_align_image(&tmp_w, min_w, max_w, mod_w,
> +			      &tmp_h, min_h, max_h, mod_h, 0);
> +
> +	if (!V4L2_TYPE_IS_OUTPUT(cr->type) &&
> +		(ctx->ctrls_mscl.rotate->val == 90 ||
> +		 ctx->ctrls_mscl.rotate->val == 270))
> +		mscl_check_crop_change(tmp_h, tmp_w,
> +					&cr->c.width, &cr->c.height);
> +	else
> +		mscl_check_crop_change(tmp_w, tmp_h,
> +					&cr->c.width, &cr->c.height);
> +
> +	/* adjust left/top if cropping rectangle is out of bounds */
> +	/* Need to add code to algin left value with 2's multiple */
> +	if (cr->c.left + tmp_w > max_w)
> +		cr->c.left = max_w - tmp_w;
> +	if (cr->c.top + tmp_h > max_h)
> +		cr->c.top = max_h - tmp_h;
> +
> +	if (is_yuv422_1p(fmt) && (cr->c.left & 1))
> +		cr->c.left -= 1;
> +
> +	dev_dbg(dev, "Aligned l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
> +	    cr->c.left, cr->c.top, cr->c.width, cr->c.height, max_w, max_h);
> +
> +	return 0;
> +}
> +
> +int mscl_check_scaler_ratio(struct mscl_variant *var, int sw, int sh, int dw,
> +			   int dh, int rot)
> +{
> +	if ((dw == 0) || (dh == 0))
> +		return -EINVAL;
> +
> +	if (rot == 90 || rot == 270)
> +		swap(dh, dw);
> +
> +	pr_debug("sw: %d, sh: %d, dw: %d, dh: %d\n", sw, sh, dw, dh);
> +
> +	if ((sw/dw) > var->scl_down_max || (sh/dh) > var->scl_down_max ||
> +	    (dw/sw) > var->scl_up_max   || (dh/sh) > var->scl_up_max)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +int mscl_set_scaler_info(struct mscl_ctx *ctx)
> +{
> +	struct mscl_scaler *sc = &ctx->scaler;
> +	struct mscl_frame *s_frame = &ctx->s_frame;
> +	struct mscl_frame *d_frame = &ctx->d_frame;
> +	struct mscl_variant *variant = ctx->mscl_dev->variant;
> +	struct device *dev = &ctx->mscl_dev->pdev->dev;
> +	int src_w, src_h, ret;
> +
> +	ret = mscl_check_scaler_ratio(variant,
> +				s_frame->crop.width, s_frame->crop.height,
> +				d_frame->crop.width, d_frame->crop.height,
> +				ctx->ctrls_mscl.rotate->val);
> +	if (ret) {
> +		dev_dbg(dev, "out of scaler range\n");
> +		return ret;
> +	}
> +
> +	if (ctx->ctrls_mscl.rotate->val == 90 ||
> +		ctx->ctrls_mscl.rotate->val == 270) {
> +		src_w = s_frame->crop.height;
> +		src_h = s_frame->crop.width;
> +	} else {
> +		src_w = s_frame->crop.width;
> +		src_h = s_frame->crop.height;
> +	}
> +
> +	sc->hratio = (src_w << 16) / d_frame->crop.width;
> +	sc->vratio = (src_h << 16) / d_frame->crop.height;
> +
> +	dev_dbg(dev, "scaler settings::\n"
> +		 "sx = %d, sy = %d, sw = %d, sh = %d\n"
> +		 "dx = %d, dy = %d, dw = %d, dh = %d\n"
> +		 "h-ratio : %d, v-ratio: %d\n",
> +		 s_frame->crop.left, s_frame->crop.top,
> +		 s_frame->crop.width, s_frame->crop.height,
> +		 d_frame->crop.left, d_frame->crop.top,
> +		 d_frame->crop.width, s_frame->crop.height,
> +		 sc->hratio, sc->vratio);
> +
> +	return 0;
> +}
> +
> +static int __mscl_s_ctrl(struct mscl_ctx *ctx, struct v4l2_ctrl *ctrl)
> +{
> +	struct mscl_dev *mscl = ctx->mscl_dev;
> +	struct mscl_variant *variant = mscl->variant;
> +	unsigned int flags = MSCL_DST_FMT | MSCL_SRC_FMT;
> +	int ret = 0;
> +
> +	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
> +		return 0;

Why would you want to do this check?

> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_HFLIP:
> +		ctx->hflip = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_VFLIP:
> +		ctx->vflip = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_ROTATE:
> +		if ((ctx->state & flags) == flags) {
> +			ret = mscl_check_scaler_ratio(variant,
> +					ctx->s_frame.crop.width,
> +					ctx->s_frame.crop.height,
> +					ctx->d_frame.crop.width,
> +					ctx->d_frame.crop.height,
> +					ctx->ctrls_mscl.rotate->val);
> +
> +			if (ret)
> +				return -EINVAL;
> +		}

I think it would be good if the try_ctrl op is implemented so you can call
VIDIOC_EXT_TRY_CTRLS in the application to check if the ROTATE control can be
set.

> +
> +		ctx->rotation = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_ALPHA_COMPONENT:
> +		ctx->d_frame.alpha = ctrl->val;
> +		break;
> +	}
> +
> +	ctx->state |= MSCL_PARAMS;
> +	return 0;
> +}
> +
> +static int mscl_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct mscl_ctx *ctx = ctrl_to_ctx(ctrl);
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&ctx->mscl_dev->slock, flags);
> +	ret = __mscl_s_ctrl(ctx, ctrl);
> +	spin_unlock_irqrestore(&ctx->mscl_dev->slock, flags);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops mscl_ctrl_ops = {
> +	.s_ctrl = mscl_s_ctrl,
> +};

Thanks for the patches!

Regards,

	Hans
