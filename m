Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16626 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0EJP4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 11:56:09 -0400
Date: Mon, 10 May 2010 17:55:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 3/3] ARM: Samsung S5P: Add Camera Interface (video
 postprocessor) driver
In-reply-to: <1273506950-25920-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, ben-linux@fluff.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1273506950-25920-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1273506950-25920-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver implements memory to memory (DMA-DMA) operations,
    including color conversion, image resizing, flipping and rotation.

    Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
    Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/Kconfig                  |   18 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/samsung-fimc/Makefile    |    3 +
 drivers/media/video/samsung-fimc/fimc-core.c | 1441 ++++++++++++++++++++++++++
 drivers/media/video/samsung-fimc/fimc-core.h |  345 ++++++
 drivers/media/video/samsung-fimc/fimc-reg.c  |  560 ++++++++++
 include/linux/videodev2.h                    |    1 +
 7 files changed, 2369 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/samsung-fimc/Makefile
 create mode 100644 drivers/media/video/samsung-fimc/fimc-core.c
 create mode 100644 drivers/media/video/samsung-fimc/fimc-core.h
 create mode 100644 drivers/media/video/samsung-fimc/fimc-reg.c

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9a306a6..6c39567 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -953,6 +953,15 @@ config VIDEO_OMAP2
 	---help---
 	  This is a v4l2 driver for the TI OMAP2 camera capture interface
 
+config  VIDEO_SAMSUNG_FIMC
+	tristate "Samsung S5P Camera Interface (video postprocessor) driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	default n
+	help
+	  This is a v4l2 driver the Samsung S5P camera capture interface
+
 #
 # USB Multimedia device configuration
 #
@@ -1134,4 +1143,13 @@ config VIDEO_MEM2MEM_TESTDEV
 	  This is a virtual test device for the memory-to-memory driver
 	  framework.
 
+config  VIDEO_SAMSUNG_FIMC
+	tristate "Samsung S5PV210 Camera Interface (video postprocessor) driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	default n
+	help
+		Samsung S5PV210 camera interface (video postprocessor) driver.
+
 endif # V4L_MEM2MEM_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 2fa3c13..20fe3a8 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -162,6 +162,7 @@ obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
 obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
 obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
+obj-$(CONFIG_VIDEO_SAMSUNG_FIMC) 	+= samsung-fimc/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
diff --git a/drivers/media/video/samsung-fimc/Makefile b/drivers/media/video/samsung-fimc/Makefile
new file mode 100644
index 0000000..7804ebf
--- /dev/null
+++ b/drivers/media/video/samsung-fimc/Makefile
@@ -0,0 +1,3 @@
+
+obj-$(CONFIG_VIDEO_SAMSUNG_FIMC) := samsung-fimc.o
+samsung-fimc-y := fimc-core.o fimc-reg.o
diff --git a/drivers/media/video/samsung-fimc/fimc-core.c b/drivers/media/video/samsung-fimc/fimc-core.c
new file mode 100644
index 0000000..a8556c2
--- /dev/null
+++ b/drivers/media/video/samsung-fimc/fimc-core.c
@@ -0,0 +1,1441 @@
+/* linux/drivers/media/video/samsung-fimc/fimc-core.c
+ *
+ * S5P camera interface (postprocessor) driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Sylwester Nawrocki, s.nawrocki@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/bug.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf-core.h>
+#include <media/videobuf-dma-contig.h>
+
+#include <plat/regs-fimc.h>
+#include "fimc-core.h"
+
+
+static int s5p_fimc_prepare_addr(struct fimc_ctx *ctx,
+	struct fimc_vid_buffer *buf, enum v4l2_buf_type type);
+static void queue_init(void *priv, struct videobuf_queue *vq,
+		       enum v4l2_buf_type type);
+static int s5p_fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
+
+static struct videobuf_queue_ops s5p_fimc_qops;
+
+static struct s5p_fimc_fmt formats[] = {
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
+static struct v4l2_queryctrl s5p_fimc_ctrls[] = {
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
+	for (i = 0; i < ARRAY_SIZE(s5p_fimc_ctrls); ++i)
+		if (id == s5p_fimc_ctrls[i].id)
+			return &s5p_fimc_ctrls[i];
+	return NULL;
+}
+
+static int s5p_fimc_get_scaler_factor(u32 src, u32 tar, u32 *ratio, u32 *shift)
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
+int s5p_fimc_set_scaler_info(struct fimc_ctx *ctx)
+{
+	struct fimc_scaler *sc = &ctx->scaler;
+	struct fimc_dma_offset *d_ofs = &ctx->s_frame.dma_offset;
+	int tx, ty, sx, sy;
+	int width, height, h_ofs, v_ofs;
+	int ret;
+	struct fimc_frame *src_frame = &ctx->s_frame;
+	struct fimc_frame *dst_frame = &ctx->d_frame;
+
+	if (ctx->in_path == S5P_FIMC_DMA) {
+		if ((ctx->rotation == 90 || ctx->rotation == 270)
+			&& ctx->out_path == S5P_FIMC_LCDFIFO) {
+			/* here we are using only the input rotator */
+			width = src_frame->height;
+			height = src_frame->width;
+			h_ofs = d_ofs->y_v;
+			v_ofs = d_ofs->y_h;
+		} else {
+			width = src_frame->width;
+			height = src_frame->height;
+			h_ofs = d_ofs->y_h;
+			v_ofs = d_ofs->y_v;
+		}
+	} else {
+		width = src_frame->width;
+		height = src_frame->height;
+		h_ofs = d_ofs->y_h;
+		v_ofs = d_ofs->y_v;
+	}
+
+	tx = dst_frame->width;
+	ty = dst_frame->height;
+
+	if (tx <= 0 || ty <= 0) {
+		v4l2_err(&ctx->fimc_dev->v4l2_dev,
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
+	ret = s5p_fimc_get_scaler_factor(sx, tx,
+			  &sc->pre_hratio, &sc->hfactor);
+	if (ret)
+		return ret;
+
+	ret = s5p_fimc_get_scaler_factor(sy, ty,
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
+	if (src_frame->fmt->color == dst_frame->fmt->color
+		&& src_frame->width == dst_frame->width
+		&& src_frame->height == dst_frame->height)
+		sc->copy_mode = 1;
+	else
+		sc->copy_mode = 0;
+
+	return 0;
+}
+
+static void s5p_fimc_clear_irq(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + S5P_CIGCTRL);
+	cfg |= S5P_CIGCTRL_IRQ_CLR;
+	writel(cfg, dev->regs + S5P_CIGCTRL);
+}
+
+static irqreturn_t s5p_fimc_isr(int irq, void *priv)
+{
+	struct fimc_ctx *ctx;
+	struct fimc_vid_buffer *src_buf, *dst_buf;
+	struct fimc_dev *dev = priv;
+
+	BUG_ON(!dev);
+
+	s5p_fimc_clear_irq(dev);
+	s5p_fimc_check_fifo(dev);
+
+	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
+	if (!ctx)
+		return IRQ_HANDLED;
+
+	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	spin_lock(&dev->irqlock);
+	src_buf->vb.state = dst_buf->vb.state = VIDEOBUF_DONE;
+	wake_up(&src_buf->vb.done);
+	wake_up(&dst_buf->vb.done);
+	spin_unlock(&dev->irqlock);
+	v4l2_m2m_job_finish(dev->m2m_dev, ctx->m2m_ctx);
+
+	return IRQ_HANDLED;
+}
+
+static void s5p_fimc_dma_run(void *priv)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *frame;
+	u32	ret;
+
+	if (!ctx || ctx->out_path != S5P_FIMC_DMA)
+		return;
+
+	ctx->updated |= S5P_FIMC_SRC_ADDR | S5P_FIMC_DST_ADDR;
+	ret = s5p_fimc_prepare_config(ctx, ctx->updated);
+	if (ret) {
+		err("Wrong configuration");
+		return;
+	}
+
+	frame = &ctx->s_frame;
+	dbg("SRC: width= %d, height= %d, f_width= %d, f_height= %d " \
+		"offs_h= %d, offs_v= %d",
+		frame->width, frame->height,
+		frame->f_width, frame->f_height,
+		frame->offs_h, frame->offs_v);
+
+	frame = &ctx->d_frame;
+	dbg("DST: width= %d, height= %d, f_width= %d, f_height= %d " \
+		"offs_h= %d, offs_v= %d",
+		frame->width, frame->height,
+		frame->f_width, frame->f_height,
+		frame->offs_h, frame->offs_v);
+
+	s5p_fimc_set_input_addr(ctx);
+
+	if (ctx->updated&S5P_FIMC_PARAMS) {
+		s5p_fimc_set_input_path(ctx);
+
+		if (ctx->in_path == S5P_FIMC_DMA)
+			s5p_fimc_set_in_dma(ctx);
+
+		if (s5p_fimc_set_scaler_info(ctx)) {
+			err("scaler configuration error");
+			return;
+		}
+		s5p_fimc_set_prescaler(ctx);
+		s5p_fimc_set_scaler(ctx);
+		s5p_fimc_set_target_format(ctx);
+		s5p_fimc_set_effect(ctx);
+	}
+
+	s5p_fimc_set_output_path(ctx);
+	if (ctx->updated & (S5P_FIMC_DST_ADDR | S5P_FIMC_PARAMS))
+		s5p_fimc_set_output_addr(ctx);
+
+	if (ctx->updated & S5P_FIMC_PARAMS)
+		s5p_fimc_set_out_dma(ctx);
+
+	if (ctx->scaler.enabled)
+		s5p_fimc_start_scaler(ctx);
+
+	s5p_fimc_en_capture(ctx);
+
+	if (ctx->in_path == S5P_FIMC_DMA)
+		s5p_fimc_start_in_dma(dev);
+
+	ctx->updated = 0;
+}
+
+static void s5p_fimc_job_abort(void *priv)
+{
+
+}
+
+/* set order for 1 and 2 plane YCBCR 4:2:2 formats */
+static void s5p_fimc_set_yuv_order(struct fimc_ctx *ctx)
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
+}
+
+/**
+ * Calculate scaling coefficients, check dimensions, operation type
+ * and color mode. Return 0 if dimensions are valid, non zero otherwise.
+ */
+static int s5p_fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
+{
+	struct fimc_frame *src_frame, *dst_frame;
+	struct fimc_vid_buffer *buf = NULL;
+	int ret = 0;
+	u32 tmp;
+
+
+	src_frame = &ctx->s_frame;
+	dst_frame = &ctx->d_frame;
+
+	if (flags & S5P_FIMC_PARAMS) {
+		if ((ctx->out_path == S5P_FIMC_DMA) &&
+			(ctx->rotation == 90 || ctx->rotation == 270)) {
+			tmp = dst_frame->f_width;
+			dst_frame->f_width = dst_frame->f_height;
+			dst_frame->f_height = tmp;
+			tmp = dst_frame->width;
+			dst_frame->width = dst_frame->height;
+			dst_frame->height = tmp;
+		}
+
+		/* prepare the output offset related attributes for scaler */
+		dst_frame->dma_offset.y_h = dst_frame->offs_h
+			 * (dst_frame->fmt->depth >> 3);
+		dst_frame->dma_offset.y_v = dst_frame->offs_v;
+
+		dst_frame->dma_offset.cb_h = dst_frame->offs_h;
+		dst_frame->dma_offset.cb_v = dst_frame->offs_v;
+
+		dst_frame->dma_offset.cr_h = dst_frame->offs_h;
+		dst_frame->dma_offset.cr_v = dst_frame->offs_v;
+
+		if (dst_frame->fmt->planes_cnt == 3) {
+			dst_frame->dma_offset.cb_h /= 2;
+			dst_frame->dma_offset.cb_v /= 2;
+			dst_frame->dma_offset.cr_h /= 2;
+			dst_frame->dma_offset.cr_v /= 2;
+		}
+
+		dbg("OUT OFFSET: color= %d, y_h= %d, y_v= %d",
+			dst_frame->fmt->color,
+			dst_frame->dma_offset.y_h, dst_frame->dma_offset.y_v);
+
+		/* prepare the input offset related attributes for scaler */
+		src_frame->dma_offset.y_h = src_frame->offs_h
+			* (src_frame->fmt->depth >> 3);
+		src_frame->dma_offset.y_v = src_frame->offs_v;
+
+		src_frame->dma_offset.cb_h = src_frame->offs_h;
+		src_frame->dma_offset.cb_v = src_frame->offs_v;
+
+		src_frame->dma_offset.cr_h = src_frame->offs_h;
+		src_frame->dma_offset.cr_v = src_frame->offs_v;
+
+		if (src_frame->fmt->planes_cnt == 3) {
+			src_frame->dma_offset.cb_h /= 2;
+			src_frame->dma_offset.cb_v /= 2;
+			src_frame->dma_offset.cr_h /= 2;
+			src_frame->dma_offset.cr_v /= 2;
+		}
+
+		dbg("IN OFFSET: color= %d, y_h= %d, y_v= %d",
+			src_frame->fmt->color, src_frame->dma_offset.y_h,
+			src_frame->dma_offset.y_v);
+
+		s5p_fimc_set_yuv_order(ctx);
+
+		/* Check against the scaler ratio */
+		if (src_frame->height > SCALER_MAX_VRATIO*dst_frame->height ||
+			src_frame->width > SCALER_MAX_HRATIO*dst_frame->width) {
+				err("Out of the scaler range");
+				return -EINVAL;
+		}
+	} /* if (flags & S5P_FIMC_PARAMS) */
+
+	/* input DMA mode is not allowed when the scaler is disabled */
+	ctx->scaler.enabled = 1;
+
+	if (flags & (S5P_FIMC_SRC_ADDR)) {
+		buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+		ret = s5p_fimc_prepare_addr(ctx, buf,
+			V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		if (ret)
+			return ret;
+	}
+
+	if (flags & (S5P_FIMC_DST_ADDR)) {
+		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+		ret = s5p_fimc_prepare_addr(ctx, buf,
+			V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	}
+
+	return ret;
+}
+
+/* the color format (planes_cnt, buff_cnt) must be already configured */
+static int s5p_fimc_prepare_addr(struct fimc_ctx *ctx,
+		struct fimc_vid_buffer *buf, enum v4l2_buf_type type)
+{
+	int ret = 0;
+	struct fimc_frame *frame;
+	u32 pix_size;
+
+	ctx_get_frame(frame, ctx, type);
+
+	if (!buf)
+		return -EINVAL;
+
+	pix_size = frame->width * frame->height;
+
+	dbg("%d buff_cnt, planes_cnt= %d, frame->size= %d, pix_size= %d",
+		frame->fmt->buff_cnt, frame->fmt->planes_cnt,
+		frame->size, pix_size);
+
+
+	if (frame->fmt->buff_cnt == 1) {
+		frame->addr_y = videobuf_to_dma_contig(&buf->vb);
+		switch (frame->fmt->planes_cnt) {
+		case 1:
+			frame->addr_cb = 0;
+			frame->addr_cr = 0;
+			break;
+		case 2:
+			/* decompose Y into Y/Cb */
+			frame->addr_cb = (u32)(frame->addr_y + pix_size);
+			frame->addr_cr = 0;
+			break;
+		case 3:
+			frame->addr_cb = (u32)(frame->addr_y + pix_size);
+			/* decompose Y into Y/Cb/Cr */
+			if (frame->fmt->color == S5P_FIMC_YCBCR420)
+				frame->addr_cr = (u32)(frame->addr_cb
+						+ (pix_size >> 2));
+			else /* 422 */
+				frame->addr_cr = (u32)(frame->addr_cb
+						+ (pix_size >> 1));
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	dbg("PHYS_ADDR: type= %d, y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
+	type, frame->addr_y, frame->addr_cb, frame->addr_cr, ret);
+
+	return ret;
+}
+
+static void s5p_fimc_buf_release(struct videobuf_queue *vq,
+				    struct videobuf_buffer *vb)
+{
+	videobuf_dma_contig_free(vq, vb);
+	vb->state = VIDEOBUF_NEEDS_INIT;
+}
+
+static int s5p_fimc_buf_setup(struct videobuf_queue *vq, unsigned int *count,
+				unsigned int *size)
+{
+	struct fimc_ctx *ctx = vq->priv_data;
+	struct fimc_frame *frame;
+
+	ctx_get_frame(frame, ctx, vq->type);
+
+	*size = (frame->width * frame->height * frame->fmt->depth) >> 3;
+	if (*count == 0)
+		*count = 1;
+	return 0;
+}
+
+static int s5p_fimc_buf_prepare(struct videobuf_queue *vq,
+				struct videobuf_buffer *vb,
+				enum v4l2_field field)
+{
+	struct fimc_ctx *ctx = vq->priv_data;
+	struct fimc_frame *frame;
+	int ret;
+
+	ctx_get_frame(frame, ctx, vq->type);
+
+	if (vb->baddr) {
+		if (vb->bsize < frame->size) {
+			v4l2_err(&ctx->fimc_dev->v4l2_dev,
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
+	if (vb->state == VIDEOBUF_NEEDS_INIT) {
+		ret = videobuf_iolock(vq, vb, NULL);
+		if (ret) {
+			v4l2_err(&ctx->fimc_dev->v4l2_dev,
+				"Iolock failed\n");
+			goto fail;
+		}
+	}
+	vb->state = VIDEOBUF_PREPARED;
+
+	return 0;
+fail:
+	s5p_fimc_buf_release(vq, vb);
+	return ret;
+}
+
+static void s5p_fimc_buf_queue(struct videobuf_queue *vq,
+				  struct videobuf_buffer *vb)
+{
+	struct fimc_ctx *ctx = vq->priv_data;
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
+}
+
+
+static struct videobuf_queue_ops s5p_fimc_qops = {
+	.buf_setup	= s5p_fimc_buf_setup,
+	.buf_prepare	= s5p_fimc_buf_prepare,
+	.buf_queue	= s5p_fimc_buf_queue,
+	.buf_release	= s5p_fimc_buf_release,
+};
+
+static int s5p_fimc_querycap(struct file *file, void *priv,
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
+		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT;
+
+	return 0;
+}
+
+static int s5p_fimc_enum_fmt(struct file *file, void *priv,
+			   struct v4l2_fmtdesc *f)
+{
+	struct s5p_fimc_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(formats))
+		return -EINVAL;
+
+	fmt = &formats[f->index];
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int s5p_fimc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_frame *frame;
+
+	ctx_get_frame(frame, ctx, f->type);
+
+	f->fmt.pix.width	= frame->width;
+	f->fmt.pix.height	= frame->height;
+	f->fmt.pix.field	= V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat	= frame->fmt->fourcc;
+
+	return 0;
+}
+
+static struct s5p_fimc_fmt *find_format(struct v4l2_format *f)
+{
+	struct s5p_fimc_fmt *fmt;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		fmt = &formats[i];
+		if (fmt->fourcc == f->fmt.pix.pixelformat)
+			break;
+	}
+	if (i == ARRAY_SIZE(formats))
+		return NULL;
+
+	return fmt;
+}
+
+static int s5p_fimc_try_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct s5p_fimc_fmt *fmt;
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	u32 max_width, max_height;
+	u32 mod_x = 1;	/* defaults for non-DMA mode */
+	u32 mod_y = 1;
+
+
+	fmt = find_format(f);
+	if (!fmt) {
+		v4l2_err(&dev->v4l2_dev, "Fourcc format (0x%08x) invalid.\n",
+			 pix->pixelformat);
+		return -EINVAL;
+	}
+
+	if (pix->field == V4L2_FIELD_ANY)
+		pix->field = V4L2_FIELD_NONE;
+	else if (pix->field != V4L2_FIELD_NONE)
+		return -EINVAL;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		max_width = dev->pldata->scaler_dis_w;
+		max_height = dev->pldata->scaler_dis_w;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		max_width = dev->pldata->out_rot_dis_w;
+		max_height = dev->pldata->out_rot_dis_w;
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
+	if (ctx->in_path == S5P_FIMC_DMA
+		|| f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		mod_x = (DMA_MIN_SIZE - 1);
+		mod_y = (DMA_MIN_SIZE - 1);
+	} else {
+		mod_x = 1, mod_y = 1;
+	}
+	dbg("mod_x= 0x%X, mod_y= 0x%X", mod_x, mod_y);
+
+	pix->width &= ~mod_x;
+	pix->height &= ~mod_y;
+	if (!pix->width)
+		pix->width = mod_x + 1;
+	if (!pix->height)
+		pix->height = mod_y + 1;
+
+	if (!pix->bytesperline) {
+		pix->bytesperline = (pix->width * fmt->depth) >> 3;
+	} else {
+		u32 f_width = pix->bytesperline*8/fmt->depth;
+		if (f_width > max_width)
+			pix->bytesperline = (max_width * fmt->depth) >> 3;
+	}
+
+	if (!pix->sizeimage)
+		pix->sizeimage = pix->height * pix->bytesperline;
+
+	dbg("pix->bytesperline= %d, fmt->depth= %d",
+	    pix->bytesperline, fmt->depth);
+
+	return 0;
+}
+
+static int s5p_fimc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct fimc_frame *frame;
+	struct v4l2_pix_format *pix;
+	struct videobuf_queue	*src_vq = NULL,
+				*dst_vq = NULL;
+	struct fimc_ctx *ctx = priv;
+	int ret = 0;
+
+	BUG_ON(!ctx);
+
+	ret = s5p_fimc_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+
+	mutex_lock(&ctx->lock);
+
+	src_vq = v4l2_m2m_get_src_vq(ctx->m2m_ctx);
+	dst_vq = v4l2_m2m_get_dst_vq(ctx->m2m_ctx);
+
+	mutex_lock(&src_vq->vb_lock);
+	mutex_lock(&dst_vq->vb_lock);
+
+	if (videobuf_queue_is_busy(src_vq)) {
+		v4l2_err(&ctx->fimc_dev->v4l2_dev, "%s queue busy\n", __func__);
+		ret = -EBUSY;
+		goto s_fmt_out;
+	}
+
+	if (videobuf_queue_is_busy(dst_vq)) {
+		v4l2_err(&ctx->fimc_dev->v4l2_dev, "%s queue busy\n", __func__);
+		ret = -EBUSY;
+		goto s_fmt_out;
+	}
+
+	ctx_get_frame(frame, ctx, f->type);
+
+	pix = &f->fmt.pix;
+	frame->fmt = find_format(f);
+	if (!frame->fmt) {
+		ret = -EINVAL;
+		goto s_fmt_out;
+	}
+
+	dbg("depth=%d, bytesperline=%d", frame->fmt->depth, pix->bytesperline);
+
+	frame->width = pix->width;
+	frame->height = pix->height;
+
+	frame->f_width = pix->bytesperline*8/frame->fmt->depth;
+	frame->f_height = pix->sizeimage/pix->bytesperline;
+
+	frame->o_width = pix->width;
+	frame->o_height = pix->height;
+	frame->offs_h = 0;
+	frame->offs_v = 0;
+	frame->size = (pix->width * pix->height * frame->fmt->depth) >> 3;
+	ctx->updated |= S5P_FIMC_PARAMS;
+	src_vq->field = dst_vq->field = pix->field;
+
+	dbg("f_width= %d, f_height= %d", frame->f_width, frame->f_height);
+
+s_fmt_out:
+	mutex_unlock(&dst_vq->vb_lock);
+	mutex_unlock(&src_vq->vb_lock);
+	mutex_unlock(&ctx->lock);
+	return ret;
+}
+
+static int s5p_fimc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct fimc_ctx *ctx = priv;
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int s5p_fimc_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int s5p_fimc_qbuf(struct file *file, void *priv,
+			  struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int s5p_fimc_dqbuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int s5p_fimc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct fimc_ctx *ctx = priv;
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int s5p_fimc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct fimc_ctx *ctx = priv;
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+static int s5p_fimc_queryctrl(struct file *file, void *priv,
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
+static int s5p_fimc_g_ctrl(struct file *file, void *priv,
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
+		v4l2_err(&ctx->fimc_dev->v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+	dbg("ctrl->value= %d", ctrl->value);
+
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
+	    || (c->step && (ctrl->value % c->step))) {
+		v4l2_err(&ctx->fimc_dev->v4l2_dev, "Invalid control value\n");
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+static int s5p_fimc_s_ctrl(struct file *file, void *priv,
+			 struct v4l2_control *ctrl)
+{
+	struct fimc_ctx *ctx = priv;
+	struct s5p_platform_fimc *pldata = ctx->fimc_dev->pldata;
+	int ret = 0;
+
+	ret = check_ctrl_val(ctx, ctrl);
+	if (ret)
+		return ret;
+
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		if (ctrl->value)
+			ctx->flip |= FLIP_X_AXIS;
+		else
+			ctx->flip &= ~FLIP_X_AXIS;
+		break;
+
+	case V4L2_CID_VFLIP:
+		if (ctrl->value)
+			ctx->flip |= FLIP_Y_AXIS;
+		else
+			ctx->flip &= ~FLIP_Y_AXIS;
+		break;
+
+	case V4L2_CID_ROTATE:
+		if (ctrl->value == 90 || ctrl->value == 270) {
+			/* use input rotator in LCDFIFO output mode only */
+			if (ctx->out_path == S5P_FIMC_LCDFIFO) {
+				if (!(pldata->capability & S5P_FIMC_IN_ROT))
+					return -EINVAL;
+			} /* in DMA/ out DMA case */
+			else if (ctx->in_path == S5P_FIMC_DMA &&
+				 !(pldata->capability & S5P_FIMC_OUT_ROT))
+				return -EINVAL;
+		}
+
+		ctx->rotation = ctrl->value;
+		if (ctrl->value == 180)
+			ctx->flip = FLIP_XY_AXIS;
+		break;
+
+	default:
+		v4l2_err(&ctx->fimc_dev->v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+
+	ctx->updated |= S5P_FIMC_PARAMS;
+	return 0;
+}
+
+
+static int s5p_fimc_cropcap(struct file *file, void *fh,
+			     struct v4l2_cropcap *cr)
+{
+	struct fimc_frame *frame;
+	struct fimc_ctx *ctx = fh;
+	if (!ctx) {
+		WARN_ON(1);
+		return -ENOENT;
+	}
+
+	ctx_get_frame(frame, ctx, cr->type);
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
+static int s5p_fimc_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct fimc_frame *frame;
+	struct fimc_ctx *ctx = file->private_data;
+
+	if (!ctx) {
+		WARN_ON(1);
+		return -ENOENT;
+	}
+
+	ctx_get_frame(frame, ctx, cr->type);
+
+	cr->c.left = frame->offs_h;
+	cr->c.top = frame->offs_v;
+	cr->c.width = frame->width;
+	cr->c.height = frame->height;
+
+	return 0;
+}
+
+static int s5p_fimc_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct fimc_frame *f;
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *dev = ctx->fimc_dev;
+
+	if (cr->c.top < 0 || cr->c.left < 0) {
+		v4l2_err(&dev->v4l2_dev,
+			"doesn't support negative values for top & left\n");
+		return -EINVAL;
+	}
+
+	ctx_get_frame(f, ctx, cr->type);
+
+	dbg("%d %d %d %d f_w= %d, f_h= %d",
+		cr->c.left, cr->c.top, cr->c.width, cr->c.height,
+		f->f_width, f->f_height);
+
+	/* adjust to pixel boundary */
+	cr->c.width = cr->c.width & ~PIX_ALIGN_MASK;
+	cr->c.height = cr->c.height & ~PIX_ALIGN_MASK;
+	if (!cr->c.width)
+		cr->c.width = DMA_MIN_SIZE;
+	if (!cr->c.height)
+		cr->c.height = DMA_MIN_SIZE;
+	cr->c.left = ((cr->c.left + PIX_ALIGN_MASK - 1) & ~PIX_ALIGN_MASK);
+	cr->c.top = ((cr->c.top + PIX_ALIGN_MASK - 1) & ~PIX_ALIGN_MASK);
+
+	if ((cr->c.left + cr->c.width > f->o_width)
+		|| (cr->c.top + cr->c.height > f->o_height)) {
+		v4l2_err(&dev->v4l2_dev, "Error in S_CROP params\n");
+		dbg("%d %d %d %d. %d %d",
+			cr->c.left, cr->c.top, cr->c.width, cr->c.height,
+			f->o_width, f->o_height);
+		return -EINVAL;
+	}
+
+	/* check for the pixel scaling ratio when cropping input image */
+	if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		if (f->width > (SCALER_MAX_HRATIO*ctx->d_frame.width) ||
+			f->height > (SCALER_MAX_VRATIO*ctx->d_frame.height)) {
+			v4l2_err(&dev->v4l2_dev, "Out of the scaler range");
+			return -EINVAL;
+		}
+	}
+
+	f->offs_h = cr->c.left;
+	f->offs_v = cr->c.top;
+	f->width = cr->c.width;
+	f->height = cr->c.height;
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops s5p_fimc_ioctl_ops = {
+	.vidioc_querycap		= s5p_fimc_querycap,
+
+	.vidioc_enum_fmt_vid_cap	= s5p_fimc_enum_fmt,
+	.vidioc_enum_fmt_vid_out	= s5p_fimc_enum_fmt,
+
+	.vidioc_g_fmt_vid_cap		= s5p_fimc_g_fmt,
+	.vidioc_g_fmt_vid_out		= s5p_fimc_g_fmt,
+
+	.vidioc_try_fmt_vid_cap		= s5p_fimc_try_fmt,
+	.vidioc_try_fmt_vid_out		= s5p_fimc_try_fmt,
+
+	.vidioc_s_fmt_vid_cap		= s5p_fimc_s_fmt,
+	.vidioc_s_fmt_vid_out		= s5p_fimc_s_fmt,
+
+	.vidioc_reqbufs			= s5p_fimc_reqbufs,
+	.vidioc_querybuf		= s5p_fimc_querybuf,
+
+	.vidioc_qbuf			= s5p_fimc_qbuf,
+	.vidioc_dqbuf			= s5p_fimc_dqbuf,
+
+	.vidioc_streamon		= s5p_fimc_streamon,
+	.vidioc_streamoff		= s5p_fimc_streamoff,
+
+	.vidioc_queryctrl		= s5p_fimc_queryctrl,
+	.vidioc_g_ctrl			= s5p_fimc_g_ctrl,
+	.vidioc_s_ctrl			= s5p_fimc_s_ctrl,
+
+	.vidioc_g_crop			= s5p_fimc_g_crop,
+	.vidioc_s_crop			= s5p_fimc_s_crop,
+	.vidioc_cropcap			= s5p_fimc_cropcap
+
+};
+
+static void queue_init(void *priv, struct videobuf_queue *vq,
+		       enum v4l2_buf_type type)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *dev = ctx->fimc_dev;
+
+	videobuf_queue_dma_contig_init(vq, &s5p_fimc_qops, dev->v4l2_dev.dev,
+			&dev->irqlock, type, V4L2_FIELD_NONE,
+			sizeof(struct fimc_vid_buffer), priv);
+}
+
+static int s5p_fimc_open(struct file *file)
+{
+	struct fimc_dev *dev = video_drvdata(file);
+	struct fimc_ctx *ctx = NULL;
+	int err;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	file->private_data = ctx;
+	ctx->fimc_dev = dev;
+	/* default format */
+	ctx->s_frame.fmt = &formats[0];
+	ctx->d_frame.fmt = &formats[0];
+	/* per user process device context initialization */
+	ctx->updated = 0;
+	ctx->effect.type = S5P_FIMC_EFFECT_ORIGINAL;
+	ctx->flags = 0;
+	ctx->in_path = S5P_FIMC_DMA;
+	ctx->out_path = S5P_FIMC_DMA;
+	mutex_init(&ctx->lock);
+
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(ctx, dev->m2m_dev, queue_init);
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
+static int s5p_fimc_release(struct file *file)
+{
+	struct fimc_ctx *ctx =
+		(struct fimc_ctx *)file->private_data;
+
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	kfree(ctx);
+	return 0;
+}
+
+static unsigned int s5p_fimc_poll(struct file *file,
+				     struct poll_table_struct *wait)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+}
+
+
+static int s5p_fimc_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+}
+
+static const struct v4l2_file_operations s5p_fimc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= s5p_fimc_open,
+	.release	= s5p_fimc_release,
+	.poll		= s5p_fimc_poll,
+	.ioctl		= video_ioctl2,
+	.mmap		= s5p_fimc_mmap,
+};
+
+static struct v4l2_m2m_ops m2m_ops = {
+	.device_run	= s5p_fimc_dma_run,
+	.job_abort	= s5p_fimc_job_abort,
+};
+
+
+static int s5p_fimc_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct video_device *vfd;
+	struct fimc_dev *dev;
+	int ret = 0;
+	struct clk *pclk;
+
+
+	if (!pdev->dev.platform_data) {
+		dev_err(&pdev->dev, "platform_data is not set\n");
+		return -ENOENT;
+	}
+
+	dev = kzalloc(sizeof(struct fimc_dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->id = pdev->id;
+	dev->pdev = pdev;
+	dev->pldata = pdev->dev.platform_data;
+
+	spin_lock_init(&dev->irqlock);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to find the registers\n");
+		ret = -ENOENT;
+		goto err_info;
+	}
+
+	dev->regs_res = request_mem_region(res->start, resource_size(res),
+			dev_name(&pdev->dev));
+	if (!dev->regs_res) {
+		dev_err(&pdev->dev, "failed to obtain register region\n");
+		ret = -ENOENT;
+		goto err_info;
+	}
+
+	dev->regs = ioremap(res->start, resource_size(res));
+	if (!dev->regs) {
+		dev_err(&pdev->dev, "failed to map registers\n");
+		ret = -ENXIO;
+		goto err_req_region;
+	}
+
+	/* FIMC parent clock */
+	pclk = clk_get(&pdev->dev, dev->pldata->srclk_name);
+	if (IS_ERR(pclk)) {
+		dev_err(&pdev->dev, "failed to get source clock of fimc\n");
+		goto err_regs_unmap;
+	}
+
+	/* FIMC clock */
+	dev->clock = clk_get(&pdev->dev, "fimc");
+	if (IS_ERR(dev->clock)) {
+		dev_err(&pdev->dev, "failed to get fimc clock source\n");
+		goto err_clk2;
+	}
+
+	ret = clk_set_parent(dev->clock, pclk);
+	if (ret)
+		goto err_clk;
+
+	/* set FIMC local clock rate */
+	clk_set_rate(dev->clock, dev->pldata->clockrate);
+	clk_enable(dev->clock);
+	clk_put(pclk);
+
+	/* IRQ */
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get IRQ resource\n");
+		ret = -ENXIO;
+		goto err_clk;
+	}
+	dev->irq = res->start;
+
+	s5p_fimc_reset(dev);
+
+	ret = request_irq(dev->irq, s5p_fimc_isr, 0, pdev->name, dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
+		goto err_clk;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		goto err_irq;
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		goto err_unreg_dev;
+	}
+
+	if ((u32)dev->id >= MAX_FIMC_DEVICES)
+		goto err_unreg_dev;
+
+	vfd->fops	= &s5p_fimc_fops;
+	vfd->ioctl_ops	= &s5p_fimc_ioctl_ops;
+	vfd->minor	= -1;
+	vfd->release	= video_device_release;
+
+	snprintf(vfd->name, sizeof(vfd->name), "%s%d", MODULE_NAME, dev->id);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto err_rel_vdev;
+	}
+	video_set_drvdata(vfd, dev);
+	dev->vfd = vfd;
+	v4l2_info(&dev->v4l2_dev, "Device registered as /dev/video%d\n",
+		vfd->num);
+
+	platform_set_drvdata(pdev, dev);
+	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
+	if (IS_ERR(dev->m2m_dev)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
+		ret = PTR_ERR(dev->m2m_dev);
+		goto err_m2m;
+	}
+
+	s5p_fimc_en_lastirq(dev, 1);
+
+	return 0;
+
+err_m2m:
+	video_unregister_device(dev->vfd);
+err_rel_vdev:
+	video_device_release(vfd);
+err_unreg_dev:
+	v4l2_device_unregister(&dev->v4l2_dev);
+err_irq:
+	free_irq(dev->irq, dev);
+err_clk:
+	clk_disable(dev->clock);
+	clk_put(dev->clock);
+err_clk2:
+	clk_put(pclk);
+err_regs_unmap:
+	iounmap(dev->regs);
+err_req_region:
+	release_resource(dev->regs_res);
+	kfree(dev->regs_res);
+err_info:
+	dev_err(&pdev->dev, "failed to install\n");
+	return ret;
+}
+
+static int __devexit s5p_fimc_remove(struct platform_device *pdev)
+{
+	struct fimc_dev *dev = platform_get_drvdata(pdev);
+
+	v4l2_info(&dev->v4l2_dev, "Removing %s\n", pdev->name);
+
+	free_irq(dev->irq, dev);
+
+	s5p_fimc_reset(dev);
+	v4l2_m2m_release(dev->m2m_dev);
+	video_unregister_device(dev->vfd);
+	v4l2_device_unregister(&dev->v4l2_dev);
+
+	iounmap(dev->regs);
+	release_resource(dev->regs_res);
+	kfree(dev->regs_res);
+	kfree(dev);
+	return 0;
+}
+
+static struct platform_driver s5p_fimc_driver = {
+	.probe = s5p_fimc_probe,
+	.remove = __devexit_p(s5p_fimc_remove),
+	.driver = {
+		.name = "s5p-fimc",
+		.owner = THIS_MODULE,
+	}
+};
+
+static char banner[] __initdata = KERN_INFO \
+	"S5P Camera Interface V4L2 Driver, (c) 2010 Samsung Electronics\n";
+
+static int __init s5p_fimc_init(void)
+{
+	u32 ret;
+	printk(banner);
+
+	ret = platform_driver_register(&s5p_fimc_driver);
+	if (ret)
+		printk(KERN_ERR "FIMC platform driver register failed\n");
+	return ret;
+}
+
+static void __exit s5p_fimc_exit(void)
+{
+	platform_driver_unregister(&s5p_fimc_driver);
+}
+
+module_init(s5p_fimc_init);
+module_exit(s5p_fimc_exit);
+
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+MODULE_DESCRIPTION("S5P FIMC (video postprocessor) driver");
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/media/video/samsung-fimc/fimc-core.h b/drivers/media/video/samsung-fimc/fimc-core.h
new file mode 100644
index 0000000..7cfb24c
--- /dev/null
+++ b/drivers/media/video/samsung-fimc/fimc-core.h
@@ -0,0 +1,345 @@
+/*
+ * drivers/media/video/samsung-fimc/fimc-core.h
+ *
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
+
+#define ctx_get_frame(frame, ctx, type) do {			\
+	if (V4L2_BUF_TYPE_VIDEO_OUTPUT == (type))		\
+		frame = &(ctx)->s_frame;			\
+	else if (V4L2_BUF_TYPE_VIDEO_CAPTURE == (type))		\
+		frame = &(ctx)->d_frame;			\
+	else {							\
+		v4l2_err(&(ctx)->fimc_dev->v4l2_dev,		\
+		 "Wrong buffer/video queue type (%d)\n", type); \
+		return -EINVAL;					\
+	}							\
+} while (0)
+
+
+#define MODULE_NAME		"s5p-fimc"
+#define MAX_FIMC_DEVICES	3
+#define S5P_FIMC_MAX_FRAMES	4
+#define DMA_MIN_SIZE		16
+#define SCALER_MAX_HRATIO	64
+#define SCALER_MAX_VRATIO	64
+#define PIX_ALIGN_MASK		(DMA_MIN_SIZE - 1)
+
+#define	S5P_FIMC_CHANGED_NONE	0
+#define	S5P_FIMC_PARAMS		(1 << 0)
+#define	S5P_FIMC_SRC_ADDR	(1 << 1)
+#define	S5P_FIMC_DST_ADDR	(1 << 2)
+
+
+enum fimc_datapath {
+	S5P_FIMC_ITU_CAM_A,
+	S5P_FIMC_ITU_CAM_B,
+	S5P_FIMC_MIPI_CAM,
+	S5P_FIMC_DMA,
+	S5P_FIMC_LCDFIFO,
+	S5P_FIMC_WRITEBACK
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
+/* Y/Cb/Cr components order at DMA output for 1 plane YCbCr 4:2:2 formats */
+#define	S5P_FIMC_OUT_CRYCBY	S5P_CIOCTRL_ORDER422_CRYCBY
+#define	S5P_FIMC_OUT_CBYCRY	S5P_CIOCTRL_ORDER422_YCRYCB
+#define	S5P_FIMC_OUT_YCRYCB	S5P_CIOCTRL_ORDER422_CBYCRY
+#define	S5P_FIMC_OUT_YCBYCR	S5P_CIOCTRL_ORDER422_YCBYCR
+
+/* Input Y/Cb/Cr components order for 1 plane YCbCr 4:2:2 color formats */
+#define	S5P_FIMC_IN_CRYCBY	S5P_MSCTRL_ORDER422_CRYCBY
+#define	S5P_FIMC_IN_CBYCRY	S5P_MSCTRL_ORDER422_YCRYCB
+#define	S5P_FIMC_IN_YCRYCB	S5P_MSCTRL_ORDER422_CBYCRY
+#define	S5P_FIMC_IN_YCBYCR	S5P_MSCTRL_ORDER422_YCBYCR
+
+/* Cb/Cr chrominance components order for 2 plane Y/CbCr 4:2:2 formats */
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
+#define	FLIP_ORIGINAL	0
+#define	FLIP_X_AXIS	0x01
+#define	FLIP_Y_AXIS	0x02
+#define	FLIP_XY_AXIS	(FLIP_X_AXIS | FLIP_Y_AXIS)
+
+/**
+ * struct fimc_dma_offset
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
+ * struct s5p_fimc_effect
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
+ * struct fimc_scaler
+ * @enabled:		flag indicating whether the scaler is used or not
+ * @hfactor:		horizontal shift factor
+ * @vfactor:		vertical shift factor
+ * @pre_hratio:		prescaler horizontal ratio
+ * @pre_vratio:		prescaler vertical ratio
+ * @pre_dst_width:	prescaler destination width
+ * @pre_dst_height:	pre-scaler destination height
+ * @scaleup_h:		flag indicating scaling up horizontally
+ * @scaleup_v:		flag indicating scaling up vertically
+ * @main_hratio:	main scaler horizontal ratio
+ * @main_vratio:	main scaler vertical ratio
+ * @real_width:		src_width - offset
+ * @real_height:	src_height - offset
+ * @copy_mode:		flag indicating one to one mode, i.e. no scaling
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
+ * struct fimc_frame - input/output frame format properties
+ * @f_width:	image full width (virtual screen size)
+ * @f_height:	image full height (virtual screen size)
+ * @o_width:	original image width as set by S_FMT
+ * @o_height:	original image height as set by S_FMT
+ * @offs_h:	image horizontal pixel offset
+ * @offs_v:	image vertical pixel offset
+ * @width:	image pixel width
+ * @height:	image pixel weight
+ * @addr_y:	RGB/Y physical address
+ * @addr_cb:	CB physical address
+ * @addr_cr:	CR physical addres
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
+	u32	addr_y;
+	u32	addr_cb;
+	u32	addr_cr;
+	u32	size;
+	struct fimc_dma_offset	dma_offset;
+	struct s5p_fimc_fmt	*fmt;
+};
+
+
+struct fimc_vid_buffer {
+	struct videobuf_buffer	vb;
+	int	index;
+};
+
+struct s5p_fimc_fmt {
+	char	*name;
+	u32	fourcc;
+	u32	color;
+	u32	depth;
+	/* Number of data planes used */
+	u16	buff_cnt;
+	u16	planes_cnt;
+};
+
+struct fimc_ctx;
+
+/**
+ * struct fimc_subdev: abstraction for a FIMC entity
+ * @pdev:	a pointer to the FIMC platform device
+ * @pldata:	a pointer to the device platform data
+ * @id:		the FIMC device index (0..2)
+ * @clock:
+ * @regs:
+ * @regs_res:
+ * @mem_res:
+ * @irq:	interrupt number of the FIMC subdevice
+ * @irqlock:	spinlock protecting videbuffer queue
+ * @timer:
+ * @vfd:
+ * @v4l2_dev:
+ * @m2m_dev:
+ */
+struct fimc_dev {
+	struct platform_device		*pdev;
+	struct s5p_platform_fimc	*pldata;
+	int				id;
+	struct clk			*clock;
+	void __iomem			*regs;
+	struct resource		*regs_res;
+	struct resource		*mem_res;
+	int				irq;
+	spinlock_t			irqlock;
+	struct video_device		*vfd;
+	struct v4l2_device		v4l2_dev;
+	struct v4l2_m2m_dev		*m2m_dev;
+};
+
+
+/**
+ * fimc_ctx - the device context data structure
+ * @lock:		mutex protecting the context data
+ * @s_frame:		source frame properties
+ * @d_frame:		destination frame properties
+ * @osd:		osd (output) window parameters
+ * @out_order_1p:	output 1-plane YCBCR order
+ * @out_order_2p:	output 2-plane YCBCR order
+ * @in_order_1p		input 1-plane YCBCR order
+ * @in_order_2p:	input 2-plane YCBCR order
+ * @in_path:		input mode
+ * @out_path:		output mode
+ * @scaler:		image scaler properties
+ * @effect:		image effect
+ * @rotation:		image clockwise rotation in degrees
+ * @flip:		image flip mode
+ * @flags:		device state flags
+ * @updated:		flags variable to keep track of user configurable
+ *			parameters (ioctl)
+ * @fimc_dev:		fimc device related to the context
+ * @m2m_ctx:		memory-to-memory device context
+ */
+struct fimc_ctx {
+	spinlock_t		slock;
+	struct mutex		lock;
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
+	u32			updated;
+	struct fimc_dev		*fimc_dev;
+	struct v4l2_m2m_ctx	*m2m_ctx;
+};
+
+int s5p_fimc_set_scaler_info(struct fimc_ctx *ctx);
+int s5p_fimc_check_fifo(struct fimc_dev *dev);
+void s5p_fimc_reset(struct fimc_dev *dev);
+void s5p_fimc_set_target_format(struct fimc_ctx *ctx);
+void s5p_fimc_set_out_dma(struct fimc_ctx *ctx);
+void s5p_fimc_en_lastirq(struct fimc_dev *dev, int enable);
+void s5p_fimc_en_irq(struct fimc_dev *dev, int enable);
+void s5p_fimc_en_autoload(struct fimc_ctx *ctx, int enable);
+void s5p_fimc_set_prescaler(struct fimc_ctx *ctx);
+void s5p_fimc_set_scaler(struct fimc_ctx *ctx);
+void s5p_fimc_start_scaler(struct fimc_ctx *ctx);
+void s5p_fimc_stop_scaler(struct fimc_ctx *ctx);
+void s5p_fimc_en_capture(struct fimc_ctx *ctx);
+void s5p_fimc_dis_capture(struct fimc_ctx *ctx);
+void s5p_fimc_set_effect(struct fimc_ctx *ctx);
+void s5p_fimc_set_in_dma(struct fimc_ctx *ctx);
+void s5p_fimc_start_in_dma(struct fimc_dev *dev);
+void s5p_fimc_stop_in_dma(struct fimc_dev *dev);
+void s5p_fimc_set_input_path(struct fimc_ctx *ctx);
+void s5p_fimc_set_output_path(struct fimc_ctx *ctx);
+void s5p_fimc_set_input_addr(struct fimc_ctx *ctx);
+void s5p_fimc_set_output_addr(struct fimc_ctx *ctx);
+
+#endif /* FIMC_CORE_H_ */
diff --git a/drivers/media/video/samsung-fimc/fimc-reg.c b/drivers/media/video/samsung-fimc/fimc-reg.c
new file mode 100644
index 0000000..2e8c7db
--- /dev/null
+++ b/drivers/media/video/samsung-fimc/fimc-reg.c
@@ -0,0 +1,560 @@
+/* linux/drivers/media/video/samsung-fimc/fimc-core.h
+ *
+ * Register interface file for Samsung Camera Interface (FIMC) driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Sylwester Nawrocki, s.nawrocki@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <mach/map.h>
+#include <plat/regs-fimc.h>
+#include <plat/fimc.h>
+#include "fimc-core.h"
+
+
+int s5p_fimc_check_fifo(struct fimc_dev *ctrl)
+{
+	u32 cfg, status;
+
+	status = readl(ctrl->regs + S5P_CISTATUS);
+
+	if ((S5P_CISTATUS_OVFIY | S5P_CISTATUS_OVFICB | S5P_CISTATUS_OVFICR)
+		& status) {
+		cfg = readl(ctrl->regs + S5P_CIWDOFST);
+		cfg |= (S5P_CIWDOFST_CLROVFIY | S5P_CIWDOFST_CLROVFICB
+			| S5P_CIWDOFST_CLROVFICR);
+		writel(cfg, ctrl->regs + S5P_CIWDOFST);
+
+		cfg = readl(ctrl->regs + S5P_CIWDOFST);
+		cfg &= ~(S5P_CIWDOFST_CLROVFIY | S5P_CIWDOFST_CLROVFICB
+			| S5P_CIWDOFST_CLROVFICR);
+		writel(cfg, ctrl->regs + S5P_CIWDOFST);
+	}
+
+	return 0;
+}
+
+void s5p_fimc_reset(struct fimc_dev *dev)
+{
+	u32 cfg;
+
+	cfg = readl(dev->regs + S5P_CISRCFMT);
+	cfg |= S5P_CISRCFMT_ITU601_8BIT;
+	writel(cfg, dev->regs + S5P_CISRCFMT);
+
+	/* sw reset */
+	cfg = readl(dev->regs + S5P_CIGCTRL);
+	cfg |= (S5P_CIGCTRL_SWRST | S5P_CIGCTRL_IRQ_LEVEL);
+	writel(cfg, dev->regs + S5P_CIGCTRL);
+	mdelay(1);
+
+	cfg = readl(dev->regs + S5P_CIGCTRL);
+	cfg &= ~S5P_CIGCTRL_SWRST;
+	writel(cfg, dev->regs + S5P_CIGCTRL);
+
+}
+
+static void s5p_fimc_set_rot90(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 cfg = readl(dev->regs + S5P_CITRGFMT);
+
+	cfg &= ~(S5P_CITRGFMT_INROT90_CLOCKWISE |
+		S5P_CITRGFMT_OUTROT90_CLOCKWISE);
+
+	/* The input and output rotator cannot work simultaneously,
+	in input DMA mode only the output rotator shall be used. */
+	if (ctx->out_path == S5P_FIMC_LCDFIFO)
+		cfg |= S5P_CITRGFMT_INROT90_CLOCKWISE;
+	else
+		cfg |= S5P_CITRGFMT_OUTROT90_CLOCKWISE;
+
+	writel(cfg, dev->regs + S5P_CITRGFMT);
+}
+
+static u32 s5p_fimc_get_in_flip(struct fimc_ctx *ctx)
+{
+	u32 flip = S5P_MSCTRL_FLIP_NORMAL;
+
+	switch (ctx->flip) {
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
+static u32 s5p_fimc_get_target_flip(struct fimc_ctx *ctx)
+{
+	u32 flip = S5P_CITRGFMT_FLIP_NORMAL;
+
+	switch (ctx->flip) {
+	case FLIP_X_AXIS:
+		flip = S5P_CITRGFMT_FLIP_X_MIRROR;
+		break;
+	case FLIP_Y_AXIS:
+		flip = S5P_CITRGFMT_FLIP_Y_MIRROR;
+		break;
+	case FLIP_XY_AXIS:
+		flip = S5P_CITRGFMT_FLIP_180;
+		break;
+	}
+	return flip;
+}
+
+void s5p_fimc_set_target_format(struct fimc_ctx *ctx)
+{
+	u32 cfg = 0;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *frame = &ctx->d_frame;
+
+	dbg("w= %d, h= %d color: %d", frame->width,
+		frame->height, frame->fmt->color);
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
+	cfg |= s5p_fimc_get_target_flip(ctx);
+	writel(cfg, dev->regs + S5P_CITRGFMT);
+
+	if (ctx->rotation == 90 || ctx->rotation == 270)
+		s5p_fimc_set_rot90(ctx);
+
+	cfg = S5P_CITAREA_TARGET_AREA(frame->width * frame->height);
+	writel(cfg, dev->regs + S5P_CITAREA);
+}
+
+static void s5p_fimc_set_out_dma_size(struct fimc_ctx *ctx)
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
+
+	writel(cfg, dev->regs + S5P_ORGOSIZE);
+}
+
+void s5p_fimc_set_out_dma(struct fimc_ctx *ctx)
+{
+	u32 cfg;
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *frame = &ctx->d_frame;
+	struct fimc_dma_offset *offset = &frame->dma_offset;
+
+	/* input dma offsets */
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
+	s5p_fimc_set_out_dma_size(ctx);
+
+	/* configure chroma components order */
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
+void s5p_fimc_en_autoload(struct fimc_ctx *ctx, int enable)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 cfg = readl(dev->regs + S5P_ORGISIZE);
+	if (enable)
+		cfg |= S5P_CIREAL_ISIZE_AUTOLOAD_ENABLE;
+	else
+		cfg &= ~S5P_CIREAL_ISIZE_AUTOLOAD_ENABLE;
+	writel(cfg, dev->regs + S5P_ORGISIZE);
+}
+
+void s5p_fimc_en_lastirq(struct fimc_dev *dev, int enable)
+{
+	unsigned long flags;
+	u32 cfg;
+	local_irq_save(flags);
+
+	cfg = readl(dev->regs + S5P_CIOCTRL);
+	if (enable)
+		cfg |= S5P_CIOCTRL_LASTIRQ_ENABLE;
+	else
+		cfg &= ~S5P_CIOCTRL_LASTIRQ_ENABLE;
+	writel(cfg, dev->regs + S5P_CIOCTRL);
+
+	local_irq_restore(flags);
+}
+
+void s5p_fimc_set_prescaler(struct fimc_ctx *ctx)
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
+void s5p_fimc_set_scaler(struct fimc_ctx *ctx)
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
+	if (ctx->in_path == S5P_FIMC_DMA) {
+		if (src_frame->fmt->color == S5P_FIMC_RGB565)
+			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB565;
+		else if (src_frame->fmt->color == S5P_FIMC_RGB666)
+			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB666;
+		else if (src_frame->fmt->color == S5P_FIMC_RGB888)
+			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB888;
+	}
+
+	if (ctx->out_path == S5P_FIMC_DMA) {
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
+void s5p_fimc_start_scaler(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
+
+	cfg |= S5P_CISCCTRL_SCALERSTART;
+	writel(cfg, dev->regs + S5P_CISCCTRL);
+}
+
+void s5p_fimc_stop_scaler(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
+
+	cfg &= ~S5P_CISCCTRL_SCALERSTART;
+	writel(cfg, dev->regs + S5P_CISCCTRL);
+}
+
+void s5p_fimc_en_capture(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 cfg = readl(dev->regs + S5P_CIIMGCPT);
+
+	if (ctx->out_path == S5P_FIMC_DMA) {
+		/* one shot mode */
+		cfg |= S5P_CIIMGCPT_CPT_FREN_ENABLE | S5P_CIIMGCPT_IMGCPTEN
+			| S5P_CIIMGCPT_CPT_FRMOD_EN;
+	} else {
+		/* freerun */
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
+void s5p_fimc_dis_capture(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 cfg = readl(dev->regs + S5P_CIIMGCPT);
+	cfg &= ~(S5P_CIIMGCPT_IMGCPTEN | S5P_CIIMGCPT_IMGCPTEN_SC);
+	writel(cfg, dev->regs + S5P_CIIMGCPT);
+}
+
+void s5p_fimc_set_effect(struct fimc_ctx *ctx)
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
+static void s5p_fimc_set_in_dma_size(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *frame = &ctx->s_frame;
+	u32 cfg_o = 0;
+	u32 cfg_r = 0;
+
+	if (ctx->out_path == S5P_FIMC_LCDFIFO)
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
+void s5p_fimc_set_in_dma(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	struct fimc_frame *frame = &ctx->s_frame;
+	struct fimc_dma_offset *offset = &frame->dma_offset;
+	u32 cfg = 0;
+
+	/* offsets */
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
+	/* original & real size */
+	s5p_fimc_set_in_dma_size(ctx);
+
+	/* autoload is used currently only in FIFO mode */
+	s5p_fimc_en_autoload(ctx, ctx->out_path == S5P_FIMC_LCDFIFO);
+
+	/* input dma set to process single frame only */
+	cfg = (S5P_MSCTRL_SUCCESSIVE_COUNT(1) | S5P_MSCTRL_INPUT_MEMORY);
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
+	/* input DMA flip mode */
+	if (ctx->out_path == S5P_FIMC_LCDFIFO)
+		cfg |= s5p_fimc_get_in_flip(ctx);;
+
+	writel(cfg, dev->regs + S5P_MSCTRL);
+
+	/* in/out DMA linear/tiled mode */
+	cfg = readl(dev->regs + S5P_CIDMAPARAM);
+	cfg &= ~(S5P_CIDMAPARAM_R_MODE_64X32 | S5P_CIDMAPARAM_W_MODE_64X32);
+
+	writel(cfg, dev->regs + S5P_CIDMAPARAM);
+}
+
+void s5p_fimc_start_in_dma(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + S5P_MSCTRL);
+	cfg |= S5P_MSCTRL_ENVID;
+	writel(cfg, dev->regs + S5P_MSCTRL);
+}
+
+void s5p_fimc_stop_in_dma(struct fimc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + S5P_MSCTRL);
+	cfg &= ~S5P_MSCTRL_ENVID;
+	writel(cfg, dev->regs + S5P_MSCTRL);
+}
+
+void s5p_fimc_set_input_path(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 cfg = readl(dev->regs + S5P_MSCTRL);
+	cfg &= ~S5P_MSCTRL_INPUT_MASK;
+
+	if (ctx->in_path == S5P_FIMC_DMA)
+		cfg |= S5P_MSCTRL_INPUT_MEMORY;
+	else
+		cfg |= S5P_MSCTRL_INPUT_EXTCAM;
+
+	writel(cfg, dev->regs + S5P_MSCTRL);
+}
+
+void s5p_fimc_set_output_path(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 cfg = readl(dev->regs + S5P_CISCCTRL);
+	cfg &= ~S5P_CISCCTRL_LCDPATHEN_FIFO;
+
+	if (ctx->out_path == S5P_FIMC_LCDFIFO)
+		cfg |= S5P_CISCCTRL_LCDPATHEN_FIFO;
+
+	writel(cfg, dev->regs + S5P_CISCCTRL);
+}
+
+void s5p_fimc_set_input_addr(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	u32 cfg = 0;
+
+	cfg = readl(dev->regs + S5P_CIREAL_ISIZE);
+	cfg |= S5P_CIREAL_ISIZE_ADDR_CH_DISABLE;
+	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
+
+	writel(ctx->s_frame.addr_y, dev->regs + S5P_CIIYSA0);
+	writel(ctx->s_frame.addr_cb, dev->regs + S5P_CIICBSA0);
+	writel(ctx->s_frame.addr_cr, dev->regs + S5P_CIICRSA0);
+
+	cfg &= ~S5P_CIREAL_ISIZE_ADDR_CH_DISABLE;
+	writel(cfg, dev->regs + S5P_CIREAL_ISIZE);
+}
+
+void s5p_fimc_set_output_addr(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *dev = ctx->fimc_dev;
+	int i = 0;
+	/* each of the four output register sets points to the same buffer */
+	for (i = 0; i < S5P_FIMC_MAX_FRAMES; i++) {
+		writel(ctx->d_frame.addr_y, dev->regs + S5P_CIOYSA(i));
+		writel(ctx->d_frame.addr_cb, dev->regs + S5P_CIOCBSA(i));
+		writel(ctx->d_frame.addr_cr, dev->regs + S5P_CIOCRSA(i));
+	}
+}
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 418dacf..15d80f7 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -287,6 +287,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_RGB565  v4l2_fourcc('R', 'G', 'B', 'P') /* 16  RGB-5-6-5     */
 #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B', 'Q') /* 16  RGB-5-5-5 BE  */
 #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B', 'R') /* 16  RGB-5-6-5 BE  */
+#define V4L2_PIX_FMT_RGB666  v4l2_fourcc('R', 'G', 'B', 'H') /* 18  RGB-6-6-6	  */
 #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8     */
 #define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B', '3') /* 24  RGB-8-8-8     */
 #define V4L2_PIX_FMT_BGR32   v4l2_fourcc('B', 'G', 'R', '4') /* 32  BGR-8-8-8-8   */
-- 
1.7.0.4

