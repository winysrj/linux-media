Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34400 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2GKIzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 04:55:16 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so815787wgb.1
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 01:55:16 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, kernel@pengutronix.de,
	linux@arm.linux.org.uk,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 1/2] media: Add mem2mem deinterlacing driver.
Date: Wed, 11 Jul 2012 10:55:03 +0200
Message-Id: <1341996904-22893-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1341996904-22893-1-git-send-email-javier.martin@vista-silicon.com>
References: <1341996904-22893-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some video decoders such as tvp5150 provide separate
video fields (V4L2_FIELD_SEQ_TB). This driver uses
dmaengine to convert this format to V4L2_FIELD_INTERLACED_TB
(weaving) or V4L2_FIELD_NONE (line doubling) so that the
image can be displayed or processed.

Of course there will be combing effect in the image but this
can be accepted for some low quality applications.

Currently YUV420 and YUYV formats are supported but
can be extended later.
---
 drivers/media/video/Kconfig           |    8 +
 drivers/media/video/Makefile          |    2 +
 drivers/media/video/m2m-deinterlace.c | 1077 +++++++++++++++++++++++++++++++++
 3 files changed, 1087 insertions(+)
 create mode 100644 drivers/media/video/m2m-deinterlace.c

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9cebf7b..c0b9233 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1188,6 +1188,14 @@ config VIDEO_CODA
 	   Coda is a range of video codec IPs that supports
 	   H.264, MPEG-4, and other video formats.
 
+config VIDEO_MEM2MEM_DEINTERLACE
+	tristate "Deinterlace support"
+	depends on VIDEO_DEV && VIDEO_V4L2 && DMA_ENGINE
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	help
+	    Generic deinterlacing V4L2 driver.
+
 config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a04c307..b6a01b1 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -189,6 +189,8 @@ obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
 obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
 obj-$(CONFIG_VIDEO_CODA) 			+= coda.o
 
+obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
+
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
diff --git a/drivers/media/video/m2m-deinterlace.c b/drivers/media/video/m2m-deinterlace.c
new file mode 100644
index 0000000..9642efd
--- /dev/null
+++ b/drivers/media/video/m2m-deinterlace.c
@@ -0,0 +1,1077 @@
+/*
+ * V4L2 deinterlacing support.
+ *
+ * Copyright (c) 2012 Vista Silicon S.L.
+ * Javier Martin <javier.martin@vista-silicon.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/dmaengine.h>
+#include <linux/platform_device.h>
+
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+
+#define MEM2MEM_TEST_MODULE_NAME "mem2mem-deinterlace"
+
+MODULE_DESCRIPTION("mem2mem device which supports deinterlacing using dmaengine");
+MODULE_AUTHOR("Javier Martin <javier.martin@vista-silicon.com");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.1");
+
+static bool debug = true;
+module_param(debug, bool, 0644);
+
+/* Flags that indicate a format can be used for capture/output */
+#define MEM2MEM_CAPTURE	(1 << 0)
+#define MEM2MEM_OUTPUT	(1 << 1)
+
+#define MEM2MEM_NAME		"m2m-deinterlace"
+
+#define dprintk(dev, fmt, arg...) \
+	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
+
+struct deinterlace_fmt {
+	char	*name;
+	u32	fourcc;
+	enum v4l2_field field;
+	/* Types the format can be used for */
+	u32	types;
+};
+
+static struct deinterlace_fmt formats[] = {
+	{
+		.name	= "YUV 4:2:0 Planar (weaving)",
+		.fourcc	= V4L2_PIX_FMT_YUV420,
+		.field	= V4L2_FIELD_INTERLACED_TB,
+		.types	= MEM2MEM_CAPTURE,
+	},
+	{
+		.name	= "YUV 4:2:0 Planar (line doubling)",
+		.fourcc	= V4L2_PIX_FMT_YUV420,
+		/* Line doubling, top field */
+		.field	= V4L2_FIELD_NONE,
+		.types	= MEM2MEM_CAPTURE,
+	},
+	{
+		.name	= "YUYV 4:2:2 (weaving)",
+		.fourcc	= V4L2_PIX_FMT_YUYV,
+		.field	= V4L2_FIELD_INTERLACED_TB,
+		.types	= MEM2MEM_CAPTURE,
+	},
+	{
+		.name	= "YUYV 4:2:2 (line doubling)",
+		.fourcc	= V4L2_PIX_FMT_YUYV,
+		/* Line doubling, top field */
+		.field	= V4L2_FIELD_NONE,
+		.types	= MEM2MEM_CAPTURE,
+	},
+	{
+		.name	= "YUV 4:2:0 Planar (top-bottom)",
+		.fourcc	= V4L2_PIX_FMT_YUV420,
+		.field	= V4L2_FIELD_SEQ_TB,
+		.types	= MEM2MEM_OUTPUT,
+	},
+	{
+		.name	= "YUYV 4:2:2 (top-bottom)",
+		.fourcc	= V4L2_PIX_FMT_YUYV,
+		.field	= V4L2_FIELD_SEQ_TB,
+		.types	= MEM2MEM_OUTPUT,
+	},
+};
+
+/* Per-queue, driver-specific private data */
+struct deinterlace_q_data {
+	unsigned int		width;
+	unsigned int		height;
+	unsigned int		sizeimage;
+	struct deinterlace_fmt	*fmt;
+};
+
+enum {
+	V4L2_M2M_SRC = 0,
+	V4L2_M2M_DST = 1,
+};
+
+enum {
+	YUV420_DMA_Y_ODD,
+	YUV420_DMA_Y_EVEN,
+	YUV420_DMA_U_ODD,
+	YUV420_DMA_U_EVEN,
+	YUV420_DMA_V_ODD,
+	YUV420_DMA_V_EVEN,
+	YUV420_DMA_Y_ODD_DOUBLING,
+	YUV420_DMA_U_ODD_DOUBLING,
+	YUV420_DMA_V_ODD_DOUBLING,
+	YUYV_DMA_ODD,
+	YUYV_DMA_EVEN,
+	YUYV_DMA_EVEN_DOUBLING,
+};
+
+/* Source and destination queue data */
+static struct deinterlace_q_data q_data[2];
+
+static struct deinterlace_q_data *get_q_data(enum v4l2_buf_type type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		return &q_data[V4L2_M2M_SRC];
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return &q_data[V4L2_M2M_DST];
+	default:
+		BUG();
+	}
+	return NULL;
+}
+
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
+static struct deinterlace_fmt *find_format(struct v4l2_format *f)
+{
+	struct deinterlace_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < NUM_FORMATS; k++) {
+		fmt = &formats[k];
+		if ((fmt->types == f->type) &&
+			(fmt->fourcc == f->fmt.pix.pixelformat) &&
+			(fmt->field == f->fmt.pix.field))
+			break;
+	}
+
+	if (k == NUM_FORMATS)
+		return NULL;
+
+	return &formats[k];
+}
+
+struct deinterlace_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vfd;
+
+	atomic_t		busy;
+	struct mutex		dev_mutex;
+	spinlock_t		irqlock;
+
+	struct dma_chan		*dma_chan;
+
+	struct v4l2_m2m_dev	*m2m_dev;
+	struct vb2_alloc_ctx	*alloc_ctx;
+};
+
+struct deinterlace_ctx {
+	struct deinterlace_dev	*dev;
+
+	/* Abort requested by m2m */
+	int			aborting;
+	dma_cookie_t		cookie;
+	struct v4l2_m2m_ctx	*m2m_ctx;
+	struct dma_interleaved_template *xt;
+};
+
+/*
+ * mem2mem callbacks
+ */
+static int deinterlace_job_ready(void *priv)
+{
+	struct deinterlace_ctx *ctx = priv;
+	struct deinterlace_dev *pcdev = ctx->dev;
+
+	if ((v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) > 0)
+	    && (v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) > 0)
+	    && (atomic_read(&ctx->dev->busy) == 0)) {
+		dprintk(pcdev, "Task ready\n");
+		return 1;
+	}
+
+	dprintk(pcdev, "Task not ready to run\n");
+
+	return 0;
+}
+
+static void deinterlace_job_abort(void *priv)
+{
+	struct deinterlace_ctx *ctx = priv;
+	struct deinterlace_dev *pcdev = ctx->dev;
+
+	ctx->aborting = 1;
+
+	dprintk(pcdev, "Aborting task\n");
+
+	v4l2_m2m_job_finish(pcdev->m2m_dev, ctx->m2m_ctx);
+}
+
+static void deinterlace_lock(void *priv)
+{
+	struct deinterlace_ctx *ctx = priv;
+	struct deinterlace_dev *pcdev = ctx->dev;
+	mutex_lock(&pcdev->dev_mutex);
+}
+
+static void deinterlace_unlock(void *priv)
+{
+	struct deinterlace_ctx *ctx = priv;
+	struct deinterlace_dev *pcdev = ctx->dev;
+	mutex_unlock(&pcdev->dev_mutex);
+}
+
+static void dma_callback(void *data)
+{
+	struct deinterlace_ctx *curr_ctx = data;
+	struct deinterlace_dev *pcdev = curr_ctx->dev;
+	struct vb2_buffer *src_vb, *dst_vb;
+
+	atomic_set(&pcdev->busy, 0);
+
+	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
+
+	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
+	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
+
+	v4l2_m2m_job_finish(pcdev->m2m_dev, curr_ctx->m2m_ctx);
+
+	dprintk(pcdev, "dma transfers completed.\n");
+}
+
+static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
+				  int do_callback)
+{
+	struct deinterlace_q_data *s_q_data, *d_q_data;
+	struct vb2_buffer *src_buf, *dst_buf;
+	struct deinterlace_dev *pcdev = ctx->dev;
+	struct dma_chan *chan = pcdev->dma_chan;
+	struct dma_device *dmadev = chan->device;
+	struct dma_async_tx_descriptor *tx;
+	unsigned int s_width, s_height;
+	unsigned int d_width, d_height;
+	unsigned int d_size, s_size;
+	dma_addr_t p_in, p_out;
+	enum dma_ctrl_flags flags;
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+
+	s_q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	s_width	= s_q_data->width;
+	s_height = s_q_data->height;
+	s_size = s_width * s_height;
+
+	d_q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	d_width = d_q_data->width;
+	d_height = d_q_data->height;
+	d_size = d_width * d_height;
+
+	p_in = (dma_addr_t)vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	p_out = (dma_addr_t)vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	if (!p_in || !p_out) {
+		v4l2_err(&pcdev->v4l2_dev,
+			 "Acquiring kernel pointers to buffers failed\n");
+		return;
+	}
+
+	switch (op) {
+	case YUV420_DMA_Y_ODD:
+		ctx->xt->numf = s_height / 2;
+		ctx->xt->sgl[0].size = s_width;
+		ctx->xt->sgl[0].icg = s_width;
+		ctx->xt->src_start = p_in;
+		ctx->xt->dst_start = p_out;
+		break;
+	case YUV420_DMA_Y_EVEN:
+		ctx->xt->numf = s_height / 2;
+		ctx->xt->sgl[0].size = s_width;
+		ctx->xt->sgl[0].icg = s_width;
+		ctx->xt->src_start = p_in + s_size / 2;
+		ctx->xt->dst_start = p_out + s_width;
+		break;
+	case YUV420_DMA_U_ODD:
+		ctx->xt->numf = s_height / 4;
+		ctx->xt->sgl[0].size = s_width / 2;
+		ctx->xt->sgl[0].icg = s_width / 2;
+		ctx->xt->src_start = p_in + s_size;
+		ctx->xt->dst_start = p_out + s_size;
+		break;
+	case YUV420_DMA_U_EVEN:
+		ctx->xt->numf = s_height / 4;
+		ctx->xt->sgl[0].size = s_width / 2;
+		ctx->xt->sgl[0].icg = s_width / 2;
+		ctx->xt->src_start = p_in + (9 * s_size) / 8;
+		ctx->xt->dst_start = p_out + s_size + s_width / 2;
+		break;
+	case YUV420_DMA_V_ODD:
+		ctx->xt->numf = s_height / 4;
+		ctx->xt->sgl[0].size = s_width / 2;
+		ctx->xt->sgl[0].icg = s_width / 2;
+		ctx->xt->src_start = p_in + (5 * s_size) / 4;
+		ctx->xt->dst_start = p_out + (5 * s_size) / 4;
+		break;
+	case YUV420_DMA_V_EVEN:
+		ctx->xt->numf = s_height / 4;
+		ctx->xt->sgl[0].size = s_width / 2;
+		ctx->xt->sgl[0].icg = s_width / 2;
+		ctx->xt->src_start = p_in + (11 * s_size) / 8;
+		ctx->xt->dst_start = p_out + (5 * s_size) / 4 + s_width / 2;
+		break;
+	case YUV420_DMA_Y_ODD_DOUBLING:
+		ctx->xt->numf = s_height / 2;
+		ctx->xt->sgl[0].size = s_width;
+		ctx->xt->sgl[0].icg = s_width;
+		ctx->xt->src_start = p_in;
+		ctx->xt->dst_start = p_out + s_width;
+		break;
+	case YUV420_DMA_U_ODD_DOUBLING:
+		ctx->xt->numf = s_height / 4;
+		ctx->xt->sgl[0].size = s_width / 2;
+		ctx->xt->sgl[0].icg = s_width / 2;
+		ctx->xt->src_start = p_in + s_size;
+		ctx->xt->dst_start = p_out + s_size + s_width / 2;
+		break;
+	case YUV420_DMA_V_ODD_DOUBLING:
+		ctx->xt->numf = s_height / 4;
+		ctx->xt->sgl[0].size = s_width / 2;
+		ctx->xt->sgl[0].icg = s_width / 2;
+		ctx->xt->src_start = p_in + (5 * s_size) / 4;
+		ctx->xt->dst_start = p_out + (5 * s_size) / 4 + s_width / 2;
+		break;
+	case YUYV_DMA_ODD:
+		ctx->xt->numf = s_height / 2;
+		ctx->xt->sgl[0].size = s_width * 2;
+		ctx->xt->sgl[0].icg = s_width * 2;
+		ctx->xt->src_start = p_in;
+		ctx->xt->dst_start = p_out;
+		break;
+	case YUYV_DMA_EVEN:
+		ctx->xt->numf = s_height / 2;
+		ctx->xt->sgl[0].size = s_width * 2;
+		ctx->xt->sgl[0].icg = s_width * 2;
+		ctx->xt->src_start = p_in + s_size;
+		ctx->xt->dst_start = p_out + s_width * 2;
+		break;
+	case YUYV_DMA_EVEN_DOUBLING:
+	default:
+		ctx->xt->numf = s_height / 2;
+		ctx->xt->sgl[0].size = s_width * 2;
+		ctx->xt->sgl[0].icg = s_width * 2;
+		ctx->xt->src_start = p_in;
+		ctx->xt->dst_start = p_out + s_width * 2;
+		break;
+	}
+
+	/* Common parameters for al transfers */
+	ctx->xt->frame_size = 1;
+	ctx->xt->dir = DMA_MEM_TO_MEM;
+	ctx->xt->src_sgl = false;
+	ctx->xt->dst_sgl = true;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
+		DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SKIP_SRC_UNMAP;
+
+	tx = dmadev->device_prep_interleaved_dma(chan, ctx->xt, flags);
+	if (tx == NULL) {
+		v4l2_warn(&pcdev->v4l2_dev, "DMA interleaved prep error\n");
+		return;
+	}
+
+	if (do_callback) {
+		tx->callback = dma_callback;
+		tx->callback_param = ctx;
+	}
+
+	ctx->cookie = dmaengine_submit(tx);
+	if (dma_submit_error(ctx->cookie)) {
+		v4l2_warn(&pcdev->v4l2_dev,
+			  "DMA submit error %d with src=0x%x dst=0x%x len=0x%x\n",
+			  ctx->cookie, p_in, p_out, s_size * 3/2);
+		return;
+	}
+
+	dma_async_issue_pending(chan);
+}
+
+static void deinterlace_device_run(void *priv)
+{
+	struct deinterlace_ctx *ctx = priv;
+	struct deinterlace_q_data *dst_q_data;
+
+	atomic_set(&ctx->dev->busy, 1);
+
+	dprintk(ctx->dev, "%s: DMA try issue.\n", __func__);
+
+	dst_q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+	switch (dst_q_data->fmt->fourcc) {
+	case V4L2_PIX_FMT_YUV420:
+		switch (dst_q_data->fmt->field) {
+		case V4L2_FIELD_INTERLACED_TB:
+			dprintk(ctx->dev, "%s: yuv420 interlaced tb.\n",
+				__func__);
+			deinterlace_issue_dma(ctx, YUV420_DMA_Y_ODD, 0);
+			deinterlace_issue_dma(ctx, YUV420_DMA_Y_EVEN, 0);
+			deinterlace_issue_dma(ctx, YUV420_DMA_U_ODD, 0);
+			deinterlace_issue_dma(ctx, YUV420_DMA_U_EVEN, 0);
+			deinterlace_issue_dma(ctx, YUV420_DMA_V_ODD, 0);
+			deinterlace_issue_dma(ctx, YUV420_DMA_V_EVEN, 1);
+			break;
+		case V4L2_FIELD_NONE:
+		default:
+			dprintk(ctx->dev, "%s: yuv420 interlaced line doubling.\n",
+				__func__);
+			deinterlace_issue_dma(ctx, YUV420_DMA_Y_ODD, 0);
+			deinterlace_issue_dma(ctx, YUV420_DMA_Y_ODD_DOUBLING, 0);
+			deinterlace_issue_dma(ctx, YUV420_DMA_U_ODD, 0);
+			deinterlace_issue_dma(ctx, YUV420_DMA_U_ODD_DOUBLING, 0);
+			deinterlace_issue_dma(ctx, YUV420_DMA_V_ODD, 0);
+			deinterlace_issue_dma(ctx, YUV420_DMA_V_ODD_DOUBLING, 1);
+			break;
+		}
+		break;
+	case V4L2_PIX_FMT_YUYV:
+	default:
+		switch (dst_q_data->fmt->field) {
+		case V4L2_FIELD_INTERLACED_TB:
+			dprintk(ctx->dev, "%s: yuyv interlaced_tb.\n",
+				__func__);
+			deinterlace_issue_dma(ctx, YUYV_DMA_ODD, 0);
+			deinterlace_issue_dma(ctx, YUYV_DMA_EVEN, 1);
+			break;
+		case V4L2_FIELD_NONE:
+		default:
+			dprintk(ctx->dev, "%s: yuyv interlaced line doubling.\n",
+				__func__);
+			deinterlace_issue_dma(ctx, YUYV_DMA_ODD, 0);
+			deinterlace_issue_dma(ctx, YUYV_DMA_EVEN_DOUBLING, 1);
+			break;
+		}
+		break;
+	}
+
+	dprintk(ctx->dev, "%s: DMA issue done.\n", __func__);
+}
+
+/*
+ * video ioctls
+ */
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
+	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
+			  | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
+{
+	int i, num;
+	struct deinterlace_fmt *fmt;
+
+	num = 0;
+
+	for (i = 0; i < NUM_FORMATS; ++i) {
+		if (formats[i].types & type) {
+			/* index-th format of type type found ? */
+			if (num == f->index)
+				break;
+			/* Correct type but haven't reached our index yet,
+			 * just increment per-type index */
+			++num;
+		}
+	}
+
+	if (i < NUM_FORMATS) {
+		/* Format found */
+		fmt = &formats[i];
+		strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+		f->pixelformat = fmt->fourcc;
+		return 0;
+	}
+
+	/* Format not found */
+	return -EINVAL;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	return enum_fmt(f, MEM2MEM_CAPTURE);
+}
+
+static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	return enum_fmt(f, MEM2MEM_OUTPUT);
+}
+
+static int vidioc_g_fmt(struct deinterlace_ctx *ctx, struct v4l2_format *f)
+{
+	struct vb2_queue *vq;
+	struct deinterlace_q_data *q_data;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = get_q_data(f->type);
+
+	f->fmt.pix.width	= q_data->width;
+	f->fmt.pix.height	= q_data->height;
+	f->fmt.pix.field	= q_data->fmt->field;
+	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
+
+	switch (q_data->fmt->fourcc) {
+	case V4L2_PIX_FMT_YUV420:
+		f->fmt.pix.bytesperline = q_data->width * 3 / 2;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+	default:
+		f->fmt.pix.bytesperline = q_data->width * 2;
+	}
+
+	f->fmt.pix.sizeimage	= q_data->sizeimage;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	return vidioc_g_fmt(priv, f);
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	return vidioc_g_fmt(priv, f);
+}
+
+static int vidioc_try_fmt(struct v4l2_format *f, struct deinterlace_fmt *fmt)
+{
+	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+		f->fmt.pix.bytesperline = f->fmt.pix.width * 3 / 2;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+	default:
+		f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
+	}
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct deinterlace_fmt *fmt;
+	struct deinterlace_ctx *ctx = priv;
+
+	fmt = find_format(f);
+	if (!fmt || !(fmt->types & MEM2MEM_CAPTURE)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+	return vidioc_try_fmt(f, fmt);
+}
+
+static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct deinterlace_fmt *fmt;
+	struct deinterlace_ctx *ctx = priv;
+
+	fmt = find_format(f);
+	if (!fmt || !(fmt->types & MEM2MEM_OUTPUT)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	return vidioc_try_fmt(f, fmt);
+}
+
+static int vidioc_s_fmt(struct deinterlace_ctx *ctx, struct v4l2_format *f)
+{
+	struct deinterlace_q_data *q_data;
+	struct vb2_queue *vq;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = get_q_data(f->type);
+	if (!q_data)
+		return -EINVAL;
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
+	q_data->fmt		= find_format(f);
+	if (!q_data->fmt) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Couldn't set format type %d, wxh: %dx%d. fmt: %d, field: %d\n",
+			f->type, f->fmt.pix.width, f->fmt.pix.height,
+			f->fmt.pix.pixelformat, f->fmt.pix.field);
+		return -EINVAL;
+	}
+
+	q_data->width		= f->fmt.pix.width;
+	q_data->height		= f->fmt.pix.height;
+
+	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+		f->fmt.pix.bytesperline = f->fmt.pix.width * 3 / 2;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+	default:
+		f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
+	}
+
+	dprintk(ctx->dev,
+		"Setting format for type %d, wxh: %dx%d, fmt: %d, field: %d\n",
+		f->type, q_data->width, q_data->height, q_data->fmt->fourcc,
+		q_data->fmt->field);
+
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	int ret;
+
+	ret = vidioc_try_fmt_vid_cap(file, priv, f);
+	if (ret)
+		return ret;
+	return vidioc_s_fmt(priv, f);
+}
+
+static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	int ret;
+
+	ret = vidioc_try_fmt_vid_out(file, priv, f);
+	if (ret)
+		return ret;
+
+	return vidioc_s_fmt(priv, f);
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct deinterlace_ctx *ctx = priv;
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int vidioc_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct deinterlace_ctx *ctx = priv;
+
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct deinterlace_ctx *ctx = priv;
+
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct deinterlace_ctx *ctx = priv;
+
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct deinterlace_q_data *s_q_data, *d_q_data;
+	struct deinterlace_ctx *ctx = priv;
+
+	/* Check that src and dst queues have the same format */
+	s_q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	d_q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	if (s_q_data->fmt->fourcc != d_q_data->fmt->fourcc)
+		return -EINVAL;
+
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct deinterlace_ctx *ctx = priv;
+
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+static const struct v4l2_ioctl_ops deinterlace_ioctl_ops = {
+	.vidioc_querycap	= vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
+
+	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
+	.vidioc_g_fmt_vid_out	= vidioc_g_fmt_vid_out,
+	.vidioc_try_fmt_vid_out	= vidioc_try_fmt_vid_out,
+	.vidioc_s_fmt_vid_out	= vidioc_s_fmt_vid_out,
+
+	.vidioc_reqbufs		= vidioc_reqbufs,
+	.vidioc_querybuf	= vidioc_querybuf,
+
+	.vidioc_qbuf		= vidioc_qbuf,
+	.vidioc_dqbuf		= vidioc_dqbuf,
+
+	.vidioc_streamon	= vidioc_streamon,
+	.vidioc_streamoff	= vidioc_streamoff,
+};
+
+
+/*
+ * Queue operations
+ */
+struct vb2_dc_conf {
+	struct device           *dev;
+};
+
+static int deinterlace_queue_setup(struct vb2_queue *vq,
+				const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct deinterlace_ctx *ctx = vb2_get_drv_priv(vq);
+	struct deinterlace_q_data *q_data;
+	unsigned int size, count = *nbuffers;
+
+	q_data = get_q_data(vq->type);
+
+	switch (q_data->fmt->fourcc) {
+	case V4L2_PIX_FMT_YUV420:
+		size = q_data->width * q_data->height * 3 / 2;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+	default:
+		size = q_data->width * q_data->height * 2;
+	}
+
+	*nplanes = 1;
+	*nbuffers = count;
+	sizes[0] = size;
+
+	alloc_ctxs[0] = ctx->dev->alloc_ctx;
+
+	dprintk(ctx->dev, "get %d buffer(s) of size %d each.\n", count, size);
+
+	return 0;
+}
+
+static int deinterlace_buf_prepare(struct vb2_buffer *vb)
+{
+	struct deinterlace_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct deinterlace_q_data *q_data;
+
+	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
+
+	q_data = get_q_data(vb->vb2_queue->type);
+
+	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
+		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
+			__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
+
+	return 0;
+}
+
+static void deinterlace_buf_queue(struct vb2_buffer *vb)
+{
+	struct deinterlace_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+}
+
+static struct vb2_ops deinterlace_qops = {
+	.queue_setup	 = deinterlace_queue_setup,
+	.buf_prepare	 = deinterlace_buf_prepare,
+	.buf_queue	 = deinterlace_buf_queue,
+};
+
+static int queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
+{
+	struct deinterlace_ctx *ctx = priv;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->ops = &deinterlace_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->ops = &deinterlace_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+
+	return vb2_queue_init(dst_vq);
+}
+
+/*
+ * File operations
+ */
+static int deinterlace_open(struct file *file)
+{
+	struct deinterlace_dev *pcdev = video_drvdata(file);
+	struct deinterlace_ctx *ctx = NULL;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	file->private_data = ctx;
+	ctx->dev = pcdev;
+
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(pcdev->m2m_dev, ctx, &queue_init);
+	if (IS_ERR(ctx->m2m_ctx)) {
+		int ret = PTR_ERR(ctx->m2m_ctx);
+
+		kfree(ctx);
+		return ret;
+	}
+
+	ctx->xt = kzalloc(sizeof(struct dma_async_tx_descriptor) +
+				sizeof(struct data_chunk), GFP_KERNEL);
+	if (!ctx->xt) {
+		int ret = PTR_ERR(ctx->xt);
+
+		kfree(ctx);
+		return ret;
+	}
+
+	dprintk(pcdev, "Created instance %p, m2m_ctx: %p\n", ctx, ctx->m2m_ctx);
+
+	return 0;
+}
+
+static int deinterlace_release(struct file *file)
+{
+	struct deinterlace_dev *pcdev = video_drvdata(file);
+	struct deinterlace_ctx *ctx = file->private_data;
+
+	dprintk(pcdev, "Releasing instance %p\n", ctx);
+
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	kfree(ctx->xt);
+	kfree(ctx);
+
+	return 0;
+}
+
+static unsigned int deinterlace_poll(struct file *file,
+				 struct poll_table_struct *wait)
+{
+	struct deinterlace_ctx *ctx = file->private_data;
+	int ret;
+
+	deinterlace_lock(ctx);
+	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	deinterlace_unlock(ctx);
+
+	return ret;
+}
+
+static int deinterlace_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct deinterlace_ctx *ctx = file->private_data;
+
+	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+}
+
+static const struct v4l2_file_operations deinterlace_fops = {
+	.owner		= THIS_MODULE,
+	.open		= deinterlace_open,
+	.release	= deinterlace_release,
+	.poll		= deinterlace_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= deinterlace_mmap,
+};
+
+static struct video_device deinterlace_videodev = {
+	.name		= MEM2MEM_NAME,
+	.fops		= &deinterlace_fops,
+	.ioctl_ops	= &deinterlace_ioctl_ops,
+	.minor		= -1,
+	.release	= video_device_release,
+};
+
+static struct v4l2_m2m_ops m2m_ops = {
+	.device_run	= deinterlace_device_run,
+	.job_ready	= deinterlace_job_ready,
+	.job_abort	= deinterlace_job_abort,
+	.lock		= deinterlace_lock,
+	.unlock		= deinterlace_unlock,
+};
+
+static int deinterlace_probe(struct platform_device *pdev)
+{
+	struct deinterlace_dev *pcdev;
+	struct video_device *vfd;
+	dma_cap_mask_t mask;
+	int ret = 0;
+
+	pcdev = kzalloc(sizeof *pcdev, GFP_KERNEL);
+	if (!pcdev)
+		return -ENOMEM;
+
+	spin_lock_init(&pcdev->irqlock);
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_INTERLEAVE, mask);
+	pcdev->dma_chan = dma_request_channel(mask, NULL, pcdev);
+	if (!pcdev->dma_chan)
+		goto free_dev;
+
+	if (!dma_has_cap(DMA_INTERLEAVE, pcdev->dma_chan->device->cap_mask)) {
+		v4l2_err(&pcdev->v4l2_dev, "DMA does not support INTERLEAVE\n");
+		goto rel_dma;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
+	if (ret)
+		goto rel_dma;
+
+	atomic_set(&pcdev->busy, 0);
+	mutex_init(&pcdev->dev_mutex);
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&pcdev->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto unreg_dev;
+	}
+
+	*vfd = deinterlace_videodev;
+	vfd->lock = &pcdev->dev_mutex;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&pcdev->v4l2_dev, "Failed to register video device\n");
+		goto rel_vdev;
+	}
+
+	video_set_drvdata(vfd, pcdev);
+	snprintf(vfd->name, sizeof(vfd->name), "%s", deinterlace_videodev.name);
+	pcdev->vfd = vfd;
+	v4l2_info(&pcdev->v4l2_dev, MEM2MEM_TEST_MODULE_NAME
+			" Device registered as /dev/video%d\n", vfd->num);
+
+	platform_set_drvdata(pdev, pcdev);
+
+	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(pcdev->alloc_ctx)) {
+		v4l2_err(&pcdev->v4l2_dev, "Failed to alloc vb2 context\n");
+		ret = PTR_ERR(pcdev->alloc_ctx);
+		goto err_ctx;
+	}
+
+	pcdev->m2m_dev = v4l2_m2m_init(&m2m_ops);
+	if (IS_ERR(pcdev->m2m_dev)) {
+		v4l2_err(&pcdev->v4l2_dev, "Failed to init mem2mem device\n");
+		ret = PTR_ERR(pcdev->m2m_dev);
+		goto err_m2m;
+	}
+
+	q_data[V4L2_M2M_SRC].fmt = &formats[1];
+	q_data[V4L2_M2M_DST].fmt = &formats[0];
+
+	return 0;
+
+	v4l2_m2m_release(pcdev->m2m_dev);
+err_m2m:
+	video_unregister_device(pcdev->vfd);
+err_ctx:
+	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
+rel_vdev:
+	video_device_release(vfd);
+unreg_dev:
+	v4l2_device_unregister(&pcdev->v4l2_dev);
+rel_dma:
+	dma_release_channel(pcdev->dma_chan);
+free_dev:
+	kfree(pcdev);
+
+	return ret;
+}
+
+static int deinterlace_remove(struct platform_device *pdev)
+{
+	struct deinterlace_dev *pcdev =
+		(struct deinterlace_dev *)platform_get_drvdata(pdev);
+
+	v4l2_info(&pcdev->v4l2_dev, "Removing " MEM2MEM_TEST_MODULE_NAME);
+	v4l2_m2m_release(pcdev->m2m_dev);
+	video_unregister_device(pcdev->vfd);
+	v4l2_device_unregister(&pcdev->v4l2_dev);
+	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
+	dma_release_channel(pcdev->dma_chan);
+	kfree(pcdev);
+
+	return 0;
+}
+
+static struct platform_driver deinterlace_pdrv = {
+	.probe		= deinterlace_probe,
+	.remove		= deinterlace_remove,
+	.driver		= {
+		.name	= MEM2MEM_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static void __exit deinterlace_exit(void)
+{
+	platform_driver_unregister(&deinterlace_pdrv);
+}
+
+static int __init deinterlace_init(void)
+{
+	return platform_driver_register(&deinterlace_pdrv);
+}
+
+module_init(deinterlace_init);
+module_exit(deinterlace_exit);
+
-- 
1.7.9.5

