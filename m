Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1258 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaBYKdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:33:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 1/2] viloop: add video loopback driver
Date: Tue, 25 Feb 2014 11:33:04 +0100
Message-Id: <1393324385-44355-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393324385-44355-1-git-send-email-hverkuil@xs4all.nl>
References: <1393324385-44355-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Create a virtual video loopback driver. It is by default singleplanar, but
by loading it with multiplanar=1 it can be set to multiplanar mode.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/Kconfig  |   24 +-
 drivers/media/platform/Makefile |    1 +
 drivers/media/platform/viloop.c | 1107 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 1128 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/platform/viloop.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index b2a4403..5eb9a63 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -239,7 +239,7 @@ menuconfig V4L_TEST_DRIVERS
 
 if V4L_TEST_DRIVERS
 config VIDEO_VIVI
-	tristate "Virtual Video Driver"
+	tristate "Virtual Video Capture Driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
 	select FONT_SUPPORT
 	select FONT_8x16
@@ -248,9 +248,22 @@ config VIDEO_VIVI
 	---help---
 	  Enables a virtual video driver. This device shows a color bar
 	  and a timestamp, as a real device would generate by using V4L2
-	  api.
-	  Say Y here if you want to test video apps or debug V4L devices.
-	  In doubt, say N.
+	  api. Use this driver to test video apps or debug V4L devices.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called vivi. If in doubt, say N.
+
+config VIDEO_VILOOP
+	tristate "Virtual Video Loopback Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF2_VMALLOC
+	---help---
+	  Enables a virtual video loopback driver. This device creates
+	  two video nodes, one for output and one for capture and anything
+	  written to the output node will appear at the capture node.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called viloop. If in doubt, say N.
 
 config VIDEO_MEM2MEM_TESTDEV
 	tristate "Virtual test device for mem2mem framework"
@@ -261,4 +274,7 @@ config VIDEO_MEM2MEM_TESTDEV
 	---help---
 	  This is a virtual test device for the memory-to-memory driver
 	  framework.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called mem2mem_testdev. If in doubt, say N.
 endif #V4L_TEST_DRIVERS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index e5269da..3cdc7df 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
+obj-$(CONFIG_VIDEO_VILOOP) += viloop.o
 
 obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
 
diff --git a/drivers/media/platform/viloop.c b/drivers/media/platform/viloop.c
new file mode 100644
index 0000000..0eca58f
--- /dev/null
+++ b/drivers/media/platform/viloop.c
@@ -0,0 +1,1107 @@
+/*
+ * Virtual Video loopback driver
+ *
+ * Based on the vivi driver:
+ * Copyright (c) 2006 by:
+ *      Mauro Carvalho Chehab <mchehab--a.t--infradead.org>
+ *      Ted Walther <ted--a.t--enumera.com>
+ *      John Sokol <sokol--a.t--videotechnology.com>
+ *      http://v4l.videotechnology.com/
+ *
+ *      Conversion to videobuf2 by Pawel Osciak & Marek Szyprowski
+ *      Copyright (c) 2010 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the BSD Licence, GNU General Public License
+ * as published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/font.h>
+#include <linux/mutex.h>
+#include <linux/videodev2.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <media/videobuf2-vmalloc.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-common.h>
+
+#define VILOOP_MODULE_NAME "viloop"
+
+#define MAX_WIDTH 1920
+#define MAX_HEIGHT 1200
+
+#define VILOOP_VERSION "0.1.0"
+
+MODULE_DESCRIPTION("Video Loopback Driver");
+MODULE_AUTHOR("Hans Verkuil");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(VILOOP_VERSION);
+
+static unsigned video_nr = -1;
+module_param(video_nr, uint, 0644);
+MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect");
+
+static unsigned n_devs = 1;
+module_param(n_devs, uint, 0644);
+MODULE_PARM_DESC(n_devs, "number of video device pairs to create");
+
+static bool multiplanar;
+module_param(multiplanar, bool, 0644);
+MODULE_PARM_DESC(multiplanar, "select multiplanar formats");
+
+static unsigned debug;
+module_param(debug, uint, 0644);
+MODULE_PARM_DESC(debug, "activates debug info");
+
+#define dprintk(dev, level, fmt, arg...) \
+	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)
+
+/* ------------------------------------------------------------------
+	Basic structures
+   ------------------------------------------------------------------*/
+
+struct viloop_fmt {
+	const char *name;
+	u32   fourcc;          /* v4l2 format id */
+	u8    depth;
+	bool  is_yuv;
+};
+
+static const struct viloop_fmt formats[] = {
+	{
+		.name     = "4:2:2, packed, YUYV",
+		.fourcc   = V4L2_PIX_FMT_YUYV,
+		.depth    = 16,
+		.is_yuv   = true,
+	},
+	{
+		.name     = "4:2:2, packed, UYVY",
+		.fourcc   = V4L2_PIX_FMT_UYVY,
+		.depth    = 16,
+		.is_yuv   = true,
+	},
+	{
+		.name     = "4:2:2, packed, YVYU",
+		.fourcc   = V4L2_PIX_FMT_YVYU,
+		.depth    = 16,
+		.is_yuv   = true,
+	},
+	{
+		.name     = "4:2:2, packed, VYUY",
+		.fourcc   = V4L2_PIX_FMT_VYUY,
+		.depth    = 16,
+		.is_yuv   = true,
+	},
+	{
+		.name     = "RGB565 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
+		.depth    = 16,
+	},
+	{
+		.name     = "RGB565 (BE)",
+		.fourcc   = V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
+		.depth    = 16,
+	},
+	{
+		.name     = "RGB555 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
+		.depth    = 16,
+	},
+	{
+		.name     = "RGB555 (BE)",
+		.fourcc   = V4L2_PIX_FMT_RGB555X, /* arrrrrgg gggbbbbb */
+		.depth    = 16,
+	},
+	{
+		.name     = "RGB24 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB24, /* rgb */
+		.depth    = 24,
+	},
+	{
+		.name     = "RGB24 (BE)",
+		.fourcc   = V4L2_PIX_FMT_BGR24, /* bgr */
+		.depth    = 24,
+	},
+	{
+		.name     = "RGB32 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB32, /* argb */
+		.depth    = 32,
+	},
+	{
+		.name     = "RGB32 (BE)",
+		.fourcc   = V4L2_PIX_FMT_BGR32, /* bgra */
+		.depth    = 32,
+	},
+};
+
+static const struct viloop_fmt mplane_formats[] = {
+	{
+		.name     = "4:2:2, planar, YUV",
+		.fourcc   = V4L2_PIX_FMT_YUV422M,
+		.depth    = 16,
+		.is_yuv   = true,
+	},
+};
+
+static const struct viloop_fmt *__get_format(u32 pixelformat)
+{
+	const struct viloop_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < ARRAY_SIZE(formats); k++) {
+		fmt = &formats[k];
+		if (fmt->fourcc == pixelformat)
+			return fmt;
+	}
+
+	if (!multiplanar)
+		return NULL;
+	for (k = 0; k < ARRAY_SIZE(mplane_formats); k++) {
+		fmt = &mplane_formats[k];
+		if (fmt->fourcc == pixelformat)
+			return fmt;
+	}
+	return NULL;
+}
+
+static const struct viloop_fmt *get_format(struct v4l2_format *f)
+{
+	return __get_format(f->fmt.pix.pixelformat);
+}
+
+/* buffer for one video frame */
+struct viloop_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_buffer	vb;
+	struct list_head	list;
+};
+
+static LIST_HEAD(viloop_devlist);
+
+struct viloop_dev {
+	struct list_head           viloop_devlist;
+	struct v4l2_device	   v4l2_dev;
+	struct video_device	   vdev_out;
+	struct video_device	   vdev_cap;
+
+	/* thread for copying video stream */
+	struct task_struct         *kthread;
+	wait_queue_head_t          wq;
+	bool			   stop_thread;
+
+	struct mutex               lock_out;
+	struct mutex               lock_cap;
+	struct mutex		   lock;
+
+	struct list_head           list_out;
+	struct list_head           list_cap;
+
+	/* video capture */
+	const struct viloop_fmt    *fmt;
+	unsigned		   pixelsize;
+	unsigned		   colorspace;
+	unsigned		   width, height;
+	unsigned		   field;
+	struct vb2_queue	   vidq_out;
+	struct vb2_queue	   vidq_cap;
+	unsigned int		   seq_count_out;
+	unsigned int		   seq_count_cap;
+};
+
+static bool viloop_can_copy(struct viloop_dev *dev)
+{
+	bool can_copy;
+
+	mutex_lock(&dev->lock_out);
+	mutex_lock(&dev->lock_cap);
+	can_copy = !list_empty(&dev->list_out) && !list_empty(&dev->list_cap);
+	mutex_unlock(&dev->lock_cap);
+	mutex_unlock(&dev->lock_out);
+	return can_copy;
+}
+
+static void viloop_copy_data(struct viloop_dev *dev)
+{
+	struct viloop_buffer *buf_out = NULL, *buf_cap = NULL;
+	unsigned planes = 1;
+	unsigned p;
+	const unsigned copy_flags = V4L2_BUF_FLAG_TIMECODE |
+				    V4L2_BUF_FLAG_KEYFRAME |
+				    V4L2_BUF_FLAG_PFRAME |
+				    V4L2_BUF_FLAG_BFRAME;
+	int state = VB2_BUF_STATE_DONE;
+
+	if (dev->fmt->fourcc == V4L2_PIX_FMT_YUV422M)
+		planes = 3;
+
+	mutex_lock(&dev->lock_out);
+	mutex_lock(&dev->lock_cap);
+	if (!vb2_is_streaming(&dev->vidq_out) || !vb2_is_streaming(&dev->vidq_cap))
+		goto unlock;
+	if (!list_empty(&dev->list_out) && !list_empty(&dev->list_cap)) {
+		buf_out = list_entry(dev->list_out.next, struct viloop_buffer, list);
+		list_del(&buf_out->list);
+		buf_cap = list_entry(dev->list_cap.next, struct viloop_buffer, list);
+		list_del(&buf_cap->list);
+	}
+	if (!buf_cap || !buf_out)
+		goto unlock;
+
+	for (p = 0; p < planes; p++) {
+		void *vbuf_out = vb2_plane_vaddr(&buf_out->vb, p);
+		void *vbuf_cap = vb2_plane_vaddr(&buf_cap->vb, p);
+		unsigned len = vb2_get_plane_payload(&buf_out->vb, p);
+
+		if (!vbuf_out || !vbuf_cap ||
+		    len > vb2_plane_size(&buf_cap->vb, p)) {
+			state = VB2_BUF_STATE_ERROR;
+			break;
+		}
+		vb2_set_plane_payload(&buf_cap->vb, p, len);
+		memcpy(vbuf_cap, vbuf_out, len);
+	}
+
+	buf_out->vb.v4l2_buf.sequence = dev->seq_count_out++;
+	buf_cap->vb.v4l2_buf.field = buf_out->vb.v4l2_buf.field;
+	buf_cap->vb.v4l2_buf.timestamp = buf_out->vb.v4l2_buf.timestamp;
+	if (buf_out->vb.v4l2_buf.flags & V4L2_BUF_FLAG_TIMECODE)
+		buf_cap->vb.v4l2_buf.timecode = buf_out->vb.v4l2_buf.timecode;
+	buf_cap->vb.v4l2_buf.flags |= buf_out->vb.v4l2_buf.flags & copy_flags;
+	vb2_buffer_done(&buf_out->vb, VB2_BUF_STATE_DONE);
+
+	buf_cap->vb.v4l2_buf.sequence = dev->seq_count_cap++;
+	vb2_buffer_done(&buf_cap->vb, state);
+
+unlock:
+	mutex_unlock(&dev->lock_cap);
+	mutex_unlock(&dev->lock_out);
+}
+
+static int viloop_thread(void *data)
+{
+	struct viloop_dev *dev = data;
+
+	set_freezable();
+	for (;;) {
+		wait_event(dev->wq, dev->stop_thread || viloop_can_copy(dev));
+
+		if (kthread_should_stop())
+			break;
+		viloop_copy_data(dev);
+	}
+	try_to_freeze();
+	return 0;
+}
+
+/* ------------------------------------------------------------------
+	Videobuf operations
+   ------------------------------------------------------------------*/
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct viloop_dev *dev = vb2_get_drv_priv(vq);
+	unsigned long size;
+
+	/*
+	 * The combination of read/write I/O and FIELD_ALTERNATE is
+	 * not allowed.
+	 */
+	if (V4L2_TYPE_IS_OUTPUT(vq->type) &&
+	    vb2_fileio_is_active(vq) && dev->field == V4L2_FIELD_ALTERNATE)
+		return -EINVAL;
+
+	size = dev->width * dev->height * dev->pixelsize;
+	if (fmt) {
+		if (fmt->fmt.pix.sizeimage < size)
+			return -EINVAL;
+		size = fmt->fmt.pix.sizeimage;
+		/* check against insane over 8K resolution buffers */
+		if (size > 7680 * 4320 * dev->pixelsize)
+			return -EINVAL;
+	}
+
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2 - vq->num_buffers;
+
+	*nplanes = 1;
+	sizes[0] = size;
+	return 0;
+}
+
+static int buffer_prepare(struct vb2_buffer *vb)
+{
+	struct viloop_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct viloop_buffer *buf = container_of(vb, struct viloop_buffer, vb);
+	unsigned long size;
+
+	/*
+	 * Theses properties only change when queue is idle, see s_fmt.
+	 * The below checks should not be performed here, on each
+	 * buffer_prepare (i.e. on each qbuf). Most of the code in this function
+	 * should thus be moved to buffer_init and s_fmt.
+	 */
+	if (dev->width  < 48 || dev->width  > MAX_WIDTH ||
+	    dev->height < 32 || dev->height > MAX_HEIGHT)
+		return -EINVAL;
+
+	size = dev->width * dev->height * dev->pixelsize;
+	if (vb2_plane_size(vb, 0) < size) {
+		dprintk(dev, 1, "%s data will not fit into plane (%lu < %lu)\n",
+				__func__, vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type) &&
+	    vb->v4l2_buf.field == V4L2_FIELD_ANY)
+		vb->v4l2_buf.field = dev->field;
+
+	vb2_set_plane_payload(&buf->vb, 0, size);
+	return 0;
+}
+
+static int queue_setup_mplane(struct vb2_queue *vq, const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct viloop_dev *dev = vb2_get_drv_priv(vq);
+	unsigned planes = 1;
+	unsigned size = dev->width * dev->height * dev->pixelsize;
+
+	if (dev->fmt->fourcc == V4L2_PIX_FMT_YUV422M)
+		planes = 3;
+	if (fmt) {
+		if (fmt->fmt.pix_mp.num_planes != planes)
+			return -EINVAL;
+		sizes[0] = fmt->fmt.pix_mp.plane_fmt[0].sizeimage;
+		if (planes == 3) {
+			sizes[1] = fmt->fmt.pix_mp.plane_fmt[1].sizeimage;
+			sizes[2] = fmt->fmt.pix_mp.plane_fmt[2].sizeimage;
+			if (sizes[0] < dev->width * dev->height ||
+			    sizes[1] < dev->width * dev->height / 2 ||
+			    sizes[2] < dev->width * dev->height / 2)
+				return -EINVAL;
+		} else if (sizes[0] < size) {
+			return -EINVAL;
+		}
+	} else {
+		if (planes == 3) {
+			sizes[0] = dev->width * dev->height;
+			sizes[1] = sizes[0] / 2;
+			sizes[2] = sizes[0] / 2;
+		} else {
+			sizes[0] = size;
+		}
+	}
+
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2 - vq->num_buffers;
+
+	*nplanes = planes;
+	return 0;
+}
+
+static int buffer_prepare_mplane(struct vb2_buffer *vb)
+{
+	struct viloop_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size;
+	unsigned planes = 1;
+
+	/*
+	 * The combination of read/write I/O and FIELD_ALTERNATE is
+	 * not allowed.
+	 */
+	if (vb2_fileio_is_active(vb->vb2_queue) &&
+	    dev->field == V4L2_FIELD_ALTERNATE)
+		return -EINVAL;
+
+	/*
+	 * Theses properties only change when queue is idle, see s_fmt.
+	 * The below checks should not be performed here, on each
+	 * buffer_prepare (i.e. on each qbuf). Most of the code in this function
+	 * should thus be moved to buffer_init and s_fmt.
+	 */
+	if (dev->width  < 48 || dev->width  > MAX_WIDTH ||
+	    dev->height < 32 || dev->height > MAX_HEIGHT)
+		return -EINVAL;
+
+	if (dev->fmt->fourcc == V4L2_PIX_FMT_YUV422M)
+		planes = 3;
+	size = dev->width * dev->height;
+	if (planes == 3) {
+		if (vb2_plane_size(vb, 0) < size) {
+			dprintk(dev, 1, "%s data will not fit into plane 0 (%lu < %lu)\n",
+					__func__, vb2_plane_size(vb, 0), size);
+			return -EINVAL;
+		}
+		if (vb2_plane_size(vb, 1) < size / 4) {
+			dprintk(dev, 1, "%s data will not fit into plane 1 (%lu < %lu)\n",
+					__func__, vb2_plane_size(vb, 1), size / 4);
+			return -EINVAL;
+		}
+		if (vb2_plane_size(vb, 2) < size / 4) {
+			dprintk(dev, 1, "%s data will not fit into plane 2 (%lu < %lu)\n",
+					__func__, vb2_plane_size(vb, 2), size / 4);
+			return -EINVAL;
+		}
+
+		vb2_set_plane_payload(vb, 0, size);
+		vb2_set_plane_payload(vb, 1, size / 2);
+		vb2_set_plane_payload(vb, 2, size / 2);
+	} else {
+		size *= dev->pixelsize;
+		if (vb2_plane_size(vb, 0) < size) {
+			dprintk(dev, 1, "%s data will not fit into plane (%lu < %lu)\n",
+					__func__, vb2_plane_size(vb, 0), size);
+			return -EINVAL;
+		}
+		vb2_set_plane_payload(vb, 0, size);
+	}
+
+	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type) &&
+	    vb->v4l2_buf.field == V4L2_FIELD_ANY)
+		vb->v4l2_buf.field = dev->field;
+
+	return 0;
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	struct viloop_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct viloop_buffer *buf = container_of(vb, struct viloop_buffer, vb);
+
+	if (vb->vb2_queue == &dev->vidq_out) {
+		mutex_lock(&dev->lock_out);
+		list_add_tail(&buf->list, &dev->list_out);
+		mutex_unlock(&dev->lock_out);
+	} else {
+		mutex_lock(&dev->lock_cap);
+		list_add_tail(&buf->list, &dev->list_cap);
+		mutex_unlock(&dev->lock_cap);
+	}
+	wake_up(&dev->wq);
+}
+
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct viloop_dev *dev = vb2_get_drv_priv(vq);
+
+	if (vq == &dev->vidq_out)
+		dev->seq_count_out = 0;
+	else
+		dev->seq_count_cap = 0;
+	vq->streaming = 1;
+	wake_up(&dev->wq);
+	return 0;
+}
+
+static void stop_streaming(struct vb2_queue *vq)
+{
+	struct viloop_dev *dev = vb2_get_drv_priv(vq);
+	struct viloop_buffer *buf;
+
+	if (vq == &dev->vidq_out) {
+		mutex_lock(&dev->lock_out);
+		while (!list_empty(&dev->list_out)) {
+			buf = list_entry(dev->list_out.next, struct viloop_buffer, list);
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		}
+		mutex_unlock(&dev->lock_out);
+	} else {
+		mutex_lock(&dev->lock_cap);
+		while (!list_empty(&dev->list_cap)) {
+			buf = list_entry(dev->list_cap.next, struct viloop_buffer, list);
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		}
+		mutex_unlock(&dev->lock_cap);
+	}
+}
+
+static const struct vb2_ops viloop_video_qops = {
+	.queue_setup		= queue_setup,
+	.buf_prepare		= buffer_prepare,
+	.buf_queue		= buffer_queue,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+static const struct vb2_ops viloop_video_mplane_qops = {
+	.queue_setup		= queue_setup_mplane,
+	.buf_prepare		= buffer_prepare_mplane,
+	.buf_queue		= buffer_queue,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+/* ------------------------------------------------------------------
+	IOCTL vidioc handling
+   ------------------------------------------------------------------*/
+static int vidioc_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *cap)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct viloop_dev *dev = video_drvdata(file);
+
+	strcpy(cap->driver, "viloop");
+	strcpy(cap->card, "viloop");
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+			"platform:%s", dev->v4l2_dev.name);
+	if (vdev == &dev->vdev_cap)
+		cap->device_caps = multiplanar ? V4L2_CAP_VIDEO_CAPTURE_MPLANE :
+				 V4L2_CAP_VIDEO_CAPTURE;
+	else
+		cap->device_caps = multiplanar ? V4L2_CAP_VIDEO_OUTPUT_MPLANE :
+				 V4L2_CAP_VIDEO_OUTPUT;
+	cap->device_caps |= V4L2_CAP_STREAMING  | V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
+		(multiplanar ? V4L2_CAP_VIDEO_CAPTURE_MPLANE |
+			       V4L2_CAP_VIDEO_OUTPUT_MPLANE
+			     : V4L2_CAP_VIDEO_CAPTURE |
+			       V4L2_CAP_VIDEO_OUTPUT);
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	const struct viloop_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(formats))
+		return -EINVAL;
+
+	fmt = &formats[f->index];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viloop_dev *dev = video_drvdata(file);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	pix->width = dev->width;
+	pix->height = dev->height;
+	pix->field = dev->field;
+	pix->pixelformat = dev->fmt->fourcc;
+	pix->bytesperline = (pix->width * dev->fmt->depth) >> 3;
+	pix->sizeimage = pix->height * pix->bytesperline;
+	pix->colorspace = dev->colorspace;
+	pix->priv = 0;
+	return 0;
+}
+
+static enum v4l2_colorspace
+viloop_check_colorspace(enum v4l2_colorspace colorspace, bool is_yuv)
+{
+	switch (colorspace) {
+	case V4L2_COLORSPACE_SMPTE170M:
+	case V4L2_COLORSPACE_SMPTE240M:
+	case V4L2_COLORSPACE_REC709:
+	case V4L2_COLORSPACE_BT878:
+	case V4L2_COLORSPACE_470_SYSTEM_M:
+	case V4L2_COLORSPACE_470_SYSTEM_BG:
+	case V4L2_COLORSPACE_JPEG:
+	case V4L2_COLORSPACE_SRGB:
+		return colorspace;
+	}
+	if (is_yuv)
+		return V4L2_COLORSPACE_SMPTE170M;
+	return V4L2_COLORSPACE_SRGB;
+}
+
+static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct viloop_dev *dev = video_drvdata(file);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	const struct viloop_fmt *fmt;
+
+	fmt = get_format(f);
+	if (!fmt) {
+		dprintk(dev, 1, "Fourcc format (0x%08x) unknown.\n",
+			pix->pixelformat);
+		pix->pixelformat = V4L2_PIX_FMT_YUYV;
+		fmt = get_format(f);
+	}
+
+	if (pix->field == V4L2_FIELD_ANY ||
+	    pix->field > V4L2_FIELD_INTERLACED_BT)
+		pix->field = V4L2_FIELD_NONE;
+	v4l_bound_align_image(&pix->width, 48, MAX_WIDTH, 2,
+			      &pix->height, 32, MAX_HEIGHT, 0, 0);
+	pix->bytesperline = (pix->width * fmt->depth) >> 3;
+	pix->sizeimage = pix->height * pix->bytesperline;
+	pix->colorspace = viloop_check_colorspace(pix->colorspace, fmt->is_yuv);
+	pix->priv = 0;
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viloop_dev *dev = video_drvdata(file);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret = vidioc_try_fmt_vid_out(file, priv, f);
+
+	if (ret < 0)
+		return ret;
+
+	if (vb2_is_busy(&dev->vidq_cap) || vb2_is_busy(&dev->vidq_out)) {
+		dprintk(dev, 1, "%s device busy\n", __func__);
+		return -EBUSY;
+	}
+
+	dev->fmt = get_format(f);
+	dev->pixelsize = dev->fmt->depth / 8;
+	dev->width = pix->width;
+	dev->height = pix->height;
+	dev->field = pix->field;
+	dev->colorspace = pix->colorspace;
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_mplane(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	const struct viloop_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(formats) + ARRAY_SIZE(mplane_formats))
+		return -EINVAL;
+
+	if (f->index < ARRAY_SIZE(formats))
+		fmt = &formats[f->index];
+	else
+		fmt = &mplane_formats[f->index - ARRAY_SIZE(formats)];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_mplane(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viloop_dev *dev = video_drvdata(file);
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+
+	mp->width = dev->width;
+	mp->height = dev->height;
+	mp->field = dev->field;
+	mp->pixelformat = dev->fmt->fourcc;
+	mp->colorspace = dev->colorspace;
+	if (dev->fmt->fourcc == V4L2_PIX_FMT_YUV422M) {
+		mp->num_planes = 3;
+		mp->plane_fmt[0].sizeimage = mp->width * mp->height;
+		mp->plane_fmt[0].bytesperline = mp->width;
+		mp->plane_fmt[1].sizeimage = mp->width * mp->height / 2;
+		mp->plane_fmt[1].bytesperline = mp->width / 2;
+		mp->plane_fmt[2].sizeimage = mp->width * mp->height / 2;
+		mp->plane_fmt[2].bytesperline = mp->width / 2;
+	} else {
+		mp->num_planes = 1;
+		mp->plane_fmt[0].bytesperline = (mp->width * dev->fmt->depth) >> 3;
+		mp->plane_fmt[0].sizeimage =
+			mp->height * mp->plane_fmt[0].bytesperline;
+	}
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	struct viloop_dev *dev = video_drvdata(file);
+	const struct viloop_fmt *fmt;
+
+	fmt = get_format(f);
+	if (!fmt) {
+		dprintk(dev, 1, "Fourcc format (0x%08x) unknown.\n",
+			mp->pixelformat);
+		mp->pixelformat = V4L2_PIX_FMT_YUV422M;
+		fmt = get_format(f);
+	}
+
+	if (mp->field == V4L2_FIELD_ANY ||
+	    mp->field > V4L2_FIELD_INTERLACED_BT)
+		mp->field = V4L2_FIELD_NONE;
+	v4l_bound_align_image(&mp->width, 48, MAX_WIDTH, 2,
+			      &mp->height, 32, MAX_HEIGHT, 0, 0);
+	if (fmt->fourcc == V4L2_PIX_FMT_YUV422M) {
+		mp->num_planes = 3;
+		memset(mp->plane_fmt, 0,
+		       mp->num_planes * sizeof(mp->plane_fmt[0]));
+		mp->plane_fmt[0].sizeimage = mp->width * mp->height;
+		mp->plane_fmt[0].bytesperline = mp->width;
+		mp->plane_fmt[1].sizeimage = mp->width * mp->height / 2;
+		mp->plane_fmt[1].bytesperline = mp->width / 2;
+		mp->plane_fmt[2].sizeimage = mp->width * mp->height / 2;
+		mp->plane_fmt[2].bytesperline = mp->width / 2;
+	} else {
+		mp->num_planes = 1;
+		memset(mp->plane_fmt, 0,
+		       mp->num_planes * sizeof(mp->plane_fmt[0]));
+		mp->plane_fmt[0].bytesperline = (mp->width * fmt->depth) >> 3;
+		mp->plane_fmt[0].sizeimage =
+			mp->height * mp->plane_fmt[0].bytesperline;
+	}
+	mp->colorspace = viloop_check_colorspace(mp->colorspace, fmt->is_yuv);
+	memset(mp->reserved, 0, sizeof(mp->reserved));
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_out_mplane(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	struct viloop_dev *dev = video_drvdata(file);
+	int ret = vidioc_try_fmt_vid_out_mplane(file, priv, f);
+
+	if (ret < 0)
+		return ret;
+
+	if (vb2_is_busy(&dev->vidq_cap) || vb2_is_busy(&dev->vidq_out)) {
+		dprintk(dev, 1, "%s device busy\n", __func__);
+		return -EBUSY;
+	}
+
+	dev->fmt = get_format(f);
+	dev->pixelsize = dev->fmt->depth / 8;
+	dev->width = mp->width;
+	dev->height = mp->height;
+	dev->colorspace = mp->colorspace;
+	return 0;
+}
+
+static int vidioc_enum_input(struct file *file, void *priv,
+				struct v4l2_input *inp)
+{
+	if (inp->index)
+		return -EINVAL;
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	strlcpy(inp->name, "Camera", sizeof(inp->name));
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
+	return i ? -EINVAL : 0;
+}
+
+static int vidioc_enum_output(struct file *file, void *priv,
+				struct v4l2_output *out)
+{
+	if (out->index)
+		return -EINVAL;
+
+	out->type = V4L2_OUTPUT_TYPE_ANALOG;
+	strlcpy(out->name, "Video Out", sizeof(out->name));
+	return 0;
+}
+
+static int vidioc_g_output(struct file *file, void *priv, unsigned int *o)
+{
+	*o = 0;
+	return 0;
+}
+
+static int vidioc_s_output(struct file *file, void *priv, unsigned int o)
+{
+	return o ? -EINVAL : 0;
+}
+
+static const struct v4l2_file_operations viloop_fops_cap = {
+	.owner		= THIS_MODULE,
+	.open           = v4l2_fh_open,
+	.release        = vb2_fop_release,
+	.read           = vb2_fop_read,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap           = vb2_fop_mmap,
+};
+
+static const struct v4l2_file_operations viloop_fops_out = {
+	.owner		= THIS_MODULE,
+	.open           = v4l2_fh_open,
+	.release        = vb2_fop_release,
+	.write          = vb2_fop_write,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap           = vb2_fop_mmap,
+};
+
+static const struct v4l2_ioctl_ops viloop_ioctl_ops = {
+	.vidioc_querycap      = vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt_vid,
+	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid,
+	.vidioc_try_fmt_vid_cap   = vidioc_g_fmt_vid,
+	.vidioc_s_fmt_vid_cap     = vidioc_g_fmt_vid,
+	.vidioc_enum_fmt_vid_out  = vidioc_enum_fmt_vid,
+	.vidioc_g_fmt_vid_out     = vidioc_g_fmt_vid,
+	.vidioc_try_fmt_vid_out   = vidioc_try_fmt_vid_out,
+	.vidioc_s_fmt_vid_out     = vidioc_s_fmt_vid_out,
+	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs   = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf   = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf      = vb2_ioctl_querybuf,
+	.vidioc_qbuf          = vb2_ioctl_qbuf,
+	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
+	.vidioc_expbuf        = vb2_ioctl_expbuf,
+	.vidioc_enum_input    = vidioc_enum_input,
+	.vidioc_g_input       = vidioc_g_input,
+	.vidioc_s_input       = vidioc_s_input,
+	.vidioc_enum_output   = vidioc_enum_output,
+	.vidioc_g_output      = vidioc_g_output,
+	.vidioc_s_output      = vidioc_s_output,
+	.vidioc_streamon      = vb2_ioctl_streamon,
+	.vidioc_streamoff     = vb2_ioctl_streamoff,
+};
+
+static const struct v4l2_ioctl_ops viloop_mplanar_ioctl_ops = {
+	.vidioc_querycap      = vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap_mplane  = vidioc_enum_fmt_vid_mplane,
+	.vidioc_g_fmt_vid_cap_mplane     = vidioc_g_fmt_vid_mplane,
+	.vidioc_try_fmt_vid_cap_mplane   = vidioc_g_fmt_vid_mplane,
+	.vidioc_s_fmt_vid_cap_mplane     = vidioc_g_fmt_vid_mplane,
+	.vidioc_enum_fmt_vid_out_mplane  = vidioc_enum_fmt_vid_mplane,
+	.vidioc_g_fmt_vid_out_mplane     = vidioc_g_fmt_vid_mplane,
+	.vidioc_try_fmt_vid_out_mplane   = vidioc_try_fmt_vid_out_mplane,
+	.vidioc_s_fmt_vid_out_mplane     = vidioc_s_fmt_vid_out_mplane,
+	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs   = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf   = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf      = vb2_ioctl_querybuf,
+	.vidioc_qbuf          = vb2_ioctl_qbuf,
+	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
+	.vidioc_expbuf        = vb2_ioctl_expbuf,
+	.vidioc_enum_input    = vidioc_enum_input,
+	.vidioc_g_input       = vidioc_g_input,
+	.vidioc_s_input       = vidioc_s_input,
+	.vidioc_enum_output   = vidioc_enum_output,
+	.vidioc_g_output      = vidioc_g_output,
+	.vidioc_s_output      = vidioc_s_output,
+	.vidioc_streamon      = vb2_ioctl_streamon,
+	.vidioc_streamoff     = vb2_ioctl_streamoff,
+};
+
+/* -----------------------------------------------------------------
+	Initialization and module stuff
+   ------------------------------------------------------------------*/
+
+static int viloop_release(void)
+{
+	struct viloop_dev *dev;
+	struct list_head *list;
+
+	while (!list_empty(&viloop_devlist)) {
+		list = viloop_devlist.next;
+		list_del(list);
+		dev = list_entry(list, struct viloop_dev, viloop_devlist);
+
+		v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+			video_device_node_name(&dev->vdev_out));
+		video_unregister_device(&dev->vdev_out);
+		v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+			video_device_node_name(&dev->vdev_cap));
+		video_unregister_device(&dev->vdev_cap);
+		dev->stop_thread = true;
+		wake_up(&dev->wq);
+		kthread_stop(dev->kthread);
+		v4l2_device_unregister(&dev->v4l2_dev);
+		kfree(dev);
+	}
+
+	return 0;
+}
+
+static int __init viloop_create_instance(int inst)
+{
+	struct viloop_dev *dev;
+	struct video_device *vfd;
+	struct vb2_queue *q;
+	int ret;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
+			"%s-%03d", VILOOP_MODULE_NAME, inst);
+	ret = v4l2_device_register(NULL, &dev->v4l2_dev);
+	if (ret)
+		goto free_dev;
+
+	dev->fmt = &formats[0];
+	dev->width = 640;
+	dev->height = 480;
+	dev->field = V4L2_FIELD_NONE;
+	dev->pixelsize = dev->fmt->depth / 8;
+	dev->colorspace = V4L2_COLORSPACE_SMPTE170M;
+
+	/* initialize locks */
+	mutex_init(&dev->lock_out);
+	mutex_init(&dev->lock_cap);
+	mutex_init(&dev->lock);
+
+	INIT_LIST_HEAD(&dev->list_out);
+	INIT_LIST_HEAD(&dev->list_cap);
+
+	init_waitqueue_head(&dev->wq);
+	dev->kthread = kthread_run(viloop_thread, dev, "%s",
+				     dev->v4l2_dev.name);
+	if (IS_ERR(dev->kthread)) {
+		v4l2_err(&dev->v4l2_dev, "kernel_thread() failed\n");
+		ret = PTR_ERR(dev->kthread);
+		goto unreg_dev;
+	}
+
+	/* initialize output queue */
+	q = &dev->vidq_out;
+	q->type = multiplanar ? V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
+				V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct viloop_buffer);
+	q->ops = multiplanar ? &viloop_video_mplane_qops : &viloop_video_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+	q->lock = &dev->lock;
+	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+
+	ret = vb2_queue_init(q);
+	if (ret)
+		goto stop_thread;
+
+	vfd = &dev->vdev_out;
+	strlcpy(vfd->name, "viloop output", sizeof(vfd->name));
+	vfd->fops = &viloop_fops_out;
+	vfd->ioctl_ops = multiplanar ? &viloop_mplanar_ioctl_ops : &viloop_ioctl_ops;
+	vfd->release = video_device_release_empty;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->vfl_dir = VFL_DIR_TX;
+	vfd->queue = &dev->vidq_out;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
+	vfd->lock = &dev->lock;
+	video_set_drvdata(vfd, dev);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, video_nr);
+	if (ret < 0)
+		goto stop_thread;
+
+	/* initialize capture queue */
+	q = &dev->vidq_cap;
+	q->type = multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+				V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct viloop_buffer);
+	q->ops = multiplanar ? &viloop_video_mplane_qops : &viloop_video_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+	q->lock = &dev->lock;
+	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+
+	ret = vb2_queue_init(q);
+	if (ret)
+		goto unreg_out;
+
+	vfd = &dev->vdev_cap;
+	strlcpy(vfd->name, "viloop capture", sizeof(vfd->name));
+	vfd->fops = &viloop_fops_cap;
+	vfd->ioctl_ops = multiplanar ? &viloop_mplanar_ioctl_ops : &viloop_ioctl_ops;
+	vfd->release = video_device_release_empty;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->queue = &dev->vidq_cap;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
+	vfd->lock = &dev->lock;
+	video_set_drvdata(vfd, dev);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, video_nr);
+	if (ret < 0)
+		goto unreg_out;
+
+	/* Now that everything is fine, let's add it to device list */
+	list_add_tail(&dev->viloop_devlist, &viloop_devlist);
+
+	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
+		  video_device_node_name(vfd));
+	return 0;
+
+unreg_out:
+	video_unregister_device(&dev->vdev_out);
+stop_thread:
+	dev->stop_thread = true;
+	wake_up(&dev->wq);
+	kthread_stop(dev->kthread);
+unreg_dev:
+	v4l2_device_unregister(&dev->v4l2_dev);
+free_dev:
+	kfree(dev);
+	return ret;
+}
+
+/* This routine allocates from 1 to n_devs virtual drivers.
+
+   The real maximum number of virtual drivers will depend on how many drivers
+   will succeed. This is limited to the maximum number of devices that
+   videodev supports, which is equal to VIDEO_NUM_DEVICES.
+ */
+static int __init viloop_init(void)
+{
+	int ret = 0, i;
+
+	if (n_devs <= 0)
+		n_devs = 1;
+
+	for (i = 0; i < n_devs; i++) {
+		ret = viloop_create_instance(i);
+		if (ret) {
+			/* If some instantiations succeeded, keep driver */
+			if (i)
+				ret = 0;
+			break;
+		}
+	}
+
+	if (ret < 0) {
+		pr_err("viloop: error %d while loading driver\n", ret);
+		return ret;
+	}
+
+	pr_info("Video Loopback Driver successfully loaded\n");
+
+	/* n_devs will reflect the actual number of allocated devices */
+	n_devs = i;
+
+	return ret;
+}
+
+static void __exit viloop_exit(void)
+{
+	viloop_release();
+}
+
+module_init(viloop_init);
+module_exit(viloop_exit);
-- 
1.9.0

