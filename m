Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43229 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab3H2Mub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 08:50:31 -0400
Message-id: <521F4393.4070607@samsung.com>
Date: Thu, 29 Aug 2013 14:50:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	posciak@google.com, arun.kk@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Figa <t.figa@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 2/5] [media] exynos-mscl: Add core functionality for the
 M-Scaler driver
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
 <1376909932-23644-3-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1376909932-23644-3-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

Couple more comments...

On 08/19/2013 12:58 PM, Shaik Ameer Basha wrote:
> This patch adds the core functionality for the M-Scaler driver.
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

First time I see such practice, why not just make it 2013 ?

> + *		http://www.samsung.com
> + *
> + * Samsung EXYNOS5 SoC series M-Scaler driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,

> + * or (at your option) any later version.

Are you sure you want this statement included ?

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

nit: s/corder/color_order ?

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

Hm, why not create MSCL_FMT_TILED flags, rename mscl_color_fmt_type to
e.g. 'flags' and use this instead of multiple fields like
mscl_color_fmt_type/is_tiled ?

[...]
> +
> +	/* [TBD] support pixel formats, corresponds to these mscl_color formats
> +	 * MSCL_L8A8, MSCL_RGBA8888, MSCL_L8 etc
> +	 */

Please remove this, or reformat it so it complies with the kernel coding style.

> +};
> +
> +const struct mscl_fmt *mscl_get_format(int index)
> +{
> +	if (index >= ARRAY_SIZE(mscl_formats))
> +		return NULL;
> +
> +	return (struct mscl_fmt *)&mscl_formats[index];

Why is casting needed here ?

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

nit: wrong multi-line comment style. Please start sentences with capital letter
and use dots.

> +	if (!(V4L2_TYPE_IS_OUTPUT(f->type) &&
> +		(fmt->mscl_color_fmt_type & MSCL_FMT_SRC)))
> +		return -EINVAL;
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

There should be fallback to some default format. Dont't return error
when unsupported pixelformat was passed.

> +		return -EINVAL;
> +	}
> +
> +	if (pix_mp->field == V4L2_FIELD_ANY)
> +		pix_mp->field = V4L2_FIELD_NONE;
> +	else if (pix_mp->field != V4L2_FIELD_NONE) {
> +		dev_dbg(dev, "Not supported field order(%d)\n", pix_mp->field);
> +		return -EINVAL;
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

Wrong multi-line comment style.

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

Ditto.

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

Shouldn't you just adjust left/top instead of returning error ?

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

Couldn't this be combined into one dev_dbg() call, or perhaps removed ?

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

Please correct this to use proper multi-line comment style.

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

nit: should have spaces aroud '/'.

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
> +
> +int mscl_ctrls_create(struct mscl_ctx *ctx)
> +{
> +	struct device *dev = &ctx->mscl_dev->pdev->dev;
> +
> +	if (ctx->ctrls_rdy) {
> +		dev_dbg(dev, "Control handler of this ctx was created already");
> +		return 0;
> +	}
> +
> +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, MSCL_MAX_CTRL_NUM);
> +
> +	ctx->ctrls_mscl.rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +			&mscl_ctrl_ops, V4L2_CID_ROTATE, 0, 270, 90, 0);
> +	ctx->ctrls_mscl.hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +			&mscl_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	ctx->ctrls_mscl.vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +			&mscl_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	ctx->ctrls_mscl.global_alpha = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +			&mscl_ctrl_ops, V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 0);
> +
> +	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
> +
> +	if (ctx->ctrl_handler.error) {
> +		int err = ctx->ctrl_handler.error;
> +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +		dev_dbg(dev, "Failed to create M-Scaler control handlers");
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +void mscl_ctrls_delete(struct mscl_ctx *ctx)
> +{
> +	if (ctx->ctrls_rdy) {
> +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +		ctx->ctrls_rdy = false;
> +	}
> +}
> +
> +/* The color format (num_comp, num_planes) must be already configured. */
> +int mscl_prepare_addr(struct mscl_ctx *ctx, struct vb2_buffer *vb,
> +			struct mscl_frame *frame, struct mscl_addr *addr)
> +{
> +	struct device *dev = &ctx->mscl_dev->pdev->dev;
> +	int ret = 0;
> +	u32 pix_size;
> +
> +	if ((vb == NULL) || (frame == NULL))

Superfluous braces.

> +		return -EINVAL;
> +
> +	pix_size = frame->f_width * frame->f_height;
> +
> +	dev_dbg(dev, "planes= %d, comp= %d, pix_size= %d, fmt = %d\n",
> +		     frame->fmt->num_planes, frame->fmt->num_comp,
> +		     pix_size, frame->fmt->mscl_color);
> +
> +	addr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +	if (frame->fmt->num_planes == 1) {
> +		switch (frame->fmt->num_comp) {
> +		case 1:
> +			addr->cb = 0;
> +			addr->cr = 0;
> +			break;
> +		case 2:
> +			/* decompose Y into Y/Cb */
> +			addr->cb = (dma_addr_t)(addr->y + pix_size);
> +			addr->cr = 0;
> +			break;
> +		case 3:
> +			/* decompose Y into Y/Cb/Cr */
> +			addr->cb = (dma_addr_t)(addr->y + pix_size);
> +			if (MSCL_YUV420 == frame->fmt->color)
> +				addr->cr = (dma_addr_t)(addr->cb
> +						+ (pix_size >> 2));
> +			else if (MSCL_YUV422 == frame->fmt->color)
> +				addr->cr = (dma_addr_t)(addr->cb
> +						+ (pix_size >> 1));
> +			else /* 444 */
> +				addr->cr = (dma_addr_t)(addr->cb + pix_size);
> +			break;
> +		default:
> +			dev_dbg(dev, "Invalid number of color planes\n");
> +			return -EINVAL;
> +		}
> +	} else {
> +		if (frame->fmt->num_planes >= 2)
> +			addr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
> +
> +		if (frame->fmt->num_planes == 3)
> +			addr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
> +	}
> +
> +	if ((frame->fmt->corder == MSCL_CRCB) && (frame->fmt->num_planes == 3))
> +		swap(addr->cb, addr->cr);
> +
> +	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type))
> +		dev_dbg(dev, "\nIN:ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d\n",
> +					addr->y, addr->cb, addr->cr, ret);
> +	else
> +		dev_dbg(dev, "\nOUT:ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d\n",
> +					addr->y, addr->cb, addr->cr, ret);
> +
> +	return ret;
> +}
> +
> +static void mscl_sw_reset(struct mscl_dev *mscl)
> +{
> +	mscl_hw_set_sw_reset(mscl);
> +	mscl_wait_reset(mscl);
> +
> +	mscl->coeff_type = MSCL_CSC_COEFF_NONE;
> +}
> +
> +static void mscl_check_for_illegal_status(struct device *dev,
> +					  unsigned int irq_status)
> +{
> +	if (irq_status & MSCL_INT_STATUS_TIMEOUT)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_TIMEOUT\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_BLEND)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_BLEND\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_RATIO)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_RATIO\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_HEIGHT)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_HEIGHT\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_WIDTH)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_WIDTH\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_V_POS)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_V_POS\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_H_POS)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_H_POS\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_C_SPAN)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_C_SPAN\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_Y_SPAN)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_Y_SPAN\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_CR_BASE)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_CR_BASE\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_CB_BASE)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_CB_BASE\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_Y_BASE)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_Y_BASE\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_DST_COLOR)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_DST_COLOR\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_HEIGHT)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_HEIGHT\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_WIDTH)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_WIDTH\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_CV_POS)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_CV_POS\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_CH_POS)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_CH_POS\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_YV_POS)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_YV_POS\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_YH_POS)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_YH_POS\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_C_SPAN)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_C_SPAN\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_Y_SPAN)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_Y_SPAN\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_CR_BASE)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_CR_BASE\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_CB_BASE)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_CB_BASE\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_Y_BASE)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_Y_BASE\n");
> +	if (irq_status & MSCL_INT_STATUS_ILLEGAL_SRC_COLOR)
> +		dev_err(dev, "ERROR:: MSCL_INT_STATUS_ILLEGAL_SRC_COLOR\n");

This looks terrible, perhaps you could use similar approach as in the
exynos4-is mipi-csis driver ?

> +}
> +
> +static irqreturn_t mscl_irq_handler(int irq, void *priv)
> +{
> +	struct mscl_dev *mscl = priv;
> +	struct mscl_ctx *ctx;
> +	unsigned int mscl_irq;
> +	struct device *dev = &mscl->pdev->dev;
> +
> +	mscl_irq = mscl_hw_get_irq_status(mscl);
> +	dev_dbg(dev, "irq_status: 0x%x\n", mscl_irq);
> +	mscl_hw_clear_irq(mscl, mscl_irq);
> +
> +	if (mscl_irq & MSCL_INT_STATUS_ERROR)
> +		mscl_check_for_illegal_status(dev, mscl_irq);
> +
> +	if (!(mscl_irq & MSCL_INT_EN_FRAME_END))
> +		return IRQ_HANDLED;
> +
> +	spin_lock(&mscl->slock);
> +
> +	if (test_and_clear_bit(ST_M2M_PEND, &mscl->state)) {
> +
> +		mscl_hw_enable_control(mscl, false);
> +
> +		if (test_and_clear_bit(ST_M2M_SUSPENDING, &mscl->state)) {
> +			set_bit(ST_M2M_SUSPENDED, &mscl->state);
> +			wake_up(&mscl->irq_queue);
> +			goto isr_unlock;
> +		}
> +		ctx = v4l2_m2m_get_curr_priv(mscl->m2m.m2m_dev);
> +
> +		if (!ctx || !ctx->m2m_ctx)
> +			goto isr_unlock;
> +
> +		spin_unlock(&mscl->slock);
> +		mscl_m2m_job_finish(ctx, VB2_BUF_STATE_DONE);
> +
> +		/* wake_up job_abort, stop_streaming */
> +		if (ctx->state & MSCL_CTX_STOP_REQ) {
> +			ctx->state &= ~MSCL_CTX_STOP_REQ;
> +			wake_up(&mscl->irq_queue);
> +		}
> +		return IRQ_HANDLED;
> +	}
> +
> +isr_unlock:
> +	spin_unlock(&mscl->slock);
> +	return IRQ_HANDLED;
> +}
> +
> +static struct mscl_frm_limit mscl_inp_frm_limit = {
> +	.min_w	= 16,
> +	.min_h	= 16,
> +	.max_w	= 8192,
> +	.max_h	= 8192,
> +};
> +
> +static struct mscl_frm_limit mscl_out_frm_limit = {
> +	.min_w	= 4,
> +	.min_h	= 4,
> +	.max_w	= 8192,
> +	.max_h	= 8192,
> +};
> +
> +static struct mscl_pix_align mscl_align_v0 = {
> +	.src_w_420 = 2,
> +	.src_w_422 = 2,
> +	.src_h_420 = 2,
> +	.dst_w_420 = 2,
> +	.dst_w_422 = 2,
> +	.dst_h_420 = 2,
> +};
> +
> +
> +static struct mscl_variant mscl_variant0 = {
> +	.pix_in = &mscl_inp_frm_limit,
> +	.pix_out = &mscl_out_frm_limit,
> +	.pix_align = &mscl_align_v0,
> +	.scl_up_max = 16,
> +	.scl_down_max = 4,
> +	.in_buf_cnt = 32,
> +	.out_buf_cnt = 32,
> +};
> +
> +static struct mscl_driverdata mscl_drvdata = {
> +	.variant = {
> +		[0] = &mscl_variant0,
> +		[1] = &mscl_variant0,
> +		[2] = &mscl_variant0,

I would just using single pointer for now if all the IPs are indentical.

> +	},
> +	.num_entities = 3,

This could be just #defined.

> +	.lclk_frequency = 266000000UL,

And that could be passed from DT through e.g. "clock-frequency" property.

> +};
> +
> +static struct platform_device_id mscl_driver_ids[] = {

You can remove this table completely, it is only for non-dt.

> +	{
> +		.name		= "exynos-mscl",
> +		.driver_data	= (unsigned long)&mscl_drvdata,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(platform, mscl_driver_ids);
> +
> +static const struct of_device_id exynos_mscl_match[] = {
> +	{
> +		.compatible = "samsung,exynos5-mscl",
> +		.data = &mscl_drvdata,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_mscl_match);
> +
> +static void *mscl_get_drv_data(struct platform_device *pdev)
> +{
> +	struct mscl_driverdata *driver_data = NULL;
> +
> +	if (pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +		match = of_match_node(of_match_ptr(exynos_mscl_match),

There is no need for of_match_ptr(), exynos_mscl_match is always compiled in.

> +					pdev->dev.of_node);
> +		if (match)
> +			driver_data = (struct mscl_driverdata *)match->data;
> +	}
> +
> +	return driver_data;
> +}
> +
> +static void mscl_clk_put(struct mscl_dev *mscl)
> +{
> +	if (!IS_ERR(mscl->clock))
> +		clk_unprepare(mscl->clock);
> +}
> +
> +static int mscl_clk_get(struct mscl_dev *mscl)
> +{
> +	int ret;
> +
> +	dev_dbg(&mscl->pdev->dev, "mscl_clk_get Called\n");
> +
> +	mscl->clock = devm_clk_get(&mscl->pdev->dev, MSCL_CLOCK_GATE_NAME);
> +	if (IS_ERR(mscl->clock)) {
> +		dev_err(&mscl->pdev->dev, "failed to get clock~~~: %s\n",
> +			MSCL_CLOCK_GATE_NAME);
> +		return PTR_ERR(mscl->clock);
> +	}
> +
> +	ret = clk_prepare(mscl->clock);
> +	if (ret < 0) {
> +		dev_err(&mscl->pdev->dev, "clock prepare fail for clock: %s\n",
> +			MSCL_CLOCK_GATE_NAME);
> +		mscl->clock = ERR_PTR(-EINVAL);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mscl_m2m_suspend(struct mscl_dev *mscl)
> +{
> +	unsigned long flags;
> +	int timeout;
> +
> +	spin_lock_irqsave(&mscl->slock, flags);
> +	if (!mscl_m2m_pending(mscl)) {
> +		spin_unlock_irqrestore(&mscl->slock, flags);
> +		return 0;
> +	}
> +	clear_bit(ST_M2M_SUSPENDED, &mscl->state);
> +	set_bit(ST_M2M_SUSPENDING, &mscl->state);
> +	spin_unlock_irqrestore(&mscl->slock, flags);
> +
> +	timeout = wait_event_timeout(mscl->irq_queue,
> +			     test_bit(ST_M2M_SUSPENDED, &mscl->state),
> +			     MSCL_SHUTDOWN_TIMEOUT);
> +
> +	clear_bit(ST_M2M_SUSPENDING, &mscl->state);
> +	return timeout == 0 ? -EAGAIN : 0;
> +}
> +
> +static int mscl_m2m_resume(struct mscl_dev *mscl)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&mscl->slock, flags);
> +	/* Clear for full H/W setup in first run after resume */
> +	mscl->m2m.ctx = NULL;
> +	spin_unlock_irqrestore(&mscl->slock, flags);
> +
> +	if (test_and_clear_bit(ST_M2M_SUSPENDED, &mscl->state))
> +		mscl_m2m_job_finish(mscl->m2m.ctx,
> +				    VB2_BUF_STATE_ERROR);
> +	return 0;
> +}

> +#ifdef CONFIG_EXYNOS_IOMMU
> +static int mscl_iommu_init(struct mscl_dev *mscl)
> +{
> +	struct dma_iommu_mapping *mapping;
> +	struct device *dev = &mscl->pdev->dev;
> +
> +	mapping = arm_iommu_create_mapping(&platform_bus_type, 0x20000000,
> +						SZ_256M, 4);
> +	if (mapping == NULL) {
> +		dev_err(dev, "IOMMU mapping failed for MSCL\n");
> +		return -EFAULT;
> +	}
> +
> +	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
> +						GFP_KERNEL);
> +	dma_set_max_seg_size(dev, 0xffffffffu);
> +	arm_iommu_attach_device(dev, mapping);
> +
> +	mscl->mapping = mapping;
> +
> +	return 0;
> +}
> +
> +static void mscl_iommu_deinit(struct mscl_dev *mscl)
> +{
> +	if (mscl->mapping)
> +		arm_iommu_release_mapping(mscl->mapping);
> +
> +	mscl->mapping = NULL;
> +}
> +
> +#else
> +static int mscl_iommu_init(struct mscl_dev *mscl)
> +{
> +	return 0;
> +}
> +
> +static void mscl_iommu_deinit(struct mscl_dev *mscl)
> +{
> +	return;
> +}
> +#endif

These smells bad. It shouldn't be necessary, the memory mappings should
be handled  by videobuf2/dma mapping layer. The drivers should use videobuf2
API for memory buffer management. Whethere there is IOMMU or not should
_not_ be a concern of the driver. The hard coded address space mapping
above looks pretty bad.

I've Cced Marek, Tomasz and Bart so we can figure out the proper way to
handle this.

> +static int mscl_probe(struct platform_device *pdev)
> +{
> +	struct mscl_dev *mscl;
> +	struct resource *res;
> +	struct mscl_driverdata *drv_data = mscl_get_drv_data(pdev);
> +	struct device *dev = &pdev->dev;
> +	int ret = 0;
> +
> +	if (!dev->of_node) {
> +		dev_err(dev, "Invalid device node\n");

Do you really need this log ? It should never trigger in practioce.

> +		return -EINVAL;

ENODEV ?

> +	}
> +
> +	mscl = devm_kzalloc(dev, sizeof(struct mscl_dev), GFP_KERNEL);
> +	if (!mscl)
> +		return -ENOMEM;

> +	mscl->id = of_alias_get_id(pdev->dev.of_node, "mscl");
> +	if (mscl->id < 0 || mscl->id >= drv_data->num_entities) {
> +		dev_err(dev, "Invalid platform device id: %d\n", mscl->id);
> +		return -EINVAL;
> +	}
> +
> +	mscl->variant = drv_data->variant[mscl->id];

This could be removed once you drop DT node aliases and mscl->id.

> +	mscl->pdev = pdev;
> +	mscl->pdata = dev->platform_data;
> +
> +	init_waitqueue_head(&mscl->irq_queue);
> +	spin_lock_init(&mscl->slock);
> +	mutex_init(&mscl->lock);
> +	mscl->clock = ERR_PTR(-EINVAL);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	mscl->regs = devm_request_and_ioremap(dev, res);
> +	if (!mscl->regs)
> +		return -ENODEV;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!res) {
> +		dev_err(dev, "failed to get IRQ resource\n");
> +		return -ENXIO;
> +	}
> +
> +	ret = mscl_clk_get(mscl);
> +	if (ret)
> +		return ret;
> +
> +	if (mscl_iommu_init(mscl)) {

Such details really belong to the IOMMU driver, driver of this IP should
not care much about iommu.

> +		dev_err(&pdev->dev, "IOMMU Initialization failed\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = devm_request_irq(dev, res->start, mscl_irq_handler,
> +				0, pdev->name, mscl);
> +	if (ret) {
> +		dev_err(dev, "failed to install irq (%d)\n", ret);
> +		goto err_clk;
> +	}
> +
> +	ret = mscl_register_m2m_device(mscl);
> +	if (ret)
> +		goto err_clk;
> +
> +	platform_set_drvdata(pdev, mscl);
> +	pm_runtime_enable(dev);
> +	ret = pm_runtime_get_sync(&pdev->dev);
> +	if (ret < 0)
> +		goto err_m2m;
> +
> +	/* Initialize continious memory allocator */

s/continious/the contiguous ?

> +	mscl->alloc_ctx = vb2_dma_contig_init_ctx(dev);
> +	if (IS_ERR(mscl->alloc_ctx)) {
> +		ret = PTR_ERR(mscl->alloc_ctx);
> +		goto err_pm;
> +	}
> +
> +	dev_err(dev, "mscl-%d registered successfully\n", mscl->id);

dev_err() ? As device name is already logged within dev_err() you could
just make it:

	dev_info(dev, "registered successfully\n");

But I would just remove that, there is also a log when device nodes
get created.

> +	pm_runtime_put(dev);
> +	return 0;
> +err_pm:
> +	pm_runtime_put(dev);
> +err_m2m:
> +	mscl_unregister_m2m_device(mscl);
> +err_clk:
> +	mscl_iommu_deinit(mscl);
> +	mscl_clk_put(mscl);
> +	return ret;
> +}
> +
> +static int mscl_remove(struct platform_device *pdev)
> +{
> +	struct mscl_dev *mscl = platform_get_drvdata(pdev);
> +
> +	mscl_unregister_m2m_device(mscl);
> +
> +	vb2_dma_contig_cleanup_ctx(mscl->alloc_ctx);
> +	pm_runtime_disable(&pdev->dev);
> +	mscl_iommu_deinit(mscl);
> +	mscl_clk_put(mscl);
> +
> +	dev_dbg(&pdev->dev, "%s driver unloaded\n", pdev->name);

Is this really needed ?

> +	return 0;
> +}
> +
> +static int mscl_runtime_resume(struct device *dev)
> +{
> +	struct mscl_dev *mscl = dev_get_drvdata(dev);
> +	int ret = 0;
> +
> +	dev_dbg(dev, "mscl%d: state: 0x%lx", mscl->id, mscl->state);
> +
> +	ret = clk_enable(mscl->clock);
> +	if (ret)
> +		return ret;
> +
> +	mscl_sw_reset(mscl);
> +
> +	return mscl_m2m_resume(mscl);

shouldn't there be clk_disable() when mscl_m2m_resume() failes ?

> +}
> +
> +static int mscl_runtime_suspend(struct device *dev)
> +{
> +	struct mscl_dev *mscl = dev_get_drvdata(dev);
> +	int ret = 0;
> +
> +	ret = mscl_m2m_suspend(mscl);
> +	if (!ret)
> +		clk_disable(mscl->clock);
> +
> +	dev_dbg(dev, "mscl%d: state: 0x%lx", mscl->id, mscl->state);
> +	return ret;
> +}
> +
> +static int mscl_resume(struct device *dev)
> +{
> +	struct mscl_dev *mscl = dev_get_drvdata(dev);
> +	unsigned long flags;
> +
> +	dev_dbg(dev, "mscl%d: state: 0x%lx", mscl->id, mscl->state);
> +
> +	/* Do not resume if the device was idle before system suspend */
> +	spin_lock_irqsave(&mscl->slock, flags);
> +	if (!test_and_clear_bit(ST_SUSPEND, &mscl->state) ||
> +	    !mscl_m2m_active(mscl)) {
> +		spin_unlock_irqrestore(&mscl->slock, flags);
> +		return 0;
> +	}
> +
> +	mscl_sw_reset(mscl);
> +	spin_unlock_irqrestore(&mscl->slock, flags);
> +
> +	return mscl_m2m_resume(mscl);
> +}
> +
> +static int mscl_suspend(struct device *dev)
> +{
> +	struct mscl_dev *mscl = dev_get_drvdata(dev);
> +
> +	dev_dbg(dev, "mscl%d: state: 0x%lx", mscl->id, mscl->state);
> +
> +	if (test_and_set_bit(ST_SUSPEND, &mscl->state))
> +		return 0;
> +
> +	return mscl_m2m_suspend(mscl);
> +}
> +
> +static const struct dev_pm_ops mscl_pm_ops = {
> +	.suspend		= mscl_suspend,
> +	.resume			= mscl_resume,
> +	.runtime_suspend	= mscl_runtime_suspend,
> +	.runtime_resume		= mscl_runtime_resume,
> +};
> +
> +static struct platform_driver mscl_driver = {
> +	.probe		= mscl_probe,
> +	.remove		= mscl_remove,
> +	.id_table	= mscl_driver_ids,
> +	.driver = {
> +		.name	= MSCL_MODULE_NAME,
> +		.owner	= THIS_MODULE,
> +		.pm	= &mscl_pm_ops,
> +		.of_match_table = exynos_mscl_match,
> +	}
> +};
> +
> +module_platform_driver(mscl_driver);
> +
> +MODULE_AUTHOR("Shaik Ameer Basha <shaik.ameer@samsung.com>");
> +MODULE_DESCRIPTION("Samsung EXYNOS5 Soc series M-Scaler driver");
> +MODULE_LICENSE("GPL");

"GPL v2" ?

> diff --git a/drivers/media/platform/exynos-mscl/mscl-core.h b/drivers/media/platform/exynos-mscl/mscl-core.h
> new file mode 100644
> index 0000000..09149a2
> --- /dev/null
> +++ b/drivers/media/platform/exynos-mscl/mscl-core.h
> @@ -0,0 +1,549 @@
> +/*
> + * Copyright (c) 2013 - 2014 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * header file for Samsung EXYNOS5 SoC series M-Scaler driver

s/header/Header ?

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef MSCL_CORE_H_
> +#define MSCL_CORE_H_
> +
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "mscl-regs.h"
> +
> +#define CONFIG_VB2_MSCL_DMA_CONTIG	1

Unused ?

> +#define MSCL_MODULE_NAME		"exynos-mscl"

I would make it "exynos5-scaler".

> +#define MSCL_SHUTDOWN_TIMEOUT		((100*HZ)/1000)
> +#define MSCL_MAX_DEVS			4
> +#define MSCL_MAX_CTRL_NUM		10
> +#define MSCL_SC_ALIGN_4			4
> +#define MSCL_SC_ALIGN_2			2
> +#define DEFAULT_CSC_EQ			1
> +#define DEFAULT_CSC_RANGE		1
> +
> +#define MSCL_PARAMS			(1 << 0)
> +#define MSCL_SRC_FMT			(1 << 1)
> +#define MSCL_DST_FMT			(1 << 2)

> +#define MSCL_CTX_M2M			(1 << 3)

Why is this needed ? There is only mem-to-mem functionality available
in this device ?

> +#define MSCL_CTX_STOP_REQ		(1 << 4)
> +
> +enum mscl_dev_flags {
> +	/* for global */
> +	ST_SUSPEND,
> +
> +	/* for m2m node */
> +	ST_M2M_OPEN,
> +	ST_M2M_RUN,
> +	ST_M2M_PEND,
> +	ST_M2M_SUSPENDED,
> +	ST_M2M_SUSPENDING,
> +};

> +enum mscl_irq {
> +	MSCL_INT_FRAME_END = 0,
> +	MSCL_INT_ILLEGAL_SRC_COLOR,
> +	MSCL_INT_ILLEGAL_SRC_Y_BASE,
> +	MSCL_INT_ILLEGAL_SRC_CB_BASE,
> +	MSCL_INT_ILLEGAL_SRC_CR_BASE,
> +	MSCL_INT_ILLEGAL_SRC_Y_SPAN,
> +	MSCL_INT_ILLEGAL_SRC_C_SPAN,
> +	MSCL_INT_ILLEGAL_SRC_YH_POS,
> +	MSCL_INT_ILLEGAL_SRC_YV_POS,
> +	MSCL_INT_ILLEGAL_SRC_CH_POS,
> +	MSCL_INT_ILLEGAL_SRC_CV_POS,
> +	MSCL_INT_ILLEGAL_SRC_WIDTH,
> +	MSCL_INT_ILLEGAL_SRC_HEIGHT,
> +	MSCL_INT_ILLEGAL_DST_COLOR,
> +	MSCL_INT_ILLEGAL_DST_Y_BASE,
> +	MSCL_INT_ILLEGAL_DST_CB_BASE,
> +	MSCL_INT_ILLEGAL_DST_CR_BASE,
> +	MSCL_INT_ILLEGAL_DST_Y_SPAN,
> +	MSCL_INT_ILLEGAL_DST_C_SPAN,
> +	MSCL_INT_ILLEGAL_DST_H_POS,
> +	MSCL_INT_ILLEGAL_DST_V_POS,
> +	MSCL_INT_ILLEGAL_DST_WIDTH,
> +	MSCL_INT_ILLEGAL_DST_HEIGHT,
> +	MSCL_INT_ILLEGAL_RATIO,
> +	MSCL_INT_ILLEGAL_BLEND,
> +	MSCL_INT_TIMEOUT,
> +};

Shouldn't these interrupt mask bits be defined in mscl-regs.h instead ?
And I would prefer it to be done with #define, as these are register
bit definitions ?

> +enum mscl_color_fmt {
> +	MSCL_RGB = (0x1 << 0),
> +	MSCL_YUV420 = (0x1 << 1),
> +	MSCL_YUV422 = (0x1 << 2),
> +	MSCL_YUV444 = (0x1 << 3),
> +};

> +enum mscl_yuv_fmt {
> +	MSCL_CBCR = 0x10,
> +	MSCL_CRCB,
> +};
> +
> +enum mscl_clr_fmt_type {
> +	MSCL_FMT_SRC = (0x1 << 0),
> +	MSCL_FMT_DST = (0x1 << 1),
> +};
> +
> +enum mscl_clr_fmt {
> +	MSCL_YUV420_2P_Y_UV = 0,
> +	MSCL_YUV422_2P_Y_UV = 2,
> +	MSCL_YUV444_2P_Y_UV,
> +	MSCL_RGB565,
> +	MSCL_ARGB1555,
> +	MSCL_ARGB8888,
> +	MSCL_PREMULTIPLIED_ARGB8888,
> +	MSCL_YUV422_1P_YVYU = 9,
> +	MSCL_YUV422_1P_YUYV,
> +	MSCL_YUV422_1P_UYVY,
> +	MSCL_ARGB4444,
> +	MSCL_L8A8,
> +	MSCL_RGBA8888,
> +	MSCL_L8,
> +	MSCL_YUV420_2P_Y_VU,
> +	MSCL_YUV422_2P_Y_VU = 18,
> +	MSCL_YUV444_2P_Y_VU,
> +	MSCL_YUV420_3P_Y_U_V,
> +	MSCL_YUV422_3P_Y_U_V = 22,
> +	MSCL_YUV444_3P_Y_U_V,
> +};
> +
> +#define fh_to_ctx(__fh) container_of(__fh, struct mscl_ctx, fh)
> +#define is_rgb(fmt) (!!(((fmt)->color) & MSCL_RGB))
> +#define is_yuv(fmt) ((fmt->color >= MSCL_YUV420) && (fmt->color <= MSCL_YUV444))
> +#define is_yuv420(fmt) (!!((fmt->color) & MSCL_YUV420))
> +#define is_yuv422(fmt) (!!((fmt->color) & MSCL_YUV422))
> +#define is_yuv422_1p(fmt) (is_yuv422(fmt) && (fmt->num_planes == 1))
> +#define is_yuv420_2p(fmt) (is_yuv420(fmt) && (fmt->num_planes == 2))
> +#define is_yuv422_2p(fmt) (is_yuv422(fmt) && (fmt->num_planes == 2))
> +#define is_yuv42x_2p(fmt) (is_yuv420_2p(fmt) || is_yuv422_2p(fmt))
> +#define is_src_fmt(fmt)	((fmt->mscl_color_fmt_type) & MSCL_FMT_SRC)
> +#define is_dst_fmt(fmt)	((fmt->mscl_color_fmt_type) & MSCL_FMT_DST)
> +
> +#define mscl_m2m_active(dev)	test_bit(ST_M2M_RUN, &(dev)->state)
> +#define mscl_m2m_pending(dev)	test_bit(ST_M2M_PEND, &(dev)->state)
> +#define mscl_m2m_opened(dev)	test_bit(ST_M2M_OPEN, &(dev)->state)
> +
> +#define ctrl_to_ctx(__ctrl) \
> +	container_of((__ctrl)->handler, struct mscl_ctx, ctrl_handler)
> +/**
> + * struct mscl_fmt - the driver's internal color format data
> + * @mbus_code: Media Bus pixel code, -1 if not applicable
> + * @mscl_color: M-Scaler color format
> + * @mscl_color_fmt_type: specifies whether src/dst format
> + * @is_tiled: tiled format or not
> + * @name: format description
> + * @pixelformat: the fourcc code for this format, 0 if not applicable
> + * @corder: Chrominance order control
> + * @num_planes: number of physically non-contiguous data planes
> + * @num_comp: number of physically contiguous data planes
> + * @depth: per plane driver's private 'number of bits per pixel'
> + * @flags: flags indicating which operation mode format applies to
> + */
> +struct mscl_fmt {
> +	enum v4l2_mbus_pixelcode mbus_code;
> +	enum mscl_clr_fmt mscl_color;
> +	enum mscl_clr_fmt_type mscl_color_fmt_type;
> +	u32	is_tiled;
> +	char	*name;
> +	u32	pixelformat;
> +	u32	color;
> +	u32	corder;
> +	u16	num_planes;
> +	u16	num_comp;
> +	u8	depth[VIDEO_MAX_PLANES];
> +	u32	flags;
> +};
> +
> +/**
> + * struct mscl_input_buf - the driver's video buffer
> + * @vb:	videobuf2 buffer
> + * @list : linked list structure for buffer queue
> + * @idx : index of M-Scaler input buffer
> + */
> +struct mscl_input_buf {
> +	struct vb2_buffer	vb;
> +	struct list_head	list;
> +	int			idx;
> +};
> +
> +/**
> + * struct mscl_addr - the M-Scaler physical address set

s/physical/DMA ?

> + * @y:	 luminance plane address
> + * @cb:	 Cb plane address
> + * @cr:	 Cr plane address
> + */
> +struct mscl_addr {
> +	dma_addr_t y;
> +	dma_addr_t cb;
> +	dma_addr_t cr;
> +};
> +
> +/* struct mscl_ctrls - the M-Scaler control set
> + * @rotate: rotation degree
> + * @hflip: horizontal flip
> + * @vflip: vertical flip
> + * @global_alpha: the alpha value of current frame
> + */
> +struct mscl_ctrls {
> +	struct v4l2_ctrl *rotate;
> +	struct v4l2_ctrl *hflip;
> +	struct v4l2_ctrl *vflip;
> +	struct v4l2_ctrl *global_alpha;
> +};
> +
> +/* struct mscl_csc_info - color space conversion information
> + *
> + */
> +enum mscl_csc_coeff {
> +	MSCL_CSC_COEFF_YCBCR_TO_RGB,
> +	MSCL_CSC_COEFF_YCBCR_TO_RGB_OFF16,
> +	MSCL_CSC_COEFF_RGB_TO_YCBCR,
> +	MSCL_CSC_COEFF_RGB_TO_YCBCR_OFF16,
> +	MSCL_CSC_COEFF_MAX,
> +	MSCL_CSC_COEFF_NONE,
> +};
> +
> +struct mscl_csc_info {
> +	enum mscl_csc_coeff coeff_type;
> +};
> +
> +/**
> + * struct mscl_scaler - the configuration data for M-Scaler inetrnal scaler
> + * @hratio:	the main scaler's horizontal ratio
> + * @vratio:	the main scaler's vertical ratio
> + */
> +struct mscl_scaler {
> +	u32 hratio;
> +	u32 vratio;
> +};
> +
> +struct mscl_dev;
> +

nit: unnecessary new line

> +struct mscl_ctx;
> +
> +/**
> + * struct mscl_frame - source/target frame properties
> + * @f_width:	SRC : SRCIMG_WIDTH, DST : OUTPUTDMA_WHOLE_IMG_WIDTH
> + * @f_height:	SRC : SRCIMG_HEIGHT, DST : OUTPUTDMA_WHOLE_IMG_HEIGHT
> + * @crop:	cropped(source)/scaled(destination) size
> + * @payload:	image size in bytes (w x h x bpp)
> + * @addr:	image frame buffer physical addresses
> + * @fmt:	M-Scaler color format pointer
> + * @colorspace: value indicating v4l2_colorspace
> + * @alpha:	frame's alpha value
> + */
> +struct mscl_frame {
> +	u32 f_width;
> +	u32 f_height;
> +	struct v4l2_rect crop;
> +	unsigned long payload[VIDEO_MAX_PLANES];
> +	struct mscl_addr	addr;
> +	const struct mscl_fmt *fmt;
> +	u32 colorspace;
> +	u8 alpha;
> +};
> +
> +/**
> + * struct mscl_m2m_device - v4l2 memory-to-memory device data
> + * @vfd: the video device node for v4l2 m2m mode
> + * @m2m_dev: v4l2 memory-to-memory device data
> + * @ctx: hardware context data
> + * @refcnt: the reference counter
> + */
> +struct mscl_m2m_device {
> +	struct video_device	*vfd;
> +	struct v4l2_m2m_dev	*m2m_dev;
> +	struct mscl_ctx		*ctx;
> +	int			refcnt;
> +};
> +
> +/**
> + *  struct mscl_pix_input - image pixel size limits for input frame
> + *
> + */
> +struct mscl_frm_limit {
> +	u16	min_w;
> +	u16	min_h;
> +	u16	max_w;
> +	u16	max_h;
> +
> +};
> +
> +struct mscl_pix_align {
> +	u16 src_w_420;
> +	u16 src_w_422;
> +	u16 src_h_420;
> +	u16 dst_w_420;
> +	u16 dst_w_422;
> +	u16 dst_h_420;
> +};
> +
> +/**
> + * struct mscl_variant - M-Scaler variant information
> + */
> +struct mscl_variant {
> +	struct mscl_frm_limit	*pix_in;
> +	struct mscl_frm_limit	*pix_out;
> +	struct mscl_pix_align	*pix_align;
> +	u16	scl_up_max;
> +	u16	scl_down_max;
> +	u16	in_buf_cnt;
> +	u16	out_buf_cnt;
> +};
> +
> +/**
> + * struct mscl_driverdata - per device type driver data for init time.
> + *
> + * @variant: the variant information for this driver.
> + * @lclk_frequency: M-Scaler clock frequency
> + * @num_entities: the number of g-scalers
> + */
> +struct mscl_driverdata {
> +	struct mscl_variant *variant[MSCL_MAX_DEVS];
> +	unsigned long	lclk_frequency;
> +	int		num_entities;
> +};
> +
> +/**
> + * struct mscl_dev - abstraction for M-Scaler entity
> + * @slock: the spinlock protecting this data structure
> + * @lock: the mutex protecting this data structure
> + * @pdev: pointer to the M-Scaler platform device
> + * @variant: the IP variant information
> + * @id: M-Scaler device index (0..MSCL_MAX_DEVS)
> + * @clock: clocks required for M-Scaler operation
> + * @regs: the mapped hardware registers
> + * @irq_queue: interrupt handler waitqueue
> + * @m2m: memory-to-memory V4L2 device information
> + * @state: flags used to synchronize m2m and capture mode operation
> + * @alloc_ctx: videobuf2 memory allocator context
> + * @vdev: video device for M-Scaler instance
> + */
> +struct mscl_dev {
> +	spinlock_t			slock;
> +	struct mutex			lock;
> +	struct platform_device		*pdev;
> +	struct mscl_variant		*variant;
> +	u16				id;
> +	struct clk			*clock;
> +	void __iomem			*regs;
> +	wait_queue_head_t		irq_queue;
> +	struct mscl_m2m_device		m2m;
> +	struct exynos_platform_msclaler	*pdata;
> +	unsigned long			state;
> +	struct vb2_alloc_ctx		*alloc_ctx;
> +	struct video_device		vdev;
> +	enum mscl_csc_coeff		coeff_type;

> +#ifdef CONFIG_EXYNOS_IOMMU
> +	struct dma_iommu_mapping	*mapping;
> +#endif

See my comments above about the memory management.

> +};
> +
> +/**
> + * mscl_ctx - the device context data
> + * @s_frame: source frame properties
> + * @d_frame: destination frame properties
> + * @scaler: image scaler properties
> + * @flags: additional flags for image conversion
> + * @state: flags to keep track of user configuration
> + * @mscl_dev: the M-Scaler device this context applies to
> + * @m2m_ctx: memory-to-memory device context
> + * @fh: v4l2 file handle
> + * @ctrl_handler: v4l2 controls handler
> + * @ctrls_mscl: M-Scaler control set
> + * @ctrls_rdy: true if the control handler is initialized
> + */
> +struct mscl_ctx {
> +	struct mscl_frame	s_frame;
> +	struct mscl_frame	d_frame;
> +	struct mscl_scaler	scaler;
> +	u32			flags;
> +	u32			state;
> +	int			rotation;
> +	unsigned int		hflip:1;
> +	unsigned int		vflip:1;
> +	struct mscl_dev		*mscl_dev;
> +	struct v4l2_m2m_ctx	*m2m_ctx;
> +	struct v4l2_fh		fh;
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	struct mscl_ctrls	ctrls_mscl;
> +	bool			ctrls_rdy;
> +};
> +
> +void mscl_set_prefbuf(struct mscl_dev *mscl, struct mscl_frame *frm);
> +int mscl_register_m2m_device(struct mscl_dev *mscl);
> +void mscl_unregister_m2m_device(struct mscl_dev *mscl);
> +void mscl_m2m_job_finish(struct mscl_ctx *ctx, int vb_state);
> +
> +u32 get_plane_size(struct mscl_frame *fr, unsigned int plane);
> +const struct mscl_fmt *mscl_get_format(int index);
> +const struct mscl_fmt *mscl_find_fmt(u32 *pixelformat,
> +				u32 *mbus_code, u32 index);
> +int mscl_enum_fmt_mplane(struct v4l2_fmtdesc *f);
> +int mscl_try_fmt_mplane(struct mscl_ctx *ctx, struct v4l2_format *f);
> +void mscl_set_frame_size(struct mscl_frame *frame, int width, int height);
> +int mscl_g_fmt_mplane(struct mscl_ctx *ctx, struct v4l2_format *f);
> +void mscl_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h);
> +int mscl_g_crop(struct mscl_ctx *ctx, struct v4l2_crop *cr);
> +int mscl_try_crop(struct mscl_ctx *ctx, struct v4l2_crop *cr);
> +int mscl_cal_prescaler_ratio(struct mscl_variant *var, u32 src, u32 dst,
> +							u32 *ratio);
> +void mscl_get_prescaler_shfactor(u32 hratio, u32 vratio, u32 *sh);
> +void mscl_check_src_scale_info(struct mscl_variant *var,
> +				struct mscl_frame *s_frame,
> +				u32 *wratio, u32 tx, u32 ty, u32 *hratio);
> +int mscl_check_scaler_ratio(struct mscl_variant *var, int sw, int sh, int dw,
> +			   int dh, int rot);
> +int mscl_set_scaler_info(struct mscl_ctx *ctx);
> +int mscl_ctrls_create(struct mscl_ctx *ctx);
> +void mscl_ctrls_delete(struct mscl_ctx *ctx);
> +int mscl_prepare_addr(struct mscl_ctx *ctx, struct vb2_buffer *vb,
> +		     struct mscl_frame *frame, struct mscl_addr *addr);
> +
> +static inline void mscl_ctx_state_lock_set(u32 state, struct mscl_ctx *ctx)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ctx->mscl_dev->slock, flags);
> +	ctx->state |= state;
> +	spin_unlock_irqrestore(&ctx->mscl_dev->slock, flags);
> +}
> +
> +static inline void mscl_ctx_state_lock_clear(u32 state, struct mscl_ctx *ctx)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ctx->mscl_dev->slock, flags);
> +	ctx->state &= ~state;
> +	spin_unlock_irqrestore(&ctx->mscl_dev->slock, flags);
> +}
> +
> +static inline int is_tiled(const struct mscl_fmt *fmt)
> +{
> +	return fmt->pixelformat == V4L2_PIX_FMT_NV12MT_16X16;
> +}

> +static inline void mscl_hw_src_y_offset_en(struct mscl_dev *dev, bool on)
> +{
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + MSCL_CFG);
> +	if (on)
> +		cfg |= MSCL_CFG_CSC_Y_OFFSET_SRC_EN;

nit: WRT the register names, it probably makes sense to use SCALER_
prefix, to keep the names as they appear in the documentation.

> +	else
> +		cfg &= ~MSCL_CFG_CSC_Y_OFFSET_SRC_EN;
> +
> +	writel(cfg, dev->regs + MSCL_CFG);
> +}
> +
> +static inline void mscl_hw_dst_y_offset_en(struct mscl_dev *dev, bool on)
> +{
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + MSCL_CFG);
> +	if (on)
> +		cfg |= MSCL_CFG_CSC_Y_OFFSET_DST_EN;
> +	else
> +		cfg &= ~MSCL_CFG_CSC_Y_OFFSET_DST_EN;
> +
> +	writel(cfg, dev->regs + MSCL_CFG);
> +}
> +
> +static inline void mscl_hw_enable_control(struct mscl_dev *dev, bool on)
> +{
> +	u32 cfg;
> +
> +	if (on)
> +		writel(0xFFFFFFFF, dev->regs + MSCL_INT_EN);

nit: please use lower case

> +	cfg = readl(dev->regs + MSCL_CFG);
> +	cfg |= MSCL_CFG_16_BURST_MODE;
> +	if (on)
> +		cfg |= MSCL_CFG_START_CMD;
> +	else
> +		cfg &= ~MSCL_CFG_START_CMD;
> +
> +	dev_dbg(&dev->pdev->dev,
> +		"mscl_hw_enable_control: MSCL_CFG:0x%x\n", cfg);

"%s: MSCL_CFG:0x%x\n", __func__, ... ?

> +
> +	writel(cfg, dev->regs + MSCL_CFG);
> +}

I would put these three in the mscl-regs.c file.

> +static inline unsigned int mscl_hw_get_irq_status(struct mscl_dev *dev)
> +{
> +	return readl(dev->regs + MSCL_INT_STATUS);
> +}
> +
> +static inline void mscl_hw_clear_irq(struct mscl_dev *dev, unsigned int irq)
> +{
> +	writel(irq, dev->regs + MSCL_INT_STATUS);
> +}

> +static inline void mscl_lock(struct vb2_queue *vq)
> +{
> +	struct mscl_ctx *ctx = vb2_get_drv_priv(vq);
> +	mutex_lock(&ctx->mscl_dev->lock);
> +}
> +
> +static inline void mscl_unlock(struct vb2_queue *vq)
> +{
> +	struct mscl_ctx *ctx = vb2_get_drv_priv(vq);
> +	mutex_unlock(&ctx->mscl_dev->lock);
> +}

These are misplaced too, but if you will use my m2m helper function
those won't be needed any more.

Those callbacks are assigned to the vb2 queue ops, so defining them
in a header file as 'static inline' is really a *bad* idea.

> +static inline bool mscl_ctx_state_is_set(u32 mask, struct mscl_ctx *ctx)
> +{
> +	unsigned long flags;
> +	bool ret;
> +
> +	spin_lock_irqsave(&ctx->mscl_dev->slock, flags);
> +	ret = (ctx->state & mask) == mask;
> +	spin_unlock_irqrestore(&ctx->mscl_dev->slock, flags);
> +	return ret;
> +}
> +
> +static inline struct mscl_frame *ctx_get_frame(struct mscl_ctx *ctx,
> +					      enum v4l2_buf_type type)
> +{
> +	struct mscl_frame *frame;
> +
> +	if (V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE == type) {
> +		frame = &ctx->s_frame;
> +	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE == type) {
> +		frame = &ctx->d_frame;
> +	} else {
> +		dev_dbg(&ctx->mscl_dev->pdev->dev,
> +			"Wrong buffer/video queue type (%d)", type);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	return frame;
> +}

This function seems too big to be in this header as 'static inline'.

> +void mscl_hw_set_sw_reset(struct mscl_dev *dev);
> +int mscl_wait_reset(struct mscl_dev *dev);
> +void mscl_hw_set_irq_mask(struct mscl_dev *dev, int interrupt, bool mask);
> +void mscl_hw_set_input_addr(struct mscl_dev *dev, struct mscl_addr *addr);
> +void mscl_hw_set_output_addr(struct mscl_dev *dev, struct mscl_addr *addr);
> +void mscl_hw_set_in_size(struct mscl_ctx *ctx);
> +void mscl_hw_set_in_image_format(struct mscl_ctx *ctx);
> +void mscl_hw_set_out_size(struct mscl_ctx *ctx);
> +void mscl_hw_set_out_image_format(struct mscl_ctx *ctx);
> +void mscl_hw_set_scaler_ratio(struct mscl_ctx *ctx);
> +void mscl_hw_set_rotation(struct mscl_ctx *ctx);
> +void mscl_hw_address_queue_reset(struct mscl_ctx *ctx);
> +void mscl_hw_set_csc_coeff(struct mscl_ctx *ctx);

Shouldn't these declarations be a part of mscl-regs.h instead ?

> +#endif /* MSCL_CORE_H_ */


Thanks,
Sylwester
