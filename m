Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:30664 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3HSMsM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 08:48:12 -0400
From: Inki Dae <inki.dae@samsung.com>
To: 'Shaik Ameer Basha' <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	cpgs@samsung.com
Cc: s.nawrocki@samsung.com, posciak@google.com, arun.kk@samsung.com
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
 <1376909932-23644-2-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1376909932-23644-2-git-send-email-shaik.ameer@samsung.com>
Subject: RE: [PATCH v2 1/5] [media] exynos-mscl: Add new driver for M-Scaler
Date: Mon, 19 Aug 2013 21:48:09 +0900
Message-id: <032701ce9cda$5c0e55d0$142b0170$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just quick review.

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Shaik Ameer Basha
> Sent: Monday, August 19, 2013 7:59 PM
> To: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org
> Cc: s.nawrocki@samsung.com; posciak@google.com; arun.kk@samsung.com;
> shaik.ameer@samsung.com
> Subject: [PATCH v2 1/5] [media] exynos-mscl: Add new driver for M-Scaler
> 
> This patch adds support for M-Scaler (M2M Scaler) device which is a
> new device for scaling, blending, color fill  and color space
> conversion on EXYNOS5 SoCs.
> 
> This device supports the followings as key feature.
>     input image format
>         - YCbCr420 2P(UV/VU), 3P
>         - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
>         - YCbCr444 2P(UV,VU), 3P
>         - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
>         - Pre-multiplexed ARGB8888, L8A8 and L8
>     output image format
>         - YCbCr420 2P(UV/VU), 3P
>         - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
>         - YCbCr444 2P(UV,VU), 3P
>         - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
>         - Pre-multiplexed ARGB8888
>     input rotation
>         - 0/90/180/270 degree, X/Y/XY Flip
>     scale ratio
>         - 1/4 scale down to 16 scale up
>     color space conversion
>         - RGB to YUV / YUV to RGB
>     Size
>         - Input : 16x16 to 8192x8192
>         - Output:   4x4 to 8192x8192
>     alpha blending, color fill
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  drivers/media/platform/exynos-mscl/mscl-regs.c |  318
> ++++++++++++++++++++++++
>  drivers/media/platform/exynos-mscl/mscl-regs.h |  282
> +++++++++++++++++++++
>  2 files changed, 600 insertions(+)
>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-regs.c
>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-regs.h
> 
> diff --git a/drivers/media/platform/exynos-mscl/mscl-regs.c
> b/drivers/media/platform/exynos-mscl/mscl-regs.c
> new file mode 100644
> index 0000000..9354afc
> --- /dev/null
> +++ b/drivers/media/platform/exynos-mscl/mscl-regs.c
> @@ -0,0 +1,318 @@
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
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +
> +#include "mscl-core.h"
> +
> +void mscl_hw_set_sw_reset(struct mscl_dev *dev)
> +{
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + MSCL_CFG);
> +	cfg |= MSCL_CFG_SOFT_RESET;
> +
> +	writel(cfg, dev->regs + MSCL_CFG);
> +}
> +
> +int mscl_wait_reset(struct mscl_dev *dev)
> +{
> +	unsigned long end = jiffies + msecs_to_jiffies(50);

What does 50 mean?

> +	u32 cfg, reset_done = 0;
> +

Please describe why the below codes are needed.

> +	while (time_before(jiffies, end)) {
> +		cfg = readl(dev->regs + MSCL_CFG);
> +		if (!(cfg & MSCL_CFG_SOFT_RESET)) {
> +			reset_done = 1;
> +			break;
> +		}
> +		usleep_range(10, 20);
> +	}
> +
> +	/* write any value to r/w reg and read it back */
> +	while (reset_done) {
> +
> +		/* [TBD] need to define number of tries before returning
> +		 * -EBUSY to the caller
> +		 */
> +
> +		writel(MSCL_CFG_SOFT_RESET_CHECK_VAL,
> +				dev->regs + MSCL_CFG_SOFT_RESET_CHECK_REG);
> +		if (MSCL_CFG_SOFT_RESET_CHECK_VAL ==
> +			readl(dev->regs + MSCL_CFG_SOFT_RESET_CHECK_REG))
> +			return 0;
> +	}
> +
> +	return -EBUSY;
> +}
> +
> +void mscl_hw_set_irq_mask(struct mscl_dev *dev, int interrupt, bool mask)
> +{
> +	u32 cfg;
> +
> +	switch (interrupt) {
> +	case MSCL_INT_TIMEOUT:
> +	case MSCL_INT_ILLEGAL_BLEND:
> +	case MSCL_INT_ILLEGAL_RATIO:
> +	case MSCL_INT_ILLEGAL_DST_HEIGHT:
> +	case MSCL_INT_ILLEGAL_DST_WIDTH:
> +	case MSCL_INT_ILLEGAL_DST_V_POS:
> +	case MSCL_INT_ILLEGAL_DST_H_POS:
> +	case MSCL_INT_ILLEGAL_DST_C_SPAN:
> +	case MSCL_INT_ILLEGAL_DST_Y_SPAN:
> +	case MSCL_INT_ILLEGAL_DST_CR_BASE:
> +	case MSCL_INT_ILLEGAL_DST_CB_BASE:
> +	case MSCL_INT_ILLEGAL_DST_Y_BASE:
> +	case MSCL_INT_ILLEGAL_DST_COLOR:
> +	case MSCL_INT_ILLEGAL_SRC_HEIGHT:
> +	case MSCL_INT_ILLEGAL_SRC_WIDTH:
> +	case MSCL_INT_ILLEGAL_SRC_CV_POS:
> +	case MSCL_INT_ILLEGAL_SRC_CH_POS:
> +	case MSCL_INT_ILLEGAL_SRC_YV_POS:
> +	case MSCL_INT_ILLEGAL_SRC_YH_POS:
> +	case MSCL_INT_ILLEGAL_SRC_C_SPAN:
> +	case MSCL_INT_ILLEGAL_SRC_Y_SPAN:
> +	case MSCL_INT_ILLEGAL_SRC_CR_BASE:
> +	case MSCL_INT_ILLEGAL_SRC_CB_BASE:
> +	case MSCL_INT_ILLEGAL_SRC_Y_BASE:
> +	case MSCL_INT_ILLEGAL_SRC_COLOR:
> +	case MSCL_INT_FRAME_END:
> +		break;
> +	default:
> +		return;
> +	}

It seems that the above codes could be more simple,


> +	cfg = readl(dev->regs + MSCL_INT_EN);
> +	if (mask)
> +		cfg |= interrupt;
> +	else
> +		cfg &= ~interrupt;
> +	writel(cfg, dev->regs + MSCL_INT_EN);
> +}
> +
> +void mscl_hw_set_input_addr(struct mscl_dev *dev, struct mscl_addr *addr)
> +{
> +	dev_dbg(&dev->pdev->dev, "src_buf: 0x%X, cb: 0x%X, cr: 0x%X",
> +				addr->y, addr->cb, addr->cr);
> +	writel(addr->y, dev->regs + MSCL_SRC_Y_BASE);
> +	writel(addr->cb, dev->regs + MSCL_SRC_CB_BASE);
> +	writel(addr->cr, dev->regs + MSCL_SRC_CR_BASE);
> +}
> +
> +void mscl_hw_set_output_addr(struct mscl_dev *dev,
> +			     struct mscl_addr *addr)
> +{
> +	dev_dbg(&dev->pdev->dev, "dst_buf: 0x%X, cb: 0x%X, cr: 0x%X",
> +				addr->y, addr->cb, addr->cr);
> +	writel(addr->y, dev->regs + MSCL_DST_Y_BASE);
> +	writel(addr->cb, dev->regs + MSCL_DST_CB_BASE);
> +	writel(addr->cr, dev->regs + MSCL_DST_CR_BASE);
> +}
> +
> +void mscl_hw_set_in_size(struct mscl_ctx *ctx)
> +{
> +	struct mscl_dev *dev = ctx->mscl_dev;
> +	struct mscl_frame *frame = &ctx->s_frame;
> +	u32 cfg;
> +
> +	/* set input pixel offset */
> +	cfg = MSCL_SRC_YH_POS(frame->crop.left);
> +	cfg |= MSCL_SRC_YV_POS(frame->crop.top);

Where are the limitations to left and top checked?.

> +	writel(cfg, dev->regs + MSCL_SRC_Y_POS);
> +
> +	/* [TBD] calculate 'C' plane h/v offset using 'Y' plane h/v offset
> */
> +
> +	/* set input span */
> +	cfg = MSCL_SRC_Y_SPAN(frame->f_width);
> +	if (is_yuv420_2p(frame->fmt))
> +		cfg |= MSCL_SRC_C_SPAN(frame->f_width);
> +	else
> +		cfg |= MSCL_SRC_C_SPAN(frame->f_width); /* [TBD] Verify */
> +
> +	writel(cfg, dev->regs + MSCL_SRC_SPAN);
> +
> +	/* Set input cropped size */
> +	cfg = MSCL_SRC_WIDTH(frame->crop.width);
> +	cfg |= MSCL_SRC_HEIGHT(frame->crop.height);
> +	writel(cfg, dev->regs + MSCL_SRC_WH);
> +
> +	dev_dbg(&dev->pdev->dev,
> +		"src: posx: %d, posY: %d, spanY: %d, spanC: %d, "
> +		"cropX: %d, cropY: %d\n",
> +		frame->crop.left, frame->crop.top, frame->f_width,
> +		frame->f_width, frame->crop.width, frame->crop.height);
> +}
> +
> +void mscl_hw_set_in_image_format(struct mscl_ctx *ctx)
> +{
> +	struct mscl_dev *dev = ctx->mscl_dev;
> +	struct mscl_frame *frame = &ctx->s_frame;
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + MSCL_SRC_CFG);
> +	cfg &= ~MSCL_SRC_COLOR_FORMAT_MASK;
> +	cfg |= MSCL_SRC_COLOR_FORMAT(frame->fmt->mscl_color);
> +
> +	/* setting tile/linear format */
> +	if (frame->fmt->is_tiled)
> +		cfg |= MSCL_SRC_TILE_EN;
> +	else
> +		cfg &= ~MSCL_SRC_TILE_EN;
> +
> +	writel(cfg, dev->regs + MSCL_SRC_CFG);
> +}
> +
> +void mscl_hw_set_out_size(struct mscl_ctx *ctx)
> +{
> +	struct mscl_dev *dev = ctx->mscl_dev;
> +	struct mscl_frame *frame = &ctx->d_frame;
> +	u32 cfg;
> +
> +	/* set output pixel offset */
> +	cfg = MSCL_DST_H_POS(frame->crop.left);
> +	cfg |= MSCL_DST_V_POS(frame->crop.top);

Ditto.

> +	writel(cfg, dev->regs + MSCL_DST_POS);
> +
> +	/* set output span */
> +	cfg = MSCL_DST_Y_SPAN(frame->f_width);
> +	if (is_yuv420_2p(frame->fmt))
> +		cfg |= MSCL_DST_C_SPAN(frame->f_width/2);
> +	else
> +		cfg |= MSCL_DST_C_SPAN(frame->f_width);
> +	writel(cfg, dev->regs + MSCL_DST_SPAN);
> +
> +	/* set output scaled size */
> +	cfg = MSCL_DST_WIDTH(frame->crop.width);
> +	cfg |= MSCL_DST_HEIGHT(frame->crop.height);
> +	writel(cfg, dev->regs + MSCL_DST_WH);
> +
> +	dev_dbg(&dev->pdev->dev,
> +		"dst: posx: %d, posY: %d, spanY: %d, spanC: %d, "
> +		"cropX: %d, cropY: %d\n",
> +		frame->crop.left, frame->crop.top, frame->f_width,
> +		frame->f_width, frame->crop.width, frame->crop.height);
> +}
> +
> +void mscl_hw_set_out_image_format(struct mscl_ctx *ctx)
> +{
> +	struct mscl_dev *dev = ctx->mscl_dev;
> +	struct mscl_frame *frame = &ctx->d_frame;
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + MSCL_DST_CFG);
> +	cfg &= ~MSCL_DST_COLOR_FORMAT_MASK;
> +	cfg |= MSCL_DST_COLOR_FORMAT(frame->fmt->mscl_color);
> +
> +	writel(cfg, dev->regs + MSCL_DST_CFG);
> +}
> +
> +void mscl_hw_set_scaler_ratio(struct mscl_ctx *ctx)
> +{
> +	struct mscl_dev *dev = ctx->mscl_dev;
> +	struct mscl_scaler *sc = &ctx->scaler;
> +	u32 cfg;
> +
> +	cfg = MSCL_H_RATIO_VALUE(sc->hratio);
> +	writel(cfg, dev->regs + MSCL_H_RATIO);
> +
> +	cfg = MSCL_V_RATIO_VALUE(sc->vratio);
> +	writel(cfg, dev->regs + MSCL_V_RATIO);
> +}
> +
> +void mscl_hw_set_rotation(struct mscl_ctx *ctx)
> +{
> +	struct mscl_dev *dev = ctx->mscl_dev;
> +	u32 cfg = 0;
> +
> +	cfg = MSCL_ROTMODE(ctx->ctrls_mscl.rotate->val/90);
> +
> +	if (ctx->ctrls_mscl.hflip->val)
> +		cfg |= MSCL_FLIP_X_EN;
> +
> +	if (ctx->ctrls_mscl.vflip->val)
> +		cfg |= MSCL_FLIP_Y_EN;
> +
> +	writel(cfg, dev->regs + MSCL_ROT_CFG);
> +}
> +
> +void mscl_hw_address_queue_reset(struct mscl_ctx *ctx)
> +{
> +	struct mscl_dev *dev = ctx->mscl_dev;
> +
> +	writel(MSCL_ADDR_QUEUE_RST, dev->regs + MSCL_ADDR_QUEUE_CONFIG);
> +}
> +
> +void mscl_hw_set_csc_coeff(struct mscl_ctx *ctx)
> +{
> +	struct mscl_dev *dev = ctx->mscl_dev;
> +	enum mscl_csc_coeff type;
> +	u32 cfg = 0;
> +	int i, j;
> +	static const u32 csc_coeff[MSCL_CSC_COEFF_MAX][3][3] = {
> +		{ /* YCbCr to RGB */
> +			{0x200, 0x000, 0x2be},
> +			{0x200, 0xeac, 0x165},
> +			{0x200, 0x377, 0x000}
> +		},
> +		{ /* YCbCr to RGB with -16 offset */
> +			{0x254, 0x000, 0x331},
> +			{0x254, 0xec8, 0xFA0},
> +			{0x254, 0x409, 0x000}
> +		},
> +		{ /* RGB to YCbCr */
> +			{0x099, 0x12d, 0x03a},
> +			{0xe58, 0xeae, 0x106},
> +			{0x106, 0xedb, 0xe2a}
> +		},
> +		{ /* RGB to YCbCr with -16 offset */
> +			{0x084, 0x102, 0x032},
> +			{0xe4c, 0xe95, 0x0e1},
> +			{0x0e1, 0xebc, 0xe24}
> +		} };
> +
> +	if (is_rgb(ctx->s_frame.fmt) == is_rgb(ctx->d_frame.fmt))
> +		type = MSCL_CSC_COEFF_NONE;
> +	else if (is_rgb(ctx->d_frame.fmt))
> +		type = MSCL_CSC_COEFF_YCBCR_TO_RGB_OFF16;
> +	else
> +		type = MSCL_CSC_COEFF_RGB_TO_YCBCR_OFF16;
> +
> +	if ((type == ctx->mscl_dev->coeff_type) || (type >=
> MSCL_CSC_COEFF_MAX))
> +		return;
> +
> +	for (i = 0; i < 3; i++) {
> +		for (j = 0; j < 3; j++) {
> +			cfg = csc_coeff[type][i][j];
> +			writel(cfg, dev->regs + MSCL_CSC_COEF(i, j));
> +		}
> +	}
> +
> +	switch (type) {
> +	case MSCL_CSC_COEFF_YCBCR_TO_RGB:

Is there this case?

> +		mscl_hw_src_y_offset_en(ctx->mscl_dev, false);

And this switch-case could be removed if you move the above line to the
above if-sentence.


> +		break;
> +	case MSCL_CSC_COEFF_YCBCR_TO_RGB_OFF16:
> +		mscl_hw_src_y_offset_en(ctx->mscl_dev, true);

Ditto.

> +		break;
> +	case MSCL_CSC_COEFF_RGB_TO_YCBCR:

Seems no case.

> +		mscl_hw_src_y_offset_en(ctx->mscl_dev, false);

Could be moved to the above if-sentence.

> +		break;
> +	case MSCL_CSC_COEFF_RGB_TO_YCBCR_OFF16:
> +		mscl_hw_src_y_offset_en(ctx->mscl_dev, true);

Ditto.

> +		break;
> +	default:
> +		return;
> +	}
> +
> +	ctx->mscl_dev->coeff_type = type;
> +	return;
> +}
> diff --git a/drivers/media/platform/exynos-mscl/mscl-regs.h
> b/drivers/media/platform/exynos-mscl/mscl-regs.h
> new file mode 100644
> index 0000000..02e2294d
> --- /dev/null
> +++ b/drivers/media/platform/exynos-mscl/mscl-regs.h
> @@ -0,0 +1,282 @@
> +/*
> + * Copyright (c) 2013 - 2014 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Register definition file for Samsung M-Scaler driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef REGS_MSCL_H_
> +#define REGS_MSCL_H_
> +
> +/* m2m-scaler status */
> +#define MSCL_STATUS				0x00
> +#define MSCL_STATUS_RUNNING			(1 << 1)
> +#define MSCL_STATUS_READY_CLK_DOWN		(1 << 0)
> +
> +/* m2m-scaler config */
> +#define MSCL_CFG				0x04
> +#define MSCL_CFG_FILL_EN			(1 << 24)
> +#define MSCL_CFG_BLEND_CLR_DIV_ALPHA_EN		(1 << 17)
> +#define MSCL_CFG_BLEND_EN			(1 << 16)
> +#define MSCL_CFG_CSC_Y_OFFSET_SRC_EN		(1 << 10)
> +#define MSCL_CFG_CSC_Y_OFFSET_DST_EN		(1 << 9)
> +#define MSCL_CFG_16_BURST_MODE			(1 << 8)
> +#define MSCL_CFG_SOFT_RESET			(1 << 1)
> +#define MSCL_CFG_START_CMD			(1 << 0)
> +
> +/* m2m-scaler interrupt enable */
> +#define MSCL_INT_EN				0x08
> +#define MSCL_INT_EN_DEFAULT			0x81ffffff
> +#define MSCL_INT_EN_TIMEOUT			(1 << 31)
> +#define MSCL_INT_EN_ILLEGAL_BLEND		(1 << 24)
> +#define MSCL_INT_EN_ILLEGAL_RATIO		(1 << 23)
> +#define MSCL_INT_EN_ILLEGAL_DST_HEIGHT		(1 << 22)
> +#define MSCL_INT_EN_ILLEGAL_DST_WIDTH		(1 << 21)
> +#define MSCL_INT_EN_ILLEGAL_DST_V_POS		(1 << 20)
> +#define MSCL_INT_EN_ILLEGAL_DST_H_POS		(1 << 19)
> +#define MSCL_INT_EN_ILLEGAL_DST_C_SPAN		(1 << 18)
> +#define MSCL_INT_EN_ILLEGAL_DST_Y_SPAN		(1 << 17)
> +#define MSCL_INT_EN_ILLEGAL_DST_CR_BASE		(1 << 16)
> +#define MSCL_INT_EN_ILLEGAL_DST_CB_BASE		(1 << 15)
> +#define MSCL_INT_EN_ILLEGAL_DST_Y_BASE		(1 << 14)
> +#define MSCL_INT_EN_ILLEGAL_DST_COLOR		(1 << 13)
> +#define MSCL_INT_EN_ILLEGAL_SRC_HEIGHT		(1 << 12)
> +#define MSCL_INT_EN_ILLEGAL_SRC_WIDTH		(1 << 11)
> +#define MSCL_INT_EN_ILLEGAL_SRC_CV_POS		(1 << 10)
> +#define MSCL_INT_EN_ILLEGAL_SRC_CH_POS		(1 << 9)
> +#define MSCL_INT_EN_ILLEGAL_SRC_YV_POS		(1 << 8)
> +#define MSCL_INT_EN_ILLEGAL_SRC_YH_POS		(1 << 7)
> +#define MSCL_INT_EN_ILLEGAL_SRC_C_SPAN		(1 << 6)
> +#define MSCL_INT_EN_ILLEGAL_SRC_Y_SPAN		(1 << 5)
> +#define MSCL_INT_EN_ILLEGAL_SRC_CR_BASE		(1 << 4)
> +#define MSCL_INT_EN_ILLEGAL_SRC_CB_BASE		(1 << 3)
> +#define MSCL_INT_EN_ILLEGAL_SRC_Y_BASE		(1 << 2)
> +#define MSCL_INT_EN_ILLEGAL_SRC_COLOR		(1 << 1)
> +#define MSCL_INT_EN_FRAME_END			(1 << 0)
> +
> +/* m2m-scaler interrupt status */
> +#define MSCL_INT_STATUS				0x0c
> +#define MSCL_INT_STATUS_CLEAR			(0xffffffff)
> +#define MSCL_INT_STATUS_ERROR			(0x81fffffe)
> +#define MSCL_INT_STATUS_TIMEOUT			(1 << 31)
> +#define MSCL_INT_STATUS_ILLEGAL_BLEND		(1 << 24)
> +#define MSCL_INT_STATUS_ILLEGAL_RATIO		(1 << 23)
> +#define MSCL_INT_STATUS_ILLEGAL_DST_HEIGHT	(1 << 22)
> +#define MSCL_INT_STATUS_ILLEGAL_DST_WIDTH	(1 << 21)
> +#define MSCL_INT_STATUS_ILLEGAL_DST_V_POS	(1 << 20)
> +#define MSCL_INT_STATUS_ILLEGAL_DST_H_POS	(1 << 19)
> +#define MSCL_INT_STATUS_ILLEGAL_DST_C_SPAN	(1 << 18)
> +#define MSCL_INT_STATUS_ILLEGAL_DST_Y_SPAN	(1 << 17)
> +#define MSCL_INT_STATUS_ILLEGAL_DST_CR_BASE	(1 << 16)
> +#define MSCL_INT_STATUS_ILLEGAL_DST_CB_BASE	(1 << 15)
> +#define MSCL_INT_STATUS_ILLEGAL_DST_Y_BASE	(1 << 14)
> +#define MSCL_INT_STATUS_ILLEGAL_DST_COLOR	(1 << 13)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_HEIGHT	(1 << 12)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_WIDTH	(1 << 11)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_CV_POS	(1 << 10)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_CH_POS	(1 << 9)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_YV_POS	(1 << 8)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_YH_POS	(1 << 7)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_C_SPAN	(1 << 6)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_Y_SPAN	(1 << 5)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_CR_BASE	(1 << 4)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_CB_BASE	(1 << 3)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_Y_BASE	(1 << 2)
> +#define MSCL_INT_STATUS_ILLEGAL_SRC_COLOR	(1 << 1)
> +#define MSCL_INT_STATUS_FRAME_END		(1 << 0)
> +
> +/* m2m-scaler source format configuration */
> +#define MSCL_SRC_CFG				0x10
> +#define MSCL_SRC_TILE_EN			(0x1 << 10)
> +#define MSCL_SRC_BYTE_SWAP_MASK			(0x3 << 5)
> +#define MSCL_SRC_BYTE_SWAP(x)			(((x) & 0x3) << 5)
> +#define MSCL_SRC_COLOR_FORMAT_MASK		(0xf << 0)
> +#define MSCL_SRC_COLOR_FORMAT(x)		(((x) & 0xf) << 0)
> +
> +/* m2m-scaler source y-base */
> +#define MSCL_SRC_Y_BASE				0x14
> +
> +/* m2m-scaler source cb-base */
> +#define MSCL_SRC_CB_BASE			0x18
> +
> +/* m2m-scaler source cr-base */
> +#define MSCL_SRC_CR_BASE			0x294
> +
> +/* m2m-scaler source span */
> +#define MSCL_SRC_SPAN				0x1c
> +#define MSCL_SRC_C_SPAN_MASK			(0x3fff << 16)
> +#define MSCL_SRC_C_SPAN(x)			(((x) & 0x3fff) << 16)
> +#define MSCL_SRC_Y_SPAN_MASK			(0x3fff << 0)
> +#define MSCL_SRC_Y_SPAN(x)			(((x) & 0x3fff) << 0)
> +
> +/* m2m-scaler source y-position */
> +#define MSCL_SRC_Y_POS				0x20
> +#define MSCL_SRC_YH_POS_MASK			(0xffff << (16 + 2))
> +#define MSCL_SRC_YH_POS(x)			(((x) & 0xffff) << (16 + 2))
> +#define MSCL_SRC_YV_POS_MASK			(0xffff << (0 + 2))
> +#define MSCL_SRC_YV_POS(x)			(((x) & 0xffff) << (0 + 2))
> +
> +/* m2m-scaler source width/height */
> +#define MSCL_SRC_WH				0x24
> +#define MSCL_SRC_WIDTH_MASK			(0x3fff << 16)
> +#define MSCL_SRC_WIDTH(x)			(((x) & 0x3fff) << 16)
> +#define MSCL_SRC_HEIGHT_MASK			(0x3fff << 0)
> +#define MSCL_SRC_HEIGHT(x)			(((x) & 0x3fff) << 0)
> +
> +/* m2m-scaler source c-position */
> +#define MSCL_SRC_C_POS				0x28
> +#define MSCL_SRC_CH_POS_MASK			(0xffff << (16 + 2))
> +#define MSCL_SRC_CH_POS(x)			(((x) & 0xffff) << (16 + 2))
> +#define MSCL_SRC_CV_POS_MASK			(0xffff << (0 + 2))
> +#define MSCL_SRC_CV_POS(x)			(((x) & 0xffff) << (0 + 2))
> +
> +/* m2m-scaler destination format configuration */
> +#define MSCL_DST_CFG				0x30
> +#define MSCL_DST_BYTE_SWAP_MASK			(0x3 << 5)
> +#define MSCL_DST_BYTE_SWAP(x)			(((x) & 0x3) << 5)
> +#define MSCL_DST_COLOR_FORMAT_MASK		(0xf << 0)
> +#define MSCL_DST_COLOR_FORMAT(x)		(((x) & 0xf) << 0)
> +
> +/* m2m-scaler destination y-base */
> +#define MSCL_DST_Y_BASE				0x34
> +
> +/* m2m-scaler destination cb-base */
> +#define MSCL_DST_CB_BASE			0x38
> +
> +/* m2m-scaler destination cr-base */
> +#define MSCL_DST_CR_BASE			0x298
> +
> +/* m2m-scaler destination span */
> +#define MSCL_DST_SPAN				0x3c
> +#define MSCL_DST_C_SPAN_MASK			(0x3fff << 16)
> +#define MSCL_DST_C_SPAN(x)			(((x) & 0x3fff) << 16)
> +#define MSCL_DST_Y_SPAN_MASK			(0x3fff << 0)
> +#define MSCL_DST_Y_SPAN(x)			(((x) & 0x3fff) << 0)
> +
> +/* m2m-scaler destination width/height */
> +#define MSCL_DST_WH				0x40
> +#define MSCL_DST_WIDTH_MASK			(0x3fff << 16)
> +#define MSCL_DST_WIDTH(x)			(((x) & 0x3fff) << 16)
> +#define MSCL_DST_HEIGHT_MASK			(0x3fff << 0)
> +#define MSCL_DST_HEIGHT(x)			(((x) & 0x3fff) << 0)
> +
> +/* m2m-scaler destination position */
> +#define MSCL_DST_POS				0x44
> +#define MSCL_DST_H_POS_MASK			(0x3fff << 16)
> +#define MSCL_DST_H_POS(x)			(((x) & 0x3fff) << 16)
> +#define MSCL_DST_V_POS_MASK			(0x3fff << 0)
> +#define MSCL_DST_V_POS(x)			(((x) & 0x3fff) << 0)
> +
> +/* m2m-scaler horizontal scale ratio */
> +#define MSCL_H_RATIO				0x50
> +#define MSCL_H_RATIO_VALUE(x)			(((x) & 0x7ffff) <<
0)
> +
> +/* m2m-scaler vertical scale ratio */
> +#define MSCL_V_RATIO				0x54
> +#define MSCL_V_RATIO_VALUE(x)			(((x) & 0x7ffff) <<
0)
> +
> +/* m2m-scaler rotation config */
> +#define MSCL_ROT_CFG				0x58
> +#define MSCL_FLIP_X_EN				(1 << 3)
> +#define MSCL_FLIP_Y_EN				(1 << 2)
> +#define MSCL_ROTMODE_MASK			(0x3 << 0)
> +#define MSCL_ROTMODE(x)				(((x) & 0x3) << 0)
> +
> +/* m2m-scaler csc coefficients */
> +#define MSCL_CSC_COEF_00			0x220
> +#define MSCL_CSC_COEF_10			0x224
> +#define MSCL_CSC_COEF_20			0x228
> +#define MSCL_CSC_COEF_01			0x22C
> +#define MSCL_CSC_COEF_11			0x230
> +#define MSCL_CSC_COEF_21			0x234
> +#define MSCL_CSC_COEF_02			0x238
> +#define MSCL_CSC_COEF_12			0x23C
> +#define MSCL_CSC_COEF_22			0x240
> +
> +#define MSCL_CSC_COEF(x, y)			(0x220 + ((x * 12) + (y *
> 4)))
> +
> +/* m2m-scaler dither config */
> +#define MSCL_DITH_CFG				0x250
> +#define MSCL_DITHER_R_TYPE_MASK			(0x7 << 6)
> +#define MSCL_DITHER_R_TYPE(x)			(((x) & 0x7) << 6)
> +#define MSCL_DITHER_G_TYPE_MASK			(0x7 << 3)
> +#define MSCL_DITHER_G_TYPE(x)			(((x) & 0x7) << 3)
> +#define MSCL_DITHER_B_TYPE_MASK			(0x7 << 0)
> +#define MSCL_DITHER_B_TYPE(x)			(((x) & 0x7) << 0)
> +
> +/* m2m-scaler src blend color */
> +#define MSCL_SRC_BLEND_COLOR			0x280
> +#define MSCL_SRC_COLOR_SEL_INV			(1 << 31)
> +#define MSCL_SRC_COLOR_SEL_MASK			(0x3 << 29)
> +#define MSCL_SRC_COLOR_SEL(x)			(((x) & 0x3) << 29)
> +#define MSCL_SRC_COLOR_OP_SEL_INV		(1 << 28)
> +#define MSCL_SRC_COLOR_OP_SEL_MASK		(0xf << 24)
> +#define MSCL_SRC_COLOR_OP_SEL(x)		(((x) & 0xf) << 24)
> +#define MSCL_SRC_GLOBAL_COLOR0_MASK		(0xff << 16)
> +#define MSCL_SRC_GLOBAL_COLOR0(x)		(((x) & 0xff) << 16)
> +#define MSCL_SRC_GLOBAL_COLOR1_MASK		(0xff << 8)
> +#define MSCL_SRC_GLOBAL_COLOR1(x)		(((x) & 0xff) << 8)
> +#define MSCL_SRC_GLOBAL_COLOR2_MASK		(0xff << 0)
> +#define MSCL_SRC_GLOBAL_COLOR2(x)		(((x) & 0xff) << 0)
> +
> +/* m2m-scaler src blend alpha */
> +#define MSCL_SRC_BLEND_ALPHA			0x284
> +#define MSCL_SRC_ALPHA_SEL_INV			(1 << 31)
> +#define MSCL_SRC_ALPHA_SEL_MASK			(0x3 << 29)
> +#define MSCL_SRC_ALPHA_SEL(x)			(((x) & 0x3) << 29)
> +#define MSCL_SRC_ALPHA_OP_SEL_INV		(1 << 28)
> +#define MSCL_SRC_ALPHA_OP_SEL_MASK		(0xf << 24)
> +#define MSCL_SRC_ALPHA_OP_SEL(x)		(((x) & 0xf) << 24)
> +#define MSCL_SRC_GLOBAL_ALPHA_MASK		(0xff << 0)
> +#define MSCL_SRC_GLOBAL_ALPHA(x)		(((x) & 0xff) << 0)
> +
> +/* m2m-scaler dst blend color */
> +#define MSCL_DST_BLEND_COLOR			0x288
> +#define MSCL_DST_COLOR_SEL_INV			(1 << 31)
> +#define MSCL_DST_COLOR_SEL_MASK			(0x3 << 29)
> +#define MSCL_DST_COLOR_SEL(x)			(((x) & 0x3) << 29)
> +#define MSCL_DST_COLOR_OP_SEL_INV		(1 << 28)
> +#define MSCL_DST_COLOR_OP_SEL_MASK		(0xf << 24)
> +#define MSCL_DST_COLOR_OP_SEL(x)		(((x) & 0xf) << 24)
> +#define MSCL_DST_GLOBAL_COLOR0_MASK		(0xff << 16)
> +#define MSCL_DST_GLOBAL_COLOR0(x)		(((x) & 0xff) << 16)
> +#define MSCL_DST_GLOBAL_COLOR1_MASK		(0xff << 8)
> +#define MSCL_DST_GLOBAL_COLOR1(x)		(((x) & 0xff) << 8)
> +#define MSCL_DST_GLOBAL_COLOR2_MASK		(0xff << 0)
> +#define MSCL_DST_GLOBAL_COLOR2(x)		(((x) & 0xff) << 0)
> +
> +/* m2m-scaler dst blend alpha */
> +#define MSCL_DST_BLEND_ALPHA			0x28C
> +#define MSCL_DST_ALPHA_SEL_INV			(1 << 31)
> +#define MSCL_DST_ALPHA_SEL_MASK			(0x3 << 29)
> +#define MSCL_DST_ALPHA_SEL(x)			(((x) & 0x3) << 29)
> +#define MSCL_DST_ALPHA_OP_SEL_INV		(1 << 28)
> +#define MSCL_DST_ALPHA_OP_SEL_MASK		(0xf << 24)
> +#define MSCL_DST_ALPHA_OP_SEL(x)		(((x) & 0xf) << 24)
> +#define MSCL_DST_GLOBAL_ALPHA_MASK		(0xff << 0)
> +#define MSCL_DST_GLOBAL_ALPHA(x)		(((x) & 0xff) << 0)
> +
> +/* m2m-scaler fill color */
> +#define MSCL_FILL_COLOR				0x290
> +#define MSCL_FILL_ALPHA_MASK			(0xff << 24)
> +#define MSCL_FILL_ALPHA(x)			(((x) & 0xff) << 24)
> +#define MSCL_FILL_COLOR0_MASK			(0xff << 16)
> +#define MSCL_FILL_COLOR0(x)			(((x) & 0xff) << 16)
> +#define MSCL_FILL_COLOR1_MASK			(0xff << 8)
> +#define MSCL_FILL_COLOR1(x)			(((x) & 0xff) << 8)
> +#define MSCL_FILL_COLOR2_MASK			(0xff << 0)
> +#define MSCL_FILL_COLOR2(x)			(((x) & 0xff) << 0)
> +
> +/* m2m-scaler address queue config */
> +#define MSCL_ADDR_QUEUE_CONFIG			0x2a0
> +#define MSCL_ADDR_QUEUE_RST			(1 << 0)
> +
> +/* arbitrary r/w register and reg-value to check soft reset is success */
> +#define MSCL_CFG_SOFT_RESET_CHECK_REG		MSCL_SRC_CFG
> +#define MSCL_CFG_SOFT_RESET_CHECK_VAL		0x3
> +
> +#endif /* REGS_MSCL_H_ */
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

