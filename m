Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:44788 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab0FIPaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jun 2010 11:30:15 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Detlev Zundel <dzu@denx.de>,
	Hongjun Chen <hong-jun.chen@freescale.com>,
	Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] v4l: Add MPC5121e VIU video capture driver
Date: Wed,  9 Jun 2010 17:30:09 +0200
Message-Id: <1276097409-8840-1-git-send-email-agust@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hongjun Chen <hong-jun.chen@freescale.com>

Adds support for Video-In (VIU) unit of MPC5121e.
The driver supports RGB888/RGB565 formats, capture
and overlay on MPC5121e DIU frame buffer.

Signed-off-by: Hongjun Chen <hong-jun.chen@freescale.com>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
Please consider this driver for inclusion in 2.6.36. Thanks!

 drivers/media/video/Kconfig   |   12 +
 drivers/media/video/Makefile  |    1 +
 drivers/media/video/fsl-viu.c | 1620 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1633 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/fsl-viu.c

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index bdbc9d3..45bef41 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -557,6 +557,18 @@ config VIDEO_DAVINCI_VPIF
 	  To compile this driver as a module, choose M here: the
 	  module will be called vpif.
 
+config VIDEO_VIU
+	tristate "Freescale VIU Video Driver"
+	depends on VIDEO_V4L2 && PPC_MPC512x
+	select VIDEOBUF_DMA_CONTIG
+	default y
+	---help---
+	  Support for Freescale VIU video driver. This device captures
+	  video data, or overlays video on DIU frame buffer.
+
+	  Say Y here if you want to enable VIU device on MPC5121e Rev2+.
+	  In doubt, say N.
+
 config VIDEO_VIVI
 	tristate "Virtual Video Driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64 && FONTS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index cc93859..542d786 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -151,6 +151,7 @@ obj-$(CONFIG_USB_S2255)		+= s2255drv.o
 obj-$(CONFIG_VIDEO_IVTV) += ivtv/
 obj-$(CONFIG_VIDEO_CX18) += cx18/
 
+obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
new file mode 100644
index 0000000..efec0a0
--- /dev/null
+++ b/drivers/media/video/fsl-viu.c
@@ -0,0 +1,1620 @@
+/*
+ * Copyright 2008 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ *  Freescale VIU video driver
+ *
+ *  Authors: Hongjun Chen <hong-jun.chen@freescale.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of_platform.h>
+#include <linux/version.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf-dma-contig.h>
+
+#define BUFFER_TIMEOUT     msecs_to_jiffies(500)  /* 0.5 seconds */
+
+static struct viu_reg reg_val;
+static char first = 1, dma_done;
+
+#define DRV_NAME		"fsl_viu"
+#define VIU_MAJOR_VERSION	0
+#define VIU_MINOR_VERSION	4
+#define VIU_RELEASE		0
+#define VIU_VERSION		KERNEL_VERSION(VIU_MAJOR_VERSION, \
+					       VIU_MINOR_VERSION, \
+					       VIU_RELEASE)
+
+#define	VIU_VID_MEM_LIMIT	4	/* Video memory limit, in Mb */
+
+/* I2C address of video decoder chip is 0x4A */
+#define VIU_VIDEO_DECODER_ADDR	0x25
+
+/* supported controls */
+static struct v4l2_queryctrl viu_qctrl[] = {
+	{
+		.id            = V4L2_CID_BRIGHTNESS,
+		.type          = V4L2_CTRL_TYPE_INTEGER,
+		.name          = "Brightness",
+		.minimum       = 0,
+		.maximum       = 255,
+		.step          = 1,
+		.default_value = 127,
+		.flags         = 0,
+	}, {
+		.id            = V4L2_CID_CONTRAST,
+		.type          = V4L2_CTRL_TYPE_INTEGER,
+		.name          = "Contrast",
+		.minimum       = 0,
+		.maximum       = 255,
+		.step          = 0x1,
+		.default_value = 0x10,
+		.flags         = 0,
+	}, {
+		.id            = V4L2_CID_SATURATION,
+		.type          = V4L2_CTRL_TYPE_INTEGER,
+		.name          = "Saturation",
+		.minimum       = 0,
+		.maximum       = 255,
+		.step          = 0x1,
+		.default_value = 127,
+		.flags         = 0,
+	}, {
+		.id            = V4L2_CID_HUE,
+		.type          = V4L2_CTRL_TYPE_INTEGER,
+		.name          = "Hue",
+		.minimum       = -128,
+		.maximum       = 127,
+		.step          = 0x1,
+		.default_value = 0,
+		.flags         = 0,
+	}
+};
+
+static int qctl_regs[ARRAY_SIZE(viu_qctrl)];
+static int info_level;
+
+#define dprintk(level, fmt, arg...)					\
+	do {								\
+		if (level <= info_level)				\
+			printk(KERN_DEBUG "viu: " fmt , ## arg);	\
+	} while (0)
+
+/*
+ * Basic structures
+ */
+struct viu_fmt {
+	char  name[32];
+	u32   fourcc;		/* v4l2 format id */
+	u32   pixelformat;
+	int   depth;
+};
+
+static struct viu_fmt formats[] = {
+	{
+		.name		= "RGB-16 (5/B-6/G-5/R)",
+		.fourcc		= V4L2_PIX_FMT_RGB565,
+		.pixelformat	= V4L2_PIX_FMT_RGB565,
+		.depth		= 16,
+	}, {
+		.name		= "RGB-32 (A-R-G-B)",
+		.fourcc		= V4L2_PIX_FMT_RGB32,
+		.pixelformat	= V4L2_PIX_FMT_RGB32,
+		.depth		= 32,
+	}
+};
+
+struct viu_dev;
+struct viu_buf;
+
+/* buffer for one video frame */
+struct viu_buf {
+	/* common v4l buffer stuff -- must be first */
+	struct videobuf_buffer vb;
+	struct viu_fmt *fmt;
+};
+
+struct viu_dmaqueue {
+	struct viu_dev		*dev;
+	struct list_head	active;
+	struct list_head	queued;
+	struct timer_list	timeout;
+};
+
+struct viu_dev {
+	struct v4l2_device	v4l2_dev;
+	struct mutex		lock;
+	spinlock_t		slock;
+	int			users;
+
+	struct device		*dev;
+	/* various device info */
+	struct video_device	*vdev;
+	struct viu_dmaqueue	vidq;
+	enum v4l2_field		capfield;
+
+	/* Hardware register area */
+	struct viu_reg		*vr;
+
+	/* Interrupt vector */
+	int			irq;
+
+	/* video overlay */
+	struct v4l2_framebuffer	ovbuf;
+	struct viu_fmt		*ovfmt;
+	unsigned int		ovenable;
+	enum v4l2_field		ovfield;
+
+	/* crop */
+	struct v4l2_rect	crop_current;
+
+	/* clock pointer */
+	struct clk		*clk;
+
+	/* decoder */
+	struct v4l2_subdev	*decoder;
+};
+
+struct viu_reg {
+	u32 status_cfg;
+	u32 luminance;
+	u32 chroma_r;
+	u32 chroma_g;
+	u32 chroma_b;
+	u32 field_base_addr;
+	u32 dma_inc;
+	u32 picture_count;
+	u32 req_alarm;
+	u32 alpha;
+} __attribute__ ((packed));
+
+struct viu_status {
+	u32 field_irq;
+	u32 vsync_irq;
+	u32 hsync_irq;
+	u32 vstart_irq;
+	u32 dma_end_irq;
+	u32 error_irq;
+};
+
+struct viu_fh {
+	struct viu_dev		*dev;
+
+	/* video capture */
+	struct videobuf_queue	vb_vidq;
+	spinlock_t		vbq_lock; /* spinlock for the videobuf queue */
+
+	/* video overlay */
+	struct v4l2_window	win;
+	struct v4l2_clip	clips[1];
+
+	/* video capture */
+	struct viu_fmt		*fmt;
+	int			width, height, sizeimage;
+	enum v4l2_buf_type	type;
+};
+
+/*
+ * Macro definitions of VIU registers
+ */
+
+/* STATUS_CONFIG register */
+enum status_config {
+	SOFT_RST		= 1 << 0,
+
+	ERR_MASK		= 0x0f << 4,	/* Error code mask */
+	ERR_NO			= 0x00,		/* No error */
+	ERR_DMA_V		= 0x01 << 4,	/* DMA in vertical active */
+	ERR_DMA_VB		= 0x02 << 4,	/* DMA in vertical blanking */
+	ERR_LINE_TOO_LONG	= 0x04 << 4,	/* Line too long */
+	ERR_TOO_MANG_LINES	= 0x05 << 4,	/* Too many lines in field */
+	ERR_LINE_TOO_SHORT	= 0x06 << 4,	/* Line too short */
+	ERR_NOT_ENOUGH_LINE	= 0x07 << 4,	/* Not enough lines in field */
+	ERR_FIFO_OVERFLOW	= 0x08 << 4,	/* FIFO overflow */
+	ERR_FIFO_UNDERFLOW	= 0x09 << 4,	/* FIFO underflow */
+	ERR_1bit_ECC		= 0x0a << 4,	/* One bit ECC error */
+	ERR_MORE_ECC		= 0x0b << 4,	/* Two/more bits ECC error */
+
+	INT_FIELD_EN		= 0x01 << 8,	/* Enable field interrupt */
+	INT_VSYNC_EN		= 0x01 << 9,	/* Enable vsync interrupt */
+	INT_HSYNC_EN		= 0x01 << 10,	/* Enable hsync interrupt */
+	INT_VSTART_EN		= 0x01 << 11,	/* Enable vstart interrupt */
+	INT_DMA_END_EN		= 0x01 << 12,	/* Enable DMA end interrupt */
+	INT_ERROR_EN		= 0x01 << 13,	/* Enable error interrupt */
+	INT_ECC_EN		= 0x01 << 14,	/* Enable ECC interrupt */
+
+	INT_FIELD_STATUS	= 0x01 << 16,	/* field interrupt status */
+	INT_VSYNC_STATUS	= 0x01 << 17,	/* vsync interrupt status */
+	INT_HSYNC_STATUS	= 0x01 << 18,	/* hsync interrupt status */
+	INT_VSTART_STATUS	= 0x01 << 19,	/* vstart interrupt status */
+	INT_DMA_END_STATUS	= 0x01 << 20,	/* DMA end interrupt status */
+	INT_ERROR_STATUS	= 0x01 << 21,	/* error interrupt status */
+
+	DMA_ACT			= 0x01 << 27,	/* Enable DMA transfer */
+	FIELD_NO		= 0x01 << 28,	/* Field number */
+	DITHER_ON		= 0x01 << 29,	/* Dithering is on */
+	ROUND_ON		= 0x01 << 30,	/* Round is on */
+	MODE_32BIT		= 0x01 << 31,	/* Data in RGBa888,
+						 * 0 in RGB565
+						 */
+};
+
+#define norm_maxw()	720
+#define norm_maxh()	576
+
+static int NUM_FORMATS = sizeof(formats)/sizeof(struct viu_fmt);
+static struct viu_status irqs;
+
+static irqreturn_t viu_intr(int irq, void *dev_id);
+inline void viu_default_settings(struct viu_reg *viu_reg, struct viu_reg *val);
+
+struct viu_fmt *format_by_fourcc(int fourcc)
+{
+	int i, j = NUM_FORMATS;
+
+	for (i = 0; i < j; i++) {
+		if (formats[i].pixelformat == fourcc)
+			return formats + i;
+	}
+
+	dprintk(0, "unknown pixelformat:'%4.4s'\n", (char *)&fourcc);
+	return NULL;
+}
+
+void viu_start_dma(struct viu_dev *dev)
+{
+	struct viu_reg *vr = dev->vr;
+
+	/* Enable DMA operation */
+	vr->status_cfg = SOFT_RST;
+	iosync();
+	vr->status_cfg = INT_FIELD_EN;
+	iosync();
+	return;
+}
+
+void viu_stop_dma(struct viu_dev *dev)
+{
+	struct viu_reg *vr = dev->vr;
+
+	vr->status_cfg = 0;
+	iosync();
+	return;
+}
+
+static int restart_video_queue(struct viu_dmaqueue *vidq)
+{
+	struct viu_buf *buf, *prev;
+
+	dprintk(1, "%s vidq=0x%08lx\n", __func__, (unsigned long)vidq);
+	if (!list_empty(&vidq->active)) {
+		buf = list_entry(vidq->active.next, struct viu_buf, vb.queue);
+		dprintk(2, "restart_queue [%p/%d]: restart dma\n",
+			buf, buf->vb.i);
+
+		viu_stop_dma(vidq->dev);
+
+		/* cancel all outstanding capture requests */
+		list_for_each_entry_safe(buf, prev, &vidq->active, vb.queue) {
+			list_del(&buf->vb.queue);
+			buf->vb.state = VIDEOBUF_ERROR;
+			wake_up(&buf->vb.done);
+		}
+		mod_timer(&vidq->timeout, jiffies+BUFFER_TIMEOUT);
+		return 0;
+	}
+
+	prev = NULL;
+	for (;;) {
+		if (list_empty(&vidq->queued))
+			return 0;
+		buf = list_entry(vidq->queued.next, struct viu_buf, vb.queue);
+		if (NULL == prev) {
+			list_del(&buf->vb.queue);
+			list_add_tail(&buf->vb.queue, &vidq->active);
+
+			dprintk(1, "Restarting video dma\n");
+			viu_stop_dma(vidq->dev);
+			viu_start_dma(vidq->dev);
+
+			buf->vb.state = VIDEOBUF_ACTIVE;
+			mod_timer(&vidq->timeout, jiffies+BUFFER_TIMEOUT);
+			dprintk(2, "[%p/%d] restart_queue - first active\n",
+				buf, buf->vb.i);
+
+		} else if (prev->vb.width  == buf->vb.width  &&
+			   prev->vb.height == buf->vb.height &&
+			   prev->fmt       == buf->fmt) {
+			list_del(&buf->vb.queue);
+			list_add_tail(&buf->vb.queue, &vidq->active);
+			buf->vb.state = VIDEOBUF_ACTIVE;
+			dprintk(2, "[%p/%d] restart_queue - move to active\n",
+				buf, buf->vb.i);
+		} else {
+			return 0;
+		}
+		prev = buf;
+	}
+}
+
+static void viu_vid_timeout(unsigned long data)
+{
+	struct viu_dev *dev = (struct viu_dev *)data;
+	struct viu_buf *buf;
+	struct viu_dmaqueue *vidq = &dev->vidq;
+
+	while (!list_empty(&vidq->active)) {
+		buf = list_entry(vidq->active.next, struct viu_buf, vb.queue);
+		list_del(&buf->vb.queue);
+		buf->vb.state = VIDEOBUF_ERROR;
+		wake_up(&buf->vb.done);
+		printk("viu/0: [%p/%d] timeout\n", buf, buf->vb.i);
+	}
+
+	restart_video_queue(vidq);
+}
+
+/*
+ * Videobuf operations
+ */
+static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
+			unsigned int *size)
+{
+	struct viu_fh *fh = vq->priv_data;
+
+	*size = fh->width * fh->height * fh->fmt->depth >> 3;
+	if (0 == *count)
+		*count = 32;
+
+	while (*size * *count > VIU_VID_MEM_LIMIT * 1024 * 1024)
+		(*count)--;
+
+	dprintk(1, "%s, count=%d, size=%d\n", __func__, *count, *size);
+	return 0;
+}
+
+static void free_buffer(struct videobuf_queue *vq, struct viu_buf *buf)
+{
+	struct videobuf_buffer *vb = &buf->vb;
+	void *vaddr = NULL;
+
+	BUG_ON(in_interrupt());
+
+	videobuf_waiton(&buf->vb, 0, 0);
+
+	if (vq->int_ops && vq->int_ops->vaddr)
+		vaddr = vq->int_ops->vaddr(vb);
+
+	if (vaddr)
+		videobuf_dma_contig_free(vq, &buf->vb);
+
+	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+}
+
+inline int buffer_activate(struct viu_dev *dev, struct viu_buf *buf)
+{
+	struct viu_reg *vr = dev->vr;
+	int bpp;
+	static int cfirst = 1;
+	unsigned long addr = videobuf_to_dma_contig(&buf->vb);
+
+	/* setup the DMA base address */
+	reg_val.field_base_addr = addr;
+
+	if (cfirst) {
+		cfirst = 0;
+		dprintk(2, "buffer_activate buf=%p\n", buf);
+		buf->vb.state = VIDEOBUF_ACTIVE;
+
+		/* interlace is on in default, set horizontal DMA increment */
+		bpp = buf->fmt->depth >> 3;
+		reg_val.status_cfg = 0;
+
+		switch (bpp) {
+		case 2:
+			reg_val.status_cfg &= ~MODE_32BIT;
+			reg_val.dma_inc = buf->vb.width * 2;
+			break;
+		case 4:
+			reg_val.status_cfg |= MODE_32BIT;
+			reg_val.dma_inc = buf->vb.width * 4;
+			break;
+		default:
+			dprintk(0, "doesn't support color depth(%d)\n",
+				bpp * 8);
+			return -EINVAL;
+		}
+
+		dev->capfield = buf->vb.field;
+
+		/* setup dma interlace */
+		if (!V4L2_FIELD_HAS_BOTH(buf->vb.field))
+			reg_val.dma_inc = 0;
+
+		/* setup picture_count register */
+		reg_val.picture_count = (buf->vb.height / 2) << 16 |
+					buf->vb.width;
+
+		reg_val.status_cfg |= DMA_ACT | INT_DMA_END_EN | INT_FIELD_EN;
+
+		vr->field_base_addr = reg_val.field_base_addr;
+		vr->dma_inc = reg_val.dma_inc;
+		vr->picture_count = reg_val.picture_count;
+		viu_default_settings(vr, &reg_val);
+		iosync();
+		mod_timer(&dev->vidq.timeout, jiffies + BUFFER_TIMEOUT);
+		return 0;
+	}
+
+	vr->field_base_addr = reg_val.field_base_addr;
+	vr->picture_count = reg_val.picture_count;
+	vr->dma_inc = reg_val.dma_inc;
+	vr->status_cfg = (vr->status_cfg &
+			0xffc0ffff) |
+			INT_FIELD_STATUS |
+			INT_DMA_END_STATUS |
+			INT_VSYNC_STATUS |
+			reg_val.status_cfg;
+
+	iosync();
+	mod_timer(&dev->vidq.timeout, jiffies + BUFFER_TIMEOUT);
+
+	return 0;
+}
+
+static int buffer_prepare(struct videobuf_queue *vq,
+			  struct videobuf_buffer *vb,
+			  enum v4l2_field field)
+{
+	struct viu_fh  *fh  = vq->priv_data;
+	struct viu_buf *buf = container_of(vb, struct viu_buf, vb);
+	int rc;
+
+	BUG_ON(NULL == fh->fmt);
+	if (fh->width  < 48 || fh->width  > norm_maxw() ||
+	    fh->height < 32 || fh->height > norm_maxh())
+		return -EINVAL;
+	buf->vb.size = (fh->width * fh->height * fh->fmt->depth) >> 3;
+	if (0 != buf->vb.baddr && buf->vb.bsize < buf->vb.size)
+		return -EINVAL;
+
+	if (buf->fmt       != fh->fmt	 ||
+	    buf->vb.width  != fh->width  ||
+	    buf->vb.height != fh->height ||
+	    buf->vb.field  != field) {
+		buf->fmt       = fh->fmt;
+		buf->vb.width  = fh->width;
+		buf->vb.height = fh->height;
+		buf->vb.field  = field;
+	}
+
+	if (buf->vb.state == VIDEOBUF_NEEDS_INIT) {
+		rc = videobuf_iolock(vq, &buf->vb, NULL);
+		if (rc != 0)
+			goto fail;
+
+		buf->vb.width  = fh->width;
+		buf->vb.height = fh->height;
+		buf->vb.field  = field;
+		buf->fmt       = fh->fmt;
+	}
+
+	buf->vb.state = VIDEOBUF_PREPARED;
+	return 0;
+
+fail:
+	free_buffer(vq, buf);
+	return rc;
+}
+
+static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+{
+	struct viu_buf       *buf     = container_of(vb, struct viu_buf, vb);
+	struct viu_fh        *fh      = vq->priv_data;
+	struct viu_dev       *dev     = fh->dev;
+	struct viu_dmaqueue  *vidq    = &dev->vidq;
+	struct viu_buf       *prev;
+
+	if (!list_empty(&vidq->queued)) {
+		dprintk(1, "adding vb queue=0x%08lx\n",
+				(unsigned long)&buf->vb.queue);
+		dprintk(1, "vidq pointer 0x%p, queued 0x%p\n",
+				vidq, &vidq->queued);
+		dprintk(1, "dev %p, queued: self %p, next %p, head %p\n",
+			dev, &vidq->queued, vidq->queued.next,
+			vidq->queued.prev);
+		list_add_tail(&buf->vb.queue, &vidq->queued);
+		buf->vb.state = VIDEOBUF_QUEUED;
+		dprintk(2, "[%p/%d] buffer_queue - append to queued\n",
+			buf, buf->vb.i);
+	} else if (list_empty(&vidq->active)) {
+		dprintk(1, "adding vb active=0x%08lx\n",
+			(unsigned long)&buf->vb.queue);
+		list_add_tail(&buf->vb.queue, &vidq->active);
+		buf->vb.state = VIDEOBUF_ACTIVE;
+		mod_timer(&vidq->timeout, jiffies+BUFFER_TIMEOUT);
+		dprintk(2, "[%p/%d] buffer_queue - first active\n",
+			buf, buf->vb.i);
+
+		buffer_activate(dev, buf);
+	} else {
+		dprintk(1, "adding vb queue2=0x%08lx\n",
+			(unsigned long)&buf->vb.queue);
+		prev = list_entry(vidq->active.prev, struct viu_buf, vb.queue);
+		if (prev->vb.width  == buf->vb.width  &&
+		    prev->vb.height == buf->vb.height &&
+		    prev->fmt       == buf->fmt) {
+			list_add_tail(&buf->vb.queue, &vidq->active);
+			buf->vb.state = VIDEOBUF_ACTIVE;
+			dprintk(2, "[%p/%d] buffer_queue - append to active\n",
+				buf, buf->vb.i);
+		} else {
+			list_add_tail(&buf->vb.queue, &vidq->queued);
+			buf->vb.state = VIDEOBUF_QUEUED;
+			dprintk(2, "[%p/%d] buffer_queue - first queued\n",
+				buf, buf->vb.i);
+		}
+	}
+}
+
+static void buffer_release(struct videobuf_queue *vq,
+				struct videobuf_buffer *vb)
+{
+	struct viu_buf *buf  = container_of(vb, struct viu_buf, vb);
+	struct viu_fh  *fh   = vq->priv_data;
+	struct viu_dev *dev  = (struct viu_dev *)fh->dev;
+
+	viu_stop_dma(dev);
+	free_buffer(vq, buf);
+}
+
+static struct videobuf_queue_ops viu_video_qops = {
+	.buf_setup      = buffer_setup,
+	.buf_prepare    = buffer_prepare,
+	.buf_queue      = buffer_queue,
+	.buf_release    = buffer_release,
+};
+
+/*
+ * IOCTL vidioc handling
+ */
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	strcpy(cap->driver, "viu");
+	strcpy(cap->card, "viu");
+	cap->version = VIU_VERSION;
+	cap->capabilities =	V4L2_CAP_VIDEO_CAPTURE |
+				V4L2_CAP_STREAMING     |
+				V4L2_CAP_VIDEO_OVERLAY |
+				V4L2_CAP_READWRITE;
+	return 0;
+}
+
+static int vidioc_enum_fmt(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	int index = f->index;
+
+	if (f->index > NUM_FORMATS)
+		return -EINVAL;
+
+	strlcpy(f->description, formats[index].name, sizeof(f->description));
+	f->pixelformat = formats[index].fourcc;
+	return 0;
+}
+
+static int vidioc_g_fmt_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viu_fh *fh = priv;
+
+	f->fmt.pix.width        = fh->width;
+	f->fmt.pix.height       = fh->height;
+	f->fmt.pix.field        = fh->vb_vidq.field;
+	f->fmt.pix.pixelformat  = fh->fmt->pixelformat;
+	f->fmt.pix.bytesperline =
+		(f->fmt.pix.width * fh->fmt->depth) >> 3;
+	f->fmt.pix.sizeimage	= fh->sizeimage;
+	return 0;
+}
+
+static int vidioc_try_fmt_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viu_fmt *fmt;
+	enum v4l2_field field;
+	unsigned int maxw, maxh;
+
+	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
+	if (!fmt) {
+		dprintk(1, "Fourcc format (0x%08x) invalid.",
+			f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	field = f->fmt.pix.field;
+
+	if (field == V4L2_FIELD_ANY) {
+		field = V4L2_FIELD_INTERLACED;
+	} else if (V4L2_FIELD_INTERLACED != field) {
+		dprintk(1, "Field type invalid.\n");
+		return -EINVAL;
+	}
+
+	maxw  = norm_maxw();
+	maxh  = norm_maxh();
+
+	f->fmt.pix.field = field;
+	if (f->fmt.pix.height < 32)
+		f->fmt.pix.height = 32;
+	if (f->fmt.pix.height > maxh)
+		f->fmt.pix.height = maxh;
+	if (f->fmt.pix.width < 48)
+		f->fmt.pix.width = 48;
+	if (f->fmt.pix.width > maxw)
+		f->fmt.pix.width = maxw;
+	f->fmt.pix.width &= ~0x03;
+	f->fmt.pix.bytesperline =
+		(f->fmt.pix.width * fmt->depth) >> 3;
+
+	return 0;
+}
+
+static int vidioc_s_fmt_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viu_fh *fh = priv;
+	int ret;
+
+	ret = vidioc_try_fmt_cap(file, fh, f);
+	if (ret < 0)
+		return ret;
+
+	fh->fmt           = format_by_fourcc(f->fmt.pix.pixelformat);
+	fh->width         = f->fmt.pix.width;
+	fh->height        = f->fmt.pix.height;
+	fh->sizeimage     = f->fmt.pix.sizeimage;
+	fh->vb_vidq.field = f->fmt.pix.field;
+	fh->type          = f->type;
+	dprintk(1, "set to pixelformat '%4.6s'\n", (char *)&fh->fmt->name);
+	return 0;
+}
+
+static int vidioc_g_fmt_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viu_fh *fh = priv;
+	f->fmt.win = fh->win;
+	return 0;
+}
+
+static int verify_preview(struct viu_dev *dev, struct v4l2_window *win)
+{
+	enum v4l2_field field;
+	int maxw, maxh;
+
+	if (NULL == dev->ovbuf.base)
+		return -EINVAL;
+	if (NULL == dev->ovfmt)
+		return -EINVAL;
+	if (win->w.width < 48 || win->w.height < 32)
+		return -EINVAL;
+
+	field = win->field;
+	maxw  = dev->crop_current.width;
+	maxh  = dev->crop_current.height;
+
+	if (V4L2_FIELD_ANY == field) {
+		field = (win->w.height > maxh/2)
+			? V4L2_FIELD_INTERLACED
+			: V4L2_FIELD_TOP;
+	}
+	switch (field) {
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+		maxh = maxh / 2;
+		break;
+	case V4L2_FIELD_INTERLACED:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	win->field = field;
+	if (win->w.width > maxw)
+		win->w.width = maxw;
+	if (win->w.height > maxh)
+		win->w.height = maxh;
+	return 0;
+}
+
+static int start_preview(struct viu_dev *dev, struct viu_fh *fh)
+{
+	int bpp;
+
+	dprintk(1, "start_preview %dx%d %s\n",
+		fh->win.w.width, fh->win.w.height, dev->ovfmt->name);
+
+	reg_val.status_cfg = 0;
+
+	/* setup window */
+	reg_val.picture_count = (fh->win.w.height / 2) << 16 |
+				fh->win.w.width;
+
+	/* setup color depth and dma increment */
+	bpp = dev->ovfmt->depth / 8;
+	switch (bpp) {
+	case 2:
+		reg_val.status_cfg &= ~MODE_32BIT;
+		reg_val.dma_inc = fh->win.w.width * 2;
+		break;
+	case 4:
+		reg_val.status_cfg |= MODE_32BIT;
+		reg_val.dma_inc = fh->win.w.width * 4;
+		break;
+	default:
+		dprintk(0, "device doesn't support color depth(%d)\n",
+			bpp * 8);
+		return -EINVAL;
+	}
+
+	dev->ovfield = fh->win.field;
+	if (!V4L2_FIELD_HAS_BOTH(dev->ovfield))
+		reg_val.dma_inc = 0;
+
+	reg_val.status_cfg |= DMA_ACT | INT_DMA_END_EN | INT_FIELD_EN;
+
+	/* setup the base address of overlay buffer */
+	reg_val.field_base_addr = (u32)dev->ovbuf.base;
+
+	/* start dma */
+	dev->ovenable = 1;
+	viu_start_dma(dev);
+	return 0;
+}
+
+static int stop_preview(struct viu_dev *dev, struct viu_fh *fh)
+{
+	viu_stop_dma(dev);
+	return 0;
+}
+
+static int vidioc_s_fmt_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viu_fh  *fh  = priv;
+	struct viu_dev *dev = (struct viu_dev *)fh->dev;
+	unsigned long  flags;
+	int err;
+
+	err = verify_preview(dev, &f->fmt.win);
+	if (0 != err)
+		return err;
+
+	mutex_lock(&dev->lock);
+	fh->win = f->fmt.win;
+
+	spin_lock_irqsave(&dev->slock, flags);
+	stop_preview(dev, fh);
+	start_preview(dev, fh);
+	spin_unlock_irqrestore(&dev->slock, flags);
+	mutex_unlock(&dev->lock);
+	return 0;
+}
+
+static int vidioc_try_fmt_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	return 0;
+}
+
+int vidioc_g_fbuf(struct file *file, void *priv, struct v4l2_framebuffer *arg)
+{
+	struct viu_fh  *fh = priv;
+	struct viu_dev *dev = fh->dev;
+	struct v4l2_framebuffer *fb = arg;
+
+	*fb = dev->ovbuf;
+	fb->capability = V4L2_FBUF_CAP_LIST_CLIPPING;
+	return 0;
+}
+
+int vidioc_s_fbuf(struct file *file, void *priv, struct v4l2_framebuffer *arg)
+{
+	struct viu_fh  *fh = priv;
+	struct viu_dev *dev = fh->dev;
+	struct v4l2_framebuffer *fb = arg;
+	struct viu_fmt *fmt;
+
+	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	/* check args */
+	fmt = format_by_fourcc(fb->fmt.pixelformat);
+	if (NULL == fmt)
+		return -EINVAL;
+
+	/* ok, accept it */
+	dev->ovbuf = *fb;
+	dev->ovfmt = fmt;
+	if (0 == dev->ovbuf.fmt.bytesperline)
+		dev->ovbuf.fmt.bytesperline =
+			dev->ovbuf.fmt.width * fmt->depth / 8;
+	return 0;
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+				struct v4l2_requestbuffers *p)
+{
+	struct viu_fh *fh = priv;
+
+	return videobuf_reqbufs(&fh->vb_vidq, p);
+}
+
+static int vidioc_querybuf(struct file *file, void *priv,
+					struct v4l2_buffer *p)
+{
+	struct viu_fh *fh = priv;
+
+	return videobuf_querybuf(&fh->vb_vidq, p);
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct viu_fh *fh = priv;
+
+	return videobuf_qbuf(&fh->vb_vidq, p);
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct viu_fh *fh = priv;
+
+	return videobuf_dqbuf(&fh->vb_vidq, p,
+				file->f_flags & O_NONBLOCK);
+}
+
+static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct viu_fh *fh = priv;
+
+	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (i != fh->type)
+		return -EINVAL;
+
+	return videobuf_streamon(&fh->vb_vidq);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct viu_fh  *fh = priv;
+
+	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (i != fh->type)
+		return -EINVAL;
+
+	return videobuf_streamoff(&fh->vb_vidq);
+}
+
+#define decoder_call(viu, o, f, args...) \
+	v4l2_subdev_call(viu->decoder, o, f, ##args)
+
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
+{
+	struct viu_fh *fh = priv;
+
+	decoder_call(fh->dev, core, s_std, *id);
+	return 0;
+}
+
+/* only one input in this driver */
+static int vidioc_enum_input(struct file *file, void *priv,
+					struct v4l2_input *inp)
+{
+	struct viu_fh *fh = priv;
+
+	if (inp->index != 0)
+		return -EINVAL;
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	inp->std = fh->dev->vdev->tvnorms;
+	strcpy(inp->name, "Camera");
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	struct viu_fh *fh = priv;
+
+	if (i > 1)
+		return -EINVAL;
+
+	decoder_call(fh->dev, video, s_routing, i, 0, 0);
+	return 0;
+}
+
+/* Controls */
+static int vidioc_queryctrl(struct file *file, void *priv,
+				struct v4l2_queryctrl *qc)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(viu_qctrl); i++)
+		if (qc->id && qc->id == viu_qctrl[i].id) {
+			memcpy(qc, &(viu_qctrl[i]), sizeof(*qc));
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+static int vidioc_g_ctrl(struct file *file, void *priv,
+				struct v4l2_control *ctrl)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(viu_qctrl); i++)
+		if (ctrl->id == viu_qctrl[i].id) {
+			ctrl->value = qctl_regs[i];
+			return 0;
+		}
+
+	return -EINVAL;
+}
+static int vidioc_s_ctrl(struct file *file, void *priv,
+				struct v4l2_control *ctrl)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(viu_qctrl); i++)
+		if (ctrl->id == viu_qctrl[i].id) {
+			if (ctrl->value < viu_qctrl[i].minimum
+				|| ctrl->value > viu_qctrl[i].maximum)
+					return -ERANGE;
+			qctl_regs[i] = ctrl->value;
+			return 0;
+		}
+	return -EINVAL;
+}
+
+inline void viu_activate_next_buf(struct viu_dev *dev,
+				struct viu_dmaqueue *viuq)
+{
+	struct viu_dmaqueue *vidq = viuq;
+	struct viu_buf *buf;
+
+	/* launch another DMA operation for an active/queued buffer */
+	if (!list_empty(&vidq->active)) {
+		buf = list_entry(vidq->active.next, struct viu_buf,
+					vb.queue);
+		dprintk(1, "start another queued buffer.\n");
+		buffer_activate(dev, buf);
+	} else if (!list_empty(&vidq->queued)) {
+		buf = list_entry(vidq->queued.next, struct viu_buf,
+					vb.queue);
+		list_del(&buf->vb.queue);
+
+		dprintk(1, "start another queued buffer.\n");
+		list_add_tail(&buf->vb.queue, &vidq->active);
+		buf->vb.state = VIDEOBUF_ACTIVE;
+		buffer_activate(dev, buf);
+	}
+}
+
+inline void viu_default_settings(struct viu_reg *viu_reg, struct viu_reg *val)
+{
+	struct viu_reg *vr = viu_reg;
+
+	vr->status_cfg = 0;
+	iosync();
+	vr->luminance = 0x9512A254;
+	vr->chroma_r = 0x03310000;
+	vr->chroma_g = 0x06600F38;
+	vr->chroma_b = 0x00000409;
+	vr->alpha = 0x000000ff;
+	vr->req_alarm = 0x00000090;
+	vr->status_cfg = (vr->status_cfg & 0xffc0ffff) |
+			(INT_FIELD_STATUS | INT_VSYNC_STATUS |
+			INT_HSYNC_STATUS | INT_VSTART_STATUS |
+			INT_DMA_END_STATUS | INT_ERROR_STATUS |
+			val->status_cfg);
+	dprintk(1, "status reg: 0x%08x, fb base: 0x%08x\n",
+		vr->status_cfg, vr->field_base_addr);
+}
+
+inline void viu_activate_overlay(struct viu_reg *viu_reg)
+{
+	struct viu_reg *vr = viu_reg;
+
+	vr->field_base_addr = reg_val.field_base_addr;
+	vr->dma_inc = reg_val.dma_inc;
+	vr->picture_count = reg_val.picture_count;
+	viu_default_settings(vr, &reg_val);
+}
+
+/* process all VIU interrupt sources */
+static irqreturn_t viu_intr(int irq, void *dev_id)
+{
+	struct viu_dev *dev  = (struct viu_dev *)dev_id;
+	struct viu_reg *vr = dev->vr;
+	struct viu_dmaqueue *vidq = &dev->vidq;
+	struct viu_buf *buf;
+	u32 status = vr->status_cfg;
+	u32 error, field_num, need_two;
+
+	/* Clear interrupt bits and error flags */
+	if (status & INT_ERROR_STATUS) {
+		irqs.error_irq++;
+		error = status & ERR_MASK;
+		if (error)
+			dprintk(1, "Err: error(%d), times:%d!\n",
+				error >> 4, irqs.error_irq);
+		vr->status_cfg = (status & 0xFFC0FFFF) | 0x00200000;
+		iosync();
+	}
+
+	if (status & INT_DMA_END_STATUS) {
+		irqs.dma_end_irq++;
+		dma_done = 1;
+		dprintk(2, "VIU DMA end interrupt times: %d\n",
+						irqs.dma_end_irq);
+	}
+
+	if (status & INT_HSYNC_STATUS)
+		irqs.hsync_irq++;
+
+	if (status & INT_FIELD_STATUS) {
+		irqs.field_irq++;
+		dprintk(2, "VIU field interrupt times: %d\n", irqs.field_irq);
+	}
+
+	if (status & INT_VSTART_STATUS)
+		irqs.vstart_irq++;
+
+	if (status & INT_VSYNC_STATUS) {
+		irqs.vsync_irq++;
+		dprintk(2, "VIU vsync interrupt times: %d\n", irqs.vsync_irq);
+	}
+
+	/* complete one field */
+	field_num = status & FIELD_NO;
+	need_two = V4L2_FIELD_HAS_BOTH(dev->capfield);
+
+	vr->status_cfg = (vr->status_cfg & 0xffc0ffff) |
+			INT_FIELD_STATUS | INT_VSYNC_STATUS
+			| INT_HSYNC_STATUS | INT_VSTART_STATUS
+			| INT_DMA_END_STATUS | INT_ERROR_STATUS;
+	iosync();
+
+	dprintk(2, "irq status: 0x%08x\n", status);
+	if (status & INT_FIELD_STATUS) {
+		if (first) {
+			if (field_num == 0) {
+				first = 0;
+
+				if (dev->ovenable) /* overlay mode */
+					viu_activate_overlay(vr);
+				else /* capture mode */
+					viu_activate_next_buf(dev, vidq);
+
+				iosync();
+			}
+			return IRQ_HANDLED;
+		} else if (dev->ovenable) {
+			/* overlay mode */
+			if (!dma_done && (status & INT_VSYNC_STATUS)) {
+				vr->status_cfg = (vr->status_cfg &
+						0xffc0ffff) |
+						INT_FIELD_STATUS |
+						INT_VSYNC_STATUS |
+						INT_HSYNC_STATUS |
+						INT_VSTART_STATUS |
+						INT_DMA_END_STATUS |
+						INT_ERROR_STATUS |
+						reg_val.status_cfg;
+				return IRQ_HANDLED;
+			}
+
+			if (dma_done) {
+				dma_done = 0;
+				if (field_num == 0) {
+					vr->field_base_addr =
+						reg_val.field_base_addr;
+					vr->picture_count =
+						reg_val.picture_count;
+					iosync();
+				} else {
+					vr->field_base_addr =
+						reg_val.field_base_addr +
+						reg_val.dma_inc;
+					vr->picture_count =
+						reg_val.picture_count;
+					iosync();
+				}
+
+				vr->dma_inc = reg_val.dma_inc;
+				vr->status_cfg = (vr->status_cfg &
+						0xffc0ffff) |
+						INT_FIELD_STATUS |
+						INT_VSYNC_STATUS |
+						INT_HSYNC_STATUS |
+						INT_VSTART_STATUS |
+						INT_DMA_END_STATUS |
+						INT_ERROR_STATUS |
+						reg_val.status_cfg;
+				iosync();
+			}
+		} else {
+			/* Capture mode */
+			if (!dma_done) {
+				vr->status_cfg = (vr->status_cfg &
+						0xffc0ffff) |
+						INT_FIELD_STATUS |
+						INT_VSYNC_STATUS |
+						INT_HSYNC_STATUS |
+						INT_VSTART_STATUS |
+						INT_DMA_END_STATUS |
+						INT_ERROR_STATUS |
+						reg_val.status_cfg;
+				iosync();
+				return IRQ_HANDLED;
+			}
+
+			/* find one buffer for next dma operation */
+			dma_done = 0;
+			if (!list_empty(&vidq->active)) {
+				if (field_num == 0 && need_two) {
+					vr->field_base_addr =
+						reg_val.field_base_addr +
+						reg_val.dma_inc;
+					vr->status_cfg = (vr->status_cfg &
+						0xffc0ffff) |
+						INT_FIELD_STATUS |
+						INT_VSYNC_STATUS |
+						INT_HSYNC_STATUS |
+						INT_VSTART_STATUS |
+						INT_DMA_END_STATUS |
+						INT_ERROR_STATUS |
+						reg_val.status_cfg;
+					iosync();
+					return IRQ_HANDLED;
+				}
+
+				buf = list_entry(vidq->active.next,
+							struct viu_buf,
+							vb.queue);
+				list_del(&buf->vb.queue);
+				buf->vb.state = VIDEOBUF_DONE;
+				wake_up(&buf->vb.done);
+				dprintk(1, "viu/0: [%p/%d] dma complete\n",
+						buf, buf->vb.i);
+			}
+
+			/* activate next dma buffer */
+			viu_activate_next_buf(dev, vidq);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * File operations for the device
+ */
+static int viu_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct viu_dev *dev = video_get_drvdata(vdev);
+	struct viu_fh *fh;
+	struct viu_reg *vr;
+	int minor = vdev->minor;
+	int i;
+
+	dprintk(1, "viu: open (minor=%d)\n", minor);
+
+	/* If more than one user, mutex should be added */
+	dev->users++;
+	vr = dev->vr;
+
+	dprintk(1, "open minor=%d type=%s users=%d\n", minor,
+		v4l2_type_names[V4L2_BUF_TYPE_VIDEO_CAPTURE], dev->users);
+
+	/* allocate and initialize per filehandle data */
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	if (!fh) {
+		dev->users--;
+		return -ENOMEM;
+	}
+
+	file->private_data = fh;
+	fh->dev = dev;
+
+	fh->type     = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_RGB32);
+	fh->width    = norm_maxw();
+	fh->height   = norm_maxh();
+	dev->crop_current.width  = fh->width;
+	dev->crop_current.height = fh->height;
+
+	/* Put all controls at a sane state */
+	for (i = 0; i < ARRAY_SIZE(viu_qctrl); i++)
+		qctl_regs[i] = viu_qctrl[i].default_value;
+
+	dprintk(1, "Open: fh=0x%08lx, dev=0x%08lx, dev->vidq=0x%08lx\n",
+		(unsigned long)fh, (unsigned long)dev,
+		(unsigned long)&dev->vidq);
+	dprintk(1, "Open: list_empty queued=%d\n",
+		list_empty(&dev->vidq.queued));
+	dprintk(1, "Open: list_empty active=%d\n",
+		list_empty(&dev->vidq.active));
+
+	vr->status_cfg &= ~(INT_VSYNC_EN | INT_HSYNC_EN |
+			    INT_FIELD_EN | INT_VSTART_EN |
+			    INT_DMA_END_EN | INT_ERROR_EN | INT_ECC_EN);
+	iosync();
+	vr->status_cfg |= INT_FIELD_STATUS | INT_VSYNC_STATUS |
+			  INT_HSYNC_STATUS | INT_VSTART_STATUS |
+			  INT_DMA_END_STATUS | INT_ERROR_STATUS;
+	iosync();
+
+	spin_lock_init(&fh->vbq_lock);
+	videobuf_queue_dma_contig_init(&fh->vb_vidq, &viu_video_qops,
+				       dev->dev, &fh->vbq_lock,
+				       fh->type, V4L2_FIELD_INTERLACED,
+				       sizeof(struct viu_buf), fh);
+	return 0;
+}
+
+static ssize_t viu_read(struct file *file, char __user *data, size_t count,
+			loff_t *ppos)
+{
+	struct viu_fh *fh = file->private_data;
+	struct viu_dev *dev = fh->dev;
+
+	dprintk(2, "%s\n", __func__);
+	if (dev->ovenable)
+		dev->ovenable = 0;
+
+	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		viu_start_dma(dev);
+		return videobuf_read_stream(&fh->vb_vidq, data, count,
+				ppos, 0, file->f_flags & O_NONBLOCK);
+	}
+	return 0;
+}
+
+static unsigned int viu_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct viu_fh *fh = file->private_data;
+	struct videobuf_queue *q = &fh->vb_vidq;
+
+	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
+		return POLLERR;
+
+	return videobuf_poll_stream(file, q, wait);
+}
+
+static int viu_release(struct file *file)
+{
+	struct viu_fh *fh = file->private_data;
+	struct viu_dev *dev = fh->dev;
+	int minor = video_devdata(file)->minor;
+
+	viu_stop_dma(dev);
+	videobuf_stop(&fh->vb_vidq);
+
+	kfree(fh);
+
+	first = 1;
+	dev->users--;
+	dprintk(1, "close (minor=%d, users=%d)\n",
+		minor, dev->users);
+	return 0;
+}
+
+void viu_reset(struct viu_reg *reg)
+{
+	reg->status_cfg = 0;
+	reg->luminance = 0x9512a254;
+	reg->chroma_r = 0x03310000;
+	reg->chroma_g = 0x06600f38;
+	reg->chroma_b = 0x00000409;
+	reg->field_base_addr = 0;
+	reg->dma_inc = 0;
+	reg->picture_count = 0x01e002d0;
+	reg->req_alarm = 0x00000090;
+	reg->alpha = 0x000000ff;
+}
+
+static int viu_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct viu_fh *fh = file->private_data;
+	int ret;
+
+	dprintk(1, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
+
+	ret = videobuf_mmap_mapper(&fh->vb_vidq, vma);
+
+	dprintk(1, "vma start=0x%08lx, size=%ld, ret=%d\n",
+		(unsigned long)vma->vm_start,
+		(unsigned long)vma->vm_end-(unsigned long)vma->vm_start,
+		ret);
+
+	return ret;
+}
+
+static struct v4l2_file_operations viu_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viu_open,
+	.release	= viu_release,
+	.read		= viu_read,
+	.poll		= viu_poll,
+	.ioctl		= video_ioctl2, /* V4L2 ioctl handler */
+	.mmap		= viu_mmap,
+};
+
+static const struct v4l2_ioctl_ops viu_ioctl_ops = {
+	.vidioc_querycap	= vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt,
+	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_cap,
+	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_cap,
+	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_cap,
+	.vidioc_enum_fmt_vid_overlay = vidioc_enum_fmt,
+	.vidioc_g_fmt_vid_overlay = vidioc_g_fmt_overlay,
+	.vidioc_try_fmt_vid_overlay = vidioc_try_fmt_overlay,
+	.vidioc_s_fmt_vid_overlay = vidioc_s_fmt_overlay,
+	.vidioc_g_fbuf	      = vidioc_g_fbuf,
+	.vidioc_s_fbuf	      = vidioc_s_fbuf,
+	.vidioc_reqbufs       = vidioc_reqbufs,
+	.vidioc_querybuf      = vidioc_querybuf,
+	.vidioc_qbuf          = vidioc_qbuf,
+	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_s_std         = vidioc_s_std,
+	.vidioc_enum_input    = vidioc_enum_input,
+	.vidioc_g_input       = vidioc_g_input,
+	.vidioc_s_input       = vidioc_s_input,
+	.vidioc_queryctrl     = vidioc_queryctrl,
+	.vidioc_g_ctrl        = vidioc_g_ctrl,
+	.vidioc_s_ctrl        = vidioc_s_ctrl,
+	.vidioc_streamon      = vidioc_streamon,
+	.vidioc_streamoff     = vidioc_streamoff,
+};
+
+static struct video_device viu_template = {
+	.name		= "FSL viu",
+	.fops		= &viu_fops,
+	.minor		= -1,
+	.ioctl_ops	= &viu_ioctl_ops,
+	.release	= video_device_release,
+
+	.tvnorms        = V4L2_STD_NTSC_M | V4L2_STD_PAL,
+	.current_norm   = V4L2_STD_NTSC_M,
+};
+
+static int __devinit viu_of_probe(struct of_device *op,
+				  const struct of_device_id *match)
+{
+	struct viu_dev *dev;
+	struct resource r;
+	struct viu_reg __iomem *viu_regs;
+	struct i2c_adapter *ad;
+	int ret, viu_irq;
+
+	ret = of_address_to_resource(op->dev.of_node, 0, &r);
+	if (ret) {
+		dev_err(&op->dev, "Can't parse device node resource\n");
+		return -ENODEV;
+	}
+
+	viu_irq = irq_of_parse_and_map(op->dev.of_node, 0);
+	if (viu_irq == NO_IRQ) {
+		dev_err(&op->dev, "Error while mapping the irq\n");
+		return -EINVAL;
+	}
+
+	/* request mem region */
+	if (!devm_request_mem_region(&op->dev, r.start,
+				     sizeof(struct viu_reg), DRV_NAME)) {
+		dev_err(&op->dev, "Error while requesting mem region\n");
+		ret = -EBUSY;
+		goto err;
+	}
+
+	/* remap registers */
+	viu_regs = devm_ioremap(&op->dev, r.start, sizeof(struct viu_reg));
+	if (!viu_regs) {
+		dev_err(&op->dev, "Can't map register set\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* Prepare our private structure */
+	dev = devm_kzalloc(&op->dev, sizeof(struct viu_dev), GFP_ATOMIC);
+	if (!dev) {
+		dev_err(&op->dev, "Can't allocate private structure\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	dev->vr = viu_regs;
+	dev->irq = viu_irq;
+	dev->dev = &op->dev;
+
+	/* init video dma queues */
+	INIT_LIST_HEAD(&dev->vidq.active);
+	INIT_LIST_HEAD(&dev->vidq.queued);
+
+	/* initialize locks */
+	mutex_init(&dev->lock);
+
+	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s", "VIU");
+	ret = v4l2_device_register(dev->dev, &dev->v4l2_dev);
+	if (ret < 0) {
+		dev_err(&op->dev, "v4l2_device_register() failed: %d\n", ret);
+		goto err;
+	}
+
+	ad = i2c_get_adapter(0);
+	dev->decoder = v4l2_i2c_new_subdev(&dev->v4l2_dev, ad,
+			"saa7115", "saa7113", VIU_VIDEO_DECODER_ADDR, NULL);
+
+	dev->vidq.timeout.function = viu_vid_timeout;
+	dev->vidq.timeout.data     = (unsigned long)dev;
+	init_timer(&dev->vidq.timeout);
+
+	/* Allocate memory for video device */
+	dev->vdev = video_device_alloc();
+	if (dev->vdev == NULL) {
+		ret = -ENOMEM;
+		goto err_vdev;
+	}
+
+	memcpy(dev->vdev, &viu_template, sizeof(viu_template));
+	video_set_drvdata(dev->vdev, dev);
+	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		video_device_release(dev->vdev);
+		goto err_vdev;
+	}
+
+	/* enable VIU clock */
+	dev->clk = clk_get(&op->dev, "viu_clk");
+	if (IS_ERR(dev->clk)) {
+		dev_err(&op->dev, "failed to find the clock module!\n");
+		ret = -ENODEV;
+		goto err_clk;
+	} else {
+		clk_enable(dev->clk);
+	}
+
+	/* reset VIU module */
+	viu_reset(dev->vr);
+
+	/* install interrupt handler */
+	if (request_irq(dev->irq, viu_intr, 0, "viu", (void *)dev)) {
+		dev_err(&op->dev, "Request VIU IRQ failed.\n");
+		ret = -ENODEV;
+		goto err_irq;
+	}
+
+	dev_info(dev->dev, "Freescale VIU Video Capture Board\n");
+
+	return ret;
+
+err_irq:
+	clk_disable(dev->clk);
+	clk_put(dev->clk);
+err_clk:
+	video_unregister_device(dev->vdev);
+err_vdev:
+	i2c_put_adapter(ad);
+	v4l2_device_unregister(&dev->v4l2_dev);
+err:
+	irq_dispose_mapping(viu_irq);
+	return ret;
+}
+
+static int __devexit viu_of_remove(struct of_device *op)
+{
+	struct v4l2_device *v4l2_dev = dev_get_drvdata(&op->dev);
+	struct viu_dev *dev = container_of(v4l2_dev, struct viu_dev, v4l2_dev);
+	struct v4l2_subdev *sdev = list_entry(v4l2_dev->subdevs.next,
+					      struct v4l2_subdev, list);
+	struct i2c_client *client = v4l2_get_subdevdata(sdev);
+
+	free_irq(dev->irq, (void *)dev);
+	irq_dispose_mapping(dev->irq);
+
+	clk_disable(dev->clk);
+	clk_put(dev->clk);
+
+	video_unregister_device(dev->vdev);
+	i2c_put_adapter(client->adapter);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int viu_suspend(struct of_device *op, pm_message_t state)
+{
+	struct v4l2_device *v4l2_dev = dev_get_drvdata(&op->dev);
+	struct viu_dev *dev = container_of(v4l2_dev, struct viu_dev, v4l2_dev);
+
+	clk_disable(dev->clk);
+	return 0;
+}
+
+static int viu_resume(struct of_device *op)
+{
+	struct v4l2_device *v4l2_dev = dev_get_drvdata(&op->dev);
+	struct viu_dev *dev = container_of(v4l2_dev, struct viu_dev, v4l2_dev);
+
+	clk_enable(dev->clk);
+	return 0;
+}
+#endif
+
+/*
+ * Initialization and module stuff
+ */
+static struct of_device_id mpc512x_viu_of_match[] = {
+	{
+		.compatible = "fsl,mpc5121-viu",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, mpc512x_viu_of_match);
+
+static struct of_platform_driver viu_of_platform_driver = {
+	.probe = viu_of_probe,
+	.remove = __devexit_p(viu_of_remove),
+#ifdef CONFIG_PM
+	.suspend = viu_suspend,
+	.resume = viu_resume,
+#endif
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = mpc512x_viu_of_match,
+	},
+};
+
+static int __init viu_init(void)
+{
+	return of_register_platform_driver(&viu_of_platform_driver);
+}
+
+static void __exit viu_exit(void)
+{
+	of_unregister_platform_driver(&viu_of_platform_driver);
+}
+
+module_init(viu_init);
+module_exit(viu_exit);
+
+MODULE_DESCRIPTION("Freescale Video-In(VIU)");
+MODULE_AUTHOR("Hongjun Chen");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

