Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TNhSW1028709
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:43:29 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TNhLR7005473
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:43:21 -0400
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7TNhGgY030155
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:43:21 -0500
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id m7TNhFGJ022560
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:43:15 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 29 Aug 2008 18:43:14 -0500
Message-ID: <A24693684029E5489D1D202277BE89441191E344@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/15] OMAP3 camera driver: Add main driver.
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

From: Sergio Aguirre <saaguirre@ti.com>

OMAP: CAM: Add main driver

This adds the main OMAP34xx camera driver to the kernel.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/Kconfig       |   10
 drivers/media/video/Makefile      |    2
 drivers/media/video/Kconfig       |   10
 drivers/media/video/Makefile      |    2
 drivers/media/video/omap34xxcam.c | 1852 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/omap34xxcam.h |  192 +++
 4 files changed, 2056 insertions(+)

Index: linux-omap-2.6/drivers/media/video/Kconfig
===================================================================
--- linux-omap-2.6.orig/drivers/media/video/Kconfig     2008-08-29 17:35:23.000000000 -0500
+++ linux-omap-2.6/drivers/media/video/Kconfig  2008-08-29 17:35:28.000000000 -0500
@@ -810,6 +810,16 @@
          CMOS camera controller.  This is the controller found on first-
          generation OLPC systems.

+config VIDEO_OMAP3
+        tristate "OMAP 3 Camera support"
+       select VIDEOBUF_GEN
+       select VIDEOBUF_DMA_SG
+       depends on VIDEO_V4L2 && ARCH_OMAP34XX
+       ---help---
+         Driver for an OMAP 3 camera controller.
+
+source "drivers/media/video/isp/Kconfig"
+
 config VIDEO_OMAP2
        tristate "OMAP 2 Camera support (EXPERIMENTAL)"
        select VIDEOBUF_GEN
Index: linux-omap-2.6/drivers/media/video/Makefile
===================================================================
--- linux-omap-2.6.orig/drivers/media/video/Makefile    2008-08-29 17:35:23.000000000 -0500
+++ linux-omap-2.6/drivers/media/video/Makefile 2008-08-29 17:35:28.000000000 -0500
@@ -107,6 +107,8 @@
 obj-$(CONFIG_VIDEO_OV7670)     += ov7670.o

 obj-$(CONFIG_VIDEO_OMAP2) += omap24xxcam.o omap24xxcam-dma.o
+obj-$(CONFIG_VIDEO_OMAP3) += omap34xxcam.o isp/
+
 obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 obj-$(CONFIG_VIDEO_OV9640)     += ov9640.o
 obj-$(CONFIG_VIDEO_MT9P012)    += mt9p012.o
Index: linux-omap-2.6/drivers/media/video/omap34xxcam.c
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/omap34xxcam.c    2008-08-29 17:35:43.000000000 -0500
@@ -0,0 +1,1852 @@
+/*
+ * drivers/media/video/omap34xxcam.c
+ *
+ * Video-for-Linux (Version 2) Camera capture driver for OMAP34xx ISP.
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ *     Sameer Venkatraman <sameerv@ti.com>
+ *     Mohit Jalori <mjalori@ti.com>
+ *     Sakari Ailus <sakari.ailus@nokia.com>
+ *     Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
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
+#include <linux/pci.h>         /* needed for videobufs */
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/videodev2.h>
+#include <linux/version.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+
+#include "omap34xxcam.h"
+#include "isp/isph3a.h"
+#include "isp/isp_af.h"
+
+#define OMAP34XXCAM_VERSION KERNEL_VERSION(0, 0, 0)
+
+/* global variables */
+static struct omap34xxcam_device *omap34xxcam;
+
+/* module parameters */
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
+                                      enum v4l2_power power)
+{
+       int rval = 0, i = OMAP34XXCAM_SLAVE_FLASH + 1;
+
+       if (power == V4L2_POWER_OFF)
+               goto out;
+
+       for (i = 0; i <= OMAP34XXCAM_SLAVE_FLASH; i++) {
+               if (!vdev->slave[i])
+                       continue;
+
+               rval = vidioc_int_s_power(vdev->slave[i], power);
+
+               if (rval) {
+                       power = V4L2_POWER_OFF;
+                       goto out;
+               }
+       }
+
+       return 0;
+
+out:
+       for (i--; i >= 0; i--) {
+               if (!vdev->slave[i])
+                       continue;
+
+               vidioc_int_s_power(vdev->slave[i], power);
+       }
+
+       return rval;
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
+       struct omap34xxcam_fh *fh = camfh_saved;
+       struct omap34xxcam_videodev *vdev = fh->vdev;
+       struct isph3a_aewb_xtrastats xtrastats;
+       int rval = 0;
+
+       do_gettimeofday(&vb->ts);
+       vb->field_count = atomic_add_return(2, &fh->field_count);
+       vb->state = VIDEOBUF_DONE;
+
+       xtrastats.ts = vb->ts;
+       xtrastats.field_count = vb->field_count;
+
+       if (vdev->streaming)
+               rval = 1;
+
+       wake_up(&vb->done);
+       isph3a_aewb_setxtrastats(&xtrastats);
+
+       return rval;
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
+                                unsigned int *size)
+{
+       struct omap34xxcam_fh *fh = vbq->priv_data;
+
+       if (*cnt <= 0)
+               *cnt = VIDEO_MAX_FRAME; /* supply a default number of buffers */
+
+       if (*cnt > VIDEO_MAX_FRAME)
+               *cnt = VIDEO_MAX_FRAME;
+
+       *size = fh->pix.sizeimage;
+
+       while (*size * *cnt > fh->vdev->vdev_sensor_config.capture_mem)
+               (*cnt)--;
+
+       return 0;
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
+                                   struct videobuf_buffer *vb)
+{
+       if (!vbq->streaming) {
+               isp_vbq_release(vbq, vb);
+               videobuf_dma_unmap(vbq, videobuf_to_dma(vb));
+               videobuf_dma_free(videobuf_to_dma(vb));
+               vb->state = VIDEOBUF_NEEDS_INIT;
+       }
+       return;
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
+                                  struct videobuf_buffer *vb,
+                                  enum v4l2_field field)
+{
+       struct omap34xxcam_fh *fh = vbq->priv_data;
+       int err = 0;
+
+       /*
+        * Accessing pix here is okay since it's constant while
+        * streaming is on (and we only get called then).
+        */
+       if (vb->baddr) {
+               /* This is a userspace buffer. */
+               if (fh->pix.sizeimage > vb->bsize)
+                       /* The buffer isn't big enough. */
+                       return -EINVAL;
+       } else {
+               if (vb->state != VIDEOBUF_NEEDS_INIT
+                   && fh->pix.sizeimage > vb->bsize)
+                       /*
+                        * We have a kernel bounce buffer that has
+                        * already been allocated.
+                        */
+                       omap34xxcam_vbq_release(vbq, vb);
+       }
+
+       vb->size = fh->pix.bytesperline * fh->pix.height;
+       vb->width = fh->pix.width;
+       vb->height = fh->pix.height;
+       vb->field = field;
+
+       if (vb->state == VIDEOBUF_NEEDS_INIT) {
+               err = videobuf_iolock(vbq, vb, NULL);
+               if (!err) {
+                       /* isp_addr will be stored locally inside isp code */
+                       err = isp_vbq_prepare(vbq, vb, field);
+               }
+       }
+
+       if (!err)
+               vb->state = VIDEOBUF_PREPARED;
+       else
+               omap34xxcam_vbq_release(vbq, vb);
+
+       return err;
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
+                                 struct videobuf_buffer *vb)
+{
+       struct omap34xxcam_fh *fh = vbq->priv_data;
+       struct omap34xxcam_videodev *vdev = fh->vdev;
+       enum videobuf_state state = vb->state;
+       isp_vbq_callback_ptr func_ptr;
+       int err = 0;
+
+       camfh_saved = fh;
+
+       func_ptr = omap34xxcam_update_vbq;
+       vb->state = VIDEOBUF_ACTIVE;
+
+       err = isp_sgdma_queue(videobuf_to_dma(vb),
+                               vb, 0, &vdev->cam->dma_notify, func_ptr);
+       if (err) {
+               dev_dbg(vdev->cam->dev, "vbq queue failed\n");
+               vb->state = state;
+       }
+
+}
+
+static struct videobuf_queue_ops omap34xxcam_vbq_ops = {
+       .buf_setup = omap34xxcam_vbq_setup,
+       .buf_prepare = omap34xxcam_vbq_prepare,
+       .buf_queue = omap34xxcam_vbq_queue,
+       .buf_release = omap34xxcam_vbq_release,
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
+                          struct v4l2_capability *cap)
+{
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+
+       strlcpy(cap->driver, CAM_NAME, sizeof(cap->driver));
+       strlcpy(cap->card, vdev->vfd->name, sizeof(cap->card));
+       cap->version = OMAP34XXCAM_VERSION;
+       cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+
+       return 0;
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
+                              struct v4l2_fmtdesc *f)
+{
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       int rval;
+
+       if (vdev->vdev_sensor_config.sensor_isp)
+               rval = vidioc_int_enum_fmt_cap(vdev->vdev_sensor, f);
+       else
+               rval = isp_enum_fmt_cap(f);
+
+       return rval;
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
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+
+       mutex_lock(&vdev->mutex);
+       f->fmt.pix = ofh->pix;
+       mutex_unlock(&vdev->mutex);
+
+       return 0;
+}
+
+static int try_pix_parm(struct omap34xxcam_videodev *vdev,
+                       struct v4l2_pix_format *best_pix_in,
+                       struct v4l2_pix_format *wanted_pix_out,
+                       struct v4l2_fract *best_ival)
+{
+       int fps;
+       int rval;
+       int size_index;
+       struct v4l2_pix_format best_pix_out;
+
+       if (best_ival->numerator == 0
+           || best_ival->denominator == 0)
+               best_ival->denominator = 30, best_ival->numerator = 1;
+
+       fps = best_ival->denominator / best_ival->numerator;
+
+       best_ival->denominator = 0;
+       best_pix_in->width = 0;
+       /* FIXME: this isn't good... */
+       best_pix_in->pixelformat = V4L2_PIX_FMT_SGRBG10;
+
+       best_pix_out.height = INT_MAX >> 1;
+       best_pix_out.width = best_pix_out.height;
+
+       /*
+        * Get supported resolutions.
+        */
+       for (size_index = 0; ; size_index++) {
+               struct v4l2_frmsizeenum frms;
+               struct v4l2_pix_format pix_tmp_in, pix_tmp_out;
+               int ival_index;
+
+               frms.index = size_index;
+               frms.pixel_format = best_pix_in->pixelformat;
+
+               rval = vidioc_int_enum_framesizes(vdev->vdev_sensor, &frms);
+               if (rval) {
+                       rval = 0;
+                       break;
+               }
+
+               pix_tmp_in.pixelformat = frms.pixel_format;
+               pix_tmp_in.width = frms.discrete.width;
+               pix_tmp_in.height = frms.discrete.height;
+               pix_tmp_out = *wanted_pix_out;
+               rval = isp_try_fmt_cap(&pix_tmp_in, &pix_tmp_out);
+               if (rval)
+                       return rval;
+
+#define IS_SMALLER_OR_EQUAL(pix1, pix2)                        \
+               ((pix1)->width + (pix1)->height         \
+                < (pix2)->width + (pix2)->height)
+#define SIZE_DIFF(pix1, pix2)                                  \
+               (abs((pix1)->width - (pix2)->width)             \
+                + abs((pix1)->height - (pix2)->height))
+
+               /*
+                * Don't use modes that are farther from wanted size
+                * that what we already got.
+                */
+               if (SIZE_DIFF(&pix_tmp_out, wanted_pix_out)
+                   > SIZE_DIFF(&best_pix_out, wanted_pix_out))
+                       continue;
+
+               /*
+                * There's an input mode that can provide output
+                * closer to wanted.
+                */
+               if (SIZE_DIFF(&pix_tmp_out, wanted_pix_out)
+                   < SIZE_DIFF(&best_pix_out, wanted_pix_out))
+                       /* Force renegotation of fps etc. */
+                       best_ival->denominator = 0;
+
+               for (ival_index = 0; ; ival_index++) {
+                       struct v4l2_frmivalenum frmi;
+
+                       frmi.index = ival_index;
+                       frmi.pixel_format = frms.pixel_format;
+                       frmi.width = frms.discrete.width;
+                       frmi.height = frms.discrete.height;
+                       /* FIXME: try to fix standard... */
+                       frmi.reserved[0] = 0xdeafbeef;
+
+                       rval = vidioc_int_enum_frameintervals(vdev->vdev_sensor,
+                                                             &frmi);
+                       if (rval) {
+                               rval = 0;
+                               break;
+                       }
+
+                       if (best_ival->denominator == 0)
+                               goto do_it_now;
+
+                       /*
+                        * We aim to use maximum resolution from the
+                        * sensor, provided that the fps is at least
+                        * as close as on the current mode.
+                        */
+#define FPS_ABS_DIFF(fps, ival) abs(fps - (ival).denominator / (ival).numerator)
+
+                       /* Select mode with closest fps. */
+                       if (FPS_ABS_DIFF(fps, frmi.discrete)
+                           < FPS_ABS_DIFF(fps, *best_ival))
+                               goto do_it_now;
+
+                       /*
+                        * Select bigger resolution if it's available
+                        * at same fps.
+                        */
+                       if (frmi.width > best_pix_in->width
+                           && FPS_ABS_DIFF(fps, frmi.discrete)
+                           <= FPS_ABS_DIFF(fps, *best_ival))
+                               goto do_it_now;
+
+                       continue;
+
+do_it_now:
+                       *best_ival = frmi.discrete;
+                       best_pix_out = pix_tmp_out;
+                       best_pix_in->width = frmi.width;
+                       best_pix_in->height = frmi.height;
+                       best_pix_in->pixelformat = frmi.pixel_format;
+               }
+       }
+
+       if (best_pix_in->width == 0)
+               return -EINVAL;
+
+       dev_info(vdev->cam->dev, "w %d, h %d -> w %d, h %d\n",
+                best_pix_in->width, best_pix_in->height,
+                best_pix_out.width, best_pix_out.height);
+
+       return isp_try_fmt_cap(best_pix_in, wanted_pix_out); }
+
+static int s_pix_parm(struct omap34xxcam_videodev *vdev,
+                     struct v4l2_pix_format *best_pix,
+                     struct v4l2_pix_format *pix,
+                     struct v4l2_fract *best_ival)
+{
+       struct v4l2_streamparm a;
+       struct v4l2_format fmt;
+       int rval;
+
+       rval = try_pix_parm(vdev, best_pix, pix, best_ival);
+       if (rval)
+               return rval;
+
+       rval = isp_s_fmt_cap(best_pix, pix);
+       if (rval)
+               return rval;
+
+       fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+       fmt.fmt.pix = *best_pix;
+       rval = vidioc_int_s_fmt_cap(vdev->vdev_sensor, &fmt);
+       if (rval)
+               return rval;
+
+       a.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+       a.parm.capture.timeperframe = *best_ival;
+       rval = vidioc_int_s_parm(vdev->vdev_sensor, &a);
+
+       return rval;
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
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       struct v4l2_pix_format pix_tmp;
+       struct v4l2_fract timeperframe;
+       int rval;
+
+       mutex_lock(&vdev->mutex);
+       if (vdev->streaming) {
+               rval = -EBUSY;
+               goto out;
+       }
+
+       vdev->want_pix = f->fmt.pix;
+
+       timeperframe = vdev->want_timeperframe;
+
+       rval = s_pix_parm(vdev, &pix_tmp, &f->fmt.pix, &timeperframe);
+       pix_tmp = f->fmt.pix;
+
+out:
+       mutex_unlock(&vdev->mutex);
+
+       if (!rval) {
+               mutex_lock(&ofh->vbq.vb_lock);
+               ofh->pix = pix_tmp;
+               mutex_unlock(&ofh->vbq.vb_lock);
+       }
+
+       return rval;
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
+                             struct v4l2_format *f)
+{
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       struct v4l2_pix_format pix_tmp;
+       struct v4l2_fract timeperframe;
+       int rval;
+
+       mutex_lock(&vdev->mutex);
+
+       timeperframe = vdev->want_timeperframe;
+
+       rval = try_pix_parm(vdev, &pix_tmp, &f->fmt.pix, &timeperframe);
+
+       mutex_unlock(&vdev->mutex);
+
+       return rval;
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
+                         struct v4l2_requestbuffers *b)
+{
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       int rval;
+
+       mutex_lock(&vdev->mutex);
+       if (vdev->streaming) {
+               mutex_unlock(&vdev->mutex);
+               return -EBUSY;
+       }
+
+       mutex_unlock(&vdev->mutex);
+
+       rval = videobuf_reqbufs(&ofh->vbq, b);
+
+       /*
+        * Either videobuf_reqbufs failed or the buffers are not
+        * memory-mapped (which would need special attention).
+        */
+       if (rval < 0 || b->memory != V4L2_MEMORY_MMAP)
+               goto out;
+
+out:
+       return rval;
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
+       struct omap34xxcam_fh *ofh = fh;
+
+       return videobuf_querybuf(&ofh->vbq, b);
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
+       struct omap34xxcam_fh *ofh = fh;
+
+       return videobuf_qbuf(&ofh->vbq, b);
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
+       struct omap34xxcam_fh *ofh = fh;
+
+       return videobuf_dqbuf(&ofh->vbq, b, file->f_flags & O_NONBLOCK);
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
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       struct omap34xxcam_device *cam = vdev->cam;
+       int rval;
+
+       mutex_lock(&vdev->mutex);
+       if (vdev->streaming) {
+               rval = -EBUSY;
+               goto out;
+       }
+
+       cam->dma_notify = 1;
+       isp_sgdma_init();
+       rval = videobuf_streamon(&ofh->vbq);
+       if (rval) {
+               dev_dbg(vdev->cam->dev, "omap34xxcam_slave_power_set failed\n");
+               goto out;
+       }
+
+
+       rval = omap34xxcam_slave_power_set(vdev, V4L2_POWER_RESUME);
+       if (!rval)
+               vdev->streaming = file;
+       else
+               videobuf_streamoff(&ofh->vbq);
+
+out:
+       mutex_unlock(&vdev->mutex);
+
+       return rval;
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
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       struct videobuf_queue *q = &ofh->vbq;
+       int rval;
+
+       mutex_lock(&vdev->mutex);
+
+       if (vdev->streaming == file)
+               isp_stop();
+
+       rval = videobuf_streamoff(q);
+       if (!rval)
+               vdev->streaming = NULL;
+
+       omap34xxcam_slave_power_set(vdev, V4L2_POWER_STANDBY);
+
+       mutex_unlock(&vdev->mutex);
+
+       return rval;
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
+                            struct v4l2_input *inp)
+{
+       if (inp->index > 0)
+               return -EINVAL;
+
+       strlcpy(inp->name, "camera", sizeof(inp->name));
+       inp->type = V4L2_INPUT_TYPE_CAMERA;
+
+       return 0;
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
+       *i = 0;
+
+       return 0;
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
+       if (i > 0)
+               return -EINVAL;
+
+       return 0;
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
+                           struct v4l2_queryctrl *a)
+{
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       int rval;
+
+       mutex_lock(&vdev->mutex);
+       if (vdev->vdev_sensor_config.sensor_isp) {
+               rval = vidioc_int_queryctrl(vdev->vdev_sensor, a);
+       } else {
+               rval = isp_queryctrl(a);
+               if (rval) {
+                       /* ISP does not support, check sensor */
+                       rval = vidioc_int_queryctrl(vdev->vdev_sensor, a);
+               }
+       }
+       mutex_unlock(&vdev->mutex);
+
+       return rval;
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
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       int rval;
+
+       mutex_lock(&vdev->mutex);
+       if (vdev->vdev_sensor_config.sensor_isp) {
+               rval = vidioc_int_g_ctrl(vdev->vdev_sensor, a);
+       } else {
+               rval = isp_g_ctrl(a);
+               /* If control not supported on ISP, try sensor */
+               if (rval)
+                       rval = vidioc_int_g_ctrl(vdev->vdev_sensor, a);
+               /* If control not supported on sensor, try lens */
+               if (vdev->vdev_lens && rval)
+                       rval = vidioc_int_g_ctrl(vdev->vdev_lens, a);
+       }
+       mutex_unlock(&vdev->mutex);
+
+       return rval;
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
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       int rval;
+
+       mutex_lock(&vdev->mutex);
+       if (vdev->vdev_sensor_config.sensor_isp) {
+               rval = vidioc_int_s_ctrl(vdev->vdev_sensor, a);
+       } else {
+               rval = isp_s_ctrl(a);
+               /* If control not supported on ISP, try sensor */
+               if (rval)
+                       rval = vidioc_int_s_ctrl(vdev->vdev_sensor, a);
+               /* If control not supported on sensor, try lens */
+               if (vdev->vdev_lens && rval)
+                       rval = vidioc_int_s_ctrl(vdev->vdev_lens, a);
+       }
+       mutex_unlock(&vdev->mutex);
+
+       return rval;
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
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       int rval;
+
+       if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+               return -EINVAL;
+
+       mutex_lock(&vdev->mutex);
+       rval = vidioc_int_g_parm(vdev->vdev_sensor, a);
+       mutex_unlock(&vdev->mutex);
+
+       return rval;
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
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       struct v4l2_pix_format pix_tmp_sensor, pix_tmp;
+       int rval;
+
+       if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+               return -EINVAL;
+
+       mutex_lock(&vdev->mutex);
+       if (vdev->streaming) {
+               rval = -EBUSY;
+               goto out;
+       }
+
+       vdev->want_timeperframe = a->parm.capture.timeperframe;
+
+       pix_tmp = vdev->want_pix;
+
+       rval = s_pix_parm(vdev, &pix_tmp_sensor, &pix_tmp,
+                         &a->parm.capture.timeperframe);
+
+out:
+       mutex_unlock(&vdev->mutex);
+
+       return rval;
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
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       struct v4l2_cropcap *cropcap = a;
+       int rval;
+
+       mutex_lock(&vdev->mutex);
+
+       if (vdev->vdev_sensor_config.sensor_isp) {
+               rval = vidioc_int_cropcap(vdev->vdev_sensor, a);
+       } else {
+               cropcap->bounds.top = 0;
+               cropcap->bounds.left = 0;
+               cropcap->bounds.width = ofh->pix.width;
+               cropcap->bounds.height = ofh->pix.height;
+               cropcap->defrect = cropcap->bounds;
+               cropcap->pixelaspect.numerator = 1;
+               cropcap->pixelaspect.denominator = 1;
+               rval = 0;
+       }
+
+       mutex_unlock(&vdev->mutex);
+
+       return rval;
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
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       int rval = 0;
+
+       mutex_lock(&vdev->mutex);
+
+       if (vdev->vdev_sensor_config.sensor_isp)
+               rval = vidioc_int_g_crop(vdev->vdev_sensor, a);
+       else
+               rval = isp_g_crop(a);
+
+       mutex_unlock(&vdev->mutex);
+
+       return rval;
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
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       struct v4l2_pix_format *pix = &ofh->pix;
+       int rval = 0;
+
+       mutex_lock(&vdev->mutex);
+
+       if (vdev->vdev_sensor_config.sensor_isp)
+               rval = vidioc_int_s_crop(vdev->vdev_sensor, a);
+       else
+               rval = isp_s_crop(a, pix);
+
+       mutex_unlock(&vdev->mutex);
+
+       return rval;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *fh,
+                                 struct v4l2_frmsizeenum *frms)
+{
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       u32 pixel_format;
+       int rval;
+
+       pixel_format = frms->pixel_format;
+       frms->pixel_format = V4L2_PIX_FMT_SGRBG10; /* We can accept any. */
+
+       mutex_lock(&vdev->mutex);
+       rval = vidioc_int_enum_framesizes(vdev->vdev_sensor, frms);
+       mutex_unlock(&vdev->mutex);
+
+       frms->pixel_format = pixel_format;
+
+       return rval;
+}
+
+static int vidioc_enum_frameintervals(struct file *file, void *fh,
+                                     struct v4l2_frmivalenum *frmi) {
+       struct omap34xxcam_fh *ofh = fh;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       u32 pixel_format;
+       int rval;
+
+       pixel_format = frmi->pixel_format;
+       frmi->pixel_format = V4L2_PIX_FMT_SGRBG10; /* We can accept any. */
+
+       mutex_lock(&vdev->mutex);
+       rval = vidioc_int_enum_frameintervals(vdev->vdev_sensor, frmi);
+       mutex_unlock(&vdev->mutex);
+
+       frmi->pixel_format = pixel_format;
+
+       return rval;
+}
+
+/**
+ * vidioc_default - private IOCTL handler
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
+static int vidioc_default(struct file *file, void *fh, int cmd, void *arg)
+{
+       struct omap34xxcam_fh *ofh = file->private_data;
+       struct omap34xxcam_videodev *vdev = ofh->vdev;
+       int rval;
+
+       if (vdev->vdev_sensor_config.sensor_isp) {
+               rval = -EINVAL;
+       } else {
+               switch (cmd) {
+               case VIDIOC_ENUM_FRAMESIZES:
+                       rval = vidioc_enum_framesizes(file, fh, arg);
+                       goto out;
+               case VIDIOC_ENUM_FRAMEINTERVALS:
+                       rval = vidioc_enum_frameintervals(file, fh, arg);
+                       goto out;
+               case VIDIOC_PRIVATE_ISP_AEWB_REQ:
+               {
+                       /* Need to update sensor first */
+                       struct isph3a_aewb_data *data;
+                       struct v4l2_control vc;
+
+                       data = (struct isph3a_aewb_data *) arg;
+                       if (data->update & SET_EXPOSURE) {
+                               vc.id = V4L2_CID_EXPOSURE;
+                               vc.value = data->shutter;
+                               mutex_lock(&vdev->mutex);
+                               rval = vidioc_int_s_ctrl(vdev->vdev_sensor,
+                                                        &vc);
+                               mutex_unlock(&vdev->mutex);
+                               if (rval)
+                                       goto out;
+                       }
+                       if (data->update & SET_ANALOG_GAIN) {
+                               vc.id = V4L2_CID_GAIN;
+                               vc.value = data->gain;
+                               mutex_lock(&vdev->mutex);
+                               rval = vidioc_int_s_ctrl(vdev->vdev_sensor,
+                                                        &vc);
+                               mutex_unlock(&vdev->mutex);
+                               if (rval)
+                                       goto out;
+                       }
+               }
+               break;
+               case VIDIOC_PRIVATE_ISP_AF_CFG: {
+                       /* Need to update lens first */
+                       struct isp_af_data *data;
+                       struct v4l2_control vc;
+
+                       if (!vdev->vdev_lens) {
+                               rval = -EINVAL;
+                               goto out;
+                       }
+                       data = (struct isp_af_data *) arg;
+                       if (data->update & LENS_DESIRED_POSITION) {
+                               vc.id = V4L2_CID_FOCUS_ABSOLUTE;
+                               vc.value = data->desired_lens_direction;
+                               mutex_lock(&vdev->mutex);
+                               rval = vidioc_int_s_ctrl(vdev->vdev_lens, &vc);
+                               mutex_unlock(&vdev->mutex);
+                               if (rval)
+                                       goto out;
+                       }
+                       if (data->update & REQUEST_STATISTICS) {
+                               vc.id = V4L2_CID_FOCUS_ABSOLUTE;
+                               mutex_lock(&vdev->mutex);
+                               rval = vidioc_int_g_ctrl(vdev->vdev_lens, &vc);
+                               mutex_unlock(&vdev->mutex);
+                               if (rval)
+                                       goto out;
+                               data->xtrastats.lens_position = vc.value;
+                       }
+               }
+               break;
+               case VIDIOC_G_PRIV_MEM:
+                       rval = vidioc_int_g_priv_mem(vdev->vdev_sensor,
+                                               (struct v4l2_priv_mem *)arg);
+                       goto out;
+               }
+
+               rval = isp_handle_private(cmd, arg);
+       }
+out:
+       mutex_unlock(&vdev->mutex);
+       return rval;
+}
+
+/*
+ *
+ * File operations.
+ *
+ */
+
+static long omap34xxcam_unlocked_ioctl(struct file *file, unsigned int cmd,
+                                      unsigned long arg)
+{
+       return (long)video_ioctl2(file->f_dentry->d_inode, file, cmd, arg);
+}
+
+/**
+ * omap34xxcam_poll - file operations poll handler
+ * @file: ptr. to system file structure
+ * @wait: system poll table structure
+ *
+ */
+static unsigned int omap34xxcam_poll(struct file *file,
+                                    struct poll_table_struct *wait)
+{
+       struct omap34xxcam_fh *fh = file->private_data;
+       struct omap34xxcam_videodev *vdev = fh->vdev;
+       struct videobuf_buffer *vb;
+
+       mutex_lock(&vdev->mutex);
+       if (vdev->streaming != file) {
+               mutex_unlock(&vdev->mutex);
+               return POLLERR;
+       }
+       mutex_unlock(&vdev->mutex);
+
+       mutex_lock(&fh->vbq.vb_lock);
+       if (list_empty(&fh->vbq.stream)) {
+               mutex_unlock(&fh->vbq.vb_lock);
+               return POLLERR;
+       }
+       vb = list_entry(fh->vbq.stream.next, struct videobuf_buffer, stream);
+       mutex_unlock(&fh->vbq.vb_lock);
+
+       poll_wait(file, &vb->done, wait);
+
+       if (vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)
+               return POLLIN | POLLRDNORM;
+
+       return 0;
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
+       struct omap34xxcam_fh *fh = file->private_data;
+
+       return videobuf_mmap_mapper(&fh->vbq, vma);
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
+       struct omap34xxcam_videodev *vdev = NULL;
+       struct omap34xxcam_device *cam = omap34xxcam;
+       struct omap34xxcam_fh *fh;
+       struct v4l2_format format;
+       int i;
+
+       for (i = 0; i < OMAP34XXCAM_VIDEODEVS; i++) {
+               if (cam->vdevs[i].vfd
+                   && cam->vdevs[i].vfd->minor == iminor(inode)) {
+                       vdev = &cam->vdevs[i];
+                       break;
+               }
+       }
+
+       if (!vdev || !vdev->vfd)
+               return -ENODEV;
+
+       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+       if (fh == NULL)
+               return -ENOMEM;
+
+       mutex_lock(&vdev->mutex);
+       for (i = 0; i <= OMAP34XXCAM_SLAVE_FLASH; i++) {
+               if (vdev->slave[i]
+                   && !try_module_get(vdev->slave[i]->module)) {
+                       mutex_unlock(&vdev->mutex);
+                       goto out_try_module_get;
+               }
+       }
+
+       if (atomic_inc_return(&vdev->users) == 1) {
+               isp_get();
+               isp_open();
+               if (omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON))
+                       goto out_slave_power_set_standby;
+               if (omap34xxcam_slave_power_set(vdev, V4L2_POWER_STANDBY))
+                       goto out_slave_power_set_standby;
+       }
+
+       fh->vdev = vdev;
+
+       /* FIXME: Check that we have sensor now... */
+       if (vdev->vdev_sensor_config.sensor_isp)
+               vidioc_int_g_fmt_cap(vdev->vdev_sensor, &format);
+       else
+               isp_g_fmt_cap(&format.fmt.pix);
+
+       mutex_unlock(&vdev->mutex);
+       /* FIXME: how about fh->pix when there are more users? */
+       fh->pix = format.fmt.pix;
+
+       file->private_data = fh;
+
+       spin_lock_init(&fh->vbq_lock);
+
+       videobuf_queue_sg_init(&fh->vbq, &omap34xxcam_vbq_ops, NULL,
+                               &fh->vbq_lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
+                               V4L2_FIELD_NONE,
+                               sizeof(struct videobuf_buffer), fh);
+
+       return 0;
+
+out_slave_power_set_standby:
+       omap34xxcam_slave_power_set(vdev, V4L2_POWER_OFF);
+       isp_close();
+       isp_put();
+       atomic_dec(&vdev->users);
+       mutex_unlock(&vdev->mutex);
+
+out_try_module_get:
+       for (i--; i >= 0; i--)
+               if (vdev->slave[i])
+                       module_put(vdev->slave[i]->module);
+
+       kfree(fh);
+
+       return -ENODEV;
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
+       struct omap34xxcam_fh *fh = file->private_data;
+       struct omap34xxcam_videodev *vdev = fh->vdev;
+       int i;
+
+       mutex_lock(&vdev->mutex);
+       if (vdev->streaming == file) {
+               isp_stop();
+               videobuf_streamoff(&fh->vbq);
+               omap34xxcam_slave_power_set(vdev, V4L2_POWER_STANDBY);
+               vdev->streaming = NULL;
+       }
+
+       if (atomic_dec_return(&vdev->users) == 0) {
+               omap34xxcam_slave_power_set(vdev, V4L2_POWER_OFF);
+               isp_close();
+               isp_put();
+       }
+       mutex_unlock(&vdev->mutex);
+
+       file->private_data = NULL;
+
+       for (i = 0; i <= OMAP34XXCAM_SLAVE_FLASH; i++)
+               if (vdev->slave[i])
+                       module_put(vdev->slave[i]->module);
+
+       kfree(fh);
+
+       return 0;
+}
+
+static struct file_operations omap34xxcam_fops = {
+       .owner = THIS_MODULE,
+       .llseek = no_llseek,
+       .unlocked_ioctl = omap34xxcam_unlocked_ioctl,
+       .poll = omap34xxcam_poll,
+       .mmap = omap34xxcam_mmap,
+       .open = omap34xxcam_open,
+       .release = omap34xxcam_release,
+};
+
+static const struct v4l2_ioctl_ops omap34xxcam_ioctl_ops = {
+       .vidioc_querycap         = vidioc_querycap,
+       .vidioc_enum_fmt_vid_cap         = vidioc_enum_fmt_cap,
+       .vidioc_g_fmt_vid_cap    = vidioc_g_fmt_cap,
+       .vidioc_s_fmt_vid_cap    = vidioc_s_fmt_cap,
+       .vidioc_try_fmt_vid_cap  = vidioc_try_fmt_cap,
+       .vidioc_reqbufs          = vidioc_reqbufs,
+       .vidioc_querybuf         = vidioc_querybuf,
+       .vidioc_qbuf             = vidioc_qbuf,
+       .vidioc_dqbuf            = vidioc_dqbuf,
+       .vidioc_streamon         = vidioc_streamon,
+       .vidioc_streamoff        = vidioc_streamoff,
+       .vidioc_enum_input       = vidioc_enum_input,
+       .vidioc_g_input          = vidioc_g_input,
+       .vidioc_s_input          = vidioc_s_input,
+       .vidioc_queryctrl        = vidioc_queryctrl,
+       .vidioc_g_ctrl           = vidioc_g_ctrl,
+       .vidioc_s_ctrl           = vidioc_s_ctrl,
+       .vidioc_g_parm           = vidioc_g_parm,
+       .vidioc_s_parm           = vidioc_s_parm,
+       .vidioc_cropcap          = vidioc_cropcap,
+       .vidioc_g_crop           = vidioc_g_crop,
+       .vidioc_s_crop           = vidioc_s_crop,
+       .vidioc_default          = vidioc_default,
+};
+/**
+ * omap34xxcam_device_unregister - V4L2 detach handler
+ * @s: ptr. to standard V4L2 device information structure
+ *
+ * Detach sensor and unregister and release the video device.
+ */
+static void omap34xxcam_device_unregister(struct v4l2_int_device *s)
+{
+       struct omap34xxcam_videodev *vdev = s->u.slave->master->priv;
+       struct omap34xxcam_hw_config hwc;
+
+       BUG_ON(vidioc_int_g_priv(s, &hwc) < 0);
+
+       if (vdev->slave[hwc.dev_type]) {
+               vdev->slave[hwc.dev_type] = NULL;
+               vdev->slaves--;
+       }
+
+       if (vdev->slaves == 0 && vdev->vfd) {
+               if (vdev->vfd->minor == -1) {
+                       /*
+                        * The device was never registered, so release the
+                        * video_device struct directly.
+                        */
+                       video_device_release(vdev->vfd);
+               } else {
+                       /*
+                        * The unregister function will release the
+                        * video_device struct as well as
+                        * unregistering it.
+                        */
+                       video_unregister_device(vdev->vfd);
+               }
+               vdev->vfd = NULL;
+       }
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
+       struct omap34xxcam_videodev *vdev = s->u.slave->master->priv;
+       struct omap34xxcam_device *cam = vdev->cam;
+       struct omap34xxcam_hw_config hwc;
+       struct video_device *vfd;
+       int rval, i;
+
+       /* We need to check rval just once. The place is here. */
+       if (vidioc_int_g_priv(s, &hwc))
+               return -ENODEV;
+
+       if (vdev->index != hwc.dev_index)
+               return -ENODEV;
+
+       if (hwc.dev_type < 0 || hwc.dev_type > OMAP34XXCAM_SLAVE_FLASH)
+               return -EINVAL;
+
+       if (vdev->slave[hwc.dev_type])
+               return -EBUSY;
+
+       mutex_lock(&vdev->mutex);
+       if (atomic_read(&vdev->users)) {
+               dev_err(cam->dev, "we're open (%d), can't register\n",
+                       atomic_read(&vdev->users));
+               mutex_unlock(&vdev->mutex);
+               return -EBUSY;
+       }
+
+       /* Are we the first slave? */
+       if (vdev->slaves == 0) {
+
+               /* initialize the video_device struct */
+               vdev->vfd = video_device_alloc();
+               vfd = vdev->vfd;
+               if (!vfd) {
+                       dev_err(cam->dev,
+                               "could not allocate video device struct\n");
+                       return -ENOMEM;
+               }
+               vfd->release = video_device_release;
+
+               vfd->parent = cam->dev;
+
+               vfd->fops                = &omap34xxcam_fops;
+               vfd->priv                = vdev;
+
+               vfd->ioctl_ops           = &omap34xxcam_ioctl_ops;
+
+               if (video_register_device(vfd, VFL_TYPE_GRABBER,
+                                         hwc.dev_minor) < 0) {
+                       dev_err(cam->dev,
+                               "could not register V4L device\n");
+                       vfd->minor = -1;
+                       rval = -EBUSY;
+                       goto err;
+               }
+       } else {
+               vfd = vdev->vfd;
+       }
+
+       vdev->slaves++;
+       vdev->slave[hwc.dev_type] = s;
+       vdev->slave_config[hwc.dev_type] = hwc;
+
+       isp_get();
+       isp_open();
+       rval = omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON);
+       if (!rval && hwc.dev_type == OMAP34XXCAM_SLAVE_SENSOR) {
+               struct v4l2_format format;
+               struct v4l2_streamparm a;
+
+               format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+               rval |= vidioc_int_g_fmt_cap(vdev->vdev_sensor, &format);
+
+               a.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+               rval |= vidioc_int_g_parm(vdev->vdev_sensor, &a);
+               if (rval)
+                       rval = -EBUSY;
+
+               vdev->want_pix = format.fmt.pix;
+               vdev->want_timeperframe = a.parm.capture.timeperframe;
+       }
+       omap34xxcam_slave_power_set(vdev, V4L2_POWER_OFF);
+       isp_close();
+       isp_put();
+
+       if (rval)
+               goto err;
+       strlcpy(vfd->name, CAM_NAME, sizeof(vfd->name));
+       for (i = 0; i <= OMAP34XXCAM_SLAVE_FLASH; i++) {
+               strlcat(vfd->name, "/", sizeof(vfd->name));
+               if (!vdev->slave[i])
+                       continue;
+               strlcat(vfd->name, vdev->slave[i]->name, sizeof(vfd->name));
+       }
+
+       mutex_unlock(&vdev->mutex);
+
+       dev_info(cam->dev, "video%d is now %s\n", vfd->minor, vfd->name);
+       return 0;
+
+err:
+       if (s == vdev->slave[hwc.dev_type]) {
+               vdev->slave[hwc.dev_type] = NULL;
+               vdev->slaves--;
+       }
+
+       mutex_unlock(&vdev->mutex);
+       omap34xxcam_device_unregister(s);
+
+       return rval;
+}
+
+static struct v4l2_int_master omap34xxcam_master = {
+       .attach = omap34xxcam_device_register,
+       .detach = omap34xxcam_device_unregister,
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
+       struct omap34xxcam_videodev *vdev = platform_get_drvdata(pdev);
+
+       if (atomic_read(&vdev->users) == 0)
+               return 0;
+
+       if (vdev->streaming) {
+               isp_stop();
+               omap34xxcam_slave_power_set(vdev, V4L2_POWER_OFF);
+       }
+
+       return 0;
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
+       struct omap34xxcam_videodev *vdev = platform_get_drvdata(pdev);
+
+       if (atomic_read(&vdev->users) == 0)
+               return 0;
+
+       if (vdev->streaming) {
+               omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON);
+               isp_start();
+       }
+
+       return 0;
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
+       struct omap34xxcam_device *cam;
+       struct resource *mem;
+       struct isp_sysc isp_sysconfig;
+       int irq;
+       int i;
+
+       cam = kzalloc(sizeof(*cam), GFP_KERNEL);
+       if (!cam) {
+               dev_err(&pdev->dev, "could not allocate memory\n");
+               goto err;
+       }
+
+       platform_set_drvdata(pdev, cam);
+
+       cam->dev = &pdev->dev;
+
+       /* request the mem region for the camera registers */
+       mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+       if (!mem) {
+               dev_err(cam->dev, "no mem resource?\n");
+               goto err;
+       }
+
+       if (!request_mem_region(mem->start, (mem->end - mem->start) + 1,
+                               pdev->name)) {
+               dev_err(cam->dev,
+                       "cannot reserve camera register I/O region\n");
+               goto err;
+
+       }
+       cam->mmio_base_phys = mem->start;
+       cam->mmio_size = (mem->end - mem->start) + 1;
+
+       /* map the region */
+       cam->mmio_base = (unsigned long)
+                       ioremap_nocache(cam->mmio_base_phys, cam->mmio_size);
+       if (!cam->mmio_base) {
+               dev_err(cam->dev, "cannot map camera register I/O region\n");
+               goto err;
+       }
+
+       irq = platform_get_irq(pdev, 0);
+       if (irq <= 0) {
+               dev_err(cam->dev, "no irq for camera?\n");
+               goto err;
+       }
+
+       isp_get();
+       isp_sysconfig.reset = 0;
+       isp_sysconfig.idle_mode = 1;
+       isp_power_settings(isp_sysconfig);
+       isp_put();
+
+       for (i = 0; i < OMAP34XXCAM_VIDEODEVS; i++) {
+               struct omap34xxcam_videodev *vdev = &cam->vdevs[i];
+               struct v4l2_int_device *m = &vdev->master;
+
+               m->module       = THIS_MODULE;
+               strlcpy(m->name, CAM_NAME, sizeof(m->name));
+               m->type         = v4l2_int_type_master;
+               m->u.master     = &omap34xxcam_master;
+               m->priv         = vdev;
+
+               mutex_init(&vdev->mutex);
+               vdev->index             = i;
+               vdev->cam               = cam;
+
+               if (v4l2_int_device_register(m))
+                       goto err;
+       }
+
+       omap34xxcam = cam;
+
+       return 0;
+
+err:
+       omap34xxcam_remove(pdev);
+       return -ENODEV;
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
+       struct omap34xxcam_device *cam = platform_get_drvdata(pdev);
+       int i;
+
+       if (!cam)
+               return 0;
+
+       omap34xxcam = NULL;
+
+       for (i = 0; i < OMAP34XXCAM_VIDEODEVS; i++) {
+               if (cam->vdevs[i].cam == NULL)
+                       continue;
+
+               v4l2_int_device_unregister(&cam->vdevs[i].master);
+               cam->vdevs[i].cam = NULL;
+       }
+
+       if (cam->mmio_base) {
+               iounmap((void *)cam->mmio_base);
+               cam->mmio_base = 0;
+       }
+
+       if (cam->mmio_base_phys) {
+               release_mem_region(cam->mmio_base_phys, cam->mmio_size);
+               cam->mmio_base_phys = 0;
+       }
+
+       kfree(cam);
+
+       return 0;
+}
+
+static struct platform_driver omap34xxcam_driver = {
+       .probe = omap34xxcam_probe,
+       .remove = omap34xxcam_remove,
+#ifdef CONFIG_PM
+       .suspend = omap34xxcam_suspend,
+       .resume = omap34xxcam_resume,
+#endif
+       .driver = {
+                  .name = CAM_NAME,
+                  },
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
+       return platform_driver_register(&omap34xxcam_driver);
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
+       platform_driver_unregister(&omap34xxcam_driver);
+}
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("OMAP34xx Video for Linux camera driver");
+MODULE_LICENSE("GPL");
+
+late_initcall(omap34xxcam_init);
+module_exit(omap34xxcam_cleanup);
Index: linux-omap-2.6/drivers/media/video/omap34xxcam.h
===================================================================
--- /dev/null   1970-01-01 00:00:00.000000000 +0000
+++ linux-omap-2.6/drivers/media/video/omap34xxcam.h    2008-08-29 17:35:28.000000000 -0500
@@ -0,0 +1,192 @@
+/*
+ * drivers/media/video/omap34xxcam.h
+ *
+ * Video-for-Linux (Version 2) Camera capture driver for OMAP34xx ISP.
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ * Copyright (C) 2008 Nokia.
+ *
+ * Contributors:
+ *     Sameer Venkatraman <sameerv@ti.com>
+ *     Mohit Jalori <mjalori@ti.com>
+ *     Sakari Ailus <sakari.ailus@nokia.com>
+ *     Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
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
+#define OMAP_ISP_AF            (1 << 4)
+#define OMAP_ISP_HIST          (1 << 5)
+#define OMAP34XXCAM_XCLK_NONE  -1
+#define OMAP34XXCAM_XCLK_A     0
+#define OMAP34XXCAM_XCLK_B     1
+
+#define OMAP34XXCAM_SLAVE_SENSOR       0
+#define OMAP34XXCAM_SLAVE_LENS         1
+#define OMAP34XXCAM_SLAVE_FLASH                2 /* This is the last slave! */
+
+#define OMAP34XXCAM_VIDEODEVS          4
+
+struct omap34xxcam_device;
+struct omap34xxcam_videodev;
+
+struct omap34xxcam_sensor_config {
+       int xclk;
+       int sensor_isp;
+       u32 capture_mem;
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
+       int dev_index; /* Index in omap34xxcam_sensors */
+       int dev_minor; /* Video device minor number */
+       int dev_type; /* OMAP34XXCAM_SLAVE_* */
+       union {
+               struct omap34xxcam_sensor_config sensor;
+               struct omap34xxcam_lens_config lens;
+               struct omap34xxcam_flash_config flash;
+       } u;
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
+       struct mutex mutex; /* For serializing access to this structure */
+
+       struct omap34xxcam_device *cam;
+       struct v4l2_int_device master;
+
+#define vdev_sensor slave[OMAP34XXCAM_SLAVE_SENSOR]
+#define vdev_lens slave[OMAP34XXCAM_SLAVE_LENS]
+#define vdev_flash slave[OMAP34XXCAM_SLAVE_FLASH]
+       struct v4l2_int_device *slave[OMAP34XXCAM_SLAVE_FLASH + 1];
+
+       /* number of slaves attached */
+       int slaves;
+
+       /*** video device parameters ***/
+       struct video_device *vfd;
+       int capture_mem;
+
+       /*** general driver state information ***/
+       /*
+        * Sensor interface parameters: interface type, CC_CTRL
+        * register value and interface specific data.
+        */
+       u32 xclk;
+       /* index to omap34xxcam_videodevs of this structure */
+       int index;
+       atomic_t users;
+
+#define vdev_sensor_config slave_config[OMAP34XXCAM_SLAVE_SENSOR].u.sensor
+#define vdev_lens_config slave_config[OMAP34XXCAM_SLAVE_LENS].u.lens
+#define vdev_flash_config slave_config[OMAP34XXCAM_SLAVE_FLASH].u.flash
+       struct omap34xxcam_hw_config slave_config[OMAP34XXCAM_SLAVE_FLASH + 1];
+
+       /*** capture data ***/
+       struct v4l2_fract want_timeperframe;
+       struct v4l2_pix_format want_pix;
+       /* file handle, if streaming is on */
+       struct file *streaming;
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
+       struct mutex mutex; /* For serializing access to this structure */
+       int sgdma_in_queue;
+       struct isp_sgdma sgdma;
+       int dma_notify;
+
+       /*** platform HW resource ***/
+       unsigned int irq;
+       unsigned long mmio_base;
+       unsigned long mmio_base_phys;
+       unsigned long mmio_size;
+
+       /*** interfaces and device ***/
+       struct device *dev;
+       struct omap34xxcam_videodev vdevs[OMAP34XXCAM_VIDEODEVS];
+
+       /*** camera module clocks ***/
+       struct clk *fck;
+       struct clk *ick;
+       bool sensor_if_enabled;
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
+       spinlock_t vbq_lock; /* For the videobuf queue */
+       struct videobuf_queue vbq;
+       struct v4l2_pix_format pix;
+       atomic_t field_count;
+       /* accessing cam here doesn't need serialisation: it's constant */
+       struct omap34xxcam_videodev *vdev;
+};
+
+#endif /* ifndef OMAP34XXCAM_H */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
