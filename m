Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23146 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbZLWKI6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 05:08:58 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 23 Dec 2009 11:08:52 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH 2/2] [ARM] samsung-rotator: Add Samsung S3C/S5P rotator driver
In-reply-to: <1261562933-26987-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1261562933-26987-3-git-send-email-p.osciak@samsung.com>
References: <1261562933-26987-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rotator device present on Samsung S3C and S5P series SoCs allows image
rotation and flipping. It requires contiguous memory buffers to operate,
as it does not have scatter-gather support. It is also an example of
a memory-to-memory device, and so uses the mem-2-mem device V4L2 framework.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig                       |   10 +
 drivers/media/video/Makefile                      |    2 +
 drivers/media/video/samsung-rotator/Makefile      |    1 +
 drivers/media/video/samsung-rotator/s3c_rotator.c | 1026 +++++++++++++++++++++
 4 files changed, 1039 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/samsung-rotator/Makefile
 create mode 100644 drivers/media/video/samsung-rotator/s3c_rotator.c

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 6fe4b53..b6040bd 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1100,4 +1100,14 @@ config VIDEO_MEM2MEM_TESTDEV
 	  This is a virtual test device for the memory-to-memory driver
 	  framework.
 
+config VIDEO_SAMSUNG_ROTATOR
+	tristate "Samsung S3C/S5P embedded image rotator"
+	depends on VIDEO_V4L2
+	select VIDEOBUF_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	default n
+	help
+	  An image rotator device present on Samsung S3C and S5P series SoCs
+	  allows image rotation and flipping.
+
 endif # V4L_MEM2MEM_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 8667f1c..72196df 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -172,6 +172,8 @@ obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 
 obj-$(CONFIG_ARCH_DAVINCI)	+= davinci/
 
+obj-$(CONFIG_VIDEO_SAMSUNG_ROTATOR)	+= samsung-rotator/
+
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff --git a/drivers/media/video/samsung-rotator/Makefile b/drivers/media/video/samsung-rotator/Makefile
new file mode 100644
index 0000000..9ce9ee9
--- /dev/null
+++ b/drivers/media/video/samsung-rotator/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_SAMSUNG_ROTATOR) += s3c_rotator.o
diff --git a/drivers/media/video/samsung-rotator/s3c_rotator.c b/drivers/media/video/samsung-rotator/s3c_rotator.c
new file mode 100644
index 0000000..83f9059
--- /dev/null
+++ b/drivers/media/video/samsung-rotator/s3c_rotator.c
@@ -0,0 +1,1026 @@
+/*
+ * Samsung S3C/S5P image rotator driver.
+ *
+ * Copyright (c) 2009 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <p.osciak@samsung.com>
+ * Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <asm/io.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf-dma-contig.h>
+
+#include <plat/regs-rotator.h>
+
+#define S3C_ROTATOR_NAME	"s3c-rotator"
+#define S3C_ROTATOR_MEM_LIMIT	(16 * 1024 * 1024)
+#define S3C_ROTATOR_MAX_WIDTH	2048
+#define S3C_ROTATOR_MAX_HEIGHT	2048
+
+/*#define S3C_ROTATOR_DEBUG_REGWRITE*/
+#ifdef S3C_ROTATOR_DEBUG_REGWRITE
+#undef writel
+#define writel(v, r) do { \
+	printk(KERN_DEBUG "%s: %08x => %p\n", __func__, (unsigned int)v, r); \
+	__raw_writel(v, r); } while(0)
+#endif /* S3C_ROTATOR_DEBUG_REGWRITE */
+
+#define V4L2_CID_PRIVATE_ROTATE (V4L2_CID_PRIVATE_BASE + 0)
+
+struct s3c_rotator_fmt {
+	char	*name;
+	u32	fourcc;
+	u32	depth;
+};
+
+/* Input/output formats (no conversion) */
+static struct s3c_rotator_fmt formats[] = {
+	{
+		.name	= "4:2:2, packed, YUYV",
+		.fourcc	= V4L2_PIX_FMT_YUYV,
+		.depth	= 16,
+	},
+	{
+		.name	= "4:2:0, planar YUV",
+		.fourcc	= V4L2_PIX_FMT_YUV420,
+		.depth	= 12,
+	},
+	{
+		.name	= "BGR565X",
+		.fourcc	= V4L2_PIX_FMT_RGB565X,
+		.depth	= 16,
+	},
+	{
+		.name	= "BGRA8888",
+		.fourcc	= V4L2_PIX_FMT_BGR32,
+		.depth	= 32,
+	},
+};
+
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
+/*
+ * The device can only do one operation at a time,
+ * i.e. simultaneous rotation + flip is not possible
+ */
+static struct v4l2_queryctrl s3c_rotator_ctrls[] = {
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
+		.id		= V4L2_CID_PRIVATE_ROTATE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Rotation (CCW)",
+		.minimum	= 90,
+		.maximum	= 270,
+		.step		= 90,
+		.default_value	= 0,
+	},
+};
+
+static struct v4l2_queryctrl *get_ctrl(int id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(s3c_rotator_ctrls); ++i) {
+		if (id == s3c_rotator_ctrls[i].id) {
+			return &s3c_rotator_ctrls[i];
+		}
+	}
+
+	return NULL;
+}
+
+struct s3c_rotator_dev {
+	struct v4l2_device		v4l2_dev;
+	struct video_device		*vfd;
+	struct v4l2_m2m_dev		*m2m_dev;
+
+	atomic_t		num_inst;
+	spinlock_t		irqlock;
+
+	struct resource		*mem_res;
+	struct resource		*regs_res;
+	void __iomem		*regs_base;
+	int			irq;
+};
+
+/**
+ * struct rot_buf_addr - physical addresses of each color component
+ * @y_rgb: physical address of Y (for YCbCr) or RGB data buffer (for RGB)
+ * @cb: physical address of Cb component buffer for YCbCr
+ * @cr: physical address of Cr component buffer for YCbCr
+ */
+struct rot_buf_addr {
+	unsigned long y_rgb;
+	unsigned long cb;
+	unsigned long cr;
+};
+
+/**
+ * enum - flip modes (only for rotation = 0).
+ * @FLIP_NONE: no flip
+ * @FLIP_VERT: vertical flip
+ * @FLIP_HORIZ: horizontal flip
+ */
+enum {
+	FLIP_NONE = 0,
+	FLIP_VERT = 2,
+	FLIP_HORIZ = 3,
+};
+
+/**
+ * struct s3c_rotator_ctx - per-instance data.
+ * @dev - device state
+ * @m2m_ctx- mem-to-mem framework context for this instance
+ * @fmt - currently selected format
+ * @width - image width in pixels
+ * @height - image height in pixels
+ * @sizeimage - image size in bytes
+ * @rotation - current rotation mode
+ * @flip - current flip mode
+ * @src_addr - physical addresses of source image
+ * @dst_addr - physical addresses of destination image
+ */
+struct s3c_rotator_ctx {
+	struct s3c_rotator_dev	*dev;
+	struct v4l2_m2m_ctx	*m2m_ctx;
+
+	struct s3c_rotator_fmt	*fmt;
+	unsigned int		width;
+	unsigned int		height;
+	unsigned int		sizeimage;
+
+	unsigned int		rotation;
+	int			flip;
+
+	struct rot_buf_addr	src_addr;
+	struct rot_buf_addr	dst_addr;
+};
+
+struct s3c_rotator_buffer {
+	struct videobuf_buffer	vb;
+};
+
+/**
+ * s3c_rot_set_src_reg() - set up source addresses in hardware
+ */
+static inline void s3c_rot_set_src_reg(struct s3c_rotator_dev *dev,
+				       struct s3c_rotator_ctx *ctx)
+{
+	void __iomem *regs = dev->regs_base;
+
+	writel(ctx->src_addr.y_rgb, regs + S3C_ROTATOR_SRCADDRREG0);
+	writel(ctx->src_addr.cb, regs + S3C_ROTATOR_SRCADDRREG1);
+	writel(ctx->src_addr.cr, regs + S3C_ROTATOR_SRCADDRREG2);
+}
+
+/**
+ * s3c_rot_set_dest_reg() - set up destination addresses in hardware
+ */
+static inline void s3c_rot_set_dest_reg(struct s3c_rotator_dev *dev,
+					struct s3c_rotator_ctx *ctx)
+{
+	void __iomem *regs = dev->regs_base;
+
+	writel(ctx->dst_addr.y_rgb, regs + S3C_ROTATOR_DESTADDRREG0);
+	writel(ctx->dst_addr.cb, regs + S3C_ROTATOR_DESTADDRREG1);
+	writel(ctx->dst_addr.cr, regs + S3C_ROTATOR_DESTADDRREG2);
+}
+
+/**
+ * s3c_rotator_start() - start the device
+ */
+static inline void s3c_rotator_start(struct s3c_rotator_dev *dev)
+{
+	u32 reg;
+
+	reg = readl(dev->regs_base + S3C_ROTATOR_CTRLREG);
+	reg |= (S3C_ROTATOR_CTRLREG_START | S3C_ROTATOR_CTRLREG_ENABLE_INT);
+	writel(reg, dev->regs_base + S3C_ROTATOR_CTRLREG);
+}
+
+/**
+ * s3c_rot_set_size_reg() - set up image dimensions in hardware
+ */
+static inline void s3c_rot_set_size_reg(struct s3c_rotator_dev *dev,
+					struct s3c_rotator_ctx *ctx)
+{
+	writel(S3C_ROT_SRC_HEIGHT(ctx->height) | S3C_ROT_SRC_WIDTH(ctx->width),
+		dev->regs_base + S3C_ROTATOR_SRCSIZEREG);
+}
+
+/**
+ * s3c_rot_set_ctrl_reg() - set up operation type in hardware
+ */
+static void s3c_rot_set_ctrl_reg(struct s3c_rotator_dev *dev,
+				 struct s3c_rotator_ctx *ctx)
+{
+	u32 reg;
+
+	reg = readl(dev->regs_base + S3C_ROTATOR_CTRLREG);
+	reg &= ~S3C_ROTATOR_CTRLREG_MASK;
+
+	switch (ctx->fmt->fourcc) {
+	case V4L2_PIX_FMT_YUYV:
+		reg |= S3C_ROTATOR_CTRLREG_SRC_YCBCR422;
+		break;
+
+	case V4L2_PIX_FMT_YUV420:
+		reg |= S3C_ROTATOR_CTRLREG_SRC_YCBCR420;
+		break;
+
+	case V4L2_PIX_FMT_RGB565X:
+		reg |= S3C_ROTATOR_CTRLREG_SRC_RGB565;
+		break;
+
+	case V4L2_PIX_FMT_BGR32:
+		reg |= S3C_ROTATOR_CTRLREG_SRC_RGB888;
+		break;
+
+	default:
+		break;
+	}
+
+	/* We can do either flipping or rotation, not both */
+	if (ctx->flip == FLIP_HORIZ) {
+		reg |= S3C_ROTATOR_CTRLREG_FLIP_HORIZ;
+	} else if (ctx->flip == FLIP_VERT) {
+		reg |= S3C_ROTATOR_CTRLREG_FLIP_VERT;
+	} else {
+		switch (ctx->rotation) {
+		case 90:
+			reg |= S3C_ROTATOR_CTRLREG_DEGREE_90;
+			break;
+
+		case 180:
+			reg |= S3C_ROTATOR_CTRLREG_DEGREE_180;
+			break;
+
+		case 270:
+			reg |= S3C_ROTATOR_CTRLREG_DEGREE_270;
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	writel(reg, dev->regs_base + S3C_ROTATOR_CTRLREG);
+}
+
+/**
+ * job_abort() - called when a device has to be prematurely stopped
+ */
+static void job_abort(void *priv)
+{
+}
+
+/**
+ * device_run() - prepare the device and run the operation
+ */
+static void device_run(void *priv)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+	struct s3c_rotator_dev *dev = ctx->dev;
+	struct s3c_rotator_buffer *src_buf;
+	struct s3c_rotator_buffer *dst_buf;
+
+	/* Acquire source and destination buffers */
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+
+	/* Set operation parameters */
+	s3c_rot_set_ctrl_reg(dev, ctx);
+	s3c_rot_set_size_reg(dev, ctx);
+
+	/* Calculate physical addresses of image buffers and set */
+	ctx->src_addr.y_rgb = videobuf_to_dma_contig(&src_buf->vb);
+	ctx->src_addr.cb = ctx->src_addr.y_rgb + ctx->width * ctx->height;
+	ctx->src_addr.cr = ctx->src_addr.y_rgb +
+		((ctx->width * ctx->height * 5) / 4);
+	s3c_rot_set_src_reg(dev, ctx);
+
+	ctx->dst_addr.y_rgb = videobuf_to_dma_contig(&dst_buf->vb);
+	ctx->dst_addr.cb = ctx->dst_addr.y_rgb + ctx->width * ctx->height;
+	ctx->dst_addr.cr = ctx->dst_addr.y_rgb +
+		((ctx->width * ctx->height * 5) / 4);
+	s3c_rot_set_dest_reg(dev, ctx);
+
+	/* Start the operation */
+	s3c_rotator_start(dev);
+}
+
+
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, S3C_ROTATOR_NAME, sizeof(cap->driver) - 1);
+	strncpy(cap->card, S3C_ROTATOR_NAME, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->version = KERNEL_VERSION(1, 0, 0);
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
+			  | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt(struct file *file, void *priv,
+			   struct v4l2_fmtdesc *f)
+{
+	struct s3c_rotator_fmt *fmt;
+
+	if (f->index >= NUM_FORMATS)
+		return -EINVAL;
+
+	fmt = &formats[f->index];
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+
+	f->fmt.pix.width	= ctx->width;
+	f->fmt.pix.height	= ctx->height;
+	f->fmt.pix.field	= V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat	= ctx->fmt->fourcc;
+
+	return 0;
+}
+
+static struct s3c_rotator_fmt *find_format(struct v4l2_format *f)
+{
+	struct s3c_rotator_fmt *fmt;
+	unsigned int i;
+
+	for (i = 0; i < NUM_FORMATS; ++i) {
+		fmt = &formats[i];
+		if (fmt->fourcc == f->fmt.pix.pixelformat)
+			break;
+	}
+
+	if (i == NUM_FORMATS)
+		return NULL;
+
+	return fmt;
+}
+
+static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+	enum v4l2_field field;
+	struct s3c_rotator_fmt *fmt;
+	u32 pixelformat;
+
+	fmt = find_format(f);
+	if (!fmt) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	pixelformat = f->fmt.pix.pixelformat;
+	field = f->fmt.pix.field;
+
+	if (field == V4L2_FIELD_ANY)
+		field = V4L2_FIELD_NONE;
+	else if (V4L2_FIELD_NONE != field)
+		return -EINVAL;
+
+	f->fmt.pix.field = field;
+
+	if (0 == f->fmt.pix.height || 0 == f->fmt.pix.width)
+		return -EINVAL;
+
+	if (f->fmt.pix.height > S3C_ROTATOR_MAX_HEIGHT)
+		f->fmt.pix.height = S3C_ROTATOR_MAX_HEIGHT;
+
+	if (f->fmt.pix.width > S3C_ROTATOR_MAX_WIDTH)
+		f->fmt.pix.width = S3C_ROTATOR_MAX_WIDTH;
+
+	if (pixelformat == V4L2_PIX_FMT_YUV420) {
+		f->fmt.pix.width &= ~7;
+		f->fmt.pix.height &= ~7;
+	} else if (pixelformat == V4L2_PIX_FMT_YUYV
+		 || pixelformat == V4L2_PIX_FMT_RGB565X) {
+		f->fmt.pix.width &= ~1;
+		f->fmt.pix.height &= ~1;
+	}
+
+	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+
+	return 0;
+}
+
+static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+	struct videobuf_queue *src_vq;
+	struct videobuf_queue *dst_vq;
+	int ret = 0;
+
+	ret = vidioc_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+
+	src_vq = v4l2_m2m_get_src_vq(ctx->m2m_ctx);
+	dst_vq = v4l2_m2m_get_dst_vq(ctx->m2m_ctx);
+
+	mutex_lock(&src_vq->vb_lock);
+	mutex_lock(&dst_vq->vb_lock);
+
+	if (videobuf_queue_is_busy(src_vq)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (videobuf_queue_is_busy(dst_vq)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ctx->fmt		= find_format(f);
+	ctx->width		= f->fmt.pix.width;
+	ctx->height		= f->fmt.pix.height;
+	ctx->sizeimage		= (ctx->width * ctx->height
+				* ctx->fmt->depth) >> 3;
+	src_vq->field = dst_vq->field = f->fmt.pix.field;
+
+out:
+	mutex_unlock(&dst_vq->vb_lock);
+	mutex_unlock(&src_vq->vb_lock);
+	return ret;
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int vidioc_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+static int vidioc_queryctrl(struct file *file, void *priv,
+			    struct v4l2_queryctrl *qc)
+{
+	struct v4l2_queryctrl *c;
+
+	c = get_ctrl(qc->id);
+	if (!c)
+		return -EINVAL;
+
+	*qc = *c;
+	return 0;
+}
+
+static int vidioc_g_ctrl(struct file *file, void *priv,
+			 struct v4l2_control *ctrl)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		ctrl->value = ctx->flip == FLIP_HORIZ ? 1 : 0;
+		break;
+
+	case V4L2_CID_VFLIP:
+		ctrl->value = ctx->flip == FLIP_VERT ? 1 : 0;
+		break;
+
+	case V4L2_CID_PRIVATE_ROTATE:
+		ctrl->value = ctx->rotation;
+		break;
+
+	default:
+		v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int check_ctrl_val(struct s3c_rotator_ctx *ctx,
+			  struct v4l2_control *ctrl)
+{
+	struct v4l2_queryctrl *c;
+
+	c = get_ctrl(ctrl->id);
+	if (!c)
+		return -EINVAL;
+
+	if (ctrl->value < c->minimum || ctrl->value > c->maximum
+		|| (c->step != 0 && ctrl->value % c->step != 0)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "Invalid control value\n");
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+static int vidioc_s_ctrl(struct file *file, void *priv,
+			 struct v4l2_control *ctrl)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+	int ret = 0;
+
+	ret = check_ctrl_val(ctx, ctrl);
+	if (ret != 0)
+		return ret;
+
+	ctx->rotation = 0;
+	ctx->flip = FLIP_NONE;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		if (ctrl->value)
+			ctx->flip = FLIP_HORIZ;
+		break;
+
+	case V4L2_CID_VFLIP:
+		if (ctrl->value)
+			ctx->flip = FLIP_VERT;
+		break;
+
+	case V4L2_CID_PRIVATE_ROTATE:
+		ctx->rotation = ctrl->value;
+		break;
+
+	default:
+		v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops s3c_rotator_ioctl_ops = {
+	.vidioc_querycap	= vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt,
+	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt,
+
+	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt,
+	.vidioc_g_fmt_vid_out	= vidioc_g_fmt,
+
+	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt,
+	.vidioc_try_fmt_vid_out	= vidioc_try_fmt,
+
+	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt,
+	.vidioc_s_fmt_vid_out	= vidioc_s_fmt,
+
+	.vidioc_reqbufs		= vidioc_reqbufs,
+	.vidioc_querybuf	= vidioc_querybuf,
+
+	.vidioc_qbuf		= vidioc_qbuf,
+	.vidioc_dqbuf		= vidioc_dqbuf,
+
+	.vidioc_streamon	= vidioc_streamon,
+	.vidioc_streamoff	= vidioc_streamoff,
+
+	.vidioc_queryctrl	= vidioc_queryctrl,
+	.vidioc_g_ctrl		= vidioc_g_ctrl,
+	.vidioc_s_ctrl		= vidioc_s_ctrl,
+};
+
+
+static void s3c_rotator_buf_release(struct videobuf_queue *vq,
+				    struct videobuf_buffer *vb)
+{
+	videobuf_dma_contig_free(vq, vb);
+	vb->state = VIDEOBUF_NEEDS_INIT;
+}
+
+static int s3c_rotator_buf_setup(struct videobuf_queue *vq, unsigned int *count,
+				 unsigned int *size)
+{
+	struct s3c_rotator_ctx *ctx = vq->priv_data;
+
+	*size = (ctx->width * ctx->height * ctx->fmt->depth) >> 3;
+
+	if (0 == *count)
+		*count = 1;
+
+	while (*size * *count > S3C_ROTATOR_MEM_LIMIT)
+		(*count)--;
+
+	return 0;
+}
+
+static int s3c_rotator_buf_prepare(struct videobuf_queue *vq,
+				   struct videobuf_buffer *vb,
+				   enum v4l2_field field)
+{
+	struct s3c_rotator_ctx *ctx = vq->priv_data;
+	int ret;
+
+	if (vb->baddr) {
+		if (vb->bsize < ctx->sizeimage) {
+			v4l2_err(&ctx->dev->v4l2_dev,
+				 "User-provided buffer too small (%d < %d)\n",
+				 vb->bsize, ctx->sizeimage);
+			return -EINVAL;
+		}
+	} else if (vb->state != VIDEOBUF_NEEDS_INIT
+			&& vb->bsize < ctx->sizeimage) {
+		return -EINVAL;
+	}
+
+	vb->width	= ctx->width;
+	vb->height	= ctx->height;
+	vb->bytesperline = (ctx->width * ctx->fmt->depth) >> 3;
+	vb->size	= ctx->sizeimage;
+	vb->field	= field;
+
+	if (VIDEOBUF_NEEDS_INIT == vb->state) {
+		ret = videobuf_iolock(vq, vb, NULL);
+		if (ret) {
+			v4l2_err(&ctx->dev->v4l2_dev, "Iolock failed\n");
+			goto fail;
+		}
+	}
+	vb->state = VIDEOBUF_PREPARED;
+
+	return 0;
+fail:
+	s3c_rotator_buf_release(vq, vb);
+	return ret;
+}
+
+static void s3c_rotator_buf_queue(struct videobuf_queue *vq,
+				  struct videobuf_buffer *vb)
+{
+	struct s3c_rotator_ctx *ctx = vq->priv_data;
+
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
+}
+
+static struct videobuf_queue_ops s3c_rotator_qops = {
+	.buf_setup	= s3c_rotator_buf_setup,
+	.buf_prepare	= s3c_rotator_buf_prepare,
+	.buf_queue	= s3c_rotator_buf_queue,
+	.buf_release	= s3c_rotator_buf_release,
+};
+
+static void queue_init(void *priv, struct videobuf_queue *vq,
+		       enum v4l2_buf_type type)
+{
+	struct s3c_rotator_ctx *ctx = priv;
+
+	videobuf_queue_dma_contig_init(vq, &s3c_rotator_qops,
+				       ctx->dev->v4l2_dev.dev,
+				       &ctx->dev->irqlock, type,
+				       V4L2_FIELD_NONE,
+				       sizeof (struct s3c_rotator_buffer),
+				       priv);
+
+}
+
+static irqreturn_t s3c_rotator_isr(int irq, void *priv)
+{
+	struct s3c_rotator_dev *dev = (struct s3c_rotator_dev *)priv;
+	struct s3c_rotator_buffer *src_buf, *dst_buf;
+	struct s3c_rotator_ctx *curr_ctx;
+	u32 reg;
+
+	curr_ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
+	if (!curr_ctx)
+		BUG();
+
+	reg = readl(dev->regs_base + S3C_ROTATOR_STATREG);
+
+#ifdef CONFIG_ARCH_S5PC1XX
+	reg |= S3C_ROTATOR_STATREG_INT_PEND;
+	writel(reg, dev->regs_base + S3C_ROTATOR_STATREG);
+#endif
+	reg = readl(dev->regs_base + S3C_ROTATOR_CTRLREG);
+	reg &= ~S3C_ROTATOR_CTRLREG_ENABLE_INT;
+	writel(reg, dev->regs_base + S3C_ROTATOR_CTRLREG);
+
+	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
+
+	v4l2_m2m_job_finish(dev->m2m_dev, curr_ctx->m2m_ctx);
+	src_buf->vb.state = dst_buf->vb.state = VIDEOBUF_DONE;
+	wake_up(&src_buf->vb.done);
+	wake_up(&dst_buf->vb.done);
+
+	return IRQ_HANDLED;
+}
+
+static int s3c_rotator_open(struct file *file)
+{
+	struct s3c_rotator_dev *dev = video_drvdata(file);
+	struct s3c_rotator_ctx *ctx = NULL;
+
+	atomic_inc(&dev->num_inst);
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx) {
+		atomic_dec(&dev->num_inst);
+		return -ENOMEM;
+	}
+
+	file->private_data = ctx;
+	ctx->dev = dev;
+	/* Default format */
+	ctx->fmt = &formats[0];
+
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(ctx, dev->m2m_dev, queue_init);
+	if (IS_ERR(ctx->m2m_ctx)) {
+		kfree(ctx);
+		atomic_dec(&dev->num_inst);
+		return PTR_ERR(ctx->m2m_ctx);
+	}
+
+	return 0;
+}
+
+static int s3c_rotator_release(struct file *file)
+{
+	struct s3c_rotator_dev *dev = video_drvdata(file);
+	struct s3c_rotator_ctx *ctx = file->private_data;
+
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	kfree(ctx);
+
+	atomic_dec(&dev->num_inst);
+
+	return 0;
+}
+
+static unsigned int s3c_rotator_poll(struct file *file,
+				     struct poll_table_struct *wait)
+{
+	struct s3c_rotator_ctx *ctx = file->private_data;
+
+	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+}
+
+static int s3c_rotator_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct s3c_rotator_ctx *ctx = file->private_data;
+
+	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+}
+
+static const struct v4l2_file_operations s3c_rotator_fops = {
+	.owner		= THIS_MODULE,
+	.open		= s3c_rotator_open,
+	.release	= s3c_rotator_release,
+	.poll		= s3c_rotator_poll,
+	.ioctl		= video_ioctl2,
+	.mmap		= s3c_rotator_mmap,
+};
+
+static struct video_device m2mtest_videodev = {
+	.name		= S3C_ROTATOR_NAME,
+	.fops		= &s3c_rotator_fops,
+	.ioctl_ops	= &s3c_rotator_ioctl_ops,
+	.minor		= -1,
+	.release	= video_device_release,
+};
+
+static struct v4l2_m2m_ops m2m_ops = {
+	.device_run	= device_run,
+	.job_abort	= job_abort,
+};
+
+static int s3c_rotator_probe(struct platform_device *pdev)
+{
+	struct s3c_rotator_dev *dev;
+	struct video_device *vfd;
+	struct resource *res;
+	int ret = -ENOENT;
+
+	dev = kzalloc(sizeof *dev, GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	spin_lock_init(&dev->irqlock);
+	ret = -ENOENT;
+
+	dev->irq = platform_get_irq(pdev, 0);
+	if (dev->irq <= 0) {
+		dev_err(&pdev->dev, "Failed to acquire irq\n");
+		goto free_dev;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev,
+			"Failed to acquire memory region resource\n");
+		goto free_irq;
+	}
+
+	dev->regs_res = request_mem_region(res->start, resource_size(res),
+					   dev_name(&pdev->dev));
+	if (!dev->regs_res) {
+		dev_err(&pdev->dev, "Failed to reserve memory region\n");
+		goto free_irq;
+	}
+
+	dev->regs_base = ioremap(res->start, resource_size(res));
+	if (!dev->regs_base) {
+		dev_err(&pdev->dev, "Ioremap failed\n");
+		ret = -ENXIO;
+		goto rel_res;
+	}
+
+	ret = request_irq(dev->irq, s3c_rotator_isr, 0,
+			  S3C_ROTATOR_NAME, dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Requesting irq failed\n");
+		goto regs_unmap;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		goto regs_unmap;
+
+	atomic_set(&dev->num_inst, 0);
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		goto unreg_dev;
+	}
+
+	*vfd = m2mtest_videodev;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto rel_vdev;
+	}
+
+	video_set_drvdata(vfd, dev);
+	snprintf(vfd->name, sizeof(vfd->name), "%s", m2mtest_videodev.name);
+	dev->vfd = vfd;
+	v4l2_info(&dev->v4l2_dev,
+			"Device registered as /dev/video%d\n", vfd->num);
+
+	platform_set_drvdata(pdev, dev);
+
+	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
+	if (IS_ERR(dev->m2m_dev)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
+		ret = PTR_ERR(dev->m2m_dev);
+		goto err_m2m;
+	}
+
+	return 0;
+
+err_m2m:
+	video_unregister_device(dev->vfd);
+rel_vdev:
+	video_device_release(vfd);
+unreg_dev:
+	v4l2_device_unregister(&dev->v4l2_dev);
+regs_unmap:
+	iounmap(dev->regs_base);
+rel_res:
+	release_resource(dev->regs_res);
+	kfree(dev->regs_res);
+free_irq:
+	free_irq(dev->irq, dev);
+free_dev:
+	kfree(dev);
+
+	return ret;
+}
+
+static int s3c_rotator_remove(struct platform_device *pdev)
+{
+	struct s3c_rotator_dev *dev =
+		(struct s3c_rotator_dev *)platform_get_drvdata(pdev);
+
+	v4l2_info(&dev->v4l2_dev, "Removing %s\n", S3C_ROTATOR_NAME);
+
+	v4l2_m2m_release(dev->m2m_dev);
+	video_unregister_device(dev->vfd);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	iounmap(dev->regs_base);
+	release_resource(dev->regs_res);
+	kfree(dev->regs_res);
+	free_irq(dev->irq, dev);
+	kfree(dev);
+
+	return 0;
+}
+
+static int s3c_rotator_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int s3c_rotator_resume(struct device *dev)
+{
+	return 0;
+}
+
+static struct dev_pm_ops s3c_rotator_pm_ops = {
+	.suspend = s3c_rotator_suspend,
+	.resume = s3c_rotator_resume,
+};
+
+static struct platform_driver s3c_rotator_pdrv = {
+	.probe		= s3c_rotator_probe,
+	.remove		= s3c_rotator_remove,
+	.driver		= {
+		.name	= S3C_ROTATOR_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &s3c_rotator_pm_ops
+	},
+};
+
+static char banner[] __initdata =
+	KERN_INFO "S3C Rotator V4L2 Driver, (c) 2009 Samsung Electronics\n";
+
+static int __init s3c_rotator_init(void)
+{
+	printk(banner);
+	return platform_driver_register(&s3c_rotator_pdrv);
+}
+
+static void __devexit s3c_rotator_exit(void)
+{
+	platform_driver_unregister(&s3c_rotator_pdrv);
+}
+
+module_init(s3c_rotator_init);
+module_exit(s3c_rotator_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pawel Osciak <p.osciak@samsung.com>");
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+
-- 
1.6.4.2.253.g0b1fac

