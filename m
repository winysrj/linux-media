Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38170 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab2GLHLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 03:11:52 -0400
Received: by wibhr14 with SMTP id hr14so1918825wib.1
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 00:11:50 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, p.zabel@pengutronix.de,
	s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v3] media: coda: Add driver for Coda video codec.
Date: Thu, 12 Jul 2012 09:11:40 +0200
Message-Id: <1342077100-8629-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Coda is a range of video codecs from Chips&Media that
support H.264, H.263, MPEG4 and other video standards.

Currently only support for the codadx6 included in the
i.MX27 SoC is added. H.264 and MPEG4 video encoding
are the only supported capabilities by now.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
Changes since v2:
 - Make hex constants lower case.
 - Fix bytesperline.
 - Make some functions and variables static.
 - Fix logical &&
 - Remove get_qops()
---
 drivers/media/video/Kconfig  |    9 +
 drivers/media/video/Makefile |    1 +
 drivers/media/video/coda.c   | 1869 ++++++++++++++++++++++++++++++++++++++++++
 drivers/media/video/coda.h   |  214 +++++
 4 files changed, 2093 insertions(+)
 create mode 100644 drivers/media/video/coda.c
 create mode 100644 drivers/media/video/coda.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 99937c9..9cebf7b 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1179,6 +1179,15 @@ config VIDEO_MEM2MEM_TESTDEV
 	  This is a virtual test device for the memory-to-memory driver
 	  framework.
 
+config VIDEO_CODA
+	tristate "Chips&Media Coda multi-standard codec IP"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	---help---
+	   Coda is a range of video codec IPs that supports
+	   H.264, MPEG-4, and other video formats.
+
 config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index d209de0..a04c307 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -187,6 +187,7 @@ obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
 obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
 
 obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
+obj-$(CONFIG_VIDEO_CODA) 			+= coda.o
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
new file mode 100644
index 0000000..bfbbeb5
--- /dev/null
+++ b/drivers/media/video/coda.c
@@ -0,0 +1,1869 @@
+/*
+ * Coda multi-standard codec IP
+ *
+ * Copyright (C) 2012 Vista Silicon S.L.
+ *    Javier Martin, <javier.martin@vista-silicon.com>
+ *    Xavier Duret
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "coda.h"
+
+#define CODA_NAME		"coda"
+
+#define CODA_MAX_INSTANCES	4
+
+#define CODA_FMO_BUF_SIZE	32
+#define CODADX6_WORK_BUF_SIZE	(288 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
+#define CODA7_WORK_BUF_SIZE	(512 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
+#define CODA_PARA_BUF_SIZE	(10 * 1024)
+#define CODA_ISRAM_SIZE	(2048 * 2)
+
+#define CODA_OUTPUT_BUFS	4
+#define CODA_CAPTURE_BUFS	2
+
+#define CODA_MAX_WIDTH		720
+#define CODA_MAX_HEIGHT		576
+#define CODA_MAX_FRAME_SIZE	0x90000
+#define FMO_SLICE_SAVE_BUF_SIZE         (32)
+#define CODA_DEFAULT_GAMMA		4096
+
+#define MIN_W 176
+#define MIN_H 144
+#define MAX_W 720
+#define MAX_H 576
+
+#define S_ALIGN		1 /* multiple of 2 */
+#define W_ALIGN		1 /* multiple of 2 */
+#define H_ALIGN		1 /* multiple of 2 */
+
+#define fh_to_ctx(__fh)	container_of(__fh, struct coda_ctx, fh)
+
+static int coda_debug;
+module_param(coda_debug, int, 0);
+MODULE_PARM_DESC(coda_debug, "Debug level (0-1)");
+
+enum {
+	V4L2_M2M_SRC = 0,
+	V4L2_M2M_DST = 1,
+};
+
+enum coda_fmt_type {
+	CODA_FMT_ENC,
+	CODA_FMT_RAW,
+};
+
+enum coda_inst_type {
+	CODA_INST_INVALID,
+	CODA_INST_ENCODER,
+	CODA_INST_DECODER,
+};
+
+enum coda_product {
+	CODA_DX6 = 0xf001,
+};
+
+struct coda_fmt {
+	char *name;
+	u32 fourcc;
+	enum coda_fmt_type type;
+};
+
+struct coda_devtype {
+	char			*firmware;
+	enum coda_product	product;
+	struct coda_fmt		*formats;
+	unsigned int		num_formats;
+	size_t			workbuf_size;
+};
+
+/* Per-queue, driver-specific private data */
+struct coda_q_data {
+	unsigned int		width;
+	unsigned int		height;
+	unsigned int		sizeimage;
+	struct coda_fmt	*fmt;
+};
+
+struct coda_aux_buf {
+	void			*vaddr;
+	dma_addr_t		paddr;
+};
+
+struct coda_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vfd;
+	struct platform_device	*plat_dev;
+	struct coda_devtype	*devtype;
+
+	void __iomem		*regs_base;
+	struct clk		*clk_per;
+	struct clk		*clk_ahb;
+	int			irq;
+
+	size_t			codebuf_size;
+	struct coda_aux_buf	codebuf;
+	struct coda_aux_buf	workbuf;
+
+	spinlock_t		irqlock;
+	struct mutex		dev_mutex;
+	struct v4l2_m2m_dev	*m2m_dev;
+	struct vb2_alloc_ctx	*alloc_ctx;
+	int			instances;
+};
+
+struct coda_params {
+	u8			h264_intra_qp;
+	u8			h264_inter_qp;
+	u8			mpeg4_intra_qp;
+	u8			mpeg4_inter_qp;
+	u8			gop_size;
+	int			codec_mode;
+	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
+	u32			framerate;
+	u16			bitrate;
+	u32			slice_max_mb;
+};
+
+struct coda_ctx {
+	struct coda_dev			*dev;
+	int				aborting;
+	int				rawstreamon;
+	int				compstreamon;
+	u32				isequence;
+	struct coda_q_data		q_data[2];
+	enum coda_inst_type		inst_type;
+	struct coda_params		params;
+	struct v4l2_m2m_ctx		*m2m_ctx;
+	struct v4l2_ctrl_handler	ctrls;
+	struct v4l2_fh			fh;
+	struct vb2_buffer		*reference;
+	int				gopcounter;
+	char				vpu_header[3][64];
+	int				vpu_header_size[3];
+	struct coda_aux_buf		parabuf;
+	int				idx;
+};
+
+static inline void coda_write(struct coda_dev *dev, u32 data, u32 reg)
+{
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+		 "%s: data=0x%x, reg=0x%x\n", __func__, data, reg);
+	writel(data, dev->regs_base + reg);
+}
+
+static inline unsigned int coda_read(struct coda_dev *dev, u32 reg)
+{
+	u32 data;
+	data = readl(dev->regs_base + reg);
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+		 "%s: data=0x%x, reg=0x%x\n", __func__, data, reg);
+	return data;
+}
+
+static inline unsigned long coda_isbusy(struct coda_dev *dev)
+{
+	return coda_read(dev, CODA_REG_BIT_BUSY);
+}
+
+static inline int coda_is_initialized(struct coda_dev *dev)
+{
+	return (coda_read(dev, CODA_REG_BIT_CUR_PC) != 0);
+}
+
+static int coda_wait_timeout(struct coda_dev *dev)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
+
+	while (coda_isbusy(dev)) {
+		if (time_after(jiffies, timeout))
+			return -ETIMEDOUT;
+	};
+	return 0;
+}
+
+static void coda_command_async(struct coda_ctx *ctx, int cmd)
+{
+	struct coda_dev *dev = ctx->dev;
+	coda_write(dev, CODA_REG_BIT_BUSY_FLAG, CODA_REG_BIT_BUSY);
+
+	coda_write(dev, ctx->idx, CODA_REG_BIT_RUN_INDEX);
+	coda_write(dev, ctx->params.codec_mode, CODA_REG_BIT_RUN_COD_STD);
+	coda_write(dev, cmd, CODA_REG_BIT_RUN_COMMAND);
+}
+
+static int coda_command_sync(struct coda_ctx *ctx, int cmd)
+{
+	struct coda_dev *dev = ctx->dev;
+
+	coda_command_async(ctx, cmd);
+	return coda_wait_timeout(dev);
+}
+
+static struct coda_q_data *get_q_data(struct coda_ctx *ctx,
+					 enum v4l2_buf_type type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		return &(ctx->q_data[V4L2_M2M_SRC]);
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return &(ctx->q_data[V4L2_M2M_DST]);
+	default:
+		BUG();
+	}
+	return NULL;
+}
+
+/*
+ * Add one array of supported formats for each version of Coda:
+ *  i.MX27 -> codadx6
+ *  i.MX51 -> coda7
+ *  i.MX6  -> coda960
+ */
+static struct coda_fmt codadx6_formats[] = {
+	{
+		.name = "YUV 4:2:0 Planar",
+		.fourcc = V4L2_PIX_FMT_YUV420,
+		.type = CODA_FMT_RAW,
+	},
+	{
+		.name = "H264 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_H264,
+		.type = CODA_FMT_ENC,
+	},
+	{
+		.name = "MPEG4 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_MPEG4,
+		.type = CODA_FMT_ENC,
+	},
+};
+
+static struct coda_fmt *find_format(struct coda_dev *dev, struct v4l2_format *f)
+{
+	struct coda_fmt *formats = dev->devtype->formats;
+	struct coda_fmt *fmt;
+	int num_formats = dev->devtype->num_formats;
+	unsigned int k;
+
+	for (k = 0; k < num_formats; k++) {
+		fmt = &formats[k];
+		if (fmt->fourcc == f->fmt.pix.pixelformat)
+			break;
+	}
+
+	if (k == num_formats)
+		return NULL;
+
+	return &formats[k];
+}
+
+/*
+ * V4L2 ioctl() operations.
+ */
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, CODA_NAME, sizeof(cap->driver) - 1);
+	strncpy(cap->card, CODA_NAME, sizeof(cap->card) - 1);
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
+			  | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
+			enum coda_fmt_type type)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+	struct coda_dev *dev = ctx->dev;
+	struct coda_fmt *formats = dev->devtype->formats;
+	struct coda_fmt *fmt;
+	int num_formats = dev->devtype->num_formats;
+	int i, num = 0;
+
+	for (i = 0; i < num_formats; i++) {
+		if (formats[i].type == type) {
+			if (num == f->index)
+				break;
+			++num;
+		}
+	}
+
+	if (i < num_formats) {
+		fmt = &formats[i];
+		strlcpy(f->description, fmt->name, sizeof(f->description) - 1);
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
+	return enum_fmt(priv, f, CODA_FMT_ENC);
+}
+
+static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	return enum_fmt(priv, f, CODA_FMT_RAW);
+}
+
+static int vidioc_g_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
+{
+	struct vb2_queue *vq;
+	struct coda_q_data *q_data;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = get_q_data(ctx, f->type);
+
+	f->fmt.pix.field	= V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
+	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
+		f->fmt.pix.width	= q_data->width;
+		f->fmt.pix.height	= q_data->height;
+		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
+	} else { /* encoded formats h.264/mpeg4 */
+		f->fmt.pix.width	= 0;
+		f->fmt.pix.height	= 0;
+		f->fmt.pix.bytesperline = 0;
+	}
+	f->fmt.pix.sizeimage	= q_data->sizeimage;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	return vidioc_g_fmt(fh_to_ctx(priv), f);
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	return vidioc_g_fmt(fh_to_ctx(priv), f);
+}
+
+static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
+{
+	enum v4l2_field field;
+
+	if (!find_format(dev, f))
+		return -EINVAL;
+
+	field = f->fmt.pix.field;
+	if (field == V4L2_FIELD_ANY)
+		field = V4L2_FIELD_NONE;
+	else if (V4L2_FIELD_NONE != field)
+		return -EINVAL;
+
+	/* V4L2 specification suggests the driver corrects the format struct
+	 * if any of the dimensions is unsupported */
+	f->fmt.pix.field = field;
+
+	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
+		v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W,
+				      W_ALIGN, &f->fmt.pix.height,
+				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
+		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
+		f->fmt.pix.sizeimage = f->fmt.pix.height *
+					f->fmt.pix.bytesperline;
+	} else { /*encoded formats h.264/mpeg4 */
+		f->fmt.pix.bytesperline = CODA_MAX_FRAME_SIZE;
+		f->fmt.pix.sizeimage = CODA_MAX_FRAME_SIZE;
+	}
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct coda_fmt *fmt;
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	fmt = find_format(ctx->dev, f);
+	/*
+	 * Since decoding support is not implemented yet do not allow
+	 * CODA_FMT_RAW formats in the capture interface.
+	 */
+	if (!fmt || !(fmt->type == CODA_FMT_ENC)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	return vidioc_try_fmt(ctx->dev, f);
+}
+
+static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+	struct coda_fmt *fmt;
+
+	fmt = find_format(ctx->dev, f);
+	/*
+	 * Since decoding support is not implemented yet do not allow
+	 * CODA_FMT formats in the capture interface.
+	 */
+	if (!fmt || !(fmt->type == CODA_FMT_RAW)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	return vidioc_try_fmt(ctx->dev, f);
+}
+
+static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
+{
+	struct coda_q_data *q_data;
+	struct vb2_queue *vq;
+	int ret;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = get_q_data(ctx, f->type);
+	if (!q_data)
+		return -EINVAL;
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
+	ret = vidioc_try_fmt(ctx->dev, f);
+	if (ret)
+		return ret;
+
+	q_data->fmt		= find_format(ctx->dev, f);
+	if (q_data->fmt->fourcc == V4L2_PIX_FMT_YUV420) {
+		q_data->width		= f->fmt.pix.width;
+		q_data->height		= f->fmt.pix.height;
+		q_data->sizeimage = q_data->width * q_data->height * 3 / 2;
+	} else { /* encoded format h.264/mpeg-4 */
+		q_data->sizeimage = CODA_MAX_FRAME_SIZE;
+	}
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
+		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
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
+
+	return vidioc_s_fmt(fh_to_ctx(priv), f);
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
+	return vidioc_s_fmt(fh_to_ctx(priv), f);
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int vidioc_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	int ret;
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	ret = v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+	return ret;
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+static const struct v4l2_ioctl_ops coda_ioctl_ops = {
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
+/*
+ * Mem-to-mem operations.
+ */
+
+static int coda_isr(struct coda_dev *dev)
+{
+	struct coda_ctx *ctx;
+	struct vb2_buffer *src_buf, *dst_buf, *tmp_buf;
+	u32 wr_ptr, start_ptr;
+
+	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
+	if (ctx == NULL) {
+		v4l2_err(&dev->v4l2_dev, "Instance released before the end of transaction\n");
+		return IRQ_HANDLED;
+	}
+
+	if (ctx->aborting) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "task has been aborted\n");
+		return IRQ_HANDLED;
+	}
+
+	if (coda_isbusy(ctx->dev)) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "coda is still busy!!!!\n");
+		return IRQ_NONE;
+	}
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+
+	/* Get results from the coda */
+	coda_read(dev, CODA_RET_ENC_PIC_TYPE);
+	start_ptr = coda_read(dev, CODA_CMD_ENC_PIC_BB_START);
+	wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx));
+	/* Calculate bytesused field */
+	if (dst_buf->v4l2_buf.sequence == 0) {
+		dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr) +
+						ctx->vpu_header_size[0] +
+						ctx->vpu_header_size[1] +
+						ctx->vpu_header_size[2];
+	} else {
+		dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr);
+	}
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "frame size = %u\n",
+		 wr_ptr - start_ptr);
+
+	coda_read(dev, CODA_RET_ENC_PIC_SLICE_NUM);
+	coda_read(dev, CODA_RET_ENC_PIC_FLAG);
+
+	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
+		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
+		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
+	} else {
+		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
+		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
+	}
+
+	/* Free previous reference picture if available */
+	if (ctx->reference) {
+		v4l2_m2m_buf_done(ctx->reference, VB2_BUF_STATE_DONE);
+		ctx->reference = NULL;
+	}
+
+	/*
+	 * For the last frame of the gop we don't need to save
+	 * a reference picture.
+	 */
+	v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	tmp_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	if (ctx->gopcounter == 0)
+		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+	else
+		ctx->reference = tmp_buf;
+
+	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
+
+	ctx->gopcounter--;
+	if (ctx->gopcounter < 0)
+		ctx->gopcounter = ctx->params.gop_size - 1;
+
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+		"job finished: encoding frame (%d) (%s)\n",
+		dst_buf->v4l2_buf.sequence,
+		(dst_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) ?
+		"KEYFRAME" : "PFRAME");
+
+	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
+
+	return IRQ_HANDLED;
+}
+
+static void coda_device_run(void *m2m_priv)
+{
+	struct coda_ctx *ctx = m2m_priv;
+	struct coda_q_data *q_data_src, *q_data_dst;
+	struct vb2_buffer *src_buf, *dst_buf;
+	struct coda_dev *dev = ctx->dev;
+	int force_ipicture;
+	int quant_param = 0;
+	u32 picture_y, picture_cb, picture_cr;
+	u32 pic_stream_buffer_addr, pic_stream_buffer_size;
+	u32 dst_fourcc;
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	dst_fourcc = q_data_dst->fmt->fourcc;
+
+	src_buf->v4l2_buf.sequence = ctx->isequence;
+	dst_buf->v4l2_buf.sequence = ctx->isequence;
+	ctx->isequence++;
+
+	/*
+	 * Workaround coda firmware BUG that only marks the first
+	 * frame as IDR. This is a problem for some decoders that can't
+	 * recover when a frame is lost.
+	 */
+	if (src_buf->v4l2_buf.sequence % ctx->params.gop_size) {
+		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
+		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
+	} else {
+		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
+		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
+	}
+
+	/*
+	 * Copy headers at the beginning of the first frame for H.264 only.
+	 * In MPEG4 they are already copied by the coda.
+	 */
+	if (src_buf->v4l2_buf.sequence == 0) {
+		pic_stream_buffer_addr =
+			vb2_dma_contig_plane_dma_addr(dst_buf, 0) +
+			ctx->vpu_header_size[0] +
+			ctx->vpu_header_size[1] +
+			ctx->vpu_header_size[2];
+		pic_stream_buffer_size = CODA_MAX_FRAME_SIZE -
+			ctx->vpu_header_size[0] -
+			ctx->vpu_header_size[1] -
+			ctx->vpu_header_size[2];
+		memcpy(vb2_plane_vaddr(dst_buf, 0),
+		       &ctx->vpu_header[0][0], ctx->vpu_header_size[0]);
+		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0],
+		       &ctx->vpu_header[1][0], ctx->vpu_header_size[1]);
+		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0] +
+			ctx->vpu_header_size[1], &ctx->vpu_header[2][0],
+			ctx->vpu_header_size[2]);
+	} else {
+		pic_stream_buffer_addr =
+			vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+		pic_stream_buffer_size = CODA_MAX_FRAME_SIZE;
+	}
+
+	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
+		force_ipicture = 1;
+		switch (dst_fourcc) {
+		case V4L2_PIX_FMT_H264:
+			quant_param = ctx->params.h264_intra_qp;
+			break;
+		case V4L2_PIX_FMT_MPEG4:
+			quant_param = ctx->params.mpeg4_intra_qp;
+			break;
+		default:
+			v4l2_warn(&ctx->dev->v4l2_dev,
+				"cannot set intra qp, fmt not supported\n");
+			break;
+		}
+	} else {
+		force_ipicture = 0;
+		switch (dst_fourcc) {
+		case V4L2_PIX_FMT_H264:
+			quant_param = ctx->params.h264_inter_qp;
+			break;
+		case V4L2_PIX_FMT_MPEG4:
+			quant_param = ctx->params.mpeg4_inter_qp;
+			break;
+		default:
+			v4l2_warn(&ctx->dev->v4l2_dev,
+				"cannot set inter qp, fmt not supported\n");
+			break;
+		}
+	}
+
+	/* submit */
+	coda_write(dev, 0, CODA_CMD_ENC_PIC_ROT_MODE);
+	coda_write(dev, quant_param, CODA_CMD_ENC_PIC_QS);
+
+
+	picture_y = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	picture_cb = picture_y + q_data_src->width * q_data_src->height;
+	picture_cr = picture_cb + q_data_src->width / 2 *
+			q_data_src->height / 2;
+
+	coda_write(dev, picture_y, CODA_CMD_ENC_PIC_SRC_ADDR_Y);
+	coda_write(dev, picture_cb, CODA_CMD_ENC_PIC_SRC_ADDR_CB);
+	coda_write(dev, picture_cr, CODA_CMD_ENC_PIC_SRC_ADDR_CR);
+	coda_write(dev, force_ipicture << 1 & 0x2,
+		   CODA_CMD_ENC_PIC_OPTION);
+
+	coda_write(dev, pic_stream_buffer_addr, CODA_CMD_ENC_PIC_BB_START);
+	coda_write(dev, pic_stream_buffer_size / 1024,
+		   CODA_CMD_ENC_PIC_BB_SIZE);
+	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
+}
+
+static int coda_job_ready(void *m2m_priv)
+{
+	struct coda_ctx *ctx = m2m_priv;
+
+	/*
+	 * For both 'P' and 'key' frame cases 1 picture
+	 * and 1 frame are needed.
+	 */
+	if (!(v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) >= 1) ||
+		!(v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) >= 1)) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "not ready: not enough video buffers.\n");
+		return 0;
+	}
+
+	/* For P frames a reference picture is needed too */
+	if ((ctx->gopcounter != (ctx->params.gop_size - 1)) &&
+	   (!ctx->reference)) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "not ready: reference picture not available.\n");
+		return 0;
+	}
+
+	if (coda_isbusy(ctx->dev)) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "not ready: coda is still busy.\n");
+		return 0;
+	}
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			"job ready\n");
+	return 1;
+}
+
+static void coda_job_abort(void *priv)
+{
+	struct coda_ctx *ctx = priv;
+	struct coda_dev *dev = ctx->dev;
+
+	ctx->aborting = 1;
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+		 "Aborting task\n");
+
+	v4l2_m2m_job_finish(dev->m2m_dev, ctx->m2m_ctx);
+}
+
+static void coda_lock(void *m2m_priv)
+{
+	struct coda_ctx *ctx = m2m_priv;
+	struct coda_dev *pcdev = ctx->dev;
+	mutex_lock(&pcdev->dev_mutex);
+}
+
+static void coda_unlock(void *m2m_priv)
+{
+	struct coda_ctx *ctx = m2m_priv;
+	struct coda_dev *pcdev = ctx->dev;
+	mutex_unlock(&pcdev->dev_mutex);
+}
+
+static struct v4l2_m2m_ops coda_m2m_ops = {
+	.device_run	= coda_device_run,
+	.job_ready	= coda_job_ready,
+	.job_abort	= coda_job_abort,
+	.lock		= coda_lock,
+	.unlock		= coda_unlock,
+};
+
+static void set_default_params(struct coda_ctx *ctx)
+{
+	struct coda_dev *dev = ctx->dev;
+
+	ctx->params.codec_mode = CODA_MODE_INVALID;
+	ctx->params.framerate = 30;
+	ctx->reference = NULL;
+	ctx->aborting = 0;
+
+	/* Default formats for output and input queues */
+	ctx->q_data[V4L2_M2M_SRC].fmt = &dev->devtype->formats[0];
+	ctx->q_data[V4L2_M2M_DST].fmt = &dev->devtype->formats[1];
+}
+
+/*
+ * Queue operations
+ */
+static int coda_queue_setup(struct vb2_queue *vq,
+				const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(vq);
+	unsigned int size;
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		*nbuffers = CODA_OUTPUT_BUFS;
+		if (fmt)
+			size = fmt->fmt.pix.width *
+				fmt->fmt.pix.height * 3 / 2;
+		else
+			size = CODA_MAX_WIDTH *
+				CODA_MAX_HEIGHT * 3 / 2;
+	} else {
+		*nbuffers = CODA_CAPTURE_BUFS;
+		size = CODA_MAX_FRAME_SIZE;
+	}
+
+	*nplanes = 1;
+	sizes[0] = size;
+
+	alloc_ctxs[0] = ctx->dev->alloc_ctx;
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+		 "get %d buffer(s) of size %d each.\n", *nbuffers, size);
+
+	return 0;
+}
+
+static int coda_buf_prepare(struct vb2_buffer *vb)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct coda_q_data *q_data;
+
+	q_data = get_q_data(ctx, vb->vb2_queue->type);
+
+	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
+		v4l2_warn(&ctx->dev->v4l2_dev,
+			  "%s data will not fit into plane (%lu < %lu)\n",
+			  __func__, vb2_plane_size(vb, 0),
+			  (long)q_data->sizeimage);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
+
+	return 0;
+}
+
+static void coda_buf_queue(struct vb2_buffer *vb)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+}
+
+static void coda_wait_prepare(struct vb2_queue *q)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(q);
+	coda_unlock(ctx);
+}
+
+static void coda_wait_finish(struct vb2_queue *q)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(q);
+	coda_lock(ctx);
+}
+
+static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(q);
+	struct coda_dev *dev = ctx->dev;
+	u32 bitstream_buf, bitstream_size;
+
+	if (count < 1)
+		return -EINVAL;
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		ctx->rawstreamon = 1;
+	else
+		ctx->compstreamon = 1;
+
+	if (ctx->rawstreamon & ctx->compstreamon) {
+		struct coda_q_data *q_data_src, *q_data_dst;
+		u32 dst_fourcc;
+		struct vb2_buffer *buf;
+		struct vb2_queue *src_vq;
+		u32 value;
+		int i = 0;
+
+		ctx->gopcounter = ctx->params.gop_size - 1;
+
+		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+		bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
+		q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+		bitstream_size = q_data_dst->sizeimage;
+		dst_fourcc = q_data_dst->fmt->fourcc;
+
+		/* Find out whether coda must encode or decode */
+		if (q_data_src->fmt->type == CODA_FMT_RAW &&
+		    q_data_dst->fmt->type == CODA_FMT_ENC) {
+			ctx->inst_type = CODA_INST_ENCODER;
+		} else if (q_data_src->fmt->type == CODA_FMT_ENC &&
+			   q_data_dst->fmt->type == CODA_FMT_RAW) {
+			ctx->inst_type = CODA_INST_DECODER;
+			v4l2_err(&ctx->dev->v4l2_dev, "decoding not supported.\n");
+			return -EINVAL;
+		} else {
+			v4l2_err(&ctx->dev->v4l2_dev, "couldn't tell instance type.\n");
+			return -EINVAL;
+		}
+
+		if (!coda_is_initialized(dev)) {
+			v4l2_err(&ctx->dev->v4l2_dev, "coda is not initialized.\n");
+			return -EFAULT;
+		}
+		coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
+		coda_write(dev, bitstream_buf, CODA_REG_BIT_RD_PTR(ctx->idx));
+		coda_write(dev, bitstream_buf, CODA_REG_BIT_WR_PTR(ctx->idx));
+		switch (dev->devtype->product) {
+		case CODA_DX6:
+			/*
+			 * We should use (CODADX6_STREAM_BUF_PIC_RESET |
+			 * CODADX6_STREAM_BUF_PIC_FLUSH) but it doesn't work
+			 * with firmware 2.2.5.
+			 */
+			coda_write(dev, (3 << 3), CODA_REG_BIT_STREAM_CTRL);
+			break;
+		default:
+			coda_write(dev, CODA7_STREAM_BUF_PIC_RESET |
+				CODA7_STREAM_BUF_PIC_FLUSH, CODA_REG_BIT_STREAM_CTRL);
+		}
+
+		/* Configure the coda */
+		coda_write(dev, 0xffff4c00, CODA_REG_BIT_SEARCH_RAM_BASE_ADDR);
+
+		/* Could set rotation here if needed */
+		switch (dev->devtype->product) {
+		case CODA_DX6:
+			value = (q_data_src->width & CODADX6_PICWIDTH_MASK) << CODADX6_PICWIDTH_OFFSET;
+			break;
+		default:
+			value = (q_data_src->width & CODA7_PICWIDTH_MASK) << CODA7_PICWIDTH_OFFSET;
+		}
+		value |= (q_data_src->height & CODA_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
+		coda_write(dev, value, CODA_CMD_ENC_SEQ_SRC_SIZE);
+		coda_write(dev, ctx->params.framerate,
+			   CODA_CMD_ENC_SEQ_SRC_F_RATE);
+
+		switch (dst_fourcc) {
+		case V4L2_PIX_FMT_MPEG4:
+			ctx->params.codec_mode = (dev->devtype->product == CODA_DX6) ? CODADX6_MODE_ENCODE_MP4 : CODA7_MODE_ENCODE_MP4;
+			coda_write(dev, CODA_STD_MPEG4, CODA_CMD_ENC_SEQ_COD_STD);
+			value  = (0 & CODA_MP4PARAM_VERID_MASK) << CODA_MP4PARAM_VERID_OFFSET;
+			value |= (0 & CODA_MP4PARAM_INTRADCVLCTHR_MASK) << CODA_MP4PARAM_INTRADCVLCTHR_OFFSET;
+			value |= (0 & CODA_MP4PARAM_REVERSIBLEVLCENABLE_MASK) << CODA_MP4PARAM_REVERSIBLEVLCENABLE_OFFSET;
+			value |=  0 & CODA_MP4PARAM_DATAPARTITIONENABLE_MASK;
+			coda_write(dev, value, CODA_CMD_ENC_SEQ_MP4_PARA);
+			break;
+		case V4L2_PIX_FMT_H264:
+			ctx->params.codec_mode = (dev->devtype->product == CODA_DX6) ? CODADX6_MODE_ENCODE_H264 : CODA7_MODE_ENCODE_H264;
+			coda_write(dev, CODA_STD_H264, CODA_CMD_ENC_SEQ_COD_STD);
+			value  = (0 & CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK) << CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET;
+			value |= (0 & CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK) << CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET;
+			value |= (0 & CODA_264PARAM_DISABLEDEBLK_MASK) << CODA_264PARAM_DISABLEDEBLK_OFFSET;
+			value |= (0 & CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_MASK) << CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET;
+			value |=  0 & CODA_264PARAM_CHROMAQPOFFSET_MASK;
+			coda_write(dev, value, CODA_CMD_ENC_SEQ_264_PARA);
+			break;
+		default:
+			v4l2_err(&ctx->dev->v4l2_dev,
+				 "dst format (0x%08x) invalid.\n", dst_fourcc);
+			return -EINVAL;
+		}
+
+		value  = (ctx->params.slice_max_mb & CODA_SLICING_SIZE_MASK) << CODA_SLICING_SIZE_OFFSET;
+		value |= (1 & CODA_SLICING_UNIT_MASK) << CODA_SLICING_UNIT_OFFSET;
+		if (ctx->params.slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB)
+			value |=  1 & CODA_SLICING_MODE_MASK;
+		coda_write(dev, value, CODA_CMD_ENC_SEQ_SLICE_MODE);
+		value  =  ctx->params.gop_size & CODA_GOP_SIZE_MASK;
+		coda_write(dev, value, CODA_CMD_ENC_SEQ_GOP_SIZE);
+
+		if (ctx->params.bitrate) {
+			/* Rate control enabled */
+			value  = (0 & CODA_RATECONTROL_AUTOSKIP_MASK) << CODA_RATECONTROL_AUTOSKIP_OFFSET;
+			value |= (0 & CODA_RATECONTROL_INITIALDELAY_MASK) << CODA_RATECONTROL_INITIALDELAY_OFFSET;
+			value |= (ctx->params.bitrate & CODA_RATECONTROL_BITRATE_MASK) << CODA_RATECONTROL_BITRATE_OFFSET;
+			value |=  1 & CODA_RATECONTROL_ENABLE_MASK;
+		} else {
+			value = 0;
+		}
+		coda_write(dev, value, CODA_CMD_ENC_SEQ_RC_PARA);
+
+		coda_write(dev, 0, CODA_CMD_ENC_SEQ_RC_BUF_SIZE);
+		coda_write(dev, 0, CODA_CMD_ENC_SEQ_INTRA_REFRESH);
+
+		coda_write(dev, bitstream_buf, CODA_CMD_ENC_SEQ_BB_START);
+		coda_write(dev, bitstream_size / 1024, CODA_CMD_ENC_SEQ_BB_SIZE);
+
+		/* set default gamma */
+		value = (CODA_DEFAULT_GAMMA & CODA_GAMMA_MASK) << CODA_GAMMA_OFFSET;
+		coda_write(dev, value, CODA_CMD_ENC_SEQ_RC_GAMMA);
+
+		value  = (CODA_DEFAULT_GAMMA > 0) << CODA_OPTION_GAMMA_OFFSET;
+		value |= (0 & CODA_OPTION_SLICEREPORT_MASK) << CODA_OPTION_SLICEREPORT_OFFSET;
+		coda_write(dev, value, CODA_CMD_ENC_SEQ_OPTION);
+
+		if (dst_fourcc == V4L2_PIX_FMT_H264) {
+			value  = (FMO_SLICE_SAVE_BUF_SIZE << 7);
+			value |= (0 & CODA_FMOPARAM_TYPE_MASK) << CODA_FMOPARAM_TYPE_OFFSET;
+			value |=  0 & CODA_FMOPARAM_SLICENUM_MASK;
+			coda_write(dev, value, CODA_CMD_ENC_SEQ_FMO);
+		}
+
+		if (coda_command_sync(ctx, CODA_COMMAND_SEQ_INIT)) {
+			v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_SEQ_INIT timeout\n");
+			return -ETIMEDOUT;
+		}
+
+		if (coda_read(dev, CODA_RET_ENC_SEQ_SUCCESS) == 0)
+			return -EFAULT;
+
+		/*
+		 * Walk the src buffer list and let the codec know the
+		 * addresses of the pictures.
+		 */
+		src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		for (i = 0; i < src_vq->num_buffers; i++) {
+			u32 *p;
+
+			buf = src_vq->bufs[i];
+			p = ctx->parabuf.vaddr;
+
+			p[i * 3] = vb2_dma_contig_plane_dma_addr(buf, 0);
+			p[i * 3 + 1] = p[i * 3] + q_data_src->width *
+					q_data_src->height;
+			p[i * 3 + 2] = p[i * 3 + 1] + q_data_src->width / 2 *
+					q_data_src->height / 2;
+		}
+
+		coda_write(dev, src_vq->num_buffers, CODA_CMD_SET_FRAME_BUF_NUM);
+		coda_write(dev, q_data_src->width, CODA_CMD_SET_FRAME_BUF_STRIDE);
+		if (coda_command_sync(ctx, CODA_COMMAND_SET_FRAME_BUF)) {
+			v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_SET_FRAME_BUF timeout\n");
+			return -ETIMEDOUT;
+		}
+
+		/* Save stream headers */
+		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+		switch (dst_fourcc) {
+		case V4L2_PIX_FMT_H264:
+			/*
+			 * Get SPS in the first frame and copy it to an
+			 * intermediate buffer.
+			 */
+			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
+			coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
+			coda_write(dev, CODA_HEADER_H264_SPS, CODA_CMD_ENC_HEADER_CODE);
+			if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
+				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
+				return -ETIMEDOUT;
+			}
+			ctx->vpu_header_size[0] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
+					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+			memcpy(&ctx->vpu_header[0][0], vb2_plane_vaddr(buf, 0),
+			       ctx->vpu_header_size[0]);
+
+			/*
+			 * Get PPS in the first frame and copy it to an
+			 * intermediate buffer.
+			 */
+			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
+			coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
+			coda_write(dev, CODA_HEADER_H264_PPS, CODA_CMD_ENC_HEADER_CODE);
+			if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
+				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
+				return -ETIMEDOUT;
+			}
+			ctx->vpu_header_size[1] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
+					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+			memcpy(&ctx->vpu_header[1][0], vb2_plane_vaddr(buf, 0),
+			       ctx->vpu_header_size[1]);
+			ctx->vpu_header_size[2] = 0;
+			break;
+		case V4L2_PIX_FMT_MPEG4:
+			/*
+			 * Get VOS in the first frame and copy it to an
+			 * intermediate buffer
+			 */
+			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
+			coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
+			coda_write(dev, CODA_HEADER_MP4V_VOS, CODA_CMD_ENC_HEADER_CODE);
+			if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
+				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
+				return -ETIMEDOUT;
+			}
+			ctx->vpu_header_size[0] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
+					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+			memcpy(&ctx->vpu_header[0][0], vb2_plane_vaddr(buf, 0),
+			       ctx->vpu_header_size[0]);
+
+			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
+			coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
+			coda_write(dev, CODA_HEADER_MP4V_VIS, CODA_CMD_ENC_HEADER_CODE);
+			if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
+				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER failed\n");
+				return -ETIMEDOUT;
+			}
+			ctx->vpu_header_size[1] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
+					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+			memcpy(&ctx->vpu_header[1][0], vb2_plane_vaddr(buf, 0),
+			       ctx->vpu_header_size[1]);
+
+			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
+			coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
+			coda_write(dev, CODA_HEADER_MP4V_VOL, CODA_CMD_ENC_HEADER_CODE);
+			if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
+				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER failed\n");
+				return -ETIMEDOUT;
+			}
+			ctx->vpu_header_size[2] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
+					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+			memcpy(&ctx->vpu_header[2][0], vb2_plane_vaddr(buf, 0),
+			       ctx->vpu_header_size[2]);
+			break;
+		default:
+			/* No more formats need to save headers at the moment */
+			break;
+		}
+	}
+	return 0;
+}
+
+static int coda_stop_streaming(struct vb2_queue *q)
+{
+	struct coda_ctx *ctx = vb2_get_drv_priv(q);
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "%s: output\n", __func__);
+		ctx->rawstreamon = 0;
+	} else {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "%s: capture\n", __func__);
+		ctx->compstreamon = 0;
+	}
+
+	if (!ctx->rawstreamon && !ctx->compstreamon) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "%s: sent command 'SEQ_END' to coda\n", __func__);
+		if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
+			v4l2_err(&ctx->dev->v4l2_dev,
+				 "CODA_COMMAND_SEQ_END failed\n");
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+
+static struct vb2_ops coda_qops = {
+	.queue_setup		= coda_queue_setup,
+	.buf_prepare		= coda_buf_prepare,
+	.buf_queue		= coda_buf_queue,
+	.wait_prepare		= coda_wait_prepare,
+	.wait_finish		= coda_wait_finish,
+	.start_streaming	= coda_start_streaming,
+	.stop_streaming		= coda_stop_streaming,
+};
+
+static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct coda_ctx *ctx =
+			container_of(ctrl->handler, struct coda_ctx, ctrls);
+
+	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+		 "s_ctrl: id = %d, val = %d\n", ctrl->id, ctrl->val);
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		ctx->params.bitrate = ctrl->val / 1000;
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		ctx->params.gop_size = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
+		ctx->params.h264_intra_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:
+		ctx->params.h264_inter_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:
+		ctx->params.mpeg4_intra_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:
+		ctx->params.mpeg4_inter_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
+		ctx->params.slice_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:
+		ctx->params.slice_max_mb = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
+		break;
+	default:
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			"Invalid control, id=%d, val=%d\n",
+			ctrl->id, ctrl->val);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct v4l2_ctrl_ops coda_ctrl_ops = {
+	.s_ctrl = coda_s_ctrl,
+};
+
+static int coda_ctrls_setup(struct coda_ctx *ctx)
+{
+	v4l2_ctrl_handler_init(&ctx->ctrls, 9);
+
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1, 0);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 60, 1, 16);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 1, 51, 1, 25);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP, 1, 51, 1, 25);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP, 1, 31, 1, 2);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP, 1, 31, 1, 2);
+	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
+		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB, 0,
+		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB, 1, 0x3fffffff, 1, 1);
+	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_HEADER_MODE,
+		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
+		(1 << V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE),
+		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME);
+
+	return v4l2_ctrl_handler_setup(&ctx->ctrls);
+}
+
+static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
+{
+	struct coda_ctx *ctx = priv;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	src_vq->io_modes = VB2_MMAP;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->ops = &coda_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dst_vq->io_modes = VB2_MMAP;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->ops = &coda_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+
+	return vb2_queue_init(dst_vq);
+}
+
+static int coda_open(struct file *file)
+{
+	struct coda_dev *dev = video_drvdata(file);
+	struct coda_ctx *ctx = NULL;
+	int ret = 0;
+
+	if (dev->instances >= CODA_MAX_INSTANCES)
+		return -EBUSY;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+	ctx->dev = dev;
+
+	set_default_params(ctx);
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
+					 &coda_queue_init);
+	if (IS_ERR(ctx->m2m_ctx)) {
+		int ret = PTR_ERR(ctx->m2m_ctx);
+
+		v4l2_err(&dev->v4l2_dev, "%s return error (%d)\n",
+			 __func__, ret);
+		goto err;
+	}
+	ret = coda_ctrls_setup(ctx);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "failed to setup coda controls\n");
+
+		goto err;
+	}
+
+	ctx->fh.ctrl_handler = &ctx->ctrls;
+
+	ctx->parabuf.vaddr = dma_alloc_coherent(&dev->plat_dev->dev,
+			CODA_PARA_BUF_SIZE, &ctx->parabuf.paddr, GFP_KERNEL);
+	if (!ctx->parabuf.vaddr) {
+		v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	coda_lock(ctx);
+	ctx->idx = dev->instances++;
+	coda_unlock(ctx);
+
+	clk_prepare_enable(dev->clk_per);
+	clk_prepare_enable(dev->clk_ahb);
+
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d (%p)\n",
+		 ctx->idx, ctx);
+
+	return 0;
+
+err:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+	return ret;
+}
+
+static int coda_release(struct file *file)
+{
+	struct coda_dev *dev = video_drvdata(file);
+	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
+
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
+		 ctx);
+
+	coda_lock(ctx);
+	dev->instances--;
+	coda_unlock(ctx);
+
+	dma_free_coherent(&dev->plat_dev->dev, CODA_PARA_BUF_SIZE,
+		ctx->parabuf.vaddr, ctx->parabuf.paddr);
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_ctrl_handler_free(&ctx->ctrls);
+	clk_disable_unprepare(dev->clk_per);
+	clk_disable_unprepare(dev->clk_ahb);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+
+	return 0;
+}
+
+static unsigned int coda_poll(struct file *file,
+				 struct poll_table_struct *wait)
+{
+	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
+	int ret;
+
+	coda_lock(ctx);
+	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	coda_unlock(ctx);
+	return ret;
+}
+
+static int coda_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
+
+	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+}
+
+static const struct v4l2_file_operations coda_fops = {
+	.owner		= THIS_MODULE,
+	.open		= coda_open,
+	.release	= coda_release,
+	.poll		= coda_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= coda_mmap,
+};
+
+static irqreturn_t coda_irq_handler(int irq, void *data)
+{
+	struct coda_dev *dev = data;
+
+	/* read status register to attend the IRQ */
+	coda_read(dev, CODA_REG_BIT_INT_STATUS);
+	coda_write(dev, CODA_REG_BIT_INT_CLEAR_SET,
+		      CODA_REG_BIT_INT_CLEAR);
+
+	return coda_isr(dev);
+}
+
+static u32 coda_supported_firmwares[] = {
+	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
+};
+
+static bool coda_firmware_supported(u32 vernum)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(coda_supported_firmwares); i++)
+		if (vernum == coda_supported_firmwares[i])
+			return true;
+	return false;
+}
+
+static char *coda_product_name(int product)
+{
+	static char buf[9];
+
+	switch (product) {
+	case CODA_DX6:
+		return "CodaDx6";
+	default:
+		snprintf(buf, sizeof(buf), "(0x%04x)", product);
+		return buf;
+	}
+}
+
+static int coda_hw_init(struct coda_dev *dev, const struct firmware *fw)
+{
+	u16 product, major, minor, release;
+	u32 data;
+	u16 *p;
+	int i;
+
+	clk_prepare_enable(dev->clk_per);
+	clk_prepare_enable(dev->clk_ahb);
+
+	/* Copy the whole firmware image to the code buffer */
+	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
+	/*
+	 * Copy the first CODA_ISRAM_SIZE in the internal SRAM.
+	 * This memory seems to be big-endian here, which is weird, since
+	 * the internal ARM processor of the coda is little endian.
+	 * Data in this SRAM survives a reboot.
+	 */
+	p = (u16 *)fw->data;
+	for (i = 0; i < (CODA_ISRAM_SIZE / 2); i++)  {
+		data = CODA_DOWN_ADDRESS_SET(i) |
+			CODA_DOWN_DATA_SET(p[i ^ 1]);
+		coda_write(dev, data, CODA_REG_BIT_CODE_DOWN);
+	}
+	release_firmware(fw);
+
+	/* Tell the BIT where to find everything it needs */
+	coda_write(dev, dev->workbuf.paddr,
+		      CODA_REG_BIT_WORK_BUF_ADDR);
+	coda_write(dev, dev->codebuf.paddr,
+		      CODA_REG_BIT_CODE_BUF_ADDR);
+	coda_write(dev, 0, CODA_REG_BIT_CODE_RUN);
+
+	/* Set default values */
+	switch (dev->devtype->product) {
+	case CODA_DX6:
+		coda_write(dev, CODADX6_STREAM_BUF_PIC_FLUSH, CODA_REG_BIT_STREAM_CTRL);
+		break;
+	default:
+		coda_write(dev, CODA7_STREAM_BUF_PIC_FLUSH, CODA_REG_BIT_STREAM_CTRL);
+	}
+	coda_write(dev, 0, CODA_REG_BIT_FRAME_MEM_CTRL);
+	coda_write(dev, CODA_INT_INTERRUPT_ENABLE,
+		      CODA_REG_BIT_INT_ENABLE);
+
+	/* Reset VPU and start processor */
+	data = coda_read(dev, CODA_REG_BIT_CODE_RESET);
+	data |= CODA_REG_RESET_ENABLE;
+	coda_write(dev, data, CODA_REG_BIT_CODE_RESET);
+	udelay(10);
+	data &= ~CODA_REG_RESET_ENABLE;
+	coda_write(dev, data, CODA_REG_BIT_CODE_RESET);
+	coda_write(dev, CODA_REG_RUN_ENABLE, CODA_REG_BIT_CODE_RUN);
+
+	/* Load firmware */
+	coda_write(dev, 0, CODA_CMD_FIRMWARE_VERNUM);
+	coda_write(dev, CODA_REG_BIT_BUSY_FLAG, CODA_REG_BIT_BUSY);
+	coda_write(dev, 0, CODA_REG_BIT_RUN_INDEX);
+	coda_write(dev, 0, CODA_REG_BIT_RUN_COD_STD);
+	coda_write(dev, CODA_COMMAND_FIRMWARE_GET, CODA_REG_BIT_RUN_COMMAND);
+	if (coda_wait_timeout(dev)) {
+		clk_disable_unprepare(dev->clk_per);
+		clk_disable_unprepare(dev->clk_ahb);
+		v4l2_err(&dev->v4l2_dev, "firmware get command error\n");
+		return -EIO;
+	}
+
+	/* Check we are compatible with the loaded firmware */
+	data = coda_read(dev, CODA_CMD_FIRMWARE_VERNUM);
+	product = CODA_FIRMWARE_PRODUCT(data);
+	major = CODA_FIRMWARE_MAJOR(data);
+	minor = CODA_FIRMWARE_MINOR(data);
+	release = CODA_FIRMWARE_RELEASE(data);
+
+	clk_disable_unprepare(dev->clk_per);
+	clk_disable_unprepare(dev->clk_ahb);
+
+	if (product != dev->devtype->product) {
+		v4l2_err(&dev->v4l2_dev, "Wrong firmware. Hw: %s, Fw: %s,"
+			 " Version: %u.%u.%u\n",
+			 coda_product_name(dev->devtype->product),
+			 coda_product_name(product), major, minor, release);
+		return -EINVAL;
+	}
+
+	v4l2_info(&dev->v4l2_dev, "Initialized %s.\n",
+		  coda_product_name(product));
+
+	if (coda_firmware_supported(data)) {
+		v4l2_info(&dev->v4l2_dev, "Firmware version: %u.%u.%u\n",
+			  major, minor, release);
+	} else {
+		v4l2_warn(&dev->v4l2_dev, "Unsupported firmware version: "
+			  "%u.%u.%u\n", major, minor, release);
+	}
+
+	return 0;
+}
+
+static void coda_fw_callback(const struct firmware *fw, void *context)
+{
+	struct coda_dev *dev = context;
+	struct platform_device *pdev = dev->plat_dev;
+	struct video_device *vfd;
+	int ret;
+
+	if (!fw) {
+		v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
+		return;
+	}
+
+	/* allocate auxiliary per-device code buffer for the BIT processor */
+	dev->codebuf_size = fw->size;
+	dev->codebuf.vaddr = dma_alloc_coherent(&pdev->dev, fw->size,
+						    &dev->codebuf.paddr,
+						    GFP_KERNEL);
+	if (!dev->codebuf.vaddr) {
+		dev_err(&pdev->dev, "failed to allocate code buffer\n");
+		return;
+	}
+
+	ret = coda_hw_init(dev, fw);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
+		return;
+	}
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		return;
+	}
+
+	vfd->fops	= &coda_fops,
+	vfd->ioctl_ops	= &coda_ioctl_ops;
+	vfd->release	= video_device_release,
+	vfd->lock	= &dev->dev_mutex;
+	vfd->v4l2_dev	= &dev->v4l2_dev;
+	snprintf(vfd->name, sizeof(vfd->name), "%s", CODA_NAME);
+	dev->vfd = vfd;
+	video_set_drvdata(vfd, dev);
+
+	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(dev->alloc_ctx)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
+		goto rel_vdev;
+	}
+
+	dev->m2m_dev = v4l2_m2m_init(&coda_m2m_ops);
+	if (IS_ERR(dev->m2m_dev)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
+		goto rel_ctx;
+	}
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto rel_m2m;
+	}
+	v4l2_info(&dev->v4l2_dev, "codec registered as /dev/video%d\n",
+		  vfd->num);
+
+	return;
+
+rel_m2m:
+	v4l2_m2m_release(dev->m2m_dev);
+rel_ctx:
+	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+rel_vdev:
+	video_device_release(vfd);
+
+	return;
+}
+
+static int coda_firmware_request(struct coda_dev *dev)
+{
+	char *fw = dev->devtype->firmware;
+
+	dev_dbg(&dev->plat_dev->dev, "requesting firmware '%s' for %s\n", fw,
+		coda_product_name(dev->devtype->product));
+
+	return request_firmware_nowait(THIS_MODULE, true,
+		fw, &dev->plat_dev->dev, GFP_KERNEL, dev, coda_fw_callback);
+}
+
+enum coda_platform {
+	CODA_IMX27,
+};
+
+static struct coda_devtype coda_devdata[] = {
+	[CODA_IMX27] = {
+		.firmware    = "v4l-codadx6-imx27.bin",
+		.product     = CODA_DX6,
+		.formats     = codadx6_formats,
+		.num_formats = ARRAY_SIZE(codadx6_formats),
+	},
+};
+
+static struct platform_device_id coda_platform_ids[] = {
+	{ .name = "coda-imx27", .driver_data = CODA_IMX27 },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(platform, coda_platform_ids);
+
+#ifdef CONFIG_OF
+static const struct of_device_id coda_dt_ids[] = {
+	{ .compatible = "fsl,imx27-vpu", .data = &coda_platform_ids[CODA_IMX27] },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(platform, coda_dt_ids);
+#endif
+
+static int __devinit coda_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *of_id =
+			of_match_device(of_match_ptr(coda_dt_ids), &pdev->dev);
+	const struct platform_device_id *pdev_id;
+	struct coda_dev *dev;
+	struct resource *res;
+	unsigned int bufsize;
+	int ret;
+
+	dev = devm_kzalloc(&pdev->dev, sizeof *dev, GFP_KERNEL);
+	if (!dev) {
+		dev_err(&pdev->dev, "Not enough memory for %s\n",
+			CODA_NAME);
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&dev->irqlock);
+
+	dev->plat_dev = pdev;
+	dev->clk_per = devm_clk_get(&pdev->dev, "per");
+	if (IS_ERR(dev->clk_per)) {
+		dev_err(&pdev->dev, "Could not get per clock\n");
+		return PTR_ERR(dev->clk_per);
+	}
+
+	dev->clk_ahb = devm_clk_get(&pdev->dev, "ahb");
+	if (IS_ERR(dev->clk_ahb)) {
+		dev_err(&pdev->dev, "Could not get ahb clock\n");
+		return PTR_ERR(dev->clk_ahb);
+	}
+
+	/* Get  memory for physical registers */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get memory region resource\n");
+		return -ENOENT;
+	}
+
+	if (devm_request_mem_region(&pdev->dev, res->start,
+			resource_size(res), CODA_NAME) == NULL) {
+		dev_err(&pdev->dev, "failed to request memory region\n");
+		return -ENOENT;
+	}
+	dev->regs_base = devm_ioremap(&pdev->dev, res->start,
+				      resource_size(res));
+	if (!dev->regs_base) {
+		dev_err(&pdev->dev, "failed to ioremap address region\n");
+		return -ENOENT;
+	}
+
+	/* IRQ */
+	dev->irq = platform_get_irq(pdev, 0);
+	if (dev->irq < 0) {
+		dev_err(&pdev->dev, "failed to get irq resource\n");
+		return -ENOENT;
+	}
+
+	if (devm_request_irq(&pdev->dev, dev->irq, coda_irq_handler,
+		0, CODA_NAME, dev) < 0) {
+		dev_err(&pdev->dev, "failed to request irq\n");
+		return -ENOENT;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		return ret;
+
+	mutex_init(&dev->dev_mutex);
+
+	pdev_id = of_id ? of_id->data : platform_get_device_id(pdev);
+
+	if (of_id)
+		dev->devtype = of_id->data;
+	else if (pdev_id)
+		dev->devtype = &coda_devdata[pdev_id->driver_data];
+	else
+		return -EINVAL;
+
+	/* allocate auxiliary per-device buffers for the BIT processor */
+	switch (dev->devtype->product) {
+	case CODA_DX6:
+		bufsize = CODADX6_WORK_BUF_SIZE;
+		break;
+	default:
+		bufsize = CODA7_WORK_BUF_SIZE;
+	}
+	dev->workbuf.vaddr = dma_alloc_coherent(&pdev->dev, bufsize,
+						    &dev->workbuf.paddr,
+						    GFP_KERNEL);
+	if (!dev->workbuf.vaddr) {
+		dev_err(&pdev->dev, "failed to allocate work buffer\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, dev);
+
+	return coda_firmware_request(dev);
+}
+
+static int coda_remove(struct platform_device *pdev)
+{
+	struct coda_dev *dev = platform_get_drvdata(pdev);
+	unsigned int bufsize;
+
+	switch (dev->devtype->product) {
+	case CODA_DX6:
+		bufsize = CODADX6_WORK_BUF_SIZE;
+		break;
+	default:
+		bufsize = CODA7_WORK_BUF_SIZE;
+	}
+
+	video_unregister_device(dev->vfd);
+	v4l2_m2m_release(dev->m2m_dev);
+	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+	video_device_release(dev->vfd);
+	if (dev->codebuf.vaddr)
+		dma_free_coherent(&pdev->dev, dev->codebuf_size,
+				  &dev->codebuf.vaddr, dev->codebuf.paddr);
+	dma_free_coherent(&pdev->dev, bufsize, &dev->workbuf.vaddr,
+			  dev->workbuf.paddr);
+	return 0;
+}
+
+static struct platform_driver coda_driver = {
+	.probe	= coda_probe,
+	.remove	= __devexit_p(coda_remove),
+	.driver	= {
+		.name	= CODA_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(coda_dt_ids),
+	},
+	.id_table = coda_platform_ids,
+};
+
+module_platform_driver(coda_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Javier Martin <javier.martin@vista-silicon.com>");
+MODULE_DESCRIPTION("Coda multi-standard codec V4L2 driver");
diff --git a/drivers/media/video/coda.h b/drivers/media/video/coda.h
new file mode 100644
index 0000000..454d5f0
--- /dev/null
+++ b/drivers/media/video/coda.h
@@ -0,0 +1,214 @@
+/*
+ * linux/drivers/media/video/coda/coda_regs.h
+ *
+ * Copyright (C) 2012 Vista Silicon SL
+ *    Javier Martin <javier.martin@vista-silicon.com>
+ *    Xavier Duret
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _REGS_CODA_H_
+#define _REGS_CODA_H_
+
+/* HW registers */
+#define CODA_REG_BIT_CODE_RUN			0x000
+#define		CODA_REG_RUN_ENABLE		(1 << 0)
+#define CODA_REG_BIT_CODE_DOWN			0x004
+#define		CODA_DOWN_ADDRESS_SET(x)	(((x) & 0xffff) << 16)
+#define		CODA_DOWN_DATA_SET(x)		((x) & 0xffff)
+#define CODA_REG_BIT_HOST_IN_REQ		0x008
+#define CODA_REG_BIT_INT_CLEAR			0x00c
+#define		CODA_REG_BIT_INT_CLEAR_SET	0x1
+#define CODA_REG_BIT_INT_STATUS		0x010
+#define CODA_REG_BIT_CODE_RESET		0x014
+#define		CODA_REG_RESET_ENABLE		(1 << 0)
+#define CODA_REG_BIT_CUR_PC			0x018
+
+/* Static SW registers */
+#define CODA_REG_BIT_CODE_BUF_ADDR		0x100
+#define CODA_REG_BIT_WORK_BUF_ADDR		0x104
+#define CODA_REG_BIT_PARA_BUF_ADDR		0x108
+#define CODA_REG_BIT_STREAM_CTRL		0x10c
+#define		CODA7_STREAM_BUF_PIC_RESET	(1 << 4)
+#define		CODADX6_STREAM_BUF_PIC_RESET	(1 << 3)
+#define		CODA7_STREAM_BUF_PIC_FLUSH	(1 << 3)
+#define		CODADX6_STREAM_BUF_PIC_FLUSH	(1 << 2)
+#define 	CODA_STREAM_CHKDIS_OFFSET	(1 << 1)
+#define		CODA_STREAM_ENDIAN_SELECT	(1 << 0)
+#define CODA_REG_BIT_FRAME_MEM_CTRL		0x110
+#define		CODA_IMAGE_ENDIAN_SELECT	(1 << 0)
+#define CODA_REG_BIT_RD_PTR(x)			(0x120 + 8 * (x))
+#define CODA_REG_BIT_WR_PTR(x)			(0x124 + 8 * (x))
+#define CODA_REG_BIT_SEARCH_RAM_BASE_ADDR	0x140
+#define CODA_REG_BIT_BUSY			0x160
+#define		CODA_REG_BIT_BUSY_FLAG		1
+#define CODA_REG_BIT_RUN_COMMAND		0x164
+#define		CODA_COMMAND_SEQ_INIT		1
+#define		CODA_COMMAND_SEQ_END		2
+#define		CODA_COMMAND_PIC_RUN		3
+#define		CODA_COMMAND_SET_FRAME_BUF	4
+#define		CODA_COMMAND_ENCODE_HEADER	5
+#define		CODA_COMMAND_ENC_PARA_SET	6
+#define		CODA_COMMAND_DEC_PARA_SET	7
+#define		CODA_COMMAND_DEC_BUF_FLUSH	8
+#define		CODA_COMMAND_RC_CHANGE_PARAMETER 9
+#define		CODA_COMMAND_FIRMWARE_GET	0xf
+#define CODA_REG_BIT_RUN_INDEX			0x168
+#define		CODA_INDEX_SET(x)		((x) & 0x3)
+#define CODA_REG_BIT_RUN_COD_STD		0x16c
+#define		CODADX6_MODE_DECODE_MP4		0
+#define		CODADX6_MODE_ENCODE_MP4		1
+#define		CODADX6_MODE_DECODE_H264	2
+#define		CODADX6_MODE_ENCODE_H264	3
+#define		CODA7_MODE_DECODE_H264		0
+#define		CODA7_MODE_DECODE_VC1		1
+#define		CODA7_MODE_DECODE_MP2		2
+#define		CODA7_MODE_DECODE_MP4		3
+#define		CODA7_MODE_DECODE_DV3		3
+#define		CODA7_MODE_DECODE_RV		4
+#define		CODA7_MODE_DECODE_MJPG		5
+#define		CODA7_MODE_ENCODE_H264		8
+#define		CODA7_MODE_ENCODE_MP4		11
+#define		CODA7_MODE_ENCODE_MJPG		13
+#define 	CODA_MODE_INVALID		0xffff
+#define CODA_REG_BIT_INT_ENABLE		0x170
+#define		CODA_INT_INTERRUPT_ENABLE	(1 << 3)
+
+/*
+ * Commands' mailbox:
+ * registers with offsets in the range 0x180-0x1d0
+ * have different meaning depending on the command being
+ * issued.
+ */
+
+/* Encoder Sequence Initialization */
+#define CODA_CMD_ENC_SEQ_BB_START				0x180
+#define CODA_CMD_ENC_SEQ_BB_SIZE				0x184
+#define CODA_CMD_ENC_SEQ_OPTION				0x188
+#define		CODA_OPTION_GAMMA_OFFSET			7
+#define		CODA_OPTION_GAMMA_MASK				0x01
+#define		CODA_OPTION_LIMITQP_OFFSET			6
+#define		CODA_OPTION_LIMITQP_MASK			0x01
+#define		CODA_OPTION_RCINTRAQP_OFFSET			5
+#define		CODA_OPTION_RCINTRAQP_MASK			0x01
+#define		CODA_OPTION_FMO_OFFSET				4
+#define		CODA_OPTION_FMO_MASK				0x01
+#define		CODA_OPTION_SLICEREPORT_OFFSET			1
+#define		CODA_OPTION_SLICEREPORT_MASK			0x01
+#define CODA_CMD_ENC_SEQ_COD_STD				0x18c
+#define		CODA_STD_MPEG4					0
+#define		CODA_STD_H263					1
+#define		CODA_STD_H264					2
+#define		CODA_STD_MJPG					3
+#define CODA_CMD_ENC_SEQ_SRC_SIZE				0x190
+#define		CODA7_PICWIDTH_OFFSET				16
+#define		CODA7_PICWIDTH_MASK				0xffff
+#define		CODADX6_PICWIDTH_OFFSET				10
+#define		CODADX6_PICWIDTH_MASK				0x3ff
+#define		CODA_PICHEIGHT_OFFSET				0
+#define		CODA_PICHEIGHT_MASK				0x3ff
+#define CODA_CMD_ENC_SEQ_SRC_F_RATE				0x194
+#define CODA_CMD_ENC_SEQ_MP4_PARA				0x198
+#define		CODA_MP4PARAM_VERID_OFFSET			6
+#define		CODA_MP4PARAM_VERID_MASK			0x01
+#define		CODA_MP4PARAM_INTRADCVLCTHR_OFFSET		2
+#define		CODA_MP4PARAM_INTRADCVLCTHR_MASK		0x07
+#define		CODA_MP4PARAM_REVERSIBLEVLCENABLE_OFFSET	1
+#define		CODA_MP4PARAM_REVERSIBLEVLCENABLE_MASK		0x01
+#define		CODA_MP4PARAM_DATAPARTITIONENABLE_OFFSET	0
+#define		CODA_MP4PARAM_DATAPARTITIONENABLE_MASK		0x01
+#define CODA_CMD_ENC_SEQ_263_PARA				0x19c
+#define		CODA_263PARAM_ANNEXJENABLE_OFFSET		2
+#define		CODA_263PARAM_ANNEXJENABLE_MASK		0x01
+#define		CODA_263PARAM_ANNEXKENABLE_OFFSET		1
+#define		CODA_263PARAM_ANNEXKENABLE_MASK		0x01
+#define		CODA_263PARAM_ANNEXTENABLE_OFFSET		0
+#define		CODA_263PARAM_ANNEXTENABLE_MASK		0x01
+#define CODA_CMD_ENC_SEQ_264_PARA				0x1a0
+#define		CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET	12
+#define		CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK	0x0f
+#define		CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET	8
+#define		CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK	0x0f
+#define		CODA_264PARAM_DISABLEDEBLK_OFFSET		6
+#define		CODA_264PARAM_DISABLEDEBLK_MASK		0x01
+#define		CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET	5
+#define		CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_MASK	0x01
+#define		CODA_264PARAM_CHROMAQPOFFSET_OFFSET		0
+#define		CODA_264PARAM_CHROMAQPOFFSET_MASK		0x1f
+#define CODA_CMD_ENC_SEQ_SLICE_MODE				0x1a4
+#define		CODA_SLICING_SIZE_OFFSET			2
+#define		CODA_SLICING_SIZE_MASK				0x3fffffff
+#define		CODA_SLICING_UNIT_OFFSET			1
+#define		CODA_SLICING_UNIT_MASK				0x01
+#define		CODA_SLICING_MODE_OFFSET			0
+#define		CODA_SLICING_MODE_MASK				0x01
+#define CODA_CMD_ENC_SEQ_GOP_SIZE				0x1a8
+#define		CODA_GOP_SIZE_OFFSET				0
+#define		CODA_GOP_SIZE_MASK				0x3f
+#define CODA_CMD_ENC_SEQ_RC_PARA				0x1ac
+#define		CODA_RATECONTROL_AUTOSKIP_OFFSET		31
+#define		CODA_RATECONTROL_AUTOSKIP_MASK			0x01
+#define		CODA_RATECONTROL_INITIALDELAY_OFFSET		16
+#define		CODA_RATECONTROL_INITIALDELAY_MASK		0x7f
+#define		CODA_RATECONTROL_BITRATE_OFFSET		1
+#define		CODA_RATECONTROL_BITRATE_MASK			0x7f
+#define		CODA_RATECONTROL_ENABLE_OFFSET			0
+#define		CODA_RATECONTROL_ENABLE_MASK			0x01
+#define CODA_CMD_ENC_SEQ_RC_BUF_SIZE				0x1b0
+#define CODA_CMD_ENC_SEQ_INTRA_REFRESH				0x1b4
+#define CODA_CMD_ENC_SEQ_FMO					0x1b8
+#define		CODA_FMOPARAM_TYPE_OFFSET			4
+#define		CODA_FMOPARAM_TYPE_MASK				1
+#define		CODA_FMOPARAM_SLICENUM_OFFSET			0
+#define		CODA_FMOPARAM_SLICENUM_MASK			0x0f
+#define CODA_CMD_ENC_SEQ_RC_QP_MAX				0x1c8
+#define		CODA_QPMAX_OFFSET				0
+#define		CODA_QPMAX_MASK					0x3f
+#define CODA_CMD_ENC_SEQ_RC_GAMMA				0x1cc
+#define		CODA_GAMMA_OFFSET				0
+#define		CODA_GAMMA_MASK					0xffff
+#define CODA_RET_ENC_SEQ_SUCCESS				0x1c0
+
+/* Encoder Picture Run */
+#define CODA_CMD_ENC_PIC_SRC_ADDR_Y	0x180
+#define CODA_CMD_ENC_PIC_SRC_ADDR_CB	0x184
+#define CODA_CMD_ENC_PIC_SRC_ADDR_CR	0x188
+#define CODA_CMD_ENC_PIC_QS		0x18c
+#define CODA_CMD_ENC_PIC_ROT_MODE	0x190
+#define CODA_CMD_ENC_PIC_OPTION	0x194
+#define CODA_CMD_ENC_PIC_BB_START	0x198
+#define CODA_CMD_ENC_PIC_BB_SIZE	0x19c
+#define CODA_RET_ENC_PIC_TYPE		0x1c4
+#define CODA_RET_ENC_PIC_SLICE_NUM	0x1cc
+#define CODA_RET_ENC_PIC_FLAG		0x1d0
+
+/* Set Frame Buffer */
+#define CODA_CMD_SET_FRAME_BUF_NUM	0x180
+#define CODA_CMD_SET_FRAME_BUF_STRIDE	0x184
+
+/* Encoder Header */
+#define CODA_CMD_ENC_HEADER_CODE	0x180
+#define		CODA_GAMMA_OFFSET	0
+#define		CODA_HEADER_H264_SPS	0
+#define		CODA_HEADER_H264_PPS	1
+#define		CODA_HEADER_MP4V_VOL	0
+#define		CODA_HEADER_MP4V_VOS	1
+#define		CODA_HEADER_MP4V_VIS	2
+#define CODA_CMD_ENC_HEADER_BB_START	0x184
+#define CODA_CMD_ENC_HEADER_BB_SIZE	0x188
+
+/* Get Version */
+#define CODA_CMD_FIRMWARE_VERNUM		0x1c0
+#define		CODA_FIRMWARE_PRODUCT(x)	(((x) >> 16) & 0xffff)
+#define		CODA_FIRMWARE_MAJOR(x)		(((x) >> 12) & 0x0f)
+#define		CODA_FIRMWARE_MINOR(x)		(((x) >> 8) & 0x0f)
+#define		CODA_FIRMWARE_RELEASE(x)	((x) & 0xff)
+#define		CODA_FIRMWARE_VERNUM(product, major, minor, release)	\
+			((product) << 16 | ((major) << 12) |		\
+			((minor) << 8) | (release))
+
+#endif
-- 
1.7.9.5

