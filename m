Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:42379 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3IOW2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Sep 2013 18:28:35 -0400
Message-ID: <52363487.6010408@gmail.com>
Date: Mon, 16 Sep 2013 00:28:23 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com, posciak@google.com, inki.dae@samsung.com,
	hverkuil@xs4all.nl
Subject: Re: [PATCH v3 2/4] [media] exynos-scaler: Add core functionality
 for the SCALER driver
References: <1378991371-24428-1-git-send-email-shaik.ameer@samsung.com> <1378991371-24428-3-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1378991371-24428-3-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

Thanks for addressing my comments, it really looks much better now.
I have few more comments, mostly minor issues.

On 09/12/2013 03:09 PM, Shaik Ameer Basha wrote:
> This patch adds the core functionality for the SCALER driver.
>
> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> ---
>   drivers/media/platform/exynos-scaler/scaler.c | 1261 +++++++++++++++++++++++++
>   drivers/media/platform/exynos-scaler/scaler.h |  385 ++++++++
>   2 files changed, 1646 insertions(+)
>   create mode 100644 drivers/media/platform/exynos-scaler/scaler.c
>   create mode 100644 drivers/media/platform/exynos-scaler/scaler.h
>
> diff --git a/drivers/media/platform/exynos-scaler/scaler.c b/drivers/media/platform/exynos-scaler/scaler.c
> new file mode 100644
> index 0000000..c22707c
> --- /dev/null
> +++ b/drivers/media/platform/exynos-scaler/scaler.c
> @@ -0,0 +1,1261 @@
> +/*
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Samsung EXYNOS5 SoC series SCALER driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include<linux/clk.h>
> +#include<linux/interrupt.h>
> +#include<linux/module.h>
> +#include<linux/of_platform.h>
> +#include<linux/pm_runtime.h>
> +
> +#include "scaler-regs.h"
> +
> +#define SCALER_CLOCK_GATE_NAME	"scaler"
> +
> +static const struct scaler_fmt scaler_formats[] = {
> +	{
> +		.name		= "YUV 4:2:0 non-contig. 2p, Y/CbCr",
> +		.pixelformat	= V4L2_PIX_FMT_NV12M,
> +		.depth		= { 8, 4 },
> +		.color		= SCALER_YUV420,
> +		.color_order	= SCALER_CBCR,
> +		.num_planes	= 2,
> +		.num_comp	= 2,
> +		.scaler_color	= SCALER_YUV420_2P_Y_UV,
> +		.flags		= (SCALER_FMT_SRC | SCALER_FMT_DST),
> +
> +	}, {
[...]
> +};
> +
> +const struct scaler_fmt *scaler_get_format(int index)
> +{
> +	if (index>= ARRAY_SIZE(scaler_formats))
> +		return NULL;
> +
> +	return&scaler_formats[index];
> +}
> +
> +const struct scaler_fmt *scaler_find_fmt(u32 *pixelformat,
> +				u32 *mbus_code, u32 index)
> +{
> +	const struct scaler_fmt *fmt, *def_fmt = NULL;
> +	unsigned int i;
> +
> +	if (index>= ARRAY_SIZE(scaler_formats))
> +		return NULL;
> +
> +	for (i = 0; i<  ARRAY_SIZE(scaler_formats); ++i) {
> +		fmt = scaler_get_format(i);
> +		if (pixelformat&&  fmt->pixelformat == *pixelformat)
> +			return fmt;

> +		if (mbus_code&&  fmt->mbus_code == *mbus_code)
> +			return fmt;

is mbus_code ever used ?

> +		if (index == i)
> +			def_fmt = fmt;
> +	}
> +
> +	return def_fmt;
> +}
> +
> +void scaler_set_frame_size(struct scaler_frame *frame, int width, int height)
> +{
> +	frame->f_width	= width;
> +	frame->f_height	= height;
> +	frame->crop.width = width;
> +	frame->crop.height = height;
> +	frame->crop.left = 0;
> +	frame->crop.top = 0;
> +}
> +
> +int scaler_enum_fmt_mplane(struct v4l2_fmtdesc *f)
> +{
> +	const struct scaler_fmt *fmt;
> +
> +	fmt = scaler_find_fmt(NULL, NULL, f->index);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	/*
> +	 * Input supports all scaler_formats but all scaler_formats are not
> +	 * supported for output. Don't return unsupported formats for output.
> +	 */
> +	if (!(V4L2_TYPE_IS_OUTPUT(f->type)&&
> +	    (fmt->flags&  SCALER_FMT_SRC)))
> +		return -EINVAL;
> +
> +	strlcpy(f->description, fmt->name, sizeof(f->description));
> +	f->pixelformat = fmt->pixelformat;
> +
> +	return 0;
> +}
> +
> +struct scaler_frame *ctx_get_frame(struct scaler_ctx *ctx,
> +					      enum v4l2_buf_type type)
> +{
> +	struct scaler_frame *frame;
> +
> +	if (V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE == type) {
> +		frame =&ctx->s_frame;
> +	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE == type) {
> +		frame =&ctx->d_frame;
> +	} else {
> +		scaler_dbg(ctx->scaler_dev,
> +			"Wrong buffer/video queue type (%d)", type);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	return frame;
> +}

How about something like:

struct scaler_frame *ctx_get_frame(struct scaler_ctx *ctx,
					      enum v4l2_buf_type type)
{
	struct scaler_frame *frame;

	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
		return &ctx->s_frame;

	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
		return &ctx->d_frame;

	scaler_dbg(ctx->scaler_dev, "Wrong buffer/video queue type (%d)", type);
	return ERR_PTR(-EINVAL);
}

?
> +static u32 get_plane_info(struct scaler_frame *frm, u32 addr, u32 *index)
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
> +	}
> +
> +	pr_debug("Plane address is wrong");

Missing "\n".

> +	return -EINVAL;
> +}
> +
> +void scaler_set_prefbuf(struct scaler_dev *scaler, struct scaler_frame *frm)
> +{
> +	u32 f_chk_addr, f_chk_len, s_chk_addr, s_chk_len;
> +	f_chk_addr = f_chk_len = s_chk_addr = s_chk_len = 0;
> +
> +	f_chk_addr = frm->addr.y;
> +	f_chk_len = frm->payload[0];

nit: an empty line here ?

> +	if (frm->fmt->num_planes == 2) {
> +		s_chk_addr = frm->addr.cb;
> +		s_chk_len = frm->payload[1];
> +	} else if (frm->fmt->num_planes == 3) {
> +		u32 low_addr, low_plane, mid_addr, mid_plane;
> +		u32 high_addr, high_plane;
> +		u32 t_min, t_max;
> +
> +		t_min = min3(frm->addr.y, frm->addr.cb, frm->addr.cr);
> +		low_addr = get_plane_info(frm, t_min,&low_plane);
> +		t_max = max3(frm->addr.y, frm->addr.cb, frm->addr.cr);
> +		high_addr = get_plane_info(frm, t_max,&high_plane);
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
> +		if (mid_addr + frm->payload[mid_plane] - low_addr>
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
> +
> +	scaler_dbg(scaler,
> +		"f_addr = 0x%08x, f_len = %d, s_addr = 0x%08x, s_len = %d\n",
> +		f_chk_addr, f_chk_len, s_chk_addr, s_chk_len);
> +}
> +
> +int scaler_try_fmt_mplane(struct scaler_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct scaler_dev *scaler = ctx->scaler_dev;
> +	struct device *dev =&scaler->pdev->dev;
> +	struct scaler_variant *variant = scaler->variant;
> +	struct v4l2_pix_format_mplane *pix_mp =&f->fmt.pix_mp;
> +	const struct scaler_fmt *fmt;
> +	u32 max_w, max_h, mod_w = 0, mod_h = 0;
> +	u32 min_w, min_h, tmp_w, tmp_h;
> +	int i;
> +	struct scaler_frm_limit *frm_limit;
> +
> +	scaler_dbg(scaler, "user put w: %d, h: %d",
> +			pix_mp->width, pix_mp->height);
> +
> +	fmt = scaler_find_fmt(&pix_mp->pixelformat, NULL, 0);
> +	if (!fmt) {
> +		scaler_dbg(scaler, "pixelformat format (0x%X) invalid\n",
> +					pix_mp->pixelformat);
> +		/* Falling back to default pixel format */
> +		fmt = scaler_find_fmt(NULL, NULL, 0);
> +		pix_mp->pixelformat = fmt->pixelformat;

Ick, why not make scaler_find_fmt() always return first format from
the scaler_formats[] array when the third argument is 0 ? When it's
-1 the function could return NULL if unsupported fourcc is passed
as the first argument. And the second argument seems to be always
being set to NULL. What would you need media bus codes in a video
mem-to-mem driver in the first place ? ;)

> +	}
> +
> +	pix_mp->field = V4L2_FIELD_NONE;
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
> +	/* Span has to be even number for YCbCr422-2p or YCbCr420 format. */
> +	if (is_yuv422_2p(fmt) || is_yuv420(fmt))
> +		mod_w = 1;
> +
> +	scaler_dbg(scaler, "mod_w: %d, mod_h: %d, max_w: %d, max_h = %d",
> +			mod_w, mod_h, max_w, max_h);
> +
> +	/*
> +	 * To check if image size is modified to adjust parameter against
> +	 * hardware abilities.

This sentence doesn't parse.

> +	 */
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
> +	/*
> +	 * Nothing mentioned about the colorspace in SCALER. Default value is
> +	 * set to V4L2_COLORSPACE_REC709.
> +	 */

Isn't scaler_hw_set_csc_coef() function configuring the colorspace ?

> +	pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> +
> +	for (i = 0; i<  pix_mp->num_planes; ++i) {
> +		int bpl = (pix_mp->width * fmt->depth[i])>>  3;
> +		pix_mp->plane_fmt[i].bytesperline = bpl;
> +		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
> +
> +		scaler_dbg(scaler, "[%d]: bpl: %d, sizeimage: %d",
> +				i, bpl, pix_mp->plane_fmt[i].sizeimage);
> +	}
> +
> +	return 0;
> +}
> +
> +int scaler_g_fmt_mplane(struct scaler_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct scaler_frame *frame;
> +	struct v4l2_pix_format_mplane *pix_mp;
> +	int i;
> +
> +	frame = ctx_get_frame(ctx, f->type);
> +	if (IS_ERR(frame))
> +		return PTR_ERR(frame);
> +
> +	pix_mp =&f->fmt.pix_mp;
> +
> +	pix_mp->width		= frame->f_width;
> +	pix_mp->height		= frame->f_height;
> +	pix_mp->field		= V4L2_FIELD_NONE;
> +	pix_mp->pixelformat	= frame->fmt->pixelformat;
> +	pix_mp->colorspace	= V4L2_COLORSPACE_REC709;
> +	pix_mp->num_planes	= frame->fmt->num_planes;
> +
> +	for (i = 0; i<  pix_mp->num_planes; ++i) {
> +		pix_mp->plane_fmt[i].bytesperline = (frame->f_width *
> +			frame->fmt->depth[i]) / 8;
> +		pix_mp->plane_fmt[i].sizeimage =
> +			 pix_mp->plane_fmt[i].bytesperline * frame->f_height;
> +	}
> +
> +	return 0;
> +}
> +
> +void scaler_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h)
> +{
> +	if (tmp_w != *w || tmp_h != *h) {
> +		pr_info("Cropped size has been modified from %dx%d to %dx%d",
> +							*w, *h, tmp_w, tmp_h);
> +		*w = tmp_w;
> +		*h = tmp_h;
> +	}
> +}
> +
> +int scaler_g_crop(struct scaler_ctx *ctx, struct v4l2_crop *cr)
> +{
> +	struct scaler_frame *frame;
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
> +int scaler_try_crop(struct scaler_ctx *ctx, struct v4l2_crop *cr)
> +{
> +	struct scaler_frame *f;
> +	const struct scaler_fmt *fmt;
> +	struct scaler_dev *scaler = ctx->scaler_dev;
> +	struct scaler_variant *variant = scaler->variant;
> +	u32 mod_w = 0, mod_h = 0, tmp_w, tmp_h;
> +	u32 min_w, min_h, max_w, max_h;
> +	struct scaler_frm_limit *frm_limit;
> +
> +	if (cr->c.top<  0) {
> +		scaler_dbg(scaler, "Adjusting crop.top value\n");
> +		cr->c.top = 0;
> +	}
> +
> +	if (cr->c.left<  0) {
> +		scaler_dbg(scaler, "Adjusting crop.left value\n");
> +		cr->c.left = 0;
> +	}
> +
> +	scaler_dbg(scaler, "user requested width: %d, height: %d",
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
> +		if (ctx->ctrls_scaler.rotate->val == 90 ||
> +		    ctx->ctrls_scaler.rotate->val == 270) {
> +			max_w = f->f_height;
> +			max_h = f->f_width;
> +			tmp_w = cr->c.height;
> +			tmp_h = cr->c.width;
> +		}
> +	}
> +
> +	scaler_dbg(scaler, "mod_x: %d, mod_y: %d, min_w: %d, min_h = %d, tmp_w : %d, tmp_h : %d",
> +			mod_w, mod_h, min_w, min_h, tmp_w, tmp_h);
> +
> +	v4l_bound_align_image(&tmp_w, min_w, max_w, mod_w,
> +			&tmp_h, min_h, max_h, mod_h, 0);
> +
> +	if (!V4L2_TYPE_IS_OUTPUT(cr->type)&&
> +		(ctx->ctrls_scaler.rotate->val == 90 ||
> +		 ctx->ctrls_scaler.rotate->val == 270))
> +		scaler_check_crop_change(tmp_h, tmp_w,
> +					&cr->c.width,&cr->c.height);
> +	else
> +		scaler_check_crop_change(tmp_w, tmp_h,
> +					&cr->c.width,&cr->c.height);
> +
> +	/*
> +	 * Adjust left/top if cropping rectangle is out of bounds. Need to add
> +	 * code to algin left value with 2's multiple.
> +	 */
> +	if (cr->c.left + tmp_w>  max_w)
> +		cr->c.left = max_w - tmp_w;
> +	if (cr->c.top + tmp_h>  max_h)
> +		cr->c.top = max_h - tmp_h;
> +
> +	if (is_yuv422_1p(fmt)&&  (cr->c.left&  1))
> +		cr->c.left -= 1;
> +
> +	scaler_dbg(scaler, "Aligned l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
> +	    cr->c.left, cr->c.top, cr->c.width, cr->c.height, max_w, max_h);
> +
> +	return 0;
> +}
> +
> +int scaler_check_scaler_ratio(struct scaler_variant *var, int sw, int sh,
> +					int dw, int dh, int rot)
> +{
> +	if ((dw == 0) || (dh == 0))
> +		return -EINVAL;
> +
> +	if (rot == 90 || rot == 270)
> +		swap(dh, dw);
> +
> +	pr_debug("sw: %d, sh: %d, dw: %d, dh: %d\n", sw, sh, dw, dh);
> +
> +	if ((sw / dw)>  var->scl_down_max || (sh / dh)>  var->scl_down_max ||
> +	    (dw / sw)>  var->scl_up_max   || (dh / sh)>  var->scl_up_max)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +int scaler_set_scaler_info(struct scaler_ctx *ctx)
> +{
> +	struct scaler_scaler *sc =&ctx->scaler;
> +	struct scaler_frame *s_frame =&ctx->s_frame;
> +	struct scaler_frame *d_frame =&ctx->d_frame;
> +	struct scaler_variant *variant = ctx->scaler_dev->variant;
> +	int src_w, src_h, ret;
> +
> +	ret = scaler_check_scaler_ratio(variant,
> +				s_frame->crop.width, s_frame->crop.height,
> +				d_frame->crop.width, d_frame->crop.height,
> +				ctx->ctrls_scaler.rotate->val);
> +	if (ret<  0) {
> +		scaler_dbg(ctx->scaler_dev, "out of scaler range\n");
> +		return ret;
> +	}
> +
> +	if (ctx->ctrls_scaler.rotate->val == 90 ||
> +		ctx->ctrls_scaler.rotate->val == 270) {
> +		src_w = s_frame->crop.height;
> +		src_h = s_frame->crop.width;
> +	} else {
> +		src_w = s_frame->crop.width;
> +		src_h = s_frame->crop.height;
> +	}
> +
> +	sc->hratio = (src_w<<  16) / d_frame->crop.width;
> +	sc->vratio = (src_h<<  16) / d_frame->crop.height;
> +
> +	scaler_dbg(ctx->scaler_dev, "scaler settings::\n"
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
> +static int __scaler_try_ctrl(struct scaler_ctx *ctx, struct v4l2_ctrl *ctrl)
> +{
> +	struct scaler_dev *scaler = ctx->scaler_dev;
> +	struct scaler_variant *variant = scaler->variant;
> +	int ret = 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_ROTATE:
> +		ret = scaler_check_scaler_ratio(variant,
> +			ctx->s_frame.crop.width, ctx->s_frame.crop.height,
> +			ctx->d_frame.crop.width, ctx->d_frame.crop.height,
> +			ctx->ctrls_scaler.rotate->val);

Why not just make it:
		return scaler_check_scaler_ratio(...)

?
> +
> +		if (ret<  0)
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int scaler_try_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct scaler_ctx *ctx = ctrl_to_ctx(ctrl);
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&ctx->scaler_dev->slock, flags);
> +	ret = __scaler_try_ctrl(ctx, ctrl);
> +	spin_unlock_irqrestore(&ctx->scaler_dev->slock, flags);
> +
> +	return ret;
> +}
> +
> +static int __scaler_s_ctrl(struct scaler_ctx *ctx, struct v4l2_ctrl *ctrl)
> +{
> +	struct scaler_dev *scaler = ctx->scaler_dev;
> +	struct scaler_variant *variant = scaler->variant;
> +	int ret = 0;
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
> +		ret = scaler_check_scaler_ratio(variant,
> +			ctx->s_frame.crop.width, ctx->s_frame.crop.height,
> +			ctx->d_frame.crop.width, ctx->d_frame.crop.height,
> +			ctx->ctrls_scaler.rotate->val);
> +
> +		if (ret<  0)
> +			return -EINVAL;
> +
> +		ctx->rotation = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_ALPHA_COMPONENT:
> +		ctx->d_frame.alpha = ctrl->val;
> +		break;
> +	}
> +
> +	ctx->state |= SCALER_PARAMS;
> +	return 0;
> +}
> +
> +static int scaler_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct scaler_ctx *ctx = ctrl_to_ctx(ctrl);
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&ctx->scaler_dev->slock, flags);
> +	ret = __scaler_s_ctrl(ctx, ctrl);
> +	spin_unlock_irqrestore(&ctx->scaler_dev->slock, flags);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops scaler_ctrl_ops = {
> +	.try_ctrl = scaler_try_ctrl,
> +	.s_ctrl = scaler_s_ctrl,
> +};
> +
> +int scaler_ctrls_create(struct scaler_ctx *ctx)
> +{
> +	if (ctx->ctrls_rdy) {
> +		scaler_dbg(ctx->scaler_dev,
> +			"Control handler of this ctx was created already");
> +		return 0;
> +	}
> +
> +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, SCALER_MAX_CTRL_NUM);
> +
> +	ctx->ctrls_scaler.rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +		&scaler_ctrl_ops, V4L2_CID_ROTATE, 0, 270, 90, 0);
> +	ctx->ctrls_scaler.hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +		&scaler_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	ctx->ctrls_scaler.vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +		&scaler_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	ctx->ctrls_scaler.global_alpha = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +		&scaler_ctrl_ops, V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 0);
> +
> +	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
> +
> +	if (ctx->ctrl_handler.error) {
> +		int err = ctx->ctrl_handler.error;
> +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +		scaler_dbg(ctx->scaler_dev,
> +			"Failed to create SCALER control handlers");
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +void scaler_ctrls_delete(struct scaler_ctx *ctx)
> +{
> +	if (ctx->ctrls_rdy) {
> +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +		ctx->ctrls_rdy = false;
> +	}
> +}
> +
> +/* The color format (num_comp, num_planes) must be already configured. */
> +int scaler_prepare_addr(struct scaler_ctx *ctx, struct vb2_buffer *vb,
> +			struct scaler_frame *frame, struct scaler_addr *addr)
> +{
> +	int ret = 0;
> +	u32 pix_size;
> +	const struct scaler_fmt *fmt;
> +
> +	if (vb == NULL || frame == NULL)
> +		return -EINVAL;
> +
> +	pix_size = frame->f_width * frame->f_height;
> +	fmt = frame->fmt;
> +
> +	scaler_dbg(ctx->scaler_dev,
> +			"planes= %d, comp= %d, pix_size= %d, fmt = %d\n",
> +			fmt->num_planes, fmt->num_comp,
> +			pix_size, fmt->scaler_color);
> +
> +	addr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +	if (fmt->num_planes == 1) {
> +		switch (fmt->num_comp) {
> +		case 1:
> +			addr->cb = 0;
> +			addr->cr = 0;
> +			break;
> +		case 2:
> +			/* Decompose Y into Y/Cb */
> +			addr->cb = (dma_addr_t)(addr->y + pix_size);
> +			addr->cr = 0;
> +			break;
> +		case 3:
> +			/* Decompose Y into Y/Cb/Cr */
> +			addr->cb = (dma_addr_t)(addr->y + pix_size);
> +			if (SCALER_YUV420 == fmt->color)
> +				addr->cr = (dma_addr_t)(addr->cb
> +						+ (pix_size>>  2));
> +			else if (SCALER_YUV422 == fmt->color)
> +				addr->cr = (dma_addr_t)(addr->cb
> +						+ (pix_size>>  1));
> +			else /* 444 */
> +				addr->cr = (dma_addr_t)(addr->cb + pix_size);
> +			break;
> +		default:
> +			scaler_dbg(ctx->scaler_dev,
> +				"Invalid number of color planes\n");
> +			return -EINVAL;
> +		}
> +	} else {
> +		if (fmt->num_planes>= 2)
> +			addr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
> +
> +		if (fmt->num_planes == 3)
> +			addr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
> +	}
> +
> +	if ((fmt->color_order == SCALER_CRCB)&&  (fmt->num_planes == 3))
> +		swap(addr->cb, addr->cr);
> +
> +	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type))
> +		scaler_dbg(ctx->scaler_dev,
> +			 "\nIN:ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d\n",
> +			 addr->y, addr->cb, addr->cr, ret);
> +	else
> +		scaler_dbg(ctx->scaler_dev,
> +			 "\nOUT:ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d\n",
> +			 addr->y, addr->cb, addr->cr, ret);
> +
> +	return ret;
> +}
> +
> +static void scaler_sw_reset(struct scaler_dev *scaler)
> +{
> +	scaler_hw_set_sw_reset(scaler);
> +	scaler_wait_reset(scaler);
> +
> +	scaler->coeff_type = SCALER_CSC_COEFF_NONE;
> +}
> +
> +static void scaler_check_for_illegal_status(struct device *dev,
> +					  unsigned int irq_status)
> +{
> +	int i;
> +
> +	for (i = 0; i<  SCALER_NUM_ERRORS; i++)
> +		if ((1<<  scaler_errors[i].irq_num)&  irq_status)
> +			dev_err(dev, "ERROR:: %s\n", scaler_errors[i].name);
> +}
> +
> +static irqreturn_t scaler_irq_handler(int irq, void *priv)
> +{
> +	struct scaler_dev *scaler = priv;
> +	struct scaler_ctx *ctx;
> +	unsigned int scaler_irq;
> +	struct device *dev =&scaler->pdev->dev;
> +
> +	scaler_irq = scaler_hw_get_irq_status(scaler);
> +	scaler_dbg(scaler, "irq_status: 0x%x\n", scaler_irq);
> +	scaler_hw_clear_irq(scaler, scaler_irq);
> +
> +	if (scaler_irq&  SCALER_INT_STATUS_ERROR)
> +		scaler_check_for_illegal_status(dev, scaler_irq);
> +
> +	if (!(scaler_irq&  (1<<  SCALER_INT_FRAME_END)))
> +		return IRQ_HANDLED;
> +
> +	spin_lock(&scaler->slock);
> +
> +	if (test_and_clear_bit(ST_M2M_PEND,&scaler->state)) {
> +
> +		scaler_hw_enable_control(scaler, false);
> +
> +		if (test_and_clear_bit(ST_M2M_SUSPENDING,&scaler->state)) {
> +			set_bit(ST_M2M_SUSPENDED,&scaler->state);
> +			wake_up(&scaler->irq_queue);
> +			goto isr_unlock;
> +		}
> +		ctx = v4l2_m2m_get_curr_priv(scaler->m2m.m2m_dev);
> +
> +		if (!ctx || !ctx->m2m_ctx)
> +			goto isr_unlock;
> +
> +		spin_unlock(&scaler->slock);
> +		scaler_m2m_job_finish(ctx, VB2_BUF_STATE_DONE);
> +
> +		/* wake_up job_abort, stop_streaming */
> +		if (ctx->state&  SCALER_CTX_STOP_REQ) {
> +			ctx->state&= ~SCALER_CTX_STOP_REQ;
> +			wake_up(&scaler->irq_queue);
> +		}
> +		return IRQ_HANDLED;
> +	}
> +
> +isr_unlock:
> +	spin_unlock(&scaler->slock);
> +	return IRQ_HANDLED;
> +}
> +
> +static struct scaler_frm_limit scaler_frm_limit_5410 = {
> +	.min_w = 4,
> +	.min_h = 4,
> +	.max_w = 4096,
> +	.max_h = 4096,
> +};
> +
> +static struct scaler_frm_limit scaler_inp_frm_limit_5420 = {
> +	.min_w = 16,
> +	.min_h = 16,
> +	.max_w = 8192,
> +	.max_h = 8192,
> +};
> +
> +static struct scaler_frm_limit scaler_out_frm_limit_5420 = {
> +	.min_w = 4,
> +	.min_h = 4,
> +	.max_w = 8192,
> +	.max_h = 8192,
> +};
> +
> +static struct scaler_pix_align scaler_align_info = {
> +	.src_w_420 = 2,
> +	.src_w_422 = 2,
> +	.src_h_420 = 2,
> +	.dst_w_420 = 2,
> +	.dst_w_422 = 2,
> +	.dst_h_420 = 2,
> +};
> +
> +
> +static struct scaler_variant scaler_variant_info_5410 = {
> +	.pix_in =&scaler_frm_limit_5410,
> +	.pix_out =&scaler_frm_limit_5410,
> +	.pix_align =&scaler_align_info,
> +	.scl_up_max = 16,
> +	.scl_down_max = 4,
> +	.in_buf_cnt = 32,
> +	.out_buf_cnt = 32,

nit: How about aligning these with tabs.

> +};
> +
> +static struct scaler_variant scaler_variant_info_5420 = {
> +	.pix_in =&scaler_inp_frm_limit_5420,
> +	.pix_out =&scaler_out_frm_limit_5420,
> +	.pix_align =&scaler_align_info,
> +	.scl_up_max = 16,
> +	.scl_down_max = 4,
> +	.in_buf_cnt = 32,
> +	.out_buf_cnt = 32,

Ditto.

> +};
> +
> +static const struct of_device_id exynos_scaler_match[] = {
> +	{
> +		.compatible = "samsung,exynos5410-scaler",
> +		.data =&scaler_variant_info_5410,
> +	},
> +	{
> +		.compatible = "samsung,exynos5420-scaler",
> +		.data =&scaler_variant_info_5420,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_scaler_match);
> +
> +static void *scaler_get_variant_data(struct platform_device *pdev)
> +{
> +	if (pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +		match = of_match_node(exynos_scaler_match, pdev->dev.of_node);
> +		if (match)
> +			return (void *)match->data;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void scaler_clk_put(struct scaler_dev *scaler)
> +{
> +	if (!IS_ERR(scaler->clock))
> +		clk_unprepare(scaler->clock);
> +}
> +
> +static int scaler_clk_get(struct scaler_dev *scaler)
> +{
> +	int ret;
> +
> +	scaler_dbg(scaler, "scaler_clk_get Called\n");
> +
> +	scaler->clock = devm_clk_get(&scaler->pdev->dev,
> +					SCALER_CLOCK_GATE_NAME);
> +	if (IS_ERR(scaler->clock)) {
> +		dev_err(&scaler->pdev->dev, "failed to get clock~~~: %s\n",
> +			SCALER_CLOCK_GATE_NAME);
> +		return PTR_ERR(scaler->clock);
> +	}
> +
> +	ret = clk_prepare(scaler->clock);
> +	if (ret<  0) {
> +		dev_err(&scaler->pdev->dev,
> +			"clock prepare fail for clock: %s\n",
> +			SCALER_CLOCK_GATE_NAME);
> +		scaler->clock = ERR_PTR(-EINVAL);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int scaler_m2m_suspend(struct scaler_dev *scaler)
> +{
> +	unsigned long flags;
> +	int timeout;
> +
> +	spin_lock_irqsave(&scaler->slock, flags);
> +	if (!scaler_m2m_pending(scaler)) {
> +		spin_unlock_irqrestore(&scaler->slock, flags);
> +		return 0;
> +	}
> +	clear_bit(ST_M2M_SUSPENDED,&scaler->state);
> +	set_bit(ST_M2M_SUSPENDING,&scaler->state);
> +	spin_unlock_irqrestore(&scaler->slock, flags);
> +
> +	timeout = wait_event_timeout(scaler->irq_queue,
> +			     test_bit(ST_M2M_SUSPENDED,&scaler->state),
> +			     SCALER_SHUTDOWN_TIMEOUT);
> +
> +	clear_bit(ST_M2M_SUSPENDING,&scaler->state);
> +	return timeout == 0 ? -EAGAIN : 0;
> +}
> +
> +static int scaler_m2m_resume(struct scaler_dev *scaler)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&scaler->slock, flags);
> +	/* Clear for full H/W setup in first run after resume */
> +	scaler->m2m.ctx = NULL;
> +	spin_unlock_irqrestore(&scaler->slock, flags);
> +
> +	if (test_and_clear_bit(ST_M2M_SUSPENDED,&scaler->state))
> +		scaler_m2m_job_finish(scaler->m2m.ctx,
> +				    VB2_BUF_STATE_ERROR);
> +	return 0;
> +}
> +
> +static int scaler_probe(struct platform_device *pdev)
> +{
> +	struct scaler_dev *scaler;
> +	struct resource *res;
> +	struct device *dev =&pdev->dev;
> +	int ret = 0;

Unnecessary initialization.

> +	if (!dev->of_node) {
> +		dev_err(dev, "Invalid device node\n");

Do you really need this log ? In practice it will never trigger.

> +		return -ENODEV;
> +	}
> +
> +	scaler = devm_kzalloc(dev, sizeof(struct scaler_dev), GFP_KERNEL);

nit: IIRC sizeof(*scaler) convention is preferred.

> +	if (!scaler)
> +		return -ENOMEM;
> +
> +	scaler->pdev = pdev;
> +	scaler->variant = (struct scaler_variant *)

Why such casting ?

> +				scaler_get_variant_data(pdev);
> +
> +	init_waitqueue_head(&scaler->irq_queue);
> +	spin_lock_init(&scaler->slock);
> +	mutex_init(&scaler->lock);
> +	scaler->clock = ERR_PTR(-EINVAL);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	scaler->regs = devm_request_and_ioremap(dev, res);
> +	if (!scaler->regs)
> +		return -ENODEV;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!res) {
> +		dev_err(dev, "failed to get IRQ resource\n");
> +		return -ENXIO;
> +	}
> +
> +	ret = scaler_clk_get(scaler);
> +	if (ret<  0)
> +		return ret;
> +
> +	ret = devm_request_irq(dev, res->start, scaler_irq_handler,
> +				0, pdev->name, scaler);
> +	if (ret<  0) {
> +		dev_err(dev, "failed to install irq (%d)\n", ret);
> +		goto err_clk;
> +	}
> +
> +	ret = scaler_register_m2m_device(scaler);

You should register video device as last thing in probe().

> +	if (ret<  0)
> +		goto err_clk;
> +
> +	platform_set_drvdata(pdev, scaler);
> +	pm_runtime_enable(dev);
> +	ret = pm_runtime_get_sync(&pdev->dev);

Is this really necessary ? I think it could be safely removed.

> +	if (ret<  0)
> +		goto err_m2m;
> +
> +	/* Initialize the continious memory allocator */
> +	scaler->alloc_ctx = vb2_dma_contig_init_ctx(dev);
> +	if (IS_ERR(scaler->alloc_ctx)) {
> +		ret = PTR_ERR(scaler->alloc_ctx);
> +		goto err_pm;
> +	}
> +
> +	dev_info(dev, "registered successfully\n");
> +
> +	pm_runtime_put(dev);

Ditto.

> +	return 0;
> +err_pm:
> +	pm_runtime_put(dev);
> +err_m2m:
> +	scaler_unregister_m2m_device(scaler);
> +err_clk:
> +	scaler_clk_put(scaler);
> +	return ret;
> +}
> +
> +static int scaler_remove(struct platform_device *pdev)
> +{
> +	struct scaler_dev *scaler = platform_get_drvdata(pdev);
> +
> +	scaler_unregister_m2m_device(scaler);
> +
> +	vb2_dma_contig_cleanup_ctx(scaler->alloc_ctx);
> +	pm_runtime_disable(&pdev->dev);
> +	scaler_clk_put(scaler);
> +
> +	scaler_dbg(scaler, "%s driver unloaded\n", pdev->name);
> +	return 0;
> +}
> +
> +static int scaler_runtime_resume(struct device *dev)
> +{
> +	struct scaler_dev *scaler = dev_get_drvdata(dev);
> +	int ret = 0;

Superfluous initialization.

> +	scaler_dbg(scaler, "state: 0x%lx", scaler->state);
> +
> +	ret = clk_enable(scaler->clock);
> +	if (ret<  0)
> +		return ret;
> +
> +	scaler_sw_reset(scaler);
> +
> +	return scaler_m2m_resume(scaler);

Shouldn't there be clk_disable() when this function fails ?

> +}
> +
> +static int scaler_runtime_suspend(struct device *dev)
> +{
> +	struct scaler_dev *scaler = dev_get_drvdata(dev);
> +	int ret = 0;

Superfluous initialization.

> +	ret = scaler_m2m_suspend(scaler);
> +	if (!ret)
> +		clk_disable(scaler->clock);
> +
> +	scaler_dbg(scaler, "state: 0x%lx", scaler->state);
> +	return ret;
> +}
> +
> +static int scaler_resume(struct device *dev)
> +{
> +	struct scaler_dev *scaler = dev_get_drvdata(dev);
> +	unsigned long flags;
> +
> +	scaler_dbg(scaler, "state: 0x%lx", scaler->state);
> +
> +	/* Do not resume if the device was idle before system suspend */
> +	spin_lock_irqsave(&scaler->slock, flags);
> +	if (!test_and_clear_bit(ST_SUSPEND,&scaler->state) ||
> +	    !scaler_m2m_active(scaler)) {
> +		spin_unlock_irqrestore(&scaler->slock, flags);
> +		return 0;
> +	}
> +
> +	scaler_sw_reset(scaler);
> +	spin_unlock_irqrestore(&scaler->slock, flags);
> +
> +	return scaler_m2m_resume(scaler);
> +}
> +
> +static int scaler_suspend(struct device *dev)
> +{
> +	struct scaler_dev *scaler = dev_get_drvdata(dev);
> +
> +	scaler_dbg(scaler, "state: 0x%lx", scaler->state);
> +
> +	if (test_and_set_bit(ST_SUSPEND,&scaler->state))
> +		return 0;
> +
> +	return scaler_m2m_suspend(scaler);
> +}
> +
> +static const struct dev_pm_ops scaler_pm_ops = {
> +	.suspend		= scaler_suspend,
> +	.resume			= scaler_resume,
> +	.runtime_suspend	= scaler_runtime_suspend,
> +	.runtime_resume		= scaler_runtime_resume,
> +};
> +
> +static struct platform_driver scaler_driver = {
> +	.probe		= scaler_probe,
> +	.remove		= scaler_remove,
> +	.driver = {
> +		.name	= SCALER_MODULE_NAME,
> +		.owner	= THIS_MODULE,
> +		.pm	=&scaler_pm_ops,
> +		.of_match_table = exynos_scaler_match,
> +	}
> +};
> +
> +module_platform_driver(scaler_driver);
> +
> +MODULE_AUTHOR("Shaik Ameer Basha<shaik.ameer@samsung.com>");
> +MODULE_DESCRIPTION("Samsung EXYNOS5 Soc series SCALER driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/platform/exynos-scaler/scaler.h b/drivers/media/platform/exynos-scaler/scaler.h
> new file mode 100644
> index 0000000..4109542
> --- /dev/null
> +++ b/drivers/media/platform/exynos-scaler/scaler.h
> @@ -0,0 +1,385 @@
> +/*
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Header file for Samsung EXYNOS5 SoC series SCALER driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef SCALER_CORE_H_
> +#define SCALER_CORE_H_
> +
> +#include<linux/device.h>
> +#include<linux/platform_device.h>
> +#include<media/v4l2-ctrls.h>
> +#include<media/v4l2-device.h>
> +#include<media/v4l2-mem2mem.h>
> +#include<media/videobuf2-dma-contig.h>
> +
> +#define scaler_dbg(_dev, fmt, args...) dev_dbg(&_dev->pdev->dev, fmt, ##args)
> +
> +#define SCALER_MODULE_NAME		"exynos5-scaler"
> +
> +#define SCALER_SHUTDOWN_TIMEOUT		((100*HZ)/1000)

nit: Should have spaces around '*' and '/'.

> +#define SCALER_MAX_DEVS			4
> +#define SCALER_MAX_CTRL_NUM		10
> +#define SCALER_SC_ALIGN_4		4
> +#define SCALER_SC_ALIGN_2		2
> +#define DEFAULT_CSC_EQ			1
> +#define DEFAULT_CSC_RANGE		1
> +
> +#define SCALER_PARAMS			(1<<  0)
> +#define SCALER_CTX_STOP_REQ		(1<<  1)
> +
> +enum scaler_dev_flags {
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
> +
> +enum scaler_color_fmt {
> +	SCALER_RGB = (0x1<<  0),
> +	SCALER_YUV420 = (0x1<<  1),
> +	SCALER_YUV422 = (0x1<<  2),
> +	SCALER_YUV444 = (0x1<<  3),

Why not use #define for these bit definitions ?

> +};
> +
> +enum scaler_yuv_fmt {
> +	SCALER_CBCR = 0x10,
> +	SCALER_CRCB,
> +};
> +
> +enum scaler_flags {
> +	SCALER_FMT_SRC = (0x1<<  0),
> +	SCALER_FMT_DST = (0x1<<  1),
> +	SCALER_FMT_TILED = (0x1<<  2),

Ditto.

> +};
> +
> +enum scaler_clr_fmt {
> +	SCALER_YUV420_2P_Y_UV = 0,
> +	SCALER_YUV422_2P_Y_UV = 2,
> +	SCALER_YUV444_2P_Y_UV,
> +	SCALER_RGB565,
> +	SCALER_ARGB1555,
> +	SCALER_ARGB8888,
> +	SCALER_PREMULTIPLIED_ARGB8888,
> +	SCALER_YUV422_1P_YVYU = 9,
> +	SCALER_YUV422_1P_YUYV,
> +	SCALER_YUV422_1P_UYVY,
> +	SCALER_ARGB4444,
> +	SCALER_L8A8,
> +	SCALER_RGBA8888,
> +	SCALER_L8,
> +	SCALER_YUV420_2P_Y_VU,
> +	SCALER_YUV422_2P_Y_VU = 18,
> +	SCALER_YUV444_2P_Y_VU,
> +	SCALER_YUV420_3P_Y_U_V,
> +	SCALER_YUV422_3P_Y_U_V = 22,
> +	SCALER_YUV444_3P_Y_U_V,

Are these register values ? Wouldn't it be better to use #defines ?

> +};
> +
> +#define fh_to_ctx(__fh)		container_of(__fh, struct scaler_ctx, fh)
> +#define is_rgb(fmt)		(!!(((fmt)->color)&  SCALER_RGB))
> +#define is_yuv(fmt)		((fmt->color>= SCALER_YUV420)&&  \
> +					(fmt->color<= SCALER_YUV444))
> +#define is_yuv420(fmt)		(!!((fmt->color)&  SCALER_YUV420))
> +#define is_yuv422(fmt)		(!!((fmt->color)&  SCALER_YUV422))
> +#define is_yuv422_1p(fmt)	(is_yuv422(fmt)&&  (fmt->num_planes == 1))
> +#define is_yuv420_2p(fmt)	(is_yuv420(fmt)&&  (fmt->num_planes == 2))
> +#define is_yuv422_2p(fmt)	(is_yuv422(fmt)&&  (fmt->num_planes == 2))
> +#define is_yuv42x_2p(fmt)	(is_yuv420_2p(fmt) || is_yuv422_2p(fmt))
> +#define is_src_fmt(fmt)		((fmt->flags)&  SCALER_FMT_SRC)
> +#define is_dst_fmt(fmt)		((fmt->flags)&  SCALER_FMT_DST)
> +#define is_tiled_fmt(fmt)	((fmt->flags)&  SCALER_FMT_TILED)
> +
> +#define scaler_m2m_active(dev)	test_bit(ST_M2M_RUN,&(dev)->state)
> +#define scaler_m2m_pending(dev)	test_bit(ST_M2M_PEND,&(dev)->state)
> +#define scaler_m2m_opened(dev)	test_bit(ST_M2M_OPEN,&(dev)->state)
> +
> +#define ctrl_to_ctx(__ctrl) \
> +	container_of((__ctrl)->handler, struct scaler_ctx, ctrl_handler)
> +/**
> + * struct scaler_fmt - the driver's internal color format data
> + * @mbus_code: Media Bus pixel code, -1 if not applicable
> + * @scaler_color: SCALER color format
> + * @name: format description
> + * @pixelformat: the fourcc code for this format, 0 if not applicable
> + * @color_order: Chrominance order control
> + * @num_planes: number of physically non-contiguous data planes
> + * @num_comp: number of physically contiguous data planes
> + * @depth: per plane driver's private 'number of bits per pixel'
> + * @flags: flags indicating which operation mode format applies to
> + */
> +struct scaler_fmt {
> +	enum v4l2_mbus_pixelcode mbus_code;

This field is not really used, is it ?

> +	enum scaler_clr_fmt scaler_color;
> +	char	*name;
> +	u32	pixelformat;
> +	u32	color;
> +	u32	color_order;
> +	u16	num_planes;
> +	u16	num_comp;
> +	u8	depth[VIDEO_MAX_PLANES];

nit: how about limiting this array to maximum number of planes supported
      by the device, that's only 3 I suppose.

> +	u32	flags;
> +};
> +
> +/**
> + * struct scaler_input_buf - the driver's video buffer
> + * @vb:	videobuf2 buffer
> + * @list : linked list structure for buffer queue
> + * @idx : index of SCALER input buffer
> + */
> +struct scaler_input_buf {
> +	struct vb2_buffer	vb;
> +	struct list_head	list;
> +	int			idx;
> +};
> +
> +/**
> + * struct scaler_addr - the SCALER DMA address set
> + * @y:	 luminance plane address
> + * @cb:	 Cb plane address
> + * @cr:	 Cr plane address
> + */
> +struct scaler_addr {
> +	dma_addr_t y;
> +	dma_addr_t cb;
> +	dma_addr_t cr;
> +};
> +
> +/**
> + * struct scaler_ctrls - the SCALER control set
> + * @rotate: rotation degree
> + * @hflip: horizontal flip
> + * @vflip: vertical flip
> + * @global_alpha: the alpha value of current frame
> + */
> +struct scaler_ctrls {
> +	struct v4l2_ctrl *rotate;
> +	struct v4l2_ctrl *hflip;
> +	struct v4l2_ctrl *vflip;
> +	struct v4l2_ctrl *global_alpha;
> +};
> +
> +/* struct scaler_csc_info - color space conversion information */
> +enum scaler_csc_coeff {
> +	SCALER_CSC_COEFF_YCBCR_TO_RGB,
> +	SCALER_CSC_COEFF_RGB_TO_YCBCR,
> +	SCALER_CSC_COEFF_MAX,
> +	SCALER_CSC_COEFF_NONE,
> +};
> +
> +struct scaler_csc_info {
> +	enum scaler_csc_coeff coeff_type;
> +};
> +
> +/**
> + * struct scaler_scaler - the configuration data for SCALER inetrnal scaler
> + * @hratio:	the main scaler's horizontal ratio
> + * @vratio:	the main scaler's vertical ratio
> + */
> +struct scaler_scaler {
> +	u32 hratio;
> +	u32 vratio;
> +};
> +
> +struct scaler_dev;
> +struct scaler_ctx;
> +
> +/**
> + * struct scaler_frame - source/target frame properties
> + * @f_width:	SRC : SRCIMG_WIDTH, DST : OUTPUTDMA_WHOLE_IMG_WIDTH
> + * @f_height:	SRC : SRCIMG_HEIGHT, DST : OUTPUTDMA_WHOLE_IMG_HEIGHT
> + * @crop:	cropped(source)/scaled(destination) size
> + * @payload:	image size in bytes (w x h x bpp)
> + * @addr:	image frame buffer physical addresses

s/physical/DMA

> + * @fmt:	SCALER color format pointer
> + * @colorspace: value indicating v4l2_colorspace
> + * @alpha:	frame's alpha value
> + */
> +struct scaler_frame {
> +	u32 f_width;
> +	u32 f_height;
> +	struct v4l2_rect crop;
> +	unsigned long payload[VIDEO_MAX_PLANES];

Similar comment as to the depth[] array size.

> +	struct scaler_addr	addr;
> +	const struct scaler_fmt *fmt;
> +	u32 colorspace;
> +	u8 alpha;
> +};
> +
> +/**
> + * struct scaler_m2m_device - v4l2 memory-to-memory device data
> + * @vfd: the video device node for v4l2 m2m mode
> + * @m2m_dev: v4l2 memory-to-memory device data
> + * @ctx: hardware context data
> + * @refcnt: the reference counter
> + */
> +struct scaler_m2m_device {
> +	struct video_device	*vfd;
> +	struct v4l2_m2m_dev	*m2m_dev;
> +	struct scaler_ctx		*ctx;
> +	int			refcnt;

This shouldn't be needed, you could use v4l2_fh_is_singular() to see
if the file handle is the only opened file handle.

> +};

--
Regards,
Sylwester
