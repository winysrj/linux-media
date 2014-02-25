Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3817 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBYKdQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:33:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/2] vioverlay: add video overlay test driver
Date: Tue, 25 Feb 2014 11:33:05 +0100
Message-Id: <1393324385-44355-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393324385-44355-1-git-send-email-hverkuil@xs4all.nl>
References: <1393324385-44355-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver creates a framebuffer, a video output device and a video capture
device which shows the framebuffer blended with the contents of the output
device. This can be combined with vivi to have both a capture overlay (vivi
overlaying the video into the framebuffer) and an output overlay (the output
video node provides the video for that).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/Kconfig     |   16 +
 drivers/media/platform/Makefile    |    1 +
 drivers/media/platform/vioverlay.c | 1532 ++++++++++++++++++++++++++++++++++++
 3 files changed, 1549 insertions(+)
 create mode 100644 drivers/media/platform/vioverlay.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 5eb9a63..50263a1 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -265,6 +265,22 @@ config VIDEO_VILOOP
 	  To compile this driver as a module, choose M here: the module
 	  will be called viloop. If in doubt, say N.
 
+config VIDEO_VIOVERLAY
+	tristate "Virtual Video Overlay Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF2_VMALLOC
+	---help---
+	  Enables a virtual video overlay driver. This device creates
+	  a framebuffer device, a video output device and a video capture
+	  device. The output device can be used as the source of the output
+	  video which will be combined with the framebuffer and the result
+	  will be available through the capture device.
+	  Drivers supporting capture or output overlay can use this driver
+	  for testing.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called vioverlay. If in doubt, say N.
+
 config VIDEO_MEM2MEM_TESTDEV
 	tristate "Virtual test device for mem2mem framework"
 	depends on VIDEO_DEV && VIDEO_V4L2
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 3cdc7df..fe5382c 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_VILOOP) += viloop.o
+obj-$(CONFIG_VIDEO_VIOVERLAY) += vioverlay.o
 
 obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
 
diff --git a/drivers/media/platform/vioverlay.c b/drivers/media/platform/vioverlay.c
new file mode 100644
index 0000000..6915776
--- /dev/null
+++ b/drivers/media/platform/vioverlay.c
@@ -0,0 +1,1532 @@
+/*
+ * Virtual Video Overlay driver
+ *
+ * Based on the viovl driver:
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
+#include <linux/fb.h>
+#include <media/videobuf2-vmalloc.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-common.h>
+
+#ifdef CONFIG_MTRR
+#include <asm/mtrr.h>
+#endif
+
+#define VIOVL_MODULE_NAME "vioverlay"
+
+#define MAX_WIDTH  720
+#define MAX_HEIGHT 576
+#define MAX_CLIPS  16
+
+#define VIOVL_VERSION "0.1.0"
+
+MODULE_DESCRIPTION("Video Overlay Driver");
+MODULE_AUTHOR("Hans Verkuil");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(VIOVL_VERSION);
+
+static unsigned video_nr = -1;
+module_param(video_nr, uint, 0644);
+MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect");
+
+static unsigned n_devs = 1;
+module_param(n_devs, uint, 0644);
+MODULE_PARM_DESC(n_devs, "number of video device pairs to create");
+
+static unsigned debug;
+module_param(debug, uint, 0644);
+MODULE_PARM_DESC(debug, "activates debug info");
+
+#define dprintk(dev, level, fmt, arg...) \
+	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)
+
+#define VIOVL_CID_CUSTOM_BASE	(V4L2_CID_USER_BASE | 0xf000)
+
+/* ------------------------------------------------------------------
+	Basic structures
+   ------------------------------------------------------------------*/
+
+struct viovl_fmt {
+	const char *name;
+	u32   fourcc;          /* v4l2 format id */
+	u8    depth;
+	bool  is_yuv;
+};
+
+static const struct viovl_fmt formats[] = {
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
+};
+
+static const struct viovl_fmt *__get_format(u32 pixelformat)
+{
+	const struct viovl_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < ARRAY_SIZE(formats); k++) {
+		fmt = &formats[k];
+		if (fmt->fourcc == pixelformat)
+			return fmt;
+	}
+	return NULL;
+}
+
+static const struct viovl_fmt *get_format(struct v4l2_format *f)
+{
+	return __get_format(f->fmt.pix.pixelformat);
+}
+
+/* buffer for one video frame */
+struct viovl_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_buffer	vb;
+	struct list_head	list;
+};
+
+static LIST_HEAD(viovl_devlist);
+
+struct viovl_dev {
+	struct list_head           viovl_devlist;
+	struct v4l2_device	   v4l2_dev;
+	struct v4l2_ctrl_handler   ctrl_handler;
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
+	const struct viovl_fmt    *fmt;
+	unsigned		   pixelsize;
+	unsigned		   colorspace;
+	unsigned		   width, height;
+	unsigned		   field;
+	struct vb2_queue	   vidq_out;
+	struct vb2_queue	   vidq_cap;
+	unsigned int		   seq_count_out;
+	unsigned int		   seq_count_cap;
+	unsigned		   fps;
+	bool			   do_overlay;
+	int			   overlay_top, overlay_left;
+	void			   *bitmap;
+	struct v4l2_clip	   clips[MAX_CLIPS];
+	struct v4l2_clip	   try_clips[MAX_CLIPS];
+	unsigned		   clipcount;
+
+	/* Physical base address */
+	unsigned long video_pbase;
+	/* Mapped base address */
+	void *video_vbase;
+	/* Buffer size */
+	u32 video_buffer_size;
+
+	/* Current dimensions */
+	int display_width;
+	int display_height;
+	int display_byte_stride;
+
+	/* Current bits per pixel */
+	int bits_per_pixel;
+	int bytes_per_pixel;
+
+	/* Frame buffer stuff */
+	struct fb_info viovl_fb_info;
+	struct fb_var_screeninfo viovl_fb_defined;
+	struct fb_fix_screeninfo viovl_fb_fix;
+};
+
+static void overlay_capture(struct viovl_dev *dev, void *cap, unsigned len)
+{
+	void *vbase = dev->video_vbase;
+	unsigned y;
+
+	for (y = 0; y < dev->display_height; y++) {
+		memcpy(cap, vbase, dev->display_byte_stride);
+		cap += dev->display_byte_stride;
+		vbase += dev->display_byte_stride;
+	}
+}
+
+static bool valid_pix(struct viovl_dev *dev, int win_y, int win_x, int fb_y, int fb_x)
+{
+	bool valid = true;
+
+	if (dev->bitmap)
+		valid = ((__u8 *)dev->bitmap)[((dev->width + 7) / 8) * win_y + win_x / 8] & (1 << (win_x & 7));
+	if (valid && dev->clipcount) {
+		int i;
+
+		for (i = 0; i < dev->clipcount; i++) {
+			struct v4l2_rect *r = &dev->clips[i].c;
+
+			if (fb_y >= r->top && fb_y < r->top + r->height &&
+			    fb_x >= r->left && fb_x < r->left + r->width)
+				return true;
+		}
+		valid = false;
+	}
+	return valid;
+}
+
+static void osd_overlay_output(struct viovl_dev *dev, void *cap, const void *out, unsigned len)
+{
+	bool quick = dev->bitmap == NULL && dev->clipcount == 0;
+	unsigned stride = dev->width * dev->pixelsize;
+	int x, y, w, out_x = 0;
+
+	x = dev->overlay_left;
+	w = dev->width;
+	if (x < 0) {
+		out_x = -x;
+		w = w - out_x;
+		x = 0;
+	} else {
+		w = dev->display_width - x;
+		if (w > dev->width)
+			w = dev->width;
+	}
+	if (w <= 0)
+		return;
+	if (dev->overlay_top >= 0)
+		cap += dev->overlay_top * dev->display_byte_stride;
+	for (y = dev->overlay_top; y < dev->overlay_top + (int)dev->height; y++) {
+		if (y >= 0 && y < dev->display_height) {
+			if (quick) {
+				memcpy(cap + x * dev->pixelsize,
+				       out + out_x * dev->pixelsize, w * dev->pixelsize);
+			} else {
+				int px;
+
+				for (px = 0; px < w; px++) {
+					if (valid_pix(dev, y - dev->overlay_top, px + out_x,
+							   y, px + x))
+						memcpy(cap + (px + x) * dev->pixelsize,
+						       out + (px + out_x) * dev->pixelsize,
+						       dev->pixelsize);
+				}
+			}
+			cap += dev->display_byte_stride;
+		}
+		out += stride;
+	}
+}
+
+static void viovl_blend(struct viovl_dev *dev, struct viovl_buffer *buf)
+{
+	struct viovl_buffer *osd_ovl_buf = NULL;
+	void *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	unsigned len = vb2_get_plane_payload(&buf->vb, 0);
+	void *osd_ovl_vbuf = NULL;
+	unsigned osd_ovl_len;
+	bool keep_osd_ovl_buf = true;
+
+	mutex_lock(&dev->lock_out);
+	if (!list_empty(&dev->list_out)) {
+		osd_ovl_buf = list_entry(dev->list_out.next, struct viovl_buffer, list);
+		keep_osd_ovl_buf = list_is_singular(&dev->list_out);
+		if (!keep_osd_ovl_buf)
+			list_del(&osd_ovl_buf->list);
+		osd_ovl_vbuf = vb2_plane_vaddr(&osd_ovl_buf->vb, 0);
+		osd_ovl_len = vb2_get_plane_payload(&osd_ovl_buf->vb, 0);
+	}
+	mutex_unlock(&dev->lock_out);
+
+	overlay_capture(dev, vbuf, len);
+
+	if (dev->do_overlay && osd_ovl_vbuf)
+		osd_overlay_output(dev, vbuf, osd_ovl_vbuf, osd_ovl_len);
+
+	if (osd_ovl_buf) {
+		v4l2_get_timestamp(&osd_ovl_buf->vb.v4l2_buf.timestamp);
+		if (!keep_osd_ovl_buf)
+			vb2_buffer_done(&osd_ovl_buf->vb, VB2_BUF_STATE_DONE);
+	}
+}
+
+static void viovl_thread_tick(struct viovl_dev *dev)
+{
+	struct viovl_buffer *buf;
+
+	mutex_lock(&dev->lock_cap);
+	if (list_empty(&dev->list_cap)) {
+		mutex_unlock(&dev->lock_cap);
+		mutex_lock(&dev->lock_out);
+		if (!list_empty(&dev->list_out)) {
+			buf = list_entry(dev->list_out.next, struct viovl_buffer, list);
+			if (!list_is_singular(&dev->list_out)) {
+				list_del(&buf->list);
+				vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+			}
+		}
+		mutex_unlock(&dev->lock_out);
+		return;
+	}
+
+	buf = list_entry(dev->list_cap.next, struct viovl_buffer, list);
+	list_del(&buf->list);
+	mutex_unlock(&dev->lock_cap);
+
+	viovl_blend(dev, buf);
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+}
+
+static int viovl_thread(void *data)
+{
+	struct viovl_dev *dev = data;
+	int timeout = msecs_to_jiffies(1000 / dev->fps);
+
+	dprintk(dev, 1, "thread started\n");
+
+	set_freezable();
+	for (;;) {
+		if (kthread_should_stop())
+			break;
+
+		viovl_thread_tick(dev);
+		schedule_timeout_interruptible(timeout);
+		try_to_freeze();
+	}
+	dprintk(dev, 1, "thread: exit\n");
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
+	struct viovl_dev *dev = vb2_get_drv_priv(vq);
+	unsigned long size;
+
+	/*
+	 * The combination of read/write I/O and FIELD_ALTERNATE is
+	 * not allowed.
+	 */
+	if (vb2_fileio_is_active(vq) && dev->field == V4L2_FIELD_ALTERNATE)
+		return -EINVAL;
+
+	if (V4L2_TYPE_IS_OUTPUT(vq->type))
+		size = dev->width * dev->height * dev->pixelsize;
+	else
+		size = dev->display_height * dev->display_byte_stride;
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
+	struct viovl_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct viovl_buffer *buf = container_of(vb, struct viovl_buffer, vb);
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
+	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type))
+		size = dev->width * dev->height * dev->pixelsize;
+	else
+		size = dev->display_height * dev->display_byte_stride;
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
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	struct viovl_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct viovl_buffer *buf = container_of(vb, struct viovl_buffer, vb);
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
+	struct viovl_dev *dev = vb2_get_drv_priv(vq);
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
+	struct viovl_dev *dev = vb2_get_drv_priv(vq);
+	struct viovl_buffer *buf;
+
+	if (vq == &dev->vidq_out) {
+		mutex_lock(&dev->lock_out);
+		while (!list_empty(&dev->list_out)) {
+			buf = list_entry(dev->list_out.next, struct viovl_buffer, list);
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		}
+		mutex_unlock(&dev->lock_out);
+	} else {
+		mutex_lock(&dev->lock_cap);
+		while (!list_empty(&dev->list_cap)) {
+			buf = list_entry(dev->list_cap.next, struct viovl_buffer, list);
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		}
+		mutex_unlock(&dev->lock_cap);
+	}
+}
+
+static const struct vb2_ops viovl_video_qops = {
+	.queue_setup		= queue_setup,
+	.buf_prepare		= buffer_prepare,
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
+	struct viovl_dev *dev = video_drvdata(file);
+
+	strcpy(cap->driver, "viovl");
+	strcpy(cap->card, "viovl");
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+			"platform:%s", dev->v4l2_dev.name);
+	if (vdev == &dev->vdev_cap)
+		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE;
+	else
+		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
+	cap->device_caps |= V4L2_CAP_STREAMING  | V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
+		     V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
+		     V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	const struct viovl_fmt *fmt;
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
+	struct viovl_dev *dev = video_drvdata(file);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	pix->width = dev->display_width;
+	pix->height = dev->display_height;
+	pix->field = dev->field;
+	pix->pixelformat = dev->fmt->fourcc;
+	pix->bytesperline = (pix->width * dev->fmt->depth) >> 3;
+	pix->sizeimage = pix->height * pix->bytesperline;
+	pix->colorspace = dev->colorspace;
+	pix->priv = 0;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viovl_dev *dev = video_drvdata(file);
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
+viovl_check_colorspace(enum v4l2_colorspace colorspace, bool is_yuv)
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
+	struct viovl_dev *dev = video_drvdata(file);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	const struct viovl_fmt *fmt;
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
+	pix->colorspace = viovl_check_colorspace(pix->colorspace, fmt->is_yuv);
+	pix->priv = 0;
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viovl_dev *dev = video_drvdata(file);
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
+static int vidioc_g_fmt_vid_out_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viovl_dev *dev = video_drvdata(file);
+	struct v4l2_window *win = &f->fmt.win;
+	unsigned clipcount = win->clipcount;
+
+	win->w.top = dev->overlay_top;
+	win->w.left = dev->overlay_left;
+	win->w.width = dev->width;
+	win->w.height = dev->height;
+	win->clipcount = dev->clipcount;
+	win->field = V4L2_FIELD_NONE;
+	if (clipcount > dev->clipcount)
+		clipcount = dev->clipcount;
+	if (dev->bitmap == NULL)
+		win->bitmap = NULL;
+	else if (win->bitmap) {
+		if (copy_to_user(win->bitmap, dev->bitmap,
+		    ((dev->width + 7) / 8) * dev->height))
+			return -EFAULT;
+	}
+	if (clipcount && win->clips) {
+		if (copy_to_user(win->clips, dev->clips,
+				 clipcount * sizeof(dev->clips[0])))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static bool rect_overlap(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
+{
+	/*
+	 * IF the left side of r1 is to the right of the right side of r2 OR
+	 *    the left side of r2 is to the right of the right side of r1 THEN
+	 * they do not overlap.
+	 */
+	if (r1->left >= r2->left + r2->width ||
+	    r2->left >= r1->left + r1->width)
+		return false;
+	/*
+	 * IF the top side of r1 is below the bottom of r2 OR
+	 *    the top side of r2 is below the bottom of r1 THEN
+	 * they do not overlap.
+	 */
+	if (r1->top >= r2->top + r2->height ||
+	    r2->top >= r1->top + r1->height)
+		return false;
+	return true;
+}
+
+static int vidioc_try_fmt_vid_out_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viovl_dev *dev = video_drvdata(file);
+	struct v4l2_window *win = &f->fmt.win;
+	int i, j;
+
+	win->w.left = clamp_t(int, win->w.left,
+			      -dev->display_width, dev->display_width);
+	win->w.top = clamp_t(int, win->w.top,
+			     -dev->display_height, dev->display_height);
+	win->w.width = dev->width;
+	win->w.height = dev->height;
+	win->field = V4L2_FIELD_NONE;
+	win->chromakey = 0;
+	win->global_alpha = 0;
+	if (win->clipcount && !win->clips)
+		win->clipcount = 0;
+	if (win->clipcount > MAX_CLIPS)
+		win->clipcount = MAX_CLIPS;
+	if (win->clipcount) {
+		if (copy_from_user(dev->try_clips, win->clips,
+				   win->clipcount * sizeof(dev->clips[0])))
+			return -EFAULT;
+		for (i = 0; i < win->clipcount; i++) {
+			struct v4l2_rect *r = &dev->try_clips[i].c;
+
+			r->top = clamp_t(s32, r->top, 0, dev->display_height - 1);
+			r->height = clamp_t(s32, r->height, 1, dev->display_height - r->top);
+			r->left = clamp_t(u32, r->left, 0, dev->display_width - 1);
+			r->width = clamp_t(u32, r->width, 1, dev->display_width - r->left);
+		}
+		/*
+		 * Yeah, so sue me, it's an O(n^2) algorithm. But n is a small
+		 * number and it's typically a one-time deal.
+		 */
+		for (i = 0; i < win->clipcount - 1; i++) {
+			struct v4l2_rect *r1 = &dev->try_clips[i].c;
+
+			for (j = i + 1; j < win->clipcount; j++) {
+				struct v4l2_rect *r2 = &dev->try_clips[j].c;
+
+				if (rect_overlap(r1, r2))
+					return -EINVAL;
+			}
+		}
+		if (copy_to_user(win->clips, dev->try_clips,
+				 win->clipcount * sizeof(dev->clips[0])))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_out_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct viovl_dev *dev = video_drvdata(file);
+	struct v4l2_window *win = &f->fmt.win;
+	int ret = vidioc_try_fmt_vid_out_overlay(file, priv, f);
+	unsigned bitmap_size = ((dev->width + 7) / 8) * dev->height;
+	unsigned clips_size = win->clipcount * sizeof(dev->clips[0]);
+	void *new_bitmap = NULL;
+
+	if (ret)
+		return ret;
+
+	if (win->bitmap) {
+		new_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+
+		if (new_bitmap == NULL)
+			return -ENOMEM;
+		if (copy_from_user(new_bitmap, win->bitmap, bitmap_size)) {
+			kfree(new_bitmap);
+			return -EFAULT;
+		}
+	}
+
+	dev->overlay_top = win->w.top;
+	dev->overlay_left = win->w.left;
+	kfree(dev->bitmap);
+	dev->bitmap = new_bitmap;
+	dev->clipcount = win->clipcount;
+	if (dev->clipcount)
+		memcpy(dev->clips, dev->try_clips, clips_size);
+	return ret;
+}
+
+static int vidioc_overlay(struct file *file, void *fh, unsigned int i)
+{
+	struct viovl_dev *dev = video_drvdata(file);
+
+	dev->do_overlay = !!i;
+	return 0;
+}
+
+static int vidioc_g_fbuf(struct file *file, void *fh,
+				struct v4l2_framebuffer *a)
+{
+	struct viovl_dev *dev = video_drvdata(file);
+
+	a->capability = V4L2_FBUF_CAP_EXTERNOVERLAY |
+			V4L2_FBUF_CAP_BITMAP_CLIPPING |
+			V4L2_FBUF_CAP_LIST_CLIPPING;
+	a->flags = V4L2_FBUF_FLAG_OVERLAY;
+	a->base = (void *)dev->video_pbase;
+	a->fmt.width = dev->display_width;
+	a->fmt.height = dev->display_height;
+	if (dev->viovl_fb_defined.green.length == 5)
+		a->fmt.pixelformat = V4L2_PIX_FMT_RGB555;
+	else
+		a->fmt.pixelformat = V4L2_PIX_FMT_RGB565;
+	a->fmt.bytesperline = dev->display_byte_stride;
+	a->fmt.sizeimage = a->fmt.height * a->fmt.bytesperline;
+	a->fmt.colorspace = V4L2_COLORSPACE_SRGB;
+	a->fmt.priv = 0;
+	return 0;
+}
+
+static int vidioc_s_fbuf(struct file *file, void *fh,
+				const struct v4l2_framebuffer *a)
+{
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
+/*
+ * Order: white, yellow, cyan, green, magenta, red, blue, black,
+ * and same again with the alpha bit set (if any)
+ */
+static const u16 rgb555[16] = {
+	0x7fff, 0x7fe0, 0x03ff, 0x03e0, 0x7c1f, 0x7c00, 0x001f, 0x0000,
+	0xffff, 0xffe0, 0x83ff, 0x83e0, 0xfc1f, 0xfc00, 0x801f, 0x8000
+};
+
+static const u16 rgb565[16] = {
+	0xffff, 0xffe0, 0x07ff, 0x07e0, 0xf81f, 0xf800, 0x001f, 0x0000,
+	0xffff, 0xffe0, 0x07ff, 0x07e0, 0xf81f, 0xf800, 0x001f, 0x0000
+};
+
+static void viovl_clear_fb(struct viovl_dev *dev)
+{
+	void *p = dev->video_vbase;
+	const u16 *rgb = rgb555;
+	unsigned x, y;
+
+	if (dev->viovl_fb_defined.green.length == 6)
+		rgb = rgb565;
+
+	for (y = 0; y < dev->display_height; y++) {
+		u16 *d = p;
+
+		for (x = 0; x < dev->display_width; x++)
+			d[x] = rgb[(y / 16 + x / 16) % 16];
+		p += dev->display_byte_stride;
+	}
+}
+
+static int viovl_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct viovl_dev *dev = container_of(ctrl->handler, struct viovl_dev, ctrl_handler);
+
+	switch (ctrl->id) {
+	case VIOVL_CID_CUSTOM_BASE:
+		viovl_clear_fb(dev);
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/* ------------------------------------------------------------------
+	File operations for the device
+   ------------------------------------------------------------------*/
+
+static const struct v4l2_ctrl_ops viovl_ctrl_ops = {
+	.s_ctrl = viovl_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config viovl_ctrl_clear_fb = {
+	.ops = &viovl_ctrl_ops,
+	.id = VIOVL_CID_CUSTOM_BASE + 0,
+	.name = "Clear Framebuffer",
+	.type = V4L2_CTRL_TYPE_BUTTON,
+};
+
+static const struct v4l2_file_operations viovl_fops_cap = {
+	.owner		= THIS_MODULE,
+	.open           = v4l2_fh_open,
+	.release        = vb2_fop_release,
+	.read           = vb2_fop_read,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap           = vb2_fop_mmap,
+};
+
+static const struct v4l2_file_operations viovl_fops_out = {
+	.owner		= THIS_MODULE,
+	.open           = v4l2_fh_open,
+	.release        = vb2_fop_release,
+	.write          = vb2_fop_write,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap           = vb2_fop_mmap,
+};
+
+static const struct v4l2_ioctl_ops viovl_ioctl_ops = {
+	.vidioc_querycap      = vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt_vid,
+	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid,
+	.vidioc_try_fmt_vid_cap   = vidioc_g_fmt_vid,
+	.vidioc_s_fmt_vid_cap     = vidioc_g_fmt_vid,
+
+	.vidioc_enum_fmt_vid_out  = vidioc_enum_fmt_vid,
+	.vidioc_g_fmt_vid_out     = vidioc_g_fmt_vid_out,
+	.vidioc_try_fmt_vid_out   = vidioc_try_fmt_vid_out,
+	.vidioc_s_fmt_vid_out     = vidioc_s_fmt_vid_out,
+
+	.vidioc_g_fmt_vid_out_overlay    = vidioc_g_fmt_vid_out_overlay,
+	.vidioc_try_fmt_vid_out_overlay  = vidioc_try_fmt_vid_out_overlay,
+	.vidioc_s_fmt_vid_out_overlay    = vidioc_s_fmt_vid_out_overlay,
+
+	.vidioc_overlay       = vidioc_overlay,
+	.vidioc_g_fbuf        = vidioc_g_fbuf,
+	.vidioc_s_fbuf        = vidioc_s_fbuf,
+
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
+/* --------------------------------------------------------------------- */
+
+static int viovl_fb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
+{
+	struct viovl_dev *dev = (struct viovl_dev *)info->par;
+
+	switch (cmd) {
+	case FBIOGET_VBLANK: {
+		struct fb_vblank vblank;
+
+		vblank.flags = FB_VBLANK_HAVE_COUNT | FB_VBLANK_HAVE_VCOUNT |
+			FB_VBLANK_HAVE_VSYNC;
+		vblank.count = 0;
+		vblank.vcount = 0;
+		vblank.hcount = 0;
+		if (copy_to_user((void __user *)arg, &vblank, sizeof(vblank)))
+			return -EFAULT;
+		return 0;
+	}
+
+	default:
+		dprintk(dev, 1, "Unknown ioctl %08x\n", cmd);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Framebuffer device handling */
+
+static int viovl_fb_set_var(struct viovl_dev *dev, struct fb_var_screeninfo *var)
+{
+	dprintk(dev, 1, "viovl_fb_set_var\n");
+
+	if (var->bits_per_pixel != 16) {
+		dprintk(dev, 1, "viovl_fb_set_var - Invalid bpp\n");
+		return -EINVAL;
+	}
+	dev->display_byte_stride = var->xres * dev->bytes_per_pixel;
+
+	return 0;
+}
+
+static int viovl_fb_get_fix(struct viovl_dev *dev, struct fb_fix_screeninfo *fix)
+{
+	dprintk(dev, 1, "viovl_fb_get_fix\n");
+	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
+	strlcpy(fix->id, "vioverlay fb", sizeof(fix->id));
+	fix->smem_start = dev->video_pbase;
+	fix->smem_len = dev->video_buffer_size;
+	fix->type = FB_TYPE_PACKED_PIXELS;
+	fix->visual = FB_VISUAL_TRUECOLOR;
+	fix->xpanstep = 1;
+	fix->ypanstep = 1;
+	fix->ywrapstep = 0;
+	fix->line_length = dev->display_byte_stride;
+	fix->accel = FB_ACCEL_NONE;
+	return 0;
+}
+
+/* Check the requested display mode, returning -EINVAL if we can't
+   handle it. */
+
+static int _viovl_fb_check_var(struct fb_var_screeninfo *var, struct viovl_dev *dev)
+{
+	dprintk(dev, 1, "viovl_fb_check_var\n");
+
+	var->bits_per_pixel = 16;
+	if (var->green.length == 5) {
+		var->red.offset = 10;
+		var->red.length = 5;
+		var->green.offset = 5;
+		var->green.length = 5;
+		var->blue.offset = 0;
+		var->blue.length = 5;
+		var->transp.offset = 15;
+		var->transp.length = 1;
+	} else {
+		var->red.offset = 11;
+		var->red.length = 5;
+		var->green.offset = 5;
+		var->green.length = 6;
+		var->blue.offset = 0;
+		var->blue.length = 5;
+		var->transp.offset = 0;
+		var->transp.length = 0;
+	}
+	var->xoffset = var->yoffset = 0;
+	var->left_margin = var->upper_margin = 0;
+	var->nonstd = 0;
+
+	var->vmode &= ~FB_VMODE_MASK;
+	var->vmode = FB_VMODE_NONINTERLACED;
+
+	/* Dummy values */
+	var->hsync_len = 24;
+	var->vsync_len = 2;
+	var->pixclock = 84316;
+	var->right_margin = 776;
+	var->lower_margin = 591;
+	return 0;
+}
+
+static int viovl_fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	struct viovl_dev *dev = (struct viovl_dev *) info->par;
+	dprintk(dev, 1, "viovl_fb_check_var\n");
+	return _viovl_fb_check_var(var, dev);
+}
+
+static int viovl_fb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	return 0;
+}
+
+static int viovl_fb_set_par(struct fb_info *info)
+{
+	int rc = 0;
+	struct viovl_dev *dev = (struct viovl_dev *) info->par;
+
+	dprintk(dev, 1, "viovl_fb_set_par\n");
+
+	rc = viovl_fb_set_var(dev, &info->var);
+	viovl_fb_get_fix(dev, &info->fix);
+	return rc;
+}
+
+static int viovl_fb_setcolreg(unsigned regno, unsigned red, unsigned green,
+				unsigned blue, unsigned transp,
+				struct fb_info *info)
+{
+	u32 color, *palette;
+
+	if (regno >= info->cmap.len)
+		return -EINVAL;
+
+	color = ((transp & 0xFF00) << 16) | ((red & 0xFF00) << 8) |
+		 (green & 0xFF00) | ((blue & 0xFF00) >> 8);
+	if (regno >= 16)
+		return -EINVAL;
+
+	palette = info->pseudo_palette;
+	if (info->var.bits_per_pixel == 16) {
+		switch (info->var.green.length) {
+		case 6:
+			color = (red & 0xf800) |
+				((green & 0xfc00) >> 5) |
+				((blue & 0xf800) >> 11);
+			break;
+		case 5:
+			color = ((red & 0xf800) >> 1) |
+				((green & 0xf800) >> 6) |
+				((blue & 0xf800) >> 11) |
+				(transp ? 0x8000 : 0);
+			break;
+		}
+	}
+	palette[regno] = color;
+	return 0;
+}
+
+/* We don't really support blanking. All this does is enable or
+   disable the OSD. */
+static int viovl_fb_blank(int blank_mode, struct fb_info *info)
+{
+	struct viovl_dev *dev = (struct viovl_dev *)info->par;
+
+	dprintk(dev, 1, "Set blanking mode : %d\n", blank_mode);
+	switch (blank_mode) {
+	case FB_BLANK_UNBLANK:
+		break;
+	case FB_BLANK_NORMAL:
+	case FB_BLANK_HSYNC_SUSPEND:
+	case FB_BLANK_VSYNC_SUSPEND:
+	case FB_BLANK_POWERDOWN:
+		break;
+	}
+	return 0;
+}
+
+static struct fb_ops viovl_fb_ops = {
+	.owner = THIS_MODULE,
+	.fb_check_var   = viovl_fb_check_var,
+	.fb_set_par     = viovl_fb_set_par,
+	.fb_setcolreg   = viovl_fb_setcolreg,
+	.fb_fillrect    = cfb_fillrect,
+	.fb_copyarea    = cfb_copyarea,
+	.fb_imageblit   = cfb_imageblit,
+	.fb_cursor      = NULL,
+	.fb_ioctl       = viovl_fb_ioctl,
+	.fb_pan_display = viovl_fb_pan_display,
+	.fb_blank       = viovl_fb_blank,
+};
+
+/* Initialization */
+
+
+/* Setup our initial video mode */
+static int viovl_fb_init_vidmode(struct viovl_dev *dev)
+{
+	struct v4l2_rect start_window;
+
+	/* Color mode */
+
+	dev->bits_per_pixel = 16;
+	dev->bytes_per_pixel = dev->bits_per_pixel / 8;
+
+	start_window.width = MAX_WIDTH;
+	start_window.left = 0;
+
+	dev->display_byte_stride = start_window.width * dev->bytes_per_pixel;
+
+	/* Vertical size & position */
+
+	start_window.height = MAX_HEIGHT;
+	start_window.top = 0;
+
+	dev->display_width = start_window.width;
+	dev->display_height = start_window.height;
+
+	/* Generate a valid fb_var_screeninfo */
+
+	dev->viovl_fb_defined.xres = dev->display_width;
+	dev->viovl_fb_defined.yres = dev->display_height;
+	dev->viovl_fb_defined.xres_virtual = dev->display_width;
+	dev->viovl_fb_defined.yres_virtual = dev->display_height;
+	dev->viovl_fb_defined.bits_per_pixel = dev->bits_per_pixel;
+	dev->viovl_fb_defined.vmode = FB_VMODE_NONINTERLACED;
+	dev->viovl_fb_defined.left_margin = start_window.left + 1;
+	dev->viovl_fb_defined.upper_margin = start_window.top + 1;
+	dev->viovl_fb_defined.accel_flags = FB_ACCEL_NONE;
+	dev->viovl_fb_defined.nonstd = 0;
+	/* set default to 1:5:5:5 */
+	dev->viovl_fb_defined.green.length = 5;
+
+	/* We've filled in the most data, let the usual mode check
+	   routine fill in the rest. */
+	_viovl_fb_check_var(&dev->viovl_fb_defined, dev);
+
+	/* Generate valid fb_fix_screeninfo */
+
+	viovl_fb_get_fix(dev, &dev->viovl_fb_fix);
+
+	/* Generate valid fb_info */
+
+	dev->viovl_fb_info.node = -1;
+	dev->viovl_fb_info.flags = FBINFO_FLAG_DEFAULT;
+	dev->viovl_fb_info.fbops = &viovl_fb_ops;
+	dev->viovl_fb_info.par = dev;
+	dev->viovl_fb_info.var = dev->viovl_fb_defined;
+	dev->viovl_fb_info.fix = dev->viovl_fb_fix;
+	dev->viovl_fb_info.screen_base = (u8 __iomem *)dev->video_vbase;
+	dev->viovl_fb_info.fbops = &viovl_fb_ops;
+
+	/* Supply some monitor specs. Bogus values will do for now */
+	dev->viovl_fb_info.monspecs.hfmin = 8000;
+	dev->viovl_fb_info.monspecs.hfmax = 70000;
+	dev->viovl_fb_info.monspecs.vfmin = 10;
+	dev->viovl_fb_info.monspecs.vfmax = 100;
+
+	/* Allocate color map */
+	if (fb_alloc_cmap(&dev->viovl_fb_info.cmap, 256, 1)) {
+		pr_err("abort, unable to alloc cmap\n");
+		return -ENOMEM;
+	}
+
+	/* Allocate the pseudo palette */
+	dev->viovl_fb_info.pseudo_palette = kmalloc(sizeof(u32) * 16, GFP_KERNEL);
+
+	if (!dev->viovl_fb_info.pseudo_palette) {
+		pr_err("abort, unable to alloc pseudo palette\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/* Release any memory we've grabbed & remove mtrr entry */
+static void viovl_fb_release_buffers(struct viovl_dev *dev)
+{
+	/* Release cmap */
+	if (dev->viovl_fb_info.cmap.len)
+		fb_dealloc_cmap(&dev->viovl_fb_info.cmap);
+
+	/* Release pseudo palette */
+	kfree(dev->viovl_fb_info.pseudo_palette);
+	kfree((void *)dev->video_vbase);
+}
+
+/* Initialize the specified card */
+
+static int viovl_fb_init(struct viovl_dev *dev)
+{
+	int ret;
+
+	dev->video_buffer_size = MAX_HEIGHT * MAX_WIDTH * 2;
+	dev->video_vbase = kzalloc(dev->video_buffer_size, GFP_KERNEL | GFP_DMA32);
+	if (dev->video_vbase == NULL)
+		return -ENOMEM;
+	dev->video_pbase = virt_to_phys(dev->video_vbase);
+
+	pr_info("Framebuffer at 0x%lx, mapped to 0x%p, size %dk\n",
+			dev->video_pbase, dev->video_vbase,
+			dev->video_buffer_size / 1024);
+
+	/* Set the startup video mode information */
+	ret = viovl_fb_init_vidmode(dev);
+	if (ret) {
+		viovl_fb_release_buffers(dev);
+		return ret;
+	}
+
+	viovl_clear_fb(dev);
+
+	/* Register the framebuffer */
+	if (register_framebuffer(&dev->viovl_fb_info) < 0) {
+		viovl_fb_release_buffers(dev);
+		return -EINVAL;
+	}
+
+	/* Set the card to the requested mode */
+	viovl_fb_set_par(&dev->viovl_fb_info);
+	return 0;
+
+}
+
+/* -----------------------------------------------------------------
+	Initialization and module stuff
+   ------------------------------------------------------------------*/
+
+static int viovl_release(void)
+{
+	struct viovl_dev *dev;
+	struct list_head *list;
+
+	while (!list_empty(&viovl_devlist)) {
+		list = viovl_devlist.next;
+		list_del(list);
+		dev = list_entry(list, struct viovl_dev, viovl_devlist);
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
+		unregister_framebuffer(&dev->viovl_fb_info);
+		viovl_fb_release_buffers(dev);
+		v4l2_ctrl_handler_free(&dev->ctrl_handler);
+		v4l2_device_unregister(&dev->v4l2_dev);
+		kfree(dev);
+	}
+
+	return 0;
+}
+
+static int __init viovl_create_instance(int inst)
+{
+	struct viovl_dev *dev;
+	struct video_device *vfd;
+	struct v4l2_ctrl_handler *hdl;
+	struct vb2_queue *q;
+	int ret;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
+			"%s-%03d", VIOVL_MODULE_NAME, inst);
+	ret = v4l2_device_register(NULL, &dev->v4l2_dev);
+	if (ret)
+		goto free_dev;
+
+	dev->fmt = &formats[0];
+	dev->width = 640;
+	dev->height = 480;
+	dev->field = V4L2_FIELD_NONE;
+	dev->pixelsize = dev->fmt->depth / 8;
+	dev->colorspace = V4L2_COLORSPACE_SRGB;
+	dev->fps = 25;
+	dev->do_overlay = true;
+
+	/* initialize locks */
+	mutex_init(&dev->lock_out);
+	mutex_init(&dev->lock_cap);
+	mutex_init(&dev->lock);
+
+	INIT_LIST_HEAD(&dev->list_out);
+	INIT_LIST_HEAD(&dev->list_cap);
+
+	hdl = &dev->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 1);
+	v4l2_ctrl_new_custom(hdl, &viovl_ctrl_clear_fb, NULL);
+	if (hdl->error) {
+		ret = hdl->error;
+		goto unreg_dev;
+	}
+
+	ret = viovl_fb_init(dev);
+	if (ret)
+		goto unreg_dev;
+
+	init_waitqueue_head(&dev->wq);
+	dev->kthread = kthread_run(viovl_thread, dev, "%s",
+				     dev->v4l2_dev.name);
+	if (IS_ERR(dev->kthread)) {
+		v4l2_err(&dev->v4l2_dev, "kernel_thread() failed\n");
+		ret = PTR_ERR(dev->kthread);
+		goto cleanup_overlay;
+	}
+
+	/* initialize output queue */
+	q = &dev->vidq_out;
+	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct viovl_buffer);
+	q->ops = &viovl_video_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+	q->lock = &dev->lock;
+	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+
+	ret = vb2_queue_init(q);
+	if (ret)
+		goto stop_thread;
+
+	vfd = &dev->vdev_out;
+	strlcpy(vfd->name, "viovl output", sizeof(vfd->name));
+	vfd->fops = &viovl_fops_out;
+	vfd->ioctl_ops = &viovl_ioctl_ops;
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
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct viovl_buffer);
+	q->ops = &viovl_video_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+	q->lock = &dev->lock;
+	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+
+	ret = vb2_queue_init(q);
+	if (ret)
+		goto unreg_out;
+
+	vfd = &dev->vdev_cap;
+	strlcpy(vfd->name, "viovl capture", sizeof(vfd->name));
+	vfd->fops = &viovl_fops_cap;
+	vfd->ioctl_ops = &viovl_ioctl_ops;
+	vfd->release = video_device_release_empty;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->queue = &dev->vidq_cap;
+	vfd->ctrl_handler = hdl;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
+	vfd->lock = &dev->lock;
+	video_set_drvdata(vfd, dev);
+	v4l2_disable_ioctl(vfd, VIDIOC_OVERLAY);
+	v4l2_disable_ioctl(vfd, VIDIOC_G_FBUF);
+	v4l2_disable_ioctl(vfd, VIDIOC_S_FBUF);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, video_nr);
+	if (ret < 0)
+		goto unreg_out;
+
+	/* Now that everything is fine, let's add it to device list */
+	list_add_tail(&dev->viovl_devlist, &viovl_devlist);
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
+cleanup_overlay:
+	viovl_fb_release_buffers(dev);
+unreg_dev:
+	v4l2_ctrl_handler_free(hdl);
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
+static int __init viovl_init(void)
+{
+	int ret = 0, i;
+
+	if (n_devs <= 0)
+		n_devs = 1;
+
+	for (i = 0; i < n_devs; i++) {
+		ret = viovl_create_instance(i);
+		if (ret) {
+			/* If some instantiations succeeded, keep driver */
+			if (i)
+				ret = 0;
+			break;
+		}
+	}
+
+	if (ret < 0) {
+		pr_err("viovl: error %d while loading driver\n", ret);
+		return ret;
+	}
+
+	pr_info("Video Overlay Driver successfully loaded\n");
+
+	/* n_devs will reflect the actual number of allocated devices */
+	n_devs = i;
+
+	return ret;
+}
+
+static void __exit viovl_exit(void)
+{
+	viovl_release();
+}
+
+module_init(viovl_init);
+module_exit(viovl_exit);
-- 
1.9.0

