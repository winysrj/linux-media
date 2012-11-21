Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58939 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465Ab2KVTKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 14:10:07 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3050567eek.19
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 11:10:05 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	Andrey Gusakov <dron0gus@gmail.com>
Subject: [PATCH RFC v4] V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface
Date: Wed, 21 Nov 2012 22:28:48 +0100
Message-Id: <1353533329-9909-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds V4L2 driver for Samsung S3C24XX/S3C64XX SoC series
camera interface. The driver exposes a subdev device node for CAMIF
pixel resolution and crop control and two video capture nodes - for
the "codec" and "preview" data paths. It has been tested on Mini2440
(s3c2440) and Mini6410 (s3c6410) board with gstreamer and mplayer.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Andrey Gusakov <dron0gus@gmail.com>
---

Changes since v3:
 - fixed the image effects controls issues and squashed
   the patch adding effects controls into this one.

 drivers/media/platform/Kconfig                   |   12 +
 drivers/media/platform/Makefile                  |    1 +
 drivers/media/platform/s3c-camif/Makefile        |    5 +
 drivers/media/platform/s3c-camif/camif-capture.c | 1675 ++++++++++++++++++++++
 drivers/media/platform/s3c-camif/camif-core.c    |  662 +++++++++
 drivers/media/platform/s3c-camif/camif-core.h    |  393 +++++
 drivers/media/platform/s3c-camif/camif-regs.c    |  606 ++++++++
 drivers/media/platform/s3c-camif/camif-regs.h    |  269 ++++
 include/media/s3c_camif.h                        |   45 +
 9 files changed, 3668 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/platform/s3c-camif/Makefile
 create mode 100644 drivers/media/platform/s3c-camif/camif-capture.c
 create mode 100644 drivers/media/platform/s3c-camif/camif-core.c
 create mode 100644 drivers/media/platform/s3c-camif/camif-core.h
 create mode 100644 drivers/media/platform/s3c-camif/camif-regs.c
 create mode 100644 drivers/media/platform/s3c-camif/camif-regs.h
 create mode 100644 include/media/s3c_camif.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 181c768..3dcfea6 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -109,6 +109,18 @@ config VIDEO_OMAP3_DEBUG
 	---help---
 	  Enable debug messages on OMAP 3 camera controller driver.

+config VIDEO_S3C_CAMIF
+	tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on (PLAT_S3C64XX || PLAT_S3C24XX) && PM_RUNTIME
+	select VIDEOBUF2_DMA_CONTIG
+	---help---
+	  This is a v4l2 driver for s3c24xx and s3c64xx SoC series camera
+	  host interface (CAMIF).
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called s3c-camif.
+
 source "drivers/media/platform/soc_camera/Kconfig"
 source "drivers/media/platform/s5p-fimc/Kconfig"
 source "drivers/media/platform/s5p-tv/Kconfig"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index baaa550..4817d28 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_VIDEO_CODA) 		+= coda.o

 obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o

+obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
diff --git a/drivers/media/platform/s3c-camif/Makefile b/drivers/media/platform/s3c-camif/Makefile
new file mode 100644
index 0000000..50bf8c5
--- /dev/null
+++ b/drivers/media/platform/s3c-camif/Makefile
@@ -0,0 +1,5 @@
+# Makefile for s3c244x/s3c64xx CAMIF driver
+
+s3c-camif-objs := camif-core.o camif-capture.o camif-regs.o
+
+obj-$(CONFIG_VIDEO_S3C_CAMIF) += s3c-camif.o
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
new file mode 100644
index 0000000..b52cc59
--- /dev/null
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -0,0 +1,1675 @@
+/*
+ * s3c24xx/s3c64xx SoC series Camera Interface (CAMIF) driver
+ *
+ * Copyright (C) 2012 Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
+ * Copyright (C) 2012 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * Based on drivers/media/platform/s5p-fimc,
+ * Copyright (C) 2010 - 2012 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
+#include <linux/bug.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/ratelimit.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+#include <media/media-device.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "camif-core.h"
+#include "camif-regs.h"
+
+static int debug;
+module_param(debug, int, 0644);
+
+/* Locking: called with vp->camif->slock spinlock held */
+static void camif_cfg_video_path(struct camif_vp *vp)
+{
+	WARN_ON(s3c_camif_get_scaler_config(vp, &vp->scaler));
+	camif_hw_set_scaler(vp);
+	camif_hw_set_flip(vp);
+	camif_hw_set_target_format(vp);
+	camif_hw_set_output_dma(vp);
+}
+
+static void camif_prepare_dma_offset(struct camif_vp *vp)
+{
+	struct camif_frame *f = &vp->out_frame;
+
+	f->dma_offset.initial = f->rect.top * f->f_width + f->rect.left;
+	f->dma_offset.line = f->f_width - (f->rect.left + f->rect.width);
+
+	pr_debug("dma_offset: initial: %d, line: %d\n",
+		 f->dma_offset.initial, f->dma_offset.line);
+}
+
+/* Locking: called with camif->slock spinlock held */
+static int s3c_camif_hw_init(struct camif_dev *camif, struct camif_vp *vp)
+{
+	const struct s3c_camif_variant *variant = camif->variant;
+
+	if (camif->sensor.sd == NULL || vp->out_fmt == NULL)
+		return -EINVAL;
+
+	if (variant->ip_revision == S3C244X_CAMIF_IP_REV)
+		camif_hw_clear_fifo_overflow(vp);
+	camif_hw_set_camera_bus(camif);
+	camif_hw_set_source_format(camif);
+	camif_hw_set_camera_crop(camif);
+	camif_hw_set_test_pattern(camif, camif->test_pattern);
+	if (variant->has_img_effect)
+		camif_hw_set_effect(camif, camif->colorfx,
+				camif->colorfx_cb, camif->colorfx_cr);
+	if (variant->ip_revision == S3C6410_CAMIF_IP_REV)
+		camif_hw_set_input_path(vp);
+	camif_cfg_video_path(vp);
+	vp->state &= ~ST_VP_CONFIG;
+
+	return 0;
+}
+
+/*
+ * Initialize the video path, only up from the scaler stage. The camera
+ * input interface set up is skipped. This is useful to enable one of the
+ * video paths when the other is already running.
+ * Locking: called with camif->slock spinlock held.
+ */
+static int s3c_camif_hw_vp_init(struct camif_dev *camif, struct camif_vp *vp)
+{
+	unsigned int ip_rev = camif->variant->ip_revision;
+
+	if (vp->out_fmt == NULL)
+		return -EINVAL;
+
+	camif_prepare_dma_offset(vp);
+	if (ip_rev == S3C244X_CAMIF_IP_REV)
+		camif_hw_clear_fifo_overflow(vp);
+	camif_cfg_video_path(vp);
+	vp->state &= ~ST_VP_CONFIG;
+	return 0;
+}
+
+static int sensor_set_power(struct camif_dev *camif, int on)
+{
+	struct cam_sensor *sensor = &camif->sensor;
+	int err = 0;
+
+	if (!on == camif->sensor.power_count)
+		err = v4l2_subdev_call(sensor->sd, core, s_power, on);
+	if (!err)
+		sensor->power_count += on ? 1 : -1;
+
+	pr_debug("on: %d, power_count: %d, err: %d\n",
+		 on, sensor->power_count, err);
+
+	return err;
+}
+
+static int sensor_set_streaming(struct camif_dev *camif, int on)
+{
+	struct cam_sensor *sensor = &camif->sensor;
+	int err = 0;
+
+	if (!on == camif->sensor.stream_count)
+		err = v4l2_subdev_call(sensor->sd, video, s_stream, on);
+	if (!err)
+		sensor->stream_count += on ? 1 : -1;
+
+	pr_debug("on: %d, stream_count: %d, err: %d\n",
+		 on, sensor->stream_count, err);
+
+	return err;
+}
+
+/*
+ * Reinitialize the driver so it is ready to start streaming again.
+ * Return any buffers to vb2, perform CAMIF software reset and
+ * turn off streaming at the data pipeline (sensor) if required.
+ */
+static int camif_reinitialize(struct camif_vp *vp)
+{
+	struct camif_dev *camif = vp->camif;
+	struct camif_buffer *buf;
+	unsigned long flags;
+	bool streaming;
+
+	spin_lock_irqsave(&camif->slock, flags);
+	streaming = vp->state & ST_VP_SENSOR_STREAMING;
+
+	vp->state &= ~(ST_VP_PENDING | ST_VP_RUNNING | ST_VP_OFF |
+		       ST_VP_ABORTING | ST_VP_STREAMING |
+		       ST_VP_SENSOR_STREAMING | ST_VP_LASTIRQ);
+
+	/* Release unused buffers */
+	while (!list_empty(&vp->pending_buf_q)) {
+		buf = camif_pending_queue_pop(vp);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+
+	while (!list_empty(&vp->active_buf_q)) {
+		buf = camif_active_queue_pop(vp);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+
+	spin_unlock_irqrestore(&camif->slock, flags);
+
+	if (!streaming)
+		return 0;
+
+	return sensor_set_streaming(camif, 0);
+}
+
+static bool s3c_vp_active(struct camif_vp *vp)
+{
+	struct camif_dev *camif = vp->camif;
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&camif->slock, flags);
+	ret = (vp->state & ST_VP_RUNNING) || (vp->state & ST_VP_PENDING);
+	spin_unlock_irqrestore(&camif->slock, flags);
+
+	return ret;
+}
+
+static bool camif_is_streaming(struct camif_dev *camif)
+{
+	unsigned long flags;
+	bool status;
+
+	spin_lock_irqsave(&camif->slock, flags);
+	status = camif->stream_count > 0;
+	spin_unlock_irqrestore(&camif->slock, flags);
+
+	return status;
+}
+
+static int camif_stop_capture(struct camif_vp *vp)
+{
+	struct camif_dev *camif = vp->camif;
+	unsigned long flags;
+	int ret;
+
+	if (!s3c_vp_active(vp))
+		return 0;
+
+	spin_lock_irqsave(&camif->slock, flags);
+	vp->state &= ~(ST_VP_OFF | ST_VP_LASTIRQ);
+	vp->state |= ST_VP_ABORTING;
+	spin_unlock_irqrestore(&camif->slock, flags);
+
+	ret = wait_event_timeout(vp->irq_queue,
+			   !(vp->state & ST_VP_ABORTING),
+			   msecs_to_jiffies(CAMIF_STOP_TIMEOUT));
+
+	spin_lock_irqsave(&camif->slock, flags);
+
+	if (ret == 0 && !(vp->state & ST_VP_OFF)) {
+		/* Timed out, forcibly stop capture */
+		vp->state &= ~(ST_VP_OFF | ST_VP_ABORTING |
+			       ST_VP_LASTIRQ);
+
+		camif_hw_disable_capture(vp);
+		camif_hw_enable_scaler(vp, false);
+	}
+
+	spin_unlock_irqrestore(&camif->slock, flags);
+
+	return camif_reinitialize(vp);
+}
+
+static int camif_prepare_addr(struct camif_vp *vp, struct vb2_buffer *vb,
+			      struct camif_addr *paddr)
+{
+	struct camif_frame *frame = &vp->out_frame;
+	u32 pix_size;
+
+	if (vb == NULL || frame == NULL)
+		return -EINVAL;
+
+	pix_size = frame->rect.width * frame->rect.height;
+
+	pr_debug("colplanes: %d, pix_size: %u\n",
+		 vp->out_fmt->colplanes, pix_size);
+
+	paddr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	switch (vp->out_fmt->colplanes) {
+	case 1:
+		paddr->cb = 0;
+		paddr->cr = 0;
+		break;
+	case 2:
+		/* decompose Y into Y/Cb */
+		paddr->cb = (u32)(paddr->y + pix_size);
+		paddr->cr = 0;
+		break;
+	case 3:
+		paddr->cb = (u32)(paddr->y + pix_size);
+		/* decompose Y into Y/Cb/Cr */
+		if (vp->out_fmt->color == IMG_FMT_YCBCR422P)
+			paddr->cr = (u32)(paddr->cb + (pix_size >> 1));
+		else /* 420 */
+			paddr->cr = (u32)(paddr->cb + (pix_size >> 2));
+
+		if (vp->out_fmt->color == IMG_FMT_YCRCB420)
+			swap(paddr->cb, paddr->cr);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	pr_debug("DMA address: y: %#x  cb: %#x cr: %#x\n",
+		 paddr->y, paddr->cb, paddr->cr);
+
+	return 0;
+}
+
+irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
+{
+	struct camif_vp *vp = priv;
+	struct camif_dev *camif = vp->camif;
+	unsigned int ip_rev = camif->variant->ip_revision;
+	unsigned int status;
+
+	spin_lock(&camif->slock);
+
+	if (ip_rev == S3C6410_CAMIF_IP_REV)
+		camif_hw_clear_pending_irq(vp);
+
+	status = camif_hw_get_status(vp);
+
+	if (ip_rev == S3C244X_CAMIF_IP_REV && (status & CISTATUS_OVF_MASK)) {
+		camif_hw_clear_fifo_overflow(vp);
+		goto unlock;
+	}
+
+	if (vp->state & ST_VP_ABORTING) {
+		if (vp->state & ST_VP_OFF) {
+			/* Last IRQ */
+			vp->state &= ~(ST_VP_OFF | ST_VP_ABORTING |
+				       ST_VP_LASTIRQ);
+			wake_up(&vp->irq_queue);
+			goto unlock;
+		} else if (vp->state & ST_VP_LASTIRQ) {
+			camif_hw_disable_capture(vp);
+			camif_hw_enable_scaler(vp, false);
+			camif_hw_set_lastirq(vp, false);
+			vp->state |= ST_VP_OFF;
+		} else {
+			/* Disable capture, enable last IRQ */
+			camif_hw_set_lastirq(vp, true);
+			vp->state |= ST_VP_LASTIRQ;
+		}
+	}
+
+	if (!list_empty(&vp->pending_buf_q) && (vp->state & ST_VP_RUNNING) &&
+	    !list_empty(&vp->active_buf_q)) {
+		unsigned int index;
+		struct camif_buffer *vbuf;
+		struct timeval *tv;
+		struct timespec ts;
+		/*
+		 * Get previous DMA write buffer index:
+		 * 0 => DMA buffer 0, 2;
+		 * 1 => DMA buffer 1, 3.
+		 */
+		index = (CISTATUS_FRAMECNT(status) + 2) & 1;
+
+		ktime_get_ts(&ts);
+		vbuf = camif_active_queue_peek(vp, index);
+
+		if (!WARN_ON(vbuf == NULL)) {
+			/* Dequeue a filled buffer */
+			tv = &vbuf->vb.v4l2_buf.timestamp;
+			tv->tv_sec = ts.tv_sec;
+			tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+			vbuf->vb.v4l2_buf.sequence = vp->frame_sequence++;
+			vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
+
+			/* Set up an empty buffer at the DMA engine */
+			vbuf = camif_pending_queue_pop(vp);
+			vbuf->index = index;
+			camif_hw_set_output_addr(vp, &vbuf->paddr, index);
+			camif_hw_set_output_addr(vp, &vbuf->paddr, index + 2);
+
+			/* Scheduled in H/W, add to the queue */
+			camif_active_queue_add(vp, vbuf);
+		}
+	} else if (!(vp->state & ST_VP_ABORTING) &&
+		   (vp->state & ST_VP_PENDING))  {
+		vp->state |= ST_VP_RUNNING;
+	}
+
+	if (vp->state & ST_VP_CONFIG) {
+		camif_prepare_dma_offset(vp);
+		camif_hw_set_camera_crop(camif);
+		camif_hw_set_scaler(vp);
+		camif_hw_set_flip(vp);
+		camif_hw_set_test_pattern(camif, camif->test_pattern);
+		if (camif->variant->has_img_effect)
+			camif_hw_set_effect(camif, camif->colorfx,
+				    camif->colorfx_cb, camif->colorfx_cr);
+		vp->state &= ~ST_VP_CONFIG;
+	}
+unlock:
+	spin_unlock(&camif->slock);
+	return IRQ_HANDLED;
+}
+
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct camif_vp *vp = vb2_get_drv_priv(vq);
+	struct camif_dev *camif = vp->camif;
+	unsigned long flags;
+	int ret;
+
+	/*
+	 * We assume the codec capture path is always activated
+	 * first, before the preview path starts streaming.
+	 * This is required to avoid internal FIFO overflow and
+	 * a need for CAMIF software reset.
+	 */
+	spin_lock_irqsave(&camif->slock, flags);
+
+	if (camif->stream_count == 0) {
+		camif_hw_reset(camif);
+		ret = s3c_camif_hw_init(camif, vp);
+	} else {
+		ret = s3c_camif_hw_vp_init(camif, vp);
+	}
+	spin_unlock_irqrestore(&camif->slock, flags);
+
+	if (ret < 0) {
+		camif_reinitialize(vp);
+		return ret;
+	}
+
+	spin_lock_irqsave(&camif->slock, flags);
+	vp->frame_sequence = 0;
+	vp->state |= ST_VP_PENDING;
+
+	if (!list_empty(&vp->pending_buf_q) &&
+	    (!(vp->state & ST_VP_STREAMING) ||
+	     !(vp->state & ST_VP_SENSOR_STREAMING))) {
+
+		camif_hw_enable_scaler(vp, vp->scaler.enable);
+		camif_hw_enable_capture(vp);
+		vp->state |= ST_VP_STREAMING;
+
+		if (!(vp->state & ST_VP_SENSOR_STREAMING)) {
+			vp->state |= ST_VP_SENSOR_STREAMING;
+			spin_unlock_irqrestore(&camif->slock, flags);
+			ret = sensor_set_streaming(camif, 1);
+			if (ret)
+				v4l2_err(&vp->vdev, "Sensor s_stream failed\n");
+			if (debug)
+				camif_hw_dump_regs(camif, __func__);
+
+			return ret;
+		}
+	}
+
+	spin_unlock_irqrestore(&camif->slock, flags);
+	return 0;
+}
+
+static int stop_streaming(struct vb2_queue *vq)
+{
+	struct camif_vp *vp = vb2_get_drv_priv(vq);
+	return camif_stop_capture(vp);
+}
+
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
+		       unsigned int *num_buffers, unsigned int *num_planes,
+		       unsigned int sizes[], void *allocators[])
+{
+	const struct v4l2_pix_format *pix = NULL;
+	struct camif_vp *vp = vb2_get_drv_priv(vq);
+	struct camif_dev *camif = vp->camif;
+	struct camif_frame *frame = &vp->out_frame;
+	const struct camif_fmt *fmt = vp->out_fmt;
+	unsigned int size;
+
+	if (pfmt) {
+		pix = &pfmt->fmt.pix;
+		fmt = s3c_camif_find_format(vp, &pix->pixelformat, -1);
+		size = (pix->width * pix->height * fmt->depth) / 8;
+	} else {
+		size = (frame->f_width * frame->f_height * fmt->depth) / 8;
+	}
+
+	if (fmt == NULL)
+		return -EINVAL;
+	*num_planes = 1;
+
+	if (pix)
+		sizes[0] = max(size, pix->sizeimage);
+	else
+		sizes[0] = size;
+	allocators[0] = camif->alloc_ctx;
+
+	pr_debug("size: %u\n", sizes[0]);
+	return 0;
+}
+
+static int buffer_prepare(struct vb2_buffer *vb)
+{
+	struct camif_vp *vp = vb2_get_drv_priv(vb->vb2_queue);
+
+	if (vp->out_fmt == NULL)
+		return -EINVAL;
+
+	if (vb2_plane_size(vb, 0) < vp->payload) {
+		v4l2_err(&vp->vdev, "buffer too small: %lu, required: %u\n",
+			 vb2_plane_size(vb, 0), vp->payload);
+		return -EINVAL;
+	}
+	vb2_set_plane_payload(vb, 0, vp->payload);
+
+	return 0;
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	struct camif_buffer *buf = container_of(vb, struct camif_buffer, vb);
+	struct camif_vp *vp = vb2_get_drv_priv(vb->vb2_queue);
+	struct camif_dev *camif = vp->camif;
+	unsigned long flags;
+
+	spin_lock_irqsave(&camif->slock, flags);
+	WARN_ON(camif_prepare_addr(vp, &buf->vb, &buf->paddr));
+
+	if (!(vp->state & ST_VP_STREAMING) && vp->active_buffers < 2) {
+		/* Schedule an empty buffer in H/W */
+		buf->index = vp->buf_index;
+
+		camif_hw_set_output_addr(vp, &buf->paddr, buf->index);
+		camif_hw_set_output_addr(vp, &buf->paddr, buf->index + 2);
+
+		camif_active_queue_add(vp, buf);
+		vp->buf_index = !vp->buf_index;
+	} else {
+		camif_pending_queue_add(vp, buf);
+	}
+
+	if (vb2_is_streaming(&vp->vb_queue) && !list_empty(&vp->pending_buf_q)
+		&& !(vp->state & ST_VP_STREAMING)) {
+
+		vp->state |= ST_VP_STREAMING;
+		camif_hw_enable_scaler(vp, vp->scaler.enable);
+		camif_hw_enable_capture(vp);
+		spin_unlock_irqrestore(&camif->slock, flags);
+
+		if (!(vp->state & ST_VP_SENSOR_STREAMING)) {
+			if (sensor_set_streaming(camif, 1) == 0)
+				vp->state |= ST_VP_SENSOR_STREAMING;
+			else
+				v4l2_err(&vp->vdev, "Sensor s_stream failed\n");
+
+			if (debug)
+				camif_hw_dump_regs(camif, __func__);
+		}
+		return;
+	}
+	spin_unlock_irqrestore(&camif->slock, flags);
+}
+
+static void camif_lock(struct vb2_queue *vq)
+{
+	struct camif_vp *vp = vb2_get_drv_priv(vq);
+	mutex_lock(&vp->camif->lock);
+}
+
+static void camif_unlock(struct vb2_queue *vq)
+{
+	struct camif_vp *vp = vb2_get_drv_priv(vq);
+	mutex_unlock(&vp->camif->lock);
+}
+
+static const struct vb2_ops s3c_camif_qops = {
+	.queue_setup	 = queue_setup,
+	.buf_prepare	 = buffer_prepare,
+	.buf_queue	 = buffer_queue,
+	.wait_prepare	 = camif_unlock,
+	.wait_finish	 = camif_lock,
+	.start_streaming = start_streaming,
+	.stop_streaming	 = stop_streaming,
+};
+
+static int s3c_camif_open(struct file *file)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	struct camif_dev *camif = vp->camif;
+	int ret;
+
+	pr_debug("[vp%d] state: %#x,  owner: %p, pid: %d\n", vp->id,
+		 vp->state, vp->owner, task_pid_nr(current));
+
+	if (mutex_lock_interruptible(&camif->lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_fh_open(file);
+	if (ret < 0)
+		goto unlock;
+
+	ret = pm_runtime_get_sync(camif->dev);
+	if (ret < 0)
+		goto err_pm;
+
+	ret = sensor_set_power(camif, 1);
+	if (!ret)
+		goto unlock;
+
+	pm_runtime_put(camif->dev);
+err_pm:
+	v4l2_fh_release(file);
+unlock:
+	mutex_unlock(&camif->lock);
+	return ret;
+}
+
+static int s3c_camif_close(struct file *file)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	struct camif_dev *camif = vp->camif;
+	int ret;
+
+	pr_debug("[vp%d] state: %#x, owner: %p, pid: %d\n", vp->id,
+		 vp->state, vp->owner, task_pid_nr(current));
+
+	if (mutex_lock_interruptible(&camif->lock))
+		return -ERESTARTSYS;
+
+	if (vp->owner == file->private_data) {
+		camif_stop_capture(vp);
+		vb2_queue_release(&vp->vb_queue);
+		vp->owner = NULL;
+	}
+
+	sensor_set_power(camif, 0);
+
+	pm_runtime_put(camif->dev);
+	ret = v4l2_fh_release(file);
+
+	mutex_unlock(&camif->lock);
+	return ret;
+}
+
+static unsigned int s3c_camif_poll(struct file *file,
+				   struct poll_table_struct *wait)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	struct camif_dev *camif = vp->camif;
+	int ret;
+
+	if (mutex_lock_interruptible(&camif->lock))
+		return -ERESTARTSYS;
+
+	if (vp->owner && vp->owner != file->private_data)
+		ret = -EBUSY;
+	else
+		ret = vb2_poll(&vp->vb_queue, file, wait);
+
+	mutex_unlock(&camif->lock);
+	return ret;
+}
+
+static int s3c_camif_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	int ret;
+
+	if (vp->owner && vp->owner != file->private_data)
+		ret = -EBUSY;
+	else
+		ret = vb2_mmap(&vp->vb_queue, vma);
+
+	return ret;
+}
+
+static const struct v4l2_file_operations s3c_camif_fops = {
+	.owner		= THIS_MODULE,
+	.open		= s3c_camif_open,
+	.release	= s3c_camif_close,
+	.poll		= s3c_camif_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= s3c_camif_mmap,
+};
+
+/*
+ * Video node IOCTLs
+ */
+
+static int s3c_camif_vidioc_querycap(struct file *file, void *priv,
+				     struct v4l2_capability *cap)
+{
+	struct camif_vp *vp = video_drvdata(file);
+
+	strlcpy(cap->driver, S3C_CAMIF_DRIVER_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, S3C_CAMIF_DRIVER_NAME, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s.%d",
+		 dev_name(vp->camif->dev), vp->id);
+
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int s3c_camif_vidioc_enum_input(struct file *file, void *priv,
+				       struct v4l2_input *input)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	struct v4l2_subdev *sensor = vp->camif->sensor.sd;
+
+	if (input->index || sensor == NULL)
+		return -EINVAL;
+
+	input->type = V4L2_INPUT_TYPE_CAMERA;
+	strlcpy(input->name, sensor->name, sizeof(input->name));
+	return 0;
+}
+
+static int s3c_camif_vidioc_s_input(struct file *file, void *priv,
+				    unsigned int i)
+{
+	return i == 0 ? 0 : -EINVAL;
+}
+
+static int s3c_camif_vidioc_g_input(struct file *file, void *priv,
+				    unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int s3c_camif_vidioc_enum_fmt(struct file *file, void *priv,
+				     struct v4l2_fmtdesc *f)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	const struct camif_fmt *fmt;
+
+	fmt = s3c_camif_find_format(vp, NULL, f->index);
+	if (!fmt)
+		return -EINVAL;
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+
+	pr_debug("fmt(%d): %s\n", f->index, f->description);
+	return 0;
+}
+
+static int s3c_camif_vidioc_g_fmt(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct camif_frame *frame = &vp->out_frame;
+	const struct camif_fmt *fmt = vp->out_fmt;
+
+	pix->bytesperline = frame->f_width * fmt->ybpp;
+	pix->sizeimage = vp->payload;
+
+	pix->pixelformat = fmt->fourcc;
+	pix->width = frame->f_width;
+	pix->height = frame->f_height;
+	pix->field = V4L2_FIELD_NONE;
+	pix->colorspace = V4L2_COLORSPACE_JPEG;
+
+	return 0;
+}
+
+static int __camif_video_try_format(struct camif_vp *vp,
+				    struct v4l2_pix_format *pix,
+				    const struct camif_fmt **ffmt)
+{
+	struct camif_dev *camif = vp->camif;
+	struct v4l2_rect *crop = &camif->camif_crop;
+	unsigned int wmin, hmin, sc_hrmax, sc_vrmax;
+	const struct vp_pix_limits *pix_lim;
+	const struct camif_fmt *fmt;
+
+	fmt = s3c_camif_find_format(vp, &pix->pixelformat, 0);
+
+	if (WARN_ON(fmt == NULL))
+		return -EINVAL;
+
+	if (ffmt)
+		*ffmt = fmt;
+
+	pix_lim = &camif->variant->vp_pix_limits[vp->id];
+
+	pr_debug("fmt: %ux%u, crop: %ux%u, bytesperline: %u\n",
+		 pix->width, pix->height, crop->width, crop->height,
+		 pix->bytesperline);
+	/*
+	 * Calculate minimum width and height according to the configured
+	 * camera input interface crop rectangle and the resizer's capabilities.
+	 */
+	sc_hrmax = min(SCALER_MAX_RATIO, 1 << (ffs(crop->width) - 3));
+	sc_vrmax = min(SCALER_MAX_RATIO, 1 << (ffs(crop->height) - 1));
+
+	wmin = max_t(u32, pix_lim->min_out_width, crop->width / sc_hrmax);
+	wmin = round_up(wmin, pix_lim->out_width_align);
+	hmin = max_t(u32, 8, crop->height / sc_vrmax);
+	hmin = round_up(hmin, 8);
+
+	v4l_bound_align_image(&pix->width, wmin, pix_lim->max_sc_out_width,
+			      ffs(pix_lim->out_width_align) - 1,
+			      &pix->height, hmin, pix_lim->max_height, 0, 0);
+
+	pix->bytesperline = pix->width * fmt->ybpp;
+	pix->sizeimage = (pix->width * pix->height * fmt->depth) / 8;
+	pix->pixelformat = fmt->fourcc;
+	pix->colorspace = V4L2_COLORSPACE_JPEG;
+	pix->field = V4L2_FIELD_NONE;
+
+	pr_debug("%ux%u, wmin: %d, hmin: %d, sc_hrmax: %d, sc_vrmax: %d\n",
+		 pix->width, pix->height, wmin, hmin, sc_hrmax, sc_vrmax);
+
+	return 0;
+}
+
+static int s3c_camif_vidioc_try_fmt(struct file *file, void *priv,
+				    struct v4l2_format *f)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	return __camif_video_try_format(vp, &f->fmt.pix, NULL);
+}
+
+static int s3c_camif_vidioc_s_fmt(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct camif_vp *vp = video_drvdata(file);
+	struct camif_frame *out_frame = &vp->out_frame;
+	const struct camif_fmt *fmt = NULL;
+	int ret;
+
+	pr_debug("[vp%d]\n", vp->id);
+
+	if (vb2_is_busy(&vp->vb_queue))
+		return -EBUSY;
+
+	ret = __camif_video_try_format(vp, &f->fmt.pix, &fmt);
+	if (ret < 0)
+		return ret;
+
+	vp->out_fmt = fmt;
+	vp->payload = pix->sizeimage;
+	out_frame->f_width = pix->width;
+	out_frame->f_height = pix->height;
+
+	/* Reset composition rectangle */
+	out_frame->rect.width = pix->width;
+	out_frame->rect.height = pix->height;
+	out_frame->rect.left = 0;
+	out_frame->rect.top = 0;
+
+	if (vp->owner == NULL)
+		vp->owner = priv;
+
+	pr_debug("%ux%u. payload: %u. fmt: %s. %d %d. sizeimage: %d. bpl: %d\n",
+		out_frame->f_width, out_frame->f_height, vp->payload, fmt->name,
+		pix->width * pix->height * fmt->depth, fmt->depth,
+		pix->sizeimage, pix->bytesperline);
+
+	return 0;
+}
+
+/* Only check pixel formats at the sensor and the camif subdev pads */
+static int camif_pipeline_validate(struct camif_dev *camif)
+{
+	struct v4l2_subdev_format src_fmt;
+	struct media_pad *pad;
+	int ret;
+
+	/* Retrieve format at the sensor subdev source pad */
+	pad = media_entity_remote_source(&camif->pads[0]);
+	if (!pad || media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+		return -EPIPE;
+
+	src_fmt.pad = pad->index;
+	src_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(camif->sensor.sd, pad, get_fmt, NULL, &src_fmt);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		return -EPIPE;
+
+	if (src_fmt.format.width != camif->mbus_fmt.width ||
+	    src_fmt.format.height != camif->mbus_fmt.height ||
+	    src_fmt.format.code != camif->mbus_fmt.code)
+		return -EPIPE;
+
+	return 0;
+}
+
+static int s3c_camif_streamon(struct file *file, void *priv,
+			      enum v4l2_buf_type type)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	struct camif_dev *camif = vp->camif;
+	struct media_entity *sensor = &camif->sensor.sd->entity;
+	int ret;
+
+	pr_debug("[vp%d]\n", vp->id);
+
+	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (vp->owner && vp->owner != priv)
+		return -EBUSY;
+
+	if (s3c_vp_active(vp))
+		return 0;
+
+	ret = media_entity_pipeline_start(sensor, camif->m_pipeline);
+	if (ret < 0)
+		return ret;
+
+	ret = camif_pipeline_validate(camif);
+	if (ret < 0) {
+		media_entity_pipeline_stop(sensor);
+		return ret;
+	}
+
+	return vb2_streamon(&vp->vb_queue, type);
+}
+
+static int s3c_camif_streamoff(struct file *file, void *priv,
+			       enum v4l2_buf_type type)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	struct camif_dev *camif = vp->camif;
+	int ret;
+
+	pr_debug("[vp%d]\n", vp->id);
+
+	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (vp->owner && vp->owner != priv)
+		return -EBUSY;
+
+	ret = vb2_streamoff(&vp->vb_queue, type);
+	if (ret == 0)
+		media_entity_pipeline_stop(&camif->sensor.sd->entity);
+	return ret;
+}
+
+static int s3c_camif_reqbufs(struct file *file, void *priv,
+			     struct v4l2_requestbuffers *rb)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	int ret;
+
+	pr_debug("[vp%d] rb count: %d, owner: %p, priv: %p\n",
+		 vp->id, rb->count, vp->owner, priv);
+
+	if (vp->owner && vp->owner != priv)
+		return -EBUSY;
+
+	if (rb->count)
+		rb->count = max_t(u32, CAMIF_REQ_BUFS_MIN, rb->count);
+	else
+		vp->owner = NULL;
+
+	ret = vb2_reqbufs(&vp->vb_queue, rb);
+	if (!ret) {
+		vp->reqbufs_count = rb->count;
+		if (vp->owner == NULL && rb->count > 0)
+			vp->owner = priv;
+	}
+
+	return ret;
+}
+
+static int s3c_camif_querybuf(struct file *file, void *priv,
+			      struct v4l2_buffer *buf)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	return vb2_querybuf(&vp->vb_queue, buf);
+}
+
+static int s3c_camif_qbuf(struct file *file, void *priv,
+			  struct v4l2_buffer *buf)
+{
+	struct camif_vp *vp = video_drvdata(file);
+
+	pr_debug("[vp%d]\n", vp->id);
+
+	if (vp->owner && vp->owner != priv)
+		return -EBUSY;
+
+	return vb2_qbuf(&vp->vb_queue, buf);
+}
+
+static int s3c_camif_dqbuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct camif_vp *vp = video_drvdata(file);
+
+	pr_debug("[vp%d] sequence: %d\n", vp->id, vp->frame_sequence);
+
+	if (vp->owner && vp->owner != priv)
+		return -EBUSY;
+
+	return vb2_dqbuf(&vp->vb_queue, buf, file->f_flags & O_NONBLOCK);
+}
+
+static int s3c_camif_create_bufs(struct file *file, void *priv,
+				 struct v4l2_create_buffers *create)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	int ret;
+
+	if (vp->owner && vp->owner != priv)
+		return -EBUSY;
+
+	create->count = max_t(u32, 1, create->count);
+	ret = vb2_create_bufs(&vp->vb_queue, create);
+
+	if (!ret && vp->owner == NULL)
+		vp->owner = priv;
+
+	return ret;
+}
+
+static int s3c_camif_prepare_buf(struct file *file, void *priv,
+				 struct v4l2_buffer *b)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	return vb2_prepare_buf(&vp->vb_queue, b);
+}
+
+static int s3c_camif_g_selection(struct file *file, void *priv,
+				 struct v4l2_selection *sel)
+{
+	struct camif_vp *vp = video_drvdata(file);
+
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = vp->out_frame.f_width;
+		sel->r.height = vp->out_frame.f_height;
+		return 0;
+
+	case V4L2_SEL_TGT_COMPOSE:
+		sel->r = vp->out_frame.rect;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static void __camif_try_compose(struct camif_dev *camif, struct camif_vp *vp,
+				struct v4l2_rect *r)
+{
+	/* s3c244x doesn't support composition */
+	if (camif->variant->ip_revision == S3C244X_CAMIF_IP_REV) {
+		*r = vp->out_frame.rect;
+		return;
+	}
+
+	/* TODO: s3c64xx */
+}
+
+static int s3c_camif_s_selection(struct file *file, void *priv,
+				 struct v4l2_selection *sel)
+{
+	struct camif_vp *vp = video_drvdata(file);
+	struct camif_dev *camif = vp->camif;
+	struct v4l2_rect rect = sel->r;
+	unsigned long flags;
+
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    sel->target != V4L2_SEL_TGT_COMPOSE)
+		return -EINVAL;
+
+	__camif_try_compose(camif, vp, &rect);
+
+	sel->r = rect;
+	spin_lock_irqsave(&camif->slock, flags);
+	vp->out_frame.rect = rect;
+	vp->state |= ST_VP_CONFIG;
+	spin_unlock_irqrestore(&camif->slock, flags);
+
+	pr_debug("type: %#x, target: %#x, flags: %#x, (%d,%d)/%dx%d\n",
+		sel->type, sel->target, sel->flags,
+		sel->r.left, sel->r.top, sel->r.width, sel->r.height);
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops s3c_camif_ioctl_ops = {
+	.vidioc_querycap	  = s3c_camif_vidioc_querycap,
+	.vidioc_enum_input	  = s3c_camif_vidioc_enum_input,
+	.vidioc_g_input		  = s3c_camif_vidioc_g_input,
+	.vidioc_s_input		  = s3c_camif_vidioc_s_input,
+	.vidioc_enum_fmt_vid_cap  = s3c_camif_vidioc_enum_fmt,
+	.vidioc_try_fmt_vid_cap	  = s3c_camif_vidioc_try_fmt,
+	.vidioc_s_fmt_vid_cap	  = s3c_camif_vidioc_s_fmt,
+	.vidioc_g_fmt_vid_cap	  = s3c_camif_vidioc_g_fmt,
+	.vidioc_g_selection	  = s3c_camif_g_selection,
+	.vidioc_s_selection	  = s3c_camif_s_selection,
+	.vidioc_reqbufs		  = s3c_camif_reqbufs,
+	.vidioc_querybuf	  = s3c_camif_querybuf,
+	.vidioc_prepare_buf	  = s3c_camif_prepare_buf,
+	.vidioc_create_bufs	  = s3c_camif_create_bufs,
+	.vidioc_qbuf		  = s3c_camif_qbuf,
+	.vidioc_dqbuf		  = s3c_camif_dqbuf,
+	.vidioc_streamon	  = s3c_camif_streamon,
+	.vidioc_streamoff	  = s3c_camif_streamoff,
+	.vidioc_subscribe_event	  = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+	.vidioc_log_status	  = v4l2_ctrl_log_status,
+};
+
+/*
+ * Video node controls
+ */
+static int s3c_camif_video_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct camif_vp *vp = ctrl->priv;
+	struct camif_dev *camif = vp->camif;
+	unsigned long flags;
+
+	pr_debug("[vp%d] ctrl: %s, value: %d\n", vp->id,
+		 ctrl->name, ctrl->val);
+
+	spin_lock_irqsave(&camif->slock, flags);
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		vp->hflip = ctrl->val;
+		break;
+
+	case V4L2_CID_VFLIP:
+		vp->vflip = ctrl->val;
+		break;
+	}
+
+	vp->state |= ST_VP_CONFIG;
+	spin_unlock_irqrestore(&camif->slock, flags);
+	return 0;
+}
+
+/* Codec and preview video node control ops */
+static const struct v4l2_ctrl_ops s3c_camif_video_ctrl_ops = {
+	.s_ctrl = s3c_camif_video_s_ctrl,
+};
+
+int s3c_camif_register_video_node(struct camif_dev *camif, int idx)
+{
+	struct camif_vp *vp = &camif->vp[idx];
+	struct vb2_queue *q = &vp->vb_queue;
+	struct video_device *vfd = &vp->vdev;
+	struct v4l2_ctrl *ctrl;
+	int ret;
+
+	memset(vfd, 0, sizeof(*vfd));
+	snprintf(vfd->name, sizeof(vfd->name), "camif-%s",
+		 vp->id == 0 ? "codec" : "preview");
+
+	vfd->fops = &s3c_camif_fops;
+	vfd->ioctl_ops = &s3c_camif_ioctl_ops;
+	vfd->v4l2_dev = &camif->v4l2_dev;
+	vfd->minor = -1;
+	vfd->release = video_device_release_empty;
+	vfd->lock = &camif->lock;
+	vp->reqbufs_count = 0;
+
+	INIT_LIST_HEAD(&vp->pending_buf_q);
+	INIT_LIST_HEAD(&vp->active_buf_q);
+
+	memset(q, 0, sizeof(*q));
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->ops = &s3c_camif_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct camif_buffer);
+	q->drv_priv = vp;
+
+	ret = vb2_queue_init(q);
+	if (ret)
+		goto err_vd_rel;
+
+	vp->pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&vfd->entity, 1, &vp->pad, 0);
+	if (ret)
+		goto err_vd_rel;
+
+	video_set_drvdata(vfd, vp);
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
+
+	v4l2_ctrl_handler_init(&vp->ctrl_handler, 1);
+	ctrl = v4l2_ctrl_new_std(&vp->ctrl_handler, &s3c_camif_video_ctrl_ops,
+				 V4L2_CID_HFLIP, 0, 1, 1, 0);
+	if (ctrl)
+		ctrl->priv = vp;
+	ctrl = v4l2_ctrl_new_std(&vp->ctrl_handler, &s3c_camif_video_ctrl_ops,
+				 V4L2_CID_VFLIP, 0, 1, 1, 0);
+	if (ctrl)
+		ctrl->priv = vp;
+
+	ret = vp->ctrl_handler.error;
+	if (ret < 0)
+		goto err_me_cleanup;
+
+	vfd->ctrl_handler = &vp->ctrl_handler;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		goto err_ctrlh_free;
+
+	v4l2_info(&camif->v4l2_dev, "registered %s as /dev/%s\n",
+		  vfd->name, video_device_node_name(vfd));
+	return 0;
+
+err_ctrlh_free:
+	v4l2_ctrl_handler_free(&vp->ctrl_handler);
+err_me_cleanup:
+	media_entity_cleanup(&vfd->entity);
+err_vd_rel:
+	video_device_release(vfd);
+	return ret;
+}
+
+void s3c_camif_unregister_video_node(struct camif_dev *camif, int idx)
+{
+	struct video_device *vfd = &camif->vp[idx].vdev;
+
+	if (video_is_registered(vfd)) {
+		video_unregister_device(vfd);
+		media_entity_cleanup(&vfd->entity);
+		v4l2_ctrl_handler_free(vfd->ctrl_handler);
+	}
+}
+
+/* Media bus pixel formats supported at the camif input */
+static const enum v4l2_mbus_pixelcode camif_mbus_formats[] = {
+	V4L2_MBUS_FMT_YUYV8_2X8,
+	V4L2_MBUS_FMT_YVYU8_2X8,
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_VYUY8_2X8,
+};
+
+/*
+ *  Camera input interface subdev operations
+ */
+
+static int s3c_camif_subdev_enum_mbus_code(struct v4l2_subdev *sd,
+					struct v4l2_subdev_fh *fh,
+					struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= ARRAY_SIZE(camif_mbus_formats))
+		return -EINVAL;
+
+	code->code = camif_mbus_formats[code->index];
+	return 0;
+}
+
+static int s3c_camif_subdev_get_fmt(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_format *fmt)
+{
+	struct camif_dev *camif = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		fmt->format = *mf;
+		return 0;
+	}
+
+	mutex_lock(&camif->lock);
+
+	switch (fmt->pad) {
+	case CAMIF_SD_PAD_SINK:
+		/* full camera input pixel size */
+		*mf = camif->mbus_fmt;
+		break;
+
+	case CAMIF_SD_PAD_SOURCE_C...CAMIF_SD_PAD_SOURCE_P:
+		/* crop rectangle at camera interface input */
+		mf->width = camif->camif_crop.width;
+		mf->height = camif->camif_crop.height;
+		mf->code = camif->mbus_fmt.code;
+		break;
+	}
+
+	mutex_unlock(&camif->lock);
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+	return 0;
+}
+
+static void __camif_subdev_try_format(struct camif_dev *camif,
+				struct v4l2_mbus_framefmt *mf, int pad)
+{
+	const struct s3c_camif_variant *variant = camif->variant;
+	const struct vp_pix_limits *pix_lim;
+	int i = ARRAY_SIZE(camif_mbus_formats);
+
+	/* FIXME: constraints against codec or preview path ? */
+	pix_lim = &variant->vp_pix_limits[VP_CODEC];
+
+	while (i-- >= 0)
+		if (camif_mbus_formats[i] == mf->code)
+			break;
+
+	mf->code = camif_mbus_formats[i];
+
+	if (pad == CAMIF_SD_PAD_SINK) {
+		v4l_bound_align_image(&mf->width, 8, CAMIF_MAX_PIX_WIDTH,
+				      ffs(pix_lim->out_width_align) - 1,
+				      &mf->height, 8, CAMIF_MAX_PIX_HEIGHT, 0,
+				      0);
+	} else {
+		struct v4l2_rect *crop = &camif->camif_crop;
+		v4l_bound_align_image(&mf->width, 8, crop->width,
+				      ffs(pix_lim->out_width_align) - 1,
+				      &mf->height, 8, crop->height,
+				      0, 0);
+	}
+
+	v4l2_dbg(1, debug, &camif->subdev, "%ux%u\n", mf->width, mf->height);
+}
+
+static int s3c_camif_subdev_set_fmt(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_format *fmt)
+{
+	struct camif_dev *camif = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
+	struct v4l2_rect *crop = &camif->camif_crop;
+	int i;
+
+	v4l2_dbg(1, debug, sd, "pad%d: code: 0x%x, %ux%u\n",
+		 fmt->pad, mf->code, mf->width, mf->height);
+
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+	mutex_lock(&camif->lock);
+
+	/*
+	 * No pixel format change at the camera input is allowed
+	 * while streaming.
+	 */
+	if (vb2_is_busy(&camif->vp[VP_CODEC].vb_queue) ||
+	    vb2_is_busy(&camif->vp[VP_PREVIEW].vb_queue)) {
+		mutex_unlock(&camif->lock);
+		return -EBUSY;
+	}
+
+	__camif_subdev_try_format(camif, mf, fmt->pad);
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		*mf = fmt->format;
+		mutex_unlock(&camif->lock);
+		return 0;
+	}
+
+	switch (fmt->pad) {
+	case CAMIF_SD_PAD_SINK:
+		camif->mbus_fmt = *mf;
+		/* Reset sink crop rectangle. */
+		crop->width = mf->width;
+		crop->height = mf->height;
+		crop->left = 0;
+		crop->top = 0;
+		/*
+		 * Reset source format (the camif's crop rectangle)
+		 * and the video output resolution.
+		 */
+		for (i = 0; i < CAMIF_VP_NUM; i++) {
+			struct camif_frame *frame = &camif->vp[i].out_frame;
+			frame->rect = *crop;
+			frame->f_width = mf->width;
+			frame->f_height = mf->height;
+		}
+		break;
+
+	case CAMIF_SD_PAD_SOURCE_C...CAMIF_SD_PAD_SOURCE_P:
+		/* Pixel format can be only changed on the sink pad. */
+		mf->code = camif->mbus_fmt.code;
+		mf->width = crop->width;
+		mf->height = crop->height;
+		break;
+	}
+
+	mutex_unlock(&camif->lock);
+	return 0;
+}
+
+static int s3c_camif_subdev_get_selection(struct v4l2_subdev *sd,
+					  struct v4l2_subdev_fh *fh,
+					  struct v4l2_subdev_selection *sel)
+{
+	struct camif_dev *camif = v4l2_get_subdevdata(sd);
+	struct v4l2_rect *crop = &camif->camif_crop;
+	struct v4l2_mbus_framefmt *mf = &camif->mbus_fmt;
+
+	if ((sel->target != V4L2_SEL_TGT_CROP &&
+	    sel->target != V4L2_SEL_TGT_CROP_BOUNDS) ||
+	    sel->pad != CAMIF_SD_PAD_SINK)
+		return -EINVAL;
+
+	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
+		sel->r = *v4l2_subdev_get_try_crop(fh, sel->pad);
+		return 0;
+	}
+
+	mutex_lock(&camif->lock);
+
+	if (sel->target == V4L2_SEL_TGT_CROP) {
+		sel->r = *crop;
+	} else { /* crop bounds */
+		sel->r.width = mf->width;
+		sel->r.height = mf->height;
+		sel->r.left = 0;
+		sel->r.top = 0;
+	}
+
+	mutex_unlock(&camif->lock);
+
+	v4l2_dbg(1, debug, sd, "%s: crop: (%d,%d) %dx%d, size: %ux%u\n",
+		 __func__, crop->left, crop->top, crop->width,
+		 crop->height, mf->width, mf->height);
+
+	return 0;
+}
+
+static void __camif_try_crop(struct camif_dev *camif, struct v4l2_rect *r)
+{
+	struct v4l2_mbus_framefmt *mf = &camif->mbus_fmt;
+	const struct camif_pix_limits *pix_lim = &camif->variant->pix_limits;
+	unsigned int left = 2 * r->left;
+	unsigned int top = 2 * r->top;
+
+	/*
+	 * Following constraints must be met:
+	 *  - r->width + 2 * r->left = mf->width;
+	 *  - r->height + 2 * r->top = mf->height;
+	 *  - crop rectangle size and position must be aligned
+	 *    to 8 or 2 pixels, depending on SoC version.
+	 */
+	v4l_bound_align_image(&r->width, 0, mf->width,
+			      ffs(pix_lim->win_hor_offset_align) - 1,
+			      &r->height, 0, mf->height, 1, 0);
+
+	v4l_bound_align_image(&left, 0, mf->width - r->width,
+			      ffs(pix_lim->win_hor_offset_align),
+			      &top, 0, mf->height - r->height, 2, 0);
+
+	r->left = left / 2;
+	r->top = top / 2;
+	r->width = mf->width - left;
+	r->height = mf->height - top;
+	/*
+	 * Make sure we either downscale or upscale both the pixel
+	 * width and height. Just return current crop rectangle if
+	 * this scaler constraint is not met.
+	 */
+	if (camif->variant->ip_revision == S3C244X_CAMIF_IP_REV &&
+	    camif_is_streaming(camif)) {
+		unsigned int i;
+
+		for (i = 0; i < CAMIF_VP_NUM; i++) {
+			struct v4l2_rect *or = &camif->vp[i].out_frame.rect;
+			if ((or->width > r->width) == (or->height > r->height))
+				continue;
+			*r = camif->camif_crop;
+			pr_debug("Width/height scaling direction limitation\n");
+			break;
+		}
+	}
+
+	v4l2_dbg(1, debug, &camif->v4l2_dev, "crop: (%d,%d)/%dx%d, fmt: %ux%u\n",
+		 r->left, r->top, r->width, r->height, mf->width, mf->height);
+}
+
+static int s3c_camif_subdev_set_selection(struct v4l2_subdev *sd,
+					  struct v4l2_subdev_fh *fh,
+					  struct v4l2_subdev_selection *sel)
+{
+	struct camif_dev *camif = v4l2_get_subdevdata(sd);
+	struct v4l2_rect *crop = &camif->camif_crop;
+	struct camif_scaler scaler;
+
+	if (sel->target != V4L2_SEL_TGT_CROP || sel->pad != CAMIF_SD_PAD_SINK)
+		return -EINVAL;
+
+	mutex_lock(&camif->lock);
+	__camif_try_crop(camif, &sel->r);
+
+	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
+		*v4l2_subdev_get_try_crop(fh, sel->pad) = sel->r;
+	} else {
+		unsigned long flags;
+		unsigned int i;
+
+		spin_lock_irqsave(&camif->slock, flags);
+		*crop = sel->r;
+
+		for (i = 0; i < CAMIF_VP_NUM; i++) {
+			struct camif_vp *vp = &camif->vp[i];
+			scaler = vp->scaler;
+			if (s3c_camif_get_scaler_config(vp, &scaler))
+				continue;
+			vp->scaler = scaler;
+			vp->state |= ST_VP_CONFIG;
+		}
+
+		spin_unlock_irqrestore(&camif->slock, flags);
+	}
+	mutex_unlock(&camif->lock);
+
+	v4l2_dbg(1, debug, sd, "%s: (%d,%d) %dx%d, f_w: %u, f_h: %u\n",
+		 __func__, crop->left, crop->top, crop->width, crop->height,
+		 camif->mbus_fmt.width, camif->mbus_fmt.height);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_pad_ops s3c_camif_subdev_pad_ops = {
+	.enum_mbus_code = s3c_camif_subdev_enum_mbus_code,
+	.get_selection = s3c_camif_subdev_get_selection,
+	.set_selection = s3c_camif_subdev_set_selection,
+	.get_fmt = s3c_camif_subdev_get_fmt,
+	.set_fmt = s3c_camif_subdev_set_fmt,
+};
+
+static struct v4l2_subdev_ops s3c_camif_subdev_ops = {
+	.pad = &s3c_camif_subdev_pad_ops,
+};
+
+static int s3c_camif_subdev_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct camif_dev *camif = container_of(ctrl->handler, struct camif_dev,
+					       ctrl_handler);
+	unsigned long flags;
+
+	spin_lock_irqsave(&camif->slock, flags);
+
+	switch (ctrl->id) {
+	case V4L2_CID_COLORFX:
+		camif->colorfx = camif->ctrl_colorfx->val;
+		/* Set Cb, Cr */
+		switch (ctrl->val) {
+		case V4L2_COLORFX_SEPIA:
+			camif->colorfx_cb = 115;
+			camif->colorfx_cr = 145;
+			break;
+		case V4L2_COLORFX_SET_CBCR:
+			camif->colorfx_cb = camif->ctrl_colorfx_cbcr->val >> 8;
+			camif->colorfx_cr = camif->ctrl_colorfx_cbcr->val & 0xff;
+			break;
+		default:
+			/* for V4L2_COLORFX_BW and others */
+			camif->colorfx_cb = 128;
+			camif->colorfx_cr = 128;
+		}
+		break;
+	case V4L2_CID_TEST_PATTERN:
+		camif->test_pattern = camif->ctrl_test_pattern->val;
+		break;
+	default:
+		WARN_ON(1);
+	}
+
+	camif->vp[VP_CODEC].state |= ST_VP_CONFIG;
+	camif->vp[VP_PREVIEW].state |= ST_VP_CONFIG;
+	spin_unlock_irqrestore(&camif->slock, flags);
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops s3c_camif_subdev_ctrl_ops = {
+	.s_ctrl	= s3c_camif_subdev_s_ctrl,
+};
+
+static const char * const s3c_camif_test_pattern_menu[] = {
+	"Disabled",
+	"Color bars",
+	"Horizontal increment",
+	"Vertical increment",
+};
+
+int s3c_camif_create_subdev(struct camif_dev *camif)
+{
+	struct v4l2_ctrl_handler *handler = &camif->ctrl_handler;
+	struct v4l2_subdev *sd = &camif->subdev;
+	int ret;
+
+	v4l2_subdev_init(sd, &s3c_camif_subdev_ops);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	strlcpy(sd->name, "S3C-CAMIF", sizeof(sd->name));
+
+	camif->pads[CAMIF_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	camif->pads[CAMIF_SD_PAD_SOURCE_C].flags = MEDIA_PAD_FL_SOURCE;
+	camif->pads[CAMIF_SD_PAD_SOURCE_P].flags = MEDIA_PAD_FL_SOURCE;
+
+	ret = media_entity_init(&sd->entity, CAMIF_SD_PADS_NUM,
+				camif->pads, 0);
+	if (ret)
+		return ret;
+
+	v4l2_ctrl_handler_init(handler, 3);
+	camif->ctrl_test_pattern = v4l2_ctrl_new_std_menu_items(handler,
+			&s3c_camif_subdev_ctrl_ops, V4L2_CID_TEST_PATTERN,
+			ARRAY_SIZE(s3c_camif_test_pattern_menu) - 1, 0, 0,
+			s3c_camif_test_pattern_menu);
+
+	camif->ctrl_colorfx = v4l2_ctrl_new_std_menu(handler,
+				&s3c_camif_subdev_ctrl_ops,
+				V4L2_CID_COLORFX, V4L2_COLORFX_SET_CBCR,
+				~0x981f, V4L2_COLORFX_NONE);
+
+	camif->ctrl_colorfx_cbcr = v4l2_ctrl_new_std(handler,
+				&s3c_camif_subdev_ctrl_ops,
+				V4L2_CID_COLORFX_CBCR, 0, 0xffff, 1, 0);
+	if (handler->error) {
+		v4l2_ctrl_handler_free(handler);
+		media_entity_cleanup(&sd->entity);
+		return handler->error;
+	}
+
+	v4l2_ctrl_auto_cluster(2, &camif->ctrl_colorfx,
+			       V4L2_COLORFX_SET_CBCR, false);
+	if (!camif->variant->has_img_effect) {
+		camif->ctrl_colorfx->flags |= V4L2_CTRL_FLAG_DISABLED;
+		camif->ctrl_colorfx_cbcr->flags |= V4L2_CTRL_FLAG_DISABLED;
+	}
+	sd->ctrl_handler = handler;
+	v4l2_set_subdevdata(sd, camif);
+
+	return 0;
+}
+
+void s3c_camif_unregister_subdev(struct camif_dev *camif)
+{
+	struct v4l2_subdev *sd = &camif->subdev;
+
+	/* Return if not registered */
+	if (v4l2_get_subdevdata(sd) == NULL)
+		return;
+
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_ctrl_handler_free(&camif->ctrl_handler);
+	v4l2_set_subdevdata(sd, NULL);
+}
+
+int s3c_camif_set_defaults(struct camif_dev *camif)
+{
+	unsigned int ip_rev = camif->variant->ip_revision;
+	int i;
+
+	for (i = 0; i < CAMIF_VP_NUM; i++) {
+		struct camif_vp *vp = &camif->vp[i];
+		struct camif_frame *f = &vp->out_frame;
+
+		vp->camif = camif;
+		vp->id = i;
+		vp->offset = camif->variant->vp_offset;
+
+		if (ip_rev == S3C244X_CAMIF_IP_REV)
+			vp->fmt_flags = i ? FMT_FL_S3C24XX_PREVIEW :
+					FMT_FL_S3C24XX_CODEC;
+		else
+			vp->fmt_flags = FMT_FL_S3C64XX;
+
+		vp->out_fmt = s3c_camif_find_format(vp, NULL, 0);
+		BUG_ON(vp->out_fmt == NULL);
+
+		memset(f, 0, sizeof(*f));
+		f->f_width = CAMIF_DEF_WIDTH;
+		f->f_height = CAMIF_DEF_HEIGHT;
+		f->rect.width = CAMIF_DEF_WIDTH;
+		f->rect.height = CAMIF_DEF_HEIGHT;
+
+		/* Scaler is always enabled */
+		vp->scaler.enable = 1;
+
+		vp->payload = (f->f_width * f->f_height *
+			       vp->out_fmt->depth) / 8;
+	}
+
+	memset(&camif->mbus_fmt, 0, sizeof(camif->mbus_fmt));
+	camif->mbus_fmt.width = CAMIF_DEF_WIDTH;
+	camif->mbus_fmt.height = CAMIF_DEF_HEIGHT;
+	camif->mbus_fmt.code  = camif_mbus_formats[0];
+
+	memset(&camif->camif_crop, 0, sizeof(camif->camif_crop));
+	camif->camif_crop.width = CAMIF_DEF_WIDTH;
+	camif->camif_crop.height = CAMIF_DEF_HEIGHT;
+
+	return 0;
+}
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
new file mode 100644
index 0000000..0dd6537
--- /dev/null
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -0,0 +1,662 @@
+/*
+ * s3c24xx/s3c64xx SoC series Camera Interface (CAMIF) driver
+ *
+ * Copyright (C) 2012 Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
+ * Copyright (C) 2012 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
+#include <linux/bug.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <media/media-device.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "camif-core.h"
+
+static char *camif_clocks[CLK_MAX_NUM] = {
+	/* HCLK CAMIF clock */
+	[CLK_GATE]	= "camif",
+	/* CAMIF / external camera sensor master clock */
+	[CLK_CAM]	= "camera",
+};
+
+static const struct camif_fmt camif_formats[] = {
+	{
+		.name		= "YUV 4:2:2 planar, Y/Cb/Cr",
+		.fourcc		= V4L2_PIX_FMT_YUV422P,
+		.depth		= 16,
+		.ybpp		= 1,
+		.color		= IMG_FMT_YCBCR422P,
+		.colplanes	= 3,
+		.flags		= FMT_FL_S3C24XX_CODEC |
+				  FMT_FL_S3C64XX,
+	}, {
+		.name		= "YUV 4:2:0 planar, Y/Cb/Cr",
+		.fourcc		= V4L2_PIX_FMT_YUV420,
+		.depth		= 12,
+		.ybpp		= 1,
+		.color		= IMG_FMT_YCBCR420,
+		.colplanes	= 3,
+		.flags		= FMT_FL_S3C24XX_CODEC |
+				  FMT_FL_S3C64XX,
+	}, {
+		.name		= "YVU 4:2:0 planar, Y/Cr/Cb",
+		.fourcc		= V4L2_PIX_FMT_YVU420,
+		.depth		= 12,
+		.ybpp		= 1,
+		.color		= IMG_FMT_YCRCB420,
+		.colplanes	= 3,
+		.flags		= FMT_FL_S3C24XX_CODEC |
+				  FMT_FL_S3C64XX,
+	}, {
+		.name		= "RGB565, 16 bpp",
+		.fourcc		= V4L2_PIX_FMT_RGB565X,
+		.depth		= 16,
+		.ybpp		= 2,
+		.color		= IMG_FMT_RGB565,
+		.colplanes	= 1,
+		.flags		= FMT_FL_S3C24XX_PREVIEW |
+				  FMT_FL_S3C64XX,
+	}, {
+		.name		= "XRGB8888, 32 bpp",
+		.fourcc		= V4L2_PIX_FMT_RGB32,
+		.depth		= 32,
+		.ybpp		= 4,
+		.color		= IMG_FMT_XRGB8888,
+		.colplanes	= 1,
+		.flags		= FMT_FL_S3C24XX_PREVIEW |
+				  FMT_FL_S3C64XX,
+	}, {
+		.name		= "BGR666",
+		.fourcc		= V4L2_PIX_FMT_BGR666,
+		.depth		= 32,
+		.ybpp		= 4,
+		.color		= IMG_FMT_RGB666,
+		.colplanes	= 1,
+		.flags		= FMT_FL_S3C64XX,
+	}
+};
+
+/**
+ * s3c_camif_find_format() - lookup camif color format by fourcc or an index
+ * @pixelformat: fourcc to match, ignored if null
+ * @index: index to the camif_formats array, ignored if negative
+ */
+const struct camif_fmt *s3c_camif_find_format(struct camif_vp *vp,
+					      const u32 *pixelformat,
+					      int index)
+{
+	const struct camif_fmt *fmt, *def_fmt = NULL;
+	unsigned int i;
+	int id = 0;
+
+	if (index >= (int)ARRAY_SIZE(camif_formats))
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(camif_formats); ++i) {
+		fmt = &camif_formats[i];
+		if (vp && !(vp->fmt_flags & fmt->flags))
+			continue;
+		if (pixelformat && fmt->fourcc == *pixelformat)
+			return fmt;
+		if (index == id)
+			def_fmt = fmt;
+		id++;
+	}
+	return def_fmt;
+}
+
+static int camif_get_scaler_factor(u32 src, u32 tar, u32 *ratio, u32 *shift)
+{
+	unsigned int sh = 6;
+
+	if (src >= 64 * tar)
+		return -EINVAL;
+
+	while (sh--) {
+		unsigned int tmp = 1 << sh;
+		if (src >= tar * tmp) {
+			*shift = sh, *ratio = tmp;
+			return 0;
+		}
+	}
+	*shift = 0, *ratio = 1;
+	return 0;
+}
+
+int s3c_camif_get_scaler_config(struct camif_vp *vp,
+				struct camif_scaler *scaler)
+{
+	struct v4l2_rect *camif_crop = &vp->camif->camif_crop;
+	int source_x = camif_crop->width;
+	int source_y = camif_crop->height;
+	int target_x = vp->out_frame.rect.width;
+	int target_y = vp->out_frame.rect.height;
+	int ret;
+
+	if (vp->rotation == 90 || vp->rotation == 270)
+		swap(target_x, target_y);
+
+	ret = camif_get_scaler_factor(source_x, target_x, &scaler->pre_h_ratio,
+				      &scaler->h_shift);
+	if (ret < 0)
+		return ret;
+
+	ret = camif_get_scaler_factor(source_y, target_y, &scaler->pre_v_ratio,
+				      &scaler->v_shift);
+	if (ret < 0)
+		return ret;
+
+	scaler->pre_dst_width = source_x / scaler->pre_h_ratio;
+	scaler->pre_dst_height = source_y / scaler->pre_v_ratio;
+
+	scaler->main_h_ratio = (source_x << 8) / (target_x << scaler->h_shift);
+	scaler->main_v_ratio = (source_y << 8) / (target_y << scaler->v_shift);
+
+	scaler->scaleup_h = (target_x >= source_x);
+	scaler->scaleup_v = (target_y >= source_y);
+
+	scaler->copy = 0;
+
+	pr_debug("H: ratio: %u, shift: %u. V: ratio: %u, shift: %u.\n",
+		 scaler->pre_h_ratio, scaler->h_shift,
+		 scaler->pre_v_ratio, scaler->v_shift);
+
+	pr_debug("Source: %dx%d, Target: %dx%d, scaleup_h/v: %d/%d\n",
+		 source_x, source_y, target_x, target_y,
+		 scaler->scaleup_h, scaler->scaleup_v);
+
+	return 0;
+}
+
+static int camif_register_sensor(struct camif_dev *camif)
+{
+	struct s3c_camif_sensor_info *sensor = &camif->pdata.sensor;
+	struct v4l2_device *v4l2_dev = &camif->v4l2_dev;
+	struct i2c_adapter *adapter;
+	struct v4l2_subdev_format format;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	camif->sensor.sd = NULL;
+
+	if (sensor->i2c_board_info.addr == 0)
+		return -EINVAL;
+
+	adapter = i2c_get_adapter(sensor->i2c_bus_num);
+	if (adapter == NULL) {
+		v4l2_warn(v4l2_dev, "failed to get I2C adapter %d\n",
+			  sensor->i2c_bus_num);
+		return -EPROBE_DEFER;
+	}
+
+	sd = v4l2_i2c_new_subdev_board(v4l2_dev, adapter,
+				       &sensor->i2c_board_info, NULL);
+	if (sd == NULL) {
+		i2c_put_adapter(adapter);
+		v4l2_warn(v4l2_dev, "failed to acquire subdev %s\n",
+			  sensor->i2c_board_info.type);
+		return -EPROBE_DEFER;
+	}
+	camif->sensor.sd = sd;
+
+	v4l2_info(v4l2_dev, "registered sensor subdevice %s\n", sd->name);
+
+	/* Get initial pixel format and set it at the camif sink pad */
+	format.pad = 0;
+	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &format);
+
+	if (ret < 0)
+		return 0;
+
+	format.pad = CAMIF_SD_PAD_SINK;
+	v4l2_subdev_call(&camif->subdev, pad, set_fmt, NULL, &format);
+
+	v4l2_info(sd, "Initial format from sensor: %dx%d, %#x\n",
+		  format.format.width, format.format.height,
+		  format.format.code);
+	return 0;
+}
+
+static void camif_unregister_sensor(struct camif_dev *camif)
+{
+	struct v4l2_subdev *sd = camif->sensor.sd;
+	struct i2c_client *client = sd ? v4l2_get_subdevdata(sd) : NULL;
+	struct i2c_adapter *adapter;
+
+	if (client == NULL)
+		return;
+
+	adapter = client->adapter;
+	v4l2_device_unregister_subdev(sd);
+	camif->sensor.sd = NULL;
+	i2c_unregister_device(client);
+	if (adapter)
+		i2c_put_adapter(adapter);
+}
+
+static int camif_create_media_links(struct camif_dev *camif)
+{
+	int i, ret;
+
+	ret = media_entity_create_link(&camif->sensor.sd->entity, 0,
+				&camif->subdev.entity, CAMIF_SD_PAD_SINK,
+				MEDIA_LNK_FL_IMMUTABLE |
+				MEDIA_LNK_FL_ENABLED);
+	if (ret)
+		return ret;
+
+	for (i = 1; i < CAMIF_SD_PADS_NUM && !ret; i++) {
+		ret = media_entity_create_link(&camif->subdev.entity, i,
+				&camif->vp[i - 1].vdev.entity, 0,
+				MEDIA_LNK_FL_IMMUTABLE |
+				MEDIA_LNK_FL_ENABLED);
+	}
+
+	return ret;
+}
+
+static int camif_register_video_nodes(struct camif_dev *camif)
+{
+	int ret = s3c_camif_register_video_node(camif, VP_CODEC);
+	if (ret < 0)
+		return ret;
+
+	return s3c_camif_register_video_node(camif, VP_PREVIEW);
+}
+
+static void camif_unregister_video_nodes(struct camif_dev *camif)
+{
+	s3c_camif_unregister_video_node(camif, VP_CODEC);
+	s3c_camif_unregister_video_node(camif, VP_PREVIEW);
+}
+
+static void camif_unregister_media_entities(struct camif_dev *camif)
+{
+	camif_unregister_video_nodes(camif);
+	camif_unregister_sensor(camif);
+	s3c_camif_unregister_subdev(camif);
+}
+
+/*
+ * Media device
+ */
+static int camif_media_dev_register(struct camif_dev *camif)
+{
+	struct media_device *md = &camif->media_dev;
+	struct v4l2_device *v4l2_dev = &camif->v4l2_dev;
+	unsigned int ip_rev = camif->variant->ip_revision;
+	int ret;
+
+	memset(md, 0, sizeof(*md));
+	snprintf(md->model, sizeof(md->model), "SAMSUNG S3C%s CAMIF",
+		 ip_rev == S3C6410_CAMIF_IP_REV ? "6410" : "244X");
+	strlcpy(md->bus_info, "platform", sizeof(md->bus_info));
+	md->hw_revision = ip_rev;
+	md->driver_version = KERNEL_VERSION(1, 0, 0);
+
+	md->dev = camif->dev;
+
+	strlcpy(v4l2_dev->name, "s3c-camif", sizeof(v4l2_dev->name));
+	v4l2_dev->mdev = md;
+
+	ret = v4l2_device_register(camif->dev, v4l2_dev);
+	if (ret < 0)
+		return ret;
+
+	ret = media_device_register(md);
+	if (ret < 0)
+		v4l2_device_unregister(v4l2_dev);
+
+	return ret;
+}
+
+static void camif_clk_put(struct camif_dev *camif)
+{
+	int i;
+
+	for (i = 0; i < CLK_MAX_NUM; i++) {
+		if (IS_ERR_OR_NULL(camif->clock[i]))
+			continue;
+		clk_unprepare(camif->clock[i]);
+		clk_put(camif->clock[i]);
+	}
+}
+
+static int camif_clk_get(struct camif_dev *camif)
+{
+	int ret, i;
+
+	for (i = 0; i < CLK_MAX_NUM; i++) {
+		camif->clock[i] = clk_get(camif->dev, camif_clocks[i]);
+		if (IS_ERR(camif->clock[i])) {
+			ret = PTR_ERR(camif->clock[i]);
+			goto err;
+		}
+		ret = clk_prepare(camif->clock[i]);
+		if (ret < 0) {
+			clk_put(camif->clock[i]);
+			camif->clock[i] = NULL;
+			goto err;
+		}
+	}
+	return 0;
+err:
+	camif_clk_put(camif);
+	dev_err(camif->dev, "failed to get clock: %s\n",
+		camif_clocks[i]);
+	return ret;
+}
+
+/*
+ * The CAMIF device has two relatively independent data processing paths
+ * that can source data from memory or the common camera input frontend.
+ * Register interrupts for each data processing path (camif_vp).
+ */
+static int camif_request_irqs(struct platform_device *pdev,
+			      struct camif_dev *camif)
+{
+	int irq, ret, i;
+
+	for (i = 0; i < CAMIF_VP_NUM; i++) {
+		struct camif_vp *vp = &camif->vp[i];
+
+		init_waitqueue_head(&vp->irq_queue);
+
+		irq = platform_get_irq(pdev, i);
+		if (irq <= 0) {
+			dev_err(&pdev->dev, "failed to get IRQ %d\n", i);
+			return -ENXIO;
+		}
+
+		ret = devm_request_irq(&pdev->dev, irq, s3c_camif_irq_handler,
+				       0, dev_name(&pdev->dev), vp);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "failed to install IRQ: %d\n", ret);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int s3c_camif_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct s3c_camif_plat_data *pdata = dev->platform_data;
+	struct s3c_camif_drvdata *drvdata;
+	struct camif_dev *camif;
+	struct resource *mres;
+	int ret = 0;
+
+	camif = devm_kzalloc(dev, sizeof(*camif), GFP_KERNEL);
+	if (!camif)
+		return -ENOMEM;
+
+	spin_lock_init(&camif->slock);
+	mutex_init(&camif->lock);
+
+	camif->dev = dev;
+
+	if (!pdata || !pdata->gpio_get || !pdata->gpio_put) {
+		dev_err(dev, "wrong platform data\n");
+		return -EINVAL;
+	}
+
+	camif->pdata = *pdata;
+	drvdata = (void *)platform_get_device_id(pdev)->driver_data;
+	camif->variant = drvdata->variant;
+
+	mres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	camif->io_base = devm_request_and_ioremap(dev, mres);
+	if (!camif->io_base) {
+		dev_err(dev, "failed to obtain I/O memory\n");
+		return -ENOENT;
+	}
+
+	ret = camif_request_irqs(pdev, camif);
+	if (ret < 0)
+		return ret;
+
+	ret = pdata->gpio_get();
+	if (ret < 0)
+		return ret;
+
+	ret = s3c_camif_create_subdev(camif);
+	if (ret < 0)
+		goto err_sd;
+
+	ret = camif_clk_get(camif);
+	if (ret < 0)
+		goto err_clk;
+
+	platform_set_drvdata(pdev, camif);
+	clk_set_rate(camif->clock[CLK_CAM],
+			camif->pdata.sensor.clock_frequency);
+
+	dev_info(dev, "sensor clock frequency: %lu\n",
+		 clk_get_rate(camif->clock[CLK_CAM]));
+	/*
+	 * Set initial pixel format, resolution and crop rectangle.
+	 * Must be done before a sensor subdev is registered as some
+	 * settings are overrode with values from sensor subdev.
+	 */
+	s3c_camif_set_defaults(camif);
+
+	pm_runtime_enable(dev);
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
+		goto err_pm;
+
+	/* Initialize contiguous memory allocator */
+	camif->alloc_ctx = vb2_dma_contig_init_ctx(dev);
+	if (IS_ERR(camif->alloc_ctx)) {
+		ret = PTR_ERR(camif->alloc_ctx);
+		goto err_alloc;
+	}
+
+	ret = camif_media_dev_register(camif);
+	if (ret < 0)
+		goto err_mdev;
+
+	ret = camif_register_sensor(camif);
+	if (ret < 0)
+		goto err_sens;
+
+	ret = v4l2_device_register_subdev(&camif->v4l2_dev, &camif->subdev);
+	if (ret < 0)
+		goto err_sens;
+
+	mutex_lock(&camif->media_dev.graph_mutex);
+
+	ret = v4l2_device_register_subdev_nodes(&camif->v4l2_dev);
+	if (ret < 0)
+		goto err_unlock;
+
+	ret = camif_register_video_nodes(camif);
+	if (ret < 0)
+		goto err_unlock;
+
+	ret = camif_create_media_links(camif);
+	if (ret < 0)
+		goto err_unlock;
+
+	mutex_unlock(&camif->media_dev.graph_mutex);
+	pm_runtime_put(dev);
+	return 0;
+
+err_unlock:
+	mutex_unlock(&camif->media_dev.graph_mutex);
+err_sens:
+	v4l2_device_unregister(&camif->v4l2_dev);
+	media_device_unregister(&camif->media_dev);
+	camif_unregister_media_entities(camif);
+err_mdev:
+	vb2_dma_contig_cleanup_ctx(camif->alloc_ctx);
+err_alloc:
+	pm_runtime_put(dev);
+	pm_runtime_disable(dev);
+err_pm:
+	camif_clk_put(camif);
+err_clk:
+	s3c_camif_unregister_subdev(camif);
+err_sd:
+	pdata->gpio_put();
+	return ret;
+}
+
+static int __devexit s3c_camif_remove(struct platform_device *pdev)
+{
+	struct camif_dev *camif = platform_get_drvdata(pdev);
+	struct s3c_camif_plat_data *pdata = &camif->pdata;
+
+	media_device_unregister(&camif->media_dev);
+	camif_unregister_media_entities(camif);
+	v4l2_device_unregister(&camif->v4l2_dev);
+
+	pm_runtime_disable(&pdev->dev);
+	camif_clk_put(camif);
+	pdata->gpio_put();
+
+	return 0;
+}
+
+static int s3c_camif_runtime_resume(struct device *dev)
+{
+	struct camif_dev *camif = dev_get_drvdata(dev);
+
+	clk_enable(camif->clock[CLK_GATE]);
+	/* null op on s3c244x */
+	clk_enable(camif->clock[CLK_CAM]);
+	return 0;
+}
+
+static int s3c_camif_runtime_suspend(struct device *dev)
+{
+	struct camif_dev *camif = dev_get_drvdata(dev);
+
+	/* null op on s3c244x */
+	clk_disable(camif->clock[CLK_CAM]);
+
+	clk_disable(camif->clock[CLK_GATE]);
+	return 0;
+}
+
+static const struct s3c_camif_variant s3c244x_camif_variant = {
+	.vp_pix_limits = {
+		[VP_CODEC] = {
+			.max_out_width		= 4096,
+			.max_sc_out_width	= 2048,
+			.out_width_align	= 16,
+			.min_out_width		= 16,
+			.max_height		= 4096,
+		},
+		[VP_PREVIEW] = {
+			.max_out_width		= 640,
+			.max_sc_out_width	= 640,
+			.out_width_align	= 16,
+			.min_out_width		= 16,
+			.max_height		= 480,
+		}
+	},
+	.pix_limits = {
+		.win_hor_offset_align	= 8,
+	},
+	.ip_revision = S3C244X_CAMIF_IP_REV,
+};
+
+static struct s3c_camif_drvdata s3c244x_camif_drvdata = {
+	.variant	= &s3c244x_camif_variant,
+	.bus_clk_freq	= 24000000UL,
+};
+
+static const struct s3c_camif_variant s3c6410_camif_variant = {
+	.vp_pix_limits = {
+		[VP_CODEC] = {
+			.max_out_width		= 4096,
+			.max_sc_out_width	= 2048,
+			.out_width_align	= 16,
+			.min_out_width		= 16,
+			.max_height		= 4096,
+		},
+		[VP_PREVIEW] = {
+			.max_out_width		= 4096,
+			.max_sc_out_width	= 720,
+			.out_width_align	= 16,
+			.min_out_width		= 16,
+			.max_height		= 4096,
+		}
+	},
+	.pix_limits = {
+		.win_hor_offset_align	= 8,
+	},
+	.ip_revision = S3C6410_CAMIF_IP_REV,
+	.has_img_effect = 1,
+	.vp_offset = 0x20,
+};
+
+static struct s3c_camif_drvdata s3c6410_camif_drvdata = {
+	.variant	= &s3c6410_camif_variant,
+	.bus_clk_freq	= 133000000UL,
+};
+
+static struct platform_device_id s3c_camif_driver_ids[] = {
+	{
+		.name		= "s3c2440-camif",
+		.driver_data	= (unsigned long)&s3c244x_camif_drvdata,
+	}, {
+		.name		= "s3c6410-camif",
+		.driver_data	= (unsigned long)&s3c6410_camif_drvdata,
+	},
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(platform, s3c_camif_driver_ids);
+
+static const struct dev_pm_ops s3c_camif_pm_ops = {
+	.runtime_suspend	= s3c_camif_runtime_suspend,
+	.runtime_resume		= s3c_camif_runtime_resume,
+};
+
+static struct platform_driver s3c_camif_driver = {
+	.probe		= s3c_camif_probe,
+	.remove		= __devexit_p(s3c_camif_remove),
+	.id_table	= s3c_camif_driver_ids,
+	.driver = {
+		.name	= S3C_CAMIF_DRIVER_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &s3c_camif_pm_ops,
+	}
+};
+
+module_platform_driver(s3c_camif_driver);
+
+MODULE_AUTHOR("Sylwester Nawrocki <sylvester.nawrocki@gmail.com>");
+MODULE_AUTHOR("Tomasz Figa <tomasz.figa@gmail.com>");
+MODULE_DESCRIPTION("S3C24XX/S3C64XX SoC camera interface driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
new file mode 100644
index 0000000..261134b
--- /dev/null
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -0,0 +1,393 @@
+/*
+ * s3c24xx/s3c64xx SoC series Camera Interface (CAMIF) driver
+ *
+ * Copyright (C) 2012 Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
+ * Copyright (C) 2012 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef CAMIF_CORE_H_
+#define CAMIF_CORE_H_
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+#include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mediabus.h>
+#include <media/videobuf2-core.h>
+#include <media/s3c_camif.h>
+
+#define S3C_CAMIF_DRIVER_NAME	"s3c-camif"
+#define CAMIF_REQ_BUFS_MIN	3
+#define CAMIF_MAX_OUT_BUFS	4
+#define CAMIF_MAX_PIX_WIDTH	4096
+#define CAMIF_MAX_PIX_HEIGHT	4096
+#define SCALER_MAX_RATIO	64
+#define CAMIF_DEF_WIDTH		640
+#define CAMIF_DEF_HEIGHT	480
+#define CAMIF_STOP_TIMEOUT	1500 /* ms */
+
+#define S3C244X_CAMIF_IP_REV	0x20 /* 2.0 */
+#define S3C2450_CAMIF_IP_REV	0x30 /* 3.0 - not implemented, not tested */
+#define S3C6400_CAMIF_IP_REV	0x31 /* 3.1 - not implemented, not tested */
+#define S3C6410_CAMIF_IP_REV	0x32 /* 3.2 */
+
+/* struct camif_vp::state */
+
+#define ST_VP_PENDING		(1 << 0)
+#define ST_VP_RUNNING		(1 << 1)
+#define ST_VP_STREAMING		(1 << 2)
+#define ST_VP_SENSOR_STREAMING	(1 << 3)
+
+#define ST_VP_ABORTING		(1 << 4)
+#define ST_VP_OFF		(1 << 5)
+#define ST_VP_LASTIRQ		(1 << 6)
+
+#define ST_VP_CONFIG		(1 << 8)
+
+#define CAMIF_SD_PAD_SINK	0
+#define CAMIF_SD_PAD_SOURCE_C	1
+#define CAMIF_SD_PAD_SOURCE_P	2
+#define CAMIF_SD_PADS_NUM	3
+
+enum img_fmt {
+	IMG_FMT_RGB565 = 0x0010,
+	IMG_FMT_RGB666,
+	IMG_FMT_XRGB8888,
+	IMG_FMT_YCBCR420 = 0x0020,
+	IMG_FMT_YCRCB420,
+	IMG_FMT_YCBCR422P,
+	IMG_FMT_YCBYCR422 = 0x0040,
+	IMG_FMT_YCRYCB422,
+	IMG_FMT_CBYCRY422,
+	IMG_FMT_CRYCBY422,
+};
+
+#define img_fmt_is_rgb(x) ((x) & 0x10)
+#define img_fmt_is_ycbcr(x) ((x) & 0x60)
+
+/* Possible values for struct camif_fmt::flags */
+#define FMT_FL_S3C24XX_CODEC	(1 << 0)
+#define FMT_FL_S3C24XX_PREVIEW	(1 << 1)
+#define FMT_FL_S3C64XX		(1 << 2)
+
+/**
+ * struct camif_fmt - pixel format description
+ * @fourcc:    fourcc code for this format, 0 if not applicable
+ * @color:     a corresponding enum img_fmt
+ * @colplanes: number of physically contiguous data planes
+ * @flags:     indicate for which SoCs revisions this format is valid
+ * @depth:     bits per pixel (total)
+ * @ybpp:      number of luminance bytes per pixel
+ */
+struct camif_fmt {
+	char *name;
+	u32 fourcc;
+	u32 color;
+	u16 colplanes;
+	u16 flags;
+	u8 depth;
+	u8 ybpp;
+};
+
+/**
+ * struct camif_dma_offset - pixel offset information for DMA
+ * @initial: offset (in pixels) to first pixel
+ * @line: offset (in pixels) from end of line to start of next line
+ */
+struct camif_dma_offset {
+	int	initial;
+	int	line;
+};
+
+/**
+ * struct camif_frame - source/target frame properties
+ * @f_width: full pixel width
+ * @f_height: full pixel height
+ * @rect: crop/composition rectangle
+ * @dma_offset: DMA offset configuration
+ */
+struct camif_frame {
+	u16 f_width;
+	u16 f_height;
+	struct v4l2_rect rect;
+	struct camif_dma_offset dma_offset;
+};
+
+/* CAMIF clocks enumeration */
+enum {
+	CLK_GATE,
+	CLK_CAM,
+	CLK_MAX_NUM,
+};
+
+struct vp_pix_limits {
+	u16 max_out_width;
+	u16 max_sc_out_width;
+	u16 out_width_align;
+	u16 max_height;
+	u8 min_out_width;
+	u16 out_hor_offset_align;
+};
+
+struct camif_pix_limits {
+	u16 win_hor_offset_align;
+};
+
+/**
+ * struct s3c_camif_variant - CAMIF variant structure
+ * @vp_pix_limits:    pixel limits for the codec and preview paths
+ * @camif_pix_limits: pixel limits for the camera input interface
+ * @ip_revision:      the CAMIF IP revision: 0x20 for s3c244x, 0x32 for s3c6410
+ */
+struct s3c_camif_variant {
+	struct vp_pix_limits vp_pix_limits[2];
+	struct camif_pix_limits pix_limits;
+	u8 ip_revision;
+	u8 has_img_effect;
+	unsigned int vp_offset;
+};
+
+struct s3c_camif_drvdata {
+	const struct s3c_camif_variant *variant;
+	unsigned long bus_clk_freq;
+};
+
+struct camif_scaler {
+	u8 scaleup_h;
+	u8 scaleup_v;
+	u8 copy;
+	u8 enable;
+	u32 h_shift;
+	u32 v_shift;
+	u32 pre_h_ratio;
+	u32 pre_v_ratio;
+	u32 pre_dst_width;
+	u32 pre_dst_height;
+	u32 main_h_ratio;
+	u32 main_v_ratio;
+};
+
+struct camif_dev;
+
+/**
+ * struct camif_vp - CAMIF data processing path structure (codec/preview)
+ * @irq_queue:	    interrupt handling waitqueue
+ * @irq:	    interrupt number for this data path
+ * @camif:	    pointer to the camif structure
+ * @pad:	    media pad for the video node
+ * @vdev            video device
+ * @ctrl_handler:   video node controls handler
+ * @owner:	    file handle that own the streaming
+ * @pending_buf_q:  pending (empty) buffers queue head
+ * @active_buf_q:   active (being written) buffers queue head
+ * @active_buffers: counter of buffer set up at the DMA engine
+ * @buf_index:	    identifier of a last empty buffer set up in H/W
+ * @frame_sequence: image frame sequence counter
+ * @reqbufs_count:  the number of buffers requested
+ * @scaler:	    the scaler structure
+ * @out_fmt:	    pixel format at this video path output
+ * @payload:	    the output data frame payload size
+ * @out_frame:	    the output pixel resolution
+ * @state:	    the video path's state
+ * @fmt_flags:	    flags determining supported pixel formats
+ * @id:		    CAMIF id, 0 - codec, 1 - preview
+ * @rotation:	    current image rotation value
+ * @hflip:	    apply horizontal flip if set
+ * @vflip:	    apply vertical flip if set
+ */
+struct camif_vp {
+	wait_queue_head_t	irq_queue;
+	int			irq;
+	struct camif_dev	*camif;
+	struct media_pad	pad;
+	struct video_device	vdev;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_fh		*owner;
+	struct vb2_queue	vb_queue;
+	struct list_head	pending_buf_q;
+	struct list_head	active_buf_q;
+	unsigned int		active_buffers;
+	unsigned int		buf_index;
+	unsigned int		frame_sequence;
+	unsigned int		reqbufs_count;
+	struct camif_scaler	scaler;
+	const struct camif_fmt	*out_fmt;
+	unsigned int		payload;
+	struct camif_frame	out_frame;
+	unsigned int		state;
+	u16			fmt_flags;
+	u8			id;
+	u8			rotation;
+	u8			hflip;
+	u8			vflip;
+	unsigned int		offset;
+};
+
+/* Video processing path enumeration */
+#define VP_CODEC	0
+#define VP_PREVIEW	1
+#define CAMIF_VP_NUM	2
+
+/**
+ * struct camif_dev - the CAMIF driver private data structure
+ * @media_dev:    top-level media device structure
+ * @v4l2_dev:	  root v4l2_device
+ * @subdev:       camera interface ("catchcam") subdev
+ * @mbus_fmt:	  camera input media bus format
+ * @camif_crop:   camera input interface crop rectangle
+ * @pads:	  the camif subdev's media pads
+ * @stream_count: the camera interface streaming reference counter
+ * @sensor:       image sensor data structure
+ * @m_pipeline:	  video entity pipeline description
+ * @ctrl_handler: v4l2 control handler (owned by @subdev)
+ * @test_pattern: test pattern controls
+ * @vp:           video path (DMA) description (codec/preview)
+ * @alloc_ctx:    memory buffer allocator context
+ * @variant:      variant information for this device
+ * @dev:	  pointer to the CAMIF device struct
+ * @pdata:	  a copy of the driver's platform data
+ * @clock:	  clocks required for the CAMIF operation
+ * @lock:	  mutex protecting this data structure
+ * @slock:	  spinlock protecting CAMIF registers
+ * @io_base:	  start address of the mmaped CAMIF registers
+ */
+struct camif_dev {
+	struct media_device		media_dev;
+	struct v4l2_device		v4l2_dev;
+	struct v4l2_subdev		subdev;
+	struct v4l2_mbus_framefmt	mbus_fmt;
+	struct v4l2_rect		camif_crop;
+	struct media_pad		pads[CAMIF_SD_PADS_NUM];
+	int				stream_count;
+
+	struct cam_sensor {
+		struct v4l2_subdev	*sd;
+		short			power_count;
+		short			stream_count;
+	} sensor;
+	struct media_pipeline		*m_pipeline;
+
+	struct v4l2_ctrl_handler	ctrl_handler;
+	struct v4l2_ctrl		*ctrl_test_pattern;
+	struct {
+		struct v4l2_ctrl	*ctrl_colorfx;
+		struct v4l2_ctrl	*ctrl_colorfx_cbcr;
+	};
+	u8				test_pattern;
+	u8				colorfx;
+	u8				colorfx_cb;
+	u8				colorfx_cr;
+
+	struct camif_vp			vp[CAMIF_VP_NUM];
+	struct vb2_alloc_ctx		*alloc_ctx;
+
+	const struct s3c_camif_variant	*variant;
+	struct device			*dev;
+	struct s3c_camif_plat_data	pdata;
+	struct clk			*clock[CLK_MAX_NUM];
+	struct mutex			lock;
+	spinlock_t			slock;
+	void __iomem			*io_base;
+};
+
+/**
+ * struct camif_addr - Y/Cb/Cr DMA start address structure
+ * @y:	 luminance plane dma address
+ * @cb:	 Cb plane dma address
+ * @cr:	 Cr plane dma address
+ */
+struct camif_addr {
+	dma_addr_t y;
+	dma_addr_t cb;
+	dma_addr_t cr;
+};
+
+/**
+ * struct camif_buffer - the camif video buffer structure
+ * @vb:    vb2 buffer
+ * @list:  list head for the buffers queue
+ * @paddr: DMA start addresses
+ * @index: an identifier of this buffer at the DMA engine
+ */
+struct camif_buffer {
+	struct vb2_buffer vb;
+	struct list_head list;
+	struct camif_addr paddr;
+	unsigned int index;
+};
+
+const struct camif_fmt *s3c_camif_find_format(struct camif_vp *vp,
+	      const u32 *pixelformat, int index);
+int s3c_camif_register_video_node(struct camif_dev *camif, int idx);
+void s3c_camif_unregister_video_node(struct camif_dev *camif, int idx);
+irqreturn_t s3c_camif_irq_handler(int irq, void *priv);
+int s3c_camif_create_subdev(struct camif_dev *camif);
+void s3c_camif_unregister_subdev(struct camif_dev *camif);
+int s3c_camif_set_defaults(struct camif_dev *camif);
+int s3c_camif_get_scaler_config(struct camif_vp *vp,
+				struct camif_scaler *scaler);
+
+static inline void camif_active_queue_add(struct camif_vp *vp,
+					  struct camif_buffer *buf)
+{
+	list_add_tail(&buf->list, &vp->active_buf_q);
+	vp->active_buffers++;
+}
+
+static inline struct camif_buffer *camif_active_queue_pop(
+					struct camif_vp *vp)
+{
+	struct camif_buffer *buf = list_first_entry(&vp->active_buf_q,
+					      struct camif_buffer, list);
+	list_del(&buf->list);
+	vp->active_buffers--;
+	return buf;
+}
+
+static inline struct camif_buffer *camif_active_queue_peek(
+			   struct camif_vp *vp, int index)
+{
+	struct camif_buffer *tmp, *buf;
+
+	if (WARN_ON(list_empty(&vp->active_buf_q)))
+		return NULL;
+
+	list_for_each_entry_safe(buf, tmp, &vp->active_buf_q, list) {
+		if (buf->index == index) {
+			list_del(&buf->list);
+			vp->active_buffers--;
+			return buf;
+		}
+	}
+
+	return NULL;
+}
+
+static inline void camif_pending_queue_add(struct camif_vp *vp,
+					   struct camif_buffer *buf)
+{
+	list_add_tail(&buf->list, &vp->pending_buf_q);
+}
+
+static inline struct camif_buffer *camif_pending_queue_pop(
+					struct camif_vp *vp)
+{
+	struct camif_buffer *buf = list_first_entry(&vp->pending_buf_q,
+					      struct camif_buffer, list);
+	list_del(&buf->list);
+	return buf;
+}
+
+#endif /* CAMIF_CORE_H_ */
diff --git a/drivers/media/platform/s3c-camif/camif-regs.c b/drivers/media/platform/s3c-camif/camif-regs.c
new file mode 100644
index 0000000..1a3b4fc
--- /dev/null
+++ b/drivers/media/platform/s3c-camif/camif-regs.c
@@ -0,0 +1,606 @@
+/*
+ * Samsung s3c24xx/s3c64xx SoC CAMIF driver
+ *
+ * Copyright (C) 2012 Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
+ * Copyright (C) 2012 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
+#include <linux/delay.h>
+#include "camif-regs.h"
+
+#define camif_write(_camif, _off, _val)	writel(_val, (_camif)->io_base + (_off))
+#define camif_read(_camif, _off)	readl((_camif)->io_base + (_off))
+
+void camif_hw_reset(struct camif_dev *camif)
+{
+	u32 cfg;
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CISRCFMT);
+	cfg |= CISRCFMT_ITU601_8BIT;
+	camif_write(camif, S3C_CAMIF_REG_CISRCFMT, cfg);
+
+	/* S/W reset */
+	cfg = camif_read(camif, S3C_CAMIF_REG_CIGCTRL);
+	cfg |= CIGCTRL_SWRST;
+	if (camif->variant->ip_revision == S3C6410_CAMIF_IP_REV)
+		cfg |= CIGCTRL_IRQ_LEVEL;
+	camif_write(camif, S3C_CAMIF_REG_CIGCTRL, cfg);
+	udelay(10);
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CIGCTRL);
+	cfg &= ~CIGCTRL_SWRST;
+	camif_write(camif, S3C_CAMIF_REG_CIGCTRL, cfg);
+	udelay(10);
+}
+
+void camif_hw_clear_pending_irq(struct camif_vp *vp)
+{
+	u32 cfg = camif_read(vp->camif, S3C_CAMIF_REG_CIGCTRL);
+	cfg |= CIGCTRL_IRQ_CLR(vp->id);
+	camif_write(vp->camif, S3C_CAMIF_REG_CIGCTRL, cfg);
+}
+
+/*
+ * Sets video test pattern (off, color bar, horizontal or vertical gradient).
+ * External sensor pixel clock must be active for the test pattern to work.
+ */
+void camif_hw_set_test_pattern(struct camif_dev *camif, unsigned int pattern)
+{
+	u32 cfg = camif_read(camif, S3C_CAMIF_REG_CIGCTRL);
+	cfg &= ~CIGCTRL_TESTPATTERN_MASK;
+	cfg |= (pattern << 27);
+	camif_write(camif, S3C_CAMIF_REG_CIGCTRL, cfg);
+}
+
+void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
+			unsigned int cr, unsigned int cb)
+{
+	static const struct v4l2_control colorfx[] = {
+		{ V4L2_COLORFX_NONE,		CIIMGEFF_FIN_BYPASS },
+		{ V4L2_COLORFX_BW,		CIIMGEFF_FIN_ARBITRARY },
+		{ V4L2_COLORFX_SEPIA,		CIIMGEFF_FIN_ARBITRARY },
+		{ V4L2_COLORFX_NEGATIVE,	CIIMGEFF_FIN_NEGATIVE },
+		{ V4L2_COLORFX_ART_FREEZE,	CIIMGEFF_FIN_ARTFREEZE },
+		{ V4L2_COLORFX_EMBOSS,		CIIMGEFF_FIN_EMBOSSING },
+		{ V4L2_COLORFX_SILHOUETTE,	CIIMGEFF_FIN_SILHOUETTE },
+		{ V4L2_COLORFX_SET_CBCR,	CIIMGEFF_FIN_ARBITRARY },
+	};
+	unsigned int i, cfg;
+
+	for (i = 0; i < ARRAY_SIZE(colorfx); i++)
+		if (colorfx[i].id == effect)
+			break;
+
+	if (i == ARRAY_SIZE(colorfx))
+		return;
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CIIMGEFF(camif->vp->offset));
+	/* Set effect */
+	cfg &= ~CIIMGEFF_FIN_MASK;
+	cfg |= colorfx[i].value;
+	/* Set both paths */
+	if (camif->variant->ip_revision >= S3C6400_CAMIF_IP_REV) {
+		if (effect == V4L2_COLORFX_NONE)
+			cfg &= ~CIIMGEFF_IE_ENABLE_MASK;
+		else
+			cfg |= CIIMGEFF_IE_ENABLE_MASK;
+	}
+	cfg &= ~CIIMGEFF_PAT_CBCR_MASK;
+	cfg |= cr | (cb << 13);
+	camif_write(camif, S3C_CAMIF_REG_CIIMGEFF(camif->vp->offset), cfg);
+}
+
+static const u32 src_pixfmt_map[8][2] = {
+	{ V4L2_MBUS_FMT_YUYV8_2X8, CISRCFMT_ORDER422_YCBYCR },
+	{ V4L2_MBUS_FMT_YVYU8_2X8, CISRCFMT_ORDER422_YCRYCB },
+	{ V4L2_MBUS_FMT_UYVY8_2X8, CISRCFMT_ORDER422_CBYCRY },
+	{ V4L2_MBUS_FMT_VYUY8_2X8, CISRCFMT_ORDER422_CRYCBY },
+};
+
+/* Set camera input pixel format and resolution */
+void camif_hw_set_source_format(struct camif_dev *camif)
+{
+	struct v4l2_mbus_framefmt *mf = &camif->mbus_fmt;
+	unsigned int i = ARRAY_SIZE(src_pixfmt_map);
+	u32 cfg;
+
+	while (i-- >= 0) {
+		if (src_pixfmt_map[i][0] == mf->code)
+			break;
+	}
+
+	if (i == 0 && src_pixfmt_map[i][0] != mf->code) {
+		dev_err(camif->dev,
+			"Unsupported pixel code, falling back to %#08x\n",
+			src_pixfmt_map[i][0]);
+	}
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CISRCFMT);
+	cfg &= ~(CISRCFMT_ORDER422_MASK | CISRCFMT_SIZE_CAM_MASK);
+	cfg |= (mf->width << 16) | mf->height;
+	cfg |= src_pixfmt_map[i][1];
+	camif_write(camif, S3C_CAMIF_REG_CISRCFMT, cfg);
+}
+
+/* Set the camera host input window offsets (cropping) */
+void camif_hw_set_camera_crop(struct camif_dev *camif)
+{
+	struct v4l2_mbus_framefmt *mf = &camif->mbus_fmt;
+	struct v4l2_rect *crop = &camif->camif_crop;
+	u32 hoff2, voff2;
+	u32 cfg;
+
+	/* Note: s3c244x requirement: left = f_width - rect.width / 2 */
+	cfg = camif_read(camif, S3C_CAMIF_REG_CIWDOFST);
+	cfg &= ~(CIWDOFST_OFST_MASK | CIWDOFST_WINOFSEN);
+	cfg |= (crop->left << 16) | crop->top;
+	if (crop->left != 0 || crop->top != 0)
+		cfg |= CIWDOFST_WINOFSEN;
+	camif_write(camif, S3C_CAMIF_REG_CIWDOFST, cfg);
+
+	if (camif->variant->ip_revision == S3C6410_CAMIF_IP_REV) {
+		hoff2 = mf->width - crop->width - crop->left;
+		voff2 = mf->height - crop->height - crop->top;
+		cfg = (hoff2 << 16) | voff2;
+		camif_write(camif, S3C_CAMIF_REG_CIWDOFST2, cfg);
+	}
+}
+
+void camif_hw_clear_fifo_overflow(struct camif_vp *vp)
+{
+	struct camif_dev *camif = vp->camif;
+	u32 cfg;
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CIWDOFST);
+	if (vp->id == 0)
+		cfg |= (CIWDOFST_CLROVCOFIY | CIWDOFST_CLROVCOFICB |
+			CIWDOFST_CLROVCOFICR);
+	else
+		cfg |= (/* CIWDOFST_CLROVPRFIY | */ CIWDOFST_CLROVPRFICB |
+			CIWDOFST_CLROVPRFICR);
+	camif_write(camif, S3C_CAMIF_REG_CIWDOFST, cfg);
+}
+
+/* Set video bus signals polarity */
+void camif_hw_set_camera_bus(struct camif_dev *camif)
+{
+	unsigned int flags = camif->pdata.sensor.flags;
+
+	u32 cfg = camif_read(camif, S3C_CAMIF_REG_CIGCTRL);
+
+	cfg &= ~(CIGCTRL_INVPOLPCLK | CIGCTRL_INVPOLVSYNC |
+		 CIGCTRL_INVPOLHREF | CIGCTRL_INVPOLFIELD);
+
+	if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+		cfg |= CIGCTRL_INVPOLPCLK;
+
+	if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+		cfg |= CIGCTRL_INVPOLVSYNC;
+	/*
+	 * HREF is normally high during frame active data
+	 * transmission and low during horizontal synchronization
+	 * period. Thus HREF active high means HSYNC active low.
+	 */
+	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
+		cfg |= CIGCTRL_INVPOLHREF; /* HREF active low */
+
+	if (camif->variant->ip_revision == S3C6410_CAMIF_IP_REV) {
+		if (flags & V4L2_MBUS_FIELD_EVEN_LOW)
+			cfg |= CIGCTRL_INVPOLFIELD;
+		cfg |= CIGCTRL_FIELDMODE;
+	}
+
+	pr_debug("Setting CIGCTRL to: %#x\n", cfg);
+
+	camif_write(camif, S3C_CAMIF_REG_CIGCTRL, cfg);
+}
+
+void camif_hw_set_output_addr(struct camif_vp *vp,
+			      struct camif_addr *paddr, int i)
+{
+	struct camif_dev *camif = vp->camif;
+
+	camif_write(camif, S3C_CAMIF_REG_CIYSA(vp->id, i), paddr->y);
+	if (camif->variant->ip_revision == S3C6410_CAMIF_IP_REV
+		|| vp->id == VP_CODEC) {
+		camif_write(camif, S3C_CAMIF_REG_CICBSA(vp->id, i),
+								paddr->cb);
+		camif_write(camif, S3C_CAMIF_REG_CICRSA(vp->id, i),
+								paddr->cr);
+	}
+
+	pr_debug("dst_buf[%d]: %#X, cb: %#X, cr: %#X\n",
+		 i, paddr->y, paddr->cb, paddr->cr);
+}
+
+static void camif_hw_set_out_dma_size(struct camif_vp *vp)
+{
+	struct camif_frame *frame = &vp->out_frame;
+	u32 cfg;
+
+	cfg = camif_read(vp->camif, S3C_CAMIF_REG_CITRGFMT(vp->id, vp->offset));
+	cfg &= ~CITRGFMT_TARGETSIZE_MASK;
+	cfg |= (frame->f_width << 16) | frame->f_height;
+	camif_write(vp->camif, S3C_CAMIF_REG_CITRGFMT(vp->id, vp->offset), cfg);
+}
+
+static void camif_get_dma_burst(u32 width, u32 ybpp, u32 *mburst, u32 *rburst)
+{
+	unsigned int nwords = width * ybpp / 4;
+	unsigned int div, rem;
+
+	if (WARN_ON(width < 8 || (width * ybpp) & 7))
+		return;
+
+	for (div = 16; div >= 2; div /= 2) {
+		if (nwords < div)
+			continue;
+
+		rem = nwords & (div - 1);
+		if (rem == 0) {
+			*mburst = div;
+			*rburst = div;
+			break;
+		}
+		if (rem == div / 2 || rem == div / 4) {
+			*mburst = div;
+			*rburst = rem;
+			break;
+		}
+	}
+}
+
+void camif_hw_set_output_dma(struct camif_vp *vp)
+{
+	struct camif_dev *camif = vp->camif;
+	struct camif_frame *frame = &vp->out_frame;
+	const struct camif_fmt *fmt = vp->out_fmt;
+	unsigned int ymburst = 0, yrburst = 0;
+	u32 cfg;
+
+	camif_hw_set_out_dma_size(vp);
+
+	if (camif->variant->ip_revision == S3C6410_CAMIF_IP_REV) {
+		struct camif_dma_offset *offset = &frame->dma_offset;
+		/* Set the input dma offsets. */
+		cfg = S3C_CISS_OFFS_INITIAL(offset->initial);
+		cfg |= S3C_CISS_OFFS_LINE(offset->line);
+		camif_write(camif, S3C_CAMIF_REG_CISSY(vp->id), cfg);
+		camif_write(camif, S3C_CAMIF_REG_CISSCB(vp->id), cfg);
+		camif_write(camif, S3C_CAMIF_REG_CISSCR(vp->id), cfg);
+	}
+
+	/* Configure DMA burst values */
+	camif_get_dma_burst(frame->rect.width, fmt->ybpp, &ymburst, &yrburst);
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CICTRL(vp->id, vp->offset));
+	cfg &= ~CICTRL_BURST_MASK;
+
+	cfg |= CICTRL_YBURST1(ymburst) | CICTRL_YBURST2(yrburst);
+	cfg |= CICTRL_CBURST1(ymburst / 2) | CICTRL_CBURST2(yrburst / 2);
+
+	camif_write(camif, S3C_CAMIF_REG_CICTRL(vp->id, vp->offset), cfg);
+
+	pr_debug("ymburst: %u, yrburst: %u\n", ymburst, yrburst);
+}
+
+void camif_hw_set_input_path(struct camif_vp *vp)
+{
+	u32 cfg = camif_read(vp->camif, S3C_CAMIF_REG_MSCTRL(vp->id));
+	cfg &= ~MSCTRL_SEL_DMA_CAM;
+	camif_write(vp->camif, S3C_CAMIF_REG_MSCTRL(vp->id), cfg);
+}
+
+void camif_hw_set_target_format(struct camif_vp *vp)
+{
+	struct camif_dev *camif = vp->camif;
+	struct camif_frame *frame = &vp->out_frame;
+	u32 cfg;
+
+	pr_debug("fw: %d, fh: %d color: %d\n", frame->f_width,
+		 frame->f_height, vp->out_fmt->color);
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CITRGFMT(vp->id, vp->offset));
+	cfg &= ~CITRGFMT_TARGETSIZE_MASK;
+
+	if (camif->variant->ip_revision == S3C244X_CAMIF_IP_REV) {
+		/* We currently support only YCbCr 4:2:2 at the camera input */
+		cfg |= CITRGFMT_IN422;
+		cfg &= ~CITRGFMT_OUT422;
+		if (vp->out_fmt->color == IMG_FMT_YCBCR422P)
+			cfg |= CITRGFMT_OUT422;
+	} else {
+		cfg &= ~CITRGFMT_OUTFORMAT_MASK;
+		switch (vp->out_fmt->color) {
+		case IMG_FMT_RGB565...IMG_FMT_XRGB8888:
+			cfg |= CITRGFMT_OUTFORMAT_RGB;
+			break;
+		case IMG_FMT_YCBCR420...IMG_FMT_YCRCB420:
+			cfg |= CITRGFMT_OUTFORMAT_YCBCR420;
+			break;
+		case IMG_FMT_YCBCR422P:
+			cfg |= CITRGFMT_OUTFORMAT_YCBCR422;
+			break;
+		case IMG_FMT_YCBYCR422...IMG_FMT_CRYCBY422:
+			cfg |= CITRGFMT_OUTFORMAT_YCBCR422I;
+			break;
+		}
+	}
+
+	/* Rotation is only supported by s3c64xx */
+	if (vp->rotation == 90 || vp->rotation == 270)
+		cfg |= (frame->f_height << 16) | frame->f_width;
+	else
+		cfg |= (frame->f_width << 16) | frame->f_height;
+	camif_write(camif, S3C_CAMIF_REG_CITRGFMT(vp->id, vp->offset), cfg);
+
+	/* Target area, output pixel width * height */
+	cfg = camif_read(camif, S3C_CAMIF_REG_CITAREA(vp->id, vp->offset));
+	cfg &= ~CITAREA_MASK;
+	cfg |= (frame->f_width * frame->f_height);
+	camif_write(camif, S3C_CAMIF_REG_CITAREA(vp->id, vp->offset), cfg);
+}
+
+void camif_hw_set_flip(struct camif_vp *vp)
+{
+	u32 cfg = camif_read(vp->camif,
+				S3C_CAMIF_REG_CITRGFMT(vp->id, vp->offset));
+
+	cfg &= ~CITRGFMT_FLIP_MASK;
+
+	if (vp->hflip)
+		cfg |= CITRGFMT_FLIP_Y_MIRROR;
+	if (vp->vflip)
+		cfg |= CITRGFMT_FLIP_X_MIRROR;
+
+	camif_write(vp->camif, S3C_CAMIF_REG_CITRGFMT(vp->id, vp->offset), cfg);
+}
+
+static void camif_hw_set_prescaler(struct camif_vp *vp)
+{
+	struct camif_dev *camif = vp->camif;
+	struct camif_scaler *sc = &vp->scaler;
+	u32 cfg, shfactor, addr;
+
+	addr = S3C_CAMIF_REG_CISCPRERATIO(vp->id, vp->offset);
+
+	shfactor = 10 - (sc->h_shift + sc->v_shift);
+	cfg = shfactor << 28;
+
+	cfg |= (sc->pre_h_ratio << 16) | sc->pre_v_ratio;
+	camif_write(camif, addr, cfg);
+
+	cfg = (sc->pre_dst_width << 16) | sc->pre_dst_height;
+	camif_write(camif, S3C_CAMIF_REG_CISCPREDST(vp->id, vp->offset), cfg);
+}
+
+void camif_s3c244x_hw_set_scaler(struct camif_vp *vp)
+{
+	struct camif_dev *camif = vp->camif;
+	struct camif_scaler *scaler = &vp->scaler;
+	unsigned int color = vp->out_fmt->color;
+	u32 cfg;
+
+	camif_hw_set_prescaler(vp);
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CISCCTRL(vp->id, vp->offset));
+
+	cfg &= ~(CISCCTRL_SCALEUP_MASK | CISCCTRL_SCALERBYPASS |
+		 CISCCTRL_MAIN_RATIO_MASK | CIPRSCCTRL_RGB_FORMAT_24BIT);
+
+	if (scaler->enable) {
+		if (scaler->scaleup_h) {
+			if (vp->id == VP_CODEC)
+				cfg |= CISCCTRL_SCALEUP_H;
+			else
+				cfg |= CIPRSCCTRL_SCALEUP_H;
+		}
+		if (scaler->scaleup_v) {
+			if (vp->id == VP_CODEC)
+				cfg |= CISCCTRL_SCALEUP_V;
+			else
+				cfg |= CIPRSCCTRL_SCALEUP_V;
+		}
+	} else {
+		if (vp->id == VP_CODEC)
+			cfg |= CISCCTRL_SCALERBYPASS;
+	}
+
+	cfg |= ((scaler->main_h_ratio & 0x1ff) << 16);
+	cfg |= scaler->main_v_ratio & 0x1ff;
+
+	if (vp->id == VP_PREVIEW) {
+		if (color == IMG_FMT_XRGB8888)
+			cfg |= CIPRSCCTRL_RGB_FORMAT_24BIT;
+		cfg |= CIPRSCCTRL_SAMPLE;
+	}
+
+	camif_write(camif, S3C_CAMIF_REG_CISCCTRL(vp->id, vp->offset), cfg);
+
+	pr_debug("main: h_ratio: %#x, v_ratio: %#x",
+		 scaler->main_h_ratio, scaler->main_v_ratio);
+}
+
+void camif_s3c64xx_hw_set_scaler(struct camif_vp *vp)
+{
+	struct camif_dev *camif = vp->camif;
+	struct camif_scaler *scaler = &vp->scaler;
+	unsigned int color = vp->out_fmt->color;
+	u32 cfg;
+
+	camif_hw_set_prescaler(vp);
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CISCCTRL(vp->id, vp->offset));
+
+	cfg &= ~(CISCCTRL_CSCR2Y_WIDE | CISCCTRL_CSCY2R_WIDE
+		| CISCCTRL_SCALEUP_H | CISCCTRL_SCALEUP_V
+		| CISCCTRL_SCALERBYPASS | CISCCTRL_ONE2ONE
+		| CISCCTRL_INRGB_FMT_MASK | CISCCTRL_OUTRGB_FMT_MASK
+		| CISCCTRL_INTERLACE | CISCCTRL_EXTRGB_EXTENSION
+		| CISCCTRL_MAIN_RATIO_MASK);
+
+	cfg |= (CISCCTRL_CSCR2Y_WIDE | CISCCTRL_CSCY2R_WIDE);
+
+	if (!scaler->enable) {
+		cfg |= CISCCTRL_SCALERBYPASS;
+	} else {
+		if (scaler->scaleup_h)
+			cfg |= CISCCTRL_SCALEUP_H;
+		if (scaler->scaleup_v)
+			cfg |= CISCCTRL_SCALEUP_V;
+		if (scaler->copy)
+			cfg |= CISCCTRL_ONE2ONE;
+	}
+
+	switch (color) {
+	case IMG_FMT_RGB666:
+		cfg |= CISCCTRL_OUTRGB_FMT_RGB666;
+		break;
+	case IMG_FMT_XRGB8888:
+		cfg |= CISCCTRL_OUTRGB_FMT_RGB888;
+		break;
+	}
+
+	cfg |= (scaler->main_h_ratio & 0x1ff) << 16;
+	cfg |= scaler->main_v_ratio & 0x1ff;
+
+	camif_write(camif, S3C_CAMIF_REG_CISCCTRL(vp->id, vp->offset), cfg);
+
+	pr_debug("main: h_ratio: %#x, v_ratio: %#x",
+		 scaler->main_h_ratio, scaler->main_v_ratio);
+}
+
+void camif_hw_set_scaler(struct camif_vp *vp)
+{
+	unsigned int ip_rev = vp->camif->variant->ip_revision;
+
+	if (ip_rev == S3C244X_CAMIF_IP_REV)
+		camif_s3c244x_hw_set_scaler(vp);
+	else
+		camif_s3c64xx_hw_set_scaler(vp);
+}
+
+void camif_hw_enable_scaler(struct camif_vp *vp, bool on)
+{
+	u32 addr = S3C_CAMIF_REG_CISCCTRL(vp->id, vp->offset);
+	u32 cfg;
+
+	cfg = camif_read(vp->camif, addr);
+	if (on)
+		cfg |= CISCCTRL_SCALERSTART;
+	else
+		cfg &= ~CISCCTRL_SCALERSTART;
+	camif_write(vp->camif, addr, cfg);
+}
+
+void camif_hw_set_lastirq(struct camif_vp *vp, int enable)
+{
+	u32 addr = S3C_CAMIF_REG_CICTRL(vp->id, vp->offset);
+	u32 cfg;
+
+	cfg = camif_read(vp->camif, addr);
+	if (enable)
+		cfg |= CICTRL_LASTIRQ_ENABLE;
+	else
+		cfg &= ~CICTRL_LASTIRQ_ENABLE;
+	camif_write(vp->camif, addr, cfg);
+}
+
+void camif_hw_enable_capture(struct camif_vp *vp)
+{
+	struct camif_dev *camif = vp->camif;
+	u32 cfg;
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CIIMGCPT(vp->offset));
+	camif->stream_count++;
+
+	if (camif->variant->ip_revision == S3C6410_CAMIF_IP_REV)
+		cfg |= CIIMGCPT_CPT_FREN_ENABLE(vp->id);
+
+	if (vp->scaler.enable)
+		cfg |= CIIMGCPT_IMGCPTEN_SC(vp->id);
+
+	if (camif->stream_count == 1)
+		cfg |= CIIMGCPT_IMGCPTEN;
+
+	camif_write(camif, S3C_CAMIF_REG_CIIMGCPT(vp->offset), cfg);
+
+	pr_debug("CIIMGCPT: %#x, camif->stream_count: %d\n",
+		 cfg, camif->stream_count);
+}
+
+void camif_hw_disable_capture(struct camif_vp *vp)
+{
+	struct camif_dev *camif = vp->camif;
+	u32 cfg;
+
+	cfg = camif_read(camif, S3C_CAMIF_REG_CIIMGCPT(vp->offset));
+	cfg &= ~CIIMGCPT_IMGCPTEN_SC(vp->id);
+
+	if (WARN_ON(--(camif->stream_count) < 0))
+		camif->stream_count = 0;
+
+	if (camif->stream_count == 0)
+		cfg &= ~CIIMGCPT_IMGCPTEN;
+
+	pr_debug("CIIMGCPT: %#x, camif->stream_count: %d\n",
+		 cfg, camif->stream_count);
+
+	camif_write(camif, S3C_CAMIF_REG_CIIMGCPT(vp->offset), cfg);
+}
+
+void camif_hw_dump_regs(struct camif_dev *camif, const char *label)
+{
+	struct {
+		u32 offset;
+		const char * const name;
+	} registers[] = {
+		{ S3C_CAMIF_REG_CISRCFMT,		"CISRCFMT" },
+		{ S3C_CAMIF_REG_CIWDOFST,		"CIWDOFST" },
+		{ S3C_CAMIF_REG_CIGCTRL,		"CIGCTRL" },
+		{ S3C_CAMIF_REG_CIWDOFST2,		"CIWDOFST2" },
+		{ S3C_CAMIF_REG_CIYSA(0, 0),		"CICOYSA0" },
+		{ S3C_CAMIF_REG_CICBSA(0, 0),		"CICOCBSA0" },
+		{ S3C_CAMIF_REG_CICRSA(0, 0),		"CICOCRSA0" },
+		{ S3C_CAMIF_REG_CIYSA(0, 1),		"CICOYSA1" },
+		{ S3C_CAMIF_REG_CICBSA(0, 1),		"CICOCBSA1" },
+		{ S3C_CAMIF_REG_CICRSA(0, 1),		"CICOCRSA1" },
+		{ S3C_CAMIF_REG_CIYSA(0, 2),		"CICOYSA2" },
+		{ S3C_CAMIF_REG_CICBSA(0, 2),		"CICOCBSA2" },
+		{ S3C_CAMIF_REG_CICRSA(0, 2),		"CICOCRSA2" },
+		{ S3C_CAMIF_REG_CIYSA(0, 3),		"CICOYSA3" },
+		{ S3C_CAMIF_REG_CICBSA(0, 3),		"CICOCBSA3" },
+		{ S3C_CAMIF_REG_CICRSA(0, 3),		"CICOCRSA3" },
+		{ S3C_CAMIF_REG_CIYSA(1, 0),		"CIPRYSA0" },
+		{ S3C_CAMIF_REG_CIYSA(1, 1),		"CIPRYSA1" },
+		{ S3C_CAMIF_REG_CIYSA(1, 2),		"CIPRYSA2" },
+		{ S3C_CAMIF_REG_CIYSA(1, 3),		"CIPRYSA3" },
+		{ S3C_CAMIF_REG_CITRGFMT(0, 0),		"CICOTRGFMT" },
+		{ S3C_CAMIF_REG_CITRGFMT(1, 0),		"CIPRTRGFMT" },
+		{ S3C_CAMIF_REG_CICTRL(0, 0),		"CICOCTRL" },
+		{ S3C_CAMIF_REG_CICTRL(1, 0),		"CIPRCTRL" },
+		{ S3C_CAMIF_REG_CISCPREDST(0, 0),	"CICOSCPREDST" },
+		{ S3C_CAMIF_REG_CISCPREDST(1, 0),	"CIPRSCPREDST" },
+		{ S3C_CAMIF_REG_CISCPRERATIO(0, 0),	"CICOSCPRERATIO" },
+		{ S3C_CAMIF_REG_CISCPRERATIO(1, 0),	"CIPRSCPRERATIO" },
+		{ S3C_CAMIF_REG_CISCCTRL(0, 0),		"CICOSCCTRL" },
+		{ S3C_CAMIF_REG_CISCCTRL(1, 0),		"CIPRSCCTRL" },
+		{ S3C_CAMIF_REG_CITAREA(0, 0),		"CICOTAREA" },
+		{ S3C_CAMIF_REG_CITAREA(1, 0),		"CIPRTAREA" },
+		{ S3C_CAMIF_REG_CISTATUS(0, 0),		"CICOSTATUS" },
+		{ S3C_CAMIF_REG_CISTATUS(1, 0),		"CIPRSTATUS" },
+		{ S3C_CAMIF_REG_CIIMGCPT(0),		"CIIMGCPT" },
+	};
+	u32 i;
+
+	pr_info("--- %s ---\n", label);
+	for (i = 0; i < ARRAY_SIZE(registers); i++) {
+		u32 cfg = readl(camif->io_base + registers[i].offset);
+		printk(KERN_INFO "%s:\t0x%08x\n", registers[i].name, cfg);
+	}
+}
diff --git a/drivers/media/platform/s3c-camif/camif-regs.h b/drivers/media/platform/s3c-camif/camif-regs.h
new file mode 100644
index 0000000..af2d472
--- /dev/null
+++ b/drivers/media/platform/s3c-camif/camif-regs.h
@@ -0,0 +1,269 @@
+/*
+ * Register definition file for s3c24xx/s3c64xx SoC CAMIF driver
+ *
+ * Copyright (C) 2012 Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
+ * Copyright (C) 2012 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef CAMIF_REGS_H_
+#define CAMIF_REGS_H_
+
+#include "camif-core.h"
+#include <media/s3c_camif.h>
+
+/*
+ * The id argument indicates the processing path:
+ * id = 0 - codec (FIMC C), 1 - preview (FIMC P).
+ */
+
+/* Camera input format */
+#define S3C_CAMIF_REG_CISRCFMT			0x00
+#define  CISRCFMT_ITU601_8BIT			(1 << 31)
+#define  CISRCFMT_ITU656_8BIT			(0 << 31)
+#define  CISRCFMT_ORDER422_YCBYCR		(0 << 14)
+#define  CISRCFMT_ORDER422_YCRYCB		(1 << 14)
+#define  CISRCFMT_ORDER422_CBYCRY		(2 << 14)
+#define  CISRCFMT_ORDER422_CRYCBY		(3 << 14)
+#define  CISRCFMT_ORDER422_MASK			(3 << 14)
+#define  CISRCFMT_SIZE_CAM_MASK			(0x1fff << 16 | 0x1fff)
+
+/* Window offset */
+#define S3C_CAMIF_REG_CIWDOFST			0x04
+#define  CIWDOFST_WINOFSEN			(1 << 31)
+#define  CIWDOFST_CLROVCOFIY			(1 << 30)
+#define  CIWDOFST_CLROVRLB_PR			(1 << 28)
+/* #define  CIWDOFST_CLROVPRFIY			(1 << 27) */
+#define  CIWDOFST_CLROVCOFICB			(1 << 15)
+#define  CIWDOFST_CLROVCOFICR			(1 << 14)
+#define  CIWDOFST_CLROVPRFICB			(1 << 13)
+#define  CIWDOFST_CLROVPRFICR			(1 << 12)
+#define  CIWDOFST_OFST_MASK			(0x7ff << 16 | 0x7ff)
+
+/* Window offset 2 */
+#define S3C_CAMIF_REG_CIWDOFST2			0x14
+#define  CIWDOFST2_OFST2_MASK			(0xfff << 16 | 0xfff)
+
+/* Global control */
+#define S3C_CAMIF_REG_CIGCTRL			0x08
+#define  CIGCTRL_SWRST				(1 << 31)
+#define  CIGCTRL_CAMRST				(1 << 30)
+#define  CIGCTRL_TESTPATTERN_NORMAL		(0 << 27)
+#define  CIGCTRL_TESTPATTERN_COLOR_BAR		(1 << 27)
+#define  CIGCTRL_TESTPATTERN_HOR_INC		(2 << 27)
+#define  CIGCTRL_TESTPATTERN_VER_INC		(3 << 27)
+#define  CIGCTRL_TESTPATTERN_MASK		(3 << 27)
+#define  CIGCTRL_INVPOLPCLK			(1 << 26)
+#define  CIGCTRL_INVPOLVSYNC			(1 << 25)
+#define  CIGCTRL_INVPOLHREF			(1 << 24)
+#define  CIGCTRL_IRQ_OVFEN			(1 << 22)
+#define  CIGCTRL_HREF_MASK			(1 << 21)
+#define  CIGCTRL_IRQ_LEVEL			(1 << 20)
+/* IRQ_CLR_C, IRQ_CLR_P */
+#define  CIGCTRL_IRQ_CLR(id)			(1 << (19 - (id)))
+#define  CIGCTRL_FIELDMODE			(1 << 2)
+#define  CIGCTRL_INVPOLFIELD			(1 << 1)
+#define  CIGCTRL_CAM_INTERLACE			(1 << 0)
+
+/* Y DMA output frame start address. n = 0..3. */
+#define S3C_CAMIF_REG_CIYSA(id, n)		(0x18 + (id) * 0x54 + (n) * 4)
+/* Cb plane output DMA start address. n = 0..3. Only codec path. */
+#define S3C_CAMIF_REG_CICBSA(id, n)		(0x28 + (id) * 0x54 + (n) * 4)
+/* Cr plane output DMA start address. n = 0..3. Only codec path. */
+#define S3C_CAMIF_REG_CICRSA(id, n)		(0x38 + (id) * 0x54 + (n) * 4)
+
+/* CICOTRGFMT, CIPRTRGFMT - Target format */
+#define S3C_CAMIF_REG_CITRGFMT(id, _offs)	(0x48 + (id) * (0x34 + (_offs)))
+#define  CITRGFMT_IN422				(1 << 31) /* only for s3c24xx */
+#define  CITRGFMT_OUT422			(1 << 30) /* only for s3c24xx */
+#define  CITRGFMT_OUTFORMAT_YCBCR420		(0 << 29) /* only for s3c6410 */
+#define  CITRGFMT_OUTFORMAT_YCBCR422		(1 << 29) /* only for s3c6410 */
+#define  CITRGFMT_OUTFORMAT_YCBCR422I		(2 << 29) /* only for s3c6410 */
+#define  CITRGFMT_OUTFORMAT_RGB			(3 << 29) /* only for s3c6410 */
+#define  CITRGFMT_OUTFORMAT_MASK		(3 << 29) /* only for s3c6410 */
+#define  CITRGFMT_TARGETHSIZE(x)		((x) << 16)
+#define  CITRGFMT_FLIP_NORMAL			(0 << 14)
+#define  CITRGFMT_FLIP_X_MIRROR			(1 << 14)
+#define  CITRGFMT_FLIP_Y_MIRROR			(2 << 14)
+#define  CITRGFMT_FLIP_180			(3 << 14)
+#define  CITRGFMT_FLIP_MASK			(3 << 14)
+/* Preview path only */
+#define  CITRGFMT_ROT90_PR			(1 << 13)
+#define  CITRGFMT_TARGETVSIZE(x)		((x) << 0)
+#define  CITRGFMT_TARGETSIZE_MASK		((0x1fff << 16) | 0x1fff)
+
+/* CICOCTRL, CIPRCTRL. Output DMA control. */
+#define S3C_CAMIF_REG_CICTRL(id, _offs)		(0x4c + (id) * (0x34 + (_offs)))
+#define  CICTRL_BURST_MASK			(0xfffff << 4)
+/* xBURSTn - 5-bits width */
+#define  CICTRL_YBURST1(x)			((x) << 19)
+#define  CICTRL_YBURST2(x)			((x) << 14)
+#define  CICTRL_RGBBURST1(x)			((x) << 19)
+#define  CICTRL_RGBBURST2(x)			((x) << 14)
+#define  CICTRL_CBURST1(x)			((x) << 9)
+#define  CICTRL_CBURST2(x)			((x) << 4)
+#define  CICTRL_LASTIRQ_ENABLE			(1 << 2)
+#define  CICTRL_ORDER422_MASK			(3 << 0)
+
+/* CICOSCPRERATIO, CIPRSCPRERATIO. Pre-scaler control 1. */
+#define S3C_CAMIF_REG_CISCPRERATIO(id, _offs)	(0x50 + (id) * (0x34 + (_offs)))
+
+/* CICOSCPREDST, CIPRSCPREDST. Pre-scaler control 2. */
+#define S3C_CAMIF_REG_CISCPREDST(id, _offs)	(0x54 + (id) * (0x34 + (_offs)))
+
+/* CICOSCCTRL, CIPRSCCTRL. Main scaler control. */
+#define S3C_CAMIF_REG_CISCCTRL(id, _offs)	(0x58 + (id) * (0x34 + (_offs)))
+#define  CISCCTRL_SCALERBYPASS			(1 << 31)
+/* s3c244x preview path only, s3c64xx both */
+#define  CIPRSCCTRL_SAMPLE			(1 << 31)
+/* 0 - 16-bit RGB, 1 - 24-bit RGB */
+#define  CIPRSCCTRL_RGB_FORMAT_24BIT		(1 << 30) /* only for s3c244x */
+#define  CIPRSCCTRL_SCALEUP_H			(1 << 29) /* only for s3c244x */
+#define  CIPRSCCTRL_SCALEUP_V			(1 << 28) /* only for s3c244x */
+/* s3c64xx */
+#define  CISCCTRL_SCALEUP_H			(1 << 30)
+#define  CISCCTRL_SCALEUP_V			(1 << 29)
+#define  CISCCTRL_SCALEUP_MASK			(0x3 << 29)
+#define  CISCCTRL_CSCR2Y_WIDE			(1 << 28)
+#define  CISCCTRL_CSCY2R_WIDE			(1 << 27)
+#define  CISCCTRL_LCDPATHEN_FIFO		(1 << 26)
+#define  CISCCTRL_INTERLACE			(1 << 25)
+#define  CISCCTRL_SCALERSTART			(1 << 15)
+#define  CISCCTRL_INRGB_FMT_RGB565		(0 << 13)
+#define  CISCCTRL_INRGB_FMT_RGB666		(1 << 13)
+#define  CISCCTRL_INRGB_FMT_RGB888		(2 << 13)
+#define  CISCCTRL_INRGB_FMT_MASK		(3 << 13)
+#define  CISCCTRL_OUTRGB_FMT_RGB565		(0 << 11)
+#define  CISCCTRL_OUTRGB_FMT_RGB666		(1 << 11)
+#define  CISCCTRL_OUTRGB_FMT_RGB888		(2 << 11)
+#define  CISCCTRL_OUTRGB_FMT_MASK		(3 << 11)
+#define  CISCCTRL_EXTRGB_EXTENSION		(1 << 10)
+#define  CISCCTRL_ONE2ONE			(1 << 9)
+#define  CISCCTRL_MAIN_RATIO_MASK		(0x1ff << 16 | 0x1ff)
+
+/* CICOTAREA, CIPRTAREA. Target area for DMA (Hsize x Vsize). */
+#define S3C_CAMIF_REG_CITAREA(id, _offs)	(0x5c + (id) * (0x34 + (_offs)))
+#define CITAREA_MASK				0xfffffff
+
+/* Codec (id = 0) or preview (id = 1) path status. */
+#define S3C_CAMIF_REG_CISTATUS(id, _offs)	(0x64 + (id) * (0x34 + (_offs)))
+#define  CISTATUS_OVFIY_STATUS			(1 << 31)
+#define  CISTATUS_OVFICB_STATUS			(1 << 30)
+#define  CISTATUS_OVFICR_STATUS			(1 << 29)
+#define  CISTATUS_OVF_MASK			(0x7 << 29)
+#define  CIPRSTATUS_OVF_MASK			(0x3 << 30)
+#define  CISTATUS_VSYNC_STATUS			(1 << 28)
+#define  CISTATUS_FRAMECNT_MASK			(3 << 26)
+#define  CISTATUS_FRAMECNT(__reg)		(((__reg) >> 26) & 0x3)
+#define  CISTATUS_WINOFSTEN_STATUS		(1 << 25)
+#define  CISTATUS_IMGCPTEN_STATUS		(1 << 22)
+#define  CISTATUS_IMGCPTENSC_STATUS		(1 << 21)
+#define  CISTATUS_VSYNC_A_STATUS		(1 << 20)
+#define  CISTATUS_FRAMEEND_STATUS		(1 << 19) /* 17 on s3c64xx */
+
+/* Image capture enable */
+#define S3C_CAMIF_REG_CIIMGCPT(_offs)		(0xa0 + (_offs))
+#define  CIIMGCPT_IMGCPTEN			(1 << 31)
+#define  CIIMGCPT_IMGCPTEN_SC(id)		(1 << (30 - (id)))
+/* Frame control: 1 - one-shot, 0 - free run */
+#define  CIIMGCPT_CPT_FREN_ENABLE(id)		(1 << (25 - (id)))
+#define  CIIMGCPT_CPT_FRMOD_ENABLE		(0 << 18)
+#define  CIIMGCPT_CPT_FRMOD_CNT			(1 << 18)
+
+/* Capture sequence */
+#define S3C_CAMIF_REG_CICPTSEQ			0xc4
+
+/* Image effects */
+#define S3C_CAMIF_REG_CIIMGEFF(_offs)		(0xb0 + (_offs))
+#define  CIIMGEFF_IE_ENABLE(id)			(1 << (30 + (id)))
+#define  CIIMGEFF_IE_ENABLE_MASK		(3 << 30)
+/* Image effect: 1 - after scaler, 0 - before scaler */
+#define  CIIMGEFF_IE_AFTER_SC			(1 << 29)
+#define  CIIMGEFF_FIN_MASK			(7 << 26)
+#define  CIIMGEFF_FIN_BYPASS			(0 << 26)
+#define  CIIMGEFF_FIN_ARBITRARY			(1 << 26)
+#define  CIIMGEFF_FIN_NEGATIVE			(2 << 26)
+#define  CIIMGEFF_FIN_ARTFREEZE			(3 << 26)
+#define  CIIMGEFF_FIN_EMBOSSING			(4 << 26)
+#define  CIIMGEFF_FIN_SILHOUETTE		(5 << 26)
+#define  CIIMGEFF_PAT_CBCR_MASK			((0xff << 13) | 0xff)
+#define  CIIMGEFF_PAT_CB(x)			((x) << 13)
+#define  CIIMGEFF_PAT_CR(x)			(x)
+
+/* MSCOY0SA, MSPRY0SA. Y/Cb/Cr frame start address for input DMA. */
+#define S3C_CAMIF_REG_MSY0SA(id)		(0xd4 + ((id) * 0x2c))
+#define S3C_CAMIF_REG_MSCB0SA(id)		(0xd8 + ((id) * 0x2c))
+#define S3C_CAMIF_REG_MSCR0SA(id)		(0xdc + ((id) * 0x2c))
+
+/* MSCOY0END, MSCOY0END. Y/Cb/Cr frame end address for input DMA. */
+#define S3C_CAMIF_REG_MSY0END(id)		(0xe0 + ((id) * 0x2c))
+#define S3C_CAMIF_REG_MSCB0END(id)		(0xe4 + ((id) * 0x2c))
+#define S3C_CAMIF_REG_MSCR0END(id)		(0xe8 + ((id) * 0x2c))
+
+/* MSPRYOFF, MSPRYOFF. Y/Cb/Cr offset. n: 0 - codec, 1 - preview. */
+#define S3C_CAMIF_REG_MSYOFF(id)		(0x118 + ((id) * 0x2c))
+#define S3C_CAMIF_REG_MSCBOFF(id)		(0x11c + ((id) * 0x2c))
+#define S3C_CAMIF_REG_MSCROFF(id)		(0x120 + ((id) * 0x2c))
+
+/* Real input DMA data size. n = 0 - codec, 1 - preview. */
+#define S3C_CAMIF_REG_MSWIDTH(id)		(0xf8 + (id) * 0x2c)
+#define  AUTOLOAD_ENABLE			(1 << 31)
+#define  ADDR_CH_DIS				(1 << 30)
+#define  MSHEIGHT(x)				(((x) & 0x3ff) << 16)
+#define  MSWIDTH(x)				((x) & 0x3ff)
+
+/* Input DMA control. n = 0 - codec, 1 - preview */
+#define S3C_CAMIF_REG_MSCTRL(id)		(0xfc + (id) * 0x2c)
+#define  MSCTRL_ORDER422_M_YCBYCR		(0 << 4)
+#define  MSCTRL_ORDER422_M_YCRYCB		(1 << 4)
+#define  MSCTRL_ORDER422_M_CBYCRY		(2 << 4)
+#define  MSCTRL_ORDER422_M_CRYCBY		(3 << 4)
+/* 0 - camera, 1 - DMA */
+#define  MSCTRL_SEL_DMA_CAM			(1 << 3)
+#define  MSCTRL_INFORMAT_M_YCBCR420		(0 << 1)
+#define  MSCTRL_INFORMAT_M_YCBCR422		(1 << 1)
+#define  MSCTRL_INFORMAT_M_YCBCR422I		(2 << 1)
+#define  MSCTRL_INFORMAT_M_RGB			(3 << 1)
+#define  MSCTRL_ENVID_M				(1 << 0)
+
+/* CICOSCOSY, CIPRSCOSY. Scan line Y/Cb/Cr offset. */
+#define S3C_CAMIF_REG_CISSY(id)			(0x12c + (id) * 0x0c)
+#define S3C_CAMIF_REG_CISSCB(id)		(0x130 + (id) * 0x0c)
+#define S3C_CAMIF_REG_CISSCR(id)		(0x134 + (id) * 0x0c)
+#define S3C_CISS_OFFS_INITIAL(x)		((x) << 16)
+#define S3C_CISS_OFFS_LINE(x)			((x) << 0)
+
+/* ------------------------------------------------------------------ */
+
+void camif_hw_reset(struct camif_dev *camif);
+void camif_hw_clear_pending_irq(struct camif_vp *vp);
+void camif_hw_clear_fifo_overflow(struct camif_vp *vp);
+void camif_hw_set_lastirq(struct camif_vp *vp, int enable);
+void camif_hw_set_input_path(struct camif_vp *vp);
+void camif_hw_enable_scaler(struct camif_vp *vp, bool on);
+void camif_hw_enable_capture(struct camif_vp *vp);
+void camif_hw_disable_capture(struct camif_vp *vp);
+void camif_hw_set_camera_bus(struct camif_dev *camif);
+void camif_hw_set_source_format(struct camif_dev *camif);
+void camif_hw_set_camera_crop(struct camif_dev *camif);
+void camif_hw_set_scaler(struct camif_vp *vp);
+void camif_hw_set_flip(struct camif_vp *vp);
+void camif_hw_set_output_dma(struct camif_vp *vp);
+void camif_hw_set_target_format(struct camif_vp *vp);
+void camif_hw_set_test_pattern(struct camif_dev *camif, unsigned int pattern);
+void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
+			unsigned int cr, unsigned int cb);
+void camif_hw_set_output_addr(struct camif_vp *vp, struct camif_addr *paddr,
+			      int index);
+void camif_hw_dump_regs(struct camif_dev *camif, const char *label);
+
+static inline u32 camif_hw_get_status(struct camif_vp *vp)
+{
+	return readl(vp->camif->io_base + S3C_CAMIF_REG_CISTATUS(vp->id,
+								vp->offset));
+}
+
+#endif /* CAMIF_REGS_H_ */
diff --git a/include/media/s3c_camif.h b/include/media/s3c_camif.h
new file mode 100644
index 0000000..df96c2c
--- /dev/null
+++ b/include/media/s3c_camif.h
@@ -0,0 +1,45 @@
+/*
+ * s3c24xx/s3c64xx SoC series Camera Interface (CAMIF) driver
+ *
+ * Copyright (C) 2012 Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef MEDIA_S3C_CAMIF_
+#define MEDIA_S3C_CAMIF_
+
+#include <linux/i2c.h>
+#include <media/v4l2-mediabus.h>
+
+/**
+ * struct s3c_camif_sensor_info - an image sensor description
+ * @i2c_board_info: pointer to an I2C sensor subdevice board info
+ * @clock_frequency: frequency of the clock the host provides to a sensor
+ * @mbus_type: media bus type
+ * @i2c_bus_num: i2c control bus id the sensor is attached to
+ * @flags: the parallel bus flags defining signals polarity (V4L2_MBUS_*)
+ * @use_field: 1 if parallel bus FIELD signal is used (only s3c64xx)
+ */
+struct s3c_camif_sensor_info {
+	struct i2c_board_info i2c_board_info;
+	unsigned long clock_frequency;
+	enum v4l2_mbus_type mbus_type;
+	u16 i2c_bus_num;
+	u16 flags;
+	u8 use_field;
+};
+
+struct s3c_camif_plat_data {
+	struct s3c_camif_sensor_info sensor;
+	int (*gpio_get)(void);
+	int (*gpio_put)(void);
+};
+
+/* Platform default helper functions */
+int s3c_camif_gpio_get(void);
+int s3c_camif_gpio_put(void);
+
+#endif /* MEDIA_S3C_CAMIF_ */
--
1.7.4.1

