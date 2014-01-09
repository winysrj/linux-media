Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44902 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaAID2y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 22:28:54 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: s.nawrocki@samsung.com, posciak@google.com, hverkuil@xs4all.nl,
	shaik.ameer@samsung.com, m.chehab@samsung.com
Subject: [PATCH v5 1/4] [media] exynos-scaler: Add new driver for Exynos5 SCALER
Date: Thu,  9 Jan 2014 08:58:11 +0530
Message-Id: <1389238094-19386-2-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1389238094-19386-1-git-send-email-shaik.ameer@samsung.com>
References: <1389238094-19386-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for SCALER device which is a new device
for scaling, blending, color fill  and color space conversion
on EXYNOS5410 and EXYNOS5420 SoCs.

This device supports the followings as key feature.
    input image format
        - YCbCr420 2P(UV/VU), 3P
        - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
        - YCbCr444 2P(UV,VU), 3P
        - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
        - Pre-multiplexed ARGB8888, L8A8 and L8
    output image format
        - YCbCr420 2P(UV/VU), 3P
        - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
        - YCbCr444 2P(UV,VU), 3P
        - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
        - Pre-multiplexed ARGB8888
    input rotation
        - 0/90/180/270 degree, X/Y/XY Flip
    scale ratio
        - 1/4 scale down to 16 scale up
    color space conversion
        - RGB to YUV / YUV to RGB
    Size - Exynos5420
        - Input : 16x16 to 8192x8192
        - Output:   4x4 to 8192x8192
    Size - Exynos5410
        - Input/Output: 4x4 to 4096x4096
    alpha blending, color fill

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos-scaler/scaler-regs.c |  337 ++++++++++++++++++++
 drivers/media/platform/exynos-scaler/scaler-regs.h |  331 +++++++++++++++++++
 2 files changed, 668 insertions(+)
 create mode 100644 drivers/media/platform/exynos-scaler/scaler-regs.c
 create mode 100644 drivers/media/platform/exynos-scaler/scaler-regs.h

diff --git a/drivers/media/platform/exynos-scaler/scaler-regs.c b/drivers/media/platform/exynos-scaler/scaler-regs.c
new file mode 100644
index 0000000..8f5076a
--- /dev/null
+++ b/drivers/media/platform/exynos-scaler/scaler-regs.c
@@ -0,0 +1,337 @@
+/*
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series SCALER driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+
+#include "scaler-regs.h"
+
+/* Scaler reset timeout in milliseconds */
+#define SCALER_RESET_TIMEOUT	5
+
+void scaler_hw_set_sw_reset(struct scaler_dev *dev)
+{
+	u32 cfg;
+
+	cfg = scaler_read(dev, SCALER_CFG);
+	cfg |= SCALER_CFG_SOFT_RESET;
+
+	scaler_write(dev, SCALER_CFG, cfg);
+}
+
+int scaler_wait_reset(struct scaler_dev *dev)
+{
+	unsigned long end = jiffies + msecs_to_jiffies(SCALER_RESET_TIMEOUT);
+	u32 cfg, reset_done = 0;
+
+	while (time_is_after_jiffies(end)) {
+		cfg = scaler_read(dev, SCALER_CFG);
+		if (!(cfg & SCALER_CFG_SOFT_RESET)) {
+			reset_done = 1;
+			break;
+		}
+		usleep_range(100, 200);
+	}
+
+	if (!reset_done)
+		return -EBUSY;
+
+	/*
+	 * Write any value to read/write register and read it back.
+	 * If the write and read value matches, then the reset process is
+	 * succeeded.
+	 */
+	end = jiffies + msecs_to_jiffies(SCALER_RESET_TIMEOUT);
+	while (time_is_after_jiffies(end)) {
+		scaler_write(dev, SCALER_CFG_SOFT_RESET_CHECK_REG,
+				SCALER_CFG_SOFT_RESET_CHECK_VAL);
+		if (SCALER_CFG_SOFT_RESET_CHECK_VAL ==
+			scaler_read(dev, SCALER_CFG_SOFT_RESET_CHECK_REG))
+			return 0;
+		usleep_range(9000, 10000);
+	}
+
+	return -EBUSY;
+}
+
+void scaler_hw_set_irq(struct scaler_dev *dev, int irq_num, bool enable)
+{
+	u32 cfg;
+
+	if ((irq_num < SCALER_INT_FRAME_END) ||
+	    (irq_num > SCALER_INT_TIMEOUT))
+		return;
+
+	cfg = scaler_read(dev, SCALER_INT_EN);
+	if (enable)
+		cfg |= 1 << irq_num;
+	else
+		cfg &= ~(1 << irq_num);
+	scaler_write(dev, SCALER_INT_EN, cfg);
+}
+
+void scaler_hw_set_input_addr(struct scaler_dev *dev, struct scaler_addr *addr)
+{
+	scaler_dbg(dev, "src_buf: 0x%x, cb: 0x%x, cr: 0x%x",
+				addr->y, addr->cb, addr->cr);
+	scaler_write(dev, SCALER_SRC_Y_BASE, addr->y);
+	scaler_write(dev, SCALER_SRC_CB_BASE, addr->cb);
+	scaler_write(dev, SCALER_SRC_CR_BASE, addr->cr);
+}
+
+void scaler_hw_set_output_addr(struct scaler_dev *dev,
+			     struct scaler_addr *addr)
+{
+	scaler_dbg(dev, "dst_buf: 0x%x, cb: 0x%x, cr: 0x%x",
+			addr->y, addr->cb, addr->cr);
+	scaler_write(dev, SCALER_DST_Y_BASE, addr->y);
+	scaler_write(dev, SCALER_DST_CB_BASE, addr->cb);
+	scaler_write(dev, SCALER_DST_CR_BASE, addr->cr);
+}
+
+void scaler_hw_set_in_size(struct scaler_ctx *ctx)
+{
+	struct scaler_dev *dev = ctx->scaler_dev;
+	struct scaler_frame *frame = &ctx->s_frame;
+	u32 cfg;
+
+	/* set input pixel offset */
+	cfg = (frame->selection.left & SCALER_SRC_YH_POS_MASK) <<
+				  SCALER_SRC_YH_POS_SHIFT;
+	cfg |= (frame->selection.top & SCALER_SRC_YV_POS_MASK) <<
+				   SCALER_SRC_YV_POS_SHIFT;
+	scaler_write(dev, SCALER_SRC_Y_POS, cfg);
+
+	/* TODO: calculate 'C' plane h/v offset using 'Y' plane h/v offset */
+
+	/* Set input span */
+	cfg = (frame->f_width & SCALER_SRC_Y_SPAN_MASK) <<
+				SCALER_SRC_Y_SPAN_SHIFT;
+	if (is_yuv420_2p(frame->fmt))
+		cfg |= (frame->f_width & SCALER_SRC_C_SPAN_MASK) <<
+					  SCALER_SRC_C_SPAN_SHIFT;
+	else /* TODO: Verify */
+		cfg |= (frame->f_width & SCALER_SRC_C_SPAN_MASK) <<
+					  SCALER_SRC_C_SPAN_SHIFT;
+
+	scaler_write(dev, SCALER_SRC_SPAN, cfg);
+
+	/* Set input cropped size */
+	cfg = (frame->selection.width & SCALER_SRC_WIDTH_MASK) <<
+				   SCALER_SRC_WIDTH_SHIFT;
+	cfg |= (frame->selection.height & SCALER_SRC_HEIGHT_MASK) <<
+				      SCALER_SRC_HEIGHT_SHIFT;
+	scaler_write(dev, SCALER_SRC_WH, cfg);
+
+	scaler_dbg(dev, "src: posx: %d, posY: %d, spanY: %d, spanC: %d\n",
+			frame->selection.left, frame->selection.top,
+			frame->f_width, frame->f_width);
+	scaler_dbg(dev, "cropX: %d, cropY: %d\n",
+			frame->selection.width,	frame->selection.height);
+}
+
+void scaler_hw_set_in_image_format(struct scaler_ctx *ctx)
+{
+	struct scaler_dev *dev = ctx->scaler_dev;
+	struct scaler_frame *frame = &ctx->s_frame;
+	u32 cfg;
+
+	cfg = scaler_read(dev, SCALER_SRC_CFG);
+	cfg &= ~(SCALER_SRC_COLOR_FORMAT_MASK << SCALER_SRC_COLOR_FORMAT_SHIFT);
+	cfg |= (frame->fmt->scaler_color & SCALER_SRC_COLOR_FORMAT_MASK) <<
+					   SCALER_SRC_COLOR_FORMAT_SHIFT;
+
+	/* Setting tiled/linear format */
+	if (is_tiled_fmt(frame->fmt))
+		cfg |= SCALER_SRC_TILE_EN;
+	else
+		cfg &= ~SCALER_SRC_TILE_EN;
+
+	scaler_write(dev, SCALER_SRC_CFG, cfg);
+}
+
+void scaler_hw_set_out_size(struct scaler_ctx *ctx)
+{
+	struct scaler_dev *dev = ctx->scaler_dev;
+	struct scaler_frame *frame = &ctx->d_frame;
+	u32 cfg;
+
+	/* Set output pixel offset */
+	cfg = (frame->selection.left & SCALER_DST_H_POS_MASK) <<
+				  SCALER_DST_H_POS_SHIFT;
+	cfg |= (frame->selection.top & SCALER_DST_V_POS_MASK) <<
+				  SCALER_DST_V_POS_SHIFT;
+	scaler_write(dev, SCALER_DST_POS, cfg);
+
+	/* Set output span */
+	cfg = (frame->f_width & SCALER_DST_Y_SPAN_MASK) <<
+				SCALER_DST_Y_SPAN_SHIFT;
+	if (is_yuv420_2p(frame->fmt))
+		cfg |= ((frame->f_width / 2) & SCALER_DST_C_SPAN_MASK) <<
+					     SCALER_DST_C_SPAN_SHIFT;
+	else
+		cfg |= (frame->f_width & SCALER_DST_C_SPAN_MASK) <<
+					     SCALER_DST_C_SPAN_SHIFT;
+	scaler_write(dev, SCALER_DST_SPAN, cfg);
+
+	/* Set output scaled size */
+	cfg = (frame->selection.width & SCALER_DST_WIDTH_MASK) <<
+				   SCALER_DST_WIDTH_SHIFT;
+	cfg |= (frame->selection.height & SCALER_DST_HEIGHT_MASK) <<
+				     SCALER_DST_HEIGHT_SHIFT;
+	scaler_write(dev, SCALER_DST_WH, cfg);
+
+	scaler_dbg(dev, "dst: pos X: %d, pos Y: %d, span Y: %d, span C: %d\n",
+			frame->selection.left, frame->selection.top,
+			frame->f_width, frame->f_width);
+	scaler_dbg(dev, "crop X: %d, crop Y: %d\n",
+			frame->selection.width,	frame->selection.height);
+}
+
+void scaler_hw_set_out_image_format(struct scaler_ctx *ctx)
+{
+	struct scaler_dev *dev = ctx->scaler_dev;
+	struct scaler_frame *frame = &ctx->d_frame;
+	u32 cfg;
+
+	cfg = scaler_read(dev, SCALER_DST_CFG);
+	cfg &= ~SCALER_DST_COLOR_FORMAT_MASK;
+	cfg |= (frame->fmt->scaler_color & SCALER_DST_COLOR_FORMAT_MASK);
+
+	scaler_write(dev, SCALER_DST_CFG, cfg);
+}
+
+void scaler_hw_set_scaler_ratio(struct scaler_ctx *ctx)
+{
+	struct scaler_dev *dev = ctx->scaler_dev;
+	struct scaler_scaler *sc = &ctx->scaler;
+	u32 cfg;
+
+	cfg = (sc->hratio & SCALER_H_RATIO_MASK) << SCALER_H_RATIO_SHIFT;
+	scaler_write(dev, SCALER_H_RATIO, cfg);
+
+	cfg = (sc->vratio & SCALER_V_RATIO_MASK) << SCALER_V_RATIO_SHIFT;
+	scaler_write(dev, SCALER_V_RATIO, cfg);
+}
+
+void scaler_hw_set_rotation(struct scaler_ctx *ctx)
+{
+	struct scaler_dev *dev = ctx->scaler_dev;
+	u32 cfg = 0;
+
+	cfg = ((ctx->ctrls_scaler.rotate->val / 90) & SCALER_ROTMODE_MASK) <<
+						      SCALER_ROTMODE_SHIFT;
+
+	if (ctx->ctrls_scaler.hflip->val)
+		cfg |= SCALER_FLIP_X_EN;
+
+	if (ctx->ctrls_scaler.vflip->val)
+		cfg |= SCALER_FLIP_Y_EN;
+
+	scaler_write(dev, SCALER_ROT_CFG, cfg);
+}
+
+void scaler_hw_set_csc_coeff(struct scaler_ctx *ctx)
+{
+	struct scaler_dev *dev = ctx->scaler_dev;
+	enum scaler_csc_coeff type;
+	u32 cfg = 0;
+	int i, j;
+	static const u32 csc_coeff[SCALER_CSC_COEFF_MAX][3][3] = {
+		{ /* YCbCr to RGB */
+			{0x254, 0x000, 0x331},
+			{0x254, 0xec8, 0xFA0},
+			{0x254, 0x409, 0x000}
+		},
+		{ /* RGB to YCbCr */
+			{0x084, 0x102, 0x032},
+			{0xe4c, 0xe95, 0x0e1},
+			{0x0e1, 0xebc, 0xe24}
+		} };
+
+	/* TODO: add check for BT.601,BT.709 narrow/wide ranges */
+	if (is_rgb(ctx->s_frame.fmt) == is_rgb(ctx->d_frame.fmt)) {
+		type = SCALER_CSC_COEFF_NONE;
+	} else if (is_rgb(ctx->d_frame.fmt)) {
+		type = SCALER_CSC_COEFF_YCBCR_TO_RGB;
+		scaler_hw_src_y_offset_en(ctx->scaler_dev, true);
+	} else {
+		type = SCALER_CSC_COEFF_RGB_TO_YCBCR;
+		scaler_hw_src_y_offset_en(ctx->scaler_dev, true);
+	}
+
+	if (type == ctx->scaler_dev->coeff_type || type >= SCALER_CSC_COEFF_MAX)
+		return;
+
+	for (i = 0; i < 3; i++) {
+		for (j = 0; j < 3; j++) {
+			cfg = csc_coeff[type][i][j];
+			scaler_write(dev, SCALER_CSC_COEF(i, j), cfg);
+		}
+	}
+
+	ctx->scaler_dev->coeff_type = type;
+}
+
+void scaler_hw_src_y_offset_en(struct scaler_dev *dev, bool on)
+{
+	u32 cfg;
+
+	cfg = scaler_read(dev, SCALER_CFG);
+	if (on)
+		cfg |= SCALER_CFG_CSC_Y_OFFSET_SRC_EN;
+	else
+		cfg &= ~SCALER_CFG_CSC_Y_OFFSET_SRC_EN;
+
+	scaler_write(dev, SCALER_CFG, cfg);
+}
+
+void scaler_hw_dst_y_offset_en(struct scaler_dev *dev, bool on)
+{
+	u32 cfg;
+
+	cfg = scaler_read(dev, SCALER_CFG);
+	if (on)
+		cfg |= SCALER_CFG_CSC_Y_OFFSET_DST_EN;
+	else
+		cfg &= ~SCALER_CFG_CSC_Y_OFFSET_DST_EN;
+
+	scaler_write(dev, SCALER_CFG, cfg);
+}
+
+void scaler_hw_enable_control(struct scaler_dev *dev, bool on)
+{
+	u32 cfg;
+
+	if (on)
+		scaler_write(dev, SCALER_INT_EN, 0xffffffff);
+
+	cfg = scaler_read(dev, SCALER_CFG);
+	cfg |= SCALER_CFG_16_BURST_MODE;
+	if (on)
+		cfg |= SCALER_CFG_START_CMD;
+	else
+		cfg &= ~SCALER_CFG_START_CMD;
+
+	scaler_dbg(dev, "%s: SCALER_CFG:0x%x\n", __func__, cfg);
+
+	scaler_write(dev, SCALER_CFG, cfg);
+}
+
+unsigned int scaler_hw_get_irq_status(struct scaler_dev *dev)
+{
+	return scaler_read(dev, SCALER_INT_STATUS);
+}
+
+void scaler_hw_clear_irq(struct scaler_dev *dev, unsigned int irq)
+{
+	scaler_write(dev, SCALER_INT_STATUS, irq);
+}
diff --git a/drivers/media/platform/exynos-scaler/scaler-regs.h b/drivers/media/platform/exynos-scaler/scaler-regs.h
new file mode 100644
index 0000000..1ea9d3e
--- /dev/null
+++ b/drivers/media/platform/exynos-scaler/scaler-regs.h
@@ -0,0 +1,331 @@
+/*
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series SCALER driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef REGS_SCALER_H_
+#define REGS_SCALER_H_
+
+#include "scaler.h"
+
+/* SCALER status */
+#define SCALER_STATUS				0x00
+#define SCALER_STATUS_RUNNING			(1 << 1)
+#define SCALER_STATUS_READY_CLK_DOWN		(1 << 0)
+
+/* SCALER config */
+#define SCALER_CFG				0x04
+#define SCALER_CFG_FILL_EN			(1 << 24)
+#define SCALER_CFG_BLEND_CLR_DIV_ALPHA_EN	(1 << 17)
+#define SCALER_CFG_BLEND_EN			(1 << 16)
+#define SCALER_CFG_CSC_Y_OFFSET_SRC_EN		(1 << 10)
+#define SCALER_CFG_CSC_Y_OFFSET_DST_EN		(1 << 9)
+#define SCALER_CFG_16_BURST_MODE		(1 << 8)
+#define SCALER_CFG_SOFT_RESET			(1 << 1)
+#define SCALER_CFG_START_CMD			(1 << 0)
+
+/* SCALER interrupts */
+#define SCALER_INT_TIMEOUT			31
+#define SCALER_INT_ILLEGAL_BLEND		24
+#define SCALER_INT_ILLEGAL_RATIO		23
+#define SCALER_INT_ILLEGAL_DST_HEIGHT		22
+#define SCALER_INT_ILLEGAL_DST_WIDTH		21
+#define SCALER_INT_ILLEGAL_DST_V_POS		20
+#define SCALER_INT_ILLEGAL_DST_H_POS		19
+#define SCALER_INT_ILLEGAL_DST_C_SPAN		18
+#define SCALER_INT_ILLEGAL_DST_Y_SPAN		17
+#define SCALER_INT_ILLEGAL_DST_CR_BASE		16
+#define SCALER_INT_ILLEGAL_DST_CB_BASE		15
+#define SCALER_INT_ILLEGAL_DST_Y_BASE		14
+#define SCALER_INT_ILLEGAL_DST_COLOR		13
+#define SCALER_INT_ILLEGAL_SRC_HEIGHT		12
+#define SCALER_INT_ILLEGAL_SRC_WIDTH		11
+#define SCALER_INT_ILLEGAL_SRC_CV_POS		10
+#define SCALER_INT_ILLEGAL_SRC_CH_POS		9
+#define SCALER_INT_ILLEGAL_SRC_YV_POS		8
+#define SCALER_INT_ILLEGAL_SRC_YH_POS		7
+#define SCALER_INT_ILLEGAL_SRC_C_SPAN		6
+#define SCALER_INT_ILLEGAL_SRC_Y_SPAN		5
+#define SCALER_INT_ILLEGAL_SRC_CR_BASE		4
+#define SCALER_INT_ILLEGAL_SRC_CB_BASE		3
+#define SCALER_INT_ILLEGAL_SRC_Y_BASE		2
+#define SCALER_INT_ILLEGAL_SRC_COLOR		1
+#define SCALER_INT_FRAME_END			0
+
+/* SCALER interrupt enable */
+#define SCALER_INT_EN				0x08
+#define SCALER_INT_EN_DEFAULT			0x81ffffff
+
+/* SCALER interrupt status */
+#define SCALER_INT_STATUS			0x0c
+#define SCALER_INT_STATUS_CLEAR			0xffffffff
+#define SCALER_INT_STATUS_ERROR			0x81fffffe
+
+/* SCALER source format configuration */
+#define SCALER_SRC_CFG				0x10
+#define SCALER_SRC_TILE_EN			(0x1 << 10)
+#define SCALER_SRC_BYTE_SWAP_MASK		0x3
+#define SCALER_SRC_BYTE_SWAP_SHIFT		5
+#define SCALER_SRC_COLOR_FORMAT_MASK		0xf
+#define SCALER_SRC_COLOR_FORMAT_SHIFT		0
+
+/* SCALER source y-base */
+#define SCALER_SRC_Y_BASE			0x14
+
+/* SCALER source cb-base */
+#define SCALER_SRC_CB_BASE			0x18
+
+/* SCALER source cr-base */
+#define SCALER_SRC_CR_BASE			0x294
+
+/* SCALER source span */
+#define SCALER_SRC_SPAN				0x1c
+#define SCALER_SRC_C_SPAN_MASK			0x3fff
+#define SCALER_SRC_C_SPAN_SHIFT			16
+#define SCALER_SRC_Y_SPAN_MASK			0x3fff
+#define SCALER_SRC_Y_SPAN_SHIFT			0
+
+/*
+ * SCALER source y-position
+ * 14.2 fixed-point format
+ *      - 14 bits at the MSB are for the integer part.
+ *      - 2 bits at LSB are for fractional part and always has to be set to 0.
+ */
+#define SCALER_SRC_Y_POS			0x20
+#define SCALER_SRC_YH_POS_MASK			0xfffc
+#define SCALER_SRC_YH_POS_SHIFT			16
+#define SCALER_SRC_YV_POS_MASK			0xfffc
+#define SCALER_SRC_YV_POS_SHIFT			0
+
+/* SCALER source width/height */
+#define SCALER_SRC_WH				0x24
+#define SCALER_SRC_WIDTH_MASK			0x3fff
+#define SCALER_SRC_WIDTH_SHIFT			16
+#define SCALER_SRC_HEIGHT_MASK			0x3fff
+#define SCALER_SRC_HEIGHT_SHIFT			0
+
+/*
+ * SCALER source c-position
+ * 14.2 fixed-point format
+ *      - 14 bits at the MSB are for the integer part.
+ *      - 2 bits at LSB are for fractional part and always has to be set to 0.
+ */
+#define SCALER_SRC_C_POS			0x28
+#define SCALER_SRC_CH_POS_MASK			0xfffc
+#define SCALER_SRC_CH_POS_SHIFT			16
+#define SCALER_SRC_CV_POS_MASK			0xfffc
+#define SCALER_SRC_CV_POS_SHIFT			0
+
+/* SCALER destination format configuration */
+#define SCALER_DST_CFG				0x30
+#define SCALER_DST_BYTE_SWAP_MASK		0x3
+#define SCALER_DST_BYTE_SWAP_SHIFT		5
+#define SCALER_DST_COLOR_FORMAT_MASK		0xf
+
+/* SCALER destination y-base */
+#define SCALER_DST_Y_BASE			0x34
+
+/* SCALER destination cb-base */
+#define SCALER_DST_CB_BASE			0x38
+
+/* SCALER destination cr-base */
+#define SCALER_DST_CR_BASE			0x298
+
+/* SCALER destination span */
+#define SCALER_DST_SPAN				0x3c
+#define SCALER_DST_C_SPAN_MASK			0x3fff
+#define SCALER_DST_C_SPAN_SHIFT			16
+#define SCALER_DST_Y_SPAN_MASK			0x3fff
+#define SCALER_DST_Y_SPAN_SHIFT			0
+
+/* SCALER destination width/height */
+#define SCALER_DST_WH				0x40
+#define SCALER_DST_WIDTH_MASK			0x3fff
+#define SCALER_DST_WIDTH_SHIFT			16
+#define SCALER_DST_HEIGHT_MASK			0x3fff
+#define SCALER_DST_HEIGHT_SHIFT			0
+
+/* SCALER destination position */
+#define SCALER_DST_POS				0x44
+#define SCALER_DST_H_POS_MASK			0x3fff
+#define SCALER_DST_H_POS_SHIFT			16
+#define SCALER_DST_V_POS_MASK			0x3fff
+#define SCALER_DST_V_POS_SHIFT			0
+
+/* SCALER horizontal scale ratio */
+#define SCALER_H_RATIO				0x50
+#define SCALER_H_RATIO_MASK			0x7ffff
+#define SCALER_H_RATIO_SHIFT			0
+
+/* SCALER vertical scale ratio */
+#define SCALER_V_RATIO				0x54
+#define SCALER_V_RATIO_MASK			0x7ffff
+#define SCALER_V_RATIO_SHIFT			0
+
+/* SCALER rotation config */
+#define SCALER_ROT_CFG				0x58
+#define SCALER_FLIP_X_EN			(1 << 3)
+#define SCALER_FLIP_Y_EN			(1 << 2)
+#define SCALER_ROTMODE_MASK			0x3
+#define SCALER_ROTMODE_SHIFT			0
+
+/* SCALER csc coefficients */
+#define SCALER_CSC_COEF(x, y)			(0x220 + ((x * 12) + (y * 4)))
+
+/* SCALER dither config */
+#define SCALER_DITH_CFG				0x250
+#define SCALER_DITHER_R_TYPE_MASK		0x7
+#define SCALER_DITHER_R_TYPE_SHIFT		6
+#define SCALER_DITHER_G_TYPE_MASK		0x7
+#define SCALER_DITHER_G_TYPE_SHIFT		3
+#define SCALER_DITHER_B_TYPE_MASK		0x7
+#define SCALER_DITHER_B_TYPE_SHIFT		0
+
+/* SCALER src blend color */
+#define SCALER_SRC_BLEND_COLOR			0x280
+#define SCALER_SRC_COLOR_SEL_INV		(1 << 31)
+#define SCALER_SRC_COLOR_SEL_MASK		0x3
+#define SCALER_SRC_COLOR_SEL_SHIFT		29
+#define SCALER_SRC_COLOR_OP_SEL_INV		(1 << 28)
+#define SCALER_SRC_COLOR_OP_SEL_MASK		0xf
+#define SCALER_SRC_COLOR_OP_SEL_SHIFT		24
+#define SCALER_SRC_GLOBAL_COLOR0_MASK		0xff
+#define SCALER_SRC_GLOBAL_COLOR0_SHIFT		16
+#define SCALER_SRC_GLOBAL_COLOR1_MASK		0xff
+#define SCALER_SRC_GLOBAL_COLOR1_SHIFT		8
+#define SCALER_SRC_GLOBAL_COLOR2_MASK		0xff
+#define SCALER_SRC_GLOBAL_COLOR2_SHIFT		0
+
+/* SCALER src blend alpha */
+#define SCALER_SRC_BLEND_ALPHA			0x284
+#define SCALER_SRC_ALPHA_SEL_INV		(1 << 31)
+#define SCALER_SRC_ALPHA_SEL_MASK		0x3
+#define SCALER_SRC_ALPHA_SEL_SHIFT		29
+#define SCALER_SRC_ALPHA_OP_SEL_INV		(1 << 28)
+#define SCALER_SRC_ALPHA_OP_SEL_MASK		0xf
+#define SCALER_SRC_ALPHA_OP_SEL_SHIFT		24
+#define SCALER_SRC_GLOBAL_ALPHA_MASK		0xff
+#define SCALER_SRC_GLOBAL_ALPHA_SHIFT		0
+
+/* SCALER dst blend color */
+#define SCALER_DST_BLEND_COLOR			0x288
+#define SCALER_DST_COLOR_SEL_INV		(1 << 31)
+#define SCALER_DST_COLOR_SEL_MASK		0x3
+#define SCALER_DST_COLOR_SEL_SHIFT		29
+#define SCALER_DST_COLOR_OP_SEL_INV		(1 << 28)
+#define SCALER_DST_COLOR_OP_SEL_MASK		0xf
+#define SCALER_DST_COLOR_OP_SEL_SHIFT		24
+#define SCALER_DST_GLOBAL_COLOR0_MASK		0xff
+#define SCALER_DST_GLOBAL_COLOR0_SHIFT		16
+#define SCALER_DST_GLOBAL_COLOR1_MASK		0xff
+#define SCALER_DST_GLOBAL_COLOR1_SHIFT		8
+#define SCALER_DST_GLOBAL_COLOR2_MASK		0xff
+#define SCALER_DST_GLOBAL_COLOR2_SHIFT		0
+
+/* SCALER dst blend alpha */
+#define SCALER_DST_BLEND_ALPHA			0x28c
+#define SCALER_DST_ALPHA_SEL_INV		(1 << 31)
+#define SCALER_DST_ALPHA_SEL_MASK		0x3
+#define SCALER_DST_ALPHA_SEL_SHIFT		29
+#define SCALER_DST_ALPHA_OP_SEL_INV		(1 << 28)
+#define SCALER_DST_ALPHA_OP_SEL_MASK		0xf
+#define SCALER_DST_ALPHA_OP_SEL_SHIFT		24
+#define SCALER_DST_GLOBAL_ALPHA_MASK		0xff
+#define SCALER_DST_GLOBAL_ALPHA_SHIFT		0
+
+/* SCALER fill color */
+#define SCALER_FILL_COLOR			0x290
+#define SCALER_FILL_ALPHA_MASK			0xff
+#define SCALER_FILL_ALPHA_SHIFT			24
+#define SCALER_FILL_COLOR0_MASK			0xff
+#define SCALER_FILL_COLOR0_SHIFT		16
+#define SCALER_FILL_COLOR1_MASK			0xff
+#define SCALER_FILL_COLOR1_SHIFT		8
+#define SCALER_FILL_COLOR2_MASK			0xff
+#define SCALER_FILL_COLOR2_SHIFT		0
+
+/* SCALER address queue config */
+#define SCALER_ADDR_QUEUE_CONFIG		0x2a0
+#define SCALER_ADDR_QUEUE_RST			0x1
+
+/* Arbitrary R/W register and value to check if soft reset succeeded */
+#define SCALER_CFG_SOFT_RESET_CHECK_REG		SCALER_SRC_CFG
+#define SCALER_CFG_SOFT_RESET_CHECK_VAL		0x3
+
+struct scaler_error {
+	u32 irq_num;
+	const char * const name;
+};
+
+static const struct scaler_error scaler_errors[] = {
+	{ SCALER_INT_TIMEOUT,			"Timeout" },
+	{ SCALER_INT_ILLEGAL_BLEND,		"Blend setting" },
+	{ SCALER_INT_ILLEGAL_RATIO,		"Scale ratio setting" },
+	{ SCALER_INT_ILLEGAL_DST_HEIGHT,	"Dst Height" },
+	{ SCALER_INT_ILLEGAL_DST_WIDTH,		"Dst Width" },
+	{ SCALER_INT_ILLEGAL_DST_V_POS,		"Dst V-Pos" },
+	{ SCALER_INT_ILLEGAL_DST_H_POS,		"Dst H-Pos" },
+	{ SCALER_INT_ILLEGAL_DST_C_SPAN,	"Dst C-Span" },
+	{ SCALER_INT_ILLEGAL_DST_Y_SPAN,	"Dst Y-span" },
+	{ SCALER_INT_ILLEGAL_DST_CR_BASE,	"Dst Cr-base" },
+	{ SCALER_INT_ILLEGAL_DST_CB_BASE,	"Dst Cb-base" },
+	{ SCALER_INT_ILLEGAL_DST_Y_BASE,	"Dst Y-base" },
+	{ SCALER_INT_ILLEGAL_DST_COLOR,		"Dst Color" },
+	{ SCALER_INT_ILLEGAL_SRC_HEIGHT,	"Src Height" },
+	{ SCALER_INT_ILLEGAL_SRC_WIDTH,		"Src Width" },
+	{ SCALER_INT_ILLEGAL_SRC_CV_POS,	"Src Chroma V-pos" },
+	{ SCALER_INT_ILLEGAL_SRC_CH_POS,	"Src Chroma H-pos" },
+	{ SCALER_INT_ILLEGAL_SRC_YV_POS,	"Src Luma V-pos" },
+	{ SCALER_INT_ILLEGAL_SRC_YH_POS,	"Src Luma H-pos" },
+	{ SCALER_INT_ILLEGAL_SRC_C_SPAN,	"Src C-span" },
+	{ SCALER_INT_ILLEGAL_SRC_Y_SPAN,	"Src Y-span" },
+	{ SCALER_INT_ILLEGAL_SRC_CR_BASE,	"Src Cr-base" },
+	{ SCALER_INT_ILLEGAL_SRC_CB_BASE,	"Src Cb-base" },
+	{ SCALER_INT_ILLEGAL_SRC_Y_BASE,	"Src Y-base" },
+	{ SCALER_INT_ILLEGAL_SRC_COLOR,		"Src Color setting" },
+};
+
+#define SCALER_NUM_ERRORS	ARRAY_SIZE(scaler_errors)
+
+static inline u32 scaler_read(struct scaler_dev *dev, u32 offset)
+{
+	return readl(dev->regs + offset);
+}
+
+static inline void scaler_write(struct scaler_dev *dev, u32 offset, u32 value)
+{
+	writel(value, dev->regs + offset);
+}
+
+static inline void scaler_hw_address_queue_reset(struct scaler_ctx *ctx)
+{
+	scaler_write(ctx->scaler_dev, SCALER_ADDR_QUEUE_CONFIG,
+					SCALER_ADDR_QUEUE_RST);
+}
+
+void scaler_hw_set_sw_reset(struct scaler_dev *dev);
+int scaler_wait_reset(struct scaler_dev *dev);
+void scaler_hw_set_irq(struct scaler_dev *dev, int interrupt, bool mask);
+void scaler_hw_set_input_addr(struct scaler_dev *dev, struct scaler_addr *addr);
+void scaler_hw_set_output_addr(struct scaler_dev *dev,
+				struct scaler_addr *addr);
+void scaler_hw_set_in_size(struct scaler_ctx *ctx);
+void scaler_hw_set_in_image_format(struct scaler_ctx *ctx);
+void scaler_hw_set_out_size(struct scaler_ctx *ctx);
+void scaler_hw_set_out_image_format(struct scaler_ctx *ctx);
+void scaler_hw_set_scaler_ratio(struct scaler_ctx *ctx);
+void scaler_hw_set_rotation(struct scaler_ctx *ctx);
+void scaler_hw_set_csc_coeff(struct scaler_ctx *ctx);
+void scaler_hw_src_y_offset_en(struct scaler_dev *dev, bool on);
+void scaler_hw_dst_y_offset_en(struct scaler_dev *dev, bool on);
+void scaler_hw_enable_control(struct scaler_dev *dev, bool on);
+unsigned int scaler_hw_get_irq_status(struct scaler_dev *dev);
+void scaler_hw_clear_irq(struct scaler_dev *dev, unsigned int irq);
+
+#endif /* REGS_SCALER_H_ */
-- 
1.7.9.5

