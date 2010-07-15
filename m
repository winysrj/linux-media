Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42919 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803Ab0GOJKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jul 2010 05:10:50 -0400
Date: Thu, 15 Jul 2010 11:10:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 04/10 v2] v4l: Add Samsung FIMC (video postprocessor) driver
In-reply-to: <1279185041-6004-1-git-send-email-s.nawrocki@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
Message-id: <1279185041-6004-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1279185041-6004-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver exports two video device nodes per each FIMC device,
one for for memory to memory (color conversion, image resizing,
flipping and rotation) operations and one for direct
V4L2 output interface to framebuffer.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/Kconfig                  |   20 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/samsung/fimc/Makefile    |    3 +
 drivers/media/video/samsung/fimc/fimc-core.c | 1664 ++++++++++++++++++++++++++
 drivers/media/video/samsung/fimc/fimc-core.h |  541 +++++++++
 drivers/media/video/samsung/fimc/fimc-fifo.c |  814 +++++++++++++
 drivers/media/video/samsung/fimc/fimc-reg.c  |  585 +++++++++
 include/linux/videodev2.h                    |    1 +
 8 files changed, 3629 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/samsung/fimc/Makefile
 create mode 100644 drivers/media/video/samsung/fimc/fimc-core.c
 create mode 100644 drivers/media/video/samsung/fimc/fimc-core.h
 create mode 100644 drivers/media/video/samsung/fimc/fimc-fifo.c
 create mode 100644 drivers/media/video/samsung/fimc/fimc-reg.c

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index bdbc9d3..5895646 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -969,6 +969,16 @@ config VIDEO_OMAP2
 	---help---
 	  This is a v4l2 driver for the TI OMAP2 camera capture interface
 
+config  VIDEO_SAMSUNG_FIMC
+	tristate "Samsung S3C/S5P FIMC (video postprocessor) driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	default n
+	help
+	  This is a v4l2 driver for the S3C/S5P camera interface
+	  (video postprocessor).
+
 #
 # USB Multimedia device configuration
 #
@@ -1150,4 +1160,14 @@ config VIDEO_MEM2MEM_TESTDEV
 	  This is a virtual test device for the memory-to-memory driver
 	  framework.
 
+config  VIDEO_SAMSUNG_FIMC
+	tristate "Samsung S3C/S5P FIMC (video postprocessor) driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	default n
+	help
+	  This is a v4l2 driver for the S3C/S5P camera interface
+	  (video postprocessor)
+
 endif # V4L_MEM2MEM_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index cc93859..e4c2e1f 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -165,6 +165,7 @@ obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
 obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
 obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
+obj-$(CONFIG_VIDEO_SAMSUNG_FIMC) 	+= samsung/fimc/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
diff --git a/drivers/media/video/samsung/fimc/Makefile b/drivers/media/video/samsung/fimc/Makefile
new file mode 100644
index 0000000..c5c40c1
--- /dev/null
+++ b/drivers/media/video/samsung/fimc/Makefile
@@ -0,0 +1,3 @@
+
+obj-$(CONFIG_VIDEO_SAMSUNG_FIMC) := samsung-fimc.o
+samsung-fimc-y := fimc-core.o fimc-reg.o fimc-fifo.o
diff --git a/drivers/media/video/samsung/fimc/fimc-core.c b/drivers/media/video/samsung/fimc/fimc-core.c
new file mode 100644
index 0000000..448550b
--- /dev/null
+++ b/drivers/media/video/samsung/fimc/fimc-core.c
@@ -0,0 +1,1664 @@
+/*
+ * S5P camera interface (video postprocessor) driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Sylwester Nawrocki, s.nawrocki@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/bug.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf-dma-contig.h>
+
+#include "fimc-core.h"
+
+static char *fimc_clock_name[NUM_FIMC_CLOCKS] = { "sclk_fimc", "fimc" };
+
+struct fimc_fmt fimc_formats[] = {
+	{
+		.name	= "RGB565",
+		.fourcc	= V4L2_PIX_FMT_RGB565X,
+		.depth	= 16,
+		.color	= S5P_FIMC_RGB565,
+		.buff_cnt = 1,
+		.planes_cnt = 1
+	}, {
+		.name	= "RGB666",
+		.fourcc	= V4L2_PIX_FMT_RGB666,
+		.depth	= 32,
+		.color	= S5P_FIMC_RGB666,
+		.buff_cnt = 1,
+		.planes_cnt = 1
+	}, {
+		.name = "XRGB-8-8-8-8, 24 bpp",
+		.fourcc	= V4L2_PIX_FMT_RGB24,
+		.depth = 32,
+		.color	= S5P_FIMC_RGB888,
+		.buff_cnt = 1,
+		.planes_cnt = 1
+	}, {
+		.name	= "YUV 4:2:2 packed, YCbYCr",
+		.fourcc	= V4L2_PIX_FMT_YUYV,
+		.depth	= 16,
+		.color	= S5P_FIMC_YCBYCR422,
+		.buff_cnt = 1,
+		.planes_cnt = 1
+		}, {
+		.name	= "YUV 4:2:2 packed, CbYCrY",
+		.fourcc	= V4L2_PIX_FMT_UYVY,
+		.depth	= 16,
+		.color	= S5P_FIMC_CBYCRY422,
+		.buff_cnt = 1,
+		.planes_cnt = 1
+	}, {
+		.name	= "YUV 4:2:2 packed, CrYCbY",
+		.fourcc	= V4L2_PIX_FMT_VYUY,
+		.depth	= 16,
+		.color	= S5P_FIMC_CRYCBY422,
+		.buff_cnt = 1,
+		.planes_cnt = 1
+	}, {
+		.name	= "YUV 4:2:2 packed, YCrYCb",
+		.fourcc	= V4L2_PIX_FMT_YVYU,
+		.depth	= 16,
+		.color	= S5P_FIMC_YCRYCB422,
+		.buff_cnt = 1,
+		.planes_cnt = 1
+	}, {
+		.name	= "YUV 4:2:2 planar, Y/Cb/Cr",
+		.fourcc	= V4L2_PIX_FMT_YUV422P,
+		.depth	= 12,
+		.color	= S5P_FIMC_YCBCR422,
+		.buff_cnt = 1,
+		.planes_cnt = 3
+	}, {
+		.name	= "YUV 4:2:2 planar, Y/CbCr",
+		.fourcc	= V4L2_PIX_FMT_NV16,
+		.depth	= 16,
+		.color	= S5P_FIMC_YCBCR422,
+		.buff_cnt = 1,
+		.planes_cnt = 2
+	}, {
+		.name	= "YUV 4:2:2 planar, Y/CrCb",
+		.fourcc	= V4L2_PIX_FMT_NV61,
+		.depth	= 16,
+		.color	= S5P_FIMC_RGB565,
+		.buff_cnt = 1,
+		.planes_cnt = 2
+	}, {
+		.name	= "YUV 4:2:0 planar, YCbCr",
+		.fourcc	= V4L2_PIX_FMT_YUV420,
+		.depth	= 12,
+		.color	= S5P_FIMC_YCBCR420,
+		.buff_cnt = 1,
+		.planes_cnt = 3
+	}, {
+		.name	= "YUV 4:2:0 planar, Y/CbCr",
+		.fourcc	= V4L2_PIX_FMT_NV12,
+		.depth	= 12,
+		.color	= S5P_FIMC_YCBCR420,
+		.buff_cnt = 1,
+		.planes_cnt = 2
+	}
+ };
+
+static struct v4l2_queryctrl fimc_ctrls[] = {
+	{
+		.id		= V4L2_CID_HFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Horizontal flip",
+		.minimum	= 0,
+		.maximum	= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_VFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Vertical flip",
+		.minimum	= 0,
+		.maximum	= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_ROTATE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Rotation (CCW)",
+		.minimum	= 0,
+		.maximum	= 270,
+		.step		= 90,
+		.default_value	= 0,
+	},
+};
+
+
+static struct v4l2_queryctrl *get_ctrl(int id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(fimc_ctrls); ++i)
+		if (id == fimc_ctrls[i].id)
+			return &fimc_ctrls[i];
+	return NULL;
+}
+
+int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f)
+{
+	int ret = 0;
+	if (r->width > f->width) {
+		if (f->width > (r->width * SCALER_MAX_HRATIO))
+			ret = 1;
+	} else {
+		if ((f->width * SCALER_MAX_HRATIO) < r->width)
+			ret = 1;
+	}
+
+	if (r->height > f->height) {
+		if (f->height > (r->height * SCALER_MAX_VRATIO))
+			ret = 1;
+	} else {
+		if ((f->height * SCALER_MAX_VRATIO) < r->height)
+			ret = 1;
+	}
+
+	return ret;
+}
+
+static int fimc_get_scaler_factor(u32 src, u32 tar, u32 *ratio, u32 *shift)
+{
+	if (src >= tar * 64) {
+		return -EINVAL;
+	} else if (src >= tar * 32) {
+		*ratio = 32;
+		*shift = 5;
+	} else if (src >= tar * 16) {
+		*ratio = 16;
+		*shift = 4;
+	} else if (src >= tar * 8) {
+		*ratio = 8;
+		*shift = 3;
+	} else if (src >= tar * 4) {
+		*ratio = 4;
+		*shift = 2;
+	} else if (src >= tar * 2) {
+		*ratio = 2;
+		*shift = 1;
+	} else {
+		*ratio = 1;
+		*shift = 0;
+	}
+
+	return 0;
+}
+
+int fimc_set_scaler_info(struct fimc_ctx *ctx)
+{
+	struct fimc_scaler *sc = &ctx->scaler;
+	struct fimc_dma_offset *d_ofs = &ctx->s_frame.dma_offset;
+	struct fimc_frame *s_frame = &ctx->s_frame;
+	struct fimc_frame *d_frame = &ctx->d_frame;
+	int width, height, h_ofs, v_ofs;
+	int tx, ty, sx, sy;
+	int ret;
+
+	if (ctx->in_path == FIMC_DMA) {
+		if ((ctx->rotation == 90 || ctx->rotation == 270)
+			&& FIMC_LCDFIFO == ctx->out_path) {
+			/* here we are using only the input rotator */
+			width = s_frame->height;
+			height = s_frame->width;
+			h_ofs = d_ofs->y_v;
+			v_ofs = d_ofs->y_h;
+		} else {
+			width = s_frame->width;
+			height = s_frame->height;
+			h_ofs = d_ofs->y_h;
+			v_ofs = d_ofs->y_v;
+		}
+	} else {
+		width = s_frame->width;
+		height = s_frame->height;
+		h_ofs = d_ofs->y_h;
+		v_ofs = d_ofs->y_v;
+	}
+
+	tx = d_frame->width;
+	ty = d_frame->height;
+
+	if (tx <= 0 || ty <= 0) {
+		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
+			"invalid target size: %d %d", tx, ty);
+		return -EINVAL;
+	}
+
+	sx = width;
+	sy = height;
+
+	sc->real_width = width;
+	sc->real_height = height;
+
+	if (sx <= 0 || sy <= 0) {
+		err("invalid source size: s: %d %d, t: %d %d", sx, sy, tx, ty);
+		return -EINVAL;
+	}
+
+	dbg("sx= %d, sy= %d, tx= %d, ty= %d", sx, sy, tx, ty);
+
+	ret = fimc_get_scaler_factor(sx, tx,
+			  &sc->pre_hratio, &sc->hfactor);
+	if (ret)
+		return ret;
+
+	ret = fimc_get_scaler_factor(sy, ty,
+			  &sc->pre_vratio, &sc->vfactor);
+	if (ret)
+		return ret;
+
+	sc->pre_dst_width = sx/sc->pre_hratio;
+	sc->pre_dst_height = sy/sc->pre_vratio;
+
+	sc->main_hratio = (sx << 8) / (tx << sc->hfactor);
+	sc->main_vratio = (sy << 8) / (ty << sc->vfactor);
+
+	dbg("sc->main_hratio= %d, sc->main_vratio= %d",
+		sc->main_hratio, sc->main_vratio);
+	dbg("sc->hfactor= %d, sc->vfactor= %d", sc->hfactor, sc->vfactor);
+
+	sc->scaleup_h = (tx >= sx) ? 1 : 0;
+	sc->scaleup_v = (ty >= sy) ? 1 : 0;
+
+	/* check to see if input and output size/format differ */
+	if (s_frame->fmt->color == d_frame->fmt->color
+		&& s_frame->width == d_frame->width
+		&& s_frame->height == d_frame->height)
+		sc->copy_mode = 1;
+	else
+		sc->copy_mode = 0;
+
+	return 0;
+}
+
+
+static irqreturn_t fimc_isr(int irq, void *priv)
+{
+	struct fimc_ctx *ctx;
+	struct fimc_vid_buffer *src_buf, *dst_buf;
+	struct fimc_dev *fimc = (struct fimc_dev *)priv;
+	struct fimc_output_device *outp = &fimc->outp;
+
+	BUG_ON(!fimc);
+	fimc_hw_clear_irq(fimc);
+
+	spin_lock(&fimc->slock);
+
+	/* v4l2-mem2mem */
+	if (test_and_clear_bit(ST_M2M_PEND, &fimc->state)) {
+		ctx = v4l2_m2m_get_curr_priv(fimc->m2m.m2m_dev);
+		if (!ctx || !ctx->m2m_ctx)
+			goto isr_unlock;
+		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+		if (src_buf && dst_buf) {
+			spin_lock(&fimc->irqlock);
+			src_buf->vb.state = dst_buf->vb.state =  VIDEOBUF_DONE;
+			wake_up(&src_buf->vb.done);
+			wake_up(&dst_buf->vb.done);
+			spin_unlock(&fimc->irqlock);
+			v4l2_m2m_job_finish(fimc->m2m.m2m_dev, ctx->m2m_ctx);
+		}
+		goto isr_unlock;
+	}
+
+	/* local fifo mode */
+	fimc_hw_reset_fifo_ov(fimc);
+
+	if (test_bit(ST_LCDFIFO_RUN, &fimc->state)) {
+		/* schedule next buffer in hw if there is any available */
+		if (!list_empty(&outp->buf_q)) {
+			ctx = outp->ctx;
+
+			spin_lock(&fimc->irqlock);
+			outp->curr_buf->vb.state = VIDEOBUF_DONE;
+			spin_unlock(&fimc->irqlock);
+			wake_up(&outp->curr_buf->vb.done);
+
+			outp->curr_buf = list_entry(outp->buf_q.next,
+				struct fimc_vid_buffer, vb.queue);
+			outp->curr_buf->vb.state = VIDEOBUF_ACTIVE;
+			list_del(&outp->curr_buf->vb.queue);
+
+			spin_lock(&ctx->slock);
+			fimc_prepare_addr(ctx, outp->curr_buf,
+					  V4L2_BUF_TYPE_VIDEO_OUTPUT);
+			/* set source buffer address in hw */
+			fimc_hw_set_input_addr(fimc, &ctx->s_frame.paddr);
+			spin_unlock(&ctx->slock);
+		}
+
+	} else if (test_and_clear_bit(ST_LCDFIFO_PEND, &fimc->state)) {
+		set_bit(ST_LCDFIFO_RUN, &fimc->state);
+	}
+
+isr_unlock:
+	spin_unlock(&fimc->slock);
+	return IRQ_HANDLED;
+}
+
+
+static void fimc_dma_run(void *priv)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	u32 ret;
+
+	if (!ctx || ctx->out_path != FIMC_DMA)
+		return;
+
+	set_bit(ST_M2M_PEND, &fimc->state);
+
+	ctx->flags |= (FIMC_SRC_ADDR | FIMC_DST_ADDR);
+	ret = fimc_prepare_config(ctx, ctx->flags);
+	if (ret) {
+		err("general configuration error");
+		return;
+	}
+
+	if (fimc->m2m.ctx != ctx)
+		ctx->flags |= FIMC_PARAMS;
+
+	fimc_hw_set_input_addr(fimc, &ctx->s_frame.paddr);
+
+	if (ctx->flags & FIMC_PARAMS) {
+		fimc_hw_set_input_path(ctx);
+		fimc_hw_set_in_dma(ctx);
+		if (fimc_set_scaler_info(ctx)) {
+			err("scaler configuration error");
+			return;
+		}
+		fimc_hw_set_prescaler(ctx);
+		fimc_hw_set_scaler(ctx);
+		fimc_hw_set_target_format(ctx);
+		fimc_hw_set_rotation(ctx);
+		fimc_hw_set_effect(ctx);
+	}
+
+	fimc_hw_set_output_path(ctx);
+	if (ctx->flags & (FIMC_DST_ADDR | FIMC_PARAMS))
+		fimc_hw_set_output_addr(fimc, &ctx->d_frame.paddr);
+
+	if (ctx->flags & FIMC_PARAMS)
+		fimc_hw_set_out_dma(ctx);
+
+	if (ctx->scaler.enabled)
+		fimc_hw_start_scaler(fimc);
+	fimc_hw_en_capture(ctx);
+
+	ctx->flags = 0;
+
+	fimc_hw_start_in_dma(fimc);
+
+	fimc->m2m.ctx = ctx;
+}
+
+static void fimc_job_abort(void *priv)
+{
+
+}
+
+/* set order for 1 and 2 plane YCBCR 4:2:2 formats */
+static void fimc_set_yuv_order(struct fimc_ctx *ctx)
+{
+	/* the one only mode supported in SoC */
+	ctx->in_order_2p = S5P_FIMC_LSB_CRCB;
+	ctx->out_order_2p = S5P_FIMC_LSB_CRCB;
+
+	/* set order for 1 plane input formats */
+	switch (ctx->s_frame.fmt->color) {
+	case S5P_FIMC_YCRYCB422:
+		ctx->in_order_1p = S5P_FIMC_IN_YCRYCB;
+		break;
+	case S5P_FIMC_CBYCRY422:
+		ctx->in_order_1p = S5P_FIMC_IN_CBYCRY;
+		break;
+	case S5P_FIMC_CRYCBY422:
+		ctx->in_order_1p = S5P_FIMC_IN_CRYCBY;
+		break;
+	case S5P_FIMC_YCBYCR422:
+	default:
+		ctx->in_order_1p = S5P_FIMC_IN_YCBYCR;
+		break;
+	}
+	dbg("ctx->in_order_1p= %d", ctx->in_order_1p);
+
+	switch (ctx->d_frame.fmt->color) {
+	case S5P_FIMC_YCRYCB422:
+		ctx->out_order_1p = S5P_FIMC_OUT_YCRYCB;
+		break;
+	case S5P_FIMC_CBYCRY422:
+		ctx->out_order_1p = S5P_FIMC_OUT_CBYCRY;
+		break;
+	case S5P_FIMC_CRYCBY422:
+		ctx->out_order_1p = S5P_FIMC_OUT_CRYCBY;
+		break;
+	case S5P_FIMC_YCBYCR422:
+	default:
+		ctx->out_order_1p = S5P_FIMC_OUT_YCBYCR;
+		break;
+	}
+	dbg("ctx->out_order_1p= %d", ctx->out_order_1p);
+}
+
+/**
+ * fimc_prepare_config - check dimensions, operation and color mode
+ *			 and pre-calculate offset and the scaling coefficients.
+ *
+ * @ctx: hardware context information
+ * @flags: flags indicating which parameters to check/update
+ *
+ * Return: 0 if dimensions are valid or non zero otherwise.
+ */
+int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
+{
+	struct fimc_frame *s_frame, *d_frame;
+	struct fimc_vid_buffer *buf = NULL;
+	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	int ret = 0;
+
+	s_frame = &ctx->s_frame;
+	d_frame = &ctx->d_frame;
+
+	if (flags & FIMC_PARAMS) {
+		if ((ctx->out_path == FIMC_DMA) &&
+			(ctx->rotation == 90 || ctx->rotation == 270)) {
+			swap(d_frame->f_width, d_frame->f_height);
+			swap(d_frame->width, d_frame->height);
+		}
+
+		/* Prepare the output offset related attributes for scaler. */
+		d_frame->dma_offset.y_h = d_frame->offs_h;
+		if (!variant->pix_hoff)
+			d_frame->dma_offset.y_h *= (d_frame->fmt->depth >> 3);
+
+		d_frame->dma_offset.y_v = d_frame->offs_v;
+
+		d_frame->dma_offset.cb_h = d_frame->offs_h;
+		d_frame->dma_offset.cb_v = d_frame->offs_v;
+
+		d_frame->dma_offset.cr_h = d_frame->offs_h;
+		d_frame->dma_offset.cr_v = d_frame->offs_v;
+
+		if (!variant->pix_hoff && d_frame->fmt->planes_cnt == 3) {
+			d_frame->dma_offset.cb_h >>= 1;
+			d_frame->dma_offset.cb_v >>= 1;
+			d_frame->dma_offset.cr_h >>= 1;
+			d_frame->dma_offset.cr_v >>= 1;
+		}
+
+		dbg("out offset: color= %d, y_h= %d, y_v= %d",
+			d_frame->fmt->color,
+			d_frame->dma_offset.y_h, d_frame->dma_offset.y_v);
+
+		/* Prepare the input offset related attributes for scaler. */
+		s_frame->dma_offset.y_h = s_frame->offs_h;
+		if (!variant->pix_hoff)
+			s_frame->dma_offset.y_h *= (s_frame->fmt->depth >> 3);
+		s_frame->dma_offset.y_v = s_frame->offs_v;
+
+		s_frame->dma_offset.cb_h = s_frame->offs_h;
+		s_frame->dma_offset.cb_v = s_frame->offs_v;
+
+		s_frame->dma_offset.cr_h = s_frame->offs_h;
+		s_frame->dma_offset.cr_v = s_frame->offs_v;
+
+		if (!variant->pix_hoff && s_frame->fmt->planes_cnt == 3) {
+			s_frame->dma_offset.cb_h >>= 1;
+			s_frame->dma_offset.cb_v >>= 1;
+			s_frame->dma_offset.cr_h >>= 1;
+			s_frame->dma_offset.cr_v >>= 1;
+		}
+
+		dbg("in offset: color= %d, y_h= %d, y_v= %d",
+			s_frame->fmt->color, s_frame->dma_offset.y_h,
+			s_frame->dma_offset.y_v);
+
+		fimc_set_yuv_order(ctx);
+
+		/* Check against the scaler ratio */
+		if (s_frame->height > (SCALER_MAX_VRATIO * d_frame->height) ||
+		    s_frame->width > (SCALER_MAX_HRATIO * d_frame->width)) {
+			err("out of scaler range");
+			return -EINVAL;
+		}
+	}
+
+	/* Input DMA mode is not allowed when the scaler is disabled. */
+	ctx->scaler.enabled = 1;
+
+	if (flags & FIMC_SRC_ADDR) {
+		buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+		ret = fimc_prepare_addr(ctx, buf,
+			V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		if (ret)
+			return ret;
+	}
+
+	if (flags & FIMC_DST_ADDR) {
+		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+		ret = fimc_prepare_addr(ctx, buf,
+			V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	}
+
+	return ret;
+}
+
+/* The color format (planes_cnt, buff_cnt) must be already configured. */
+int fimc_prepare_addr(struct fimc_ctx *ctx,
+		struct fimc_vid_buffer *buf, enum v4l2_buf_type type)
+{
+	struct fimc_frame *frame;
+	struct fimc_addr *paddr;
+	u32 pix_size;
+	int ret = 0;
+
+	ctx_m2m_get_frame(frame, ctx, type);
+	paddr = &frame->paddr;
+
+	if (!buf)
+		return -EINVAL;
+
+	pix_size = frame->width * frame->height;
+
+	dbg("buff_cnt= %d, planes_cnt= %d, frame->size= %d, pix_size= %d",
+		frame->fmt->buff_cnt, frame->fmt->planes_cnt,
+		frame->size, pix_size);
+
+	if (frame->fmt->buff_cnt == 1) {
+		paddr->y = videobuf_to_dma_contig(&buf->vb);
+		switch (frame->fmt->planes_cnt) {
+		case 1:
+			paddr->cb = 0;
+			paddr->cr = 0;
+			break;
+		case 2:
+			/* decompose Y into Y/Cb */
+			paddr->cb = (u32)(paddr->y + pix_size);
+			paddr->cr = 0;
+			break;
+		case 3:
+			paddr->cb = (u32)(paddr->y + pix_size);
+			/* decompose Y into Y/Cb/Cr */
+			if (S5P_FIMC_YCBCR420 == frame->fmt->color)
+				paddr->cr = (u32)(paddr->cb
+						+ (pix_size >> 2));
+			else /* 422 */
+				paddr->cr = (u32)(paddr->cb
+						+ (pix_size >> 1));
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	dbg("PHYS_ADDR: type= %d, y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
+	type, paddr->y, paddr->cb, paddr->cr, ret);
+
+	return ret;
+}
+
+static void fimc_buf_release(struct videobuf_queue *vq,
+				    struct videobuf_buffer *vb)
+{
+	videobuf_dma_contig_free(vq, vb);
+	vb->state = VIDEOBUF_NEEDS_INIT;
+}
+
+static int fimc_buf_setup(struct videobuf_queue *vq, unsigned int *count,
+				unsigned int *size)
+{
+	struct fimc_ctx *ctx = vq->priv_data;
+	struct fimc_frame *frame;
+
+	ctx_m2m_get_frame(frame, ctx, vq->type);
+
+	*size = (frame->width * frame->height * frame->fmt->depth) >> 3;
+	if (0 == *count)
+		*count = 1;
+	return 0;
+}
+
+static int fimc_buf_prepare(struct videobuf_queue *vq,
+		struct videobuf_buffer *vb, enum v4l2_field field)
+{
+	struct fimc_ctx *ctx = vq->priv_data;
+	struct v4l2_device *v4l2_dev = &ctx->fimc_dev->m2m.v4l2_dev;
+	struct fimc_frame *frame;
+	int ret;
+
+	ctx_m2m_get_frame(frame, ctx, vq->type);
+
+	if (vb->baddr) {
+		if (vb->bsize < frame->size) {
+			v4l2_err(v4l2_dev,
+				"User-provided buffer too small (%d < %d)\n",
+				 vb->bsize, frame->size);
+			WARN_ON(1);
+			return -EINVAL;
+		}
+	} else if (vb->state != VIDEOBUF_NEEDS_INIT
+		   && vb->bsize < frame->size) {
+		return -EINVAL;
+	}
+
+	vb->width       = frame->width;
+	vb->height      = frame->height;
+	vb->bytesperline = (frame->width * frame->fmt->depth) >> 3;
+	vb->size        = frame->size;
+	vb->field       = field;
+
+	if (VIDEOBUF_NEEDS_INIT == vb->state) {
+		ret = videobuf_iolock(vq, vb, NULL);
+		if (ret) {
+			v4l2_err(v4l2_dev, "Iolock failed\n");
+			fimc_buf_release(vq, vb);
+			return ret;
+		}
+	}
+	vb->state = VIDEOBUF_PREPARED;
+
+	return 0;
+}
+
+static void fimc_buf_queue(struct videobuf_queue *vq,
+				  struct videobuf_buffer *vb)
+{
+	unsigned long flags;
+	struct fimc_ctx *ctx = vq->priv_data;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+
+	if (ctx->out_path != FIMC_LCDFIFO) {
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
+	} else {
+		/* Queue the buffer and start transaction if required. */
+		spin_lock_irqsave(&ctx->slock, flags);
+		list_add_tail(&vb->queue, &fimc->outp.buf_q);
+		vb->state = VIDEOBUF_QUEUED;
+		spin_unlock_irqrestore(&ctx->slock, flags);
+
+		spin_lock_irqsave(&fimc->slock, flags);
+		if (!test_bit(ST_LCDFIFO_RUN, &fimc->state)) {
+			set_bit(ST_LCDFIFO_PEND, &fimc->state);
+			queue_work(fimc->work_queue, &fimc->outp.work);
+		}
+		spin_unlock_irqrestore(&fimc->slock, flags);
+	}
+}
+
+struct videobuf_queue_ops fimc_qops = {
+	.buf_setup	= fimc_buf_setup,
+	.buf_prepare	= fimc_buf_prepare,
+	.buf_queue	= fimc_buf_queue,
+	.buf_release	= fimc_buf_release,
+};
+
+static int fimc_m2m_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+
+	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->version = KERNEL_VERSION(1, 0, 0);
+	cap->capabilities = V4L2_CAP_STREAMING |
+		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT;
+
+	return 0;
+}
+
+int fimc_m2m_enum_fmt(struct file *file, void *priv, struct v4l2_fmtdesc *f)
+{
+	struct fimc_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(fimc_formats))
+		return -EINVAL;
+
+	fmt = &fimc_formats[f->index];
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int fimc_m2m_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_frame *frame;
+
+	ctx_m2m_get_frame(frame, ctx, f->type);
+
+	f->fmt.pix.width	= frame->width;
+	f->fmt.pix.height	= frame->height;
+	f->fmt.pix.field	= V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat	= frame->fmt->fourcc;
+
+	return 0;
+}
+
+struct fimc_fmt *find_format(struct v4l2_format *f)
+{
+	struct fimc_fmt *fmt;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(fimc_formats); ++i) {
+		fmt = &fimc_formats[i];
+		if (fmt->fourcc == f->fmt.pix.pixelformat)
+			break;
+	}
+	if (i == ARRAY_SIZE(fimc_formats))
+		return NULL;
+
+	return fmt;
+}
+
+static int fimc_m2m_try_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct fimc_fmt *fmt;
+	u32 max_width, max_height, mod_x, mod_y;
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct samsung_fimc_variant *variant = fimc->variant;
+
+	fmt = find_format(f);
+	if (!fmt) {
+		v4l2_err(&fimc->m2m.v4l2_dev,
+			 "Fourcc format (0x%X) invalid.\n",  pix->pixelformat);
+		return -EINVAL;
+	}
+
+	if (pix->field == V4L2_FIELD_ANY)
+		pix->field = V4L2_FIELD_NONE;
+	else if (V4L2_FIELD_NONE != pix->field)
+		return -EINVAL;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		max_width = variant->scaler_dis_w;
+		max_height = variant->scaler_dis_w;
+		mod_x = variant->min_inp_pixsize;
+		mod_y = variant->min_inp_pixsize;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		max_width = variant->out_rot_dis_w;
+		max_height = variant->out_rot_dis_w;
+		mod_x = variant->min_out_pixsize;
+		mod_y = variant->min_out_pixsize;
+	} else {
+		err("Wrong stream type (%d)", f->type);
+		return -EINVAL;
+	}
+
+	dbg("max_w= %d, max_h= %d", max_width, max_height);
+
+	if (pix->height > max_height)
+		pix->height = max_height;
+	if (pix->width > max_width)
+		pix->width = max_width;
+
+	if (tiled_fmt(fmt)) {
+		mod_x = 64; /* 64x32 tile */
+		mod_y = 32;
+	}
+
+	dbg("mod_x= 0x%X, mod_y= 0x%X", mod_x, mod_y);
+
+	pix->width = (pix->width == 0) ? mod_x : ALIGN(pix->width, mod_x);
+	pix->height = (pix->height == 0) ? mod_y : ALIGN(pix->height, mod_y);
+
+	if (pix->bytesperline == 0 ||
+	    pix->bytesperline * 8 / fmt->depth > pix->width)
+		pix->bytesperline = (pix->width * fmt->depth) >> 3;
+
+	if (pix->sizeimage == 0)
+		pix->sizeimage = pix->height * pix->bytesperline;
+
+	dbg("pix->bytesperline= %d, fmt->depth= %d",
+	    pix->bytesperline, fmt->depth);
+
+	return 0;
+}
+
+
+static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct fimc_frame *frame;
+	struct v4l2_pix_format *pix;
+	struct videobuf_queue	*src_vq = NULL,
+				*dst_vq = NULL;
+	struct fimc_ctx *ctx = priv;
+	struct v4l2_device *v4l2_dev = &ctx->fimc_dev->m2m.v4l2_dev;
+	int ret = 0;
+
+	BUG_ON(!ctx);
+
+	ret = fimc_m2m_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+
+	mutex_lock(&ctx->fimc_dev->lock);
+
+	src_vq = v4l2_m2m_get_src_vq(ctx->m2m_ctx);
+	dst_vq = v4l2_m2m_get_dst_vq(ctx->m2m_ctx);
+
+	mutex_lock(&src_vq->vb_lock);
+	mutex_lock(&dst_vq->vb_lock);
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		if (videobuf_queue_is_busy(src_vq)) {
+			v4l2_err(v4l2_dev, "%s queue busy\n", __func__);
+			ret = -EBUSY;
+			goto s_fmt_out;
+		}
+		frame = &ctx->s_frame;
+		ctx->flags |= FIMC_SRC_FMT;
+
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		if (videobuf_queue_is_busy(dst_vq)) {
+			v4l2_err(v4l2_dev, "%s queue busy\n", __func__);
+			ret = -EBUSY;
+			goto s_fmt_out;
+		}
+		frame = &(ctx)->d_frame;
+		ctx->flags |= FIMC_DST_FMT;
+
+	} else {
+		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
+			 "Wrong buffer/video queue type (%d)\n", f->type);
+		return -EINVAL;
+	}
+
+	pix = &f->fmt.pix;
+	frame->fmt = find_format(f);
+	if (!frame->fmt) {
+		ret = -EINVAL;
+		goto s_fmt_out;
+	}
+
+	frame->f_width = pix->bytesperline * 8 / frame->fmt->depth;
+	frame->f_height = pix->sizeimage/pix->bytesperline;
+	frame->width = pix->width;
+	frame->height = pix->height;
+	frame->o_width = pix->width;
+	frame->o_height = pix->height;
+	frame->offs_h = 0;
+	frame->offs_v = 0;
+	frame->size = (pix->width * pix->height * frame->fmt->depth) >> 3;
+	ctx->flags |= FIMC_PARAMS;
+	src_vq->field = dst_vq->field = pix->field;
+
+	dbg("f_width= %d, f_height= %d", frame->f_width, frame->f_height);
+
+s_fmt_out:
+	mutex_unlock(&dst_vq->vb_lock);
+	mutex_unlock(&src_vq->vb_lock);
+	mutex_unlock(&ctx->fimc_dev->lock);
+	return ret;
+}
+
+static int fimc_m2m_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct fimc_ctx *ctx = priv;
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int fimc_m2m_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int fimc_m2m_qbuf(struct file *file, void *priv,
+			  struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+
+	if (!fimc_fifo_active(ctx->fimc_dev))
+		return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+	else
+		return -EBUSY;
+}
+
+static int fimc_m2m_dqbuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int fimc_m2m_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct fimc_ctx *ctx = priv;
+
+	if (!fimc_fifo_active(ctx->fimc_dev))
+		return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+	else
+		return -EBUSY;
+}
+
+static int fimc_m2m_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct fimc_ctx *ctx = priv;
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+int fimc_m2m_queryctrl(struct file *file, void *priv,
+			    struct v4l2_queryctrl *qc)
+{
+	struct v4l2_queryctrl *c;
+	c = get_ctrl(qc->id);
+	if (!c)
+		return -EINVAL;
+	*qc = *c;
+	return 0;
+}
+
+int fimc_m2m_g_ctrl(struct file *file, void *priv,
+			 struct v4l2_control *ctrl)
+{
+	struct fimc_ctx *ctx = priv;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		ctrl->value = (FLIP_X_AXIS & ctx->flip) ? 1 : 0;
+		break;
+	case V4L2_CID_VFLIP:
+		ctrl->value = (FLIP_Y_AXIS & ctx->flip) ? 1 : 0;
+		break;
+	case V4L2_CID_ROTATE:
+		ctrl->value = ctx->rotation;
+		break;
+	default:
+		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+	dbg("ctrl->value= %d", ctrl->value);
+	return 0;
+}
+
+static int check_ctrl_val(struct fimc_ctx *ctx,
+			  struct v4l2_control *ctrl)
+{
+	struct v4l2_queryctrl *c;
+	c = get_ctrl(ctrl->id);
+	if (!c)
+		return -EINVAL;
+
+	if (ctrl->value < c->minimum || ctrl->value > c->maximum
+		|| (c->step != 0 && ctrl->value % c->step != 0)) {
+		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
+		"Invalid control value\n");
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+int fimc_m2m_s_ctrl(struct file *file, void *priv,
+			 struct v4l2_control *ctrl)
+{
+	struct fimc_ctx *ctx = priv;
+	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	int ret = 0;
+
+	ret = check_ctrl_val(ctx, ctrl);
+	if (ret)
+		return ret;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		if (ctx->rotation != 0)
+			return 0;
+		if (ctrl->value)
+			ctx->flip |= FLIP_X_AXIS;
+		else
+			ctx->flip &= ~FLIP_X_AXIS;
+		break;
+
+	case V4L2_CID_VFLIP:
+		if (ctx->rotation != 0)
+			return 0;
+		if (ctrl->value)
+			ctx->flip |= FLIP_Y_AXIS;
+		else
+			ctx->flip &= ~FLIP_Y_AXIS;
+		break;
+
+	case V4L2_CID_ROTATE:
+		if (ctrl->value == 90 || ctrl->value == 270) {
+			if (ctx->out_path == FIMC_LCDFIFO &&
+			    !variant->has_inp_rot) {
+				return -EINVAL;
+			} else if (ctx->in_path == FIMC_DMA &&
+				   !variant->has_out_rot) {
+				return -EINVAL;
+			}
+		}
+		ctx->rotation = ctrl->value;
+		if (ctrl->value == 180)
+			ctx->flip = FLIP_XY_AXIS;
+		break;
+
+	default:
+		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+
+	ctx->flags |= FIMC_PARAMS;
+	return 0;
+}
+
+
+static int fimc_m2m_cropcap(struct file *file, void *fh,
+			     struct v4l2_cropcap *cr)
+{
+	struct fimc_frame *frame;
+	struct fimc_ctx *ctx = fh;
+
+	ctx_m2m_get_frame(frame, ctx, cr->type);
+
+	cr->bounds.left = 0;
+	cr->bounds.top = 0;
+	cr->bounds.width = frame->f_width;
+	cr->bounds.height = frame->f_height;
+	cr->defrect.left = frame->offs_h;
+	cr->defrect.top = frame->offs_v;
+	cr->defrect.width = frame->o_width;
+	cr->defrect.height = frame->o_height;
+	return 0;
+}
+
+static int fimc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct fimc_frame *frame;
+	struct fimc_ctx *ctx = file->private_data;
+
+	ctx_m2m_get_frame(frame, ctx, cr->type);
+
+	cr->c.left = frame->offs_h;
+	cr->c.top = frame->offs_v;
+	cr->c.width = frame->width;
+	cr->c.height = frame->height;
+
+	return 0;
+}
+
+static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_frame *f;
+	u32 min_size;
+	int ret = 0;
+
+	if (cr->c.top < 0 || cr->c.left < 0) {
+		v4l2_err(&fimc->m2m.v4l2_dev,
+			"doesn't support negative values for top & left\n");
+		return -EINVAL;
+	}
+
+	if (cr->c.width  <= 0 || cr->c.height <= 0) {
+		v4l2_err(&fimc->m2m.v4l2_dev,
+			"crop width and height must be greater than 0\n");
+		return -EINVAL;
+	}
+
+	ctx_m2m_get_frame(f, ctx, cr->type);
+
+	dbg("%d %d %d %d f_w= %d, f_h= %d",
+		cr->c.left, cr->c.top, cr->c.width, cr->c.height,
+		f->f_width, f->f_height);
+
+	/* Adjust to required pixel boundary. */
+	min_size = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ?
+		fimc->variant->min_inp_pixsize : fimc->variant->min_out_pixsize;
+
+	cr->c.width = round_down(cr->c.width, min_size);
+	cr->c.height = round_down(cr->c.height, min_size);
+	cr->c.left = round_down(cr->c.left + 1, min_size);
+	cr->c.top = round_down(cr->c.top + 1, min_size);
+
+	if ((cr->c.left + cr->c.width > f->o_width)
+		|| (cr->c.top + cr->c.height > f->o_height)) {
+		v4l2_err(&fimc->m2m.v4l2_dev, "Error in S_CROP params\n");
+		return -EINVAL;
+	}
+
+	if ((ctx->flags & FIMC_SRC_FMT) && (ctx->flags & FIMC_DST_FMT)) {
+		/* Check for the pixel scaling ratio when cropping input img. */
+		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			ret = fimc_check_scaler_ratio(&cr->c, &ctx->d_frame);
+		else if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			ret = fimc_check_scaler_ratio(&cr->c, &ctx->s_frame);
+
+		if (ret) {
+			v4l2_err(&fimc->m2m.v4l2_dev,  "Out of scaler range");
+			return -EINVAL;
+		}
+	}
+
+	f->offs_h = cr->c.left;
+	f->offs_v = cr->c.top;
+	f->width = cr->c.width;
+	f->height = cr->c.height;
+	ctx->flags |= FIMC_PARAMS;
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
+	.vidioc_querycap		= fimc_m2m_querycap,
+
+	.vidioc_enum_fmt_vid_cap	= fimc_m2m_enum_fmt,
+	.vidioc_enum_fmt_vid_out	= fimc_m2m_enum_fmt,
+
+	.vidioc_g_fmt_vid_cap		= fimc_m2m_g_fmt,
+	.vidioc_g_fmt_vid_out		= fimc_m2m_g_fmt,
+
+	.vidioc_try_fmt_vid_cap		= fimc_m2m_try_fmt,
+	.vidioc_try_fmt_vid_out		= fimc_m2m_try_fmt,
+
+	.vidioc_s_fmt_vid_cap		= fimc_m2m_s_fmt,
+	.vidioc_s_fmt_vid_out		= fimc_m2m_s_fmt,
+
+	.vidioc_reqbufs			= fimc_m2m_reqbufs,
+	.vidioc_querybuf		= fimc_m2m_querybuf,
+
+	.vidioc_qbuf			= fimc_m2m_qbuf,
+	.vidioc_dqbuf			= fimc_m2m_dqbuf,
+
+	.vidioc_streamon		= fimc_m2m_streamon,
+	.vidioc_streamoff		= fimc_m2m_streamoff,
+
+	.vidioc_queryctrl		= fimc_m2m_queryctrl,
+	.vidioc_g_ctrl			= fimc_m2m_g_ctrl,
+	.vidioc_s_ctrl			= fimc_m2m_s_ctrl,
+
+	.vidioc_g_crop			= fimc_m2m_g_crop,
+	.vidioc_s_crop			= fimc_m2m_s_crop,
+	.vidioc_cropcap			= fimc_m2m_cropcap
+
+};
+
+static void queue_init(void *priv, struct videobuf_queue *vq,
+		       enum v4l2_buf_type type)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+
+	videobuf_queue_dma_contig_init(vq, &fimc_qops,
+		fimc->m2m.v4l2_dev.dev,
+		&fimc->irqlock, type, V4L2_FIELD_NONE,
+		sizeof(struct fimc_vid_buffer), priv);
+}
+
+static int fimc_m2m_open(struct file *file)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_ctx *ctx = NULL;
+	int err = 0;
+
+	mutex_lock(&fimc->lock);
+	fimc->m2m.refcnt++;
+	set_bit(ST_OUTDMA_RUN, &fimc->state);
+	mutex_unlock(&fimc->lock);
+
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	file->private_data = ctx;
+	ctx->fimc_dev = fimc;
+	/* default format */
+	ctx->s_frame.fmt = &fimc_formats[0];
+	ctx->d_frame.fmt = &fimc_formats[0];
+	/* per user process device context initialization */
+	ctx->flags = 0;
+	ctx->effect.type = S5P_FIMC_EFFECT_ORIGINAL;
+	ctx->in_path = FIMC_DMA;
+	ctx->out_path = FIMC_DMA;
+
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(ctx, fimc->m2m.m2m_dev, queue_init);
+
+	if (IS_ERR(ctx->m2m_ctx)) {
+		err = PTR_ERR(ctx->m2m_ctx);
+		kfree(ctx);
+		return err;
+	}
+
+	return 0;
+}
+
+static int fimc_m2m_release(struct file *file)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	kfree(ctx);
+	mutex_lock(&fimc->lock);
+	if (--fimc->m2m.refcnt <= 0)
+		clear_bit(ST_OUTDMA_RUN, &fimc->state);
+	mutex_unlock(&fimc->lock);
+	return 0;
+}
+
+static unsigned int fimc_m2m_poll(struct file *file,
+				     struct poll_table_struct *wait)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+}
+
+
+static int fimc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+}
+
+static const struct v4l2_file_operations fimc_m2m_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fimc_m2m_open,
+	.release	= fimc_m2m_release,
+	.poll		= fimc_m2m_poll,
+	.ioctl		= video_ioctl2,
+	.mmap		= fimc_m2m_mmap,
+};
+
+static struct v4l2_m2m_ops m2m_ops = {
+	.device_run	= fimc_dma_run,
+	.job_abort	= fimc_job_abort,
+};
+
+
+static int fimc_register_m2m_device(struct fimc_dev *fimc)
+{
+	struct video_device *vfd;
+	struct platform_device *pdev;
+	struct v4l2_device *v4l2_dev;
+	int ret = 0;
+
+	if (!fimc)
+		return -ENODEV;
+
+	pdev = fimc->pdev;
+	v4l2_dev = &fimc->m2m.v4l2_dev;
+
+	/* set name if it is empty */
+	if (!v4l2_dev->name[0])
+		snprintf(v4l2_dev->name, sizeof(v4l2_dev->name),
+			 "%s.%d.v4l2_m2m", MODULE_NAME, fimc->id);
+
+	ret = v4l2_device_register(&pdev->dev, v4l2_dev);
+	if (ret)
+		return ret;;
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(v4l2_dev, "Failed to allocate video device\n");
+		goto err_m2m_r1;
+	}
+
+	vfd->fops	= &fimc_m2m_fops;
+	vfd->ioctl_ops	= &fimc_m2m_ioctl_ops;
+	vfd->minor	= -1;
+	vfd->release	= video_device_release;
+
+	snprintf(vfd->name, sizeof(vfd->name), "%s.%d:v4l2_m2m",
+		 MODULE_NAME, fimc->id);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		v4l2_err(v4l2_dev,
+			 "%s(): failed to register video device\n", __func__);
+		goto err_m2m_r2;
+	}
+	video_set_drvdata(vfd, fimc);
+	fimc->m2m.vfd = vfd;
+	v4l2_info(v4l2_dev,
+		  "FIMC m2m driver registered as /dev/video%d\n", vfd->num);
+
+	platform_set_drvdata(pdev, fimc);
+
+	fimc->m2m.m2m_dev = v4l2_m2m_init(&m2m_ops);
+
+	if (IS_ERR(fimc->m2m.m2m_dev)) {
+		v4l2_err(v4l2_dev, "failed to initialize v4l2-m2m device\n");
+		ret = PTR_ERR(fimc->m2m.m2m_dev);
+		goto err_m2m_r3;
+	}
+	return 0;
+
+err_m2m_r1:
+	v4l2_device_unregister(&fimc->m2m.v4l2_dev);
+err_m2m_r2:
+	video_device_release(fimc->m2m.vfd);
+err_m2m_r3:
+	video_unregister_device(fimc->m2m.vfd);
+
+	return ret;
+}
+
+static void fimc_unregister_m2m_device(struct fimc_dev *fimc)
+{
+	if (fimc) {
+		v4l2_m2m_release(fimc->m2m.m2m_dev);
+		video_unregister_device(fimc->m2m.vfd);
+		video_device_release(fimc->m2m.vfd);
+		v4l2_device_unregister(&fimc->m2m.v4l2_dev);
+	}
+}
+
+static void fimc_clk_release(struct fimc_dev *fimc)
+{
+	int i;
+	for(i = 0; i < NUM_FIMC_CLOCKS; i++) {
+		if(fimc->clock[i]) {
+			clk_disable(fimc->clock[i]);
+			clk_put(fimc->clock[i]);
+		}
+	}
+}
+
+static int fimc_clk_get(struct fimc_dev *fimc)
+{
+	int i;
+	for(i = 0; i < NUM_FIMC_CLOCKS; i++) {
+		fimc->clock[i] = clk_get(&fimc->pdev->dev, fimc_clock_name[i]);
+		if (IS_ERR(fimc->clock[i])) {
+			dev_err(&fimc->pdev->dev,
+				"failed to get fimc clock: %s\n",
+				fimc_clock_name[i]);
+			return -ENXIO;
+		}
+		clk_enable(fimc->clock[i]);
+	}
+	return 0;
+}
+
+static int fimc_probe(struct platform_device *pdev)
+{
+	struct fimc_dev *fimc;
+	struct resource *res;
+	struct samsung_fimc_driverdata *drv_data;
+	int ret = 0;
+
+	dev_dbg(&pdev->dev, "%s():\n", __func__);
+
+	drv_data = (struct samsung_fimc_driverdata *)
+		platform_get_device_id(pdev)->driver_data;
+
+	if (pdev->id >= drv_data->devs_cnt) {
+		dev_err(&pdev->dev, "Invalid platform device id: %d\n",
+			pdev->id);
+		return -EINVAL;
+	}
+
+	fimc = kzalloc(sizeof(struct fimc_dev), GFP_KERNEL);
+	if (!fimc)
+		return -ENOMEM;
+
+	fimc->id = pdev->id;
+	fimc->variant = drv_data->variant[fimc->id];
+	fimc->pdev = pdev;
+	fimc->pdata = pdev->dev.platform_data;
+	fimc->state = ST_IDLE;
+
+	spin_lock_init(&fimc->irqlock);
+	spin_lock_init(&fimc->slock);
+
+	mutex_init(&fimc->lock);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to find the registers\n");
+		ret = -ENOENT;
+		goto err_info;
+	}
+
+	fimc->regs_res = request_mem_region(res->start, resource_size(res),
+			dev_name(&pdev->dev));
+	if (!fimc->regs_res) {
+		dev_err(&pdev->dev, "failed to obtain register region\n");
+		ret = -ENOENT;
+		goto err_info;
+	}
+
+	fimc->regs = ioremap(res->start, resource_size(res));
+	if (!fimc->regs) {
+		dev_err(&pdev->dev, "failed to map registers\n");
+		ret = -ENXIO;
+		goto err_req_region;
+	}
+
+	ret = fimc_clk_get(fimc);
+	if(ret)
+		goto err_regs_unmap;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get IRQ resource\n");
+		ret = -ENXIO;
+		goto err_clk;
+	}
+	fimc->irq = res->start;
+
+	fimc_hw_reset(fimc);
+
+	ret = request_irq(fimc->irq, fimc_isr, 0, pdev->name, fimc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
+		goto err_clk;
+	}
+
+	fimc->work_queue = create_workqueue(dev_name(&fimc->pdev->dev));
+	if (!fimc->work_queue)
+		goto err_irq;
+
+	ret = fimc_register_m2m_device(fimc);
+	if (ret)
+		goto err_wq;
+
+	if (fimc->variant->fifo_capable) {
+		ret = fimc_register_fifo_device(fimc);
+		if (ret)
+			goto err_m2m;
+	}
+
+	fimc_hw_en_lastirq(fimc, 1);
+
+	dev_dbg(&pdev->dev, "%s(): fimc-%d registered successfully\n",
+		__func__, fimc->id);
+
+	return 0;
+
+err_m2m:
+	fimc_unregister_m2m_device(fimc);
+err_wq:
+	destroy_workqueue(fimc->work_queue);
+err_irq:
+	free_irq(fimc->irq, fimc);
+err_clk:
+	fimc_clk_release(fimc);
+err_regs_unmap:
+	iounmap(fimc->regs);
+err_req_region:
+	release_resource(fimc->regs_res);
+	kfree(fimc->regs_res);
+err_info:
+	dev_err(&pdev->dev, "failed to install\n");
+	return ret;
+}
+
+static int __devexit fimc_remove(struct platform_device *pdev)
+{
+	struct fimc_dev *fimc =
+		(struct fimc_dev *)platform_get_drvdata(pdev);
+
+	v4l2_info(&fimc->m2m.v4l2_dev, "Removing %s\n", pdev->name);
+
+	free_irq(fimc->irq, fimc);
+
+	fimc_hw_reset(fimc);
+
+	fimc_unregister_m2m_device(fimc);
+	fimc_unregister_fifo_device(fimc);
+	fimc_clk_release(fimc);
+	iounmap(fimc->regs);
+	release_resource(fimc->regs_res);
+	kfree(fimc->regs_res);
+	kfree(fimc);
+	return 0;
+}
+
+
+static struct samsung_fimc_variant fimc01_variant_s5pc100 = {
+	.has_inp_rot	= 1,
+	.has_out_rot	= 1,
+	.fifo_capable	= 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+
+	.scaler_en_w	= 3264,
+	.scaler_dis_w	= 8192,
+	.in_rot_en_h	= 1920,
+	.in_rot_dis_w	= 8192,
+	.out_rot_en_w	= 1920,
+	.out_rot_dis_w	= 4224,
+};
+
+static struct samsung_fimc_variant fimc2_variant_s5pc100 = {
+	.fifo_capable	 = 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+
+	.scaler_en_w	= 4224,
+	.scaler_dis_w	= 8192,
+	.in_rot_en_h	= 1920,
+	.in_rot_dis_w	= 8192,
+	.out_rot_en_w	= 1920,
+	.out_rot_dis_w	= 4224,
+};
+
+static struct samsung_fimc_variant fimc01_variant_s5pv210 = {
+	.has_inp_rot	= 1,
+	.has_out_rot	= 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 32,
+
+	.scaler_en_w	= 4224,
+	.scaler_dis_w	= 8192,
+	.in_rot_en_h	= 1920,
+	.in_rot_dis_w	= 8192,
+	.out_rot_en_w	= 1920,
+	.out_rot_dis_w	= 4224,
+};
+
+static struct samsung_fimc_variant fimc2_variant_s5pv210 = {
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 32,
+
+	.scaler_en_w	= 1920,
+	.scaler_dis_w	= 8192,
+	.in_rot_en_h	= 1280,
+	.in_rot_dis_w	= 8192,
+	.out_rot_en_w	= 1280,
+	.out_rot_dis_w	= 1920,
+};
+
+static struct samsung_fimc_driverdata fimc_drvdata_s5pc100 = {
+	.variant = {
+		[0] = &fimc01_variant_s5pc100,
+		[1] = &fimc01_variant_s5pc100,
+		[2] = &fimc2_variant_s5pc100,
+	},
+	.devs_cnt = 3
+};
+
+static struct samsung_fimc_driverdata fimc_drvdata_s5pv210 = {
+	.variant = {
+		[0] = &fimc01_variant_s5pv210,
+		[1] = &fimc01_variant_s5pv210,
+		[2] = &fimc2_variant_s5pv210,
+	},
+	.devs_cnt = 3
+};
+
+static struct platform_device_id fimc_driver_ids[] = {
+	{
+		.name		= "s5pc100-fimc",
+		.driver_data	= (unsigned long)&fimc_drvdata_s5pc100,
+	}, {
+		.name		= "s5pv210-fimc",
+		.driver_data	= (unsigned long)&fimc_drvdata_s5pv210,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, s3c_fimc_driver_ids);
+
+static struct platform_driver fimc_driver = {
+	.probe		= fimc_probe,
+	.remove	= __devexit_p(fimc_remove),
+	.id_table	= fimc_driver_ids,
+	.driver = {
+		.name	= MODULE_NAME,
+		.owner	= THIS_MODULE,
+	}
+};
+
+static char banner[] __initdata = KERN_INFO
+	"S5PC Camera Interface V4L2 Driver, (c) 2010 Samsung Electronics\n";
+
+static int __init fimc_init(void)
+{
+	u32 ret;
+	printk(banner);
+
+	ret = platform_driver_register(&fimc_driver);
+	if (ret) {
+		printk(KERN_ERR "FIMC platform driver register failed\n");
+		return -1;
+	}
+	return 0;
+}
+
+static void __exit fimc_exit(void)
+{
+	platform_driver_unregister(&fimc_driver);
+}
+
+module_init(fimc_init);
+module_exit(fimc_exit);
+
+MODULE_AUTHOR("Sylwester Nawrocki, s.nawrocki@samsung.com");
+MODULE_DESCRIPTION("S5PV210 FIMC (video postprocessor) driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/samsung/fimc/fimc-core.h b/drivers/media/video/samsung/fimc/fimc-core.h
new file mode 100644
index 0000000..377c815
--- /dev/null
+++ b/drivers/media/video/samsung/fimc/fimc-core.h
@@ -0,0 +1,541 @@
+/*
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Sylwester Nawrocki, s.nawrocki@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_CORE_H_
+#define FIMC_CORE_H_
+
+#include <linux/types.h>
+#include <plat/fimc.h>
+#include <plat/regs-fimc.h>
+#include <media/videobuf-core.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mem2mem.h>
+#include <linux/videodev2.h>
+
+
+#define err(fmt, args...) \
+	printk(KERN_ERR "%s:%d: " fmt "\n", __func__, __LINE__, ##args)
+
+#ifdef DEBUG
+#define dbg(fmt, args...) \
+	printk(KERN_DEBUG "%s:%d: " fmt "\n", __func__, __LINE__, ##args)
+#else
+#define dbg(fmt, args...)
+#endif
+
+#define ctx_m2m_get_frame(frame, ctx, type) do { \
+	if (V4L2_BUF_TYPE_VIDEO_OUTPUT == (type)) { \
+		frame = &(ctx)->s_frame; \
+	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE == (type)) { \
+		frame = &(ctx)->d_frame; \
+	} else { \
+		v4l2_err(&(ctx)->fimc_dev->m2m.v4l2_dev,\
+			"Wrong buffer/video queue type (%d)\n", type); \
+		return -EINVAL; \
+	} \
+} while (0)
+
+
+/* Time to wait for an interrupt whilst shutting down the lcdfifo mode. */
+#define FIMC_FIFO_SHDWN_TIMEOUT	((100*HZ)/1000)
+#define NUM_FIMC_CLOCKS		2
+#define MODULE_NAME		"s5p-fimc"
+#define FIMC_MAX_DEVS		3
+#define FIMC_MAX_OUT_BUFS	4
+#define SCALER_MAX_HRATIO	64
+#define SCALER_MAX_VRATIO	64
+
+/* The hardware context flags. */
+#define	FIMC_PARAMS		(1 << 0)
+#define	FIMC_SRC_ADDR		(1 << 1)
+#define	FIMC_DST_ADDR		(1 << 2)
+#define	FIMC_SRC_FMT		(1 << 3)
+#define	FIMC_DST_FMT		(1 << 4)
+
+
+enum fimc_dev_flags {
+	ST_IDLE,
+	ST_OUTDMA_RUN,
+	ST_M2M_PEND,
+	ST_LCDFIFO_PEND,
+	ST_LCDFIFO_RUN
+};
+
+#define fimc_m2m_active(dev) test_bit(ST_OUTDMA_RUN, &(dev)->state)
+#define fimc_m2m_pending(dev) test_bit(ST_M2M_PEND, &(dev)->state)
+
+#define fimc_fifo_active(dev) test_bit(ST_LCDFIFO_RUN, &(dev)->state)
+#define fimc_fifo_pending(dev) test_bit(ST_LCDFIFO_PEND, &(dev)->state)
+
+enum fimc_datapath {
+	FIMC_ITU_CAM_A,
+	FIMC_ITU_CAM_B,
+	FIMC_MIPI_CAM,
+	FIMC_DMA,
+	FIMC_LCDFIFO,
+	FIMC_WRITEBACK
+};
+
+enum fimc_color_fmt {
+	S5P_FIMC_RGB565,
+	S5P_FIMC_RGB666,
+	S5P_FIMC_RGB888,
+	S5P_FIMC_YCBCR420,
+	S5P_FIMC_YCBCR422,
+	S5P_FIMC_YCBYCR422,
+	S5P_FIMC_YCRYCB422,
+	S5P_FIMC_CBYCRY422,
+	S5P_FIMC_CRYCBY422,
+	S5P_FIMC_RGB30_LOCAL,
+	S5P_FIMC_YCBCR444_LOCAL,
+	S5P_FIMC_MAX_COLOR = S5P_FIMC_YCBCR444_LOCAL,
+	S5P_FIMC_COLOR_MASK = 0x0F,
+};
+
+/* Y/Cb/Cr components order at DMA output for 1 plane YCbCr 4:2:2 formats. */
+#define	S5P_FIMC_OUT_CRYCBY	S5P_CIOCTRL_ORDER422_CRYCBY
+#define	S5P_FIMC_OUT_CBYCRY	S5P_CIOCTRL_ORDER422_YCRYCB
+#define	S5P_FIMC_OUT_YCRYCB	S5P_CIOCTRL_ORDER422_CBYCRY
+#define	S5P_FIMC_OUT_YCBYCR	S5P_CIOCTRL_ORDER422_YCBYCR
+
+/* Input Y/Cb/Cr components order for 1 plane YCbCr 4:2:2 color formats. */
+#define	S5P_FIMC_IN_CRYCBY	S5P_MSCTRL_ORDER422_CRYCBY
+#define	S5P_FIMC_IN_CBYCRY	S5P_MSCTRL_ORDER422_YCRYCB
+#define	S5P_FIMC_IN_YCRYCB	S5P_MSCTRL_ORDER422_CBYCRY
+#define	S5P_FIMC_IN_YCBYCR	S5P_MSCTRL_ORDER422_YCBYCR
+
+/* Cb/Cr chrominance components order for 2 plane Y/CbCr 4:2:2 formats. */
+#define	S5P_FIMC_LSB_CRCB	S5P_CIOCTRL_ORDER422_2P_LSB_CRCB
+
+/* The embedded image effect selection */
+#define	S5P_FIMC_EFFECT_ORIGINAL	S5P_CIIMGEFF_FIN_BYPASS
+#define	S5P_FIMC_EFFECT_ARBITRARY	S5P_CIIMGEFF_FIN_ARBITRARY
+#define	S5P_FIMC_EFFECT_NEGATIVE	S5P_CIIMGEFF_FIN_NEGATIVE
+#define	S5P_FIMC_EFFECT_ARTFREEZE	S5P_CIIMGEFF_FIN_ARTFREEZE
+#define	S5P_FIMC_EFFECT_EMBOSSING	S5P_CIIMGEFF_FIN_EMBOSSING
+#define	S5P_FIMC_EFFECT_SIKHOUETTE	S5P_CIIMGEFF_FIN_SILHOUETTE
+
+
+/* Definitions for flags field in struct fimc_ctx */
+#define	IN_DMA_ACCESS_LINEAR		0	/* default */
+#define	IN_DMA_ACCESS_TILED		(1 << 0)
+#define	OUT_DMA_ACCESS_LINEAR		(0 << 1)
+#define	OUT_DMA_ACCESS_TILED		(1 << 1)
+#define	SCAN_MODE_PROGRESSIVE		(0 << 2)
+#define	SCAN_MODE_INTERLACED		(1 << 2)
+/* YCbCr data dynamic range selection for the RGB <-> YCBCR color space
+ * conversion. Y/Cb/Cr (0 ~ 255) : Wide default */
+#define	S5P_FIMC_COLOR_RANGE_WIDE	(0 << 3)
+/* Y (16 ~ 235), Cb/Cr (16 ~ 240) : Narrow */
+#define	S5P_FIMC_COLOR_RANGE_NARROW	(1 << 3)
+
+#define	FLIP_NONE			0
+#define	FLIP_X_AXIS			1
+#define	FLIP_Y_AXIS			2
+#define	FLIP_XY_AXIS			(FLIP_X_AXIS | FLIP_Y_AXIS)
+
+/**
+ * struct fimc_fmt - the driver's internal color format data
+ * @name: format description
+ * @fourcc: the fourcc code for this format
+ * @color: the corresponding fimc_color_fmt
+ * @depth: number of bits per pixel
+ * @buff_cnt: number of physically non-contiguous data planes
+ * @planes_cnt: number of physically contiguous data planes
+ */
+struct fimc_fmt {
+	char	*name;
+	u32	fourcc;
+	u32	color;
+	u32	depth;
+	u16	buff_cnt;
+	u16	planes_cnt;
+};
+
+/**
+ * struct fimc_dma_offset - pixel offset information for DMA
+ * @y_h:	y value horizontal offset
+ * @y_v:	y value vertical offset
+ * @cb_h:	cb value horizontal offset
+ * @cb_v:	cb value vertical offset
+ * @cr_h:	cr value horizontal offset
+ * @cr_v:	cr value vertical offset
+ */
+struct fimc_dma_offset {
+	int	y_h;
+	int	y_v;
+	int	cb_h;
+	int	cb_v;
+	int	cr_h;
+	int	cr_v;
+};
+
+/**
+ * struct fimc_effect - the configuration data for the "Arbitrary" image effect
+ * @type:	effect type
+ * @pat_cb:	cr value when type is "arbitrary"
+ * @pat_cr:	cr value when type is "arbitrary"
+ */
+struct fimc_effect {
+	u32	type;
+	u8	pat_cb;
+	u8	pat_cr;
+};
+
+/**
+ * struct fimc_scaler - the configuration data for FIMC inetrnal scaler
+ *
+ * @enabled:		the flag set when the scaler is used
+ * @hfactor:		horizontal shift factor
+ * @vfactor:		vertical shift factor
+ * @pre_hratio:		horizontal ratio of the prescaler
+ * @pre_vratio:		vertical ratio of the prescaler
+ * @pre_dst_width:	the prescaler's destination width
+ * @pre_dst_height:	the prescaler's destination height
+ * @scaleup_h:		flag indicating scaling up horizontally
+ * @scaleup_v:		flag indicating scaling up vertically
+ * @main_hratio:	the main scaler's horizontal ratio
+ * @main_vratio:	the main scaler's vertical ratio
+ * @real_width:		source width - offset
+ * @real_height:	source height - offset
+ * @copy_mode:		flag set if one-to-one mode is used, i.e. no scaling
+ *			and color format conversion
+ */
+struct fimc_scaler {
+	u32	enabled;
+	u32	hfactor;
+	u32	vfactor;
+	u32	pre_hratio;
+	u32	pre_vratio;
+	u32	pre_dst_width;
+	u32	pre_dst_height;
+	u32	scaleup_h;
+	u32	scaleup_v;
+	u32	main_hratio;
+	u32	main_vratio;
+	u32	real_width;
+	u32	real_height;
+	u32	copy_mode;
+};
+
+/**
+ * struct fimc_addr - the FIMC physical address set for DMA
+ *
+ * @y:	 luminance plane physical address
+ * @cb:	 Cb plane physical address
+ * @cr:	 Cr plane physical address
+ */
+struct fimc_addr {
+	u32	y;
+	u32	cb;
+	u32	cr;
+};
+
+/**
+ * struct fimc_vid_buffer - the driver's video buffer
+ * @vb:	v4l videobuf buffer
+ */
+struct fimc_vid_buffer {
+	struct videobuf_buffer	vb;
+};
+
+/**
+ * struct fimc_frame - input/output frame format properties
+ *
+ * @f_width:	image full width (virtual screen size)
+ * @f_height:	image full height (virtual screen size)
+ * @o_width:	original image width as set by S_FMT
+ * @o_height:	original image height as set by S_FMT
+ * @offs_h:	image horizontal pixel offset
+ * @offs_v:	image vertical pixel offset
+ * @width:	image pixel width
+ * @height:	image pixel weight
+ * @paddr:	image frame buffer physical addresses
+ * @buf_cnt:	number of buffers depending on a color format
+ * @size:	image size in bytes
+ * @color:	color format
+ * @dma_offset:	DMA offset in bytes
+ */
+struct fimc_frame {
+	u32	f_width;
+	u32	f_height;
+	u32	o_width;
+	u32	o_height;
+	u32	offs_h;
+	u32	offs_v;
+	u32	width;
+	u32	height;
+	u32	size;
+	struct fimc_addr	paddr;
+	struct fimc_dma_offset	dma_offset;
+	struct fimc_fmt		*fmt;
+};
+
+/**
+ * struct fimc_m2m_device -  v4l2 memory-to-memory device data
+ * @vfd: the video device node for v4l2 m2m mode
+ * @v4l2_dev: v4l2 device for m2m mode
+ * @m2m_dev: v4l2 memory-to-memory device data
+ * @ctx: hardware context data
+ * @refcnt: the reference counter
+ */
+struct fimc_m2m_device {
+	struct video_device	*vfd;
+	struct v4l2_device	v4l2_dev;
+	struct v4l2_m2m_dev	*m2m_dev;
+	struct fimc_ctx		*ctx;
+	int			refcnt;
+};
+
+/**
+ * struct fimc_output_device - v4l2 output device data
+ *
+ * @vfd: the video device node for v4l2 output mode
+ * @v4l2_dev: v4l2 device for managing the subdevices
+ * @m2m_dev: v4l2 memory-to-memory device data
+ * @sd[]: the v4l2 subdevices to control fifo link at framebuffer
+ * @work:
+ * @buf_q: the driver's internal video buffer queue head
+ * @curr_buf: the pointer to curently processed video buffer
+ * @vbq: video buffer queue for v4l2 output stream
+ * @fmt: pixel format information for lcd controller fifo input
+ * @ctx: hardware context data
+ * @refcnt: the reference counter
+ */
+struct fimc_output_device {
+	struct video_device		*vfd;
+	struct v4l2_device		v4l2_dev;
+	struct v4l2_subdev		*sd[FIMC_MAX_FIFO_TARGETS];
+	struct work_struct		work;
+	struct list_head		buf_q;
+	struct fimc_vid_buffer		*curr_buf;
+	struct videobuf_queue		vbq;
+	struct v4l2_format		fmt;
+	struct fimc_ctx			*ctx;
+	int				refcnt;
+};
+
+/**
+ * struct samsung_fimc_variant - camera interface variant information
+ *
+ * @pix_hoff: indicate whether horizontal offset is in pixels or in bytes
+ * @has_inp_rot: set if has input rotator
+ * @has_out_rot: set if has output rotator
+ * @fifo_capable: set if direct local path to lcd controller is supported
+ * @min_inp_pixsize: minimum input pixel size
+ * @min_out_pixsize: minimum output pixel size
+ * @scaler_en_w: maximum input pixel width when the scaler is enabled
+ * @scaler_dis_w: maximum input pixel width when the scaler is disabled
+ * @in_rot_en_h: maximum input width when the input rotator is used
+ * @in_rot_dis_w: maximum input width when the input rotator is used
+ * @out_rot_en_w: maximum output width for the output rotator enabled
+ * @out_rot_dis_w: maximum output width for the output rotator enabled
+ */
+struct samsung_fimc_variant {
+	unsigned int	pix_hoff:1;
+	unsigned int	has_inp_rot:1;
+	unsigned int	has_out_rot:1;
+	unsigned int	fifo_capable:1;
+
+	u16		min_inp_pixsize;
+	u16		min_out_pixsize;
+
+	u16		scaler_en_w;
+	u16		scaler_dis_w;
+	u16		in_rot_en_h;
+	u16		in_rot_dis_w;
+	u16		out_rot_en_w;
+	u16		out_rot_dis_w;
+};
+
+/**
+ * struct samsung_fimc_driverdata - per-device type driver data for init time.
+ *
+ * @variant: the variant information for this driver.
+ * @dev_cnt: number of fimc sub-devices available in SoC
+ */
+struct samsung_fimc_driverdata {
+	struct samsung_fimc_variant *variant[FIMC_MAX_DEVS];
+	int	devs_cnt;
+};
+
+struct fimc_ctx;
+
+/**
+ * struct fimc_subdev - abstraction for a FIMC entity
+ *
+ * @slock:	the spinlock protecting this data structure
+ * @lock:	the mutex protecting this data structure
+ * @pdev:	pointer to the FIMC platform device
+ * @pdata:	pointer to the device platform data
+ * @id:		FIMC device index (0..2)
+ * @clock[]:	the clocks required for FIMC operation
+ * @regs:	the mapped hardware registers
+ * @regs_res:	the resource claimed for IO registers
+ * @irq:	interrupt number of the FIMC subdevice
+ * @irqlock:	spinlock protecting videbuffer queue
+ * @work_queue: the workqueue used to start FIMC in fifo mode
+ * @m2m:	memory-to-memory V4L2 device information
+ * @outp:	V4L2 output device information
+ * @state:	the FIMC device state flags
+ */
+struct fimc_dev {
+	spinlock_t			slock;
+	struct mutex			lock;
+	struct platform_device		*pdev;
+	struct samsung_plat_fimc	*pdata;
+	struct samsung_fimc_variant	*variant;
+	int				id;
+	struct clk			*clock[NUM_FIMC_CLOCKS];
+	void __iomem			*regs;
+	struct resource			*regs_res;
+	int				irq;
+	spinlock_t			irqlock;
+	struct workqueue_struct		*work_queue;
+	struct fimc_m2m_device		m2m;
+	struct fimc_output_device	outp;
+	unsigned long			state;
+};
+
+/**
+ * fimc_ctx - the device context data
+ *
+ * @lock:		mutex protecting this data structure
+ * @s_frame:		source frame properties
+ * @d_frame:		destination frame properties
+ * @out_order_1p:	output 1-plane YCBCR order
+ * @out_order_2p:	output 2-plane YCBCR order
+ * @in_order_1p		input 1-plane YCBCR order
+ * @in_order_2p:	input 2-plane YCBCR order
+ * @in_path:		input mode (DMA or camera)
+ * @out_path:		output mode (DMA or FIFO)
+ * @scaler:		image scaler properties
+ * @effect:		image effect
+ * @rotation:		image clockwise rotation in degrees
+ * @flip:		image flip mode
+ * @updated:		flags to keep track of user configuration sequence
+ * @fimc_dev:		the FIMC device this context applies to
+ * @m2m_ctx:		memory-to-memory device context
+ */
+struct fimc_ctx {
+	spinlock_t		slock;
+	struct fimc_frame	s_frame;
+	struct fimc_frame	d_frame;
+	u32			out_order_1p;
+	u32			out_order_2p;
+	u32			in_order_1p;
+	u32			in_order_2p;
+	enum fimc_datapath	in_path;
+	enum fimc_datapath	out_path;
+	struct fimc_scaler	scaler;
+	struct fimc_effect	effect;
+	int			rotation;
+	u32			flip;
+	u32			flags;
+	struct fimc_dev		*fimc_dev;
+	struct v4l2_m2m_ctx	*m2m_ctx;
+};
+
+
+extern struct fimc_fmt fimc_formats[];
+extern struct videobuf_queue_ops fimc_qops;
+
+static inline int tiled_fmt(struct fimc_fmt *fmt)
+{
+	return 0;
+}
+
+static inline void fimc_hw_clear_irq(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + S5P_CIGCTRL);
+	cfg |= S5P_CIGCTRL_IRQ_CLR;
+	writel(cfg, dev->regs + S5P_CIGCTRL);
+}
+
+static inline void fimc_hw_start_scaler(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
+	cfg |= S5P_CISCCTRL_SCALERSTART;
+	writel(cfg, dev->regs + S5P_CISCCTRL);
+}
+
+static inline void fimc_hw_stop_scaler(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
+	cfg &= ~S5P_CISCCTRL_SCALERSTART;
+	writel(cfg, dev->regs + S5P_CISCCTRL);
+}
+
+static inline void fimc_hw_dis_capture(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + S5P_CIIMGCPT);
+	cfg &= ~(S5P_CIIMGCPT_IMGCPTEN | S5P_CIIMGCPT_IMGCPTEN_SC);
+	writel(cfg, dev->regs + S5P_CIIMGCPT);
+}
+
+static inline void fimc_hw_start_in_dma(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + S5P_MSCTRL);
+	cfg |= S5P_MSCTRL_ENVID;
+	writel(cfg, dev->regs + S5P_MSCTRL);
+}
+
+static inline void fimc_hw_stop_in_dma(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + S5P_MSCTRL);
+	cfg &= ~S5P_MSCTRL_ENVID;
+	writel(cfg, dev->regs + S5P_MSCTRL);
+}
+
+
+/* -----------------------------------------------------*/
+/* fimc-core.c */
+int fimc_set_scaler_info(struct fimc_ctx *ctx);
+struct fimc_fmt *find_format(struct v4l2_format *f);
+int fimc_m2m_enum_fmt(struct file *file, void *priv,
+		      struct v4l2_fmtdesc *f);
+int fimc_m2m_queryctrl(struct file *file, void *priv,
+		       struct v4l2_queryctrl *qc);
+int fimc_m2m_g_ctrl(struct file *file, void *priv,
+		    struct v4l2_control *ctrl);
+int fimc_m2m_s_ctrl(struct file *file, void *priv,
+		    struct v4l2_control *ctrl);
+int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f);
+int fimc_prepare_addr(struct fimc_ctx *ctx,
+	struct fimc_vid_buffer *buf, enum v4l2_buf_type type);
+int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
+
+/* -----------------------------------------------------*/
+/* fimc-fifo.c						*/
+int fimc_register_fifo_device(struct fimc_dev *dev);
+void fimc_unregister_fifo_device(struct fimc_dev *dev);
+
+/* -----------------------------------------------------*/
+/* fimc-reg.c						*/
+int fimc_hw_reset_fifo_ov(struct fimc_dev *dev);
+void fimc_hw_reset(struct fimc_dev *dev);
+void fimc_hw_set_rotation(struct fimc_ctx *ctx);
+void fimc_hw_set_target_format(struct fimc_ctx *ctx);
+void fimc_hw_set_out_dma(struct fimc_ctx *ctx);
+void fimc_hw_en_lastirq(struct fimc_dev *dev, int enable);
+void fimc_hw_en_irq(struct fimc_dev *dev, int enable);
+void fimc_hw_en_autoload(struct fimc_dev *dev, int enable);
+void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
+void fimc_hw_set_scaler(struct fimc_ctx *ctx);
+void fimc_hw_en_capture(struct fimc_ctx *ctx);
+void fimc_hw_set_effect(struct fimc_ctx *ctx);
+void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
+void fimc_hw_set_input_path(struct fimc_ctx *ctx);
+void fimc_hw_set_output_path(struct fimc_ctx *ctx);
+void fimc_hw_set_input_addr(struct fimc_dev *dev, struct fimc_addr *paddr);
+void fimc_hw_set_output_addr(struct fimc_dev *dev, struct fimc_addr *paddr);
+void fimc_hw_shadow_dis(struct fimc_dev *ctx, int off);
+
+#endif /* FIMC_CORE_H_ */
diff --git a/drivers/media/video/samsung/fimc/fimc-fifo.c b/drivers/media/video/samsung/fimc/fimc-fifo.c
new file mode 100644
index 0000000..3917034
--- /dev/null
+++ b/drivers/media/video/samsung/fimc/fimc-fifo.c
@@ -0,0 +1,814 @@
+/*
+ * S5P camera interface (video postprocessor) driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Sylwester Nawrocki, s.nawrocki@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/bug.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+
+#include <linux/fb.h>
+#include <mach/regs-fb.h>
+#include <plat/fb.h>
+#include <plat/fimc.h>
+#include <plat/fifo.h>
+
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf-dma-contig.h>
+
+#include "fimc-core.h"
+
+
+static int fimc_stop_lcdfifo(struct fimc_dev *dev)
+{
+	unsigned long flags;
+	struct fimc_output_device *outp;
+
+	outp = &dev->outp;
+
+	if (fimc_fifo_active(dev) || fimc_fifo_pending(dev)) {
+		flush_workqueue(dev->work_queue);
+
+		/* Disable fifo at frambuffer and fimc side. */
+		v4l2_subdev_call(dev->outp.sd[FIMC_LCD_FIFO_TARGET],
+				 video, s_stream, 0);
+	}
+
+	spin_lock_irqsave(&dev->slock, flags);
+
+	/* Processing of the last buffer in the videobuf queue is never finished
+	   within the interrupt routine, so it needs to be done here.*/
+	if (outp->curr_buf) {
+		spin_lock(&dev->irqlock);
+		outp->curr_buf->vb.state = VIDEOBUF_DONE;
+		spin_unlock(&dev->irqlock);
+
+		wake_up(&outp->curr_buf->vb.done);
+		outp->curr_buf = NULL;
+	}
+	clear_bit(ST_LCDFIFO_RUN, &dev->state);
+	spin_unlock_irqrestore(&dev->slock, flags);
+	return 0;
+}
+
+void fimc_v4l2_dev_notify(struct v4l2_subdev *sd,
+			  unsigned int notification, void *arg)
+{
+	struct fimc_dev *dev = v4l2_get_subdevdata(sd);
+
+	BUG_ON(!dev);
+
+	switch (notification) {
+	case 0:
+		spin_lock(&dev->slock);
+		fimc_hw_en_autoload(dev, false);
+		fimc_hw_dis_capture(dev);
+		fimc_hw_stop_in_dma(dev);
+		fimc_hw_stop_scaler(dev);
+		clear_bit(ST_LCDFIFO_RUN, &dev->state);
+		spin_unlock(&dev->slock);
+		break;
+	default:
+		break;
+	}
+}
+
+static void fimc_fifo_try_run(void *priv)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *f;
+	unsigned long flags;
+
+	BUG_ON(dev->outp.sd[FIMC_LCD_FIFO_TARGET] == NULL);
+
+	f = &ctx->s_frame;
+	dbg("SRC: w= %d, h= %d, f_w= %d, f_h= %d off_h= %d, off_v= %d",
+		f->width, f->height, f->f_width, f->f_height,
+		f->offs_h, f->offs_v);
+
+	f = &ctx->d_frame;
+	dbg("DST: w= %d, h= %d, f_w= %d, f_h= %d off_h= %d, off_v= %d",
+		f->width, f->height, f->f_width, f->f_height,
+		f->offs_h, f->offs_v);
+
+	spin_lock_irqsave(&dev->slock, flags);
+	fimc_hw_set_input_addr(dev, &ctx->s_frame.paddr);
+	spin_unlock_irqrestore(&dev->slock, flags);
+
+	if (ctx->flags & FIMC_PARAMS) {
+		fimc_hw_set_input_path(ctx);
+		fimc_hw_set_in_dma(ctx);
+
+		if (fimc_set_scaler_info(ctx)) {
+			err("scaler configuration failed");
+			return;
+		}
+
+		spin_lock_irqsave(&dev->slock, flags);
+		fimc_hw_set_prescaler(ctx);
+		fimc_hw_set_scaler(ctx);
+		fimc_hw_set_target_format(ctx);
+		fimc_hw_set_rotation(ctx);
+		fimc_hw_set_effect(ctx);
+		spin_unlock_irqrestore(&dev->slock, flags);
+	}
+
+	v4l2_subdev_call(dev->outp.sd[FIMC_LCD_FIFO_TARGET], video,
+			 s_stream, 1);
+
+	spin_lock_irqsave(&dev->slock, flags);
+
+	fimc_hw_set_output_path(ctx);
+	if (ctx->scaler.enabled)
+		fimc_hw_start_scaler(dev);
+
+	fimc_hw_en_capture(ctx);
+	fimc_hw_start_in_dma(dev);
+
+	ctx->flags = 0;
+	spin_unlock_irqrestore(&dev->slock, flags);
+}
+
+static void fimc_worker(struct work_struct *work)
+{
+	int ret;
+	unsigned long flags;
+	struct fimc_output_device *outp =
+		container_of(work, struct fimc_output_device, work);
+	struct fimc_ctx *ctx = outp->ctx;
+	struct fimc_frame *f = &ctx->d_frame;
+	struct fimc_dev *dev;
+	struct v4l2_crop cr;
+
+	BUG_ON(!ctx || !ctx->fimc_dev);
+	dev = ctx->fimc_dev;
+
+	mutex_lock(&dev->lock);
+
+	if (fimc_fifo_active(dev) || list_empty(&outp->buf_q))
+		goto w_unlock;
+
+	/* Get the window parameters from framebuffer to apply its any
+	   aligment requirements. */
+	cr.type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
+	v4l2_subdev_call(outp->sd[FIMC_LCD_FIFO_TARGET],
+			video, g_crop, &cr);
+
+	f->offs_h = cr.c.left;
+	f->offs_v = cr.c.top;
+	f->width = cr.c.width;
+	f->height = cr.c.height;
+
+	ctx->flags &= ~(FIMC_SRC_ADDR | FIMC_DST_ADDR);
+	ret = fimc_prepare_config(ctx, ctx->flags);
+	if (ret)
+		goto w_unlock;
+
+	spin_lock_irqsave(&dev->slock, flags);
+	outp->curr_buf = list_entry(outp->buf_q.next,
+		struct fimc_vid_buffer, vb.queue);
+
+	spin_lock(&dev->irqlock);
+	outp->curr_buf->vb.state = VIDEOBUF_ACTIVE;
+	spin_unlock(&dev->irqlock);
+
+	list_del(&outp->curr_buf->vb.queue);
+	fimc_prepare_addr(ctx, outp->curr_buf,
+				V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	spin_unlock_irqrestore(&dev->slock, flags);
+
+	fimc_fifo_try_run(ctx);
+
+w_unlock:
+	mutex_unlock(&dev->lock);
+}
+
+
+static int fimc_target_osd_sync(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct v4l2_cropcap osd;
+	struct v4l2_rect *r;
+	struct fimc_frame *frame;
+	u32 pix_mod;
+	int ret;
+
+	if (!dev || !dev->outp.sd[FIMC_LCD_FIFO_TARGET])
+		return -EINVAL;
+
+	ret = v4l2_subdev_call(dev->outp.sd[FIMC_LCD_FIFO_TARGET],
+				video, cropcap, &osd);
+	if (ret)
+		return ret;
+
+	pix_mod = dev->variant->min_out_pixsize;
+
+	r = &osd.defrect;
+	r->left = round_down(r->left, pix_mod);
+	r->top = round_down(r->top, pix_mod);
+	r->width = round_down(r->width, pix_mod);
+	r->height = round_down(r->height, pix_mod);
+
+	frame = &ctx->d_frame;
+	frame->f_width = r->width;
+	frame->f_height = r->height;
+	frame->width = r->width;
+	frame->height = r->height;
+	frame->o_width = r->width;
+	frame->o_height = r->height;
+	return 0;
+}
+
+/* Register any framebuffer fifo subdevices if not already registered. */
+static int fimc_register_fb_subdevices(struct fimc_dev *dev)
+{
+	struct s3c_fifo_link *link;
+	int i, ret = 0;
+
+	for (i = 0; i < FIMC_MAX_FIFO_TARGETS; i++) {
+		link = dev->pdata->fifo_targets[i];
+		if (!link)
+			continue;
+		mutex_lock(&link->slave_dev->mutex);
+		if (link->sub_dev) {
+			if (link->sub_dev->v4l2_dev) {
+				mutex_unlock(&link->slave_dev->mutex);
+				continue;
+			}
+			if (!v4l2_device_register_subdev(&dev->outp.v4l2_dev,
+							link->sub_dev)) {
+				v4l2_set_subdevdata(link->sub_dev, dev);
+				dev->outp.sd[i] = link->sub_dev;
+			} else {
+				dev->outp.sd[i] = NULL;
+				mutex_unlock(&link->slave_dev->mutex);
+				v4l2_err(&dev->outp.v4l2_dev,
+					 "Failed to register fb subdevice\n");
+				return -ENODEV;
+			}
+		}
+		mutex_unlock(&link->slave_dev->mutex);
+	}
+	return ret;
+}
+
+/* Unregister fifo target subdevices. */
+static void fimc_unregister_fb_subdevices(struct fimc_dev *dev)
+{
+	int i;
+	struct s3c_fifo_link *link;
+
+	for (i = 0; i < FIMC_MAX_FIFO_TARGETS; i++) {
+		link = dev->pdata->fifo_targets[i];
+		if (!link)
+			continue;
+		mutex_lock(&link->slave_dev->mutex);
+		if (dev->outp.sd[i]) {
+			v4l2_device_unregister_subdev(dev->outp.sd[i]);
+			dev->outp.sd[i] = NULL;
+		}
+		mutex_unlock(&link->slave_dev->mutex);
+	}
+}
+
+static int fimc_open(struct file *file)
+{
+	struct fimc_dev *dev = video_drvdata(file);
+	int ret;
+
+	mutex_lock(&dev->lock);
+
+	dbg("pid: %d, state: 0x%lx, refcnt= %d",
+		task_pid_nr(current), dev->state, dev->outp.refcnt);
+
+	if (dev->outp.refcnt++ == 0) {
+		ret = fimc_register_fb_subdevices(dev);
+		if (ret)
+			goto op_err;
+
+		if (!dev->outp.sd[FIMC_LCD_FIFO_TARGET]) {
+			v4l2_err(&dev->outp.v4l2_dev,
+				 "Lcd fifo subdevice not found\n");
+			ret = -ENODEV;
+			goto op_err;
+		}
+	}
+
+	file->private_data = dev->outp.ctx;
+
+op_err:
+	mutex_unlock(&dev->lock);
+	return ret;
+}
+
+static int fimc_close(struct file *file)
+{
+	struct fimc_dev *dev = video_drvdata(file);
+
+	mutex_lock(&dev->lock);
+
+	dbg("pid: %d, state: 0x%lx, refcnt= %d",
+		task_pid_nr(current), dev->state, dev->outp.refcnt);
+
+	if (--dev->outp.refcnt <= 0) {
+		fimc_stop_lcdfifo(dev);
+		videobuf_stop(&dev->outp.vbq);
+		fimc_unregister_fb_subdevices(dev);
+	}
+	dbg("pid: %d, state: 0x%lx, refcnt= %d",
+		task_pid_nr(current), dev->state, dev->outp.refcnt);
+
+	mutex_unlock(&dev->lock);
+	return 0;
+}
+
+static unsigned int fimc_poll(struct file *file,
+				     struct poll_table_struct *wait)
+{
+	return POLLERR;
+}
+
+static int fimc_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_output_device *outp = &ctx->fimc_dev->outp;
+
+	return videobuf_mmap_mapper(&outp->vbq, vma);
+}
+
+
+static const struct v4l2_file_operations fimc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fimc_open,
+	.release	= fimc_close,
+	.poll		= fimc_poll,
+	.ioctl		= video_ioctl2,
+	.mmap		= fimc_mmap,
+};
+
+static int fimc_querycap_output(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *dev = ctx->fimc_dev;
+
+	strncpy(cap->driver, dev->pdev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, dev->pdev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->version = KERNEL_VERSION(1, 0, 0);
+	cap->capabilities = V4L2_CAP_STREAMING |
+		V4L2_CAP_VIDEO_OVERLAY | V4L2_CAP_VIDEO_OUTPUT;
+
+	return 0;
+}
+
+static int fimc_g_fmt_output(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_frame *frame = &ctx->s_frame;
+
+	f->fmt.pix.width	= frame->width;
+	f->fmt.pix.height	= frame->height;
+	f->fmt.pix.field	= V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat	= frame->fmt->fourcc;
+
+	return 0;
+}
+
+static int fimc_try_fmt_output(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct fimc_fmt *fmt;
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	u32 max_width, max_height;
+	u32 mod_x, mod_y;
+
+	fmt = find_format(f);
+	if (!fmt) {
+		v4l2_err(&dev->outp.v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 pix->pixelformat);
+		return -EINVAL;
+	}
+
+	if (pix->field == V4L2_FIELD_ANY)
+		pix->field = V4L2_FIELD_NONE;
+	else if (V4L2_FIELD_NONE != pix->field)
+		return -EINVAL;
+
+	max_width = dev->variant->scaler_dis_w;
+	max_height = dev->variant->scaler_dis_w;
+	mod_x = dev->variant->min_inp_pixsize;
+	mod_y = mod_x;
+
+
+	if (pix->height > max_height)
+		pix->height = max_height;
+	if (pix->width > max_width)
+		pix->width = max_width;
+
+	if (tiled_fmt(fmt)) {
+		mod_x = 64; /* 64x32 tile */
+		mod_y = 32;
+	}
+
+	pix->width = (pix->width == 0) ? mod_x : ALIGN(pix->width, mod_x);
+	pix->height = (pix->height == 0) ? mod_y : ALIGN(pix->height, mod_y);
+
+	if (pix->bytesperline == 0 ||
+	    pix->bytesperline * 8 / fmt->depth > pix->width)
+		pix->bytesperline = (pix->width * fmt->depth) >> 3;
+
+	if (pix->sizeimage == 0)
+		pix->sizeimage = pix->height * pix->bytesperline;
+
+	dbg("pix->bytesperline= %d, fmt->depth= %d",
+	    pix->bytesperline, fmt->depth);
+
+	return 0;
+}
+
+
+static int fimc_s_fmt_output(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct fimc_frame *frame;
+	struct v4l2_pix_format *pix;
+	struct v4l2_format fmt;
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	int ret;
+
+	BUG_ON(!ctx);
+
+	if (fimc_fifo_active(dev))
+		return -EBUSY;
+
+	ret = fimc_try_fmt_output(file, priv, f);
+	if (ret)
+		return ret;
+
+	mutex_lock(&dev->lock);
+
+	frame = &ctx->s_frame;
+	pix = &f->fmt.pix;
+	frame->fmt = find_format(f);
+	if (!frame->fmt) {
+		mutex_unlock(&dev->lock);
+		return -EINVAL;
+	}
+
+	/* source frame format */
+	frame->f_width = pix->bytesperline * 8 / frame->fmt->depth;
+	frame->f_height = pix->sizeimage / pix->bytesperline;
+	frame->width = pix->width;
+	frame->height = pix->height;
+	frame->o_width = pix->width;
+	frame->o_height = pix->height;
+	frame->offs_h = 0;
+	frame->offs_v = 0;
+	frame->size = (pix->width * pix->height * frame->fmt->depth) >> 3;
+
+	/* FIMC target frame format */
+	fimc_target_osd_sync(ctx);
+
+	fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24;
+	ret = v4l2_subdev_call(dev->outp.sd[FIMC_LCD_FIFO_TARGET],
+			       video, s_fmt, &fmt);
+
+	ctx->flags |= FIMC_PARAMS | FIMC_SRC_FMT;
+	mutex_unlock(&dev->lock);
+	return ret;
+}
+
+static int fimc_streamon_output(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_output_device *outp = &ctx->fimc_dev->outp;
+
+	if (fimc_fifo_active(ctx->fimc_dev))
+		return -EBUSY;
+
+	return videobuf_streamon(&outp->vbq);
+}
+
+static int fimc_streamoff_output(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	unsigned long flags;
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	int ret = 0;
+
+	spin_lock_irqsave(&dev->slock, flags);
+
+	if (!fimc_fifo_active(dev)) {
+		spin_unlock_irqrestore(&dev->slock, flags);
+	} else {
+		spin_unlock_irqrestore(&dev->slock, flags);
+		fimc_stop_lcdfifo(dev);
+		ret = videobuf_streamoff(&dev->outp.vbq);
+	}
+	return ret;
+}
+
+static int fimc_reqbufs_output(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_output_device *outp = &ctx->fimc_dev->outp;
+
+	if (fimc_fifo_active(ctx->fimc_dev))
+		return -EBUSY;
+
+	return videobuf_reqbufs(&outp->vbq, reqbufs);
+}
+
+static int fimc_querybuf_output(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_output_device *outp = &ctx->fimc_dev->outp;
+
+	if (fimc_fifo_active(ctx->fimc_dev))
+		return -EBUSY;
+
+	return videobuf_querybuf(&outp->vbq, buf);
+}
+
+static int fimc_qbuf_output(struct file *file, void *priv,
+			  struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_output_device *outp = &ctx->fimc_dev->outp;
+
+	return videobuf_qbuf(&outp->vbq, buf);
+}
+
+static int fimc_dqbuf_output(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+
+	return videobuf_dqbuf(&ctx->fimc_dev->outp.vbq, buf,
+		file->f_flags & O_NONBLOCK);
+}
+
+static int fimc_cropcap_output(struct file *file, void *fh,
+			     struct v4l2_cropcap *cr)
+{
+	struct fimc_ctx *ctx = fh;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *f = &ctx->s_frame;
+
+	if (cr->type == V4L2_BUF_TYPE_VIDEO_OVERLAY) {
+		return v4l2_subdev_call(dev->outp.sd[FIMC_LCD_FIFO_TARGET],
+					video, cropcap, cr);
+	} else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		cr->bounds.left = 0;
+		cr->bounds.top = 0;
+		cr->bounds.width = f->f_width;
+		cr->bounds.height = f->f_height;
+		cr->defrect.left = f->offs_h;
+		cr->defrect.top = f->offs_v;
+		cr->defrect.width = f->o_width;
+		cr->defrect.height = f->o_height;
+	} else {
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int fimc_g_crop_output(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_frame *f = &ctx->s_frame;
+	struct fimc_dev *dev = ctx->fimc_dev;
+
+	if (cr->type == V4L2_BUF_TYPE_VIDEO_OVERLAY) {
+		return v4l2_subdev_call(dev->outp.sd[FIMC_LCD_FIFO_TARGET],
+					video, g_crop, cr);
+	} else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		cr->c.left = f->offs_h;
+		cr->c.top = f->offs_v;
+		cr->c.width = f->width;
+		cr->c.height = f->height;
+	} else {
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int fimc_s_crop_output(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct fimc_frame *f;
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 pix_mod;
+	int ret = 0;
+
+	if (fimc_fifo_active(dev))
+		return -EBUSY;
+
+	if (cr->c.top < 0 || cr->c.left < 0) {
+		v4l2_err(&dev->outp.v4l2_dev,
+			"doesn't support negative values for top & left\n");
+		return -EINVAL;
+	}
+
+	if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		f = &ctx->s_frame;
+		pix_mod = dev->variant->min_out_pixsize;
+	} else if (cr->type == V4L2_BUF_TYPE_VIDEO_OVERLAY) {
+		f = &ctx->d_frame;
+		pix_mod = dev->variant->min_inp_pixsize;
+	} else {
+		v4l2_err(&ctx->fimc_dev->outp.v4l2_dev,
+			"Wrong buffer/video queue type (%d)\n", cr->type);
+		return -EINVAL;
+	}
+
+	/* Adjust to required pixel boundary. */
+	cr->c.width = ALIGN(cr->c.width, pix_mod);
+	cr->c.height = ALIGN(cr->c.height, pix_mod);
+	cr->c.left = ALIGN(cr->c.left, pix_mod);
+	cr->c.top = ALIGN(cr->c.top, pix_mod);
+
+	dbg("%d %d %d %d f_w= %d, f_h= %d",
+		cr->c.left, cr->c.top, cr->c.width, cr->c.height,
+		f->f_width, f->f_height);
+
+	if ((cr->c.left + cr->c.width > f->o_width)
+		|| (cr->c.top + cr->c.height > f->o_height)) {
+		v4l2_err(&dev->outp.v4l2_dev, "Error in S_CROP params\n");
+		return -EINVAL;
+	}
+
+	if ((ctx->flags & FIMC_SRC_FMT) && (ctx->flags & FIMC_DST_FMT)) {
+		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			ret = fimc_check_scaler_ratio(&cr->c, &ctx->d_frame);
+		else if (cr->type == V4L2_BUF_TYPE_VIDEO_OVERLAY)
+			ret = fimc_check_scaler_ratio(&cr->c, &ctx->s_frame);
+
+		if (ret) {
+			v4l2_err(&dev->outp.v4l2_dev,  "Out of scaler range");
+			return -EINVAL;
+		}
+	}
+
+	f->offs_h = cr->c.left;
+	f->offs_v = cr->c.top;
+	f->width = cr->c.width;
+	f->height = cr->c.height;
+
+	if (cr->type == V4L2_BUF_TYPE_VIDEO_OVERLAY)
+		return v4l2_subdev_call(dev->outp.sd[FIMC_LCD_FIFO_TARGET],
+					video, s_crop, cr);
+	return 0;
+}
+
+
+static const struct v4l2_ioctl_ops fimc_ioctl_ops = {
+	.vidioc_querycap		= fimc_querycap_output,
+
+	.vidioc_enum_fmt_vid_out	= fimc_m2m_enum_fmt,
+	.vidioc_try_fmt_vid_out		= fimc_try_fmt_output,
+	.vidioc_s_fmt_vid_out		= fimc_s_fmt_output,
+	.vidioc_g_fmt_vid_out		= fimc_g_fmt_output,
+
+	.vidioc_reqbufs			= fimc_reqbufs_output,
+	.vidioc_querybuf		= fimc_querybuf_output,
+
+	.vidioc_qbuf			= fimc_qbuf_output,
+	.vidioc_dqbuf			= fimc_dqbuf_output,
+
+	.vidioc_streamon		= fimc_streamon_output,
+	.vidioc_streamoff		= fimc_streamoff_output,
+
+	.vidioc_queryctrl		= fimc_m2m_queryctrl,
+	.vidioc_g_ctrl			= fimc_m2m_g_ctrl,
+	.vidioc_s_ctrl			= fimc_m2m_s_ctrl,
+
+	.vidioc_g_crop			= fimc_g_crop_output,
+	.vidioc_s_crop			= fimc_s_crop_output,
+	.vidioc_cropcap			= fimc_cropcap_output
+};
+
+/* Register FIMC video device for local fifo path mode. */
+int fimc_register_fifo_device(struct fimc_dev *dev)
+{
+	int ret = 0;
+	struct video_device *vfd;
+	struct fimc_ctx *ctx;
+	struct v4l2_device *v4l2_dev = &dev->outp.v4l2_dev;
+
+	if (!v4l2_dev->name[0])
+		snprintf(v4l2_dev->name, sizeof(v4l2_dev->name),
+			 "%s.%d.v4l2_output", MODULE_NAME, dev->id);
+
+	ret = v4l2_device_register(NULL, v4l2_dev);
+	if (ret)
+		goto err_info;
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto err_v4l2_reg;
+	}
+
+	vfd->fops	= &fimc_fops;
+	vfd->ioctl_ops	= &fimc_ioctl_ops;
+	vfd->minor	= -1;
+	vfd->release	= video_device_release;
+	snprintf(vfd->name, sizeof(vfd->name), "%s%d", MODULE_NAME, dev->id);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		v4l2_err(v4l2_dev, "Failed to register video device\n");
+		goto err_vd_reg;
+	}
+	video_set_drvdata(vfd, dev);
+
+	INIT_WORK(&dev->outp.work, fimc_worker);
+
+	dev->outp.vfd = vfd;
+	v4l2_dev->notify = fimc_v4l2_dev_notify;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto err_ctx;
+	}
+	ctx->fimc_dev = dev;
+	/* Defaults to RGB888. */
+	ctx->s_frame.fmt = &fimc_formats[2];
+	ctx->d_frame.fmt = &fimc_formats[2];
+
+	ctx->in_path = FIMC_DMA;
+	ctx->out_path = FIMC_LCDFIFO;
+	ctx->effect.type = S5P_FIMC_EFFECT_ORIGINAL;
+	ctx->flags |= FIMC_DST_FMT;
+	fimc_target_osd_sync(ctx);
+
+	dev->outp.ctx = ctx;
+
+	spin_lock_init(&ctx->slock);
+	INIT_LIST_HEAD(&dev->outp.buf_q);
+
+	/* The video bufer queue for FIMC fifo V4L2 output device. */
+	videobuf_queue_dma_contig_init(&dev->outp.vbq, &fimc_qops,
+		dev->outp.v4l2_dev.dev, &dev->irqlock,
+		V4L2_BUF_TYPE_VIDEO_OUTPUT, V4L2_FIELD_NONE,
+		sizeof(struct fimc_vid_buffer), (void *)ctx);
+
+	dev->outp.fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24;
+	dev->outp.refcnt = 0;
+
+	v4l2_info(v4l2_dev, "FIMC fifo driver registered as /dev/video%d\n",
+		  vfd->num);
+	return 0;
+
+err_ctx:
+	video_unregister_device(dev->outp.vfd);
+err_vd_reg:
+	video_device_release(vfd);
+err_v4l2_reg:
+	v4l2_device_unregister(v4l2_dev);
+err_info:
+	dev_err(&dev->pdev->dev, "failed to install\n");
+	return ret;
+}
+
+void fimc_unregister_fifo_device(struct fimc_dev *dev)
+{
+	if (dev && dev->outp.vfd) {
+		video_unregister_device(dev->outp.vfd);
+		video_device_release(dev->outp.vfd);
+		v4l2_device_unregister(&dev->outp.v4l2_dev);
+		kfree(dev->outp.ctx);
+	}
+}
diff --git a/drivers/media/video/samsung/fimc/fimc-reg.c b/drivers/media/video/samsung/fimc/fimc-reg.c
new file mode 100644
index 0000000..cc4ea68
--- /dev/null
+++ b/drivers/media/video/samsung/fimc/fimc-reg.c
@@ -0,0 +1,585 @@
+/*
+ * Register interface file for Samsung Camera Interface (FIMC) driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Sylwester Nawrocki, s.nawrocki@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <mach/map.h>
+
+#include "fimc-core.h"
+
+
+int fimc_hw_reset_fifo_ov(struct fimc_dev *dev)
+{
+	u32 cfg, status;
+
+	status = readl(dev->regs + S5P_CISTATUS);
+
+	if ((S5P_CISTATUS_OVFIY | S5P_CISTATUS_OVFICB | S5P_CISTATUS_OVFICR)
+		& status) {
+		cfg = readl(dev->regs + S5P_CIWDOFST);
+		cfg |= (S5P_CIWDOFST_CLROVFIY | S5P_CIWDOFST_CLROVFICB
+			| S5P_CIWDOFST_CLROVFICR);
+		writel(cfg, dev->regs + S5P_CIWDOFST);
+
+		cfg = readl(dev->regs + S5P_CIWDOFST);
+		cfg &= ~(S5P_CIWDOFST_CLROVFIY | S5P_CIWDOFST_CLROVFICB
+			| S5P_CIWDOFST_CLROVFICR);
+		writel(cfg, dev->regs + S5P_CIWDOFST);
+	}
+
+	return 0;
+}
+
+void fimc_hw_reset(struct fimc_dev *dev)
+{
+	u32 cfg;
+
+	cfg = readl(dev->regs + S5P_CISRCFMT);
+	cfg |= S5P_CISRCFMT_ITU601_8BIT;
+	writel(cfg, dev->regs + S5P_CISRCFMT);
+
+	/* Software reset. */
+	cfg = readl(dev->regs + S5P_CIGCTRL);
+	cfg |= (S5P_CIGCTRL_SWRST | S5P_CIGCTRL_IRQ_LEVEL);
+	writel(cfg, dev->regs + S5P_CIGCTRL);
+	msleep(1);
+
+	cfg = readl(dev->regs + S5P_CIGCTRL);
+	cfg &= ~S5P_CIGCTRL_SWRST;
+	writel(cfg, dev->regs + S5P_CIGCTRL);
+
+}
+
+void fimc_hw_set_rotation(struct fimc_ctx *ctx)
+{
+	u32 cfg, flip;
+	struct fimc_dev *dev = ctx->fimc_dev;
+
+	cfg = readl(dev->regs + S5P_CITRGFMT);
+	cfg &= ~(S5P_CITRGFMT_INROT90 | S5P_CITRGFMT_OUTROT90);
+
+	flip = readl(dev->regs + S5P_MSCTRL);
+	flip &= ~S5P_MSCTRL_FLIP_MASK;
+
+	/*
+	 * The input and output rotator cannot work simultaneously.
+	 * Use the output rotator in output DMA mode or the input rotator
+	 * in direct fifo output mode.
+	 */
+	if (ctx->rotation == 90 || ctx->rotation == 270) {
+		if (ctx->out_path == FIMC_LCDFIFO) {
+			cfg |= S5P_CITRGFMT_INROT90;
+			if (ctx->rotation == 270)
+				flip |= S5P_MSCTRL_FLIP_180;
+		} else {
+			cfg |= S5P_CITRGFMT_OUTROT90;
+			if (ctx->rotation == 270)
+				cfg |= S5P_CITRGFMT_FLIP_180;
+		}
+	} else if (ctx->rotation == 180) {
+		if (ctx->out_path == FIMC_LCDFIFO)
+			flip |= S5P_MSCTRL_FLIP_180;
+		else
+			cfg |= S5P_CITRGFMT_FLIP_180;
+	}
+	if (ctx->rotation == 180 || ctx->rotation == 270)
+		writel(flip, dev->regs + S5P_MSCTRL);
+	writel(cfg, dev->regs + S5P_CITRGFMT);
+}
+
+static u32 fimc_hw_get_in_flip(u32 ctx_flip)
+{
+	u32 flip = S5P_MSCTRL_FLIP_NORMAL;
+
+	switch (ctx_flip) {
+	case FLIP_X_AXIS:
+		flip = S5P_MSCTRL_FLIP_X_MIRROR;
+		break;
+	case FLIP_Y_AXIS:
+		flip = S5P_MSCTRL_FLIP_Y_MIRROR;
+		break;
+	case FLIP_XY_AXIS:
+		flip = S5P_MSCTRL_FLIP_180;
+		break;
+	}
+
+	return flip;
+}
+
+static u32 fimc_hw_get_target_flip(u32 ctx_flip)
+{
+	u32 flip = S5P_CITRGFMT_FLIP_NORMAL;
+
+	switch (ctx_flip) {
+	case FLIP_X_AXIS:
+		flip = S5P_CITRGFMT_FLIP_X_MIRROR;
+		break;
+	case FLIP_Y_AXIS:
+		flip = S5P_CITRGFMT_FLIP_Y_MIRROR;
+		break;
+	case FLIP_XY_AXIS:
+		flip = S5P_CITRGFMT_FLIP_180;
+		break;
+	case FLIP_NONE:
+		break;
+
+	}
+	return flip;
+}
+
+void fimc_hw_set_target_format(struct fimc_ctx *ctx)
+{
+	u32 cfg;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *frame = &ctx->d_frame;
+
+	dbg("w= %d, h= %d color: %d", frame->width,
+		frame->height, frame->fmt->color);
+
+	cfg = readl(dev->regs + S5P_CITRGFMT);
+	cfg &= ~(S5P_CITRGFMT_OUT_FMT_MASK |
+		  S5P_CITRGFMT_HSIZE_MASK |
+		  S5P_CITRGFMT_VSIZE_MASK);
+
+	switch (frame->fmt->color) {
+	case S5P_FIMC_RGB565:
+	case S5P_FIMC_RGB666:
+	case S5P_FIMC_RGB888:
+		cfg |= S5P_CITRGFMT_OUTFORMAT_RGB;
+		break;
+	case S5P_FIMC_YCBCR420:
+		cfg |= S5P_CITRGFMT_OUTFORMAT_YCBCR420;
+		break;
+	case S5P_FIMC_YCBYCR422:
+	case S5P_FIMC_YCRYCB422:
+	case S5P_FIMC_CBYCRY422:
+	case S5P_FIMC_CRYCBY422:
+		if (frame->fmt->planes_cnt == 1)
+			cfg |= S5P_CITRGFMT_OUTFORMAT_YCBCR422_1PLANE;
+		else
+			cfg |= S5P_CITRGFMT_OUTFORMAT_YCBCR422;
+		break;
+	default:
+		break;
+	}
+
+	cfg |= S5P_CITRGFMT_TARGETHSIZE(frame->width);
+	cfg |= S5P_CITRGFMT_TARGETVSIZE(frame->height);
+
+	if (!ctx->rotation) {
+		cfg &= ~S5P_CITRGFMT_FLIP_MASK;
+		cfg |= fimc_hw_get_target_flip(ctx->flip);
+	}
+	writel(cfg, dev->regs + S5P_CITRGFMT);
+
+	cfg = S5P_CITAREA_TARGET_AREA(frame->width * frame->height);
+	writel(cfg, dev->regs + S5P_CITAREA);
+}
+
+static void fimc_hw_set_out_dma_size(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *frame = &ctx->d_frame;
+	u32 cfg = 0;
+
+	dbg("h= 0x%X  w= 0x%X", frame->f_width, frame->f_height);
+
+	if (ctx->rotation == 90 || ctx->rotation == 270) {
+		cfg |= S5P_ORGOSIZE_HORIZONTAL(frame->f_height);
+		cfg |= S5P_ORGOSIZE_VERTICAL(frame->f_width);
+	} else {
+		cfg |= S5P_ORGOSIZE_HORIZONTAL(frame->f_width);
+		cfg |= S5P_ORGOSIZE_VERTICAL(frame->f_height);
+	}
+	dbg("ORGOSIZE: 0x%X", cfg);
+	writel(cfg, dev->regs + S5P_ORGOSIZE);
+}
+
+void fimc_hw_set_out_dma(struct fimc_ctx *ctx)
+{
+	u32 cfg;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *frame = &ctx->d_frame;
+	struct fimc_dma_offset *offset = &frame->dma_offset;
+
+	/* Set the input dma offsets. */
+	cfg = 0;
+	cfg |= S5P_CIOYOFF_HORIZONTAL(offset->y_h);
+	cfg |= S5P_CIOYOFF_VERTICAL(offset->y_v);
+	writel(cfg, dev->regs + S5P_CIOYOFF);
+
+	cfg = 0;
+	cfg |= S5P_CIOCBOFF_HORIZONTAL(offset->cb_h);
+	cfg |= S5P_CIOCBOFF_VERTICAL(offset->cb_v);
+	writel(cfg, dev->regs + S5P_CIOCBOFF);
+
+	cfg = 0;
+	cfg |= S5P_CIOCROFF_HORIZONTAL(offset->cr_h);
+	cfg |= S5P_CIOCROFF_VERTICAL(offset->cr_v);
+	writel(cfg, dev->regs + S5P_CIOCROFF);
+
+	fimc_hw_set_out_dma_size(ctx);
+
+	/* Configure chroma components order. */
+	cfg = readl(dev->regs + S5P_CIOCTRL);
+
+	cfg &= ~(S5P_CIOCTRL_ORDER2P_MASK | S5P_CIOCTRL_ORDER422_MASK |
+		 S5P_CIOCTRL_YCBCR_PLANE_MASK);
+
+	if (frame->fmt->planes_cnt == 1)
+		cfg |= ctx->out_order_1p;
+	else if (frame->fmt->planes_cnt == 2)
+		cfg |= ctx->out_order_2p | S5P_CIOCTRL_YCBCR_2PLANE;
+	else if (frame->fmt->planes_cnt == 3)
+		cfg |= S5P_CIOCTRL_YCBCR_3PLANE;
+
+	writel(cfg, dev->regs + S5P_CIOCTRL);
+}
+
+void fimc_hw_en_autoload(struct fimc_dev *dev, int enable)
+{
+	u32 cfg = readl(dev->regs + S5P_ORGISIZE);
+	if (enable)
+		cfg |= S5P_CIREAL_ISIZE_AUTOLOAD_ENABLE;
+	else
+		cfg &= ~S5P_CIREAL_ISIZE_AUTOLOAD_ENABLE;
+	writel(cfg, dev->regs + S5P_ORGISIZE);
+}
+
+void fimc_hw_en_lastirq(struct fimc_dev *dev, int enable)
+{
+	unsigned long flags;
+	u32 cfg;
+
+	spin_lock_irqsave(&dev->slock, flags);
+
+	cfg = readl(dev->regs + S5P_CIOCTRL);
+	if (enable)
+		cfg |= S5P_CIOCTRL_LASTIRQ_ENABLE;
+	else
+		cfg &= ~S5P_CIOCTRL_LASTIRQ_ENABLE;
+	writel(cfg, dev->regs + S5P_CIOCTRL);
+
+	spin_unlock_irqrestore(&dev->slock, flags);
+}
+
+void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev =  ctx->fimc_dev;
+	struct fimc_scaler *sc = &ctx->scaler;
+	u32 cfg = 0, shfactor;
+
+	shfactor = 10 - (sc->hfactor + sc->vfactor);
+
+	cfg |= S5P_CISCPRERATIO_SHFACTOR(shfactor);
+	cfg |= S5P_CISCPRERATIO_PREHORRATIO(sc->pre_hratio);
+	cfg |= S5P_CISCPRERATIO_PREVERRATIO(sc->pre_vratio);
+
+	writel(cfg, dev->regs + S5P_CISCPRERATIO);
+
+	cfg = 0;
+	cfg |= S5P_CISCPREDST_PREDSTWIDTH(sc->pre_dst_width);
+	cfg |= S5P_CISCPREDST_PREDSTHEIGHT(sc->pre_dst_height);
+
+	writel(cfg, dev->regs + S5P_CISCPREDST);
+}
+
+void fimc_hw_set_scaler(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_scaler *sc = &ctx->scaler;
+	struct fimc_frame *src_frame = &ctx->s_frame;
+	struct fimc_frame *dst_frame = &ctx->d_frame;
+	u32 cfg;
+
+	if (ctx->flags & S5P_FIMC_COLOR_RANGE_NARROW)
+		cfg = (S5P_CISCCTRL_CSCR2Y_NARROW|S5P_CISCCTRL_CSCY2R_NARROW);
+	else
+		cfg = (S5P_CISCCTRL_CSCR2Y_WIDE|S5P_CISCCTRL_CSCY2R_WIDE);
+
+	if (!sc->enabled)
+		cfg |= S5P_CISCCTRL_SCALERBYPASS;
+
+	if (sc->scaleup_h)
+		cfg |= S5P_CISCCTRL_SCALEUP_H;
+
+	if (sc->scaleup_v)
+		cfg |= S5P_CISCCTRL_SCALEUP_V;
+
+	if (sc->copy_mode)
+		cfg |= S5P_CISCCTRL_ONE2ONE;
+
+
+	if (ctx->in_path == FIMC_DMA) {
+		if (src_frame->fmt->color == S5P_FIMC_RGB565)
+			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB565;
+		else if (src_frame->fmt->color == S5P_FIMC_RGB666)
+			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB666;
+		else if (src_frame->fmt->color == S5P_FIMC_RGB888)
+			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB888;
+	}
+
+	if (ctx->out_path == FIMC_DMA) {
+		if (dst_frame->fmt->color == S5P_FIMC_RGB565)
+			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB565;
+		else if (dst_frame->fmt->color == S5P_FIMC_RGB666)
+			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB666;
+		else if (dst_frame->fmt->color == S5P_FIMC_RGB888)
+			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB888;
+	} else {
+		cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB888;
+
+		if (ctx->flags&SCAN_MODE_INTERLACED)
+			cfg |= S5P_CISCCTRL_INTERLACE;
+		else
+			cfg |= S5P_CISCCTRL_PROGRESSIVE;
+	}
+
+	dbg("main_hratio= 0x%X  main_vratio= 0x%X",
+		sc->main_hratio, sc->main_vratio);
+
+	cfg |= S5P_CISCCTRL_MAINHORRATIO(sc->main_hratio);
+	cfg |= S5P_CISCCTRL_MAINVERRATIO(sc->main_vratio);
+
+	writel(cfg, dev->regs + S5P_CISCCTRL);
+}
+
+
+void fimc_hw_en_capture(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 cfg = readl(dev->regs + S5P_CIIMGCPT);
+
+	if (FIMC_DMA == ctx->out_path) {
+		/* One shot mode. */
+		cfg |= S5P_CIIMGCPT_CPT_FREN_ENABLE | S5P_CIIMGCPT_IMGCPTEN
+			| S5P_CIIMGCPT_CPT_FRMOD_EN;
+	} else {
+		/* Continous frame capture mode (freerun). */
+		cfg &= ~(S5P_CIIMGCPT_CPT_FREN_ENABLE |
+			 S5P_CIIMGCPT_CPT_FRMOD_EN);
+		cfg |= S5P_CIIMGCPT_IMGCPTEN;
+	}
+
+	if (ctx->scaler.enabled)
+		cfg |= S5P_CIIMGCPT_IMGCPTEN_SC;
+
+	writel(cfg, dev->regs + S5P_CIIMGCPT);
+}
+
+void fimc_hw_shadow_dis(struct fimc_dev *dev, int off)
+{
+	u32 cfg = readl(dev->regs + S5P_CIGCTRL);
+	if (off)
+		cfg |= S5P_CIGCTRL_SHDW_DISABLE;
+	else
+		cfg &= ~S5P_CIGCTRL_SHDW_DISABLE;
+	writel(cfg, dev->regs + S5P_CIGCTRL);
+}
+
+
+void fimc_hw_overflow_irq_en(struct fimc_dev *dev, int on)
+{
+	u32 cfg = readl(dev->regs + S5P_CIGCTRL);
+	if (on)
+		cfg |= S5P_CIGCTRL_IRQ_OVFEN;
+	else
+		cfg &= ~S5P_CIGCTRL_IRQ_OVFEN;
+	writel(cfg, dev->regs + S5P_CIGCTRL);
+}
+
+
+void fimc_hw_set_effect(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_effect *effect = &ctx->effect;
+	u32 cfg = (S5P_CIIMGEFF_IE_ENABLE | S5P_CIIMGEFF_IE_SC_AFTER);
+
+	cfg |= effect->type;
+
+	if (effect->type == S5P_FIMC_EFFECT_ARBITRARY) {
+		cfg |= S5P_CIIMGEFF_PAT_CB(effect->pat_cb);
+		cfg |= S5P_CIIMGEFF_PAT_CR(effect->pat_cr);
+	}
+
+	writel(cfg, dev->regs + S5P_CIIMGEFF);
+}
+
+static void fimc_hw_set_in_dma_size(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *frame = &ctx->s_frame;
+	u32 cfg_o = 0;
+	u32 cfg_r = 0;
+
+	if (FIMC_LCDFIFO == ctx->out_path)
+		cfg_r |=  S5P_CIREAL_ISIZE_AUTOLOAD_ENABLE;
+
+	cfg_o |= S5P_ORGISIZE_HORIZONTAL(frame->f_width);
+	cfg_o |= S5P_ORGISIZE_VERTICAL(frame->f_height);
+	cfg_r |= S5P_CIREAL_ISIZE_WIDTH(frame->width);
+	cfg_r |= S5P_CIREAL_ISIZE_HEIGHT(frame->height);
+
+	writel(cfg_o, dev->regs + S5P_ORGISIZE);
+	writel(cfg_r, dev->regs + S5P_CIREAL_ISIZE);
+}
+
+void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *frame = &ctx->s_frame;
+	struct fimc_dma_offset *offset = &frame->dma_offset;
+	u32 cfg = 0;
+
+	/* Set the pixel offsets. */
+	cfg |= S5P_CIIYOFF_HORIZONTAL(offset->y_h);
+	cfg |= S5P_CIIYOFF_VERTICAL(offset->y_v);
+	writel(cfg, dev->regs + S5P_CIIYOFF);
+
+	cfg = 0;
+	cfg |= S5P_CIICBOFF_HORIZONTAL(offset->cb_h);
+	cfg |= S5P_CIICBOFF_VERTICAL(offset->cb_v);
+	writel(cfg, dev->regs + S5P_CIICBOFF);
+
+	cfg = 0;
+	cfg |= S5P_CIICROFF_HORIZONTAL(offset->cr_h);
+	cfg |= S5P_CIICROFF_VERTICAL(offset->cr_v);
+	writel(cfg, dev->regs + S5P_CIICROFF);
+
+	/* Input original and real size. */
+	fimc_hw_set_in_dma_size(ctx);
+
+	/* Autoload is used currently only in FIFO mode. */
+	fimc_hw_en_autoload(dev, ctx->out_path == FIMC_LCDFIFO);
+
+	/* Set the input DMA to process single frame only. */
+	cfg = readl(dev->regs + S5P_MSCTRL);
+	cfg &= ~(S5P_MSCTRL_FLIP_MASK
+		| S5P_MSCTRL_INFORMAT_MASK
+		| S5P_MSCTRL_IN_BURST_COUNT_MASK
+		| S5P_MSCTRL_INPUT_MASK
+		| S5P_MSCTRL_C_INT_IN_MASK
+		| S5P_MSCTRL_2P_IN_ORDER_MASK);
+
+	cfg |= (S5P_MSCTRL_SUCCESSIVE_COUNT(1) | S5P_MSCTRL_INPUT_MEMORY);
+
+	switch (frame->fmt->color) {
+	case S5P_FIMC_RGB565:
+	case S5P_FIMC_RGB666:
+	case S5P_FIMC_RGB888:
+		cfg |= S5P_MSCTRL_INFORMAT_RGB;
+		break;
+	case S5P_FIMC_YCBCR420:
+		cfg |= S5P_MSCTRL_INFORMAT_YCBCR420;
+
+		if (frame->fmt->planes_cnt == 2)
+			cfg |= ctx->in_order_2p | S5P_MSCTRL_C_INT_IN_2PLANE;
+		else
+			cfg |= S5P_MSCTRL_C_INT_IN_3PLANE;
+
+		break;
+	case S5P_FIMC_YCBYCR422:
+	case S5P_FIMC_YCRYCB422:
+	case S5P_FIMC_CBYCRY422:
+	case S5P_FIMC_CRYCBY422:
+		if (frame->fmt->planes_cnt == 1) {
+			cfg |= ctx->in_order_1p
+				| S5P_MSCTRL_INFORMAT_YCBCR422_1PLANE;
+		} else {
+			cfg |= S5P_MSCTRL_INFORMAT_YCBCR422;
+
+			if (frame->fmt->planes_cnt == 2)
+				cfg |= ctx->in_order_2p
+					| S5P_MSCTRL_C_INT_IN_2PLANE;
+			else
+				cfg |= S5P_MSCTRL_C_INT_IN_3PLANE;
+		}
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * Input DMA flip mode (and rotation).
+	 * Do not allow simultaneous rotation and flipping.
+	 */
+	if (!ctx->rotation && ctx->out_path == FIMC_LCDFIFO)
+		cfg |= fimc_hw_get_in_flip(ctx->flip);
+
+	writel(cfg, dev->regs + S5P_MSCTRL);
+
+	/* Input/output DMA linear/tiled mode. */
+	cfg = readl(dev->regs + S5P_CIDMAPARAM);
+	cfg &= ~(S5P_CIDMAPARAM_R_MODE_64X32 | S5P_CIDMAPARAM_W_MODE_64X32);
+
+	if (tiled_fmt(ctx->s_frame.fmt))
+		cfg |= S5P_CIDMAPARAM_R_MODE_64X32;
+
+	if (tiled_fmt(ctx->d_frame.fmt))
+		cfg |= S5P_CIDMAPARAM_W_MODE_64X32;
+
+	writel(cfg, dev->regs + S5P_CIDMAPARAM);
+}
+
+
+void fimc_hw_set_input_path(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+
+	u32 cfg = readl(dev->regs + S5P_MSCTRL);
+	cfg &= ~S5P_MSCTRL_INPUT_MASK;
+
+	if (ctx->in_path == FIMC_DMA)
+		cfg |= S5P_MSCTRL_INPUT_MEMORY;
+	else
+		cfg |= S5P_MSCTRL_INPUT_EXTCAM;
+
+	writel(cfg, dev->regs + S5P_MSCTRL);
+}
+
+void fimc_hw_set_output_path(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+
+	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
+	cfg &= ~S5P_CISCCTRL_LCDPATHEN_FIFO;
+	if (ctx->out_path == FIMC_LCDFIFO)
+		cfg |= S5P_CISCCTRL_LCDPATHEN_FIFO;
+	writel(cfg, dev->regs + S5P_CISCCTRL);
+}
+
+void fimc_hw_set_input_addr(struct fimc_dev *dev, struct fimc_addr *paddr)
+{
+	u32 cfg = 0;
+
+	cfg = readl(dev->regs + S5P_CIREAL_ISIZE);
+	cfg |= S5P_CIREAL_ISIZE_ADDR_CH_DISABLE;
+	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
+
+	writel(paddr->y, dev->regs + S5P_CIIYSA0);
+	writel(paddr->cb, dev->regs + S5P_CIICBSA0);
+	writel(paddr->cr, dev->regs + S5P_CIICRSA0);
+
+	cfg &= ~S5P_CIREAL_ISIZE_ADDR_CH_DISABLE;
+	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
+}
+
+void fimc_hw_set_output_addr(struct fimc_dev *dev, struct fimc_addr *paddr)
+{
+	int i;
+	/* Set all the output register sets to point to single video buffer. */
+	for (i = 0; i < FIMC_MAX_OUT_BUFS; i++) {
+		writel(paddr->y, dev->regs + S5P_CIOYSA(i));
+		writel(paddr->cb, dev->regs + S5P_CIOCBSA(i));
+		writel(paddr->cr, dev->regs + S5P_CIOCRSA(i));
+	}
+}
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 047f7e6..974dc51 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -277,6 +277,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_RGB565  v4l2_fourcc('R', 'G', 'B', 'P') /* 16  RGB-5-6-5     */
 #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B', 'Q') /* 16  RGB-5-5-5 BE  */
 #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B', 'R') /* 16  RGB-5-6-5 BE  */
+#define V4L2_PIX_FMT_RGB666  v4l2_fourcc('R', 'G', 'B', 'H') /* 18  RGB-6-6-6	  */
 #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8     */
 #define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B', '3') /* 24  RGB-8-8-8     */
 #define V4L2_PIX_FMT_BGR32   v4l2_fourcc('B', 'G', 'R', '4') /* 32  BGR-8-8-8-8   */
-- 
1.7.0.4

