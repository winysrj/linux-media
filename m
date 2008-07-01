Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6147jjV030796
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:07:45 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6147X5D015543
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:07:33 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id m6147MaW013281
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:07:27 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id m6147LFc014643
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:07:21 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m6147LG20001
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:07:21 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m6147LKn007694
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:07:21 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m6147Lma007682
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 23:07:21 -0500
Date: Mon, 30 Jun 2008 23:07:21 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080701040721.GA7673@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 10/16] OMAP3 camera driver ISP basic blocks
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Mohit Jalori <mjalori@ti.com>

ARM: OMAP: OMAP34XXCAM: Camera Driver.

Adding OMAP 3 Camera Driver with basic ISP blocks.

Signed-off-by: Mohit Jalori <mjalori@ti.com>
---
 drivers/media/video/Kconfig          |   10
 drivers/media/video/Makefile         |    2
 drivers/media/video/omap34xxcam.c    | 1605 +++++++++++++++++++++++++++++++
 drivers/media/video/omap34xxcam.h    |  189 +++
 drivers/media/video/isp/Makefile     |    4
 drivers/media/video/isp/Kconfig      |    1
 drivers/media/video/isp/isp.c        | 1802 +++++++++++++++++++++++++++++++++++
 drivers/media/video/isp/isp.h        |  326 ++++++
 drivers/media/video/isp/ispccdc.c    | 1296 +++++++++++++++++++++++++
 drivers/media/video/isp/ispccdc.h    |  202 +++
 drivers/media/video/isp/ispmmu.c     |  742 ++++++++++++++
 drivers/media/video/isp/ispmmu.h     |  117 ++
 drivers/media/video/isp/ispreg.h     | 1281 ++++++++++++++++++++++++
 include/asm-arm/arch-omap/isp_user.h |  151 ++
 14 files changed, 7728 insertions(+)

--- a/drivers/media/video/Kconfig	2008-06-29 17:44:21.000000000 -0500
+++ b/drivers/media/video/Kconfig	2008-06-29 16:57:48.000000000 -0500
@@ -792,6 +792,16 @@ config VIDEO_CAFE_CCIC
 	  CMOS camera controller.  This is the controller found on first-
 	  generation OLPC systems.
 
+config VIDEO_OMAP3
+        tristate "OMAP 3 Camera support"
+	select VIDEOBUF_GEN
+	select VIDEOBUF_DMA_SG
+	depends on VIDEO_V4L2 && ARCH_OMAP34XX
+	---help---
+	  Driver for an OMAP 3 camera controller.
+
+source "drivers/media/video/isp/Kconfig"
+
 config VIDEO_OMAP2
 	tristate "OMAP 2 Camera support (EXPERIMENTAL)"
 	select VIDEOBUF_GEN
--- a/drivers/media/video/Makefile	2008-06-29 17:44:21.000000000 -0500
+++ b/drivers/media/video/Makefile	2008-06-29 16:57:48.000000000 -0500
@@ -105,6 +105,8 @@ obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_cc
 obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
 
 obj-$(CONFIG_VIDEO_OMAP2) += omap24xxcam.o omap24xxcam-dma.o
+obj-$(CONFIG_VIDEO_OMAP3) += omap34xxcam.o isp/
+
 obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 obj-$(CONFIG_VIDEO_OV9640)	+= ov9640.o
 
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/omap34xxcam.c	2008-06-29 17:07:06.000000000 -0500
@@ -0,0 +1,1605 @@
+/*
+ * drivers/media/video/omap34xxcam.c
+ *
+ * Video-for-Linux (Version 2) Camera capture driver for OMAP34xx ISP.
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ * 	Sameer Venkatraman <sameerv@ti.com>
+ * 	Mohit Jalori <mjalori@ti.com>
+ * 	Sakari Ailus <sakari.ailus@nokia.com>
+ * 	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/pci.h>		/* needed for videobufs */
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/videodev2.h>
+#include <linux/version.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-common.h>
+
+#include "omap34xxcam.h"
+#include "isp/isp.h"
+#include "isp/ispmmu.h"
+#include "isp/ispreg.h"
+#include "isp/ispccdc.h"
+
+#define OMAP34XXCAM_VERSION KERNEL_VERSION(0, 0, 0)
+
+/* global variables */
+static struct omap34xxcam_device *omap34xxcam;
+
+/* module parameters */
+static int capture_mem = 2592 * 1944 * 2 * 2;
+static int omap34xxcam_device_register(struct v4l2_int_device *s);
+static void omap34xxcam_device_unregister(struct v4l2_int_device *s);
+static int omap34xxcam_remove(struct platform_device *pdev);
+struct omap34xxcam_fh *camfh_saved;
+
+/*
+ *
+ * Sensor handling.
+ *
+ */
+
+/**
+ * omap34xxcam_slave_enable - Enable all slaves on device
+ * @vdev: per-video device data structure
+ *
+ * Power-up and configure camera sensor and sensor interface. On
+ * successful return (0), it's ready for capturing now.
+ */
+static int omap34xxcam_slave_power_set(struct omap34xxcam_videodev *vdev,
+				       enum v4l2_power power)
+{
+	int rval = 0, i = OMAP34XXCAM_SLAVE_FLASH + 1;
+
+	if (power == V4L2_POWER_OFF)
+		goto out;
+
+	for (i = 0; i <= OMAP34XXCAM_SLAVE_FLASH; i++) {
+		if (!vdev->slave[i])
+			continue;
+
+		rval = vidioc_int_s_power(vdev->slave[i], power);
+
+		if (rval) {
+			power = V4L2_POWER_OFF;
+			goto out;
+		}
+	}
+
+	return 0;
+
+out:
+	for (i--; i >= 0; i--) {
+		if (!vdev->slave[i])
+			continue;
+
+		vidioc_int_s_power(vdev->slave[i], power);
+	}
+
+	return rval;
+}
+
+/**
+ * omap34xxcam_update_vbq - Updates VBQ with completed input buffer
+ * @vb: ptr. to standard V4L2 video buffer structure
+ *
+ * Updates video buffer queue with completed buffer passed as
+ * input parameter.  Also updates ISP H3A timestamp and field count
+ * statistics.
+ */
+int omap34xxcam_update_vbq(struct videobuf_buffer *vb)
+{
+	struct omap34xxcam_fh *fh = camfh_saved;
+	struct omap34xxcam_videodev *vdev = fh->vdev;
+	int rval = 0;
+
+	do_gettimeofday(&vb->ts);
+	vb->field_count = atomic_add_return(2, &fh->field_count);
+	vb->state = VIDEOBUF_DONE;
+
+	if (vdev->streaming)
+		rval = 1;
+
+	wake_up(&vb->done);
+
+	return rval;
+}
+
+/**
+ * omap34xxcam_vbq_setup - Calcs size and num of buffs allowed in queue
+ * @vbq: ptr. to standard V4L2 video buffer queue structure
+ * @cnt: ptr to location to hold the count of buffers to be in the queue
+ * @size: ptr to location to hold the size of a frame
+ *
+ * Calculates the number of buffers of current image size that can be
+ * supported by the available capture memory.
+ */
+static int omap34xxcam_vbq_setup(struct videobuf_queue *vbq, unsigned int *cnt,
+				 unsigned int *size)
+{
+	struct omap34xxcam_fh *fh = vbq->priv_data;
+	struct v4l2_format format;
+
+	if (*cnt <= 0)
+		*cnt = VIDEO_MAX_FRAME;	/* supply a default number of buffers */
+
+	if (*cnt > VIDEO_MAX_FRAME)
+		*cnt = VIDEO_MAX_FRAME;
+
+	isp_g_fmt_cap(&format);
+	*size = format.fmt.pix.sizeimage;
+
+	/* accessing fh->cam->capture_mem is ok, it's constant */
+	while (*size * *cnt > fh->vdev->capture_mem)
+		(*cnt)--;
+
+	return 0;
+}
+
+/**
+ * omap34xxcam_vbq_release - Free resources for input VBQ and VB
+ * @vbq: ptr. to standard V4L2 video buffer queue structure
+ * @vb: ptr to standard V4L2 video buffer structure
+ *
+ * Unmap and free all memory associated with input VBQ and VB, also
+ * unmap the address in ISP MMU.  Reset the VB state.
+ */
+static void omap34xxcam_vbq_release(struct videobuf_queue *vbq,
+				    struct videobuf_buffer *vb)
+{
+	if (!vbq->streaming) {
+		isp_vbq_release(vbq, vb);
+		videobuf_dma_unmap(vbq, videobuf_to_dma(vb));
+		videobuf_dma_free(videobuf_to_dma(vb));
+		vb->state = VIDEOBUF_NEEDS_INIT;
+	}
+	return;
+}
+
+/**
+ * omap34xxcam_vbq_prepare - V4L2 video ops buf_prepare handler
+ * @vbq: ptr. to standard V4L2 video buffer queue structure
+ * @vb: ptr to standard V4L2 video buffer structure
+ * @field: standard V4L2 field enum
+ *
+ * Verifies there is sufficient locked memory for the requested
+ * buffer, or if there is not, allocates, locks and initializes
+ * it.
+ */
+static int omap34xxcam_vbq_prepare(struct videobuf_queue *vbq,
+				   struct videobuf_buffer *vb,
+				   enum v4l2_field field)
+{
+	struct v4l2_format format;
+	unsigned int size;
+	int err = 0;
+
+	isp_g_fmt_cap(&format);
+	size = format.fmt.pix.sizeimage;
+	/*
+	 * Accessing pix here is okay since it's constant while
+	 * streaming is on (and we only get called then).
+	 */
+	if (vb->baddr) {
+		/* This is a userspace buffer. */
+		if (size > vb->bsize)
+			/* The buffer isn't big enough. */
+			err = -EINVAL;
+		else {
+			vb->size = size;
+			vb->bsize = vb->size;
+		}
+	} else {
+		if (vb->state != VIDEOBUF_NEEDS_INIT) {
+			/*
+			 * We have a kernel bounce buffer that has
+			 * already been allocated.
+			 */
+			if (size > vb->size) {
+				/*
+				 * The image size has been changed to
+				 * a larger size since this buffer was
+				 * allocated, so we need to free and
+				 * reallocate it.
+				 */
+				omap34xxcam_vbq_release(vbq, vb);
+				vb->size = size;
+			}
+		} else {
+			/* We need to allocate a new kernel bounce buffer. */
+			vb->size = size;
+		}
+	}
+
+	if (err)
+		return err;
+
+	vb->width = format.fmt.pix.width;
+	vb->height = format.fmt.pix.height;
+	vb->field = field;
+
+	if (vb->state == VIDEOBUF_NEEDS_INIT) {
+		err = videobuf_iolock(vbq, vb, NULL);
+		if (!err) {
+			/* isp_addr will be stored locally inside isp code */
+			err = isp_vbq_prepare(vbq, vb, field);
+		}
+	}
+
+	if (!err)
+		vb->state = VIDEOBUF_PREPARED;
+	else
+		omap34xxcam_vbq_release(vbq, vb);
+
+	return err;
+
+}
+
+/**
+ * omap34xxcam_vbq_queue - V4L2 video ops buf_queue handler
+ * @vbq: ptr. to standard V4L2 video buffer queue structure
+ * @vb: ptr to standard V4L2 video buffer structure
+ *
+ * Maps the video buffer to sgdma and through the isp, sets
+ * the isp buffer done callback and sets the video buffer state
+ * to active.
+ */
+static void omap34xxcam_vbq_queue(struct videobuf_queue *vbq,
+				  struct videobuf_buffer *vb)
+{
+	struct omap34xxcam_fh *fh = vbq->priv_data;
+	struct omap34xxcam_videodev *vdev = fh->vdev;
+	enum videobuf_state state = vb->state;
+	isp_vbq_callback_ptr func_ptr;
+	int err = 0;
+
+	camfh_saved = fh;
+
+	func_ptr = omap34xxcam_update_vbq;
+	vb->state = VIDEOBUF_ACTIVE;
+
+	err = isp_sgdma_queue(videobuf_to_dma(vb),
+				vb, 0, &vdev->cam->dma_notify, func_ptr);
+	if (err) {
+		dev_dbg(vdev->cam->dev, "vbq queue failed\n");
+		vb->state = state;
+	}
+
+}
+
+static struct videobuf_queue_ops omap34xxcam_vbq_ops = {
+	.buf_setup = omap34xxcam_vbq_setup,
+	.buf_prepare = omap34xxcam_vbq_prepare,
+	.buf_queue = omap34xxcam_vbq_queue,
+	.buf_release = omap34xxcam_vbq_release,
+};
+
+/*
+ *
+ * IOCTL interface.
+ *
+ */
+
+/**
+ * vidioc_querycap - V4L2 query capabilities IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @cap: ptr to standard V4L2 capability structure
+ *
+ * Fill in the V4L2 capabliity structure for the camera device
+ */
+static int vidioc_querycap(struct file *file, void *fh,
+			   struct v4l2_capability *cap)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+
+	strlcpy(cap->driver, CAM_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, vdev->vfd->name, sizeof(cap->card));
+	cap->version = OMAP34XXCAM_VERSION;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+/**
+ * vidioc_enum_fmt_cap - V4L2 enumerate format capabilities IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @f: ptr to standard V4L2 format description structure
+ *
+ * Fills in enumerate format capabilities information for sensor (if SOC
+ * sensor attached) or ISP (if raw sensor attached).
+ */
+static int vidioc_enum_fmt_cap(struct file *file, void *fh,
+			       struct v4l2_fmtdesc *f)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval;
+
+	if (vdev->vdev_sensor_config.sensor_isp)
+		rval = vidioc_int_enum_fmt_cap(vdev->vdev_sensor, f);
+	else
+		rval = isp_enum_fmt_cap(f);
+
+	return rval;
+}
+
+/**
+ * vidioc_g_fmt_cap - V4L2 get format capabilities IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @f: ptr to standard V4L2 format structure
+ *
+ * Fills in format capabilities for sensor (if SOC sensor attached) or ISP
+ * (if raw sensor attached).
+ */
+static int vidioc_g_fmt_cap(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+
+	mutex_lock(&vdev->mutex);
+	f->fmt.pix = ofh->pix;
+	mutex_unlock(&vdev->mutex);
+
+	return 0;
+}
+
+/**
+ * vidioc_s_fmt_cap - V4L2 set format capabilities IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @f: ptr to standard V4L2 format structure
+ *
+ * Attempts to set input format with the sensor driver (first) and then the
+ * ISP.  Returns the return code from vidioc_g_fmt_cap().
+ */
+static int vidioc_s_fmt_cap(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_pix_format pix_tmp;
+	int rval;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->streaming) {
+		rval = -EBUSY;
+		goto out;
+	}
+
+	pix_tmp.width = f->fmt.pix.width;
+	pix_tmp.height = f->fmt.pix.height;
+	pix_tmp.pixelformat = f->fmt.pix.pixelformat;
+	/* Always negotiate with the sensor first */
+	rval = vidioc_int_s_fmt_cap(vdev->vdev_sensor, f);
+	if (rval)
+		goto out;
+
+	/* Negotiate with OMAP3 ISP */
+	rval = isp_s_fmt_cap(pix, &pix_tmp);
+out:
+	mutex_unlock(&vdev->mutex);
+
+	if (!rval) {
+		mutex_lock(&ofh->vbq.vb_lock);
+		*pix = ofh->pix = pix_tmp;
+		mutex_unlock(&ofh->vbq.vb_lock);
+	}
+
+	return rval;
+}
+
+/**
+ * vidioc_try_fmt_cap - V4L2 try format capabilities IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @f: ptr to standard V4L2 format structure
+ *
+ * Checks if the given format is supported by the sensor driver and
+ * by the ISP.
+ */
+static int vidioc_try_fmt_cap(struct file *file, void *fh,
+			      struct v4l2_format *f)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_pix_format pix_tmp;
+	int rval;
+
+	mutex_lock(&vdev->mutex);
+	pix_tmp.width = f->fmt.pix.width;
+	pix_tmp.height = f->fmt.pix.height;
+	pix_tmp.pixelformat = f->fmt.pix.pixelformat;
+	rval = vidioc_int_try_fmt_cap(vdev->vdev_sensor, f);
+	if (rval)
+		goto out;
+
+	rval = isp_try_fmt_cap(pix, &pix_tmp);
+	*pix = pix_tmp;
+
+out:
+	mutex_unlock(&vdev->mutex);
+	return rval;
+}
+
+/**
+ * vidioc_reqbufs - V4L2 request buffers IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @b: ptr to standard V4L2 request buffers structure
+ *
+ * Attempts to get a buffer from the buffer queue associated with the
+ * fh through the video buffer library API.
+ */
+static int vidioc_reqbufs(struct file *file, void *fh,
+			  struct v4l2_requestbuffers *b)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->streaming) {
+		mutex_unlock(&vdev->mutex);
+		return -EBUSY;
+	}
+
+	mutex_unlock(&vdev->mutex);
+
+	rval = videobuf_reqbufs(&ofh->vbq, b);
+
+	/*
+	 * Either videobuf_reqbufs failed or the buffers are not
+	 * memory-mapped (which would need special attention).
+	 */
+	if (rval < 0 || b->memory != V4L2_MEMORY_MMAP)
+		goto out;
+
+out:
+	return rval;
+}
+
+/**
+ * vidioc_querybuf - V4L2 query buffer IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @b: ptr to standard V4L2 buffer structure
+ *
+ * Attempts to fill in the v4l2_buffer structure for the buffer queue
+ * associated with the fh through the video buffer library API.
+ */
+static int vidioc_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct omap34xxcam_fh *ofh = fh;
+
+	return videobuf_querybuf(&ofh->vbq, b);
+}
+
+/**
+ * vidioc_qbuf - V4L2 queue buffer IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @b: ptr to standard V4L2 buffer structure
+ *
+ * Attempts to queue the v4l2_buffer on the buffer queue
+ * associated with the fh through the video buffer library API.
+ */
+static int vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct omap34xxcam_fh *ofh = fh;
+
+	return videobuf_qbuf(&ofh->vbq, b);
+}
+
+/**
+ * vidioc_dqbuf - V4L2 dequeue buffer IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @b: ptr to standard V4L2 buffer structure
+ *
+ * Attempts to dequeue the v4l2_buffer from the buffer queue
+ * associated with the fh through the video buffer library API.  If the
+ * buffer is a user space buffer, then this function will also requeue it,
+ * as user does not expect to do this.
+ */
+static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct omap34xxcam_fh *ofh = fh;
+
+	return videobuf_dqbuf(&ofh->vbq, b, file->f_flags & O_NONBLOCK);
+}
+
+/**
+ * vidioc_streamon - V4L2 streamon IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @i: V4L2 buffer type
+ *
+ * Attempts to start streaming by enabling the sensor interface and turning
+ * on video buffer streaming through the video buffer library API.  Upon
+ * success the function returns 0, otherwise an error code is returned.
+ */
+static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	struct omap34xxcam_device *cam = vdev->cam;
+	int rval;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->streaming) {
+		rval = -EBUSY;
+		goto out;
+	}
+
+	rval = omap34xxcam_slave_power_set(vdev, V4L2_POWER_RESUME);
+	if (rval) {
+		dev_dbg(vdev->cam->dev, "omap34xxcam_slave_power_set failed\n");
+		goto out;
+	}
+	/* Configure sensor and start streaming */
+	rval = vidioc_int_init(vdev->vdev_sensor);
+	if (rval) {
+		dev_dbg(vdev->cam->dev, "vidioc_int_init failed\n");
+		goto out;
+	}
+
+	cam->dma_notify = 1;
+	isp_sgdma_init();
+	rval = videobuf_streamon(&ofh->vbq);
+	if (!rval)
+		vdev->streaming = file;
+
+out:
+	mutex_unlock(&vdev->mutex);
+
+	return rval;
+}
+
+/**
+ * vidioc_streamoff - V4L2 streamoff IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @i: V4L2 buffer type
+ *
+ * Attempts to stop streaming by flushing all scheduled work, waiting on
+ * any queued buffers to complete and then stopping the ISP and turning
+ * off video buffer streaming through the video buffer library API.  Upon
+ * success the function returns 0, otherwise an error code is returned.
+ */
+static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	struct videobuf_queue *q = &ofh->vbq;
+	int rval;
+
+	isp_stop();
+	rval = videobuf_streamoff(q);
+	if (!rval) {
+		mutex_lock(&vdev->mutex);
+		vdev->streaming = NULL;
+		mutex_unlock(&vdev->mutex);
+	}
+
+	omap34xxcam_slave_power_set(vdev, V4L2_POWER_STANDBY);
+
+	return rval;
+}
+
+/**
+ * vidioc_enum_input - V4L2 enumerate input IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @inp: V4L2 input type information structure
+ *
+ * Fills in v4l2_input structure.  Returns 0.
+ */
+static int vidioc_enum_input(struct file *file, void *fh,
+			     struct v4l2_input *inp)
+{
+	if (inp->index > 0)
+		return -EINVAL;
+
+	strlcpy(inp->name, "camera", sizeof(inp->name));
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+
+	return 0;
+}
+
+/**
+ * vidioc_g_input - V4L2 get input IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @i: address to hold index of input supported
+ *
+ * Sets index to 0.
+ */
+static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
+{
+	*i = 0;
+
+	return 0;
+}
+
+/**
+ * vidioc_s_input - V4L2 set input IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @i: index of input selected
+ *
+ * 0 is only index supported.
+ */
+static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
+{
+	if (i > 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * vidioc_queryctrl - V4L2 query control IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @a: standard V4L2 query control ioctl structure
+ *
+ * If the requested control is supported, returns the control information
+ * in the v4l2_queryctrl structure.  Otherwise, returns -EINVAL if the
+ * control is not supported.  If the sensor being used is a "smart sensor",
+ * this request is passed to the sensor driver, otherwise the ISP is
+ * queried and if it does not support the requested control, the request
+ * is forwarded to the "raw" sensor driver to see if it supports it.
+ */
+static int vidioc_queryctrl(struct file *file, void *fh,
+			    struct v4l2_queryctrl *a)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->vdev_sensor_config.sensor_isp) {
+		rval = vidioc_int_queryctrl(vdev->vdev_sensor, a);
+	} else {
+		rval = isp_queryctrl(a);
+		if (rval) {
+			/* ISP does not support, check sensor */
+			rval = vidioc_int_queryctrl(vdev->vdev_sensor, a);
+		}
+	}
+	mutex_unlock(&vdev->mutex);
+
+	return rval;
+}
+
+/**
+ * vidioc_g_ctrl - V4L2 get control IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @a: standard V4L2 control structure
+ *
+ * If the sensor being used is a "smart sensor",
+ * this request is passed to the sensor driver, otherwise the ISP is
+ * queried and if it does not support the requested control, the request
+ * is forwarded to the "raw" sensor driver to see if it supports it.
+ * If one of these supports the control, the current value of the control
+ * is returned in the v4l2_control structure.  Otherwise, -EINVAL is
+ * returned if the control is not supported.
+ */
+static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *a)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->vdev_sensor_config.sensor_isp) {
+		rval = vidioc_int_g_ctrl(vdev->vdev_sensor, a);
+	} else {
+		rval = isp_g_ctrl(a);
+		/* If control not supported on ISP, try sensor */
+		if (rval)
+			rval = vidioc_int_g_ctrl(vdev->vdev_sensor, a);
+	}
+	mutex_unlock(&vdev->mutex);
+
+	return rval;
+}
+
+/**
+ * vidioc_s_ctrl - V4L2 set control IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @a: standard V4L2 control structure
+ *
+ * If the sensor being used is a "smart sensor", this request is passed to
+ * the sensor driver.  Otherwise, the ISP is queried and if it does not
+ * support the requested control, the request is forwarded to the "raw"
+ * sensor driver to see if it supports it.
+ * If one of these supports the control, the current value of the control
+ * is returned in the v4l2_control structure.  Otherwise, -EINVAL is
+ * returned if the control is not supported.
+ */
+static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->vdev_sensor_config.sensor_isp) {
+		rval = vidioc_int_s_ctrl(vdev->vdev_sensor, a);
+	} else {
+		rval = isp_s_ctrl(a);
+		/* If control not supported on ISP, try sensor */
+		if (rval)
+			rval = vidioc_int_s_ctrl(vdev->vdev_sensor, a);
+	}
+	mutex_unlock(&vdev->mutex);
+
+	return rval;
+}
+
+/**
+ * vidioc_g_parm - V4L2 get parameters IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @a: standard V4L2 stream parameters structure
+ *
+ * If request is for video capture buffer type, handles request by
+ * forwarding to sensor driver.
+ */
+static int vidioc_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	mutex_lock(&vdev->mutex);
+	rval = vidioc_int_g_parm(vdev->vdev_sensor, a);
+	mutex_unlock(&vdev->mutex);
+
+	return rval;
+}
+
+/**
+ * vidioc_s_parm - V4L2 set parameters IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @a: standard V4L2 stream parameters structure
+ *
+ * If request is for video capture buffer type, handles request by
+ * first getting current stream parameters from sensor, then forwarding
+ * request to set new parameters to sensor driver.  It then attempts to
+ * enable the sensor interface with the new parameters.  If this fails, it
+ * reverts back to the previous parameters.
+ */
+static int vidioc_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	struct v4l2_streamparm old_streamparm;
+	int rval;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->streaming) {
+		rval = -EBUSY;
+		goto out;
+	}
+
+	old_streamparm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	rval = vidioc_int_g_parm(vdev->vdev_sensor, &old_streamparm);
+	if (rval)
+		goto out;
+
+	rval = vidioc_int_s_parm(vdev->vdev_sensor, a);
+	if (rval)
+		goto out;
+
+out:
+	mutex_unlock(&vdev->mutex);
+
+	return rval;
+}
+
+/**
+ * vidioc_cropcap - V4L2 crop capture IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @a: standard V4L2 crop capture structure
+ *
+ * If using a "smart" sensor, just forwards request to the sensor driver,
+ * otherwise fills in the v4l2_cropcap values locally.
+ */
+static int vidioc_cropcap(struct file *file, void *fh, struct v4l2_cropcap *a)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	struct v4l2_cropcap *cropcap = a;
+	int rval;
+
+	if (vdev->vdev_sensor_config.sensor_isp) {
+		rval = vidioc_int_cropcap(vdev->vdev_sensor, a);
+	} else {
+		cropcap->bounds.left = cropcap->bounds.top = 0;
+		cropcap->bounds.width = ofh->pix.width;
+		cropcap->bounds.height = ofh->pix.height;
+		cropcap->defrect = cropcap->bounds;
+		cropcap->pixelaspect.numerator = 1;
+		cropcap->pixelaspect.denominator = 1;
+		rval = 0;
+	}
+	return rval;
+}
+
+/**
+ * vidioc_g_crop - V4L2 get capture crop IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @a: standard V4L2 crop structure
+ *
+ * If using a "smart" sensor, just forwards request to the sensor driver,
+ * otherwise calls the isp functions to fill in current crop values.
+ */
+static int vidioc_g_crop(struct file *file, void *fh, struct v4l2_crop *a)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval = 0;
+
+	if (vdev->vdev_sensor_config.sensor_isp)
+		rval = vidioc_int_g_crop(vdev->vdev_sensor, a);
+	else
+		rval = isp_g_crop(a);
+
+	return rval;
+}
+
+/**
+ * vidioc_s_crop - V4L2 set capture crop IOCTL handler
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @a: standard V4L2 crop structure
+ *
+ * If using a "smart" sensor, just forwards request to the sensor driver,
+ * otherwise calls the isp functions to set the current crop values.
+ */
+static int vidioc_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
+{
+	struct omap34xxcam_fh *ofh = fh;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	struct v4l2_pix_format *pix = &ofh->pix;
+	int rval = 0;
+
+	if (vdev->vdev_sensor_config.sensor_isp)
+		rval = vidioc_int_s_crop(vdev->vdev_sensor, a);
+	else
+		rval = isp_s_crop(a, pix);
+
+	return rval;
+}
+
+/*
+ *
+ * File operations.
+ *
+ */
+
+/**
+ * omap34xxcam_poll - file operations poll handler
+ * @file: ptr. to system file structure
+ * @wait: system poll table structure
+ *
+ */
+static unsigned int omap34xxcam_poll(struct file *file,
+				     struct poll_table_struct *wait)
+{
+	struct omap34xxcam_fh *fh = file->private_data;
+	struct omap34xxcam_videodev *vdev = fh->vdev;
+	struct videobuf_buffer *vb;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->streaming != file) {
+		mutex_unlock(&vdev->mutex);
+		return POLLERR;
+	}
+	mutex_unlock(&vdev->mutex);
+
+	mutex_lock(&fh->vbq.vb_lock);
+	if (list_empty(&fh->vbq.stream)) {
+		mutex_unlock(&fh->vbq.vb_lock);
+		return POLLERR;
+	}
+	vb = list_entry(fh->vbq.stream.next, struct videobuf_buffer, stream);
+	mutex_unlock(&fh->vbq.vb_lock);
+
+	poll_wait(file, &vb->done, wait);
+
+	if (vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+/**
+ * omap34xxcam_mmap - file operations mmap handler
+ * @file: ptr. to system file structure
+ * @vma: system virt. mem. area structure
+ *
+ * Maps a virtual memory area via the video buffer API
+ */
+static int omap34xxcam_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct omap34xxcam_fh *fh = file->private_data;
+
+	return videobuf_mmap_mapper(&fh->vbq, vma);
+}
+
+/**
+ * omap34xxcam_open - file operations open handler
+ * @inode: ptr. to system inode structure
+ * @file: ptr. to system file structure
+ *
+ * Allocates and initializes the per-filehandle data (omap34xxcam_fh),
+ * enables the sensor, opens/initializes the ISP interface and the
+ * video buffer queue.  Note that this function will allow multiple
+ * file handles to be open simultaneously, however only the first
+ * handle opened will initialize the ISP.  It is the application
+ * responsibility to only use one handle for streaming and the others
+ * for control only.
+ * This function returns 0 upon success and -ENODEV upon error.
+ */
+static int omap34xxcam_open(struct inode *inode, struct file *file)
+{
+	struct omap34xxcam_videodev *vdev = NULL;
+	struct omap34xxcam_device *cam = omap34xxcam;
+	struct omap34xxcam_fh *fh;
+	struct v4l2_format format;
+	int i;
+
+	for (i = 0; i < OMAP34XXCAM_VIDEODEVS; i++) {
+		if (cam->vdevs[i].vfd
+		    && cam->vdevs[i].vfd->minor == iminor(inode)) {
+			vdev = &cam->vdevs[i];
+			break;
+		}
+	}
+
+	if (!vdev || !vdev->vfd)
+		return -ENODEV;
+
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	if (fh == NULL)
+		return -ENOMEM;
+
+	mutex_lock(&vdev->mutex);
+	for (i = 0; i <= OMAP34XXCAM_SLAVE_FLASH; i++) {
+		if (vdev->slave[i]
+		    && !try_module_get(vdev->slave[i]->module)) {
+			mutex_unlock(&vdev->mutex);
+			goto out_try_module_get;
+		}
+	}
+
+	if (atomic_inc_return(&vdev->users) == 1) {
+		isp_get();
+		isp_open();
+		if (omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON)) {
+			mutex_unlock(&vdev->mutex);
+			goto out_try_module_get;
+		}
+		if (omap34xxcam_slave_power_set(vdev, V4L2_POWER_STANDBY)) {
+			mutex_unlock(&vdev->mutex);
+			goto out_try_module_get;
+		}
+	}
+
+	mutex_unlock(&vdev->mutex);
+	fh->vdev = vdev;
+	mutex_lock(&vdev->mutex);
+
+	/* FIXME: Check that we have sensor now... */
+	if (vdev->vdev_sensor_config.sensor_isp)
+		vidioc_int_g_fmt_cap(vdev->vdev_sensor, &format);
+	else
+		isp_g_fmt_cap(&format);
+
+	mutex_unlock(&vdev->mutex);
+	/* FIXME: how about fh->pix when there are more users? */
+	fh->pix = format.fmt.pix;
+
+	file->private_data = fh;
+
+	spin_lock_init(&fh->vbq_lock);
+
+	videobuf_queue_sg_init(&fh->vbq, &omap34xxcam_vbq_ops, NULL,
+				&fh->vbq_lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				V4L2_FIELD_NONE,
+				sizeof(struct videobuf_buffer), fh);
+
+	return 0;
+
+out_try_module_get:
+	for (i--; i >= 0; i--)
+		if (vdev->slave[i])
+			module_put(vdev->slave[i]->module);
+
+	isp_close();
+	isp_put();
+	kfree(fh);
+
+	return -ENODEV;
+}
+
+/**
+ * omap34xxcam_release - file operations release handler
+ * @inode: ptr. to system inode structure
+ * @file: ptr. to system file structure
+ *
+ * Complement of omap34xxcam_open.  This function will flush any scheduled
+ * work, disable the sensor, close the ISP interface, stop the
+ * video buffer queue from streaming and free the per-filehandle data
+ * (omap34xxcam_fh).  Note that because multiple open file handles
+ * are allowed, this function will only close the ISP and disable the
+ * sensor when the last open file handle (by count) is closed.
+ * This function returns 0.
+ */
+static int omap34xxcam_release(struct inode *inode, struct file *file)
+{
+	struct omap34xxcam_fh *fh = file->private_data;
+	struct omap34xxcam_videodev *vdev = fh->vdev;
+	int i;
+
+	mutex_lock(&vdev->mutex);
+	if (vdev->streaming == file) {
+		isp_stop();
+		videobuf_streamoff(&fh->vbq);
+		omap34xxcam_slave_power_set(vdev, V4L2_POWER_STANDBY);
+		vdev->streaming = NULL;
+	}
+
+	if (atomic_dec_return(&vdev->users) == 0) {
+		omap34xxcam_slave_power_set(vdev, V4L2_POWER_OFF);
+		isp_close();
+		isp_put();
+	}
+	mutex_unlock(&vdev->mutex);
+
+	file->private_data = NULL;
+
+	for (i = 0; i <= OMAP34XXCAM_SLAVE_FLASH; i++)
+		if (vdev->slave[i])
+			module_put(vdev->slave[i]->module);
+
+	kfree(fh);
+
+	return 0;
+}
+
+/**
+ * omap34xxcam_handle_private - private IOCTL handler
+ * @inode: ptr. to system inode structure
+ * @file: ptr. to system file structure
+ * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle data)
+ * @cmd: ioctl cmd value
+ * @arg: ioctl arg value
+ *
+ * If the sensor being used is a "smart sensor", this request is returned to
+ * caller with -EINVAL err code.  Otherwise if the control id is the private
+ * VIDIOC_PRIVATE_ISP_AEWB_REQ to update the analog gain or exposure,
+ * then this request is forwared directly to the sensor to incorporate the
+ * feedback. The request is then passed on to the ISP private IOCTL handler,
+ * isp_handle_private()
+ */
+static int omap34xxcam_handle_private(struct file *file, void *fh,
+							int cmd, void *arg)
+{
+	struct omap34xxcam_fh *ofh = file->private_data;
+	struct omap34xxcam_videodev *vdev = ofh->vdev;
+	int rval;
+
+	mutex_lock(&vdev->mutex);
+
+	if (vdev->vdev_sensor_config.sensor_isp) {
+		rval = -EINVAL;
+	} else {
+		switch (cmd) {
+		default:
+			rval = isp_handle_private(cmd, arg);
+		}
+	}
+
+	mutex_unlock(&vdev->mutex);
+	return rval;
+}
+
+/**
+ * omap34xxcam_unlocked_ioctl - unlocked (unserialized) IOCTL handler
+ * @file: ptr. to system file structure
+ * @cmd: ioctl cmd value
+ * @arg: ioctl arg value
+ *
+ * Unlocked (unserialized) ioctl handler for the camera driver.
+ * Checks if the IOCTL is in the private ioctl range, and if so
+ * calls the local private ioctl handler omap34xxcam_handle_private(),
+ * otherwise it calls the V4L2 provided ioctl handler (video_ioctl2).
+ */
+static long omap34xxcam_unlocked_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	return (long)video_ioctl2(file->f_dentry->d_inode, file, cmd, arg);
+}
+
+static struct file_operations omap34xxcam_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.unlocked_ioctl = omap34xxcam_unlocked_ioctl,
+	.poll = omap34xxcam_poll,
+	.mmap = omap34xxcam_mmap,
+	.open = omap34xxcam_open,
+	.release = omap34xxcam_release,
+};
+
+/**
+ * omap34xxcam_device_unregister - V4L2 detach handler
+ * @s: ptr. to standard V4L2 device information structure
+ *
+ * Detach sensor and unregister and release the video device.
+ */
+static void omap34xxcam_device_unregister(struct v4l2_int_device *s)
+{
+	struct omap34xxcam_videodev *vdev = s->u.slave->master->priv;
+	struct omap34xxcam_hw_config hwc;
+
+	BUG_ON(vidioc_int_g_priv(s, &hwc) < 0);
+
+	if (vdev->slave[hwc.dev_type]) {
+		vdev->slave[hwc.dev_type] = NULL;
+		vdev->slaves--;
+	}
+
+	if (vdev->slaves == 0 && vdev->vfd) {
+		if (vdev->vfd->minor == -1) {
+			/*
+			 * The device was never registered, so release the
+			 * video_device struct directly.
+			 */
+			video_device_release(vdev->vfd);
+		} else {
+			/*
+			 * The unregister function will release the
+			 * video_device struct as well as
+			 * unregistering it.
+			 */
+			video_unregister_device(vdev->vfd);
+		}
+		vdev->vfd = NULL;
+	}
+
+}
+
+/**
+ * omap34xxcam_device_register - V4L2 attach handler
+ * @s: ptr. to standard V4L2 device information structure
+ *
+ * Allocates and initializes the V4L2 video_device structure, initializes
+ * the sensor, and finally registers the device with V4L2 based on the
+ * video_device structure.
+ *
+ * Returns 0 on success, otherwise an appropriate error code on
+ * failure.
+ */
+static int omap34xxcam_device_register(struct v4l2_int_device *s)
+{
+	struct omap34xxcam_videodev *vdev = s->u.slave->master->priv;
+	struct omap34xxcam_device *cam = vdev->cam;
+	struct omap34xxcam_hw_config hwc;
+	struct video_device *vfd;
+	int rval, i;
+
+	/* We need to check rval just once. The place is here. */
+	if (vidioc_int_g_priv(s, &hwc))
+		return -ENODEV;
+
+	dev_info(cam->dev, "vdev index %d, slave index %d\n",
+		 vdev->index, hwc.dev_index);
+
+	if (vdev->index != hwc.dev_index)
+		return -ENODEV;
+
+	if (hwc.dev_type < 0 || hwc.dev_type > OMAP34XXCAM_SLAVE_FLASH)
+		return -EINVAL;
+
+	if (vdev->slave[hwc.dev_type])
+		return -EBUSY;
+
+	mutex_lock(&vdev->mutex);
+	if (atomic_read(&vdev->users)) {
+		dev_info(cam->dev, "we're open (%d), can't register\n",
+			 atomic_read(&vdev->users));
+		mutex_unlock(&vdev->mutex);
+		return -EBUSY;
+	}
+
+	/* Are we the first slave? */
+	if (vdev->slaves == 0) {
+
+		/* initialize the video_device struct */
+		vfd = vdev->vfd = video_device_alloc();
+		if (!vfd) {
+			dev_err(cam->dev,
+				"could not allocate video device struct\n");
+			return -ENOMEM;
+		}
+		vfd->release = video_device_release;
+
+		vfd->dev = cam->dev;
+
+		vfd->type		 = VID_TYPE_CAPTURE;
+		vfd->fops		 = &omap34xxcam_fops;
+		vfd->priv		 = vdev;
+
+		vfd->vidioc_querycap	 = vidioc_querycap;
+		vfd->vidioc_enum_fmt_cap = vidioc_enum_fmt_cap;
+		vfd->vidioc_g_fmt_cap	 = vidioc_g_fmt_cap;
+		vfd->vidioc_s_fmt_cap	 = vidioc_s_fmt_cap;
+		vfd->vidioc_try_fmt_cap	 = vidioc_try_fmt_cap;
+		vfd->vidioc_reqbufs	 = vidioc_reqbufs;
+		vfd->vidioc_querybuf	 = vidioc_querybuf;
+		vfd->vidioc_qbuf	 = vidioc_qbuf;
+		vfd->vidioc_dqbuf	 = vidioc_dqbuf;
+		vfd->vidioc_streamon	 = vidioc_streamon;
+		vfd->vidioc_streamoff	 = vidioc_streamoff;
+		vfd->vidioc_enum_input	 = vidioc_enum_input;
+		vfd->vidioc_g_input	 = vidioc_g_input;
+		vfd->vidioc_s_input	 = vidioc_s_input;
+		vfd->vidioc_queryctrl	 = vidioc_queryctrl;
+		vfd->vidioc_g_ctrl	 = vidioc_g_ctrl;
+		vfd->vidioc_s_ctrl	 = vidioc_s_ctrl;
+		vfd->vidioc_g_parm	 = vidioc_g_parm;
+		vfd->vidioc_s_parm	 = vidioc_s_parm;
+		vfd->vidioc_cropcap	 = vidioc_cropcap;
+		vfd->vidioc_g_crop	 = vidioc_g_crop;
+		vfd->vidioc_s_crop	 = vidioc_s_crop;
+		vfd->vidioc_default	 = omap34xxcam_handle_private;
+
+		if (video_register_device(vfd, VFL_TYPE_GRABBER,
+					  hwc.dev_minor) < 0) {
+			dev_err(cam->dev,
+				"could not register V4L device\n");
+			vfd->minor = -1;
+			rval = -EBUSY;
+			goto err;
+		}
+		dev_info(cam->dev,
+			 "registered device video%d\n", vfd->minor);
+	} else {
+		vfd = vdev->vfd;
+	}
+
+	vdev->slaves++;
+	vdev->slave[hwc.dev_type] = s;
+	vdev->slave_config[hwc.dev_type] = hwc;
+	dev_info(cam->dev, "registering device %s (%d) to video%d\n",
+		 s->name, hwc.dev_type, vfd->minor);
+
+	isp_get();
+	rval = omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON);
+	omap34xxcam_slave_power_set(vdev, V4L2_POWER_OFF);
+	isp_put();
+
+	if (rval)
+		goto err;
+	strlcpy(vfd->name, CAM_NAME, sizeof(vfd->name));
+	for (i = 0; i <= OMAP34XXCAM_SLAVE_FLASH; i++) {
+		strlcat(vfd->name, "/", sizeof(vfd->name));
+		if (!vdev->slave[i])
+			continue;
+		strlcat(vfd->name, vdev->slave[i]->name, sizeof(vfd->name));
+	}
+
+	mutex_unlock(&vdev->mutex);
+
+	dev_info(cam->dev, "video%d is now %s\n", vfd->minor, vfd->name);
+	return 0;
+
+err:
+	if (s == vdev->slave[hwc.dev_type]) {
+		vdev->slave[hwc.dev_type] = NULL;
+		vdev->slaves--;
+	}
+
+	mutex_unlock(&vdev->mutex);
+	omap34xxcam_device_unregister(s);
+
+	return rval;
+}
+
+static struct v4l2_int_master omap34xxcam_master = {
+	.attach = omap34xxcam_device_register,
+	.detach = omap34xxcam_device_unregister,
+};
+
+/*
+ *
+ * Driver Suspend/Resume
+ *
+ */
+
+#ifdef CONFIG_PM
+/**
+ * omap34xxcam_suspend - platform driver PM suspend handler
+ * @pdev: ptr. to platform level device information structure
+ * @state: power state
+ *
+ * If applicable, stop capture and disable sensor.
+ *
+ * Returns 0 always
+ */
+static int omap34xxcam_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct omap34xxcam_videodev *vdev = platform_get_drvdata(pdev);
+
+	if (atomic_read(&vdev->users) == 0)
+		return 0;
+
+	if (vdev->streaming) {
+		isp_stop();
+		omap34xxcam_slave_power_set(vdev, V4L2_POWER_OFF);
+	}
+
+	return 0;
+}
+
+/**
+ * omap34xxcam_resume - platform driver PM resume handler
+ * @pdev: ptr. to platform level device information structure
+ *
+ * If applicable, resume capture and enable sensor.
+ *
+ * Returns 0 always
+ */
+static int omap34xxcam_resume(struct platform_device *pdev)
+{
+	struct omap34xxcam_videodev *vdev = platform_get_drvdata(pdev);
+
+	if (atomic_read(&vdev->users) == 0)
+		return 0;
+
+	if (vdev->streaming) {
+		omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON);
+		isp_start();
+	}
+
+	return 0;
+}
+#endif
+
+/*
+ *
+ * Driver initialisation and deinitialisation.
+ *
+ */
+
+/**
+ * omap34xxcam_probe - platform driver probe handler
+ * @pdev: ptr. to platform level device information structure
+ *
+ * Allocates and initializes camera device information structure
+ * (omap34xxcam_device), maps the device registers and gets the
+ * device IRQ.  Registers the device as a V4L2 client.
+ *
+ * Returns 0 on success or -ENODEV on failure.
+ */
+static int omap34xxcam_probe(struct platform_device *pdev)
+{
+	struct omap34xxcam_device *cam;
+	struct resource *mem;
+	struct isp_sysc isp_sysconfig;
+	int irq;
+	int i;
+
+	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
+	if (!cam) {
+		dev_err(&pdev->dev, "could not allocate memory\n");
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, cam);
+
+	cam->dev = &pdev->dev;
+	/*
+	 * Impose a lower limit on the amount of memory allocated for
+	 * capture. We require at least enough memory to double-buffer
+	 * QVGA (300KB).
+	 */
+	if (capture_mem < 320 * 240 * 2 * 2)
+		capture_mem = 320 * 240 * 2 * 2;
+
+	/* request the mem region for the camera registers */
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(cam->dev, "no mem resource?\n");
+		goto err;
+	}
+
+	if (!request_mem_region(mem->start, (mem->end - mem->start) + 1,
+				pdev->name)) {
+		dev_err(cam->dev,
+			"cannot reserve camera register I/O region\n");
+		goto err;
+
+	}
+	cam->mmio_base_phys = mem->start;
+	cam->mmio_size = (mem->end - mem->start) + 1;
+
+	/* map the region */
+	cam->mmio_base = (unsigned long)
+			ioremap_nocache(cam->mmio_base_phys, cam->mmio_size);
+	if (!cam->mmio_base) {
+		dev_err(cam->dev, "cannot map camera register I/O region\n");
+		goto err;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_err(cam->dev, "no irq for camera?\n");
+		goto err;
+	}
+
+	isp_get();
+	isp_sysconfig.reset = 0;
+	isp_sysconfig.idle_mode = 1;
+	isp_power_settings(isp_sysconfig);
+
+	for (i = 0; i < OMAP34XXCAM_VIDEODEVS; i++) {
+		struct omap34xxcam_videodev *vdev = &cam->vdevs[i];
+		struct v4l2_int_device *m = &vdev->master;
+
+		m->module       = THIS_MODULE;
+		strlcpy(m->name, CAM_NAME, sizeof(m->name));
+		m->type         = v4l2_int_type_master;
+		m->u.master     = &omap34xxcam_master;
+		m->priv		= vdev;
+
+		if (v4l2_int_device_register(m))
+			goto err;
+
+		mutex_init(&vdev->mutex);
+		vdev->index             = i;
+		vdev->cam               = cam;
+		vdev->capture_mem       = capture_mem;
+	}
+
+	omap34xxcam = cam;
+	isp_put();
+
+	return 0;
+
+err:
+	omap34xxcam_remove(pdev);
+	isp_put();
+	return -ENODEV;
+}
+
+/**
+ * omap34xxcam_remove - platform driver remove handler
+ * @pdev: ptr. to platform level device information structure
+ *
+ * Unregister device with V4L2, unmap camera registers, and
+ * free camera device information structure (omap34xxcam_device).
+ *
+ * Returns 0 always.
+ */
+static int omap34xxcam_remove(struct platform_device *pdev)
+{
+	struct omap34xxcam_device *cam = platform_get_drvdata(pdev);
+	int i;
+
+	if (!cam)
+		return 0;
+
+	omap34xxcam = NULL;
+
+	isp_put();
+
+	for (i = 0; i < OMAP34XXCAM_VIDEODEVS; i++) {
+		if (cam->vdevs[i].cam == NULL)
+			continue;
+
+		v4l2_int_device_unregister(&cam->vdevs[i].master);
+		cam->vdevs[i].cam = NULL;
+	}
+
+	if (cam->mmio_base) {
+		iounmap((void *)cam->mmio_base);
+		cam->mmio_base = 0;
+	}
+
+	if (cam->mmio_base_phys) {
+		release_mem_region(cam->mmio_base_phys, cam->mmio_size);
+		cam->mmio_base_phys = 0;
+	}
+
+	kfree(cam);
+
+	return 0;
+}
+
+static struct platform_driver omap34xxcam_driver = {
+	.probe = omap34xxcam_probe,
+	.remove = omap34xxcam_remove,
+#ifdef CONFIG_PM
+	.suspend = omap34xxcam_suspend,
+	.resume = omap34xxcam_resume,
+#endif
+	.driver = {
+		   .name = CAM_NAME,
+		   },
+};
+
+/*
+ *
+ * Module initialisation and deinitialisation
+ *
+ */
+
+/**
+ * omap34xxcam_init - module_init function
+ *
+ * Calls platfrom driver to register probe, remove,
+ * suspend and resume functions.
+ *
+ */
+static int __init omap34xxcam_init(void)
+{
+	return platform_driver_register(&omap34xxcam_driver);
+}
+
+/**
+ * omap34xxcam_cleanup - module_exit function
+ *
+ * Calls platfrom driver to unregister probe, remove,
+ * suspend and resume functions.
+ *
+ */
+static void __exit omap34xxcam_cleanup(void)
+{
+	platform_driver_unregister(&omap34xxcam_driver);
+}
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("OMAP34xx Video for Linux camera driver");
+MODULE_LICENSE("GPL");
+
+late_initcall(omap34xxcam_init);
+module_exit(omap34xxcam_cleanup);
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/omap34xxcam.h	2008-06-29 16:57:48.000000000 -0500
@@ -0,0 +1,189 @@
+/*
+ * drivers/media/video/omap34xxcam.h
+ *
+ * Video-for-Linux (Version 2) Camera capture driver for OMAP34xx ISP.
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ * 	Sameer Venkatraman <sameerv@ti.com>
+ * 	Mohit Jalori <mjalori@ti.com>
+ * 	Sakari Ailus <sakari.ailus@nokia.com>
+ * 	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#ifndef OMAP34XXCAM_H
+#define OMAP34XXCAM_H
+
+#include <media/v4l2-int-device.h>
+#include "isp/isp.h"
+
+#define CAM_NAME "omap34xxcam"
+
+#define OMAP_ISP_AF     	(1 << 4)
+#define OMAP_ISP_HIST   	(1 << 5)
+#define OMAP34XXCAM_XCLK_NONE	-1
+#define OMAP34XXCAM_XCLK_A	0
+#define OMAP34XXCAM_XCLK_B	1
+
+#define OMAP34XXCAM_SLAVE_SENSOR	0
+#define OMAP34XXCAM_SLAVE_LENS		1
+#define OMAP34XXCAM_SLAVE_FLASH		2 /* This is the last slave! */
+
+#define OMAP34XXCAM_VIDEODEVS		4
+
+struct omap34xxcam_device;
+struct omap34xxcam_videodev;
+
+struct omap34xxcam_sensor_config {
+	int xclk;
+	int sensor_isp;
+};
+
+struct omap34xxcam_lens_config {
+};
+
+struct omap34xxcam_flash_config {
+};
+
+/**
+ * struct omap34xxcam_hw_config - struct for vidioc_int_g_priv ioctl
+ * @xclk: OMAP34XXCAM_XCLK_A or OMAP34XXCAM_XCLK_B
+ * @sensor_isp: Is sensor smart/SOC or raw
+ * @s_pix_sparm: Access function to set pix and sparm.
+ * Pix will override sparm
+ */
+struct omap34xxcam_hw_config {
+	int dev_index; /* Index in omap34xxcam_sensors */
+	int dev_minor; /* Video device minor number */
+	int dev_type; /* OMAP34XXCAM_SLAVE_* */
+	union {
+		struct omap34xxcam_sensor_config sensor;
+		struct omap34xxcam_lens_config lens;
+		struct omap34xxcam_flash_config flash;
+	} u;
+};
+
+/**
+ * struct omap34xxcam_videodev - per /dev/video* structure
+ * @mutex: serialises access to this structure
+ * @cam: pointer to cam hw structure
+ * @master: we are v4l2_int_device master
+ * @sensor: sensor device
+ * @lens: lens device
+ * @flash: flash device
+ * @slaves: how many slaves we have at the moment
+ * @vfd: our video device
+ * @capture_mem: maximum kernel-allocated capture memory
+ * @if_u: sensor interface stuff
+ * @index: index of this structure in cam->vdevs
+ * @users: how many users we have
+ * @sensor_config: ISP-speicific sensor configuration
+ * @lens_config: ISP-speicific lens configuration
+ * @flash_config: ISP-speicific flash configuration
+ * @streaming: streaming file handle, if streaming is enabled
+ */
+struct omap34xxcam_videodev {
+	struct mutex mutex;
+
+	struct omap34xxcam_device *cam;
+	struct v4l2_int_device master;
+
+#define vdev_sensor slave[OMAP34XXCAM_SLAVE_SENSOR]
+#define vdev_lens slave[OMAP34XXCAM_SLAVE_LENS]
+#define vdev_flash slave[OMAP34XXCAM_SLAVE_FLASH]
+	struct v4l2_int_device *slave[OMAP34XXCAM_SLAVE_FLASH + 1];
+
+	/* number of slaves attached */
+	int slaves;
+
+	/*** video device parameters ***/
+	struct video_device *vfd;
+	int capture_mem;
+
+	/*** general driver state information ***/
+	/*
+	 * Sensor interface parameters: interface type, CC_CTRL
+	 * register value and interface specific data.
+	 */
+	u32 xclk;
+	/* index to omap34xxcam_videodevs of this structure */
+	int index;
+	atomic_t users;
+
+#define vdev_sensor_config slave_config[OMAP34XXCAM_SLAVE_SENSOR].u.sensor
+#define vdev_lens_config slave_config[OMAP34XXCAM_SLAVE_LENS].u.lens
+#define vdev_flash_config slave_config[OMAP34XXCAM_SLAVE_FLASH].u.flash
+	struct omap34xxcam_hw_config slave_config[OMAP34XXCAM_SLAVE_FLASH + 1];
+
+	/*** capture data ***/
+	/* file handle, if streaming is on */
+	struct file *streaming;
+};
+
+/**
+ * struct omap34xxcam_device - per-device data structure
+ * @mutex: mutex serialises access to this structure
+ * @sgdma_in_queue: Number or sgdma requests in scatter-gather queue,
+ * protected by the lock above.
+ * @sgdma: ISP sgdma subsystem information structure
+ * @dma_notify: DMA notify flag
+ * @irq: irq number platform HW resource
+ * @mmio_base: register map memory base (platform HW resource)
+ * @mmio_base_phys: register map memory base physical address
+ * @mmio_size: register map memory size
+ * @dev: device structure
+ * @vdevs: /dev/video specific structures
+ * @fck: camera module fck clock information
+ * @ick: camera module ick clock information
+ */
+struct omap34xxcam_device {
+	struct mutex mutex;
+	int sgdma_in_queue;
+	struct isp_sgdma sgdma;
+	int dma_notify;
+
+	/*** platform HW resource ***/
+	unsigned int irq;
+	unsigned long mmio_base;
+	unsigned long mmio_base_phys;
+	unsigned long mmio_size;
+
+	/*** interfaces and device ***/
+	struct device *dev;
+	struct omap34xxcam_videodev vdevs[OMAP34XXCAM_VIDEODEVS];
+
+	/*** camera module clocks ***/
+	struct clk *fck;
+	struct clk *ick;
+	bool sensor_if_enabled;
+};
+
+/**
+ * struct omap34xxcam_fh - per-filehandle data structure
+ * @vbq_lock: spinlock for the videobuf queue
+ * @vbq: V4L2 video buffer queue structure
+ * @pix: V4L2 pixel format structure (serialise pix by vbq->lock)
+ * @field_count: field counter for videobuf_buffer
+ * @vdev: our /dev/video specific structure
+ */
+struct omap34xxcam_fh {
+	spinlock_t vbq_lock;
+	struct videobuf_queue vbq;
+	struct v4l2_pix_format pix;
+	atomic_t field_count;
+	/* accessing cam here doesn't need serialisation: it's constant */
+	struct omap34xxcam_videodev *vdev;
+};
+
+#endif /* ifndef OMAP34XXCAM_H */
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/Makefile	2008-06-29 17:44:40.000000000 -0500
@@ -0,0 +1,4 @@
+# Makefile for OMAP3 ISP driver
+
+obj-$(CONFIG_VIDEO_OMAP3) += \
+	isp.o ispccdc.o ispmmu.o \
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/Kconfig	2008-06-29 17:07:00.000000000 -0500
@@ -0,0 +1 @@
+# Kconfig for OMAP3 ISP driver
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/isp.c	2008-06-29 17:44:57.000000000 -0500
@@ -0,0 +1,1802 @@
+/*
+ * drivers/media/video/isp/isp.c
+ *
+ * Driver Library for ISP Control module in TI's OMAP3430 Camera ISP
+ * ISP interface and IRQ related APIs are defined here.
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ * 	Sameer Venkatraman <sameerv@ti.com>
+ * 	Mohit Jalori <mjalori@ti.com>
+ * 	Sakari Ailus <sakari.ailus@nokia.com>
+ * 	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *	Toni Leinonen <toni.leinonen@nokia.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <asm/irq.h>
+#include <linux/bitops.h>
+#include <linux/scatterlist.h>
+#include <asm/mach-types.h>
+#include <asm/arch/clock.h>
+#include <asm/arch/io.h>
+#include <linux/device.h>
+#include <linux/videodev2.h>
+
+#include "isp.h"
+#include "ispmmu.h"
+#include "ispreg.h"
+#include "ispccdc.h"
+
+/* List of image formats supported via OMAP ISP */
+const static struct v4l2_fmtdesc isp_formats[] = {
+	{
+		.description = "UYVY, packed",
+		.pixelformat = V4L2_PIX_FMT_UYVY,
+	},
+	{
+		.description = "YUYV (YUV 4:2:2), packed",
+		.pixelformat = V4L2_PIX_FMT_YUYV,
+	},
+	{
+		.description = "Bayer10 (GrR/BGb)",
+		.pixelformat = V4L2_PIX_FMT_SGRBG10,
+	},
+};
+
+/* ISP Crop capabilities */
+static struct v4l2_rect ispcroprect;
+static struct v4l2_rect cur_rect;
+
+/**
+ * struct vcontrol - Video control structure.
+ * @qc: V4L2 Query control structure.
+ * @current_value: Current value of the control.
+ */
+static struct vcontrol {
+	struct v4l2_queryctrl qc;
+	int current_value;
+} video_control[] = { };
+
+/**
+ * struct ispirq - Structure for containing callbacks to be called in ISP ISR.
+ * @isp_callbk: Array which stores callback functions, indexed by the type of
+ *              callback (8 possible types).
+ * @isp_callbk_arg1: Pointer to array containing pointers to the first argument
+ *                   to be passed to the requested callback function.
+ * @isp_callbk_arg2: Pointer to array containing pointers to the second
+ *                   argument to be passed to the requested callback function.
+ *
+ * This structure is used to contain all the callback functions related for
+ * each callback type (CBK_CCDC_VD0, CBK_CCDC_VD1, CBK_PREV_DONE,
+ * CBK_RESZ_DONE, CBK_MMU_ERR, CBK_H3A_AWB_DONE, CBK_HIST_DONE, CBK_HS_VS,
+ * CBK_LSC_ISR).
+ */
+static struct ispirq {
+	isp_callback_t isp_callbk[9];
+	isp_vbq_callback_ptr isp_callbk_arg1[9];
+	void *isp_callbk_arg2[9];
+} ispirq_obj;
+
+/**
+ * struct isp - Structure for storing ISP Control module information
+ * @lock: Spinlock to sync between isr and processes.
+ * @isp_temp_buf_lock: Temporary spinlock for buffer control.
+ * @isp_mutex: Semaphore used to get access to the ISP.
+ * @if_status: Type of interface used in ISP.
+ * @interfacetype: (Not used).
+ * @ref_count: Reference counter.
+ * @cam_ick: Pointer to ISP Interface clock.
+ * @cam_fck: Pointer to ISP Functional clock.
+ *
+ * This structure is used to store the OMAP ISP Control Information.
+ */
+static struct isp {
+	spinlock_t lock;
+	spinlock_t isp_temp_buf_lock;
+	struct mutex isp_mutex;
+	u8 if_status;
+	u8 interfacetype;
+	int ref_count;
+	struct clk *cam_ick;
+	struct clk *cam_mclk;
+} isp_obj;
+
+struct isp_sgdma ispsg;
+
+/**
+ * struct ispmodule - Structure for storing ISP sub-module information.
+ * @isp_pipeline: Bit mask for submodules enabled within the ISP.
+ * @isp_temp_state: State of current buffers.
+ * @applyCrop: Flag to do a crop operation when video buffer queue ISR is done
+ * @pix: Structure containing the format and layout of the output image.
+ * @ccdc_input_width: ISP CCDC module input image width.
+ * @ccdc_input_height: ISP CCDC module input image height.
+ * @ccdc_output_width: ISP CCDC module output image width.
+ * @ccdc_output_height: ISP CCDC module output image height.
+ * @preview_input_width: ISP Preview module input image width.
+ * @preview_input_height: ISP Preview module input image height.
+ * @preview_output_width: ISP Preview module output image width.
+ * @preview_output_height: ISP Preview module output image height.
+ * @resizer_input_width: ISP Resizer module input image width.
+ * @resizer_input_height: ISP Resizer module input image height.
+ * @resizer_output_width: ISP Resizer module output image width.
+ * @resizer_output_height: ISP Resizer module output image height.
+ */
+struct ispmodule {
+	unsigned int isp_pipeline;
+	int isp_temp_state;
+	int applyCrop;
+	struct v4l2_pix_format pix;
+	unsigned int ccdc_input_width;
+	unsigned int ccdc_input_height;
+	unsigned int ccdc_output_width;
+	unsigned int ccdc_output_height;
+	unsigned int preview_input_width;
+	unsigned int preview_input_height;
+	unsigned int preview_output_width;
+	unsigned int preview_output_height;
+	unsigned int resizer_input_width;
+	unsigned int resizer_input_height;
+	unsigned int resizer_output_width;
+	unsigned int resizer_output_height;
+};
+
+static struct ispmodule ispmodule_obj = {
+	.isp_pipeline = OMAP_ISP_CCDC,
+	.isp_temp_state = ISP_BUF_INIT,
+	.applyCrop = 0,
+	.pix = {
+		.width = ISP_OUTPUT_WIDTH_DEFAULT,
+		.height = ISP_OUTPUT_HEIGHT_DEFAULT,
+		.pixelformat = V4L2_PIX_FMT_UYVY,
+		.field = V4L2_FIELD_NONE,
+		.bytesperline = ISP_OUTPUT_WIDTH_DEFAULT * ISP_BYTES_PER_PIXEL,
+		.colorspace = V4L2_COLORSPACE_JPEG,
+		.priv = 0,
+	},
+};
+
+/* Structure for saving/restoring ISP module registers */
+static struct isp_reg isp_reg_list[] = {
+	{ISP_SYSCONFIG, 0},
+	{ISP_IRQ0ENABLE, 0},
+	{ISP_IRQ1ENABLE, 0},
+	{ISP_TCTRL_GRESET_LENGTH, 0},
+	{ISP_TCTRL_PSTRB_REPLAY, 0},
+	{ISP_CTRL, 0},
+	{ISP_TCTRL_CTRL, 0},
+	{ISP_TCTRL_FRAME, 0},
+	{ISP_TCTRL_PSTRB_DELAY, 0},
+	{ISP_TCTRL_STRB_DELAY, 0},
+	{ISP_TCTRL_SHUT_DELAY, 0},
+	{ISP_TCTRL_PSTRB_LENGTH, 0},
+	{ISP_TCTRL_STRB_LENGTH, 0},
+	{ISP_TCTRL_SHUT_LENGTH, 0},
+	{ISP_CBUFF_SYSCONFIG, 0},
+	{ISP_CBUFF_IRQENABLE, 0},
+	{ISP_CBUFF0_CTRL, 0},
+	{ISP_CBUFF1_CTRL, 0},
+	{ISP_CBUFF0_START, 0},
+	{ISP_CBUFF1_START, 0},
+	{ISP_CBUFF0_END, 0},
+	{ISP_CBUFF1_END, 0},
+	{ISP_CBUFF0_WINDOWSIZE, 0},
+	{ISP_CBUFF1_WINDOWSIZE, 0},
+	{ISP_CBUFF0_THRESHOLD, 0},
+	{ISP_CBUFF1_THRESHOLD, 0},
+	{ISP_TOK_TERM, 0}
+};
+
+/*
+ *
+ * V4L2 Handling
+ *
+ */
+
+/**
+ * find_vctrl - Returns the index of the ctrl array of the requested ctrl ID.
+ * @id: Requested control ID.
+ *
+ * Returns 0 if successful, -EINVAL if not found, or -EDOM if its out of
+ * domain.
+ **/
+static int find_vctrl(int id)
+{
+	int i;
+
+	if (id < V4L2_CID_BASE)
+		return -EDOM;
+
+	for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--)
+		if (video_control[i].qc.id == id)
+			break;
+
+	if (i < 0)
+		i = -EINVAL;
+
+	return i;
+}
+
+/**
+ * isp_open - Reserve ISP submodules for operation
+ **/
+void isp_open(void)
+{
+	ispccdc_request();
+	return;
+}
+EXPORT_SYMBOL(isp_open);
+
+/**
+ * isp_close - Free ISP submodules
+ **/
+void isp_close(void)
+{
+	ispccdc_free();
+	return;
+}
+EXPORT_SYMBOL(isp_close);
+
+/* Flag to check first time of isp_get */
+static int off_mode;
+
+/**
+ * isp_set_sgdma_callback - Set Scatter-Gather DMA Callback.
+ * @sgdma_state: Pointer to structure with the SGDMA state for each videobuffer
+ * @func_ptr: Callback function pointer for SG-DMA management
+ **/
+static int isp_set_sgdma_callback(struct isp_sgdma_state *sgdma_state,
+						isp_vbq_callback_ptr func_ptr)
+{
+	if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+		isp_set_callback(CBK_CCDC_VD0, sgdma_state->callback, func_ptr,
+							sgdma_state->arg);
+		isp_set_callback(CBK_CCDC_VD1, sgdma_state->callback, func_ptr,
+							sgdma_state->arg);
+		isp_set_callback(CBK_LSC_ISR, NULL, NULL, NULL);
+	}
+
+	isp_set_callback(CBK_HS_VS, sgdma_state->callback, func_ptr,
+							sgdma_state->arg);
+	return 0;
+}
+
+/**
+ * isp_set_callback - Sets the callback for the ISP module done events.
+ * @type: Type of the event for which callback is requested.
+ * @callback: Method to be called as callback in the ISR context.
+ * @arg1: First argument to be passed when callback is called in ISR.
+ * @arg2: Second argument to be passed when callback is called in ISR.
+ *
+ * This function sets a callback function for a done event in the ISP
+ * module, and enables the corresponding interrupt.
+ **/
+int isp_set_callback(enum isp_callback_type type, isp_callback_t callback,
+						isp_vbq_callback_ptr arg1,
+						void *arg2)
+{
+	unsigned long irqflags = 0;
+
+	if (callback == NULL) {
+		DPRINTK_ISPCTRL("ISP_ERR : Null Callback\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&isp_obj.lock, irqflags);
+	ispirq_obj.isp_callbk[type] = callback;
+	ispirq_obj.isp_callbk_arg1[type] = arg1;
+	ispirq_obj.isp_callbk_arg2[type] = arg2;
+	spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+	switch (type) {
+	case CBK_HS_VS:
+		omap_writel(IRQ0ENABLE_HS_VS_IRQ, ISP_IRQ0STATUS);
+		omap_writel(omap_readl(ISP_IRQ0ENABLE) | IRQ0ENABLE_HS_VS_IRQ,
+							ISP_IRQ0ENABLE);
+		break;
+	case CBK_MMU_ERR:
+		omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+					IRQ0ENABLE_MMU_ERR_IRQ,
+					ISP_IRQ0ENABLE);
+
+		omap_writel(omap_readl(ISPMMU_IRQENABLE) |
+					IRQENABLE_MULTIHITFAULT |
+					IRQENABLE_TWFAULT |
+					IRQENABLE_EMUMISS |
+					IRQENABLE_TRANSLNFAULT |
+					IRQENABLE_TLBMISS,
+					ISPMMU_IRQENABLE);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(isp_set_callback);
+
+/**
+ * isp_unset_callback - Clears the callback for the ISP module done events.
+ * @type: Type of the event for which callback to be cleared.
+ *
+ * This function clears a callback function for a done event in the ISP
+ * module, and disables the corresponding interrupt.
+ **/
+int isp_unset_callback(enum isp_callback_type type)
+{
+	unsigned long irqflags = 0;
+
+	spin_lock_irqsave(&isp_obj.lock, irqflags);
+	ispirq_obj.isp_callbk[type] = NULL;
+	ispirq_obj.isp_callbk_arg1[type] = NULL;
+	ispirq_obj.isp_callbk_arg2[type] = NULL;
+	spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+	switch (type) {
+	case CBK_CCDC_VD0:
+		omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+						~IRQ0ENABLE_CCDC_VD0_IRQ,
+						ISP_IRQ0ENABLE);
+		break;
+	case CBK_CCDC_VD1:
+		omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+						~IRQ0ENABLE_CCDC_VD1_IRQ,
+						ISP_IRQ0ENABLE);
+		break;
+	case CBK_MMU_ERR:
+		omap_writel(omap_readl(ISPMMU_IRQENABLE) &
+						~(IRQENABLE_MULTIHITFAULT |
+						IRQENABLE_TWFAULT |
+						IRQENABLE_EMUMISS |
+						IRQENABLE_TRANSLNFAULT |
+						IRQENABLE_TLBMISS),
+						ISPMMU_IRQENABLE);
+		break;
+	case CBK_HS_VS:
+		omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+						~IRQ0ENABLE_HS_VS_IRQ,
+						ISP_IRQ0ENABLE);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(isp_unset_callback);
+
+/**
+ * isp_request_interface - Requests an ISP interface type (parallel or serial).
+ * @if_t: Type of requested ISP interface (parallel or serial).
+ *
+ * This function requests for allocation of an ISP interface type.
+ **/
+int isp_request_interface(enum isp_interface_type if_t)
+{
+	if (isp_obj.if_status & if_t) {
+		DPRINTK_ISPCTRL("ISP_ERR : Requested Interface already \
+			allocated\n");
+		goto err_ebusy;
+	}
+	if ((isp_obj.if_status == (ISP_PARLL | ISP_CSIA))
+			|| isp_obj.if_status == (ISP_CSIA | ISP_CSIB)) {
+		DPRINTK_ISPCTRL("ISP_ERR : No Free interface now\n");
+		goto err_ebusy;
+	}
+
+	if (((isp_obj.if_status == ISP_PARLL) && (if_t == ISP_CSIA)) ||
+				((isp_obj.if_status == ISP_CSIA) &&
+				(if_t == ISP_PARLL)) ||
+				((isp_obj.if_status == ISP_CSIA) &&
+				(if_t == ISP_CSIB)) ||
+				((isp_obj.if_status == ISP_CSIB) &&
+				(if_t == ISP_CSIA)) ||
+				(isp_obj.if_status == 0)) {
+		isp_obj.if_status |= if_t;
+		return 0;
+	} else {
+		DPRINTK_ISPCTRL("ISP_ERR : Invalid Combination Serial- \
+			Parallel interface\n");
+		return -EINVAL;
+	}
+
+err_ebusy:
+	return -EBUSY;
+}
+EXPORT_SYMBOL(isp_request_interface);
+
+/**
+ * isp_free_interface - Frees an ISP interface type (parallel or serial).
+ * @if_t: Type of ISP interface to be freed (parallel or serial).
+ *
+ * This function frees the allocation of an ISP interface type.
+ **/
+int isp_free_interface(enum isp_interface_type if_t)
+{
+	isp_obj.if_status &= ~if_t;
+	return 0;
+}
+EXPORT_SYMBOL(isp_free_interface);
+
+/**
+ * isp_set_xclk - Configures the specified cam_xclk to the desired frequency.
+ * @xclk: Desired frequency of the clock in Hz.
+ * @xclksel: XCLK to configure (0 = A, 1 = B).
+ *
+ * Configures the specified MCLK divisor in the ISP timing control register
+ * (TCTRL_CTRL) to generate the desired xclk clock value.
+ *
+ * Divisor = CM_CAM_MCLK_HZ / xclk
+ *
+ * Returns the final frequency that is actually being generated
+ **/
+u32 isp_set_xclk(u32 xclk, u8 xclksel)
+{
+	u32 divisor;
+	u32 currentxclk;
+
+	if (xclk >= CM_CAM_MCLK_HZ) {
+		divisor = ISPTCTRL_CTRL_DIV_BYPASS;
+		currentxclk = CM_CAM_MCLK_HZ;
+	} else if (xclk >= 2) {
+		divisor = CM_CAM_MCLK_HZ / xclk;
+		if (divisor >= ISPTCTRL_CTRL_DIV_BYPASS)
+			divisor = ISPTCTRL_CTRL_DIV_BYPASS - 1;
+		currentxclk = CM_CAM_MCLK_HZ / divisor;
+	} else {
+		divisor = xclk;
+		currentxclk = 0;
+	}
+
+	switch (xclksel) {
+	case 0:
+		omap_writel((omap_readl(ISP_TCTRL_CTRL) &
+				~ISPTCTRL_CTRL_DIVA_MASK) |
+				(divisor << ISPTCTRL_CTRL_DIVA_SHIFT),
+				ISP_TCTRL_CTRL);
+		DPRINTK_ISPCTRL("isp_set_xclk(): cam_xclka set to %d Hz\n",
+								currentxclk);
+		break;
+	case 1:
+		omap_writel((omap_readl(ISP_TCTRL_CTRL) &
+				~ISPTCTRL_CTRL_DIVB_MASK) |
+				(divisor << ISPTCTRL_CTRL_DIVB_SHIFT),
+				ISP_TCTRL_CTRL);
+		DPRINTK_ISPCTRL("isp_set_xclk(): cam_xclkb set to %d Hz\n",
+								currentxclk);
+		break;
+	default:
+		DPRINTK_ISPCTRL("ISP_ERR: isp_set_xclk(): Invalid requested "
+						"xclk. Must be 0 (A) or 1 (B)."
+						"\n");
+		return -EINVAL;
+	}
+
+	return currentxclk;
+}
+EXPORT_SYMBOL(isp_set_xclk);
+
+/**
+ * isp_get_xclk - Returns the frequency in Hz of the desired cam_xclk.
+ * @xclksel: XCLK to retrieve (0 = A, 1 = B).
+ *
+ * This function returns the External Clock (XCLKA or XCLKB) value generated
+ * by the ISP.
+ **/
+u32 isp_get_xclk(u8 xclksel)
+{
+	u32 xclkdiv;
+	u32 xclk;
+
+	switch (xclksel) {
+	case 0:
+		xclkdiv = omap_readl(ISP_TCTRL_CTRL) & ISPTCTRL_CTRL_DIVA_MASK;
+		xclkdiv = xclkdiv >> ISPTCTRL_CTRL_DIVA_SHIFT;
+		break;
+	case 1:
+		xclkdiv = omap_readl(ISP_TCTRL_CTRL) & ISPTCTRL_CTRL_DIVB_MASK;
+		xclkdiv = xclkdiv >> ISPTCTRL_CTRL_DIVB_SHIFT;
+		break;
+	default:
+		DPRINTK_ISPCTRL("ISP_ERR: isp_get_xclk(): Invalid requested "
+						"xclk. Must be 0 (A) or 1 (B)."
+						"\n");
+		return -EINVAL;
+	}
+
+	switch (xclkdiv) {
+	case 0:
+	case 1:
+		xclk = 0;
+		break;
+	case 0x1f:
+		xclk = CM_CAM_MCLK_HZ;
+		break;
+	default:
+		xclk = CM_CAM_MCLK_HZ / xclkdiv;
+		break;
+	}
+
+	return xclk;
+}
+EXPORT_SYMBOL(isp_get_xclk);
+
+/**
+ * isp_power_settings - Sysconfig settings, for Power Management.
+ * @isp_sysconfig: Structure containing the power settings for ISP to configure
+ *
+ * Sets the power settings for the ISP, and SBL bus.
+ **/
+void isp_power_settings(struct isp_sysc isp_sysconfig)
+{
+	if (isp_sysconfig.idle_mode) {
+		omap_writel(ISP_SYSCONFIG_AUTOIDLE |
+				(ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY <<
+				ISP_SYSCONFIG_MIDLEMODE_SHIFT),
+				ISP_SYSCONFIG);
+
+		omap_writel(ISPMMU_AUTOIDLE | (ISPMMU_SIDLEMODE_SMARTIDLE <<
+						ISPMMU_SIDLEMODE_SHIFT),
+						ISPMMU_SYSCONFIG);
+		if (is_sil_rev_equal_to(OMAP3430_REV_ES1_0)) {
+			omap_writel(ISPCSI1_AUTOIDLE |
+					(ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
+					ISPCSI1_MIDLEMODE_SHIFT),
+					ISP_CSIA_SYSCONFIG);
+			omap_writel(ISPCSI1_AUTOIDLE |
+					(ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
+					ISPCSI1_MIDLEMODE_SHIFT),
+					ISP_CSIB_SYSCONFIG);
+		}
+		omap_writel(ISPCTRL_SBL_AUTOIDLE, ISP_CTRL);
+
+	} else {
+		omap_writel(ISP_SYSCONFIG_AUTOIDLE |
+				(ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY <<
+				ISP_SYSCONFIG_MIDLEMODE_SHIFT),
+				ISP_SYSCONFIG);
+
+		omap_writel(ISPMMU_AUTOIDLE |
+			(ISPMMU_SIDLEMODE_NOIDLE << ISPMMU_SIDLEMODE_SHIFT),
+							ISPMMU_SYSCONFIG);
+		if (is_sil_rev_equal_to(OMAP3430_REV_ES1_0)) {
+			omap_writel(ISPCSI1_AUTOIDLE |
+					(ISPCSI1_MIDLEMODE_FORCESTANDBY <<
+					ISPCSI1_MIDLEMODE_SHIFT),
+					ISP_CSIA_SYSCONFIG);
+
+			omap_writel(ISPCSI1_AUTOIDLE |
+					(ISPCSI1_MIDLEMODE_FORCESTANDBY <<
+					ISPCSI1_MIDLEMODE_SHIFT),
+					ISP_CSIB_SYSCONFIG);
+		}
+
+		omap_writel(ISPCTRL_SBL_AUTOIDLE, ISP_CTRL);
+	}
+}
+EXPORT_SYMBOL(isp_power_settings);
+
+#define BIT_SET(var, shift, mask, val)		\
+	do {					\
+		var = (var & ~(mask << shift))	\
+			| (val << shift);	\
+	} while (0)
+
+static int isp_init_csi(struct isp_interface_config *config)
+{
+	u32 i = 0, val, reg;
+	int format;
+
+	switch (config->u.csi.format) {
+	case V4L2_PIX_FMT_SGRBG10:
+		format = 0x16;		/* RAW10+VP */
+		break;
+	case V4L2_PIX_FMT_SGRBG10DPCM8:
+		format = 0x12;		/* RAW8+DPCM10+VP */
+		break;
+	default:
+		printk(KERN_ERR "isp_init_csi: bad csi format\n");
+		return -EINVAL;
+	}
+
+	/* Reset the CSI and wait for reset to complete */
+	omap_writel(omap_readl(ISPCSI1_SYSCONFIG) | BIT(1), ISPCSI1_SYSCONFIG);
+	while (!(omap_readl(ISPCSI1_SYSSTATUS) & BIT(0))) {
+		udelay(10);
+		if (i++ > 10)
+			break;
+	}
+	if (!(omap_readl(ISPCSI1_SYSSTATUS) & BIT(0))) {
+		printk(KERN_WARNING
+			"omap3_isp: timeout waiting for csi reset\n");
+	}
+
+	/* CONTROL_CSIRXFE */
+	omap_writel(
+		/* CSIb receiver data/clock or data/strobe mode */
+		(config->u.csi.signalling << 10)
+		| BIT(12)	/* Enable differential transceiver */
+		| BIT(13)	/* Disable reset */
+#ifdef TERM_RESISTOR
+		| BIT(8)	/* Enable internal CSIb resistor (no effect) */
+#endif
+/*		| BIT(7) */	/* Strobe/clock inversion (no effect) */
+	, CONTROL_CSIRXFE);
+
+#ifdef TERM_RESISTOR
+	/* Set CONTROL_CSI */
+	val = omap_readl(CONTROL_CSI);
+	val &= ~(0x1F<<16);
+	val |= BIT(31) | (TERM_RESISTOR<<16);
+	omap_writel(val, CONTROL_CSI);
+#endif
+
+	/* ISPCSI1_CTRL */
+	val = omap_readl(ISPCSI1_CTRL);
+	val &= ~BIT(11);	/* Enable VP only off ->
+				extract embedded data to interconnect */
+	BIT_SET(val, 8, 0x3, config->u.csi.vpclk);	/* Video port clock */
+/*	val |= BIT(3);	*/	/* Wait for FEC before disabling interface */
+	val |= BIT(2);		/* I/O cell output is parallel
+				(no effect, but errata says should be enabled
+				for class 1/2) */
+	val |= BIT(12);		/* VP clock polarity to falling edge
+				(needed or bad picture!) */
+
+	/* Data/strobe physical layer */
+	BIT_SET(val, 1, 1, config->u.csi.signalling);
+	BIT_SET(val, 10, 1, config->u.csi.strobe_clock_inv);
+	val |= BIT(4);		/* Magic bit to enable CSI1 and strobe mode */
+	omap_writel(val, ISPCSI1_CTRL);
+
+	/* ISPCSI1_LCx_CTRL logical channel #0 */
+	reg = ISPCSI1_LCx_CTRL(0);	/* reg = ISPCSI1_CTRL1; */
+	val = omap_readl(reg);
+	/* Format = RAW10+VP or RAW8+DPCM10+VP*/
+	BIT_SET(val, 3, 0x1f, format);
+	/* Enable setting of frame regions of interest */
+	BIT_SET(val, 1, 1, 1);
+	BIT_SET(val, 2, 1, config->u.csi.crc);
+	omap_writel(val, reg);
+
+	/* ISPCSI1_DAT_START for logical channel #0 */
+	reg = ISPCSI1_LCx_DAT_START(0);		/* reg = ISPCSI1_DAT_START; */
+	val = omap_readl(reg);
+	BIT_SET(val, 16, 0xfff, config->u.csi.data_start);
+	omap_writel(val, reg);
+
+	/* ISPCSI1_DAT_SIZE for logical channel #0 */
+	reg = ISPCSI1_LCx_DAT_SIZE(0);		/* reg = ISPCSI1_DAT_SIZE; */
+	val = omap_readl(reg);
+	BIT_SET(val, 16, 0xfff, config->u.csi.data_size);
+	omap_writel(val, reg);
+
+	/* Clear status bits for logical channel #0 */
+	omap_writel(0xFFF & ~BIT(6), ISPCSI1_LC01_IRQSTATUS);
+
+	/* Enable CSI1 */
+	val = omap_readl(ISPCSI1_CTRL);
+	val |=  BIT(0) | BIT(4);
+	omap_writel(val, ISPCSI1_CTRL);
+
+	if (!(omap_readl(ISPCSI1_CTRL) & BIT(4))) {
+		printk(KERN_WARNING "OMAP3 CSI1 bus not available\n");
+		if (config->u.csi.signalling)	/* Strobe mode requires CSI1 */
+			return -EIO;
+	}
+
+	return 0;
+}
+
+/**
+ * isp_configure_interface - Configures ISP Control I/F related parameters.
+ * @config: Pointer to structure containing the desired configuration for the
+ * 	ISP.
+ *
+ * Configures ISP control register (ISP_CTRL) with the values specified inside
+ * the config structure. Controls:
+ * - Selection of parallel or serial input to the preview hardware.
+ * - Data lane shifter.
+ * - Pixel clock polarity.
+ * - 8 to 16-bit bridge at the input of CCDC module.
+ * - HS or VS synchronization signal detection
+ **/
+int isp_configure_interface(struct isp_interface_config *config)
+{
+	u32 ispctrl_val = omap_readl(ISP_CTRL);
+	u32 ispccdc_vdint_val;
+	int r;
+
+	ispctrl_val &= ISPCTRL_SHIFT_MASK;
+	ispctrl_val |= (config->dataline_shift << ISPCTRL_SHIFT_SHIFT);
+	ispctrl_val &= ~ISPCTRL_PAR_CLK_POL_INV;
+
+	ispctrl_val &= (ISPCTRL_PAR_SER_CLK_SEL_MASK);
+	switch (config->ccdc_par_ser) {
+	case ISP_PARLL:
+		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
+		ispctrl_val |= (config->u.par.par_clk_pol
+						<< ISPCTRL_PAR_CLK_POL_SHIFT);
+		ispctrl_val &= ~ISPCTRL_PAR_BRIDGE_BENDIAN;
+		ispctrl_val |= (config->u.par.par_bridge
+						<< ISPCTRL_PAR_BRIDGE_SHIFT);
+		break;
+	case ISP_CSIB:
+		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_CSIB;
+		r = isp_init_csi(config);
+		if (r)
+			return r;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ispctrl_val &= ~(ISPCTRL_SYNC_DETECT_VSRISE);
+	ispctrl_val |= (config->hsvs_syncdetect);
+
+	omap_writel(ispctrl_val, ISP_CTRL);
+
+	ispccdc_vdint_val = omap_readl(ISPCCDC_VDINT);
+	ispccdc_vdint_val &= ~(ISPCCDC_VDINT_0_MASK << ISPCCDC_VDINT_0_SHIFT);
+	ispccdc_vdint_val &= ~(ISPCCDC_VDINT_1_MASK << ISPCCDC_VDINT_1_SHIFT);
+	omap_writel((config->vdint0_timing << ISPCCDC_VDINT_0_SHIFT) |
+						(config->vdint1_timing <<
+						ISPCCDC_VDINT_1_SHIFT),
+						ISPCCDC_VDINT);
+
+	return 0;
+}
+EXPORT_SYMBOL(isp_configure_interface);
+
+/**
+ * isp_CCDC_VD01_enable - Enables VD0 and VD1 IRQs.
+ *
+ * Sets VD0 and VD1 bits in IRQ0STATUS to reset the flag, and sets them in
+ * IRQ0ENABLE to enable the corresponding IRQs.
+ **/
+void isp_CCDC_VD01_enable(void)
+{
+	omap_writel(IRQ0STATUS_CCDC_VD0_IRQ | IRQ0STATUS_CCDC_VD1_IRQ,
+							ISP_IRQ0STATUS);
+	omap_writel(omap_readl(ISP_IRQ0ENABLE) | IRQ0ENABLE_CCDC_VD0_IRQ |
+						IRQ0ENABLE_CCDC_VD1_IRQ,
+						ISP_IRQ0ENABLE);
+}
+
+/**
+ * isp_CCDC_VD01_disable - Disables VD0 and VD1 IRQs.
+ *
+ * Clears VD0 and VD1 bits in IRQ0ENABLE register.
+ **/
+void isp_CCDC_VD01_disable(void)
+{
+	omap_writel(omap_readl(ISP_IRQ0ENABLE) & ~(IRQ0ENABLE_CCDC_VD0_IRQ |
+						IRQ0ENABLE_CCDC_VD1_IRQ),
+						ISP_IRQ0ENABLE);
+}
+
+/**
+ * omap34xx_isp_isr - Interrupt Service Routine for Camera ISP module.
+ * @irq: Not used currently.
+ * @ispirq_disp: Pointer to the object that is passed while request_irq is
+ *               called. This is the ispirq_obj object containing info on the
+ *               callback.
+ *
+ * Handles the corresponding callback if plugged in.
+ *
+ * Returns IRQ_HANDLED when IRQ was correctly handled, or IRQ_NONE when the
+ * IRQ wasn't handled.
+ **/
+static irqreturn_t omap34xx_isp_isr(int irq, void *ispirq_disp)
+{
+	struct ispirq *irqdis = (struct ispirq *)ispirq_disp;
+	u32 irqstatus = 0;
+	unsigned long irqflags = 0;
+	u8 is_irqhandled = 0;
+
+	irqstatus = omap_readl(ISP_IRQ0STATUS);
+
+	spin_lock_irqsave(&isp_obj.lock, irqflags);
+
+	if ((irqstatus & MMU_ERR) == MMU_ERR) {
+		if (irqdis->isp_callbk[CBK_MMU_ERR])
+			irqdis->isp_callbk[CBK_MMU_ERR](irqstatus,
+				irqdis->isp_callbk_arg1[CBK_MMU_ERR],
+				irqdis->isp_callbk_arg2[CBK_MMU_ERR]);
+		is_irqhandled = 1;
+		goto out;
+	}
+
+	if ((irqstatus & CCDC_VD1) == CCDC_VD1) {
+		if (irqdis->isp_callbk[CBK_CCDC_VD1])
+				irqdis->isp_callbk[CBK_CCDC_VD1](CCDC_VD1,
+				irqdis->isp_callbk_arg1[CBK_CCDC_VD1],
+				irqdis->isp_callbk_arg2[CBK_CCDC_VD1]);
+		is_irqhandled = 1;
+	}
+
+	if ((irqstatus & CCDC_VD0) == CCDC_VD0) {
+		if (irqdis->isp_callbk[CBK_CCDC_VD0])
+			irqdis->isp_callbk[CBK_CCDC_VD0](CCDC_VD0,
+				irqdis->isp_callbk_arg1[CBK_CCDC_VD0],
+				irqdis->isp_callbk_arg2[CBK_CCDC_VD0]);
+		is_irqhandled = 1;
+	}
+
+	if ((irqstatus & HS_VS) == HS_VS) {
+		if (irqdis->isp_callbk[CBK_HS_VS])
+			irqdis->isp_callbk[CBK_HS_VS](HS_VS,
+				irqdis->isp_callbk_arg1[CBK_HS_VS],
+				irqdis->isp_callbk_arg2[CBK_HS_VS]);
+		is_irqhandled = 1;
+	}
+
+	if (irqstatus & IRQ0STATUS_CSIB_IRQ) {
+		u32 ispcsi1_irqstatus;
+
+		ispcsi1_irqstatus = omap_readl(ISPCSI1_LC01_IRQSTATUS);
+		DPRINTK_ISPCTRL("%x\n", ispcsi1_irqstatus);
+	}
+
+out:
+	omap_writel(irqstatus, ISP_IRQ0STATUS);
+	spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+
+	if (is_irqhandled)
+		return IRQ_HANDLED;
+	else
+		return IRQ_NONE;
+}
+/* Device name, needed for resource tracking layer */
+struct device_driver camera_drv = {
+	.name = "camera"
+};
+
+struct device camera_dev = {
+	.driver = &camera_drv,
+};
+
+/**
+ * isp_set_pipeline - Set bit mask for submodules enabled within the ISP.
+ * @soc_type: Sensor to use: 1 - Smart sensor, 0 - Raw sensor.
+ *
+ * Sets Previewer and Resizer in the bit mask only if its a Raw sensor.
+ **/
+void isp_set_pipeline(int soc_type)
+{
+	ispmodule_obj.isp_pipeline |= OMAP_ISP_CCDC;
+
+	if (!soc_type)
+		ispmodule_obj.isp_pipeline |= (OMAP_ISP_PREVIEW |
+							OMAP_ISP_RESIZER);
+
+	return;
+}
+
+/**
+ * omapisp_unset_callback - Unsets all the callbacks associated with ISP module
+ **/
+void omapisp_unset_callback()
+{
+	isp_unset_callback(CBK_HS_VS);
+
+	if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+		isp_unset_callback(CBK_CCDC_VD0);
+		isp_unset_callback(CBK_CCDC_VD1);
+		isp_unset_callback(CBK_LSC_ISR);
+	}
+	omap_writel(omap_readl(ISP_IRQ0STATUS) | ISP_INT_CLR, ISP_IRQ0STATUS);
+}
+
+/**
+ * isp_start - Starts ISP submodule
+ *
+ * Start the needed isp components assuming these components
+ * are configured correctly.
+ **/
+void isp_start(void)
+{
+	return;
+}
+
+/**
+ * isp_stop - Stops isp submodules
+ **/
+void isp_stop()
+{
+	int timeout;
+
+	spin_lock(&isp_obj.isp_temp_buf_lock);
+	ispmodule_obj.isp_temp_state = ISP_FREE_RUNNING;
+	spin_unlock(&isp_obj.isp_temp_buf_lock);
+	omapisp_unset_callback();
+
+	if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+		ispccdc_enable(0);
+		timeout = 0;
+		while (ispccdc_busy() && (timeout < 20)) {
+			timeout++;
+			mdelay(10);
+		}
+	}
+	if (ispccdc_busy()) {
+		isp_save_ctx();
+		omap_writel(omap_readl(ISP_SYSCONFIG) |
+			ISP_SYSCONFIG_SOFTRESET, ISP_SYSCONFIG);
+		timeout = 0;
+		while ((!(omap_readl(ISP_SYSSTATUS) & 0x1)) && timeout < 20) {
+			timeout++;
+			mdelay(1);
+		}
+	isp_restore_ctx();
+	}
+}
+
+/**
+ * isp_set_buf - Sets output address for submodules.
+ * @sgdma_state: Pointer to structure with the SGDMA state for each videobuffer
+ **/
+void isp_set_buf(struct isp_sgdma_state *sgdma_state)
+{
+	if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC)
+		ispccdc_set_outaddr(sgdma_state->isp_addr);
+
+}
+
+/**
+ * isp_calc_pipeline - Sets pipeline depending of input and output pixel format
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ **/
+void isp_calc_pipeline(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output)
+{
+	ispmodule_obj.isp_pipeline = OMAP_ISP_CCDC;
+	if ((pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10) &&
+		(pix_output->pixelformat != V4L2_PIX_FMT_SGRBG10)) {
+		ispmodule_obj.isp_pipeline |= (OMAP_ISP_PREVIEW |
+							OMAP_ISP_RESIZER);
+		ispccdc_config_datapath(CCDC_RAW, CCDC_OTHERS_VP);
+	} else {
+		if (pix_input->pixelformat == V4L2_PIX_FMT_SGRBG10)
+			ispccdc_config_datapath(CCDC_RAW, CCDC_OTHERS_MEM);
+		else
+			ispccdc_config_datapath(CCDC_YUV_SYNC,
+							CCDC_OTHERS_MEM);
+	}
+	return;
+}
+
+/**
+ * isp_config_pipeline - Configures the image size and ycpos for ISP submodules
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * The configuration of ycpos depends on the output pixel format for both the
+ * Preview and Resizer submodules.
+ **/
+void isp_config_pipeline(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output)
+{
+	ispccdc_config_size(ispmodule_obj.ccdc_input_width,
+			ispmodule_obj.ccdc_input_height,
+			ispmodule_obj.ccdc_output_width,
+			ispmodule_obj.ccdc_output_height);
+
+	return;
+}
+
+/**
+ * isp_vbq_done - Callback for interrupt completion
+ * @status: IRQ0STATUS register value. Passed by the ISR, or the caller.
+ * @arg1: Pointer to callback function for SG-DMA management.
+ * @arg2: Pointer to videobuffer structure managed by ISP.
+ **/
+void isp_vbq_done(unsigned long status, isp_vbq_callback_ptr arg1, void *arg2)
+{
+	struct videobuf_buffer *vb = (struct videobuf_buffer *) arg2;
+	int notify = 0;
+	int rval = 0;
+	unsigned long flags;
+
+	switch (status) {
+	case CCDC_VD0:
+		ispccdc_config_shadow_registers();
+		if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) ||
+			(ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW))
+			return;
+		else {
+			spin_lock(&isp_obj.isp_temp_buf_lock);
+			if (ispmodule_obj.isp_temp_state != ISP_BUF_INIT) {
+				spin_unlock(&isp_obj.isp_temp_buf_lock);
+				return;
+
+			} else {
+				spin_unlock(&isp_obj.isp_temp_buf_lock);
+				break;
+			}
+		}
+		break;
+	case CCDC_VD1:
+		if ((ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER) ||
+			(ispmodule_obj.isp_pipeline & OMAP_ISP_PREVIEW))
+			return;
+		spin_lock(&isp_obj.isp_temp_buf_lock);
+		if (ispmodule_obj.isp_temp_state == ISP_BUF_INIT) {
+			spin_unlock(&isp_obj.isp_temp_buf_lock);
+			ispccdc_enable(0);
+			return;
+		}
+		spin_unlock(&isp_obj.isp_temp_buf_lock);
+		return;
+		break;
+	case HS_VS:
+		spin_lock(&isp_obj.isp_temp_buf_lock);
+		if (ispmodule_obj.isp_temp_state == ISP_BUF_TRAN) {
+			isp_CCDC_VD01_enable();
+			ispmodule_obj.isp_temp_state = ISP_BUF_INIT;
+		}
+		spin_unlock(&isp_obj.isp_temp_buf_lock);
+		return;
+	default:
+		break;
+	}
+
+	spin_lock_irqsave(&ispsg.lock, flags);
+	ispsg.free_sgdma++;
+	if (ispsg.free_sgdma > NUM_SG_DMA)
+		ispsg.free_sgdma = NUM_SG_DMA;
+	spin_unlock_irqrestore(&ispsg.lock, flags);
+
+	rval = arg1(vb);
+
+	if (rval)
+		isp_sgdma_process(&ispsg, 1, &notify, arg1);
+
+	return;
+}
+
+/**
+ * isp_sgdma_init - Initializes Scatter Gather DMA status and operations.
+ **/
+void isp_sgdma_init()
+{
+	int sg;
+
+	ispsg.free_sgdma = NUM_SG_DMA;
+	ispsg.next_sgdma = 0;
+	for (sg = 0; sg < NUM_SG_DMA; sg++) {
+		ispsg.sg_state[sg].status = 0;
+		ispsg.sg_state[sg].callback = NULL;
+		ispsg.sg_state[sg].arg = NULL;
+	}
+}
+
+/**
+ * isp_sgdma_process - Sets operations and config for specified SG DMA
+ * @sgdma: SG-DMA function to work on.
+ * @irq: Flag to specify if an IRQ is associated with the DMA completion.
+ * @dma_notify: Pointer to flag that says when the ISP has to be started.
+ * @func_ptr: Callback function pointer for SG-DMA setup.
+ **/
+void isp_sgdma_process(struct isp_sgdma *sgdma, int irq, int *dma_notify,
+						isp_vbq_callback_ptr func_ptr)
+{
+	struct isp_sgdma_state *sgdma_state;
+	unsigned long flags;
+	spin_lock_irqsave(&sgdma->lock, flags);
+
+	if (NUM_SG_DMA > sgdma->free_sgdma) {
+		sgdma_state = sgdma->sg_state +
+			(sgdma->next_sgdma + sgdma->free_sgdma) % NUM_SG_DMA;
+		if (!irq) {
+			if (*dma_notify) {
+				isp_set_sgdma_callback(sgdma_state, func_ptr);
+				isp_set_buf(sgdma_state);
+				ispccdc_enable(1);
+				isp_start();
+				*dma_notify = 0;
+				ispmodule_obj.isp_temp_state = ISP_BUF_TRAN;
+			} else {
+				if (ispmodule_obj.isp_temp_state ==
+							ISP_FREE_RUNNING) {
+					isp_set_sgdma_callback(sgdma_state,
+								func_ptr);
+					isp_set_buf(sgdma_state);
+					ispccdc_enable(1);
+					ispmodule_obj.isp_temp_state =
+								ISP_BUF_TRAN;
+				}
+			}
+		} else {
+			isp_set_sgdma_callback(sgdma_state, func_ptr);
+			isp_set_buf(sgdma_state);
+			ispccdc_enable(1);
+			ispmodule_obj.isp_temp_state = ISP_BUF_INIT;
+
+			if (*dma_notify) {
+				isp_start();
+				*dma_notify = 0;
+			}
+		}
+	} else {
+		spin_lock(&isp_obj.isp_temp_buf_lock);
+		isp_CCDC_VD01_disable();
+		ispmodule_obj.isp_temp_state = ISP_FREE_RUNNING;
+		spin_unlock(&isp_obj.isp_temp_buf_lock);
+	}
+	spin_unlock_irqrestore(&sgdma->lock, flags);
+	return;
+}
+
+/**
+ * isp_sgdma_queue - Queues a Scatter-Gather DMA videobuffer.
+ * @vdma: Pointer to structure containing the desired DMA video buffer
+ *        transfer parameters.
+ * @vb: Pointer to structure containing the target videobuffer.
+ * @irq: Flag to specify if an IRQ is associated with the DMA completion.
+ * @dma_notify: Pointer to flag that says when the ISP has to be started.
+ * @func_ptr: Callback function pointer for SG-DMA setup.
+ *
+ * Returns 0 if successful, -EINVAL if invalid SG linked list setup, or -EBUSY
+ * if the ISP SG-DMA is not free.
+ **/
+int isp_sgdma_queue(struct videobuf_dmabuf *vdma, struct videobuf_buffer *vb,
+						int irq, int *dma_notify,
+						isp_vbq_callback_ptr func_ptr)
+{
+	unsigned long flags;
+	struct isp_sgdma_state *sg_state;
+	const struct scatterlist *sglist = vdma->sglist;
+	int sglen = vdma->sglen;
+
+	if ((sglen < 0) || ((sglen > 0) & !sglist))
+		return -EINVAL;
+
+	spin_lock_irqsave(&ispsg.lock, flags);
+
+	if (!ispsg.free_sgdma) {
+		spin_unlock_irqrestore(&ispsg.lock, flags);
+		return -EBUSY;
+	}
+
+	sg_state = ispsg.sg_state + ispsg.next_sgdma;
+	sg_state->isp_addr = ispsg.isp_addr_capture[vb->i];
+	sg_state->status = 0;
+	sg_state->callback = isp_vbq_done;
+	sg_state->arg = vb;
+
+	ispsg.next_sgdma = (ispsg.next_sgdma + 1) % NUM_SG_DMA;
+	ispsg.free_sgdma--;
+
+	spin_unlock_irqrestore(&ispsg.lock, flags);
+
+	isp_sgdma_process(&ispsg, irq, dma_notify, func_ptr);
+
+	return 0;
+}
+
+/**
+ * isp_vbq_prepare - Videobuffer queue prepare.
+ * @vbq: Pointer to videobuf_queue structure.
+ * @vb: Pointer to videobuf_buffer structure.
+ * @field: Requested Field order for the videobuffer.
+ *
+ * Returns 0 if successful, or -EIO if the ispmmu was unable to map a
+ * scatter-gather linked list data space.
+ **/
+int isp_vbq_prepare(struct videobuf_queue *vbq, struct videobuf_buffer *vb,
+							enum v4l2_field field)
+{
+	unsigned int isp_addr;
+	struct videobuf_dmabuf	*vdma;
+
+	int err = 0;
+
+	vdma = videobuf_to_dma(vb);
+
+	isp_addr = ispmmu_map_sg(vdma->sglist, vdma->sglen);
+
+	if (!isp_addr)
+		err = -EIO;
+	else
+		ispsg.isp_addr_capture[vb->i] = isp_addr;
+
+	return err;
+}
+
+/**
+ * isp_vbq_release - Videobuffer queue release.
+ * @vbq: Pointer to videobuf_queue structure.
+ * @vb: Pointer to videobuf_buffer structure.
+ **/
+void isp_vbq_release(struct videobuf_queue *vbq, struct videobuf_buffer *vb)
+{
+	ispmmu_unmap(ispsg.isp_addr_capture[vb->i]);
+	ispsg.isp_addr_capture[vb->i] = (dma_addr_t) NULL;
+	return;
+}
+
+/**
+ * isp_queryctrl - Query V4L2 control from existing controls in ISP.
+ * @a: Pointer to v4l2_queryctrl structure. It only needs the id field filled.
+ *
+ * Returns 0 if successful, or -EINVAL if not found in ISP.
+ **/
+int isp_queryctrl(struct v4l2_queryctrl *a)
+{
+	int i;
+
+	i = find_vctrl(a->id);
+	if (i == -EINVAL)
+		a->flags = V4L2_CTRL_FLAG_DISABLED;
+
+	if (i < 0)
+		return -EINVAL;
+
+	*a = video_control[i].qc;
+	return 0;
+}
+
+/**
+ * isp_g_ctrl - Gets value of the desired V4L2 control.
+ * @a: V4L2 control to read actual value from.
+ *
+ * Return 0 if successful, or -EINVAL if chosen control is not found.
+ **/
+int isp_g_ctrl(struct v4l2_control *a)
+{
+	int rval = 0;
+
+	switch (a->id) {
+	default:
+		rval = -EINVAL;
+		break;
+	}
+
+	return rval;
+}
+
+/**
+ * isp_s_ctrl - Sets value of the desired V4L2 control.
+ * @a: V4L2 control to read actual value from.
+ *
+ * Return 0 if successful, -EINVAL if chosen control is not found or value
+ * is out of bounds, -EFAULT if copy_from_user or copy_to_user operation fails
+ * from camera abstraction layer related controls or the transfered user space
+ * pointer via the value field is not set properly.
+ **/
+int isp_s_ctrl(struct v4l2_control *a)
+{
+	int rval = 0;
+
+	switch (a->id) {
+	default:
+		rval = -EINVAL;
+		break;
+	}
+
+	return rval;
+}
+
+/**
+ * isp_handle_private - Handle all private ioctls for isp module.
+ * @cmd: ioctl cmd value
+ * @arg: ioctl arg value
+ *
+ * Return 0 if successful, -EINVAL if chosen cmd value is not handled or value
+ * is out of bounds, -EFAULT if ioctl arg value is not valid.
+ * Function simply routes the input ioctl cmd id to the appropriate handler in
+ * the isp module.
+ **/
+int isp_handle_private(int cmd, void *arg)
+{
+	int rval = 0;
+
+	switch (cmd) {
+	default:
+		rval = -EINVAL;
+		break;
+	}
+
+	return rval;
+}
+
+/**
+ * isp_enum_fmt_cap - Gets more information of chosen format index and type
+ * @f: Pointer to structure containing index and type of format to read from.
+ *
+ * Returns 0 if successful, or -EINVAL if format index or format type is
+ * invalid.
+ **/
+int isp_enum_fmt_cap(struct v4l2_fmtdesc *f)
+{
+	int index = f->index;
+	enum v4l2_buf_type type = f->type;
+	int rval = -EINVAL;
+
+	if (index >= NUM_ISP_CAPTURE_FORMATS)
+		goto err;
+
+	memset(f, 0, sizeof(*f));
+	f->index = index;
+	f->type = type;
+
+	switch (f->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		rval = 0;
+		break;
+	default:
+		goto err;
+	}
+
+	f->flags = isp_formats[index].flags;
+	strncpy(f->description, isp_formats[index].description,
+						sizeof(f->description));
+	f->pixelformat = isp_formats[index].pixelformat;
+err:
+	return rval;
+}
+EXPORT_SYMBOL(isp_enum_fmt_cap);
+
+/**
+ * isp_g_fmt_cap - Gets current output image format.
+ * @f: Pointer to V4L2 format structure to be filled with current output format
+ **/
+void isp_g_fmt_cap(struct v4l2_format *f)
+{
+	f->fmt.pix = ispmodule_obj.pix;
+	return;
+}
+
+/**
+ * isp_s_fmt_cap - Sets I/O formats and crop and configures pipeline in ISP
+ * @f: Pointer to V4L2 format structure to be filled with current output format
+ *
+ * Returns 0 if successful, or return value of either isp_try_size or
+ * isp_try_fmt if there is an error.
+ **/
+int isp_s_fmt_cap(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output)
+{
+	int crop_scaling_w, crop_scaling_h = 0;
+	int rval = 0;
+
+	isp_calc_pipeline(pix_input, pix_output);
+	rval = isp_try_size(pix_input, pix_output);
+
+	if (rval)
+		goto out;
+
+	rval = isp_try_fmt(pix_input, pix_output);
+	if (rval)
+		goto out;
+
+	if (ispcroprect.width != pix_output->width) {
+		crop_scaling_w = 1;
+		ispcroprect.left = 0;
+		ispcroprect.width = pix_output->width;
+	}
+
+	if (ispcroprect.height != pix_output->height) {
+		crop_scaling_h = 1;
+		ispcroprect.top = 0;
+		ispcroprect.height = pix_output->height;
+	}
+
+	isp_config_pipeline(pix_input, pix_output);
+
+	if (crop_scaling_h || crop_scaling_w)
+		isp_config_crop(pix_output);
+
+out:
+	return rval;
+}
+EXPORT_SYMBOL(isp_s_fmt_cap);
+
+/**
+ * isp_config_crop - Configures crop parameters in isp resizer.
+ * @croppix: Pointer to V4L2 pixel format structure containing crop parameters
+ **/
+void isp_config_crop(struct v4l2_pix_format *croppix)
+{
+	u8 crop_scaling_w;
+	u8 crop_scaling_h;
+	struct v4l2_pix_format *pix = croppix;
+
+	crop_scaling_w = (ispmodule_obj.preview_output_width * 10) /
+								pix->width;
+	crop_scaling_h = (ispmodule_obj.preview_output_height * 10) /
+								pix->height;
+
+	cur_rect.left = (ispcroprect.left * crop_scaling_w) / 10;
+	cur_rect.top = (ispcroprect.top * crop_scaling_h) / 10;
+	cur_rect.width = (ispcroprect.width * crop_scaling_w) / 10;
+	cur_rect.height = (ispcroprect.height * crop_scaling_h) / 10;
+
+	return;
+}
+
+/**
+ * isp_g_crop - Gets crop rectangle size and position.
+ * @a: Pointer to V4L2 crop structure to be filled.
+ *
+ * Always returns 0.
+ **/
+int isp_g_crop(struct v4l2_crop *a)
+{
+	struct v4l2_crop *crop = a;
+
+	crop->c = ispcroprect;
+	return 0;
+}
+
+/**
+ * isp_s_crop - Sets crop rectangle size and position and queues crop operation
+ * @a: Pointer to V4L2 crop structure with desired parameters.
+ * @pix: Pointer to V4L2 pixel format structure with desired parameters.
+ *
+ * Returns 0 if successful, or -EINVAL if crop parameters are out of bounds.
+ **/
+int isp_s_crop(struct v4l2_crop *a, struct v4l2_pix_format *pix)
+{
+	struct v4l2_crop *crop = a;
+	int rval = 0;
+
+	if ((crop->c.left + crop->c.width) > pix->width) {
+		rval = -EINVAL;
+		goto out;
+	}
+
+	if ((crop->c.top + crop->c.height) > pix->height) {
+		rval = -EINVAL;
+		goto out;
+	}
+
+	ispcroprect.left = crop->c.left;
+	ispcroprect.top = crop->c.top;
+	ispcroprect.width = crop->c.width;
+	ispcroprect.height = crop->c.height;
+
+	isp_config_crop(pix);
+
+	ispmodule_obj.applyCrop = 1;
+out:
+	return rval;
+}
+
+/**
+ * isp_try_fmt_cap - Tries desired input/output image formats
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * Returns 0 if successful, or return value of either isp_try_size or
+ * isp_try_fmt if there is an error.
+ **/
+int isp_try_fmt_cap(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output)
+{
+	int rval = 0;
+
+	isp_calc_pipeline(pix_input, pix_output);
+	rval = isp_try_size(pix_input, pix_output);
+
+	if (rval)
+		goto out;
+
+	rval = isp_try_fmt(pix_input, pix_output);
+
+	if (rval)
+		goto out;
+
+out:
+	return rval;
+}
+EXPORT_SYMBOL(isp_try_fmt_cap);
+
+/**
+ * isp_try_size - Tries size configuration for I/O images of each ISP submodule
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * Returns 0 if successful, or return value of ispccdc_try_size,
+ * isppreview_try_size, or ispresizer_try_size (depending on the pipeline
+ * configuration) if there is an error.
+ **/
+int isp_try_size(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output)
+{
+	int rval = 0;
+	ispmodule_obj.ccdc_input_width = pix_input->width;
+	ispmodule_obj.ccdc_input_height = pix_input->height;
+	ispmodule_obj.resizer_output_width = pix_output->width;
+	ispmodule_obj.resizer_output_height = pix_output->height;
+
+	if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+		rval = ispccdc_try_size(ispmodule_obj.ccdc_input_width,
+					ispmodule_obj.ccdc_input_height,
+					&ispmodule_obj.ccdc_output_width,
+					&ispmodule_obj.ccdc_output_height);
+		pix_output->width = ispmodule_obj.ccdc_output_width;
+		pix_output->height = ispmodule_obj.ccdc_output_height;
+	}
+
+	return rval;
+}
+EXPORT_SYMBOL(isp_try_size);
+
+/**
+ * isp_try_fmt - Validates input/output format parameters.
+ * @pix_input: Pointer to V4L2 pixel format structure for input image.
+ * @pix_output: Pointer to V4L2 pixel format structure for output image.
+ *
+ * Always returns 0.
+ **/
+int isp_try_fmt(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output)
+{
+	int ifmt;
+
+	for (ifmt = 0; ifmt < NUM_ISP_CAPTURE_FORMATS; ifmt++) {
+		if (pix_output->pixelformat == isp_formats[ifmt].pixelformat)
+			break;
+	}
+	if (ifmt == NUM_ISP_CAPTURE_FORMATS)
+		ifmt = 1;
+	pix_output->pixelformat = isp_formats[ifmt].pixelformat;
+	pix_output->field = V4L2_FIELD_NONE;
+	pix_output->bytesperline = pix_output->width * ISP_BYTES_PER_PIXEL;
+	pix_output->sizeimage = pix_output->bytesperline * pix_output->height;
+	pix_output->priv = 0;
+	switch (pix_output->pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+		pix_output->colorspace = V4L2_COLORSPACE_JPEG;
+		break;
+	default:
+		pix_output->colorspace = V4L2_COLORSPACE_SRGB;
+		break;
+	}
+
+	ispmodule_obj.pix.pixelformat = pix_output->pixelformat;
+	ispmodule_obj.pix.width = pix_output->width;
+	ispmodule_obj.pix.height = pix_output->height;
+	ispmodule_obj.pix.field = pix_output->field;
+	ispmodule_obj.pix.bytesperline = pix_output->bytesperline;
+	ispmodule_obj.pix.sizeimage = pix_output->sizeimage;
+	ispmodule_obj.pix.priv = pix_output->priv;
+	ispmodule_obj.pix.colorspace = pix_output->colorspace;
+
+	return 0;
+}
+/**
+ * isp_save_ctx - Saves ISP, CCDC, HIST, H3A, PREV, RESZ & MMU context.
+ *
+ * Routine for saving the context of each module in the ISP.
+ * CCDC, HIST, H3A, PREV, RESZ and MMU.
+ **/
+void isp_save_ctx(void)
+{
+	isp_save_context(isp_reg_list);
+	ispccdc_save_context();
+	ispmmu_save_context();
+}
+EXPORT_SYMBOL(isp_save_ctx);
+
+/**
+ * isp_restore_ctx - Restores ISP, CCDC, HIST, H3A, PREV, RESZ & MMU context.
+ *
+ * Routine for restoring the context of each module in the ISP.
+ * CCDC, HIST, H3A, PREV, RESZ and MMU.
+ **/
+void isp_restore_ctx(void)
+{
+	isp_restore_context(isp_reg_list);
+	ispccdc_restore_context();
+	ispmmu_restore_context();
+}
+EXPORT_SYMBOL(isp_restore_ctx);
+
+/**
+ * isp_get - Adquires the ISP resource.
+ *
+ * Initializes the clocks for the first acquire.
+ **/
+int isp_get(void)
+{
+	int ret_err = 0;
+	DPRINTK_ISPCTRL("isp_get: old %d\n", isp_obj.ref_count);
+	mutex_lock(&(isp_obj.isp_mutex));
+	if (isp_obj.ref_count == 0) {
+		isp_obj.cam_ick = clk_get(&camera_dev, "cam_ick");
+		if (IS_ERR(isp_obj.cam_ick)) {
+			DPRINTK_ISPCTRL("ISP_ERR: clk_get for "
+							"cam_ick failed\n");
+			ret_err = PTR_ERR(isp_obj.cam_ick);
+			goto out_clk_get_ick;
+		}
+		isp_obj.cam_mclk = clk_get(&camera_dev, "cam_mclk");
+		if (IS_ERR(isp_obj.cam_mclk)) {
+			DPRINTK_ISPCTRL("ISP_ERR: clk_get for "
+							"cam_mclk failed\n");
+			ret_err = PTR_ERR(isp_obj.cam_mclk);
+			goto out_clk_get_mclk;
+		}
+		ret_err = clk_enable(isp_obj.cam_ick);
+		if (ret_err) {
+			DPRINTK_ISPCTRL("ISP_ERR: clk_en for ick failed\n");
+			goto out_clk_enable_ick;
+		}
+		ret_err = clk_enable(isp_obj.cam_mclk);
+		if (ret_err) {
+			DPRINTK_ISPCTRL("ISP_ERR: clk_en for mclk failed\n");
+			goto out_clk_enable_mclk;
+		}
+		if (off_mode == 1)
+			isp_restore_ctx();
+	}
+	isp_obj.ref_count++;
+	mutex_unlock(&(isp_obj.isp_mutex));
+
+
+	DPRINTK_ISPCTRL("isp_get: new %d\n", isp_obj.ref_count);
+	return isp_obj.ref_count;
+
+out_clk_enable_mclk:
+	clk_disable(isp_obj.cam_ick);
+out_clk_enable_ick:
+	clk_put(isp_obj.cam_mclk);
+out_clk_get_mclk:
+	clk_put(isp_obj.cam_ick);
+out_clk_get_ick:
+
+	mutex_unlock(&(isp_obj.isp_mutex));
+
+	return ret_err;
+}
+EXPORT_SYMBOL(isp_get);
+
+/**
+ * isp_put - Releases the ISP resource.
+ *
+ * Releases the clocks also for the last release.
+ **/
+int isp_put(void)
+{
+	DPRINTK_ISPCTRL("isp_put: old %d\n", isp_obj.ref_count);
+	mutex_lock(&(isp_obj.isp_mutex));
+	if (isp_obj.ref_count)
+		if (--isp_obj.ref_count == 0) {
+			isp_save_ctx();
+			off_mode = 1;
+
+			clk_disable(isp_obj.cam_ick);
+			clk_disable(isp_obj.cam_mclk);
+			clk_put(isp_obj.cam_ick);
+			clk_put(isp_obj.cam_mclk);
+		}
+	mutex_unlock(&(isp_obj.isp_mutex));
+	DPRINTK_ISPCTRL("isp_put: new %d\n", isp_obj.ref_count);
+	return isp_obj.ref_count;
+}
+EXPORT_SYMBOL(isp_put);
+
+/**
+ * isp_save_context - Saves the values of the ISP module registers.
+ * @reg_list: Structure containing pairs of register address and value to
+ *            modify on OMAP.
+ **/
+void isp_save_context(struct isp_reg *reg_list)
+{
+	struct isp_reg *next = reg_list;
+
+	for (; next->reg != ISP_TOK_TERM; next++)
+		next->val = omap_readl(next->reg);
+}
+EXPORT_SYMBOL(isp_save_context);
+
+/**
+ * isp_restore_context - Restores the values of the ISP module registers.
+ * @reg_list: Structure containing pairs of register address and value to
+ *            modify on OMAP.
+ **/
+void isp_restore_context(struct isp_reg *reg_list)
+{
+	struct isp_reg *next = reg_list;
+
+	for (; next->reg != ISP_TOK_TERM; next++)
+		omap_writel(next->val, next->reg);
+}
+EXPORT_SYMBOL(isp_restore_context);
+
+/**
+ * isp_init - ISP module initialization.
+ **/
+static int __init isp_init(void)
+{
+	DPRINTK_ISPCTRL("+isp_init for Omap 3430 Camera ISP\n");
+	isp_obj.ref_count = 0;
+
+	mutex_init(&(isp_obj.isp_mutex));
+	spin_lock_init(&isp_obj.isp_temp_buf_lock);
+
+	if (request_irq(INT_34XX_CAM_IRQ, omap34xx_isp_isr, IRQF_SHARED,
+				"Omap 34xx Camera ISP", &ispirq_obj)) {
+		DPRINTK_ISPCTRL("Could not install ISR\n");
+		return -EINVAL;
+	} else {
+		spin_lock_init(&isp_obj.lock);
+		DPRINTK_ISPCTRL("-isp_init for Omap 3430 Camera ISP\n");
+		return 0;
+	}
+}
+
+/**
+ * isp_cleanup - ISP module cleanup.
+ **/
+static void __exit isp_cleanup(void)
+{
+	free_irq(INT_34XX_CAM_IRQ, &ispirq_obj);
+}
+
+/**
+ * isp_print_status - Prints the values of the ISP Control Module registers
+ *
+ * Also prints other debug information stored in the ISP module structure.
+ **/
+void isp_print_status(void)
+{
+	if (!is_ispctrl_debug_enabled())
+		return;
+
+	DPRINTK_ISPCTRL("###CM_FCLKEN_CAM=0x%x\n", omap_readl(CM_FCLKEN_CAM));
+	DPRINTK_ISPCTRL("###CM_ICLKEN_CAM=0x%x\n", omap_readl(CM_ICLKEN_CAM));
+	DPRINTK_ISPCTRL("###CM_CLKSEL_CAM=0x%x\n", omap_readl(CM_CLKSEL_CAM));
+	DPRINTK_ISPCTRL("###CM_AUTOIDLE_CAM=0x%x\n",
+						omap_readl(CM_AUTOIDLE_CAM));
+	DPRINTK_ISPCTRL("###CM_CLKEN_PLL[18:16] should be 0x7, = 0x%x\n",
+						omap_readl(CM_CLKEN_PLL));
+	DPRINTK_ISPCTRL("###CM_CLKSEL2_PLL[18:8] should be 0x2D, [6:0] should "
+				"be 1 = 0x%x\n", omap_readl(CM_CLKSEL2_PLL));
+	DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_HS=0x%x\n",
+					omap_readl(CTRL_PADCONF_CAM_HS));
+	DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_XCLKA=0x%x\n",
+					omap_readl(CTRL_PADCONF_CAM_XCLKA));
+	DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D1=0x%x\n",
+					omap_readl(CTRL_PADCONF_CAM_D1));
+	DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D3=0x%x\n",
+					omap_readl(CTRL_PADCONF_CAM_D3));
+	DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D5=0x%x\n",
+					omap_readl(CTRL_PADCONF_CAM_D5));
+	DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D7=0x%x\n",
+					omap_readl(CTRL_PADCONF_CAM_D7));
+	DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D9=0x%x\n",
+					omap_readl(CTRL_PADCONF_CAM_D9));
+	DPRINTK_ISPCTRL("###CTRL_PADCONF_CAM_D11=0x%x\n",
+					omap_readl(CTRL_PADCONF_CAM_D11));
+}
+EXPORT_SYMBOL(isp_print_status);
+
+module_init(isp_init);
+module_exit(isp_cleanup);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("ISP Control Module Library");
+MODULE_LICENSE("GPL");
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/isp.h	2008-06-29 16:57:48.000000000 -0500
@@ -0,0 +1,326 @@
+/*
+ * drivers/media/video/isp/isp.h
+ *
+ * Top level public header file for ISP Control module in
+ * TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ * 	Sameer Venkatraman <sameerv@ti.com>
+ * 	Mohit Jalori <mjalori@ti.com>
+ * 	Sakari Ailus <sakari.ailus@nokia.com>
+ * 	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_TOP_H
+#define OMAP_ISP_TOP_H
+#include <media/videobuf-dma-sg.h>
+#include <linux/videodev2.h>
+#define OMAP_ISP_CCDC		(1 << 0)
+#define OMAP_ISP_PREVIEW	(1 << 1)
+#define OMAP_ISP_RESIZER	(1 << 2)
+#define OMAP_ISP_AEWB		(1 << 3)
+#define OMAP_ISP_AF		(1 << 4)
+#define OMAP_ISP_HIST		(1 << 5)
+
+/* Our ISP specific controls */
+#define V4L2_CID_PRIVATE_ISP_COLOR_FX		(V4L2_CID_PRIVATE_BASE + 0)
+
+/* ISP Private IOCTLs */
+#define VIDIOC_PRIVATE_ISP_CCDC_CFG	\
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 1, struct ispccdc_update_config)
+#define VIDIOC_PRIVATE_ISP_PRV_CFG \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 2, struct ispprv_update_config)
+#define VIDIOC_PRIVATE_ISP_AEWB_CFG \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 4, struct isph3a_aewb_config)
+#define VIDIOC_PRIVATE_ISP_AEWB_REQ \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 5, struct isph3a_aewb_data)
+#define VIDIOC_PRIVATE_ISP_HIST_CFG \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, struct isp_hist_config)
+#define VIDIOC_PRIVATE_ISP_HIST_REQ \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 7, struct isp_hist_data)
+#define VIDIOC_PRIVATE_ISP_AF_CFG \
+	_IO('V', BASE_VIDIOC_PRIVATE + 8)
+#define VIDIOC_PRIVATE_ISP_AF_REQ \
+	_IO('V', BASE_VIDIOC_PRIVATE + 9)
+
+#define ISP_TOK_TERM		0xFFFFFFFF	/*
+						 * terminating token for ISP
+						 * modules reg list
+						 */
+#define NUM_SG_DMA		(VIDEO_MAX_FRAME + 2)
+
+#define ISP_BUF_INIT		0
+#define ISP_FREE_RUNNING	1
+#define ISP_BUF_TRAN		2
+
+#ifndef CONFIG_ARCH_OMAP3410
+#define USE_ISP_PREVIEW
+#define USE_ISP_RESZ
+#define is_isppreview_enabled()		1
+#define is_ispresizer_enabled()		1
+#else
+#define is_isppreview_enabled()		0
+#define is_ispresizer_enabled()		0
+#endif
+
+#ifdef OMAP_ISPCTRL_DEBUG
+#define is_ispctrl_debug_enabled()		1
+#else
+#define is_ispctrl_debug_enabled()		0
+#endif
+
+#define ISP_XCLKA_DEFAULT		0x12
+#define ISP_OUTPUT_WIDTH_DEFAULT	176
+#define ISP_OUTPUT_HEIGHT_DEFAULT	144
+#define ISP_BYTES_PER_PIXEL		2
+#define NUM_ISP_CAPTURE_FORMATS 	(sizeof(isp_formats) /\
+							sizeof(isp_formats[0]))
+
+typedef int (*isp_vbq_callback_ptr) (struct videobuf_buffer *vb);
+typedef void (*isp_callback_t) (unsigned long status,
+					isp_vbq_callback_ptr arg1, void *arg2);
+
+enum isp_interface_type {
+	ISP_PARLL = 1,
+	ISP_CSIA = 2,
+	ISP_CSIB = 4
+};
+
+enum isp_irqevents {
+	CCDC_VD0 = 0x100,
+	CCDC_VD1 = 0x200,
+	CCDC_VD2 = 0x400,
+	CCDC_ERR = 0x800,
+	H3A_AWB_DONE = 0x2000,
+	HIST_DONE = 0x10000,
+	PREV_DONE = 0x100000,
+	LSC_DONE = 0x20000,
+	LSC_PRE_COMP = 0x40000,
+	LSC_PRE_ERR = 0x80000,
+	RESZ_DONE = 0x1000000,
+	SBL_OVF = 0x2000000,
+	MMU_ERR = 0x10000000,
+	OCP_ERR = 0x20000000,
+	HS_VS = 0x80000000
+};
+
+enum isp_callback_type {
+	CBK_CCDC_VD0,
+	CBK_CCDC_VD1,
+	CBK_PREV_DONE,
+	CBK_RESZ_DONE,
+	CBK_MMU_ERR,
+	CBK_H3A_AWB_DONE,
+	CBK_HIST_DONE,
+	CBK_HS_VS,
+	CBK_LSC_ISR
+};
+
+/**
+ * struct isp_reg - Structure for ISP register values.
+ * @reg: 32-bit Register address.
+ * @val: 32-bit Register value.
+ */
+struct isp_reg {
+	u32 reg;
+	u32 val;
+};
+
+/**
+ * struct isp_sgdma_state - SG-DMA state for each videobuffer + 2 overlays
+ * @isp_addr: ISP space address mapped by ISP MMU.
+ * @status: DMA return code mapped by ISP MMU.
+ * @callback: Pointer to ISP callback function.
+ * @arg: Pointer to argument passed to the specified callback function.
+ */
+struct isp_sgdma_state {
+	dma_addr_t isp_addr;
+	u32 status;
+	isp_callback_t callback;
+	void *arg;
+};
+
+/**
+ * struct isp_sgdma - ISP Scatter Gather DMA status.
+ * @isp_addr_capture: Array of ISP space addresses mapped by the ISP MMU.
+ * @lock: Spinlock used to check free_sgdma field.
+ * @free_sgdma: Number of free SG-DMA slots.
+ * @next_sgdma: Index of next SG-DMA slot to use.
+ */
+struct isp_sgdma {
+	dma_addr_t isp_addr_capture[VIDEO_MAX_FRAME];
+	spinlock_t lock;
+	int free_sgdma;
+	int next_sgdma;
+	struct isp_sgdma_state sg_state[NUM_SG_DMA];
+};
+
+/**
+ * struct isp_interface_config - ISP interface configuration.
+ * @ccdc_par_ser: ISP interface type. 0 - Parallel, 1 - CSIA, 2 - CSIB to CCDC.
+ * @par_bridge: CCDC Bridge input control. Parallel interface.
+ *                  0 - Disable, 1 - Enable, first byte->cam_d(bits 7 to 0)
+ *                  2 - Enable, first byte -> cam_d(bits 15 to 8)
+ * @par_clk_pol: Pixel clock polarity on the parallel interface.
+ *                    0 - Non Inverted, 1 - Inverted
+ * @dataline_shift: Data lane shifter.
+ *                      0 - No Shift, 1 - CAMEXT[13 to 2]->CAM[11 to 0]
+ *                      2 - CAMEXT[13 to 4]->CAM[9 to 0]
+ *                      3 - CAMEXT[13 to 6]->CAM[7 to 0]
+ * @hsvs_syncdetect: HS or VS synchronization signal detection.
+ *                       0 - HS Falling, 1 - HS rising
+ *                       2 - VS falling, 3 - VS rising
+ * @vdint0_timing: VD0 Interrupt timing.
+ * @vdint1_timing: VD1 Interrupt timing.
+ * @strobe: Strobe related parameter.
+ * @prestrobe: PreStrobe related parameter.
+ * @shutter: Shutter related parameter.
+ */
+struct isp_interface_config {
+	enum isp_interface_type ccdc_par_ser;
+	u8 dataline_shift;
+	u32 hsvs_syncdetect;
+	u16 vdint0_timing;
+	u16 vdint1_timing;
+	int strobe;
+	int prestrobe;
+	int shutter;
+	union {
+		struct par {
+			unsigned par_bridge:2;
+			unsigned par_clk_pol:1;
+		} par;
+		struct csi {
+			unsigned crc:1;
+			unsigned mode:1;
+			unsigned edge:1;
+			unsigned signalling:1;
+			unsigned strobe_clock_inv:1;
+			unsigned vs_edge:1;
+			unsigned channel:3;
+			unsigned vpclk:2;	/* Video port output clock */
+			unsigned int data_start;
+			unsigned int data_size;
+			u32 format;		/* V4L2_PIX_FMT_* */
+		} csi;
+	} u;
+};
+
+/**
+ * struct isp_sysc - ISP Power switches to set.
+ * @reset: Flag for setting ISP reset.
+ * @idle_mode: Flag for setting ISP idle mode.
+ */
+struct isp_sysc {
+	char reset;
+	char idle_mode;
+};
+
+void isp_open(void);
+
+void isp_close(void);
+
+void isp_start(void);
+
+void isp_stop(void);
+
+void isp_sgdma_init(void);
+
+void isp_vbq_done(unsigned long status, isp_vbq_callback_ptr arg1, void *arg2);
+
+void isp_sgdma_process(struct isp_sgdma *sgdma, int irq, int *dma_notify,
+						isp_vbq_callback_ptr func_ptr);
+
+int isp_sgdma_queue(struct videobuf_dmabuf *vdma, struct videobuf_buffer *vb,
+						int irq, int *dma_notify,
+						isp_vbq_callback_ptr func_ptr);
+
+int isp_vbq_prepare(struct videobuf_queue *vbq, struct videobuf_buffer *vb,
+							enum v4l2_field field);
+
+void isp_vbq_release(struct videobuf_queue *vbq, struct videobuf_buffer *vb);
+
+int isp_set_callback(enum isp_callback_type type, isp_callback_t callback,
+					isp_vbq_callback_ptr arg1, void *arg2);
+
+void omapisp_unset_callback(void);
+
+int isp_unset_callback(enum isp_callback_type type);
+
+u32 isp_set_xclk(u32 xclk, u8 xclksel);
+
+u32 isp_get_xclk(u8 xclksel);
+
+int isp_request_interface(enum isp_interface_type if_t);
+
+int isp_free_interface(enum isp_interface_type if_t);
+
+void isp_power_settings(struct isp_sysc);
+
+int isp_configure_interface(struct isp_interface_config *config);
+
+void isp_CCDC_VD01_disable(void);
+
+void isp_CCDC_VD01_enable(void);
+
+int isp_get(void);
+
+int isp_put(void);
+
+void isp_set_pipeline(int soc_type);
+
+void isp_config_pipeline(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output);
+
+int isp_queryctrl(struct v4l2_queryctrl *a);
+
+int isp_g_ctrl(struct v4l2_control *a);
+
+int isp_s_ctrl(struct v4l2_control *a);
+
+int isp_enum_fmt_cap(struct v4l2_fmtdesc *f);
+
+int isp_try_fmt_cap(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output);
+
+void isp_g_fmt_cap(struct v4l2_format *f);
+
+int isp_s_fmt_cap(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output);
+
+int isp_g_crop(struct v4l2_crop *a);
+
+int isp_s_crop(struct v4l2_crop *a, struct v4l2_pix_format *pix);
+
+void isp_config_crop(struct v4l2_pix_format *pix);
+
+int isp_try_size(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output);
+
+int isp_try_fmt(struct v4l2_pix_format *pix_input,
+					struct v4l2_pix_format *pix_output);
+
+int isp_handle_private(int cmd, void *arg);
+
+void isp_save_context(struct isp_reg *);
+
+void isp_restore_context(struct isp_reg *);
+
+void isp_save_ctx(void);
+
+void isp_restore_ctx(void);
+
+void isp_print_status(void);
+
+#endif	/* OMAP_ISP_TOP_H */
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/ispccdc.c	2008-06-29 17:44:57.000000000 -0500
@@ -0,0 +1,1296 @@
+/*
+ * drivers/media/video/isp/ispccdc.c
+ *
+ * Driver Library for CCDC module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *	Senthilvadivu Guruswamy <svadivu@ti.com>
+ *	Pallavi Kulkarni <p-kulkarni@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/types.h>
+#include <asm/mach-types.h>
+#include <asm/arch/clock.h>
+#include <linux/io.h>
+#include <linux/scatterlist.h>
+#include <linux/uaccess.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispccdc.h"
+#include "ispmmu.h"
+
+static u32 *fpc_table_add;
+static unsigned long fpc_table_add_m;
+
+/**
+ * struct isp_ccdc - Structure for the CCDC module to store its own information
+ * @ccdc_inuse: Flag to determine if CCDC has been reserved or not (0 or 1).
+ * @ccdcout_w: CCDC output width.
+ * @ccdcout_h: CCDC output height.
+ * @ccdcin_w: CCDC input width.
+ * @ccdcin_h: CCDC input height.
+ * @ccdcin_woffset: CCDC input horizontal offset.
+ * @ccdcin_hoffset: CCDC input vertical offset.
+ * @crop_w: Crop width.
+ * @crop_h: Crop weight.
+ * @ccdc_inpfmt: CCDC input format.
+ * @ccdc_outfmt: CCDC output format.
+ * @vpout_en: Video port output enable.
+ * @wen: Data write enable.
+ * @exwen: External data write enable.
+ * @refmt_en: Reformatter enable.
+ * @ccdcslave: CCDC slave mode enable.
+ * @syncif_ipmod: Image
+ * @obclamp_en: Data input format.
+ * @mutexlock: Mutex used to get access to the CCDC.
+ */
+static struct isp_ccdc {
+	u8 ccdc_inuse;
+	u32 ccdcout_w;
+	u32 ccdcout_h;
+	u32 ccdcin_w;
+	u32 ccdcin_h;
+	u32 ccdcin_woffset;
+	u32 ccdcin_hoffset;
+	u32 crop_w;
+	u32 crop_h;
+	u8 ccdc_inpfmt;
+	u8 ccdc_outfmt;
+	u8 vpout_en;
+	u8 wen;
+	u8 exwen;
+	u8 refmt_en;
+	u8 ccdcslave;
+	u8 syncif_ipmod;
+	u8 obclamp_en;
+	u8 lsc_en;
+	struct mutex mutexlock;
+} ispccdc_obj;
+
+/* Structure for saving/restoring CCDC module registers*/
+static struct isp_reg ispccdc_reg_list[] = {
+	{ISPCCDC_SYN_MODE, 0},
+	{ISPCCDC_HD_VD_WID, 0},
+	{ISPCCDC_PIX_LINES, 0},
+	{ISPCCDC_HORZ_INFO, 0},
+	{ISPCCDC_VERT_START, 0},
+	{ISPCCDC_VERT_LINES, 0},
+	{ISPCCDC_CULLING, 0},
+	{ISPCCDC_HSIZE_OFF, 0},
+	{ISPCCDC_SDOFST, 0},
+	{ISPCCDC_SDR_ADDR, 0},
+	{ISPCCDC_CLAMP, 0},
+	{ISPCCDC_DCSUB, 0},
+	{ISPCCDC_COLPTN, 0},
+	{ISPCCDC_BLKCMP, 0},
+	{ISPCCDC_FPC, 0},
+	{ISPCCDC_FPC_ADDR, 0},
+	{ISPCCDC_VDINT, 0},
+	{ISPCCDC_ALAW, 0},
+	{ISPCCDC_REC656IF, 0},
+	{ISPCCDC_CFG, 0},
+	{ISPCCDC_FMTCFG, 0},
+	{ISPCCDC_FMT_HORZ, 0},
+	{ISPCCDC_FMT_VERT, 0},
+	{ISPCCDC_FMT_ADDR0, 0},
+	{ISPCCDC_FMT_ADDR1, 0},
+	{ISPCCDC_FMT_ADDR2, 0},
+	{ISPCCDC_FMT_ADDR3, 0},
+	{ISPCCDC_FMT_ADDR4, 0},
+	{ISPCCDC_FMT_ADDR5, 0},
+	{ISPCCDC_FMT_ADDR6, 0},
+	{ISPCCDC_FMT_ADDR7, 0},
+	{ISPCCDC_PRGEVEN0, 0},
+	{ISPCCDC_PRGEVEN1, 0},
+	{ISPCCDC_PRGODD0, 0},
+	{ISPCCDC_PRGODD1, 0},
+	{ISPCCDC_VP_OUT, 0},
+	{ISPCCDC_LSC_CONFIG, 0},
+	{ISPCCDC_LSC_INITIAL, 0},
+	{ISPCCDC_LSC_TABLE_BASE, 0},
+	{ISPCCDC_LSC_TABLE_OFFSET, 0},
+	{ISP_TOK_TERM, 0}
+};
+
+/**
+ * omap34xx_isp_ccdc_config - Sets CCDC configuration from userspace
+ * @userspace_add: Structure containing CCDC configuration sent from userspace.
+ *
+ * Returns 0 if successful, -EINVAL if the pointer to the configuration
+ * structure is null, or the copy_from_user function fails to copy user space
+ * memory to kernel space memory.
+ **/
+int omap34xx_isp_ccdc_config(void *userspace_add)
+{
+	struct ispccdc_bclamp bclamp_t;
+	struct ispccdc_blcomp blcomp_t;
+	struct ispccdc_fpc fpc_t;
+	struct ispccdc_culling cull_t;
+	struct ispccdc_update_config *ccdc_struct;
+
+	if (userspace_add == NULL)
+		return -EINVAL;
+
+	ccdc_struct = (struct ispccdc_update_config *) userspace_add;
+
+	if ((ISP_ABS_CCDC_ALAW & ccdc_struct->flag) == ISP_ABS_CCDC_ALAW) {
+		if ((ISP_ABS_CCDC_ALAW & ccdc_struct->update) ==
+							ISP_ABS_CCDC_ALAW)
+			ispccdc_config_alaw(ccdc_struct->alawip);
+		ispccdc_enable_alaw(1);
+	} else if ((ISP_ABS_CCDC_ALAW & ccdc_struct->update) ==
+							ISP_ABS_CCDC_ALAW)
+		ispccdc_enable_alaw(0);
+
+	if ((ISP_ABS_CCDC_LPF & ccdc_struct->flag) == ISP_ABS_CCDC_LPF)
+		ispccdc_enable_lpf(1);
+	else
+		ispccdc_enable_lpf(0);
+
+	if ((ISP_ABS_CCDC_BLCLAMP & ccdc_struct->flag) ==
+		ISP_ABS_CCDC_BLCLAMP) {
+		if ((ISP_ABS_CCDC_BLCLAMP & ccdc_struct->update) ==
+			ISP_ABS_CCDC_BLCLAMP) {
+			if (copy_from_user(&bclamp_t, (struct ispccdc_bclamp *)
+						(ccdc_struct->bclamp),
+						sizeof(struct ispccdc_bclamp)))
+				goto copy_from_user_err;
+
+			ispccdc_config_black_clamp(bclamp_t);
+		}
+		ispccdc_enable_black_clamp(1);
+	} else if ((ISP_ABS_CCDC_BLCLAMP & ccdc_struct->update) ==
+							ISP_ABS_CCDC_BLCLAMP)
+			ispccdc_enable_black_clamp(0);
+
+	if ((ISP_ABS_CCDC_BCOMP & ccdc_struct->update) == ISP_ABS_CCDC_BCOMP) {
+		if (copy_from_user(&blcomp_t, (struct ispccdc_blcomp *)
+							(ccdc_struct->blcomp),
+							sizeof(blcomp_t)))
+			goto copy_from_user_err;
+
+		ispccdc_config_black_comp(blcomp_t);
+	}
+
+	if ((ISP_ABS_CCDC_FPC & ccdc_struct->flag) == ISP_ABS_CCDC_FPC) {
+		if ((ISP_ABS_CCDC_FPC & ccdc_struct->update) ==
+							ISP_ABS_CCDC_FPC) {
+			if (copy_from_user(&fpc_t, (struct ispccdc_fpc *)
+							(ccdc_struct->fpc),
+							sizeof(fpc_t)))
+				goto copy_from_user_err;
+			fpc_table_add = kmalloc((64 + (fpc_t.fpnum * 4)),
+							GFP_KERNEL | GFP_DMA);
+			if (!fpc_table_add) {
+				printk(KERN_ERR "Cannot allocate memory for"
+								" FPC table");
+				return -ENOMEM;
+			}
+			while (((int)fpc_table_add & 0xFFFFFFC0) !=
+							(int)fpc_table_add)
+				fpc_table_add++;
+
+			fpc_table_add_m = ispmmu_map(virt_to_phys
+							(fpc_table_add),
+							(fpc_t.fpnum) * 4);
+
+			if (copy_from_user(fpc_table_add, (u32 *)fpc_t.fpcaddr,
+							fpc_t.fpnum * 4))
+				goto copy_from_user_err;
+
+			fpc_t.fpcaddr = fpc_table_add_m;
+			ispccdc_config_fpc(fpc_t);
+		}
+		ispccdc_enable_fpc(1);
+	} else if ((ISP_ABS_CCDC_FPC & ccdc_struct->update) ==
+							ISP_ABS_CCDC_FPC)
+			ispccdc_enable_fpc(0);
+
+	if ((ISP_ABS_CCDC_CULL & ccdc_struct->update) == ISP_ABS_CCDC_CULL) {
+		if (copy_from_user(&cull_t, (struct ispccdc_culling *)
+							(ccdc_struct->cull),
+							sizeof(cull_t)))
+			goto copy_from_user_err;
+		ispccdc_config_culling(cull_t);
+	}
+
+	if ((ISP_ABS_CCDC_COLPTN & ccdc_struct->update) == ISP_ABS_CCDC_COLPTN)
+		ispccdc_config_imgattr(ccdc_struct->colptn);
+
+	return 0;
+
+copy_from_user_err:
+	printk(KERN_ERR "CCDC Config:Copy From User Error");
+	return -EINVAL ;
+}
+
+/**
+ * ispccdc_request - Reserves the CCDC module.
+ *
+ * Reserves the CCDC module and assures that is used only once at a time.
+ *
+ * Returns 0 if successful, or -EBUSY if CCDC module is busy.
+ **/
+int ispccdc_request(void)
+{
+	mutex_lock(&ispccdc_obj.mutexlock);
+	if (ispccdc_obj.ccdc_inuse) {
+		mutex_unlock(&ispccdc_obj.mutexlock);
+		DPRINTK_ISPCCDC("ISP_ERR : CCDC Module Busy");
+		return -EBUSY;
+	}
+
+	ispccdc_obj.ccdc_inuse = 1;
+	mutex_unlock(&ispccdc_obj.mutexlock);
+	omap_writel((omap_readl(ISP_CTRL)) | ISPCTRL_CCDC_RAM_EN |
+							ISPCTRL_CCDC_CLK_EN |
+							ISPCTRL_SBL_WR1_RAM_EN,
+							ISP_CTRL);
+	omap_writel((omap_readl(ISPCCDC_CFG)) | ISPCCDC_CFG_VDLC, ISPCCDC_CFG);
+	return 0;
+}
+EXPORT_SYMBOL(ispccdc_request);
+
+/**
+ * ispccdc_free - Frees the CCDC module.
+ *
+ * Frees the CCDC module so it can be used by another process.
+ *
+ * Returns 0 if successful, or -EINVAL if module has been already freed.
+ **/
+int ispccdc_free(void)
+{
+	mutex_lock(&ispccdc_obj.mutexlock);
+	if (!ispccdc_obj.ccdc_inuse) {
+		mutex_unlock(&ispccdc_obj.mutexlock);
+		DPRINTK_ISPCCDC("ISP_ERR: CCDC Module already freed\n");
+		return -EINVAL;
+	}
+
+	ispccdc_obj.ccdc_inuse = 0;
+	mutex_unlock(&ispccdc_obj.mutexlock);
+	omap_writel((omap_readl(ISP_CTRL)) & ~(ISPCTRL_CCDC_CLK_EN |
+						ISPCTRL_CCDC_RAM_EN |
+						ISPCTRL_SBL_WR1_RAM_EN),
+						ISP_CTRL);
+	return 0;
+}
+EXPORT_SYMBOL(ispccdc_free);
+
+/**
+ * ispccdc_config_crop - Configures crop parameters for the ISP CCDC.
+ * @left: Left offset of the crop area.
+ * @top: Top offset of the crop area.
+ * @height: Height of the crop area.
+ * @width: Width of the crop area.
+ *
+ * The following restrictions are applied for the crop settings. If incoming
+ * values do not follow these restrictions then we map the settings to the
+ * closest acceptable crop value.
+ * 1) Left offset is always odd. This can be avoided if we enable byte swap
+ *    option for incoming data into CCDC.
+ * 2) Top offset is always even.
+ * 3) Crop height is always even.
+ * 4) Crop width is always a multiple of 16 pixels
+ **/
+void ispccdc_config_crop(u32 left, u32 top, u32 height, u32 width)
+{
+	ispccdc_obj.ccdcin_woffset = left + ((left + 1) % 2);
+	ispccdc_obj.ccdcin_hoffset = top + (top % 2);
+
+	ispccdc_obj.crop_w = width - (width % 16);
+	ispccdc_obj.crop_h = height + (height % 2);
+
+	DPRINTK_ISPCCDC("\n\tOffsets L %d T %d W %d H %d\n",
+						ispccdc_obj.ccdcin_woffset,
+						ispccdc_obj.ccdcin_hoffset,
+						ispccdc_obj.crop_w,
+						ispccdc_obj.crop_h);
+}
+
+/**
+ * ispccdc_config_datapath - Specifies the input and output modules for CCDC.
+ * @input: Indicates the module that inputs the image to the CCDC.
+ * @output: Indicates the module to which the CCDC outputs the image.
+ *
+ * Configures the default configuration for the CCDC to work with.
+ *
+ * The valid values for the input are CCDC_RAW (0), CCDC_YUV_SYNC (1),
+ * CCDC_YUV_BT (2), and CCDC_OTHERS (3).
+ *
+ * The valid values for the output are CCDC_YUV_RSZ (0), CCDC_YUV_MEM_RSZ (1),
+ * CCDC_OTHERS_VP (2), CCDC_OTHERS_MEM (3), CCDC_OTHERS_VP_MEM (4).
+ *
+ * Returns 0 if successful, or -EINVAL if wrong I/O combination or wrong input
+ * or output values.
+ **/
+int ispccdc_config_datapath(enum ccdc_input input, enum ccdc_output output)
+{
+	u32 syn_mode = 0;
+	struct ispccdc_vp vpcfg;
+	struct ispccdc_syncif syncif;
+	struct ispccdc_bclamp blkcfg;
+
+	u32 colptn = (ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP0PLC0_SHIFT) |
+		(ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP0PLC1_SHIFT) |
+		(ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP0PLC2_SHIFT) |
+		(ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP0PLC3_SHIFT) |
+		(ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP1PLC0_SHIFT) |
+		(ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP1PLC1_SHIFT) |
+		(ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP1PLC2_SHIFT) |
+		(ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP1PLC3_SHIFT) |
+		(ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP2PLC0_SHIFT) |
+		(ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP2PLC1_SHIFT) |
+		(ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP2PLC2_SHIFT) |
+		(ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP2PLC3_SHIFT) |
+		(ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP3PLC0_SHIFT) |
+		(ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP3PLC1_SHIFT) |
+		(ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP3PLC2_SHIFT) |
+		(ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP3PLC3_SHIFT);
+
+	/* CCDC does not convert the image format */
+	if (((input == CCDC_RAW) || (input == CCDC_OTHERS)) &&
+						(output == CCDC_YUV_RSZ)) {
+		DPRINTK_ISPCCDC("ISP_ERR: Wrong CCDC I/O Combination\n");
+		return -EINVAL;
+	}
+
+	syn_mode = omap_readl(ISPCCDC_SYN_MODE);
+
+	switch (output) {
+	case CCDC_YUV_RSZ:
+		syn_mode |= ISPCCDC_SYN_MODE_SDR2RSZ;
+		syn_mode &= ~ISPCCDC_SYN_MODE_WEN;
+		break;
+
+	case CCDC_YUV_MEM_RSZ:
+		syn_mode |= ISPCCDC_SYN_MODE_SDR2RSZ;
+		ispccdc_obj.wen = 1;
+		syn_mode |= ISPCCDC_SYN_MODE_WEN;
+		break;
+
+	case CCDC_OTHERS_VP:
+		syn_mode &= ~ISPCCDC_SYN_MODE_VP2SDR;
+		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
+		syn_mode &= ~ISPCCDC_SYN_MODE_WEN;
+		vpcfg.bitshift_sel = BIT9_0;
+		vpcfg.freq_sel = PIXCLKBY2;
+		ispccdc_config_vp(vpcfg);
+		ispccdc_enable_vp(1);
+		break;
+
+	case CCDC_OTHERS_MEM:
+		syn_mode &= ~ISPCCDC_SYN_MODE_VP2SDR;
+		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
+		syn_mode |= ISPCCDC_SYN_MODE_WEN;
+		syn_mode |= ISPCCDC_SYN_MODE_EXWEN;
+		omap_writel((omap_readl(ISPCCDC_CFG)) | ISPCCDC_CFG_WENLOG,
+								ISPCCDC_CFG);
+		break;
+
+	case CCDC_OTHERS_VP_MEM:
+		syn_mode |= ISPCCDC_SYN_MODE_VP2SDR;
+		syn_mode |= ISPCCDC_SYN_MODE_WEN;
+		syn_mode |= ISPCCDC_SYN_MODE_EXWEN;
+		omap_writel((omap_readl(ISPCCDC_CFG)) | ISPCCDC_CFG_WENLOG,
+								ISPCCDC_CFG);
+		vpcfg.bitshift_sel = BIT9_0;
+		vpcfg.freq_sel = PIXCLKBY2;
+		ispccdc_config_vp(vpcfg);
+		ispccdc_enable_vp(1);
+		break;
+	default:
+		DPRINTK_ISPCCDC("ISP_ERR: Wrong CCDC Output");
+		return -EINVAL;
+	};
+
+	omap_writel(syn_mode, ISPCCDC_SYN_MODE);
+
+	switch (input) {
+	case CCDC_RAW:
+		syncif.ccdc_mastermode = 0;
+		syncif.datapol = 0;
+		syncif.datsz = DAT10;
+		syncif.fldmode = 0;
+		syncif.fldout = 0;
+		syncif.fldpol = 0;
+		syncif.fldstat = 0;
+		syncif.hdpol = 0;
+		syncif.ipmod = RAW;
+		syncif.vdpol = 0;
+		ispccdc_config_sync_if(syncif);
+		ispccdc_config_imgattr(colptn);
+		blkcfg.dcsubval = 42;
+		ispccdc_config_black_clamp(blkcfg);
+		break;
+	case CCDC_YUV_SYNC:
+		syncif.ccdc_mastermode = 0;
+		syncif.datapol = 0;
+		syncif.datsz = DAT8;
+		syncif.fldmode = 0;
+		syncif.fldout = 0;
+		syncif.fldpol = 0;
+		syncif.fldstat = 0;
+		syncif.hdpol = 0;
+		syncif.ipmod = YUV16;
+		syncif.vdpol = 0;
+		ispccdc_config_imgattr(0);
+		ispccdc_config_sync_if(syncif);
+		blkcfg.dcsubval = 0;
+		ispccdc_config_black_clamp(blkcfg);
+		break;
+	case CCDC_YUV_BT:
+		break;
+	case CCDC_OTHERS:
+		break;
+	default:
+		DPRINTK_ISPCCDC("ISP_ERR: Wrong CCDC Input");
+		return -EINVAL;
+	}
+
+	ispccdc_obj.ccdc_inpfmt = input;
+	ispccdc_obj.ccdc_outfmt = output;
+		ispccdc_print_status();
+		isp_print_status();
+	return 0;
+}
+EXPORT_SYMBOL(ispccdc_config_datapath);
+
+/**
+ * ispccdc_config_sync_if - Sets the sync i/f params between sensor and CCDC.
+ * @syncif: Structure containing the sync parameters like field state, CCDC in
+ *          master/slave mode, raw/yuv data, polarity of data, field, hs, vs
+ *          signals.
+ **/
+void ispccdc_config_sync_if(struct ispccdc_syncif syncif)
+{
+	u32 syn_mode = omap_readl(ISPCCDC_SYN_MODE);
+
+	syn_mode |= ISPCCDC_SYN_MODE_VDHDEN;
+
+	if (syncif.fldstat)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDSTAT;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_FLDSTAT;
+
+	syn_mode &= ISPCCDC_SYN_MODE_INPMOD_MASK;
+	ispccdc_obj.syncif_ipmod = syncif.ipmod;
+
+	switch (syncif.ipmod) {
+	case RAW:
+		break;
+	case YUV16:
+		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
+		break;
+	case YUV8:
+		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
+		break;
+	};
+
+	syn_mode &= ISPCCDC_SYN_MODE_DATSIZ_MASK;
+	switch (syncif.datsz) {
+	case DAT8:
+		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_8;
+		break;
+	case DAT10:
+		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_10;
+		break;
+	case DAT11:
+		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_11;
+		break;
+	case DAT12:
+		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_12;
+		break;
+	};
+
+	if (syncif.fldmode)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_FLDMODE;
+
+	if (syncif.datapol)
+		syn_mode |= ISPCCDC_SYN_MODE_DATAPOL;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_DATAPOL;
+
+	if (syncif.fldpol)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDPOL;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_FLDPOL;
+
+	if (syncif.hdpol)
+		syn_mode |= ISPCCDC_SYN_MODE_HDPOL;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_HDPOL;
+
+	if (syncif.vdpol)
+		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_VDPOL;
+
+	if (syncif.ccdc_mastermode) {
+		syn_mode |= ISPCCDC_SYN_MODE_FLDOUT | ISPCCDC_SYN_MODE_VDHDOUT;
+		omap_writel((syncif.hs_width << ISPCCDC_HD_VD_WID_HDW_SHIFT)
+						| (syncif.vs_width <<
+						ISPCCDC_HD_VD_WID_VDW_SHIFT),
+						ISPCCDC_HD_VD_WID);
+
+		omap_writel(syncif.ppln << ISPCCDC_PIX_LINES_PPLN_SHIFT
+			| syncif.hlprf << ISPCCDC_PIX_LINES_HLPRF_SHIFT,
+			ISPCCDC_PIX_LINES);
+	} else
+		syn_mode &= ~(ISPCCDC_SYN_MODE_FLDOUT |
+						ISPCCDC_SYN_MODE_VDHDOUT);
+
+	omap_writel(syn_mode, ISPCCDC_SYN_MODE);
+
+	if (!(syncif.bt_r656_en)) {
+		omap_writel((omap_readl(ISPCCDC_REC656IF)) &
+						~ISPCCDC_REC656IF_R656ON,
+						ISPCCDC_REC656IF);
+	}
+}
+EXPORT_SYMBOL(ispccdc_config_sync_if);
+
+/**
+ * ispccdc_config_black_clamp - Configures the clamp parameters in CCDC.
+ * @bclamp: Structure containing the optical black average gain, optical black
+ *          sample length, sample lines, and the start pixel position of the
+ *          samples w.r.t the HS pulse.
+ * Configures the clamp parameters in CCDC. Either if its being used the
+ * optical black clamp, or the digital clamp. If its a digital clamp, then
+ * assures to put a valid DC substraction level.
+ *
+ * Returns always 0 when completed.
+ **/
+int ispccdc_config_black_clamp(struct ispccdc_bclamp bclamp)
+{
+	u32 bclamp_val = 0;
+
+	if (ispccdc_obj.obclamp_en) {
+		bclamp_val |= bclamp.obgain << ISPCCDC_CLAMP_OBGAIN_SHIFT;
+		bclamp_val |= bclamp.oblen << ISPCCDC_CLAMP_OBSLEN_SHIFT;
+		bclamp_val |= bclamp.oblines << ISPCCDC_CLAMP_OBSLN_SHIFT;
+		bclamp_val |= bclamp.obstpixel << ISPCCDC_CLAMP_OBST_SHIFT;
+		omap_writel(bclamp_val, ISPCCDC_CLAMP);
+	} else {
+		if (is_sil_rev_less_than(OMAP3430_REV_ES2_0))
+			if ((ispccdc_obj.syncif_ipmod == YUV16) ||
+					(ispccdc_obj.syncif_ipmod == YUV8) ||
+					((omap_readl(ISPCCDC_REC656IF) &
+					ISPCCDC_REC656IF_R656ON) ==
+					ISPCCDC_REC656IF_R656ON))
+				bclamp.dcsubval = 0;
+		omap_writel(bclamp.dcsubval, ISPCCDC_DCSUB);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(ispccdc_config_black_clamp);
+
+/**
+ * ispccdc_enable_black_clamp - Enables/Disables the optical black clamp.
+ * @enable: 0 Disables optical black clamp, 1 Enables optical black clamp.
+ *
+ * Enables or disables the optical black clamp. When disabled, the digital
+ * clamp operates.
+ **/
+void ispccdc_enable_black_clamp(u8 enable)
+{
+	if (enable) {
+		omap_writel((omap_readl(ISPCCDC_CLAMP))|ISPCCDC_CLAMP_CLAMPEN,
+								ISPCCDC_CLAMP);
+		ispccdc_obj.obclamp_en = 1;
+	} else {
+		omap_writel((omap_readl(ISPCCDC_CLAMP)) &
+					~ISPCCDC_CLAMP_CLAMPEN, ISPCCDC_CLAMP);
+		ispccdc_obj.obclamp_en = 0;
+	}
+}
+EXPORT_SYMBOL(ispccdc_enable_black_clamp);
+
+/**
+ * ispccdc_config_fpc - Configures the Faulty Pixel Correction parameters.
+ * @fpc: Structure containing the number of faulty pixels corrected in the
+ *       frame, address of the FPC table.
+ *
+ * Returns 0 if successful, or -EINVAL if FPC Address is not on the 64 byte
+ * boundary.
+ **/
+int ispccdc_config_fpc(struct ispccdc_fpc fpc)
+{
+	u32 fpc_val = 0;
+
+	fpc_val = omap_readl(ISPCCDC_FPC);
+
+	if ((fpc.fpcaddr & 0xFFFFFFC0) == fpc.fpcaddr) {
+		omap_writel(fpc_val&(~ISPCCDC_FPC_FPCEN), ISPCCDC_FPC);
+		omap_writel(fpc.fpcaddr, ISPCCDC_FPC_ADDR);
+	} else {
+		DPRINTK_ISPCCDC("FPC Address should be on 64byte boundary\n");
+		return -EINVAL;
+	}
+	omap_writel(fpc_val | (fpc.fpnum << ISPCCDC_FPC_FPNUM_SHIFT),
+								ISPCCDC_FPC);
+	return 0;
+}
+EXPORT_SYMBOL(ispccdc_config_fpc);
+
+/**
+ * ispccdc_enable_fpc - Enables the Faulty Pixel Correction.
+ * @enable: 0 Disables FPC, 1 Enables FPC.
+ **/
+void ispccdc_enable_fpc(u8 enable)
+{
+	if (enable) {
+		omap_writel(omap_readl(ISPCCDC_FPC) | ISPCCDC_FPC_FPCEN,
+								ISPCCDC_FPC);
+	} else {
+		omap_writel(omap_readl(ISPCCDC_FPC) & ~ISPCCDC_FPC_FPCEN,
+								ISPCCDC_FPC);
+	}
+}
+EXPORT_SYMBOL(ispccdc_enable_fpc);
+
+/**
+ * ispccdc_config_black_comp - Configures Black Level Compensation parameters.
+ * @blcomp: Structure containing the black level compensation value for RGrGbB
+ *          pixels. in 2's complement.
+ **/
+void ispccdc_config_black_comp(struct ispccdc_blcomp blcomp)
+{
+	u32 blcomp_val = 0;
+
+	blcomp_val |= blcomp.b_mg << ISPCCDC_BLKCMP_B_MG_SHIFT;
+	blcomp_val |= blcomp.gb_g << ISPCCDC_BLKCMP_GB_G_SHIFT;
+	blcomp_val |= blcomp.gr_cy << ISPCCDC_BLKCMP_GR_CY_SHIFT;
+	blcomp_val |= blcomp.r_ye << ISPCCDC_BLKCMP_R_YE_SHIFT;
+
+	omap_writel(blcomp_val, ISPCCDC_BLKCMP);
+}
+EXPORT_SYMBOL(ispccdc_config_black_comp);
+
+/**
+ * ispccdc_config_vp - Configures the Video Port Configuration parameters.
+ * @vpcfg: Structure containing the Video Port input frequency, and the 10 bit
+ *         format.
+ **/
+void ispccdc_config_vp(struct ispccdc_vp vpcfg)
+{
+	u32 fmtcfg_vp = omap_readl(ISPCCDC_FMTCFG);
+
+	fmtcfg_vp &= ISPCCDC_FMTCFG_VPIN_MASK & ISPCCDC_FMTCF_VPIF_FRQ_MASK;
+
+	switch (vpcfg.bitshift_sel) {
+	case BIT9_0:
+		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_9_0;
+		break;
+	case BIT10_1:
+		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_10_1;
+		break;
+	case BIT11_2:
+		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_11_2;
+		break;
+	case BIT12_3:
+		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_12_3;
+		break;
+	};
+	switch (vpcfg.freq_sel) {
+	case PIXCLKBY2:
+		fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY2;
+		break;
+	case PIXCLKBY3_5:
+		fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY3;
+		break;
+	case PIXCLKBY4_5:
+		fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY4;
+		break;
+	case PIXCLKBY5_5:
+		fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY5;
+		break;
+	case PIXCLKBY6_5:
+		fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY6;
+		break;
+	};
+	omap_writel(fmtcfg_vp, ISPCCDC_FMTCFG);
+}
+EXPORT_SYMBOL(ispccdc_config_vp);
+
+/**
+ * ispccdc_enable_vp - Enables the Video Port.
+ * @enable: 0 Disables VP, 1 Enables VP
+ **/
+void ispccdc_enable_vp(u8 enable)
+{
+	if (enable) {
+		omap_writel((omap_readl(ISPCCDC_FMTCFG)) |
+					ISPCCDC_FMTCFG_VPEN, ISPCCDC_FMTCFG);
+	} else {
+		omap_writel(omap_readl(ISPCCDC_FMTCFG) &
+					~ISPCCDC_FMTCFG_VPEN, ISPCCDC_FMTCFG);
+	}
+}
+EXPORT_SYMBOL(ispccdc_enable_vp);
+
+/**
+ * ispccdc_config_reformatter - Configures the Reformatter.
+ * @refmt: Structure containing the memory address to format and the bit fields
+ *         for the reformatter registers.
+ *
+ * Configures the Reformatter register values if line alternating is disabled.
+ * Else, just enabling line alternating is enough.
+ **/
+void ispccdc_config_reformatter(struct ispccdc_refmt refmt)
+{
+	u32 fmtcfg_val = 0;
+
+	fmtcfg_val = omap_readl(ISPCCDC_FMTCFG);
+
+	if (refmt.lnalt)
+		fmtcfg_val |= ISPCCDC_FMTCFG_LNALT;
+	else {
+		fmtcfg_val &= ~ISPCCDC_FMTCFG_LNALT;
+		fmtcfg_val &= 0xFFFFF003;
+		fmtcfg_val |= refmt.lnum << ISPCCDC_FMTCFG_LNUM_SHIFT;
+		fmtcfg_val |= refmt.plen_even <<
+						ISPCCDC_FMTCFG_PLEN_EVEN_SHIFT;
+		fmtcfg_val |= refmt.plen_odd << ISPCCDC_FMTCFG_PLEN_ODD_SHIFT;
+
+		omap_writel(refmt.prgeven0, ISPCCDC_PRGEVEN0);
+		omap_writel(refmt.prgeven1, ISPCCDC_PRGEVEN1);
+		omap_writel(refmt.prgodd0, ISPCCDC_PRGODD0);
+		omap_writel(refmt.prgodd1, ISPCCDC_PRGODD1);
+		omap_writel(refmt.fmtaddr0, ISPCCDC_FMT_ADDR0);
+		omap_writel(refmt.fmtaddr1, ISPCCDC_FMT_ADDR1);
+		omap_writel(refmt.fmtaddr2, ISPCCDC_FMT_ADDR2);
+		omap_writel(refmt.fmtaddr3, ISPCCDC_FMT_ADDR3);
+		omap_writel(refmt.fmtaddr4, ISPCCDC_FMT_ADDR4);
+		omap_writel(refmt.fmtaddr5, ISPCCDC_FMT_ADDR5);
+		omap_writel(refmt.fmtaddr6, ISPCCDC_FMT_ADDR6);
+		omap_writel(refmt.fmtaddr7, ISPCCDC_FMT_ADDR7);
+	}
+	omap_writel(fmtcfg_val, ISPCCDC_FMTCFG);
+}
+EXPORT_SYMBOL(ispccdc_config_reformatter);
+
+/**
+ * ispccdc_enable_reformatter - Enables the Reformatter.
+ * @enable: 0 Disables Reformatter, 1- Enables Data Reformatter
+ **/
+void ispccdc_enable_reformatter(u8 enable)
+{
+	if (enable) {
+		omap_writel((omap_readl(ISPCCDC_FMTCFG)) |
+							ISPCCDC_FMTCFG_FMTEN,
+							ISPCCDC_FMTCFG);
+		ispccdc_obj.refmt_en = 1;
+	} else {
+		omap_writel((omap_readl(ISPCCDC_FMTCFG)) &
+							~ISPCCDC_FMTCFG_FMTEN,
+							ISPCCDC_FMTCFG);
+		ispccdc_obj.refmt_en = 0;
+	}
+}
+EXPORT_SYMBOL(ispccdc_enable_reformatter);
+
+/**
+ * ispccdc_config_culling - Configures the culling parameters.
+ * @cull: Structure containing the vertical culling pattern, and horizontal
+ *        culling pattern for odd and even lines.
+ **/
+void ispccdc_config_culling(struct ispccdc_culling cull)
+{
+	u32 culling_val = 0;
+
+	culling_val |= cull.v_pattern << ISPCCDC_CULLING_CULV_SHIFT;
+	culling_val |= cull.h_even << ISPCCDC_CULLING_CULHEVN_SHIFT;
+	culling_val |= cull.h_odd << ISPCCDC_CULLING_CULHODD_SHIFT;
+
+	omap_writel(culling_val, ISPCCDC_CULLING);
+}
+EXPORT_SYMBOL(ispccdc_config_culling);
+
+/**
+ * ispccdc_enable_lpf - Enables the Low-Pass Filter (LPF).
+ * @enable: 0 Disables LPF, 1 Enables LPF
+ **/
+void ispccdc_enable_lpf(u8 enable)
+{
+	if (enable) {
+		omap_writel(omap_readl(ISPCCDC_SYN_MODE) |
+							ISPCCDC_SYN_MODE_LPF,
+							ISPCCDC_SYN_MODE);
+	} else {
+		omap_writel(omap_readl(ISPCCDC_SYN_MODE) &
+							~ISPCCDC_SYN_MODE_LPF,
+							ISPCCDC_SYN_MODE);
+	}
+}
+EXPORT_SYMBOL(ispccdc_enable_lpf);
+
+/**
+ * ispccdc_config_alaw - Configures the input width for A-law.
+ * @ipwidth: Input width for A-law
+ **/
+void ispccdc_config_alaw(enum alaw_ipwidth ipwidth)
+{
+	omap_writel(ipwidth << ISPCCDC_ALAW_GWDI_SHIFT, ISPCCDC_ALAW);
+}
+EXPORT_SYMBOL(ispccdc_config_alaw);
+
+/**
+ * ispccdc_enable_alaw - Enables the A-law compression.
+ * @enable: 0 - Disables A-law, 1 - Enables A-law
+ **/
+void ispccdc_enable_alaw(u8 enable)
+{
+	if (enable) {
+		omap_writel((omap_readl(ISPCCDC_ALAW)) | ISPCCDC_ALAW_CCDTBL,
+								ISPCCDC_ALAW);
+	} else {
+		omap_writel((omap_readl(ISPCCDC_ALAW)) & ~ISPCCDC_ALAW_CCDTBL,
+								ISPCCDC_ALAW);
+	}
+}
+EXPORT_SYMBOL(ispccdc_enable_alaw);
+
+/**
+ * ispccdc_config_imgattr - Configures the sensor image specific attributes.
+ * @colptn: Color pattern of the sensor.
+ **/
+void ispccdc_config_imgattr(u32 colptn)
+{
+	omap_writel(colptn, ISPCCDC_COLPTN);
+}
+EXPORT_SYMBOL(ispccdc_config_imgattr);
+
+/**
+ * ispccdc_config_shadow_registers - Programs the shadow registers for CCDC.
+ **/
+void ispccdc_config_shadow_registers(void)
+{
+	return;
+}
+EXPORT_SYMBOL(ispccdc_config_shadow_registers);
+
+/**
+ * ispccdc_try_size - Checks if requested Input/output dimensions are valid
+ * @input_w: input width for the CCDC in number of pixels per line
+ * @input_h: input height for the CCDC in number of lines
+ * @output_w: output width from the CCDC in number of pixels per line
+ * @output_h: output height for the CCDC in number of lines
+ *
+ * Calculates the number of pixels cropped if the reformater is disabled,
+ * Fills up the output width and height variables in the isp_ccdc structure.
+ *
+ * Returns 0 if successful, or -EINVAL if the input width is less than 2 pixels
+ **/
+int ispccdc_try_size(u32 input_w, u32 input_h, u32 *output_w, u32 *output_h)
+{
+	if (input_w < 2) {
+		DPRINTK_ISPCCDC("ISP_ERR: CCDC cannot handle input width less"
+							" than 2 pixels\n");
+		return -EINVAL;
+	}
+
+	if (ispccdc_obj.crop_w)
+		*output_w = ispccdc_obj.crop_w;
+	else
+		*output_w = input_w;
+
+	if (ispccdc_obj.crop_h)
+		*output_h = ispccdc_obj.crop_h;
+	else
+		*output_h = input_h;
+
+	if ((!ispccdc_obj.refmt_en) && (ispccdc_obj.ccdc_outfmt !=
+							CCDC_OTHERS_MEM))
+		*output_h -= 1;
+
+	if ((ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_MEM) ||
+						(ispccdc_obj.ccdc_outfmt ==
+						CCDC_OTHERS_VP_MEM)) {
+		if (*output_w % 16) {
+			*output_w -= (*output_w % 16);
+			*output_w += 16;
+		}
+	}
+
+	ispccdc_obj.ccdcout_w = *output_w;
+	ispccdc_obj.ccdcout_h = *output_h;
+	ispccdc_obj.ccdcin_w = input_w;
+	ispccdc_obj.ccdcin_h = input_h;
+
+	DPRINTK_ISPCCDC("try size: ccdcin_w=%u,ccdcin_h=%u,ccdcout_w=%u,"
+							" ccdcout_h=%u\n",
+							ispccdc_obj.ccdcin_w,
+							ispccdc_obj.ccdcin_h,
+							ispccdc_obj.ccdcout_w,
+							ispccdc_obj.ccdcout_h);
+
+	return 0;
+}
+EXPORT_SYMBOL(ispccdc_try_size);
+
+/**
+ * ispccdc_config_size - Configure the dimensions of the CCDC input/output
+ * @input_w: input width for the CCDC in number of pixels per line
+ * @input_h: input height for the CCDC in number of lines
+ * @output_w: output width from the CCDC in number of pixels per line
+ * @output_h: output height for the CCDC in number of lines
+ *
+ * Configures the appropriate values stored in the isp_ccdc structure to
+ * HORZ/VERT_INFO registers and the VP_OUT depending on whether the image
+ * is stored in memory or given to the another module in the ISP pipeline.
+ *
+ * Returns 0 if successful, or -EINVAL if try_size was not called before to
+ * validate the requested dimensions.
+ **/
+int ispccdc_config_size(u32 input_w, u32 input_h, u32 output_w, u32 output_h)
+{
+	DPRINTK_ISPCCDC("config size: input_w=%u, input_h=%u, output_w=%u,"
+							" output_h=%u\n",
+							input_w, input_h,
+							output_w, output_h);
+	if ((output_w != ispccdc_obj.ccdcout_w) || (output_h !=
+						ispccdc_obj.ccdcout_h)) {
+		DPRINTK_ISPCCDC("ISP_ERR : ispccdc_try_size should"
+					" be called before config size\n");
+		return -EINVAL;
+	}
+
+	if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_VP) {
+		omap_writel((ispccdc_obj.ccdcin_woffset <<
+					ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
+					(ispccdc_obj.ccdcin_w <<
+					ISPCCDC_FMT_HORZ_FMTLNH_SHIFT),
+					ISPCCDC_FMT_HORZ);
+		omap_writel((ispccdc_obj.ccdcin_hoffset <<
+					ISPCCDC_FMT_VERT_FMTSLV_SHIFT) |
+					(ispccdc_obj.ccdcin_h <<
+					ISPCCDC_FMT_VERT_FMTLNV_SHIFT),
+					ISPCCDC_FMT_VERT);
+		omap_writel((ispccdc_obj.ccdcout_w <<
+					ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
+					(ispccdc_obj.ccdcout_h <<
+					ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
+					ISPCCDC_VP_OUT);
+		omap_writel((((ispccdc_obj.ccdcout_h - 25) &
+					ISPCCDC_VDINT_0_MASK) <<
+					ISPCCDC_VDINT_0_SHIFT) |
+					((50 & ISPCCDC_VDINT_1_MASK) <<
+					ISPCCDC_VDINT_1_SHIFT), ISPCCDC_VDINT);
+
+	} else if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_MEM) {
+		omap_writel(1 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
+						((ispccdc_obj.ccdcout_w - 1) <<
+						ISPCCDC_HORZ_INFO_NPH_SHIFT),
+						ISPCCDC_HORZ_INFO);
+		omap_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
+							ISPCCDC_VERT_START);
+		omap_writel((ispccdc_obj.ccdcout_h - 1) <<
+						ISPCCDC_VERT_LINES_NLV_SHIFT,
+						ISPCCDC_VERT_LINES);
+
+		ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2, 0, 0);
+		omap_writel((((ispccdc_obj.ccdcout_h - 1) &
+					ISPCCDC_VDINT_0_MASK) <<
+					ISPCCDC_VDINT_0_SHIFT) |
+					((50 & ISPCCDC_VDINT_1_MASK) <<
+					ISPCCDC_VDINT_1_SHIFT), ISPCCDC_VDINT);
+	} else if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_VP_MEM) {
+		omap_writel((1 << ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
+					(ispccdc_obj.ccdcin_w <<
+					ISPCCDC_FMT_HORZ_FMTLNH_SHIFT),
+					ISPCCDC_FMT_HORZ);
+		omap_writel((0 << ISPCCDC_FMT_VERT_FMTSLV_SHIFT) |
+					((ispccdc_obj.ccdcin_h) <<
+					ISPCCDC_FMT_VERT_FMTLNV_SHIFT),
+					ISPCCDC_FMT_VERT);
+		omap_writel((ispccdc_obj.ccdcout_w
+					<< ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
+					(ispccdc_obj.ccdcout_h <<
+					ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
+					ISPCCDC_VP_OUT);
+		omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
+					((ispccdc_obj.ccdcout_w - 1) <<
+					ISPCCDC_HORZ_INFO_NPH_SHIFT),
+					ISPCCDC_HORZ_INFO);
+		omap_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
+					ISPCCDC_VERT_START);
+		omap_writel((ispccdc_obj.ccdcout_h - 1) <<
+					ISPCCDC_VERT_LINES_NLV_SHIFT,
+					ISPCCDC_VERT_LINES);
+		ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2, 0, 0);
+		omap_writel((((ispccdc_obj.ccdcout_h - 25) &
+					ISPCCDC_VDINT_0_MASK) <<
+					ISPCCDC_VDINT_0_SHIFT) |
+					((50 & ISPCCDC_VDINT_1_MASK) <<
+					ISPCCDC_VDINT_1_SHIFT), ISPCCDC_VDINT);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ispccdc_config_size);
+
+/**
+ * ispccdc_config_outlineoffset - Configures the output line offset
+ * @offset: Must be twice the Output width and aligned on 32 byte boundary
+ * @oddeven: Specifies the odd/even line pattern to be chosen to store the
+ *           output.
+ * @numlines: Set the value 0-3 for +1-4lines, 4-7 for -1-4lines.
+ *
+ * - Configures the output line offset when stored in memory
+ * - Sets the odd/even line pattern to store the output
+ *    (EVENEVEN (1), ODDEVEN (2), EVENODD (3), ODDODD (4))
+ * - Configures the number of even and odd line fields in case of rearranging
+ * the lines.
+ *
+ * Returns 0 if successful, or -EINVAL if the offset is not in 32 byte
+ * boundary.
+ **/
+int ispccdc_config_outlineoffset(u32 offset, u8 oddeven, u8 numlines)
+{
+	if ((offset & ISP_32B_BOUNDARY_OFFSET) == offset)
+		omap_writel((offset & 0xFFFF), ISPCCDC_HSIZE_OFF);
+	else {
+		DPRINTK_ISPCCDC("ISP_ERR : Offset should be in 32 byte"
+								" boundary");
+		return -EINVAL;
+	}
+
+	omap_writel((omap_readl(ISPCCDC_SDOFST) & (~ISPCCDC_SDOFST_FINV)),
+							ISPCCDC_SDOFST);
+
+	omap_writel(omap_readl(ISPCCDC_SDOFST) & ISPCCDC_SDOFST_FOFST_1L,
+							ISPCCDC_SDOFST);
+
+	switch (oddeven) {
+	case EVENEVEN:
+		omap_writel((omap_readl(ISPCCDC_SDOFST)) | ((numlines & 0x7) <<
+						ISPCCDC_SDOFST_LOFST0_SHIFT),
+						ISPCCDC_SDOFST);
+		break;
+	case ODDEVEN:
+		omap_writel((omap_readl(ISPCCDC_SDOFST)) | ((numlines & 0x7) <<
+						ISPCCDC_SDOFST_LOFST1_SHIFT),
+						ISPCCDC_SDOFST);
+		break;
+	case EVENODD:
+		omap_writel((omap_readl(ISPCCDC_SDOFST)) | ((numlines & 0x7) <<
+						ISPCCDC_SDOFST_LOFST2_SHIFT),
+						ISPCCDC_SDOFST);
+		break;
+	case ODDODD:
+		omap_writel((omap_readl(ISPCCDC_SDOFST)) | ((numlines & 0x7) <<
+						ISPCCDC_SDOFST_LOFST3_SHIFT),
+						ISPCCDC_SDOFST);
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(ispccdc_config_outlineoffset);
+
+/**
+ * ispccdc_set_outaddr - Sets the memory address where the output will be saved
+ * @addr: 32-bit memory address aligned on 32 byte boundary.
+ *
+ * Sets the memory address where the output will be saved.
+ *
+ * Returns 0 if successful, or -EINVAL if the address is not in the 32 byte
+ * boundary.
+ **/
+int ispccdc_set_outaddr(u32 addr)
+{
+	if ((addr & ISP_32B_BOUNDARY_BUF) == addr) {
+		omap_writel(addr, ISPCCDC_SDR_ADDR);
+		return 0;
+	} else {
+		DPRINTK_ISPCCDC("ISP_ERR : Address should be in 32 byte"
+								" boundary");
+		return -EINVAL;
+	}
+
+}
+EXPORT_SYMBOL(ispccdc_set_outaddr);
+
+/**
+ * ispccdc_enable - Enables the CCDC module.
+ * @enable: 0 Disables CCDC, 1 Enables CCDC
+ *
+ * Client should configure all the sub modules in CCDC before this.
+ **/
+void ispccdc_enable(u8 enable)
+{
+	if (enable) {
+		omap_writel(omap_readl(ISPCCDC_PCR) | (ISPCCDC_PCR_EN),
+								ISPCCDC_PCR);
+	} else {
+		omap_writel(omap_readl(ISPCCDC_PCR) & ~(ISPCCDC_PCR_EN),
+								ISPCCDC_PCR);
+	}
+
+}
+EXPORT_SYMBOL(ispccdc_enable);
+
+/**
+ * ispccdc_busy - Gets busy state of the CCDC.
+ **/
+int ispccdc_busy(void)
+{
+	return omap_readl(ISPCCDC_PCR) & ISPCCDC_PCR_BUSY;
+}
+
+/**
+ * ispccdc_save_context - Saves the values of the CCDC module registers
+ **/
+void ispccdc_save_context(void)
+{
+	DPRINTK_ISPCCDC("Saving context\n");
+	isp_save_context(ispccdc_reg_list);
+
+}
+EXPORT_SYMBOL(ispccdc_save_context);
+
+/**
+ * ispccdc_restore_context - Restores the values of the CCDC module registers
+ **/
+void ispccdc_restore_context(void)
+{
+	DPRINTK_ISPCCDC("Restoring context\n");
+	isp_restore_context(ispccdc_reg_list);
+}
+EXPORT_SYMBOL(ispccdc_restore_context);
+
+/**
+ * ispccdc_print_status - Prints the values of the CCDC Module registers
+ *
+ * Also prints other debug information stored in the CCDC module.
+ **/
+void ispccdc_print_status(void)
+{
+	if (!is_ispccdc_debug_enabled())
+		return;
+
+	DPRINTK_ISPCCDC("Module in use =%d\n", ispccdc_obj.ccdc_inuse);
+	DPRINTK_ISPCCDC("Accepted CCDC Input (width = %d,Height = %d)\n",
+							ispccdc_obj.ccdcin_w,
+							ispccdc_obj.ccdcin_h);
+	DPRINTK_ISPCCDC("Accepted CCDC Output (width = %d,Height = %d)\n",
+							ispccdc_obj.ccdcout_w,
+							ispccdc_obj.ccdcout_h);
+	DPRINTK_ISPCCDC("###CCDC PCR=0x%x\n", omap_readl(ISPCCDC_PCR));
+	DPRINTK_ISPCCDC("ISP_CTRL =0x%x\n", omap_readl(ISP_CTRL));
+	switch (ispccdc_obj.ccdc_inpfmt) {
+	case CCDC_RAW:
+		DPRINTK_ISPCCDC("ccdc input format is CCDC_RAW\n");
+		break;
+	case CCDC_YUV_SYNC:
+		DPRINTK_ISPCCDC("ccdc input format is CCDC_YUV_SYNC\n");
+		break;
+	case CCDC_YUV_BT:
+		DPRINTK_ISPCCDC("ccdc input format is CCDC_YUV_BT\n");
+		break;
+	}
+
+	switch (ispccdc_obj.ccdc_outfmt) {
+	case CCDC_OTHERS_VP:
+		DPRINTK_ISPCCDC("ccdc output format is CCDC_OTHERS_VP\n");
+		break;
+	case CCDC_OTHERS_MEM:
+		DPRINTK_ISPCCDC("ccdc output format is CCDC_OTHERS_MEM\n");
+		break;
+	case CCDC_YUV_RSZ:
+		DPRINTK_ISPCCDC("ccdc output format is CCDC_YUV_RSZ\n");
+		break;
+	}
+
+	DPRINTK_ISPCCDC("###ISP_CTRL in ccdc =0x%x\n", omap_readl(ISP_CTRL));
+	DPRINTK_ISPCCDC("###ISP_IRQ0ENABLE in ccdc =0x%x\n",
+						omap_readl(ISP_IRQ0ENABLE));
+	DPRINTK_ISPCCDC("###ISP_IRQ0STATUS in ccdc =0x%x\n",
+						omap_readl(ISP_IRQ0STATUS));
+	DPRINTK_ISPCCDC("###CCDC SYN_MODE=0x%x\n",
+						omap_readl(ISPCCDC_SYN_MODE));
+	DPRINTK_ISPCCDC("###CCDC HORZ_INFO=0x%x\n",
+						omap_readl(ISPCCDC_HORZ_INFO));
+	DPRINTK_ISPCCDC("###CCDC VERT_START=0x%x\n",
+					omap_readl(ISPCCDC_VERT_START));
+	DPRINTK_ISPCCDC("###CCDC VERT_LINES=0x%x\n",
+					omap_readl(ISPCCDC_VERT_LINES));
+	DPRINTK_ISPCCDC("###CCDC CULLING=0x%x\n", omap_readl(ISPCCDC_CULLING));
+	DPRINTK_ISPCCDC("###CCDC HSIZE_OFF=0x%x\n",
+						omap_readl(ISPCCDC_HSIZE_OFF));
+	DPRINTK_ISPCCDC("###CCDC SDOFST=0x%x\n", omap_readl(ISPCCDC_SDOFST));
+	DPRINTK_ISPCCDC("###CCDC SDR_ADDR=0x%x\n",
+						omap_readl(ISPCCDC_SDR_ADDR));
+	DPRINTK_ISPCCDC("###CCDC CLAMP=0x%x\n", omap_readl(ISPCCDC_CLAMP));
+	DPRINTK_ISPCCDC("###CCDC COLPTN=0x%x\n", omap_readl(ISPCCDC_COLPTN));
+	DPRINTK_ISPCCDC("###CCDC CFG=0x%x\n", omap_readl(ISPCCDC_CFG));
+	DPRINTK_ISPCCDC("###CCDC VP_OUT=0x%x\n", omap_readl(ISPCCDC_VP_OUT));
+	DPRINTK_ISPCCDC("###CCDC_SDR_ADDR= 0x%x\n",
+						omap_readl(ISPCCDC_SDR_ADDR));
+	DPRINTK_ISPCCDC("###CCDC FMTCFG=0x%x\n", omap_readl(ISPCCDC_FMTCFG));
+	DPRINTK_ISPCCDC("###CCDC FMT_HORZ=0x%x\n",
+						omap_readl(ISPCCDC_FMT_HORZ));
+	DPRINTK_ISPCCDC("###CCDC FMT_VERT=0x%x\n",
+						omap_readl(ISPCCDC_FMT_VERT));
+	DPRINTK_ISPCCDC("###CCDC LSC_CONFIG=0x%x\n",
+					omap_readl(ISPCCDC_LSC_CONFIG));
+	DPRINTK_ISPCCDC("###CCDC LSC_INIT=0x%x\n",
+					omap_readl(ISPCCDC_LSC_INITIAL));
+	DPRINTK_ISPCCDC("###CCDC LSC_TABLE BASE=0x%x\n",
+					omap_readl(ISPCCDC_LSC_TABLE_BASE));
+	DPRINTK_ISPCCDC("###CCDC LSC TABLE OFFSET=0x%x\n",
+					omap_readl(ISPCCDC_LSC_TABLE_OFFSET));
+}
+EXPORT_SYMBOL(ispccdc_print_status);
+
+/**
+ * isp_ccdc_init - CCDC module initialization.
+ *
+ * Always returns 0
+ **/
+static int __init isp_ccdc_init(void)
+{
+	ispccdc_obj.ccdc_inuse = 0;
+	ispccdc_config_crop(0, 0, 0, 0);
+	mutex_init(&ispccdc_obj.mutexlock);
+
+	return 0;
+}
+
+/**
+ * isp_ccdc_cleanup - CCDC module cleanup.
+ **/
+static void isp_ccdc_cleanup(void)
+{
+	if (fpc_table_add_m != 0) {
+		ispmmu_unmap(fpc_table_add_m);
+		kfree(fpc_table_add);
+	}
+}
+
+module_init(isp_ccdc_init);
+module_exit(isp_ccdc_cleanup);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("ISP CCDC Library");
+MODULE_LICENSE("GPL");
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/ispccdc.h	2008-06-29 17:44:57.000000000 -0500
@@ -0,0 +1,202 @@
+/*
+ * drivers/media/video/isp/ispccdc.h
+ *
+ * Driver header file for CCDC module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *	Senthilvadivu Guruswamy <svadivu@ti.com>
+ *	Pallavi Kulkarni <p-kulkarni@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_CCDC_H
+#define OMAP_ISP_CCDC_H
+
+#include <asm/arch/isp_user.h>
+
+#ifdef OMAP_ISPCCDC_DEBUG
+# define is_ispccdc_debug_enabled()		1
+#else
+# define is_ispccdc_debug_enabled()		0
+#endif
+
+/* Enumeration constants for CCDC input output format */
+enum ccdc_input {
+	CCDC_RAW,
+	CCDC_YUV_SYNC,
+	CCDC_YUV_BT,
+	CCDC_OTHERS
+};
+
+enum ccdc_output {
+	CCDC_YUV_RSZ,
+	CCDC_YUV_MEM_RSZ,
+	CCDC_OTHERS_VP,
+	CCDC_OTHERS_MEM,
+	CCDC_OTHERS_VP_MEM
+};
+
+/* Enumeration constants for the sync interface parameters */
+enum inpmode {
+	RAW,
+	YUV16,
+	YUV8
+};
+enum datasize {
+	DAT8,
+	DAT10,
+	DAT11,
+	DAT12
+};
+
+
+/**
+ * struct ispccdc_syncif - Structure for Sync Interface between sensor and CCDC
+ * @ccdc_mastermode: Master mode. 1 - Master, 0 - Slave.
+ * @fldstat: Field state. 0 - Odd Field, 1 - Even Field.
+ * @ipmod: Input mode.
+ * @datsz: Data size.
+ * @fldmode: 0 - Progressive, 1 - Interlaced.
+ * @datapol: 0 - Positive, 1 - Negative.
+ * @fldpol: 0 - Positive, 1 - Negative.
+ * @hdpol: 0 - Positive, 1 - Negative.
+ * @vdpol: 0 - Positive, 1 - Negative.
+ * @fldout: 0 - Input, 1 - Output.
+ * @hs_width: Width of the Horizontal Sync pulse, used for HS/VS Output.
+ * @vs_width: Width of the Vertical Sync pulse, used for HS/VS Output.
+ * @ppln: Number of pixels per line, used for HS/VS Output.
+ * @hlprf: Number of half lines per frame, used for HS/VS Output.
+ * @bt_r656_en: 1 - Enable ITU-R BT656 mode, 0 - Sync mode.
+ */
+struct ispccdc_syncif {
+	u8 ccdc_mastermode;
+	u8 fldstat;
+	enum inpmode ipmod;
+	enum datasize datsz;
+	u8 fldmode;
+	u8 datapol;
+	u8 fldpol;
+	u8 hdpol;
+	u8 vdpol;
+	u8 fldout;
+	u8 hs_width;
+	u8 vs_width;
+	u8 ppln;
+	u8 hlprf;
+	u8 bt_r656_en;
+};
+
+/**
+ * ispccdc_refmt - Structure for Reformatter parameters
+ * @lnalt: Line alternating mode enable. 0 - Enable, 1 - Disable.
+ * @lnum: Number of output lines from 1 input line. 1 to 4 lines.
+ * @plen_even: Number of program entries in even line minus 1.
+ * @plen_odd: Number of program entries in odd line minus 1.
+ * @prgeven0: Program entries 0-7 for even lines register
+ * @prgeven1: Program entries 8-15 for even lines register
+ * @prgodd0: Program entries 0-7 for odd lines register
+ * @prgodd1: Program entries 8-15 for odd lines register
+ * @fmtaddr0: Output line in which the original pixel is to be placed
+ * @fmtaddr1: Output line in which the original pixel is to be placed
+ * @fmtaddr2: Output line in which the original pixel is to be placed
+ * @fmtaddr3: Output line in which the original pixel is to be placed
+ * @fmtaddr4: Output line in which the original pixel is to be placed
+ * @fmtaddr5: Output line in which the original pixel is to be placed
+ * @fmtaddr6: Output line in which the original pixel is to be placed
+ * @fmtaddr7: Output line in which the original pixel is to be placed
+ */
+struct ispccdc_refmt {
+	u8 lnalt;
+	u8 lnum;
+	u8 plen_even;
+	u8 plen_odd;
+	u32 prgeven0;
+	u32 prgeven1;
+	u32 prgodd0;
+	u32 prgodd1;
+	u32 fmtaddr0;
+	u32 fmtaddr1;
+	u32 fmtaddr2;
+	u32 fmtaddr3;
+	u32 fmtaddr4;
+	u32 fmtaddr5;
+	u32 fmtaddr6;
+	u32 fmtaddr7;
+};
+
+int ispccdc_request(void);
+
+int ispccdc_free(void);
+
+int ispccdc_config_datapath(enum ccdc_input input, enum ccdc_output output);
+
+void ispccdc_config_crop(u32 left, u32 top, u32 height, u32 width);
+
+void ispccdc_config_sync_if(struct ispccdc_syncif syncif);
+
+int ispccdc_config_black_clamp(struct ispccdc_bclamp bclamp);
+
+void ispccdc_enable_black_clamp(u8 enable);
+
+int ispccdc_config_fpc(struct ispccdc_fpc fpc);
+
+void ispccdc_enable_fpc(u8 enable);
+
+void ispccdc_config_black_comp(struct ispccdc_blcomp blcomp);
+
+void ispccdc_config_vp(struct ispccdc_vp vp);
+
+void ispccdc_enable_vp(u8 enable);
+
+void ispccdc_config_reformatter(struct ispccdc_refmt refmt);
+
+void ispccdc_enable_reformatter(u8 enable);
+
+void ispccdc_config_culling(struct ispccdc_culling culling);
+
+void ispccdc_enable_lpf(u8 enable);
+
+void ispccdc_config_alaw(enum alaw_ipwidth ipwidth);
+
+void ispccdc_enable_alaw(u8 enable);
+
+int ispccdc_load_lsc(u32 table_size);
+
+void ispccdc_config_lsc(struct ispccdc_lsc_config *lsc_cfg);
+
+void ispccdc_enable_lsc(u8 enable);
+
+void ispccdc_config_imgattr(u32 colptn);
+
+void ispccdc_config_shadow_registers(void);
+
+int ispccdc_try_size(u32 input_w, u32 input_h, u32 *output_w, u32 *output_h);
+
+int ispccdc_config_size(u32 input_w, u32 input_h, u32 output_w, u32 output_h);
+
+int ispccdc_config_outlineoffset(u32 offset, u8 oddeven, u8 numlines);
+
+int ispccdc_set_outaddr(u32 addr);
+
+void ispccdc_enable(u8 enable);
+
+int ispccdc_busy(void);
+
+void ispccdc_save_context(void);
+
+void ispccdc_restore_context(void);
+
+void ispccdc_print_status(void);
+
+int omap34xx_isp_ccdc_config(void *userspace_add);
+
+#endif		/* OMAP_ISP_CCDC_H */
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/ispmmu.c	2008-06-29 16:57:48.000000000 -0500
@@ -0,0 +1,742 @@
+/*
+ * drivers/media/video/isp/ispmmu.c
+ *
+ * Driver Library for ISP MMU module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *	Senthilvadivu Guruswamy <svadivu@ti.com>
+ *	Thara Gopinath <thara@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+
+#include <linux/io.h>
+#include <linux/scatterlist.h>
+#include <linux/semaphore.h>
+#include <asm/byteorder.h>
+#include <asm/irq.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispmmu.h"
+
+/**
+ * struct ispmmu_mapattr - Struct for Mapping Attributes in L1, L2 descriptor
+ * endianism: Endianism.
+ * element_size: Bit size of the element.
+ * mixed_size: Mixed region type.
+ * map_size: Mapping size.
+ */
+struct ispmmu_mapattr {
+	enum ISPMMU_MAP_ENDIAN endianism;
+	enum ISPMMU_MAP_ELEMENTSIZE element_size;
+	enum ISPMMU_MAP_MIXEDREGION mixed_size;
+	enum ISPMMU_MAP_SIZE map_size;
+};
+
+/* Structure for saving/restoring mmu module registers */
+static struct isp_reg ispmmu_reg_list[] = {
+	{ISPMMU_SYSCONFIG, 0x0000},
+	{ISPMMU_IRQENABLE, 0x0000},
+	{ISPMMU_CNTL, 0x0000},
+	{ISPMMU_TTB, 0x0000},
+	{ISPMMU_LOCK, 0x0000},
+	{ISPMMU_LD_TLB, 0x0000},
+	{ISPMMU_CAM, 0x0000},
+	{ISPMMU_RAM, 0x0000},
+	{ISPMMU_GFLUSH, 0x0000},
+	{ISPMMU_FLUSH_ENTRY, 0x0000},
+	{ISP_TOK_TERM, 0x0000}
+};
+
+/* Page structure for statically allocated l1 and l2 page tables */
+static struct page *ttb_page;
+static struct page *l2p_page;
+
+/*
+* Allocate the same number as of TTB entries for easy tracking
+* even though L2P tables are limited to 16 or so
+*/
+static u32 l2p_table_addr[4096];
+
+/* An array of flags to keep the L2P table allotted */
+static int l2p_table_allotted[L2P_TABLE_NR];
+
+/* TTB virtual and physical address */
+static u32 *ttb, ttb_p;
+
+/* Worst case allocation for TTB for 16KB alignment */
+static u32 ttb_aligned_size;
+
+/* L2 page table base virtural and physical address */
+static u32 l2_page_cache, l2_page_cache_p;
+
+static struct ispmmu_mapattr l1_mapattr_obj, l2_mapattr_obj;
+
+/**
+ * ispmmu_set_pte - Sets the L1, L2 descriptor.
+ * @pte_addr: Pointer to the Indexed address in the L1 Page table ie TTB.
+ * @phy_addr: Section/Supersection/L2page table physical address.
+ * @mapattr: Mapping attributes applicable for Section/Supersections.
+ *
+ * Set with section/supersection/Largepage/Smallpage base address or with L2
+ * Page table address depending on the size parameter.
+ *
+ * Returns the written L1/L2 descriptor.
+ **/
+static u32 ispmmu_set_pte(u32 *pte_addr, u32 phy_addr,
+						struct ispmmu_mapattr mapattr)
+{
+	u32 pte = 0;
+
+	switch (mapattr.map_size) {
+	case PAGE :
+		pte = ISPMMU_L1D_TYPE_PAGE << ISPMMU_L1D_TYPE_SHIFT;
+		pte |= (phy_addr >> ISPMMU_L1D_PAGE_ADDR_SHIFT)
+						<< ISPMMU_L1D_PAGE_ADDR_SHIFT;
+		break;
+	case SMALLPAGE:
+		pte = ISPMMU_L2D_TYPE_SMALL_PAGE << ISPMMU_L2D_TYPE_SHIFT;
+		pte &= ~ISPMMU_L2D_M_ACCESSBASED;
+		if (mapattr.endianism)
+			pte |= ISPMMU_L2D_E_BIGENDIAN;
+		else
+			pte &= ~ISPMMU_L2D_E_BIGENDIAN;
+		pte &= ISPMMU_L2D_ES_MASK;
+		pte |= mapattr.element_size << ISPMMU_L2D_ES_SHIFT;
+		pte |= (phy_addr >> ISPMMU_L2D_SMALL_ADDR_SHIFT)
+						<< ISPMMU_L2D_SMALL_ADDR_SHIFT;
+		break;
+	case L1DFAULT:
+		pte = ISPMMU_L1D_TYPE_FAULT << ISPMMU_L1D_TYPE_SHIFT;
+		break;
+	case L2DFAULT:
+		pte = ISPMMU_L2D_TYPE_FAULT << ISPMMU_L2D_TYPE_SHIFT;
+		break;
+	default:
+		break;
+	};
+
+	*pte_addr = pte;
+	return pte;
+}
+
+/**
+ * find_free_region_index - Returns the index in the ttb for a free 32MB region
+ *
+ * Returns 0 as an error code, if run out of regions.
+ **/
+static u32 find_free_region_index(void)
+{
+	int idx = 0;
+	for (idx = ISPMMU_REGION_ENTRIES_NR; idx < ISPMMU_TTB_ENTRIES_NR;
+					idx += ISPMMU_REGION_ENTRIES_NR) {
+		if (((*(ttb + idx)) & ISPMMU_L1D_TYPE_MASK) ==
+						(ISPMMU_L1D_TYPE_FAULT <<
+						ISPMMU_L1D_TYPE_SHIFT))
+			break;
+	}
+	if (idx == ISPMMU_TTB_ENTRIES_NR) {
+		DPRINTK_ISPMMU("run out of virtual space\n");
+		return 0;
+	}
+	return idx;
+}
+
+/**
+ * page_aligned_addr - Returns the Page aligned address.
+ * @addr: Address to be page aligned.
+ **/
+static inline u32 page_aligned_addr(u32 addr)
+{
+	u32 paddress;
+	paddress = addr & ~(PAGE_SIZE-1);
+	return paddress;
+}
+
+
+/**
+ * l2_page_paddr - Returns the physical address of the allocated L2 page Table.
+ * @l2_table: Virtual address of the allocated l2 table.
+ **/
+static inline u32 l2_page_paddr(u32 l2_table)
+{
+	return l2_page_cache_p + (l2_table - l2_page_cache);
+}
+
+/**
+ * init_l2_page_cache - Allocates contigous memory for L2 page tables.
+ *
+ * Returns 0 if successful, or -ENOMEM if no memory for L2 page tables.
+ **/
+static int init_l2_page_cache(void)
+{
+	int i;
+	u32 *l2p;
+
+	l2p_page = alloc_pages(GFP_KERNEL, get_order(L2P_TABLES_SIZE));
+	if (!l2p_page) {
+		DPRINTK_ISPMMU("ISP_ERR : No Memory for L2 page tables\n");
+		return -ENOMEM;
+	}
+	l2p = page_address(l2p_page);
+	l2_page_cache = (u32)l2p;
+	l2_page_cache_p = __pa(l2p);
+	l2_page_cache = (u32)ioremap_nocache(l2_page_cache_p, L2P_TABLES_SIZE);
+
+	for (i = 0; i < L2P_TABLE_NR; i++)
+		l2p_table_allotted[i] = 0;
+
+	DPRINTK_ISPMMU("Mem for L2 page tables at l2_paddr = %x,"
+					" l2_vaddr = 0x%x, of bytes = 0x%x\n",
+					l2_page_cache_p, l2_page_cache,
+					L2P_TABLES_SIZE);
+
+	if (is_sil_rev_less_than(OMAP3430_REV_ES2_0))
+		l2_mapattr_obj.endianism = B_ENDIAN;
+	else
+		l2_mapattr_obj.endianism = L_ENDIAN;
+	l2_mapattr_obj.element_size = ES_8BIT;
+	l2_mapattr_obj.mixed_size = ACCESS_BASED;
+	l2_mapattr_obj.map_size = L2DFAULT;
+	return 0;
+}
+
+/**
+ * cleanup_l2_page_cache - Frees the memory of L2 page tables.
+ **/
+static void cleanup_l2_page_cache(void)
+{
+	if (l2p_page) {
+		ioremap_cached(l2_page_cache_p, L2P_TABLES_SIZE);
+		__free_pages(l2p_page, get_order(L2P_TABLES_SIZE));
+	}
+}
+
+/**
+ * request_l2_page_table - Requests L2 Page table slot.
+ *
+ * Finds a free L2 Page table slot.
+ * Fills the allotted L2 Page table with default entries.
+ * Returns the virtual address of the allocatted L2 Pagetable, or 0 if cannot
+ * allocate the requested L2 pagetables
+ **/
+static u32 request_l2_page_table(void)
+{
+	int i, j;
+	u32 l2_table;
+
+	for (i = 0; i < L2P_TABLE_NR; i++) {
+		if (!l2p_table_allotted[i])
+			break;
+	}
+	if (i < L2P_TABLE_NR) {
+		l2p_table_allotted[i] = 1;
+		l2_table = l2_page_cache + (i * L2P_TABLE_SIZE);
+		l2_mapattr_obj.map_size = L2DFAULT;
+		for (j = 0; j < ISPMMU_L2D_ENTRIES_NR; j++)
+			ispmmu_set_pte((u32 *)l2_table + j, 0, l2_mapattr_obj);
+		DPRINTK_ISPMMU("Allotted l2 page table at 0x%x\n",
+					(u32)l2_table);
+		return l2_table;
+	} else {
+		DPRINTK_ISPMMU("ISP_ERR : Cannot allocate more than 16 L2\
+				Page Tables");
+		return 0;
+	}
+}
+
+/**
+ * free_l2_page_table - Frees the allocatted L2 Page table slot.
+ * @l2_table: 32 bit address for L2 Table to be freed.
+ *
+ * Returns 0 if successful, or -EINVAL if table is not found.
+ **/
+static int free_l2_page_table(u32 l2_table)
+{
+	int i;
+
+	DPRINTK_ISPMMU("Free l2 page table at 0x%x\n", l2_table);
+	for (i = 0; i < L2P_TABLE_NR; i++)
+		if (l2_table == (l2_page_cache + (i * L2P_TABLE_SIZE))) {
+			if (!l2p_table_allotted[i])
+				DPRINTK_ISPMMU("L2 page not in use\n");
+
+			l2p_table_allotted[i] = 0;
+			return 0;
+		}
+	DPRINTK_ISPMMU("L2 table not found\n");
+	return -EINVAL;
+}
+
+/**
+ * ispmmu_map - Map a physically contiguous buffer to ISP space.
+ * @p_addr: Physical address of the contigous mem to be mapped.
+ * @size: Size of the contigous mem to be mapped.
+ *
+ * This call is used to map a frame buffer.
+ *
+ * Returns a valid address when successful, 0 if no memory could be mapped,
+ * or -EINVAL if runned out of virtual space.
+ **/
+dma_addr_t ispmmu_map(u32 p_addr, int size)
+{
+	int i, j, idx, num;
+	u32 sz, first_padding;
+	u32 p_addr_align, p_addr_align_end;
+	u32 pd;
+	u32 *l2_table;
+	dma_addr_t ret_addr;
+
+	DPRINTK_ISPMMU("map: p_addr = 0x%x, size = 0x%x\n", p_addr, size);
+
+	p_addr_align = page_aligned_addr(p_addr);
+
+	first_padding = p_addr - p_addr_align;
+	if (first_padding > size)
+		sz = 0;
+	else
+		sz = size - first_padding;
+
+	num = (sz / PAGE_SIZE) + ((sz % PAGE_SIZE) ? 1 : 0) +
+						(first_padding ? 1 : 0);
+	p_addr_align_end = p_addr_align + num * PAGE_SIZE;
+
+	DPRINTK_ISPMMU("buffer at 0x%x of size 0x%x spans to %d pages\n",
+							p_addr, size, num);
+
+	idx = find_free_region_index();
+	if (!idx) {
+		DPRINTK_ISPMMU("Runs out of virtual space");
+		return -EINVAL;
+	}
+	DPRINTK_ISPMMU("allocating region %d\n", idx/ISPMMU_REGION_ENTRIES_NR);
+
+	num = num / ISPMMU_L2D_ENTRIES_NR +
+				((num % ISPMMU_L2D_ENTRIES_NR) ? 1 : 0);
+	DPRINTK_ISPMMU("need %d second-level page tables (1KB each)\n", num);
+
+	for (i = 0; i < num; i++) {
+		l2_table = (u32 *)request_l2_page_table();
+		if (!l2_table) {
+			DPRINTK_ISPMMU("no memory\n");
+			i--;
+			goto release_mem;
+		}
+
+		l1_mapattr_obj.map_size = PAGE;
+		pd = ispmmu_set_pte(ttb+idx+i, l2_page_paddr((u32)l2_table),
+			l1_mapattr_obj);
+		DPRINTK_ISPMMU("L1 pte[%d] = 0x%x\n", idx+i, pd);
+
+		l2_mapattr_obj.map_size = SMALLPAGE;
+		for (j = 0; j < ISPMMU_L2D_ENTRIES_NR; j++) {
+			pd = ispmmu_set_pte(l2_table + j, p_addr_align,
+							l2_mapattr_obj);
+			p_addr_align += PAGE_SIZE;
+			if (p_addr_align == p_addr_align_end)
+				break;
+		}
+		l2p_table_addr[idx + i] = (u32)l2_table;
+	}
+
+	DPRINTK_ISPMMU("mapped to ISP virtual address 0x%x\n",
+		(u32)((idx << 20) + (p_addr & (PAGE_SIZE - 1))));
+
+	omap_writel(1, ISPMMU_GFLUSH);
+	ret_addr = (dma_addr_t)((idx << 20) + (p_addr & (PAGE_SIZE - 1)));
+	return ret_addr;
+
+release_mem:
+	for (; i >= 0; i--) {
+		free_l2_page_table(l2p_table_addr[idx + i]);
+		l2p_table_addr[idx + i] = 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ispmmu_map);
+
+/**
+ * ispmmu_map_sg - Map a physically discontiguous buffer to ISP space.
+ * @sg_list: Address of the Scatter gather linked list.
+ * @sglen: Number of elements in the sg list.
+ *
+ * This call is used to map a user buffer or a vmalloc buffer. The sg list is
+ * a set of pages.
+ *
+ * Returns a valid address when successful, 0 if no memory could be mapped,
+ * or -EINVAL if runned out of virtual space.
+ **/
+dma_addr_t ispmmu_map_sg(const struct scatterlist *sglist, int sglen)
+{
+	int i, j, idx, num, sg_num = 0;
+	u32 pd, sg_element_addr;
+	u32 *l2_table;
+	dma_addr_t ret_addr;
+
+	DPRINTK_ISPMMU("Map_sg: sglen (num of pages) = %d\n", sglen);
+
+	idx = find_free_region_index();
+	if (!idx) {
+		DPRINTK_ISPMMU("Runs out of virtual space");
+		return -EINVAL;
+	}
+
+	DPRINTK_ISPMMU("allocating region %d\n", idx/ISPMMU_REGION_ENTRIES_NR);
+
+	num = sglen / ISPMMU_L2D_ENTRIES_NR +
+			((sglen % ISPMMU_L2D_ENTRIES_NR) ? 1 : 0);
+	DPRINTK_ISPMMU("Need %d second-level page tables (1KB each)\n", num);
+
+	for (i = 0; i < num; i++) {
+		l2_table = (u32 *)request_l2_page_table();
+		if (!l2_table) {
+			DPRINTK_ISPMMU("No memory\n");
+			i--;
+			goto release_mem;
+		}
+		l1_mapattr_obj.map_size = PAGE;
+		pd = ispmmu_set_pte(ttb + idx + i,
+						l2_page_paddr((u32)l2_table),
+						l1_mapattr_obj);
+		DPRINTK_ISPMMU("L1 pte[%d] = 0x%x\n", idx + i, pd);
+
+		l2_mapattr_obj.map_size = SMALLPAGE;
+		for (j = 0; j < ISPMMU_L2D_ENTRIES_NR; j++) {
+			sg_element_addr = sg_dma_address(sglist + sg_num);
+			if ((sg_num > 0) && page_aligned_addr(sg_element_addr)
+							!= sg_element_addr)
+				DPRINTK_ISPMMU("ISP_ERR : Intermediate SG"
+						" elements are not"
+						" page aligned = 0x%x\n",
+						sg_element_addr);
+			pd = ispmmu_set_pte(l2_table + j, sg_element_addr,
+							l2_mapattr_obj);
+
+			/* DPRINTK_ISPMMU("L2 pte[%d] = 0x%x\n", j, pd); */
+
+			sg_num++;
+			if (sg_num == sglen)
+				break;
+		}
+		/* save it so we can free this l2 table later */
+		l2p_table_addr[idx + i] = (u32)l2_table;
+	}
+
+	DPRINTK_ISPMMU("mapped sg list to ISP virtual address 0x%x, idx=%d\n",
+		(u32)((idx << 20) + (sg_dma_address(sglist + 0) &
+						(PAGE_SIZE - 1))), idx);
+
+	omap_writel(1, ISPMMU_GFLUSH);
+	ret_addr = (dma_addr_t)((idx << 20) + (sg_dma_address(sglist + 0) &
+							(PAGE_SIZE - 1)));
+	return ret_addr;
+
+release_mem:
+	for (; i >= 0; i--) {
+		free_l2_page_table(l2p_table_addr[idx + i]);
+		l2p_table_addr[idx + i] = 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ispmmu_map_sg);
+
+/**
+ * ispmmu_unmap - Unmap a ISP space that was mmapped before.
+ * @v_addr: Virtural address to be unmapped
+ *
+ * Works with mmapped spaces either with ispmmu_map or ispmmu_map_sg.
+ *
+ * Returns 0 if successful, or -EINVAL if wrong region, or non region-aligned
+ **/
+int ispmmu_unmap(dma_addr_t v_addr)
+{
+	u32 v_addr_align;
+	int idx;
+
+	DPRINTK_ISPMMU("+ispmmu_unmap: 0x%x\n", v_addr);
+
+	v_addr_align = page_aligned_addr(v_addr);
+	idx = v_addr_align >> 20;
+	if ((idx < ISPMMU_REGION_ENTRIES_NR) || (idx >
+					(ISPMMU_REGION_ENTRIES_NR *
+					(ISPMMU_REGION_NR - 1))) ||
+					((idx << 20) != v_addr_align) ||
+					(idx % ISPMMU_REGION_ENTRIES_NR)) {
+		DPRINTK_ISPMMU("Cannot unmap a non region-aligned space"
+							" 0x%x\n", v_addr);
+		return -EINVAL;
+	}
+
+	if (((*(ttb + idx)) & (ISPMMU_L1D_TYPE_MASK <<
+						ISPMMU_L1D_TYPE_SHIFT)) !=
+						(ISPMMU_L1D_TYPE_PAGE <<
+						ISPMMU_L1D_TYPE_SHIFT)) {
+		DPRINTK_ISPMMU("unmap a wrong region\n");
+		return -EINVAL;
+	}
+
+	while (((*(ttb + idx)) & (ISPMMU_L1D_TYPE_MASK <<
+						ISPMMU_L1D_TYPE_SHIFT)) ==
+						(ISPMMU_L1D_TYPE_PAGE <<
+						ISPMMU_L1D_TYPE_SHIFT)) {
+		*(ttb + idx) = (ISPMMU_L1D_TYPE_FAULT <<
+						ISPMMU_L1D_TYPE_SHIFT);
+		free_l2_page_table(l2p_table_addr[idx]);
+		l2p_table_addr[idx++] = 0;
+		if (!(idx % ISPMMU_REGION_ENTRIES_NR)) {
+			DPRINTK_ISPMMU("Do not exceed this 32M region\n");
+			break;
+		}
+	}
+	omap_writel(1, ISPMMU_GFLUSH);
+
+	DPRINTK_ISPMMU("-ispmmu_unmap()\n");
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ispmmu_unmap);
+
+/**
+ * ispmmu_isr - Callback from ISP driver for MMU interrupt.
+ * @status: IRQ status of ISPMMU
+ * @arg1: Not used as of now.
+ * @arg2: Not used as of now.
+ **/
+static void ispmmu_isr(unsigned long status, isp_vbq_callback_ptr arg1,
+								void *arg2)
+{
+	u32 irqstatus = 0;
+
+	irqstatus = omap_readl(ISPMMU_IRQSTATUS);
+	DPRINTK_ISPMMU("mmu error 0x%lx, 0x%x\n", status, irqstatus);
+	if (irqstatus & IRQENABLE_TLBMISS)
+		DPRINTK_ISPMMU("ISP_ERR: TLB Miss\n");
+	if (irqstatus & IRQENABLE_TRANSLNFAULT)
+		DPRINTK_ISPMMU("ISP_ERR: Invalide descriptor in the"
+						" translation table -"
+						" Translation Fault\n");
+	if (irqstatus & IRQENABLE_EMUMISS) {
+		DPRINTK_ISPMMU("ISP_ERR: TLB Miss during debug -"
+							" Emulation mode\n");
+	}
+	if (irqstatus & IRQENABLE_TWFAULT)
+		DPRINTK_ISPMMU("ISP_ERR: Table Walk Fault\n");
+	if (irqstatus & IRQENABLE_MULTIHITFAULT)
+		DPRINTK_ISPMMU("ISP_ERR: Multiple Matches in the TLB\n");
+	DPRINTK_ISPMMU("Fault address for the ISPMMU is 0x%x",
+						omap_readl(ISPMMU_FAULT_AD));
+	omap_writel(irqstatus, ISPMMU_IRQSTATUS);
+}
+
+/**
+ * ispmmu_init - ISP MMU Initialization.
+ *
+ * - Reserves memory for L1 and L2 Page tables.
+ * - Initializes the ISPMMU with TTB address, fault entries as default in the
+ * - TTB table.
+ * - Enables MMU and TWL.
+ * - Sets the callback for the MMU error events.
+ *
+ * Returns 0 if successful, -ENODEV if can't take ISP MMU out of reset, -ENOMEM
+ * when no memory for TTB, or init_l2_page_cache return value if L2 page cache
+ * init fails.
+ **/
+static int __init ispmmu_init(void)
+{
+	int i, val = 0;
+	struct isp_sysc isp_sysconfig;
+
+	isp_get();
+
+	omap_writel(2, ISPMMU_SYSCONFIG);
+	while (((omap_readl(ISPMMU_SYSSTATUS) & 0x1) != 0x1) && val--)
+		udelay(10);
+
+	if ((omap_readl(ISPMMU_SYSSTATUS) & 0x1) != 0x1) {
+		DPRINTK_ISPMMU("can't take ISP MMU out of reset\n");
+		isp_put();
+		return -ENODEV;
+	}
+	isp_sysconfig.reset = 0;
+	isp_sysconfig.idle_mode = 1;
+	isp_power_settings(isp_sysconfig);
+
+	ttb_page = alloc_pages(GFP_KERNEL, get_order(ISPMMU_TTB_ENTRIES_NR *
+									4));
+	if (!ttb_page) {
+		DPRINTK_ISPMMU("No Memory for TTB\n");
+		isp_put();
+		return -ENOMEM;
+	}
+
+	ttb = page_address(ttb_page);
+	ttb_p = __pa(ttb);
+	ttb_aligned_size = ISPMMU_TTB_ENTRIES_NR * 4;
+	ttb = ioremap_nocache(ttb_p, ttb_aligned_size);
+	if ((ttb_p & 0xFFFFC000) != ttb_p) {
+		DPRINTK_ISPMMU("ISP_ERR : TTB address not aligned at 16KB\n");
+		__free_pages(ttb_page, get_order(ISPMMU_TTB_ENTRIES_NR * 4));
+		ttb_aligned_size = (ISPMMU_TTB_ENTRIES_NR * 4) +
+						(ISPMMU_TTB_MISALIGN_SIZE);
+		ttb_page = alloc_pages(GFP_KERNEL,
+						get_order(ttb_aligned_size));
+		if (!ttb_page) {
+			DPRINTK_ISPMMU("No Memory for TTB\n");
+			isp_put();
+			return -ENOMEM;
+		}
+		ttb = page_address(ttb_page);
+		ttb_p = __pa(ttb);
+		ttb = ioremap_nocache(ttb_p, ttb_aligned_size);
+		if ((ttb_p & 0xFFFFC000) != ttb_p) {
+			ttb = (u32 *)(((u32)ttb & 0xFFFFC000) + 0x4000);
+			ttb_p = __pa(ttb);
+		}
+	}
+
+	DPRINTK_ISPMMU("TTB allocated at p = 0x%x, v = 0x%x, size = 0x%x\n",
+		ttb_p, (u32)ttb, ttb_aligned_size);
+
+	if (is_sil_rev_less_than(OMAP3430_REV_ES2_0))
+		l1_mapattr_obj.endianism = B_ENDIAN;
+	else
+		l1_mapattr_obj.endianism = L_ENDIAN;
+	l1_mapattr_obj.element_size = ES_8BIT;
+	l1_mapattr_obj.mixed_size = ACCESS_BASED;
+	l1_mapattr_obj.map_size = L1DFAULT;
+
+	val = init_l2_page_cache();
+	if (val) {
+		DPRINTK_ISPMMU("ISP_ERR: init l2 page cache\n");
+		ttb = page_address(ttb_page);
+		ttb_p = __pa(ttb);
+		ioremap_cached(ttb_p, ttb_aligned_size);
+		__free_pages(ttb_page, get_order(ttb_aligned_size));
+		isp_put();
+		return val;
+	}
+
+	for (i = 0; i < ISPMMU_TTB_ENTRIES_NR; i++)
+		ispmmu_set_pte(ttb + i, 0, l1_mapattr_obj);
+
+	omap_writel(ttb_p, ISPMMU_TTB);
+
+	omap_writel((ISPMMU_MMUCNTL_MMU_EN|ISPMMU_MMUCNTL_TWL_EN),
+			ISPMMU_CNTL);
+	omap_writel(omap_readl(ISPMMU_IRQSTATUS), ISPMMU_IRQSTATUS);
+	omap_writel(0xf, ISPMMU_IRQENABLE);
+
+	isp_set_callback(CBK_MMU_ERR, ispmmu_isr, (void *)NULL, (void *)NULL);
+
+	val = omap_readl(ISPMMU_REVISION);
+	DPRINTK_ISPMMU("ISP MMU Rev %c.%c initialized\n",
+			(val >> ISPMMU_REVISION_REV_MAJOR_SHIFT) + '0',
+			(val & ISPMMU_REVISION_REV_MINOR_MASK) + '0');
+	isp_put();
+	return 0;
+
+}
+
+/**
+ * ispmmu_cleanup - Frees the L1, L2 Page tables. Unsets the callback for MMU.
+ **/
+static void ispmmu_cleanup(void)
+{
+	ttb = page_address(ttb_page);
+	ttb_p = __pa(ttb);
+	ioremap_cached(ttb_p, ttb_aligned_size);
+	__free_pages(ttb_page, get_order(ttb_aligned_size));
+	isp_unset_callback(CBK_MMU_ERR);
+	cleanup_l2_page_cache();
+
+	return;
+}
+
+/**
+ * ispmmu_save_context - Saves the values of the mmu module registers.
+ **/
+void ispmmu_save_context(void)
+{
+	DPRINTK_ISPMMU(" Saving context\n");
+	isp_save_context(ispmmu_reg_list);
+}
+EXPORT_SYMBOL_GPL(ispmmu_save_context);
+
+/**
+ * ispmmu_restore_context - Restores the values of the mmu module registers.
+ **/
+void ispmmu_restore_context(void)
+{
+	DPRINTK_ISPMMU(" Restoring context\n");
+	isp_restore_context(ispmmu_reg_list);
+}
+EXPORT_SYMBOL_GPL(ispmmu_restore_context);
+
+/**
+ * ispmmu_print_status - Prints the values of the ISPMMU registers
+ * Also prints other debug information stored
+ **/
+void ispmmu_print_status(void)
+{
+	if (!is_ispmmu_debug_enabled())
+		return;
+	DPRINTK_ISPMMU("TTB v_addr = 0x%x, p_addr = 0x%x\n", (u32)ttb, ttb_p);
+	DPRINTK_ISPMMU("L2P base v_addr = 0x%x, p_addr = 0x%x\n"
+				, l2_page_cache, l2_page_cache_p);
+	DPRINTK_ISPMMU("ISPMMU_REVISION = 0x%x\n",
+						omap_readl(ISPMMU_REVISION));
+	DPRINTK_ISPMMU("ISPMMU_SYSCONFIG = 0x%x\n",
+						omap_readl(ISPMMU_SYSCONFIG));
+	DPRINTK_ISPMMU("ISPMMU_SYSSTATUS = 0x%x\n",
+						omap_readl(ISPMMU_SYSSTATUS));
+	DPRINTK_ISPMMU("ISPMMU_IRQSTATUS = 0x%x\n",
+						omap_readl(ISPMMU_IRQSTATUS));
+	DPRINTK_ISPMMU("ISPMMU_IRQENABLE = 0x%x\n",
+						omap_readl(ISPMMU_IRQENABLE));
+	DPRINTK_ISPMMU("ISPMMU_WALKING_ST = 0x%x\n",
+						omap_readl(ISPMMU_WALKING_ST));
+	DPRINTK_ISPMMU("ISPMMU_CNTL = 0x%x\n", omap_readl(ISPMMU_CNTL));
+	DPRINTK_ISPMMU("ISPMMU_FAULT_AD = 0x%x\n",
+						omap_readl(ISPMMU_FAULT_AD));
+	DPRINTK_ISPMMU("ISPMMU_TTB = 0x%x\n", omap_readl(ISPMMU_TTB));
+	DPRINTK_ISPMMU("ISPMMU_LOCK = 0x%x\n", omap_readl(ISPMMU_LOCK));
+	DPRINTK_ISPMMU("ISPMMU_LD_TLB= 0x%x\n", omap_readl(ISPMMU_LD_TLB));
+	DPRINTK_ISPMMU("ISPMMU_CAM = 0x%x\n", omap_readl(ISPMMU_CAM));
+	DPRINTK_ISPMMU("ISPMMU_RAM = 0x%x\n", omap_readl(ISPMMU_RAM));
+	DPRINTK_ISPMMU("ISPMMU_GFLUSH = 0x%x\n", omap_readl(ISPMMU_GFLUSH));
+	DPRINTK_ISPMMU("ISPMMU_FLUSH_ENTRY = 0x%x\n",
+					omap_readl(ISPMMU_FLUSH_ENTRY));
+	DPRINTK_ISPMMU("ISPMMU_READ_CAM = 0x%x\n",
+						omap_readl(ISPMMU_READ_CAM));
+	DPRINTK_ISPMMU("ISPMMU_READ_RAM = 0x%x\n",
+						omap_readl(ISPMMU_READ_RAM));
+}
+EXPORT_SYMBOL_GPL(ispmmu_print_status);
+
+MODULE_AUTHOR("Texas Instruments.");
+MODULE_DESCRIPTION("OMAP3430 ISP MMU Driver");
+MODULE_LICENSE("GPL");
+
+module_init(ispmmu_init);
+module_exit(ispmmu_cleanup);
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/ispmmu.h	2008-06-29 16:57:48.000000000 -0500
@@ -0,0 +1,117 @@
+/*
+ * drivers/media/video/isp/ispmmu.h
+ *
+ * OMAP3430 Camera ISP MMU API
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *	Senthilvadivu Guruswamy <svadivu@ti.com>
+ *	Thara Gopinath <thara@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_MMU_H
+#define OMAP_ISP_MMU_H
+
+#define ISPMMU_L1D_TYPE_SHIFT		0
+#define ISPMMU_L1D_TYPE_MASK		0x3
+#define ISPMMU_L1D_TYPE_FAULT		0
+#define ISPMMU_L1D_TYPE_FAULT1		3
+#define ISPMMU_L1D_TYPE_PAGE		1
+#define ISPMMU_L1D_TYPE_SECTION		2
+#define ISPMMU_L1D_PAGE_ADDR_SHIFT	10
+
+#define ISPMMU_L2D_TYPE_SHIFT		0
+#define ISPMMU_L2D_TYPE_MASK		0x3
+#define ISPMMU_L2D_TYPE_FAULT		0
+#define ISPMMU_L2D_TYPE_LARGE_PAGE	1
+#define ISPMMU_L2D_TYPE_SMALL_PAGE	2
+#define ISPMMU_L2D_SMALL_ADDR_SHIFT	12
+#define ISPMMU_L2D_SMALL_ADDR_MASK	0xFFFFF000
+#define ISPMMU_L2D_M_ACCESSBASED	(1 << 11)
+#define ISPMMU_L2D_E_BIGENDIAN		(1 << 9)
+#define ISPMMU_L2D_ES_SHIFT		4
+#define ISPMMU_L2D_ES_MASK		(~(3 << 4))
+#define ISPMMU_L2D_ES_8BIT		0
+#define ISPMMU_L2D_ES_16BIT		1
+#define ISPMMU_L2D_ES_32BIT		2
+#define ISPMMU_L2D_ES_NOENCONV		3
+
+#define ISPMMU_TTB_ENTRIES_NR		4096
+
+/* Number 1MB entries in TTB in one 32MB region */
+#define ISPMMU_REGION_ENTRIES_NR	32
+
+/* 128 region entries */
+#define ISPMMU_REGION_NR (ISPMMU_TTB_ENTRIES_NR / ISPMMU_REGION_ENTRIES_NR)
+
+/* Each region is 32MB */
+#define ISPMMU_REGION_SIZE		(ISPMMU_REGION_ENTRIES_NR * (1 << 20))
+
+/* Number of entries per L2 Page table */
+#define ISPMMU_L2D_ENTRIES_NR		256
+
+/*
+ * Statically allocate 16KB for L2 page tables. 16KB can be used for
+ * up to 16 L2 page tables which cover up to 16MB space. We use an array of 16
+ * to keep track of these 16 L2 page table's status.
+ */
+#define L2P_TABLE_SIZE			1024
+#define L2P_TABLE_NR 			41 /* Currently supports 4*5MP shots */
+#define L2P_TABLES_SIZE 		(L2P_TABLE_SIZE * L2P_TABLE_NR)
+
+/* Extra memory allocated to get ttb aligned on 16KB */
+#define ISPMMU_TTB_MISALIGN_SIZE	0x3000
+
+#ifdef CONFIG_ARCH_OMAP3410
+#include <linux/scatterlist.h>
+#endif
+
+enum ISPMMU_MAP_ENDIAN {
+	L_ENDIAN,
+	B_ENDIAN
+};
+
+enum ISPMMU_MAP_ELEMENTSIZE {
+	ES_8BIT,
+	ES_16BIT,
+	ES_32BIT,
+	ES_NOENCONV
+};
+
+enum ISPMMU_MAP_MIXEDREGION {
+	ACCESS_BASED,
+	PAGE_BASED
+};
+
+enum ISPMMU_MAP_SIZE {
+	L1DFAULT,
+	PAGE,
+	SECTION,
+	SUPERSECTION,
+	L2DFAULT,
+	LARGEPAGE,
+	SMALLPAGE
+};
+
+dma_addr_t ispmmu_map(unsigned int p_addr, int size);
+
+dma_addr_t ispmmu_map_sg(const struct scatterlist *sglist, int sglen);
+
+int ispmmu_unmap(dma_addr_t isp_addr);
+
+void ispmmu_print_status(void);
+
+void ispmmu_save_context(void);
+
+void ispmmu_restore_context(void);
+
+#endif /* OMAP_ISP_MMU_H */
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/ispreg.h	2008-06-29 12:26:08.000000000 -0500
@@ -0,0 +1,1281 @@
+/*
+ * drivers/media/video/isp/ispreg.h
+ *
+ * Header file for all the ISP module in TI's OMAP3430 Camera ISP.
+ * It has the OMAP HW register definitions.
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ * 	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
+ *	Thara Gopinath <thara@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef __ISPREG_H__
+#define __ISPREG_H__
+
+#if 0
+#define OMAP_ISPCTRL_DEBUG
+#define OMAP_ISPCCDC_DEBUG
+#define OMAP_ISPPREV_DEBUG
+#define OMAP_ISPRESZ_DEBUG
+#define OMAP_ISPMMU_DEBUG
+#define OMAP_ISPH3A_DEBUG
+#define OMAP_ISPHIST_DEBUG
+#endif
+
+#ifdef OMAP_ISPCTRL_DEBUG
+#define DPRINTK_ISPCTRL(format, ...)\
+	printk(KERN_INFO "ISPCTRL: " format, ## __VA_ARGS__)
+#define is_ispctrl_debug_enabled()		1
+#else
+#define DPRINTK_ISPCTRL(format, ...)
+#define is_ispctrl_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPCCDC_DEBUG
+#define DPRINTK_ISPCCDC(format, ...)\
+	printk(KERN_INFO "ISPCCDC: " format, ## __VA_ARGS__)
+#define is_ispccdc_debug_enabled()		1
+#else
+#define DPRINTK_ISPCCDC(format, ...)
+#define is_ispccdc_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPPREV_DEBUG
+#define DPRINTK_ISPPREV(format, ...)\
+	printk(KERN_INFO "ISPPREV: " format, ## __VA_ARGS__)
+#define is_ispprev_debug_enabled()		1
+#else
+#define DPRINTK_ISPPREV(format, ...)
+#define is_ispprev_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPRESZ_DEBUG
+#define DPRINTK_ISPRESZ(format, ...)\
+	printk(KERN_INFO "ISPRESZ: " format, ## __VA_ARGS__)
+#define is_ispresz_debug_enabled()		1
+#else
+#define DPRINTK_ISPRESZ(format, ...)
+#define is_ispresz_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPMMU_DEBUG
+#define DPRINTK_ISPMMU(format, ...)\
+	printk(KERN_INFO "ISPMMU: " format, ## __VA_ARGS__)
+#define is_ispmmu_debug_enabled()		1
+#else
+#define DPRINTK_ISPMMU(format, ...)
+#define is_ispmmu_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPH3A_DEBUG
+#define DPRINTK_ISPH3A(format, ...)\
+	printk(KERN_INFO "ISPH3A: " format, ## __VA_ARGS__)
+#define is_isph3a_debug_enabled()		1
+#else
+#define DPRINTK_ISPH3A(format, ...)
+#define is_isph3a_debug_enabled()		0
+#endif
+
+#ifdef OMAP_ISPHIST_DEBUG
+#define DPRINTK_ISPHIST(format, ...)\
+	printk(KERN_INFO "ISPHIST: " format, ## __VA_ARGS__)
+#define is_isphist_debug_enabled()		1
+#else
+#define DPRINTK_ISPHIST(format, ...)
+#define is_isphist_debug_enabled()		0
+#endif
+
+#define ISP_32B_BOUNDARY_BUF		0xFFFFFFE0
+#define ISP_32B_BOUNDARY_OFFSET		0x0000FFE0
+
+#define CONTROL_CSIRXFE			0x480022DC
+#define CONTROL_CSI			0x48002530
+
+/*PRCM Clock definition*/
+
+#define CM_FCLKEN_CAM			0x48004f00
+#define CM_ICLKEN_CAM			0x48004f10
+#define CM_AUTOIDLE_CAM			0x48004f30
+#define CM_CLKSEL_CAM			0x48004f40
+#define CM_CLKEN_PLL			0x48004D00
+#define CM_CLKSEL2_PLL			0x48004D44
+#define CTRL_PADCONF_CAM_HS		0x4800210C
+#define CTRL_PADCONF_CAM_XCLKA		0x48002110
+#define CTRL_PADCONF_CAM_D1		0x48002118
+#define CTRL_PADCONF_CAM_D3		0x4800211C
+#define CTRL_PADCONF_CAM_D5		0x48002120
+
+#define CTRL_PADCONF_CAM_D7		0x48002124
+#define CTRL_PADCONF_CAM_D9		0x48002128
+#define CTRL_PADCONF_CAM_D11		0x4800212C
+
+#define CM_ICLKEN_CAM_EN		0x1
+#define CM_FCLKEN_CAM_EN		0x1
+
+#define CM_CAM_MCLK_HZ			216000000
+
+/* ISP Submodules offset */
+
+#define ISP_REG_BASE			0x480BC000
+#define ISP_REG_SIZE			0x00001600
+
+#define ISPCBUFF_REG_BASE		0x480BC100
+#define ISPCBUFF_REG(offset)		(ISPCBUFF_REG_BASE + (offset))
+
+#define ISPCCP2A_REG_OFFSET		0x00000200
+#define ISPCCP2A_REG_BASE		0x480BC200
+
+#define ISPCCP2B_REG_OFFSET		0x00000400
+#define ISPCCP2B_REG_BASE		0x480BC400
+
+#define ISPCCDC_REG_OFFSET		0x00000600
+#define ISPCCDC_REG_BASE		0x480BC600
+
+#define ISPSCMP_REG_OFFSET		0x00000800
+#define ISPSCMP_REG_BASE		0x480BC800
+
+#define ISPHIST_REG_OFFSET		0x00000A00
+#define ISPHIST_REG_BASE		0x480BCA00
+#define ISPHIST_REG(offset)		(ISPHIST_REG_BASE + (offset))
+
+#define ISPH3A_REG_OFFSET		0x00000C00
+#define ISPH3A_REG_BASE				0x480BCC00
+#define ISPH3A_REG(offset)		(ISPH3A_REG_BASE + (offset))
+
+#define ISPPREVIEW_REG_OFFSET		0x00000E00
+#define ISPPREVIEW_REG_BASE		0x480BCE00
+
+#define ISPRESIZER_REG_OFFSET		0x00001000
+#define ISPRESIZER_REG_BASE		0x480BD000
+
+#define ISPSBL_REG_OFFSET		0x00001200
+#define ISPSBL_REG_BASE			0x480BD200
+
+#define ISPMMU_REG_OFFSET		0x00001400
+#define ISPMMU_REG_BASE			0x480BD400
+
+/* ISP module register offset */
+
+#define ISP_REVISION			0x480BC000
+#define ISP_SYSCONFIG			0x480BC004
+#define ISP_SYSSTATUS			0x480BC008
+#define ISP_IRQ0ENABLE			0x480BC00C
+#define ISP_IRQ0STATUS			0x480BC010
+#define ISP_IRQ1ENABLE			0x480BC014
+#define ISP_IRQ1STATUS			0x480BC018
+#define ISP_TCTRL_GRESET_LENGTH		0x480BC030
+#define ISP_TCTRL_PSTRB_REPLAY		0x480BC034
+#define ISP_CTRL			0x480BC040
+#define ISP_SECURE			0x480BC044
+#define ISP_TCTRL_CTRL			0x480BC050
+#define ISP_TCTRL_FRAME			0x480BC054
+#define ISP_TCTRL_PSTRB_DELAY		0x480BC058
+#define ISP_TCTRL_STRB_DELAY		0x480BC05C
+#define ISP_TCTRL_SHUT_DELAY		0x480BC060
+#define ISP_TCTRL_PSTRB_LENGTH		0x480BC064
+#define ISP_TCTRL_STRB_LENGTH		0x480BC068
+#define ISP_TCTRL_SHUT_LENGTH		0x480BC06C
+#define ISP_PING_PONG_ADDR		0x480BC070
+#define ISP_PING_PONG_MEM_RANGE		0x480BC074
+#define ISP_PING_PONG_BUF_SIZE		0x480BC078
+
+/* CSI1 receiver registers (ES2.0) */
+#define ISPCSI1_REVISION		0x480BC400
+#define ISPCSI1_SYSCONFIG		0x480BC404
+#define ISPCSI1_SYSSTATUS		0x480BC408
+#define ISPCSI1_LC01_IRQENABLE		0x480BC40C
+#define ISPCSI1_LC01_IRQSTATUS		0x480BC410
+#define ISPCSI1_LC23_IRQENABLE		0x480BC414
+#define ISPCSI1_LC23_IRQSTATUS		0x480BC418
+#define ISPCSI1_LCM_IRQENABLE		0x480BC42C
+#define ISPCSI1_LCM_IRQSTATUS		0x480BC430
+#define ISPCSI1_CTRL			0x480BC440
+#define ISPCSI1_DBG			0x480BC444
+#define ISPCSI1_GNQ			0x480BC448
+#define ISPCSI1_LCx_CTRL(x)		(0x480BC450+0x30*(x))
+#define ISPCSI1_LCx_CODE(x)		(0x480BC454+0x30*(x))
+#define ISPCSI1_LCx_STAT_START(x)	(0x480BC458+0x30*(x))
+#define ISPCSI1_LCx_STAT_SIZE(x)	(0x480BC45C+0x30*(x))
+#define ISPCSI1_LCx_SOF_ADDR(x)		(0x480BC460+0x30*(x))
+#define ISPCSI1_LCx_EOF_ADDR(x)		(0x480BC464+0x30*(x))
+#define ISPCSI1_LCx_DAT_START(x)	(0x480BC468+0x30*(x))
+#define ISPCSI1_LCx_DAT_SIZE(x)		(0x480BC46C+0x30*(x))
+#define ISPCSI1_LCx_DAT_PING_ADDR(x)	(0x480BC470+0x30*(x))
+#define ISPCSI1_LCx_DAT_PONG_ADDR(x)	(0x480BC474+0x30*(x))
+#define ISPCSI1_LCx_DAT_OFST(x)		(0x480BC478+0x30*(x))
+#define ISPCSI1_LCM_CTRL		0x480BC5D0
+#define ISPCSI1_LCM_VSIZE		0x480BC5D4
+#define ISPCSI1_LCM_HSIZE		0x480BC5D8
+#define ISPCSI1_LCM_PREFETCH		0x480BC5DC
+#define ISPCSI1_LCM_SRC_ADDR		0x480BC5E0
+#define ISPCSI1_LCM_SRC_OFST		0x480BC5E4
+#define ISPCSI1_LCM_DST_ADDR		0x480BC5E8
+#define ISPCSI1_LCM_DST_OFST		0x480BC5EC
+
+/* CSI2 receiver registers (ES2.0) */
+#define ISPCSI2_REVISION		0x480BD800
+#define ISPCSI2_SYSCONFIG		0x480BD810
+#define ISPCSI2_SYSSTATUS		0x480BD814
+#define ISPCSI2_IRQSTATUS		0x480BD818
+#define ISPCSI2_IRQENABLE		0x480BD81C
+#define ISPCSI2_CTRL			0x480BD840
+#define ISPCSI2_DBG_H			0x480BD844
+#define ISPCSI2_GNQ			0x480BD848
+#define ISPCSI2_COMPLEXIO_CFG1		0x480BD850
+#define ISPCSI2_COMPLEXIO1_IRQSTATUS	0x480BD854
+#define ISPCSI2_SHORT_PACKET		0x480BD85C
+#define ISPCSI2_COMPLEXIO1_IRQENABLE	0x480BD860
+#define ISPCSI2_DBG_P			0x480BD868
+#define ISPCSI2_TIMING			0x480BD86C
+#define ISPCSI2_CTX_CTRL1(n)		(0x480BD870+0x20*(n))
+#define ISPCSI2_CTX_CTRL2(n)		(0x480BD874+0x20*(n))
+#define ISPCSI2_CTX_DAT_OFST(n)		(0x480BD878+0x20*(n))
+#define ISPCSI2_CTX_DAT_PING_ADDR(n)	(0x480BD87C+0x20*(n))
+#define ISPCSI2_CTX_DAT_PONG_ADDR(n)	(0x480BD880+0x20*(n))
+#define ISPCSI2_CTX_IRQENABLE(n)	(0x480BD884+0x20*(n))
+#define ISPCSI2_CTX_IRQSTATUS(n)	(0x480BD888+0x20*(n))
+#define ISPCSI2_CTX_CTRL3(n)		(0x480BD88C+0x20*(n))
+
+#define ISP_CSIB_SYSCONFIG		ISPCSI1_SYSCONFIG
+#define ISP_CSIA_SYSCONFIG		ISPCSI2_SYSCONFIG
+
+/* ISP_CBUFF Registers */
+
+#define ISP_CBUFF_SYSCONFIG		ISPCBUFF_REG(0x010)
+#define ISP_CBUFF_IRQENABLE		ISPCBUFF_REG(0x01C)
+
+#define ISP_CBUFF0_CTRL			ISPCBUFF_REG(0x020)
+#define ISP_CBUFF1_CTRL			(ISP_CBUFF0_CTRL + (0x004))
+
+#define ISP_CBUFF0_START		ISPCBUFF_REG(0x040)
+#define ISP_CBUFF1_START		(ISP_CBUFF0_START + (0x004))
+
+#define ISP_CBUFF0_END			ISPCBUFF_REG(0x050)
+#define ISP_CBUFF1_END			(ISP_CBUFF0_END + (0x04))
+
+#define ISP_CBUFF0_WINDOWSIZE		ISPCBUFF_REG(0x060)
+#define ISP_CBUFF1_WINDOWSIZE		(ISP_CBUFF0_WINDOWSIZE + (0x004))
+
+#define ISP_CBUFF0_THRESHOLD		ISPCBUFF_REG(0x070)
+#define ISP_CBUFF1_THRESHOLD		(ISP_CBUFF0_THRESHOLD + (0x004))
+
+/* CCDC module register offset */
+
+#define ISPCCDC_PID			0x480BC600
+#define ISPCCDC_PCR			0x480BC604
+#define ISPCCDC_SYN_MODE		0x480BC608
+#define ISPCCDC_HD_VD_WID		0x480BC60C
+#define ISPCCDC_PIX_LINES		0x480BC610
+#define ISPCCDC_HORZ_INFO		0x480BC614
+#define ISPCCDC_VERT_START		0x480BC618
+#define ISPCCDC_VERT_LINES		0x480BC61C
+#define ISPCCDC_CULLING			0x480BC620
+#define ISPCCDC_HSIZE_OFF		0x480BC624
+#define ISPCCDC_SDOFST			0x480BC628
+#define ISPCCDC_SDR_ADDR		0x480BC62C
+#define ISPCCDC_CLAMP			0x480BC630
+#define ISPCCDC_DCSUB			0x480BC634
+#define ISPCCDC_COLPTN			0x480BC638
+#define ISPCCDC_BLKCMP			0x480BC63C
+#define ISPCCDC_FPC			0x480BC640
+#define ISPCCDC_FPC_ADDR		0x480BC644
+#define ISPCCDC_VDINT			0x480BC648
+#define ISPCCDC_ALAW			0x480BC64C
+#define ISPCCDC_REC656IF		0x480BC650
+#define ISPCCDC_CFG			0x480BC654
+#define ISPCCDC_FMTCFG			0x480BC658
+#define ISPCCDC_FMT_HORZ		0x480BC65C
+#define ISPCCDC_FMT_VERT		0x480BC660
+#define ISPCCDC_FMT_ADDR0		0x480BC664
+#define ISPCCDC_FMT_ADDR1		0x480BC668
+#define ISPCCDC_FMT_ADDR2		0x480BC66C
+#define ISPCCDC_FMT_ADDR3		0x480BC670
+#define ISPCCDC_FMT_ADDR4		0x480BC674
+#define ISPCCDC_FMT_ADDR5		0x480BC678
+#define ISPCCDC_FMT_ADDR6		0x480BC67C
+#define ISPCCDC_FMT_ADDR7		0x480BC680
+#define ISPCCDC_PRGEVEN0		0x480BC684
+#define ISPCCDC_PRGEVEN1		0x480BC688
+#define ISPCCDC_PRGODD0			0x480BC68C
+#define ISPCCDC_PRGODD1			0x480BC690
+#define ISPCCDC_VP_OUT			0x480BC694
+
+#define ISPCCDC_LSC_CONFIG		0x480BC698
+#define ISPCCDC_LSC_INITIAL		0x480BC69C
+#define ISPCCDC_LSC_TABLE_BASE		0x480BC6A0
+#define ISPCCDC_LSC_TABLE_OFFSET	0x480BC6A4
+
+/* Histogram registers */
+#define ISPHIST_PID			ISPHIST_REG(0x000)
+#define ISPHIST_PCR			ISPHIST_REG(0x004)
+#define ISPHIST_CNT			ISPHIST_REG(0x008)
+#define ISPHIST_WB_GAIN			ISPHIST_REG(0x00C)
+#define ISPHIST_R0_HORZ			ISPHIST_REG(0x010)
+#define ISPHIST_R0_VERT			ISPHIST_REG(0x014)
+#define ISPHIST_R1_HORZ			ISPHIST_REG(0x018)
+#define ISPHIST_R1_VERT			ISPHIST_REG(0x01C)
+#define ISPHIST_R2_HORZ			ISPHIST_REG(0x020)
+#define ISPHIST_R2_VERT			ISPHIST_REG(0x024)
+#define ISPHIST_R3_HORZ			ISPHIST_REG(0x028)
+#define ISPHIST_R3_VERT			ISPHIST_REG(0x02C)
+#define ISPHIST_ADDR			ISPHIST_REG(0x030)
+#define ISPHIST_DATA			ISPHIST_REG(0x034)
+#define ISPHIST_RADD			ISPHIST_REG(0x038)
+#define ISPHIST_RADD_OFF		ISPHIST_REG(0x03C)
+#define ISPHIST_H_V_INFO		ISPHIST_REG(0x040)
+
+/* H3A module registers */
+#define ISPH3A_PID			ISPH3A_REG(0x000)
+#define ISPH3A_PCR			ISPH3A_REG(0x004)
+#define ISPH3A_AEWWIN1			ISPH3A_REG(0x04C)
+#define ISPH3A_AEWINSTART		ISPH3A_REG(0x050)
+#define ISPH3A_AEWINBLK			ISPH3A_REG(0x054)
+#define ISPH3A_AEWSUBWIN		ISPH3A_REG(0x058)
+#define ISPH3A_AEWBUFST			ISPH3A_REG(0x05C)
+#define ISPH3A_AFPAX1			ISPH3A_REG(0x008)
+#define ISPH3A_AFPAX2			ISPH3A_REG(0x00C)
+#define ISPH3A_AFPAXSTART		ISPH3A_REG(0x010)
+#define ISPH3A_AFIIRSH			ISPH3A_REG(0x014)
+#define ISPH3A_AFBUFST			ISPH3A_REG(0x018)
+#define ISPH3A_AFCOEF010		ISPH3A_REG(0x01C)
+#define ISPH3A_AFCOEF032		ISPH3A_REG(0x020)
+#define ISPH3A_AFCOEF054		ISPH3A_REG(0x024)
+#define ISPH3A_AFCOEF076		ISPH3A_REG(0x028)
+#define ISPH3A_AFCOEF098		ISPH3A_REG(0x02C)
+#define ISPH3A_AFCOEF0010		ISPH3A_REG(0x030)
+#define ISPH3A_AFCOEF110		ISPH3A_REG(0x034)
+#define ISPH3A_AFCOEF132		ISPH3A_REG(0x038)
+#define ISPH3A_AFCOEF154		ISPH3A_REG(0x03C)
+#define ISPH3A_AFCOEF176		ISPH3A_REG(0x040)
+#define ISPH3A_AFCOEF198		ISPH3A_REG(0x044)
+#define ISPH3A_AFCOEF1010		ISPH3A_REG(0x048)
+
+#define ISPPRV_PCR			0x480BCE04
+#define ISPPRV_HORZ_INFO		0x480BCE08
+#define ISPPRV_VERT_INFO		0x480BCE0C
+#define ISPPRV_RSDR_ADDR		0x480BCE10
+#define ISPPRV_RADR_OFFSET		0x480BCE14
+#define ISPPRV_DSDR_ADDR		0x480BCE18
+#define ISPPRV_DRKF_OFFSET		0x480BCE1C
+#define ISPPRV_WSDR_ADDR		0x480BCE20
+#define ISPPRV_WADD_OFFSET		0x480BCE24
+#define ISPPRV_AVE			0x480BCE28
+#define ISPPRV_HMED			0x480BCE2C
+#define ISPPRV_NF			0x480BCE30
+#define ISPPRV_WB_DGAIN			0x480BCE34
+#define ISPPRV_WBGAIN			0x480BCE38
+#define ISPPRV_WBSEL			0x480BCE3C
+#define ISPPRV_CFA			0x480BCE40
+#define ISPPRV_BLKADJOFF		0x480BCE44
+#define ISPPRV_RGB_MAT1			0x480BCE48
+#define ISPPRV_RGB_MAT2			0x480BCE4C
+#define ISPPRV_RGB_MAT3			0x480BCE50
+#define ISPPRV_RGB_MAT4			0x480BCE54
+#define ISPPRV_RGB_MAT5			0x480BCE58
+#define ISPPRV_RGB_OFF1			0x480BCE5C
+#define ISPPRV_RGB_OFF2			0x480BCE60
+#define ISPPRV_CSC0			0x480BCE64
+#define ISPPRV_CSC1			0x480BCE68
+#define ISPPRV_CSC2			0x480BCE6C
+#define ISPPRV_CSC_OFFSET		0x480BCE70
+#define ISPPRV_CNT_BRT			0x480BCE74
+#define ISPPRV_CSUP			0x480BCE78
+#define ISPPRV_SETUP_YC			0x480BCE7C
+#define ISPPRV_SET_TBL_ADDR		0x480BCE80
+#define ISPPRV_SET_TBL_DATA		0x480BCE84
+#define ISPPRV_CDC_THR0			0x480BCE90
+#define ISPPRV_CDC_THR1			(ISPPRV_CDC_THR0 + (0x4))
+#define ISPPRV_CDC_THR2			(ISPPRV_CDC_THR0 + (0x4) * 2)
+#define ISPPRV_CDC_THR3			(ISPPRV_CDC_THR0 + (0x4) * 3)
+
+#define ISPPRV_REDGAMMA_TABLE_ADDR	0x0000
+#define ISPPRV_GREENGAMMA_TABLE_ADDR	0x0400
+#define ISPPRV_BLUEGAMMA_TABLE_ADDR	0x0800
+#define ISPPRV_NF_TABLE_ADDR		0x0C00
+#define ISPPRV_YENH_TABLE_ADDR		0x1000
+#define ISPPRV_CFA_TABLE_ADDR		0x1400
+
+#define ISPPRV_MAXOUTPUT_WIDTH		1280
+#define ISPPRV_MAXOUTPUT_WIDTH_ES2	3300
+
+/* Resizer module register offset */
+#define ISPRSZ_PID			0x480BD000
+#define ISPRSZ_PCR			0x480BD004
+#define ISPRSZ_CNT			0x480BD008
+#define ISPRSZ_OUT_SIZE			0x480BD00C
+#define ISPRSZ_IN_START			0x480BD010
+#define ISPRSZ_IN_SIZE			0x480BD014
+#define ISPRSZ_SDR_INADD		0x480BD018
+#define ISPRSZ_SDR_INOFF		0x480BD01C
+#define ISPRSZ_SDR_OUTADD		0x480BD020
+#define ISPRSZ_SDR_OUTOFF		0x480BD024
+#define ISPRSZ_HFILT10			0x480BD028
+#define ISPRSZ_HFILT32			0x480BD02C
+#define ISPRSZ_HFILT54			0x480BD030
+#define ISPRSZ_HFILT76			0x480BD034
+#define ISPRSZ_HFILT98			0x480BD038
+#define ISPRSZ_HFILT1110		0x480BD03C
+#define ISPRSZ_HFILT1312		0x480BD040
+#define ISPRSZ_HFILT1514		0x480BD044
+#define ISPRSZ_HFILT1716		0x480BD048
+#define ISPRSZ_HFILT1918		0x480BD04C
+#define ISPRSZ_HFILT2120		0x480BD050
+#define ISPRSZ_HFILT2322		0x480BD054
+#define ISPRSZ_HFILT2524		0x480BD058
+#define ISPRSZ_HFILT2726		0x480BD05C
+#define ISPRSZ_HFILT2928		0x480BD060
+#define ISPRSZ_HFILT3130		0x480BD064
+#define ISPRSZ_VFILT10			0x480BD068
+#define ISPRSZ_VFILT32			0x480BD06C
+#define ISPRSZ_VFILT54			0x480BD070
+#define ISPRSZ_VFILT76			0x480BD074
+#define ISPRSZ_VFILT98			0x480BD078
+#define ISPRSZ_VFILT1110		0x480BD07C
+#define ISPRSZ_VFILT1312		0x480BD080
+#define ISPRSZ_VFILT1514		0x480BD084
+#define ISPRSZ_VFILT1716		0x480BD088
+#define ISPRSZ_VFILT1918		0x480BD08C
+#define ISPRSZ_VFILT2120		0x480BD090
+#define ISPRSZ_VFILT2322		0x480BD094
+#define ISPRSZ_VFILT2524		0x480BD098
+#define ISPRSZ_VFILT2726		0x480BD09C
+#define ISPRSZ_VFILT2928		0x480BD0A0
+#define ISPRSZ_VFILT3130		0x480BD0A4
+#define ISPRSZ_YENH			0x480BD0A8
+
+/* MMU module registers */
+#define ISPMMU_REVISION			0x480BD400
+#define ISPMMU_SYSCONFIG		0x480BD410
+#define ISPMMU_SYSSTATUS		0x480BD414
+#define ISPMMU_IRQSTATUS		0x480BD418
+#define ISPMMU_IRQENABLE		0x480BD41C
+#define ISPMMU_WALKING_ST		0x480BD440
+#define ISPMMU_CNTL			0x480BD444
+#define ISPMMU_FAULT_AD			0x480BD448
+#define ISPMMU_TTB			0x480BD44C
+#define ISPMMU_LOCK			0x480BD450
+#define ISPMMU_LD_TLB			0x480BD454
+#define ISPMMU_CAM			0x480BD458
+#define ISPMMU_RAM			0x480BD45C
+#define ISPMMU_GFLUSH			0x480BD460
+#define ISPMMU_FLUSH_ENTRY		0x480BD464
+#define ISPMMU_READ_CAM			0x480BD468
+#define ISPMMU_READ_RAM			0x480BD46c
+#define ISPMMU_EMU_FAULT_AD		0x480BD470
+
+#define ISP_INT_CLR			0xFF113F11
+#define ISPPRV_PCR_EN			1
+#define ISPPRV_PCR_BUSY			(1 << 1)
+#define ISPPRV_PCR_SOURCE		(1 << 2)
+#define ISPPRV_PCR_ONESHOT		(1 << 3)
+#define ISPPRV_PCR_WIDTH		(1 << 4)
+#define ISPPRV_PCR_INVALAW		(1 << 5)
+#define ISPPRV_PCR_DRKFEN		(1 << 6)
+#define ISPPRV_PCR_DRKFCAP		(1 << 7)
+#define ISPPRV_PCR_HMEDEN		(1 << 8)
+#define ISPPRV_PCR_NFEN			(1 << 9)
+#define ISPPRV_PCR_CFAEN		(1 << 10)
+#define ISPPRV_PCR_CFAFMT_SHIFT		11
+#define ISPPRV_PCR_CFAFMT_MASK		0x7800
+#define ISPPRV_PCR_CFAFMT_BAYER		(0 << 11)
+#define ISPPRV_PCR_CFAFMT_SONYVGA	(1 << 11)
+#define ISPPRV_PCR_CFAFMT_RGBFOVEON	(2 << 11)
+#define ISPPRV_PCR_CFAFMT_DNSPL		(3 << 11)
+#define ISPPRV_PCR_CFAFMT_HONEYCOMB	(4 << 11)
+#define ISPPRV_PCR_CFAFMT_RRGGBBFOVEON	(5 << 11)
+#define ISPPRV_PCR_YNENHEN		(1 << 15)
+#define ISPPRV_PCR_SUPEN		(1 << 16)
+#define ISPPRV_PCR_YCPOS_SHIFT		17
+#define ISPPRV_PCR_YCPOS_YCrYCb		(0 << 17)
+#define ISPPRV_PCR_YCPOS_YCbYCr		(1 << 17)
+#define ISPPRV_PCR_YCPOS_CbYCrY		(2 << 17)
+#define ISPPRV_PCR_YCPOS_CrYCbY		(3 << 17)
+#define ISPPRV_PCR_RSZPORT		(1 << 19)
+#define ISPPRV_PCR_SDRPORT		(1 << 20)
+#define ISPPRV_PCR_SCOMP_EN		(1 << 21)
+#define ISPPRV_PCR_SCOMP_SFT_SHIFT	(22)
+#define ISPPRV_PCR_SCOMP_SFT_MASK	(~(7 << 22))
+#define ISPPRV_PCR_GAMMA_BYPASS		(1 << 26)
+#define ISPPRV_PCR_DCOREN		(1 << 27)
+#define ISPPRV_PCR_DCCOUP		(1 << 28)
+#define ISPPRV_PCR_DRK_FAIL		(1 << 31)
+
+#define ISPPRV_HORZ_INFO_EPH_SHIFT	0
+#define ISPPRV_HORZ_INFO_EPH_MASK	0x3fff
+#define ISPPRV_HORZ_INFO_SPH_SHIFT	16
+#define ISPPRV_HORZ_INFO_SPH_MASK	0x3fff0
+
+#define ISPPRV_VERT_INFO_ELV_SHIFT	0
+#define ISPPRV_VERT_INFO_ELV_MASK	0x3fff
+#define ISPPRV_VERT_INFO_SLV_SHIFT	16
+#define ISPPRV_VERT_INFO_SLV_MASK	0x3fff0
+
+#define ISPPRV_AVE_EVENDIST_SHIFT	2
+#define ISPPRV_AVE_EVENDIST_1		0x0
+#define ISPPRV_AVE_EVENDIST_2		0x1
+#define ISPPRV_AVE_EVENDIST_3		0x2
+#define ISPPRV_AVE_EVENDIST_4		0x3
+#define ISPPRV_AVE_ODDDIST_SHIFT	4
+#define ISPPRV_AVE_ODDDIST_1		0x0
+#define ISPPRV_AVE_ODDDIST_2		0x1
+#define ISPPRV_AVE_ODDDIST_3		0x2
+#define ISPPRV_AVE_ODDDIST_4		0x3
+
+#define ISPPRV_HMED_THRESHOLD_SHIFT	0
+#define ISPPRV_HMED_EVENDIST		(1 << 8)
+#define ISPPRV_HMED_ODDDIST		(1 << 9)
+
+#define ISPPRV_WBGAIN_COEF0_SHIFT	0
+#define ISPPRV_WBGAIN_COEF1_SHIFT	8
+#define ISPPRV_WBGAIN_COEF2_SHIFT	16
+#define ISPPRV_WBGAIN_COEF3_SHIFT	24
+
+#define ISPPRV_WBSEL_COEF0		0x0
+#define ISPPRV_WBSEL_COEF1		0x1
+#define ISPPRV_WBSEL_COEF2		0x2
+#define ISPPRV_WBSEL_COEF3		0x3
+
+#define ISPPRV_WBSEL_N0_0_SHIFT		0
+#define ISPPRV_WBSEL_N0_1_SHIFT		2
+#define ISPPRV_WBSEL_N0_2_SHIFT		4
+#define ISPPRV_WBSEL_N0_3_SHIFT		6
+#define ISPPRV_WBSEL_N1_0_SHIFT		8
+#define ISPPRV_WBSEL_N1_1_SHIFT		10
+#define ISPPRV_WBSEL_N1_2_SHIFT		12
+#define ISPPRV_WBSEL_N1_3_SHIFT		14
+#define ISPPRV_WBSEL_N2_0_SHIFT		16
+#define ISPPRV_WBSEL_N2_1_SHIFT		18
+#define ISPPRV_WBSEL_N2_2_SHIFT		20
+#define ISPPRV_WBSEL_N2_3_SHIFT		22
+#define ISPPRV_WBSEL_N3_0_SHIFT		24
+#define ISPPRV_WBSEL_N3_1_SHIFT		26
+#define ISPPRV_WBSEL_N3_2_SHIFT		28
+#define ISPPRV_WBSEL_N3_3_SHIFT		30
+
+#define ISPPRV_CFA_GRADTH_HOR_SHIFT	0
+#define ISPPRV_CFA_GRADTH_VER_SHIFT	8
+
+#define ISPPRV_BLKADJOFF_B_SHIFT	0
+#define ISPPRV_BLKADJOFF_G_SHIFT	8
+#define ISPPRV_BLKADJOFF_R_SHIFT	16
+
+#define ISPPRV_RGB_MAT1_MTX_RR_SHIFT	0
+#define ISPPRV_RGB_MAT1_MTX_GR_SHIFT	16
+
+#define ISPPRV_RGB_MAT2_MTX_BR_SHIFT	0
+#define ISPPRV_RGB_MAT2_MTX_RG_SHIFT	16
+
+#define ISPPRV_RGB_MAT3_MTX_GG_SHIFT	0
+#define ISPPRV_RGB_MAT3_MTX_BG_SHIFT	16
+
+#define ISPPRV_RGB_MAT4_MTX_RB_SHIFT	0
+#define ISPPRV_RGB_MAT4_MTX_GB_SHIFT	16
+
+#define ISPPRV_RGB_MAT5_MTX_BB_SHIFT	0
+
+#define ISPPRV_RGB_OFF1_MTX_OFFG_SHIFT	0
+#define ISPPRV_RGB_OFF1_MTX_OFFR_SHIFT	16
+
+#define ISPPRV_RGB_OFF2_MTX_OFFB_SHIFT	0
+
+#define ISPPRV_CSC0_RY_SHIFT		0
+#define ISPPRV_CSC0_GY_SHIFT		10
+#define ISPPRV_CSC0_BY_SHIFT		20
+
+#define ISPPRV_CSC1_RCB_SHIFT		0
+#define ISPPRV_CSC1_GCB_SHIFT		10
+#define ISPPRV_CSC1_BCB_SHIFT		20
+
+#define ISPPRV_CSC2_RCR_SHIFT		0
+#define ISPPRV_CSC2_GCR_SHIFT		10
+#define ISPPRV_CSC2_BCR_SHIFT		20
+
+#define ISPPRV_CSC_OFFSET_CR_SHIFT	0
+#define ISPPRV_CSC_OFFSET_CB_SHIFT	8
+#define ISPPRV_CSC_OFFSET_Y_SHIFT	16
+
+#define ISPPRV_CNT_BRT_BRT_SHIFT	0
+#define ISPPRV_CNT_BRT_CNT_SHIFT	8
+
+#define ISPPRV_CONTRAST_MAX		0x10
+#define ISPPRV_CONTRAST_MIN		0xFF
+#define ISPPRV_BRIGHT_MIN		0x00
+#define ISPPRV_BRIGHT_MAX		0xFF
+
+#define ISPPRV_CSUP_CSUPG_SHIFT		0
+#define ISPPRV_CSUP_THRES_SHIFT		8
+#define ISPPRV_CSUP_HPYF_SHIFT		16
+
+#define ISPPRV_SETUP_YC_MINC_SHIFT	0
+#define ISPPRV_SETUP_YC_MAXC_SHIFT	8
+#define ISPPRV_SETUP_YC_MINY_SHIFT	16
+#define ISPPRV_SETUP_YC_MAXY_SHIFT	24
+#define ISPPRV_YC_MAX			0xFF
+#define ISPPRV_YC_MIN			0x0
+
+/* Define bit fields within selected registers */
+#define ISP_REVISION_SHIFT			0
+
+#define ISP_SYSCONFIG_AUTOIDLE			0
+#define ISP_SYSCONFIG_SOFTRESET			(1 << 1)
+#define ISP_SYSCONFIG_MIDLEMODE_SHIFT		12
+#define ISP_SYSCONFIG_MIDLEMODE_FORCESTANDBY	0x0
+#define ISP_SYSCONFIG_MIDLEMODE_NOSTANBY	0x1
+#define ISP_SYSCONFIG_MIDLEMODE_SMARTSTANDBY	0x2
+
+#define ISP_SYSSTATUS_RESETDONE			0
+
+#define IRQ0ENABLE_CSIA_IRQ			1
+#define IRQ0ENABLE_CSIA_LC1_IRQ			(1 << 1)
+#define IRQ0ENABLE_CSIA_LC2_IRQ			(1 << 2)
+#define IRQ0ENABLE_CSIA_LC3_IRQ			(1 << 3)
+#define IRQ0ENABLE_CSIB_IRQ			(1 << 4)
+#define IRQ0ENABLE_CSIB_LC1_IRQ			(1 << 5)
+#define IRQ0ENABLE_CSIB_LC2_IRQ			(1 << 6)
+#define IRQ0ENABLE_CSIB_LC3_IRQ			(1 << 7)
+#define IRQ0ENABLE_CCDC_VD0_IRQ			(1 << 8)
+#define IRQ0ENABLE_CCDC_VD1_IRQ			(1 << 9)
+#define IRQ0ENABLE_CCDC_VD2_IRQ			(1 << 10)
+#define IRQ0ENABLE_CCDC_ERR_IRQ			(1 << 11)
+#define IRQ0ENABLE_H3A_AF_DONE_IRQ		(1 << 12)
+#define IRQ0ENABLE_H3A_AWB_DONE_IRQ		(1 << 13)
+#define IRQ0ENABLE_HIST_DONE_IRQ		(1 << 16)
+#define IRQ0ENABLE_CCDC_LSC_DONE_IRQ		(1 << 17)
+#define IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ	(1 << 18)
+#define IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ	(1 << 19)
+#define IRQ0ENABLE_PRV_DONE_IRQ			(1 << 20)
+#define IRQ0ENABLE_RSZ_DONE_IRQ			(1 << 24)
+#define IRQ0ENABLE_OVF_IRQ			(1 << 25)
+#define IRQ0ENABLE_PING_IRQ			(1 << 26)
+#define IRQ0ENABLE_PONG_IRQ			(1 << 27)
+#define IRQ0ENABLE_MMU_ERR_IRQ			(1 << 28)
+#define IRQ0ENABLE_OCP_ERR_IRQ			(1 << 29)
+#define IRQ0ENABLE_SEC_ERR_IRQ			(1 << 30)
+#define IRQ0ENABLE_HS_VS_IRQ			(1 << 31)
+
+#define IRQ0STATUS_CSIA_IRQ			1
+#define IRQ0STATUS_CSIA_LC1_IRQ			(1 << 1)
+#define IRQ0STATUS_CSIA_LC2_IRQ			(1 << 2)
+#define IRQ0STATUS_CSIA_LC3_IRQ			(1 << 3)
+#define IRQ0STATUS_CSIB_IRQ			(1 << 4)
+#define IRQ0STATUS_CSIB_LC1_IRQ			(1 << 5)
+#define IRQ0STATUS_CSIB_LC2_IRQ			(1 << 6)
+#define IRQ0STATUS_CSIB_LC3_IRQ			(1 << 7)
+#define IRQ0STATUS_CCDC_VD0_IRQ			(1 << 8)
+#define IRQ0STATUS_CCDC_VD1_IRQ			(1 << 9)
+#define IRQ0STATUS_CCDC_VD2_IRQ			(1 << 10)
+#define IRQ0STATUS_CCDC_ERR_IRQ			(1 << 11)
+#define IRQ0STATUS_H3A_AF_DONE_IRQ		(1 << 12)
+#define IRQ0STATUS_H3A_AWB_DONE_IRQ		(1 << 13)
+#define IRQ0STATUS_HIST_DONE_IRQ		(1 << 16)
+#define IRQ0STATUS_PRV_DONE_IRQ			(1 << 20)
+#define IRQ0STATUS_RSZ_DONE_IRQ			(1 << 24)
+#define IRQ0STATUS_OVF_IRQ			(1 << 25)
+#define IRQ0STATUS_PING_IRQ			(1 << 26)
+#define IRQ0STATUS_PONG_IRQ			(1 << 27)
+#define IRQ0STATUS_MMU_ERR_IRQ			(1 << 28)
+#define IRQ0STATUS_OCP_ERR_IRQ			(1 << 29)
+#define IRQ0STATUS_SEC_ERR_IRQ			(1 << 30)
+#define IRQ0STATUS_HS_VS_IRQ			(1 << 31)
+
+#define TCTRL_GRESET_LEN			0
+
+#define TCTRL_PSTRB_REPLAY_DELAY		0
+#define TCTRL_PSTRB_REPLAY_COUNTER_SHIFT	25
+
+#define ISPCTRL_PAR_SER_CLK_SEL_PARALLEL	0x0
+#define ISPCTRL_PAR_SER_CLK_SEL_CSIA		0x1
+#define ISPCTRL_PAR_SER_CLK_SEL_CSIB		0x2
+#define ISPCTRL_PAR_SER_CLK_SEL_MASK		0xFFFFFFFC
+
+#define ISPCTRL_PAR_BRIDGE_SHIFT		2
+#define ISPCTRL_PAR_BRIDGE_DISABLE		(0x0 << 2)
+#define ISPCTRL_PAR_BRIDGE_LENDIAN		(0x2 << 2)
+#define ISPCTRL_PAR_BRIDGE_BENDIAN		(0x3 << 2)
+
+#define ISPCTRL_PAR_CLK_POL_SHIFT		4
+#define ISPCTRL_PAR_CLK_POL_INV			(1 << 4)
+#define ISPCTRL_PING_PONG_EN			(1 << 5)
+#define ISPCTRL_SHIFT_SHIFT			6
+#define ISPCTRL_SHIFT_0				(0x0 << 6)
+#define ISPCTRL_SHIFT_2				(0x1 << 6)
+#define ISPCTRL_SHIFT_4				(0x2 << 6)
+#define ISPCTRL_SHIFT_MASK			(~(0x3 << 6))
+
+#define ISPCTRL_CCDC_CLK_EN			(1 << 8)
+#define ISPCTRL_SCMP_CLK_EN			(1 << 9)
+#define ISPCTRL_H3A_CLK_EN			(1 << 10)
+#define ISPCTRL_HIST_CLK_EN			(1 << 11)
+#define ISPCTRL_PREV_CLK_EN			(1 << 12)
+#define ISPCTRL_RSZ_CLK_EN			(1 << 13)
+#define ISPCTRL_SYNC_DETECT_SHIFT		14
+#define ISPCTRL_SYNC_DETECT_HSFALL	(0x0 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_HSRISE	(0x1 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_VSFALL	(0x2 << ISPCTRL_SYNC_DETECT_SHIFT)
+#define ISPCTRL_SYNC_DETECT_VSRISE	(0x3 << ISPCTRL_SYNC_DETECT_SHIFT)
+
+#define ISPCTRL_CCDC_RAM_EN		(1 << 16)
+#define ISPCTRL_PREV_RAM_EN		(1 << 17)
+#define ISPCTRL_SBL_RD_RAM_EN		(1 << 18)
+#define ISPCTRL_SBL_WR1_RAM_EN		(1 << 19)
+#define ISPCTRL_SBL_WR0_RAM_EN		(1 << 20)
+#define ISPCTRL_SBL_AUTOIDLE		(1 << 21)
+#define ISPCTRL_SBL_SHARED_RPORTB	(1 << 28)
+#define ISPCTRL_JPEG_FLUSH		(1 << 30)
+#define ISPCTRL_CCDC_FLUSH		(1 << 31)
+
+#define ISPSECURE_SECUREMODE		0
+
+#define ISPTCTRL_CTRL_DIV_LOW		0x0
+#define ISPTCTRL_CTRL_DIV_HIGH		0x1
+#define ISPTCTRL_CTRL_DIV_BYPASS	0x1F
+
+#define ISPTCTRL_CTRL_DIVA_SHIFT	0
+#define ISPTCTRL_CTRL_DIVA_MASK		(0x1F << ISPTCTRL_CTRL_DIVA_SHIFT)
+
+#define ISPTCTRL_CTRL_DIVB_SHIFT	5
+#define ISPTCTRL_CTRL_DIVB_MASK		(0x1F << ISPTCTRL_CTRL_DIVB_SHIFT)
+
+#define ISPTCTRL_CTRL_DIVC_SHIFT	10
+#define ISPTCTRL_CTRL_DIVC_NOCLOCK	(0x0 << 10)
+
+#define ISPTCTRL_CTRL_SHUTEN		(1 << 21)
+#define ISPTCTRL_CTRL_PSTRBEN		(1 << 22)
+#define ISPTCTRL_CTRL_STRBEN		(1 << 23)
+#define ISPTCTRL_CTRL_SHUTPOL		(1 << 24)
+#define ISPTCTRL_CTRL_STRBPSTRBPOL	(1 << 26)
+
+#define ISPTCTRL_CTRL_INSEL_SHIFT	27
+#define ISPTCTRL_CTRL_INSEL_PARALLEL	(0x0 << 27)
+#define ISPTCTRL_CTRL_INSEL_CSIA	(0x1 << 27)
+#define ISPTCTRL_CTRL_INSEL_CSIB	(0x2 << 27)
+
+#define ISPTCTRL_CTRL_GRESETEn		(1 << 29)
+#define ISPTCTRL_CTRL_GRESETPOL		(1 << 30)
+#define ISPTCTRL_CTRL_GRESETDIR		(1 << 31)
+
+#define ISPTCTRL_FRAME_SHUT_SHIFT		0
+#define ISPTCTRL_FRAME_PSTRB_SHIFT		6
+#define ISPTCTRL_FRAME_STRB_SHIFT		12
+
+#define ISPCCDC_PID_PREV_SHIFT			0
+#define ISPCCDC_PID_CID_SHIFT			8
+#define ISPCCDC_PID_TID_SHIFT			16
+
+#define ISPCCDC_PCR_EN				1
+#define ISPCCDC_PCR_BUSY			(1 << 1)
+
+#define ISPCCDC_SYN_MODE_VDHDOUT		0x1
+#define ISPCCDC_SYN_MODE_FLDOUT			(1 << 1)
+#define ISPCCDC_SYN_MODE_VDPOL			(1 << 2)
+#define ISPCCDC_SYN_MODE_HDPOL			(1 << 3)
+#define ISPCCDC_SYN_MODE_FLDPOL			(1 << 4)
+#define ISPCCDC_SYN_MODE_EXWEN			(1 << 5)
+#define ISPCCDC_SYN_MODE_DATAPOL		(1 << 6)
+#define ISPCCDC_SYN_MODE_FLDMODE		(1 << 7)
+#define ISPCCDC_SYN_MODE_DATSIZ_MASK		0xFFFFF8FF
+#define ISPCCDC_SYN_MODE_DATSIZ_8_16		(0x0 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_12		(0x4 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_11		(0x5 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_10		(0x6 << 8)
+#define ISPCCDC_SYN_MODE_DATSIZ_8		(0x7 << 8)
+#define ISPCCDC_SYN_MODE_PACK8			(1 << 11)
+#define ISPCCDC_SYN_MODE_INPMOD_MASK		0xFFFFCFFF
+#define ISPCCDC_SYN_MODE_INPMOD_RAW		(0 << 12)
+#define ISPCCDC_SYN_MODE_INPMOD_YCBCR16		(1 << 12)
+#define ISPCCDC_SYN_MODE_INPMOD_YCBCR8		(2 << 12)
+#define ISPCCDC_SYN_MODE_LPF			(1 << 14)
+#define ISPCCDC_SYN_MODE_FLDSTAT		(1 << 15)
+#define ISPCCDC_SYN_MODE_VDHDEN			(1 << 16)
+#define ISPCCDC_SYN_MODE_WEN			(1 << 17)
+#define ISPCCDC_SYN_MODE_VP2SDR			(1 << 18)
+#define ISPCCDC_SYN_MODE_SDR2RSZ		(1 << 19)
+
+#define ISPCCDC_HD_VD_WID_VDW_SHIFT		0
+#define ISPCCDC_HD_VD_WID_HDW_SHIFT		16
+
+#define ISPCCDC_PIX_LINES_HLPRF_SHIFT		0
+#define ISPCCDC_PIX_LINES_PPLN_SHIFT		16
+
+#define ISPCCDC_HORZ_INFO_NPH_SHIFT		0
+#define ISPCCDC_HORZ_INFO_NPH_MASK		0xFFFF8000
+#define ISPCCDC_HORZ_INFO_SPH_MASK		0x1000FFFF
+#define ISPCCDC_HORZ_INFO_SPH_SHIFT		16
+
+#define ISPCCDC_VERT_START_SLV0_SHIFT		16
+#define ISPCCDC_VERT_START_SLV0_MASK		0x1000FFFF
+#define ISPCCDC_VERT_START_SLV1_SHIFT		0
+
+#define ISPCCDC_VERT_LINES_NLV_MASK		0xFFFF8000
+#define ISPCCDC_VERT_LINES_NLV_SHIFT		0
+
+#define ISPCCDC_CULLING_CULV_SHIFT		0
+#define ISPCCDC_CULLING_CULHODD_SHIFT		16
+#define ISPCCDC_CULLING_CULHEVN_SHIFT		24
+
+#define ISPCCDC_HSIZE_OFF_SHIFT			0
+
+#define ISPCCDC_SDOFST_FINV			(1 << 14)
+#define ISPCCDC_SDOFST_FOFST_1L			(~(3 << 12))
+#define ISPCCDC_SDOFST_FOFST_4L			(3 << 12)
+#define ISPCCDC_SDOFST_LOFST3_SHIFT		0
+#define ISPCCDC_SDOFST_LOFST2_SHIFT		3
+#define ISPCCDC_SDOFST_LOFST1_SHIFT		6
+#define ISPCCDC_SDOFST_LOFST0_SHIFT		9
+#define EVENEVEN				1
+#define ODDEVEN					2
+#define EVENODD					3
+#define ODDODD					4
+
+#define ISPCCDC_CLAMP_OBGAIN_SHIFT		0
+#define ISPCCDC_CLAMP_OBST_SHIFT		10
+#define ISPCCDC_CLAMP_OBSLN_SHIFT		25
+#define ISPCCDC_CLAMP_OBSLEN_SHIFT		28
+#define ISPCCDC_CLAMP_CLAMPEN			(1 << 31)
+
+#define ISPCCDC_COLPTN_R_Ye			0x0
+#define ISPCCDC_COLPTN_Gr_Cy			0x1
+#define ISPCCDC_COLPTN_Gb_G			0x2
+#define ISPCCDC_COLPTN_B_Mg			0x3
+#define ISPCCDC_COLPTN_CP0PLC0_SHIFT		0
+#define ISPCCDC_COLPTN_CP0PLC1_SHIFT		2
+#define ISPCCDC_COLPTN_CP0PLC2_SHIFT		4
+#define ISPCCDC_COLPTN_CP0PLC3_SHIFT		6
+#define ISPCCDC_COLPTN_CP1PLC0_SHIFT		8
+#define ISPCCDC_COLPTN_CP1PLC1_SHIFT		10
+#define ISPCCDC_COLPTN_CP1PLC2_SHIFT		12
+#define ISPCCDC_COLPTN_CP1PLC3_SHIFT		14
+#define ISPCCDC_COLPTN_CP2PLC0_SHIFT		16
+#define ISPCCDC_COLPTN_CP2PLC1_SHIFT		18
+#define ISPCCDC_COLPTN_CP2PLC2_SHIFT		20
+#define ISPCCDC_COLPTN_CP2PLC3_SHIFT		22
+#define ISPCCDC_COLPTN_CP3PLC0_SHIFT		24
+#define ISPCCDC_COLPTN_CP3PLC1_SHIFT		26
+#define ISPCCDC_COLPTN_CP3PLC2_SHIFT		28
+#define ISPCCDC_COLPTN_CP3PLC3_SHIFT		30
+
+#define ISPCCDC_BLKCMP_B_MG_SHIFT		0
+#define ISPCCDC_BLKCMP_GB_G_SHIFT		8
+#define ISPCCDC_BLKCMP_GR_CY_SHIFT		6
+#define ISPCCDC_BLKCMP_R_YE_SHIFT		24
+
+#define ISPCCDC_FPC_FPNUM_SHIFT			0
+#define ISPCCDC_FPC_FPCEN			(1 << 15)
+#define ISPCCDC_FPC_FPERR			(1 << 16)
+
+#define ISPCCDC_VDINT_1_SHIFT			0
+#define ISPCCDC_VDINT_0_SHIFT			16
+#define ISPCCDC_VDINT_0_MASK			0x7FFF
+#define ISPCCDC_VDINT_1_MASK			0x7FFF
+
+#define ISPCCDC_ALAW_GWDI_SHIFT			0
+#define ISPCCDC_ALAW_CCDTBL			(1 << 3)
+
+#define ISPCCDC_REC656IF_R656ON			1
+#define ISPCCDC_REC656IF_ECCFVH			(1 << 1)
+
+#define ISPCCDC_CFG_BW656			(1 << 5)
+#define ISPCCDC_CFG_FIDMD_SHIFT			6
+#define ISPCCDC_CFG_WENLOG			(1 << 8)
+#define ISPCCDC_CFG_Y8POS			(1 << 11)
+#define ISPCCDC_CFG_BSWD			(1 << 12)
+#define ISPCCDC_CFG_MSBINVI			(1 << 13)
+#define ISPCCDC_CFG_VDLC			(1 << 15)
+
+#define ISPCCDC_FMTCFG_FMTEN			0x1
+#define ISPCCDC_FMTCFG_LNALT			(1 << 1)
+#define ISPCCDC_FMTCFG_LNUM_SHIFT		2
+#define ISPCCDC_FMTCFG_PLEN_ODD_SHIFT		4
+#define ISPCCDC_FMTCFG_PLEN_EVEN_SHIFT		8
+#define ISPCCDC_FMTCFG_VPIN_MASK		0xFFFF8000
+#define ISPCCDC_FMTCFG_VPIN_12_3		(0x3 << 12)
+#define ISPCCDC_FMTCFG_VPIN_11_2		(0x4 << 12)
+#define ISPCCDC_FMTCFG_VPIN_10_1		(0x5 << 12)
+#define ISPCCDC_FMTCFG_VPIN_9_0			(0x6 << 12)
+#define ISPCCDC_FMTCFG_VPEN			(1 << 15)
+
+#define ISPCCDC_FMTCF_VPIF_FRQ_MASK		0xFFF8FFFF
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY2		(0x0 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY3		(0x1 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY4		(0x2 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY5		(0x3 << 16)
+#define ISPCCDC_FMTCF_VPIF_FRQ_BY6		(0x4 << 16)
+
+#define ISPCCDC_FMT_HORZ_FMTLNH_SHIFT		0
+#define ISPCCDC_FMT_HORZ_FMTSPH_SHIFT		16
+
+#define ISPCCDC_FMT_VERT_FMTLNV_SHIFT		0
+#define ISPCCDC_FMT_VERT_FMTSLV_SHIFT		16
+
+#define ISPCCDC_FMT_HORZ_FMTSPH_MASK		0x1FFF0000
+#define ISPCCDC_FMT_HORZ_FMTLNH_MASK		0x1FFF
+
+#define ISPCCDC_FMT_VERT_FMTSLV_MASK		0x1FFF0000
+#define ISPCCDC_FMT_VERT_FMTLNV_MASK		0x1FFF
+
+#define ISPCCDC_VP_OUT_HORZ_ST_SHIFT		0
+#define ISPCCDC_VP_OUT_HORZ_NUM_SHIFT		4
+#define ISPCCDC_VP_OUT_VERT_NUM_SHIFT		17
+
+#define ISPRSZ_PID_PREV_SHIFT			0
+#define ISPRSZ_PID_CID_SHIFT			8
+#define ISPRSZ_PID_TID_SHIFT			16
+
+#define ISPRSZ_PCR_ENABLE			0x5
+#define ISPRSZ_PCR_BUSY				(1 << 1)
+
+#define ISPRSZ_CNT_HRSZ_SHIFT			0
+#define ISPRSZ_CNT_HRSZ_MASK			0x3FF
+#define ISPRSZ_CNT_VRSZ_SHIFT			10
+#define ISPRSZ_CNT_VRSZ_MASK			0xFFC00
+#define ISPRSZ_CNT_HSTPH_SHIFT			20
+#define ISPRSZ_CNT_HSTPH_MASK			0x700000
+#define ISPRSZ_CNT_VSTPH_SHIFT			23
+#define	ISPRSZ_CNT_VSTPH_MASK			0x3800000
+#define	ISPRSZ_CNT_CBILIN_MASK			0x20000000
+#define	ISPRSZ_CNT_INPTYP_MASK			0x08000000
+#define	ISPRSZ_CNT_PIXFMT_MASK			0x04000000
+#define ISPRSZ_CNT_YCPOS			(1 << 26)
+#define ISPRSZ_CNT_INPTYP			(1 << 27)
+#define ISPRSZ_CNT_INPSRC			(1 << 28)
+#define ISPRSZ_CNT_CBILIN			(1 << 29)
+
+#define ISPRSZ_OUT_SIZE_HORZ_SHIFT		0
+#define ISPRSZ_OUT_SIZE_HORZ_MASK		0x7FF
+#define ISPRSZ_OUT_SIZE_VERT_SHIFT		16
+#define ISPRSZ_OUT_SIZE_VERT_MASK		0x7FF0000
+
+
+#define ISPRSZ_IN_START_HORZ_ST_SHIFT		0
+#define ISPRSZ_IN_START_HORZ_ST_MASK		0x1FFF
+#define ISPRSZ_IN_START_VERT_ST_SHIFT		16
+#define ISPRSZ_IN_START_VERT_ST_MASK		0x1FFF0000
+
+
+#define ISPRSZ_IN_SIZE_HORZ_SHIFT		0
+#define ISPRSZ_IN_SIZE_HORZ_MASK		0x1FFF
+#define ISPRSZ_IN_SIZE_VERT_SHIFT		16
+#define ISPRSZ_IN_SIZE_VERT_MASK		0x1FFF0000
+
+#define ISPRSZ_SDR_INADD_ADDR_SHIFT		0
+#define ISPRSZ_SDR_INADD_ADDR_MASK		0xFFFFFFFF
+
+#define ISPRSZ_SDR_INOFF_OFFSET_SHIFT		0
+#define ISPRSZ_SDR_INOFF_OFFSET_MASK		0xFFFF
+
+#define ISPRSZ_SDR_OUTADD_ADDR_SHIFT		0
+#define ISPRSZ_SDR_OUTADD_ADDR_MASK		0xFFFFFFFF
+
+
+#define ISPRSZ_SDR_OUTOFF_OFFSET_SHIFT		0
+#define ISPRSZ_SDR_OUTOFF_OFFSET_MASK		0xFFFF
+
+#define ISPRSZ_HFILT10_COEF0_SHIFT		0
+#define ISPRSZ_HFILT10_COEF0_MASK		0x3FF
+#define ISPRSZ_HFILT10_COEF1_SHIFT		16
+#define ISPRSZ_HFILT10_COEF1_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT32_COEF2_SHIFT		0
+#define ISPRSZ_HFILT32_COEF2_MASK		0x3FF
+#define ISPRSZ_HFILT32_COEF3_SHIFT		16
+#define ISPRSZ_HFILT32_COEF3_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT54_COEF4_SHIFT		0
+#define ISPRSZ_HFILT54_COEF4_MASK		0x3FF
+#define ISPRSZ_HFILT54_COEF5_SHIFT		16
+#define ISPRSZ_HFILT54_COEF5_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT76_COEFF6_SHIFT		0
+#define ISPRSZ_HFILT76_COEFF6_MASK		0x3FF
+#define ISPRSZ_HFILT76_COEFF7_SHIFT		16
+#define ISPRSZ_HFILT76_COEFF7_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT98_COEFF8_SHIFT		0
+#define ISPRSZ_HFILT98_COEFF8_MASK		0x3FF
+#define ISPRSZ_HFILT98_COEFF9_SHIFT		16
+#define ISPRSZ_HFILT98_COEFF9_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1110_COEF10_SHIFT		0
+#define ISPRSZ_HFILT1110_COEF10_MASK		0x3FF
+#define ISPRSZ_HFILT1110_COEF11_SHIFT		16
+#define ISPRSZ_HFILT1110_COEF11_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1312_COEFF12_SHIFT		0
+#define ISPRSZ_HFILT1312_COEFF12_MASK		0x3FF
+#define ISPRSZ_HFILT1312_COEFF13_SHIFT		16
+#define ISPRSZ_HFILT1312_COEFF13_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1514_COEFF14_SHIFT		0
+#define ISPRSZ_HFILT1514_COEFF14_MASK		0x3FF
+#define ISPRSZ_HFILT1514_COEFF15_SHIFT		16
+#define ISPRSZ_HFILT1514_COEFF15_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1716_COEF16_SHIFT		0
+#define ISPRSZ_HFILT1716_COEF16_MASK		0x3FF
+#define ISPRSZ_HFILT1716_COEF17_SHIFT		16
+#define ISPRSZ_HFILT1716_COEF17_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT1918_COEF18_SHIFT		0
+#define ISPRSZ_HFILT1918_COEF18_MASK		0x3FF
+#define ISPRSZ_HFILT1918_COEF19_SHIFT		16
+#define ISPRSZ_HFILT1918_COEF19_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2120_COEF20_SHIFT		0
+#define ISPRSZ_HFILT2120_COEF20_MASK		0x3FF
+#define ISPRSZ_HFILT2120_COEF21_SHIFT		16
+#define ISPRSZ_HFILT2120_COEF21_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2322_COEF22_SHIFT		0
+#define ISPRSZ_HFILT2322_COEF22_MASK		0x3FF
+#define ISPRSZ_HFILT2322_COEF23_SHIFT		16
+#define ISPRSZ_HFILT2322_COEF23_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2524_COEF24_SHIFT		0
+#define ISPRSZ_HFILT2524_COEF24_MASK		0x3FF
+#define ISPRSZ_HFILT2524_COEF25_SHIFT		16
+#define ISPRSZ_HFILT2524_COEF25_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2726_COEF26_SHIFT		0
+#define ISPRSZ_HFILT2726_COEF26_MASK		0x3FF
+#define ISPRSZ_HFILT2726_COEF27_SHIFT		16
+#define ISPRSZ_HFILT2726_COEF27_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT2928_COEF28_SHIFT		0
+#define ISPRSZ_HFILT2928_COEF28_MASK		0x3FF
+#define ISPRSZ_HFILT2928_COEF29_SHIFT		16
+#define ISPRSZ_HFILT2928_COEF29_MASK		0x3FF0000
+
+#define ISPRSZ_HFILT3130_COEF30_SHIFT		0
+#define ISPRSZ_HFILT3130_COEF30_MASK		0x3FF
+#define ISPRSZ_HFILT3130_COEF31_SHIFT		16
+#define ISPRSZ_HFILT3130_COEF31_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT10_COEF0_SHIFT		0
+#define ISPRSZ_VFILT10_COEF0_MASK		0x3FF
+#define ISPRSZ_VFILT10_COEF1_SHIFT		16
+#define ISPRSZ_VFILT10_COEF1_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT32_COEF2_SHIFT		0
+#define ISPRSZ_VFILT32_COEF2_MASK		0x3FF
+#define ISPRSZ_VFILT32_COEF3_SHIFT		16
+#define ISPRSZ_VFILT32_COEF3_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT54_COEF4_SHIFT		0
+#define ISPRSZ_VFILT54_COEF4_MASK		0x3FF
+#define ISPRSZ_VFILT54_COEF5_SHIFT		16
+#define ISPRSZ_VFILT54_COEF5_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT76_COEFF6_SHIFT		0
+#define ISPRSZ_VFILT76_COEFF6_MASK		0x3FF
+#define ISPRSZ_VFILT76_COEFF7_SHIFT		16
+#define ISPRSZ_VFILT76_COEFF7_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT98_COEFF8_SHIFT		0
+#define ISPRSZ_VFILT98_COEFF8_MASK		0x3FF
+#define ISPRSZ_VFILT98_COEFF9_SHIFT		16
+#define ISPRSZ_VFILT98_COEFF9_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1110_COEF10_SHIFT		0
+#define ISPRSZ_VFILT1110_COEF10_MASK		0x3FF
+#define ISPRSZ_VFILT1110_COEF11_SHIFT		16
+#define ISPRSZ_VFILT1110_COEF11_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1312_COEFF12_SHIFT		0
+#define ISPRSZ_VFILT1312_COEFF12_MASK		0x3FF
+#define ISPRSZ_VFILT1312_COEFF13_SHIFT		16
+#define ISPRSZ_VFILT1312_COEFF13_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1514_COEFF14_SHIFT		0
+#define ISPRSZ_VFILT1514_COEFF14_MASK		0x3FF
+#define ISPRSZ_VFILT1514_COEFF15_SHIFT		16
+#define ISPRSZ_VFILT1514_COEFF15_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1716_COEF16_SHIFT		0
+#define ISPRSZ_VFILT1716_COEF16_MASK		0x3FF
+#define ISPRSZ_VFILT1716_COEF17_SHIFT		16
+#define ISPRSZ_VFILT1716_COEF17_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT1918_COEF18_SHIFT		0
+#define ISPRSZ_VFILT1918_COEF18_MASK		0x3FF
+#define ISPRSZ_VFILT1918_COEF19_SHIFT		16
+#define ISPRSZ_VFILT1918_COEF19_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2120_COEF20_SHIFT		0
+#define ISPRSZ_VFILT2120_COEF20_MASK		0x3FF
+#define ISPRSZ_VFILT2120_COEF21_SHIFT		16
+#define ISPRSZ_VFILT2120_COEF21_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2322_COEF22_SHIFT		0
+#define ISPRSZ_VFILT2322_COEF22_MASK		0x3FF
+#define ISPRSZ_VFILT2322_COEF23_SHIFT		16
+#define ISPRSZ_VFILT2322_COEF23_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2524_COEF24_SHIFT		0
+#define ISPRSZ_VFILT2524_COEF24_MASK		0x3FF
+#define ISPRSZ_VFILT2524_COEF25_SHIFT		16
+#define ISPRSZ_VFILT2524_COEF25_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2726_COEF26_SHIFT		0
+#define ISPRSZ_VFILT2726_COEF26_MASK		0x3FF
+#define ISPRSZ_VFILT2726_COEF27_SHIFT		16
+#define ISPRSZ_VFILT2726_COEF27_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT2928_COEF28_SHIFT		0
+#define ISPRSZ_VFILT2928_COEF28_MASK		0x3FF
+#define ISPRSZ_VFILT2928_COEF29_SHIFT		16
+#define ISPRSZ_VFILT2928_COEF29_MASK		0x3FF0000
+
+#define ISPRSZ_VFILT3130_COEF30_SHIFT		0
+#define ISPRSZ_VFILT3130_COEF30_MASK		0x3FF
+#define ISPRSZ_VFILT3130_COEF31_SHIFT		16
+#define ISPRSZ_VFILT3130_COEF31_MASK		0x3FF0000
+
+#define ISPRSZ_YENH_CORE_SHIFT			0
+#define ISPRSZ_YENH_CORE_MASK			0xFF
+#define ISPRSZ_YENH_SLOP_SHIFT			8
+#define ISPRSZ_YENH_SLOP_MASK			0xF00
+#define ISPRSZ_YENH_GAIN_SHIFT			12
+#define ISPRSZ_YENH_GAIN_MASK			0xF000
+#define ISPRSZ_YENH_ALGO_SHIFT			16
+#define ISPRSZ_YENH_ALGO_MASK			0x30000
+
+#define ISPH3A_PCR_AEW_ALAW_EN_SHIFT		1
+#define ISPH3A_PCR_AF_MED_TH_SHIFT		3
+#define ISPH3A_PCR_AF_RGBPOS_SHIFT		11
+#define ISPH3A_PCR_AEW_AVE2LMT_SHIFT		22
+#define ISPH3A_PCR_AEW_AVE2LMT_MASK		0xFFC00000
+
+#define ISPH3A_AEWWIN1_WINHC_SHIFT		0
+#define ISPH3A_AEWWIN1_WINHC_MASK		0x3F
+#define ISPH3A_AEWWIN1_WINVC_SHIFT		6
+#define ISPH3A_AEWWIN1_WINVC_MASK		0x1FC0
+#define ISPH3A_AEWWIN1_WINW_SHIFT		13
+#define ISPH3A_AEWWIN1_WINW_MASK		0xFE000
+#define ISPH3A_AEWWIN1_WINH_SHIFT		24
+#define ISPH3A_AEWWIN1_WINH_MASK		0x7F000000
+
+#define ISPH3A_AEWINSTART_WINSH_SHIFT		0
+#define ISPH3A_AEWINSTART_WINSH_MASK		0x0FFF
+#define ISPH3A_AEWINSTART_WINSV_SHIFT		16
+#define ISPH3A_AEWINSTART_WINSV_MASK		0x0FFF0000
+
+#define ISPH3A_AEWINBLK_WINH_SHIFT		0
+#define ISPH3A_AEWINBLK_WINH_MASK		0x7F
+#define ISPH3A_AEWINBLK_WINSV_SHIFT		16
+#define ISPH3A_AEWINBLK_WINSV_MASK		0x0FFF0000
+
+#define ISPH3A_AEWSUBWIN_AEWINCH_SHIFT		0
+#define ISPH3A_AEWSUBWIN_AEWINCH_MASK		0x0F
+#define ISPH3A_AEWSUBWIN_AEWINCV_SHIFT		8
+#define ISPH3A_AEWSUBWIN_AEWINCV_MASK		0x0F00
+
+#define ISPHIST_PCR_ENABLE_SHIFT	0
+#define ISPHIST_PCR_ENABLE_MASK		0x01
+#define ISPHIST_PCR_BUSY_SHIFT		1
+#define ISPHIST_PCR_BUSY_MASK		0x02
+
+#define ISPHIST_CNT_DATASIZE_SHIFT	8
+#define ISPHIST_CNT_DATASIZE_MASK	0x0100
+#define ISPHIST_CNT_CLEAR_SHIFT		7
+#define ISPHIST_CNT_CLEAR_MASK		0x080
+#define ISPHIST_CNT_CFA_SHIFT		6
+#define ISPHIST_CNT_CFA_MASK		0x040
+#define ISPHIST_CNT_BINS_SHIFT		4
+#define ISPHIST_CNT_BINS_MASK		0x030
+#define ISPHIST_CNT_SOURCE_SHIFT	3
+#define ISPHIST_CNT_SOURCE_MASK		0x08
+#define ISPHIST_CNT_SHIFT_SHIFT		0
+#define ISPHIST_CNT_SHIFT_MASK		0x07
+
+#define ISPHIST_WB_GAIN_WG00_SHIFT	24
+#define ISPHIST_WB_GAIN_WG00_MASK	0xFF000000
+#define ISPHIST_WB_GAIN_WG01_SHIFT	16
+#define ISPHIST_WB_GAIN_WG01_MASK	0xFF0000
+#define ISPHIST_WB_GAIN_WG02_SHIFT	8
+#define ISPHIST_WB_GAIN_WG02_MASK	0xFF00
+#define ISPHIST_WB_GAIN_WG03_SHIFT	0
+#define ISPHIST_WB_GAIN_WG03_MASK	0xFF
+
+#define ISPHIST_REGHORIZ_HSTART_SHIFT		16	/*
+							* REGION 0 to 3 HORZ
+							* and VERT
+							*/
+#define ISPHIST_REGHORIZ_HSTART_MASK		0x3FFF0000
+#define ISPHIST_REGHORIZ_HEND_SHIFT		0
+#define ISPHIST_REGHORIZ_HEND_MASK		0x3FFF
+#define ISPHIST_REGVERT_VSTART_SHIFT		16
+#define ISPHIST_REGVERT_VSTART_MASK		0x3FFF0000
+#define ISPHIST_REGVERT_VEND_SHIFT		0
+#define ISPHIST_REGVERT_VEND_MASK		0x3FFF
+
+#define ISPHIST_REGHORIZ_MASK			0x3FFF3FFF
+#define ISPHIST_REGVERT_MASK			0x3FFF3FFF
+
+#define ISPHIST_ADDR_SHIFT			0
+#define ISPHIST_ADDR_MASK			0x3FF
+
+#define ISPHIST_DATA_SHIFT			0
+#define ISPHIST_DATA_MASK			0xFFFFF
+
+#define ISPHIST_RADD_SHIFT			0
+#define ISPHIST_RADD_MASK			0xFFFFFFFF
+
+#define ISPHIST_RADD_OFF_SHIFT			0
+#define ISPHIST_RADD_OFF_MASK			0xFFFF
+
+#define ISPHIST_HV_INFO_HSIZE_SHIFT		16
+#define ISPHIST_HV_INFO_HSIZE_MASK		0x3FFF0000
+#define ISPHIST_HV_INFO_VSIZE_SHIFT		0
+#define ISPHIST_HV_INFO_VSIZE_MASK		0x3FFF
+
+#define ISPHIST_HV_INFO_MASK			0x3FFF3FFF
+
+#define ISPCCDC_LSC_GAIN_MODE_N_MASK		0x700
+#define ISPCCDC_LSC_GAIN_MODE_N_SHIFT		8
+#define ISPCCDC_LSC_GAIN_MODE_M_MASK		0x3800
+#define ISPCCDC_LSC_GAIN_MODE_M_SHIFT		12
+#define ISPCCDC_LSC_GAIN_FORMAT_MASK		0xE
+#define ISPCCDC_LSC_GAIN_FORMAT_SHIFT		1
+#define ISPCCDC_LSC_AFTER_REFORMATTER_MASK	(1<<6)
+
+#define ISPCCDC_LSC_INITIAL_X_MASK		0x3F
+#define ISPCCDC_LSC_INITIAL_X_SHIFT		0
+#define ISPCCDC_LSC_INITIAL_Y_MASK		0x3F0000
+#define ISPCCDC_LSC_INITIAL_Y_SHIFT		16
+
+#define ISPMMU_REVISION_REV_MINOR_MASK		0xF
+#define ISPMMU_REVISION_REV_MAJOR_SHIFT		0x4
+
+#define IRQENABLE_MULTIHITFAULT			(1<<4)
+#define IRQENABLE_TWFAULT			(1<<3)
+#define IRQENABLE_EMUMISS			(1<<2)
+#define IRQENABLE_TRANSLNFAULT			(1<<1)
+#define IRQENABLE_TLBMISS			(1)
+
+#define ISPMMU_MMUCNTL_MMU_EN			(1<<1)
+#define ISPMMU_MMUCNTL_TWL_EN			(1<<2)
+#define ISPMMU_MMUCNTL_EMUTLBUPDATE		(1<<3)
+#define ISPMMU_AUTOIDLE				0x1
+#define ISPMMU_SIDLEMODE_FORCEIDLE		0
+#define ISPMMU_SIDLEMODE_NOIDLE			1
+#define ISPMMU_SIDLEMODE_SMARTIDLE		2
+#define ISPMMU_SIDLEMODE_SHIFT			3
+
+#define ISPCSI1_AUTOIDLE			0x1
+#define ISPCSI1_MIDLEMODE_SHIFT			12
+#define ISPCSI1_MIDLEMODE_FORCESTANDBY		0x0
+#define ISPCSI1_MIDLEMODE_NOSTANDBY		0x1
+#define ISPCSI1_MIDLEMODE_SMARTSTANDBY		0x2
+
+#endif	/* __ISPREG_H__ */
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/include/asm-arm/arch-omap/isp_user.h	2008-06-29 17:44:57.000000000 -0500
@@ -0,0 +1,151 @@
+/*
+ * include/asm-arm/arch-omap/isp_user.h
+ *
+ * Include file for OMAP ISP module in TI's OMAP3430.
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *	Mohit Jalori <mjalori@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_USER_H
+#define OMAP_ISP_USER_H
+
+/* ISP CCDC structs */
+
+/* Abstraction layer CCDC configurations */
+#define ISP_ABS_CCDC_ALAW		(1 << 0)
+#define ISP_ABS_CCDC_LPF 		(1 << 1)
+#define ISP_ABS_CCDC_BLCLAMP		(1 << 2)
+#define ISP_ABS_CCDC_BCOMP		(1 << 3)
+#define ISP_ABS_CCDC_FPC		(1 << 4)
+#define ISP_ABS_CCDC_CULL		(1 << 5)
+#define ISP_ABS_CCDC_COLPTN		(1 << 6)
+#define ISP_ABS_CCDC_CONFIG_LSC		(1 << 7)
+#define ISP_ABS_TBL_LSC			(1 << 8)
+
+#define RGB_MAX				3
+
+/* Enumeration constants for Alaw input width */
+enum alaw_ipwidth {
+	ALAW_BIT12_3 = 0x3,
+	ALAW_BIT11_2 = 0x4,
+	ALAW_BIT10_1 = 0x5,
+	ALAW_BIT9_0 = 0x6
+};
+
+/* Enumeration constants for Video Port */
+enum vpin {
+	BIT12_3 = 3,
+	BIT11_2 = 4,
+	BIT10_1 = 5,
+	BIT9_0 = 6
+};
+
+enum vpif_freq {
+	PIXCLKBY2,
+	PIXCLKBY3_5,
+	PIXCLKBY4_5,
+	PIXCLKBY5_5,
+	PIXCLKBY6_5
+};
+
+/**
+ * struct ispccdc_bclamp - Structure for Optical & Digital black clamp subtract
+ * @obgain: Optical black average gain.
+ * @obstpixel: Start Pixel w.r.t. HS pulse in Optical black sample.
+ * @oblines: Optical Black Sample lines.
+ * @oblen: Optical Black Sample Length.
+ * @dcsubval: Digital Black Clamp subtract value.
+ */
+struct ispccdc_bclamp {
+	u8 obgain;
+	u8 obstpixel;
+	u8 oblines;
+	u8 oblen;
+	u16 dcsubval;
+};
+
+/**
+ * ispccdc_fpc - Structure for FPC
+ * @fpnum: Number of faulty pixels to be corrected in the frame.
+ * @fpcaddr: Memory address of the FPC Table
+ */
+struct ispccdc_fpc {
+	u16 fpnum;
+	u32 fpcaddr;
+};
+
+/**
+ * ispccdc_blcomp - Structure for Black Level Compensation parameters.
+ * @b_mg: B/Mg pixels. 2's complement. -128 to +127.
+ * @gb_g: Gb/G pixels. 2's complement. -128 to +127.
+ * @gr_cy: Gr/Cy pixels. 2's complement. -128 to +127.
+ * @r_ye: R/Ye pixels. 2's complement. -128 to +127.
+ */
+struct ispccdc_blcomp {
+	u8 b_mg;
+	u8 gb_g;
+	u8 gr_cy;
+	u8 r_ye;
+};
+
+/**
+ * struct ispccdc_vp - Structure for Video Port parameters
+ * @bitshift_sel: Video port input select. 3 - bits 12-3, 4 - bits 11-2,
+ *                5 - bits 10-1, 6 - bits 9-0.
+ * @freq_sel: Video port data ready frequency. 1 - 1/3.5, 2 - 1/4.5,
+ *            3 - 1/5.5, 4 - 1/6.5.
+ */
+struct ispccdc_vp {
+	enum vpin bitshift_sel;
+	enum vpif_freq freq_sel;
+};
+
+/**
+ * ispccdc_culling - Structure for Culling parameters.
+ * @v_pattern: Vertical culling pattern.
+ * @h_odd: Horizontal Culling pattern for odd lines.
+ * @h_even: Horizontal Culling pattern for even lines.
+ */
+struct ispccdc_culling {
+	u8 v_pattern;
+	u16 h_odd;
+	u16 h_even;
+};
+
+/**
+ * ispccdc_update_config - Structure for CCDC configuration.
+ * @update: Specifies which CCDC registers should be updated.
+ * @flag: Specifies which CCDC functions should be enabled.
+ * @alawip: Enable/Disable A-Law compression.
+ * @bclamp: Black clamp control register.
+ * @blcomp: Black level compensation value for RGrGbB Pixels. 2's complement.
+ * @fpc: Number of faulty pixels corrected in the frame, address of FPC table.
+ * @cull: Cull control register.
+ * @colptn: Color pattern of the sensor.
+ * @lsc: Pointer to LSC gain table.
+ */
+struct ispccdc_update_config {
+	u16 update;
+	u16 flag;
+	enum alaw_ipwidth alawip;
+	struct ispccdc_bclamp *bclamp;
+	struct ispccdc_blcomp *blcomp;
+	struct ispccdc_fpc *fpc;
+	struct ispccdc_lsc_config *lsc_cfg;
+	struct ispccdc_culling *cull;
+	u32 colptn;
+	u8 *lsc;
+};
+
+#endif /* OMAP_ISP_USER_H */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
