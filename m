Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:43436 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbcBNRDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2016 12:03:09 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [RFC/PATCH] [media] rcar-vin: add Renesas R-Car VIN IP core
Date: Sun, 14 Feb 2016 17:55:32 +0100
Message-Id: <1455468932-8573-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A V4L2 driver for Renesas R-Car VIN IP cores that do not depend on
soc_camera. The driver is heavily based on its predecessor and aims to
replace the soc_camera driver.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---

The driver is tested on Koelsch and can grab frames using yavta.  It
also passes a v4l2-compliance (1.10.0) run without failures. There is
however a issues sometimes if one first run v4l2-compliance and then
yavta the grabbed frames are a bit fuzzy. I'm working on it. Also I
could only get frames if the video signal on the composite IN was NTSC,
but this also applied to the soc_camera driver, it might be my test
setup.

As stated in commit message the driver is based on its soc_camera
version but some features have been drooped (for now?).
 - The driver no longer try to use the subdev for cropping (using
   cropcrop/s_crop).
 - Do not interrogate the subdev using g_mbus_config.

The goal is to replace the soc_camera driver completely to prepare for
Gen3 enablement.  Is it a good idea to aim for inheriting
CONFIG_VIDEO_RCAR_VIN in such case?  I'm thinking down the road if this
driver is good enough to simply rename the old CONFIG_VIDEO_RCAR_VIN to
something like CONFIG_VIDEO_SOC_CAMERA_RCAR_VIN mark is at deprecated
and use this one as a drop in replacement.

The main feature missing at this point is vidioc_[gs]_selection. The
driver can crop/scale but it's not exposed to the user. However this
will be different on Gen3 HW where not all channels have scalers.

More stress testing is also needed for example streaming over longer
periods.

 drivers/media/platform/rcar-vin/rcar-dma.c   |  942 ++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h   |  178 +++
 drivers/media/platform/rcar-vin/rcar-vinip.c | 1552 ++++++++++++++++++++++++++
 3 files changed, 2672 insertions(+)
 create mode 100644 drivers/media/platform/rcar-vin/rcar-dma.c
 create mode 100644 drivers/media/platform/rcar-vin/rcar-vin.h
 create mode 100644 drivers/media/platform/rcar-vin/rcar-vinip.c

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
new file mode 100644
index 0000000..8041e0d
--- /dev/null
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -0,0 +1,942 @@
+/*
+ * Driver for Renesas R-Car VIN IP
+ *
+ * Copyright (C) 2016 Renesas Solutions Corp.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "rcar-vin.h"
+
+#define VIN_MAX_WIDTH	2048
+#define VIN_MAX_HEIGHT	2048
+#define TIMEOUT_MS	100
+
+struct rvin_buffer {
+	struct vb2_v4l2_buffer vb;
+	struct list_head list;
+};
+
+#define to_buf_list(vb2_buffer) (&container_of(vb2_buffer, \
+			struct rvin_buffer, \
+			vb)->list)
+
+/* -----------------------------------------------------------------------------
+ * DMA Functions
+ */
+
+static int rvin_get_free_hw_slot(struct rvin_dev *vin)
+{
+	int slot;
+
+	for (slot = 0; slot < vin->nr_hw_slots; slot++)
+		if (vin->queue_buf[slot] == NULL)
+			return slot;
+
+	return -1;
+}
+
+static int rvin_hw_ready(struct rvin_dev *vin)
+{
+	/* Ensure all HW slots are filled */
+	return rvin_get_free_hw_slot(vin) < 0 ? 1 : 0;
+}
+
+/* Moves a buffer from the queue to the HW slots */
+static int rvin_fill_hw_slot(struct rvin_dev *vin)
+{
+	struct rvin_buffer *buf;
+	struct vb2_v4l2_buffer *vbuf;
+	dma_addr_t phys_addr_top;
+	int slot;
+
+	if (list_empty(&vin->buf_list))
+		return 0;
+
+	/* Search for free HW slot */
+	slot = rvin_get_free_hw_slot(vin);
+	if (slot < 0)
+		return 0;
+
+	/* Keep track of buffer we give to HW */
+	buf = list_entry(vin->buf_list.next, struct rvin_buffer, list);
+	vbuf = &buf->vb;
+	list_del_init(to_buf_list(vbuf));
+	vin->queue_buf[slot] = vbuf;
+
+	/* Setup DMA */
+	phys_addr_top = vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0);
+	rvin_set_slot_addr(vin, slot, phys_addr_top);
+
+	return 1;
+}
+
+/* Need to hold qlock before calling */
+static void return_all_buffers(struct rvin_dev *vin,
+		enum vb2_buffer_state state)
+{
+	struct rvin_buffer *buf, *node;
+
+	list_for_each_entry_safe(buf, node, &vin->buf_list, list) {
+		vb2_buffer_done(&buf->vb.vb2_buf, state);
+		list_del(&buf->list);
+	}
+}
+
+static int rvin_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
+		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
+
+{
+	struct rvin_dev *vin = vb2_get_drv_priv(vq);
+
+	alloc_ctxs[0] = vin->alloc_ctx;
+
+	if (!*nbuffers)
+		*nbuffers = 2;
+	vin->vb_count = *nbuffers;
+
+	/* Number of hardware slots */
+	if (is_continuous_transfer(vin))
+		vin->nr_hw_slots = MAX_BUFFER_NUM;
+	else
+		vin->nr_hw_slots = 1;
+
+	if (*nplanes)
+		return sizes[0] < vin->format.sizeimage ? -EINVAL : 0;
+
+	sizes[0] = vin->format.sizeimage;
+	*nplanes = 1;
+
+	vin_dbg(vin, "nbuffers=%d, size=%u\n", *nbuffers, sizes[0]);
+
+	return 0;
+};
+
+static int rvin_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct rvin_dev *vin = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size = vin->format.sizeimage;
+
+	if (vb2_plane_size(vb, 0) < size) {
+		vin_err(vin, "buffer too small (%lu < %lu)\n",
+				vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, size);
+	return 0;
+}
+
+static void rvin_buffer_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	unsigned long flags;
+	struct rvin_dev *vin = vb2_get_drv_priv(vb->vb2_queue);
+
+	spin_lock_irqsave(&vin->qlock, flags);
+
+	list_add_tail(to_buf_list(vbuf), &vin->buf_list);
+	rvin_fill_hw_slot(vin);
+
+	spin_unlock_irqrestore(&vin->qlock, flags);
+}
+
+static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct rvin_dev *vin = vb2_get_drv_priv(vq);
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vin->qlock, flags);
+
+	ret = rvin_setup(vin);
+	if (!ret) {
+		vin->request_to_stop = false;
+		init_completion(&vin->capture_stop);
+		vin->state = RUNNING;
+		rvin_capture(vin);
+	}
+
+	if (ret) {
+		/*
+		 * In case of an error, return all active buffers to the
+		 * QUEUED state
+		 */
+		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
+	}
+
+	spin_unlock_irqrestore(&vin->qlock, flags);
+
+	return ret;
+}
+
+static void rvin_stop_streaming(struct vb2_queue *vq)
+{
+	struct rvin_dev *vin = vb2_get_drv_priv(vq);
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&vin->qlock, flags);
+
+	rvin_request_capture_stop(vin);
+
+	/* Wait for streaming to stop */
+	while (vin->state != STOPPED) {
+		/* issue stop if running */
+		if (vin->state == RUNNING)
+			rvin_request_capture_stop(vin);
+
+		/* Wait until capturing has been stopped */
+		if (vin->state == STOPPING) {
+			vin->request_to_stop = true;
+			spin_unlock_irqrestore(&vin->qlock, flags);
+			if (!wait_for_completion_timeout(&vin->capture_stop,
+						msecs_to_jiffies(TIMEOUT_MS)))
+				vin->state = STOPPED;
+			spin_lock_irqsave(&vin->qlock, flags);
+		}
+	}
+
+	for (i = 0; i < MAX_BUFFER_NUM; i++) {
+		if (vin->queue_buf[i]) {
+			vb2_buffer_done(&vin->queue_buf[i]->vb2_buf,
+					VB2_BUF_STATE_ERROR);
+			vin->queue_buf[i] = NULL;
+		}
+	}
+
+	/* Release all active buffers */
+	return_all_buffers(vin, VB2_BUF_STATE_ERROR);
+
+	spin_unlock_irqrestore(&vin->qlock, flags);
+}
+
+static struct vb2_ops rvin_qops = {
+	.queue_setup		= rvin_queue_setup,
+	.buf_prepare		= rvin_buffer_prepare,
+	.buf_queue		= rvin_buffer_queue,
+	.start_streaming	= rvin_start_streaming,
+	.stop_streaming		= rvin_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+static irqreturn_t rvin_irq(int irq, void *data)
+{
+	struct rvin_dev *vin = data;
+	u32 int_status;
+	bool hw_stopped;
+	int slot;
+	unsigned int handled = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vin->qlock, flags);
+
+	int_status = rvin_get_interrupt_status(vin);
+	if (!int_status)
+		goto done;
+	rvin_ack_interrupt(vin);
+	handled = 1;
+
+	/* Nothing to do if capture status is 'STOPPED' */
+	if (vin->state == STOPPED)
+		goto done;
+
+	hw_stopped = !rvin_capture_active(vin);
+
+	if (hw_stopped) {
+		vin->state = STOPPED;
+		vin->request_to_stop = false;
+		complete(&vin->capture_stop);
+		goto done;
+	}
+
+	if (!rvin_hw_ready(vin))
+		goto done;
+
+	slot = rvin_get_active_slot(vin);
+
+	vin->queue_buf[slot]->field = vin->format.field;
+	vin->queue_buf[slot]->sequence = vin->sequence++;
+	vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
+	vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf, VB2_BUF_STATE_DONE);
+	vin->queue_buf[slot] = NULL;
+
+	rvin_fill_hw_slot(vin);
+
+done:
+	spin_unlock_irqrestore(&vin->qlock, flags);
+
+	return IRQ_RETVAL(handled);
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 ioctls
+ */
+
+static int __rvin_dma_try_format_sensor(struct rvin_dev *vin,
+		u32 which,
+		struct v4l2_pix_format *pix,
+		const struct rvin_video_format *info,
+		struct rvin_sensor *sensor)
+{
+	struct v4l2_subdev *sd;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = which,
+	};
+	u32 rwidth, rheight, swidth, sheight;
+	int ret;
+
+	sd = vin_to_sd(vin);
+
+	/* Requested */
+	rwidth = pix->width;
+	rheight = pix->height;
+
+	v4l2_fill_mbus_format(&format.format, pix, info->code);
+	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
+			&pad_cfg, &format);
+	if (ret < 0)
+		return ret;
+	v4l2_fill_pix_format(pix, &format.format);
+
+	/* Sensor */
+	swidth = pix->width;
+	sheight = pix->height;
+
+	vin_dbg(vin, "sensor format: %ux%u requested format: %ux%u\n", swidth,
+			sheight, rwidth, rheight);
+
+	if (swidth != rwidth || sheight != rheight) {
+		vin_dbg(vin, "sensor format mismatch, see if we can scale\n");
+		ret = rvin_scale_try(vin, pix, rwidth, rheight);
+		if (ret)
+			return ret;
+	}
+
+	/* Store sensor output format */
+	if (sensor) {
+		sensor->width = swidth;
+		sensor->height = sheight;
+	}
+
+	return 0;
+}
+
+static int __rvin_dma_try_format(struct rvin_dev *vin,
+		u32 which,
+		struct v4l2_pix_format *pix,
+		const struct rvin_video_format **fmtinfo,
+		struct rvin_sensor *sensor)
+{
+	const struct rvin_video_format *info;
+	struct v4l2_subdev *sd;
+	v4l2_std_id std;
+	int ret;
+
+	sd = vin_to_sd(vin);
+
+	/* Retrieve format information and select the current format if the
+	 * requested format isn't supported.
+	 */
+	info = rvin_get_format_by_fourcc(vin, pix->pixelformat);
+	if (!info) {
+		info = vin->fmtinfo;
+		vin_dbg(vin, "Format %x not found, keeping %x\n",
+				pix->pixelformat, vin->fmtinfo->fourcc);
+		pix->pixelformat = vin->format.pixelformat;
+		pix->colorspace = vin->format.colorspace;
+		pix->bytesperline = vin->format.bytesperline;
+		pix->sizeimage = vin->format.sizeimage;
+		pix->field = vin->format.field;
+	}
+
+	/* FIXME: calculate using depth and bus width */
+	v4l_bound_align_image(&pix->width, 2, VIN_MAX_WIDTH, 1,
+			&pix->height, 4, VIN_MAX_HEIGHT, 2, 0);
+
+	/* Limit to sensor capabilities */
+	ret = __rvin_dma_try_format_sensor(vin, which, pix, info, sensor);
+	if (ret)
+		return ret;
+
+	switch (pix->field) {
+	default:
+		pix->field = V4L2_FIELD_NONE;
+		/* fall-through */
+	case V4L2_FIELD_NONE:
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+		break;
+	case V4L2_FIELD_INTERLACED:
+		/* Query for standard if not explicitly mentioned _TB/_BT */
+		ret = v4l2_subdev_call(sd, video, querystd, &std);
+		if (ret < 0) {
+			if (ret != -ENOIOCTLCMD)
+				return ret;
+			pix->field = V4L2_FIELD_NONE;
+		} else {
+			pix->field = std & V4L2_STD_625_50 ?
+				V4L2_FIELD_INTERLACED_TB :
+				V4L2_FIELD_INTERLACED_BT;
+		}
+		break;
+	}
+
+	ret = rvin_bytes_per_line(info, pix->width);
+	if (ret < 0)
+		return ret;
+	pix->bytesperline = max_t(u32, pix->bytesperline, ret);
+
+	ret = rvin_image_size(info, pix->bytesperline, pix->height);
+	if (ret < 0)
+		return ret;
+	pix->sizeimage = max_t(u32, pix->sizeimage, ret);
+
+	if (fmtinfo)
+		*fmtinfo = info;
+
+	return 0;
+}
+
+static int rvin_querycap(struct file *file, void *priv,
+		struct v4l2_capability *cap)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+
+	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strlcpy(cap->card, "R_Car_VIN", sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+			dev_name(vin->dev));
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+
+	/* Only single-plane capture is supported so far */
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	return __rvin_dma_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
+			NULL, NULL);
+}
+
+static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	const struct rvin_video_format *info;
+	struct rvin_sensor sensor;
+	int ret;
+
+	/* Only single-plane capture is supported so far */
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (vb2_is_busy(&vin->queue))
+		return -EBUSY;
+
+	ret = __rvin_dma_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
+			&info, &sensor);
+	if (ret)
+		return ret;
+
+	vin->format = f->fmt.pix;
+	vin->fmtinfo = info;
+	vin->sensor.width = sensor.width;
+	vin->sensor.height = sensor.height;
+
+	vin_dbg(vin, "set width: %d height: %d\n", vin->format.width,
+			vin->format.height);
+
+	return 0;
+}
+
+static int rvin_g_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	f->fmt.pix = vin->format;
+
+	return 0;
+}
+
+static int rvin_enum_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_fmtdesc *f)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+
+	if (f->index >= vin->sensor.num_formats)
+		return -EINVAL;
+
+	f->pixelformat = vin->sensor.formats[f->index].fourcc;
+	strlcpy(f->description, vin->sensor.formats[f->index].name,
+			sizeof(f->description));
+	return 0;
+}
+
+static int rvin_enum_input(struct file *file, void *priv,
+		struct v4l2_input *i)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+
+	if (i->index != 0)
+		return -EINVAL;
+
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	i->std = vin->vdev.tvnorms;
+	strlcpy(i->name, "Camera", sizeof(i->name));
+
+	return 0;
+}
+
+static int rvin_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int rvin_s_input(struct file *file, void *priv, unsigned int i)
+{
+	if (i > 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int rvin_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	int ret;
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_sd(vin);
+
+	WARN_ON(priv != file->private_data);
+
+	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	ret = vb2_streamon(&vin->queue, i);
+	if (!ret)
+		v4l2_subdev_call(sd, video, s_stream, 1);
+
+	return ret;
+}
+
+static int rvin_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	int ret;
+	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *sd = vin_to_sd(vin);
+
+	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	/*
+	 * This calls buf_release from host driver's videobuf_queue_ops for all
+	 * remaining buffers. When the last buffer is freed, stop capture
+	 */
+	ret = vb2_streamoff(&vin->queue, i);
+
+	v4l2_subdev_call(sd, video, s_stream, 0);
+
+	return ret;
+}
+
+static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
+	.vidioc_querycap		= rvin_querycap,
+	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= rvin_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= rvin_s_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap	= rvin_enum_fmt_vid_cap,
+
+	/* TODO:
+	 * .vidioc_g_selection		= rvin_g_selection,
+	 * .vidioc_s_selection		= rvin_s_selection,
+	 */
+
+	.vidioc_enum_input		= rvin_enum_input,
+	.vidioc_g_input			= rvin_g_input,
+	.vidioc_s_input			= rvin_s_input,
+
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+
+	.vidioc_streamon		= rvin_streamon,
+	.vidioc_streamoff		= rvin_streamoff,
+
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+};
+
+/* -----------------------------------------------------------------------------
+ * File Operations
+ */
+
+static int __rvin_power_on(struct rvin_dev *vin)
+{
+	int ret;
+	struct v4l2_subdev *sd = vin_to_sd(vin);
+
+	ret = v4l2_subdev_call(sd, core, s_power, 1);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
+	return 0;
+}
+
+static int __rvin_power_off(struct rvin_dev *vin)
+{
+	int ret;
+	struct v4l2_subdev *sd = vin_to_sd(vin);
+
+	ret = v4l2_subdev_call(sd, core, s_power, 0);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
+	return 0;
+}
+static int rvin_add_device(struct rvin_dev *vin)
+{
+	int i;
+
+	for (i = 0; i < MAX_BUFFER_NUM; i++)
+		vin->queue_buf[i] = NULL;
+
+	pm_runtime_get_sync(vin->v4l2_dev.dev);
+
+	return 0;
+}
+
+static int rvin_remove_device(struct rvin_dev *vin)
+{
+	struct vb2_v4l2_buffer *vbuf;
+	unsigned long flags;
+	int i;
+
+	/* disable capture, disable interrupts */
+	rvin_disable_capture(vin);
+	rvin_disable_interrupts(vin);
+
+	vin->state = STOPPED;
+	vin->request_to_stop = false;
+
+	spin_lock_irqsave(&vin->qlock, flags);
+	for (i = 0; i < MAX_BUFFER_NUM; i++) {
+		vbuf = vin->queue_buf[i];
+		if (vbuf) {
+			list_del_init(to_buf_list(vbuf));
+			vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_ERROR);
+		}
+	}
+	spin_unlock_irqrestore(&vin->qlock, flags);
+
+	pm_runtime_put(vin->v4l2_dev.dev);
+
+	return 0;
+}
+
+static int rvin_initialize_device(struct file *file)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	int ret;
+
+	struct v4l2_format f = {
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		.fmt.pix = {
+			.width		= vin->format.width,
+			.height		= vin->format.height,
+			.field		= vin->format.field,
+			.colorspace	= vin->format.colorspace,
+			.pixelformat	= vin->fmtinfo->fourcc,
+		},
+	};
+
+	rvin_add_device(vin);
+
+	/* Power on subdevice */
+	ret = __rvin_power_on(vin);
+	if (ret < 0)
+		goto epower;
+
+	pm_runtime_enable(&vin->vdev.dev);
+	ret = pm_runtime_resume(&vin->vdev.dev);
+	if (ret < 0 && ret != -ENOSYS)
+		goto eresume;
+
+	/*
+	 * Try to configure with default parameters. Notice: this is the
+	 * very first open, so, we cannot race against other calls,
+	 * apart from someone else calling open() simultaneously, but
+	 * .host_lock is protecting us against it.
+	 */
+	ret = rvin_s_fmt_vid_cap(file, NULL, &f);
+	if (ret < 0)
+		goto esfmt;
+
+	v4l2_ctrl_handler_setup(&vin->ctrl_handler);
+
+
+	return 0;
+esfmt:
+	pm_runtime_disable(&vin->vdev.dev);
+eresume:
+	__rvin_power_off(vin);
+epower:
+	rvin_remove_device(vin);
+
+	return ret;
+}
+
+static int rvin_open(struct file *file)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	int ret;
+
+	mutex_lock(&vin->lock);
+
+	file->private_data = vin;
+
+	ret = v4l2_fh_open(file);
+	if (ret)
+		goto unlock;
+
+	if (!v4l2_fh_is_singular_file(file))
+		goto unlock;
+
+	if (rvin_initialize_device(file)) {
+		v4l2_fh_release(file);
+		ret = -ENODEV;
+	}
+
+unlock:
+	mutex_unlock(&vin->lock);
+	return ret;
+}
+
+static int rvin_release(struct file *file)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	bool fh_singular;
+	int ret;
+
+	mutex_lock(&vin->lock);
+
+	/* Save the singular status before we call the clean-up helper */
+	fh_singular = v4l2_fh_is_singular_file(file);
+
+	/* the release helper will cleanup any on-going streaming */
+	ret = _vb2_fop_release(file, NULL);
+
+	/*
+	 * If this was the last open file.
+	 * Then de-initialize hw module.
+	 */
+	if (fh_singular) {
+		pm_runtime_suspend(&vin->vdev.dev);
+		pm_runtime_disable(&vin->vdev.dev);
+
+		__rvin_power_off(vin);
+
+		rvin_remove_device(vin);
+	}
+
+	mutex_unlock(&vin->lock);
+
+	return ret;
+}
+
+static const struct v4l2_file_operations rvin_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= video_ioctl2,
+	.open		= rvin_open,
+	.release	= rvin_release,
+	.poll		= vb2_fop_poll,
+	.mmap		= vb2_fop_mmap,
+};
+
+/* -----------------------------------------------------------------------------
+ * DMA Core
+ */
+
+void rvin_dma_cleanup(struct rvin_dev *vin)
+{
+	if (video_is_registered(&vin->vdev)) {
+		v4l2_info(&vin->v4l2_dev, "Removing /dev/video%d\n",
+				vin->vdev.num);
+		video_unregister_device(&vin->vdev);
+	}
+
+	if (!IS_ERR_OR_NULL(vin->alloc_ctx))
+		vb2_dma_contig_cleanup_ctx(vin->alloc_ctx);
+
+	/* Checks internaly if handlers have been init or not */
+	v4l2_ctrl_handler_free(&vin->ctrl_handler);
+
+	mutex_destroy(&vin->lock);
+}
+
+int rvin_dma_init(struct rvin_dev *vin, int irq)
+{
+	struct video_device *vdev = &vin->vdev;
+	struct vb2_queue *q = &vin->queue;
+	int ret;
+
+	mutex_init(&vin->lock);
+	INIT_LIST_HEAD(&vin->buf_list);
+	spin_lock_init(&vin->qlock);
+
+	/* TODO: add more default vin->format and vin->fmts */
+	vin->state = STOPPED;
+	vin->format.width = VIN_MAX_WIDTH;
+	vin->format.height = VIN_MAX_HEIGHT;
+
+	/* Add the controls */
+	/*
+	 * Currently the subdev with the largest number of controls (13) is
+	 * ov6550. So let's pick 16 as a hint for the control handler. Note
+	 * that this is a hint only: too large and you waste some memory, too
+	 * small and there is a (very) small performance hit when looking up
+	 * controls in the internal hash.
+	 */
+	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
+	if (ret < 0)
+		goto error;
+
+	/* video node */
+	vdev->fops = &rvin_fops;
+	vdev->v4l2_dev = &vin->v4l2_dev;
+	vdev->queue = &vin->queue;
+	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
+	vdev->release = video_device_release_empty;
+	vdev->ioctl_ops = &rvin_ioctl_ops;
+	vdev->lock = &vin->lock;
+	vdev->ctrl_handler = &vin->ctrl_handler;
+
+	/* buffer queue */
+	vin->alloc_ctx = vb2_dma_contig_init_ctx(vin->dev);
+	if (IS_ERR(vin->alloc_ctx)) {
+		ret = PTR_ERR(vin->alloc_ctx);
+		goto error;
+	}
+
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->lock = &vin->lock;
+	q->drv_priv = vin;
+	q->buf_struct_size = sizeof(struct rvin_buffer);
+	q->ops = &rvin_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+
+	ret = vb2_queue_init(q);
+	if (ret < 0) {
+		vin_err(vin, "failed to initialize VB2 queue\n");
+		goto error;
+	}
+
+	/* irq */
+	ret = devm_request_irq(vin->dev, irq,
+			rvin_irq, IRQF_SHARED, KBUILD_MODNAME, vin);
+	if (ret) {
+		vin_err(vin, "failed to request irq\n");
+		goto error;
+	}
+
+	return 0;
+error:
+	rvin_dma_cleanup(vin);
+	return ret;
+}
+
+int rvin_dma_on(struct rvin_dev *vin)
+{
+	struct v4l2_subdev *sd;
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	int ret;
+
+	sd = vin_to_sd(vin);
+
+	/* Pick first format as default format */
+	vin->fmtinfo = &vin->sensor.formats[0];
+
+	sd->grp_id = 0;
+	v4l2_set_subdev_hostdata(sd, vin);
+
+	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
+
+	if (vin->vdev.tvnorms == 0) {
+		/* Disable the STD API if there are no tvnorms defined */
+		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
+		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
+	}
+
+	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
+	if (ret < 0)
+		return ret;
+
+	ret = rvin_add_device(vin);
+	if (ret < 0) {
+		vin_err(vin, "Couldn't activate the camera: %d\n", ret);
+		return ret;
+	}
+
+	/* TODO: ret = rvin_sensor_setup(vin, pix, ...); */
+
+	vin->format.field = V4L2_FIELD_ANY;
+
+	video_set_drvdata(&vin->vdev, vin);
+
+	ret = video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		vin_err(vin, "Failed to register video device\n");
+		goto remove_device;
+	}
+
+	v4l2_info(&vin->v4l2_dev, "Device registered as /dev/video%d\n",
+			vin->vdev.num);
+
+	/* Try to improve our guess of a reasonable window format */
+	if (!v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt)) {
+		vin->format.width	= mf->width;
+		vin->format.height	= mf->height;
+		vin->format.colorspace	= mf->colorspace;
+		vin->format.field	= mf->field;
+	}
+
+remove_device:
+	rvin_remove_device(vin);
+
+	return ret;
+}
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
new file mode 100644
index 0000000..99141d7
--- /dev/null
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -0,0 +1,178 @@
+/*
+ * Driver for Renesas R-Car VIN IP
+ *
+ * Copyright (C) 2016 Renesas Solutions Corp.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __RCAR_VIN__
+#define __RCAR_VIN__
+
+#include <media/v4l2-async.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
+
+enum chip_id {
+	RCAR_GEN2,
+	RCAR_H1,
+	RCAR_M1,
+	RCAR_E1,
+};
+
+/* Max number of HW buffers */
+#define MAX_BUFFER_NUM 3
+
+/**
+ * enum rvin_mbus_packing - data packing types on the media-bus
+ * @RVIN_MBUS_PACKING_NONE:      no packing, bit-for-bit transfer to RAM, one
+ *				 sample represents one pixel
+ * @RVIN_MBUS_PACKING_2X8_PADHI: 16 bits transferred in 2 8-bit samples, in the
+ *				 possibly incomplete byte high bits are padding
+ * @RVIN_MBUS_PACKING_2X8_PADLO: as above, but low bits are padding
+ * @RVIN_MBUS_PACKING_EXTEND16:	 sample width (e.g., 10 bits) has to be extended
+ *				 to 16 bits
+ * @RVIN_MBUS_PACKING_VARIABLE:	 compressed formats with variable packing
+ * @RVIN_MBUS_PACKING_1_5X8:	 used for packed YUV 4:2:0 formats, where 4
+ *				 pixels occupy 6 bytes in RAM
+ * @RVIN_MBUS_PACKING_EXTEND32:	 sample width (e.g., 24 bits) has to be extended
+ *				 to 32 bits
+ */
+enum rvin_mbus_packing {
+	RVIN_MBUS_PACKING_NONE,
+	RVIN_MBUS_PACKING_2X8_PADHI,
+	RVIN_MBUS_PACKING_2X8_PADLO,
+	RVIN_MBUS_PACKING_EXTEND16,
+	RVIN_MBUS_PACKING_VARIABLE,
+	RVIN_MBUS_PACKING_1_5X8,
+	RVIN_MBUS_PACKING_EXTEND32,
+};
+
+/**
+ * struct rvin_video_format - Data format on the media bus
+ * @code		Media bus format
+ * @name:		Name of the format
+ * @fourcc:		Fourcc code, that will be obtained if the data is
+ *			stored in memory in the following way:
+ * @packing:		Type of sample-packing, that has to be used
+ * @bits_per_sample:	How many bits the bridge has to sample
+ */
+struct rvin_video_format {
+	u32			code;
+	const char		*name;
+	u32			fourcc;
+	enum rvin_mbus_packing	packing;
+	u8			bits_per_sample;
+};
+
+/**
+ * struct rvin_sensor - Sensor information
+ * @width		Width of camera output
+ * @height:		Height of camere output
+ * @num_formats:	Number of formats camera support
+ * @formats:		Supported format information
+ */
+struct rvin_sensor {
+	u32 width;
+	u32 height;
+
+	int num_formats;
+	struct rvin_video_format *formats;
+};
+
+enum rvin_dma_state {
+	STOPPED = 0,
+	RUNNING,
+	STOPPING,
+};
+
+struct rvin_graph_entity {
+	struct device_node *node;
+	struct media_entity *entity;
+
+	struct v4l2_async_subdev asd;
+	struct v4l2_subdev *subdev;
+};
+
+/* TODO: split out a 'struct rvin_dma' */
+struct rvin_dev {
+	struct device *dev;
+	void __iomem *base;
+	enum chip_id chip;
+
+	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler ctrl_handler;
+
+	struct video_device vdev;
+	struct mutex lock;
+
+	struct vb2_queue queue;
+	struct vb2_v4l2_buffer *queue_buf[MAX_BUFFER_NUM];
+	struct vb2_alloc_ctx *alloc_ctx;
+
+	spinlock_t qlock;
+	struct list_head buf_list;
+	unsigned sequence;
+
+	/* TODO: needed ? */
+	unsigned int pdata_flags;
+
+	struct v4l2_async_notifier notifier;
+	struct rvin_graph_entity entity;
+
+	struct v4l2_pix_format format;
+	const struct rvin_video_format *fmtinfo;
+
+	struct rvin_sensor sensor;
+
+	enum rvin_dma_state state;
+	unsigned int vb_count;
+	unsigned int nr_hw_slots;
+	bool request_to_stop;
+	struct completion capture_stop;
+};
+
+#define vin_to_sd(vin)			vin->entity.subdev
+#define is_continuous_transfer(vin)	(vin->vb_count > MAX_BUFFER_NUM)
+
+/* Debug */
+#define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
+#define vin_info(d, fmt, arg...)	dev_info(d->dev, fmt, ##arg)
+#define vin_warn(d, fmt, arg...)	dev_warn(d->dev, fmt, ##arg)
+#define vin_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
+
+/* Format */
+const struct rvin_video_format *rvin_get_format_by_fourcc(
+		struct rvin_dev *vin, u32 fourcc);
+s32 rvin_bytes_per_line(const struct rvin_video_format *info, u32 width);
+s32 rvin_image_size(const struct rvin_video_format *info, u32 bytes_per_line,
+		u32 height);
+
+/* Scaling */
+int rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix, u32 width,
+		u32 height);
+int rvin_scale_setup(struct rvin_dev *vin);
+
+/* HW */
+int rvin_get_active_slot(struct rvin_dev *vin);
+void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t addr);
+void rvin_disable_interrupts(struct rvin_dev *vin);
+void rvin_disable_capture(struct rvin_dev *vin);
+u32 rvin_get_interrupt_status(struct rvin_dev *vin);
+void rvin_ack_interrupt(struct rvin_dev *vin);
+bool rvin_capture_active(struct rvin_dev *vin);
+int rvin_setup(struct rvin_dev *vin);
+void rvin_capture(struct rvin_dev *vin);
+void rvin_request_capture_stop(struct rvin_dev *vin);
+
+/* DMA Core */
+int rvin_dma_init(struct rvin_dev *vin, int irq);
+void rvin_dma_cleanup(struct rvin_dev *vin);
+int rvin_dma_on(struct rvin_dev *vin);
+
+#endif
diff --git a/drivers/media/platform/rcar-vin/rcar-vinip.c b/drivers/media/platform/rcar-vin/rcar-vinip.c
new file mode 100644
index 0000000..fa6cc69
--- /dev/null
+++ b/drivers/media/platform/rcar-vin/rcar-vinip.c
@@ -0,0 +1,1552 @@
+/*
+ * Driver for Renesas R-Car VIN IP
+ *
+ * Copyright (C) 2016 Renesas Solutions Corp.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+#include <media/videobuf2-v4l2.h>
+
+#include "rcar-vin.h"
+
+#define notifier_to_vin(n) container_of(n, struct rvin_dev, notifier)
+
+/* -----------------------------------------------------------------------------
+ * HW Functions
+ */
+
+/* Register offsets for R-Car VIN */
+#define VNMC_REG	0x00	/* Video n Main Control Register */
+#define VNMS_REG	0x04	/* Video n Module Status Register */
+#define VNFC_REG	0x08	/* Video n Frame Capture Register */
+#define VNSLPRC_REG	0x0C	/* Video n Start Line Pre-Clip Register */
+#define VNELPRC_REG	0x10	/* Video n End Line Pre-Clip Register */
+#define VNSPPRC_REG	0x14	/* Video n Start Pixel Pre-Clip Register */
+#define VNEPPRC_REG	0x18	/* Video n End Pixel Pre-Clip Register */
+#define VNSLPOC_REG	0x1C	/* Video n Start Line Post-Clip Register */
+#define VNELPOC_REG	0x20	/* Video n End Line Post-Clip Register */
+#define VNSPPOC_REG	0x24	/* Video n Start Pixel Post-Clip Register */
+#define VNEPPOC_REG	0x28	/* Video n End Pixel Post-Clip Register */
+#define VNIS_REG	0x2C	/* Video n Image Stride Register */
+#define VNMB_REG(m)	(0x30 + ((m) << 2)) /* Video n Memory Base m Register */
+#define VNIE_REG	0x40	/* Video n Interrupt Enable Register */
+#define VNINTS_REG	0x44	/* Video n Interrupt Status Register */
+#define VNSI_REG	0x48	/* Video n Scanline Interrupt Register */
+#define VNMTC_REG	0x4C	/* Video n Memory Transfer Control Register */
+#define VNYS_REG	0x50	/* Video n Y Scale Register */
+#define VNXS_REG	0x54	/* Video n X Scale Register */
+#define VNDMR_REG	0x58	/* Video n Data Mode Register */
+#define VNDMR2_REG	0x5C	/* Video n Data Mode Register 2 */
+#define VNUVAOF_REG	0x60	/* Video n UV Address Offset Register */
+#define VNC1A_REG	0x80	/* Video n Coefficient Set C1A Register */
+#define VNC1B_REG	0x84	/* Video n Coefficient Set C1B Register */
+#define VNC1C_REG	0x88	/* Video n Coefficient Set C1C Register */
+#define VNC2A_REG	0x90	/* Video n Coefficient Set C2A Register */
+#define VNC2B_REG	0x94	/* Video n Coefficient Set C2B Register */
+#define VNC2C_REG	0x98	/* Video n Coefficient Set C2C Register */
+#define VNC3A_REG	0xA0	/* Video n Coefficient Set C3A Register */
+#define VNC3B_REG	0xA4	/* Video n Coefficient Set C3B Register */
+#define VNC3C_REG	0xA8	/* Video n Coefficient Set C3C Register */
+#define VNC4A_REG	0xB0	/* Video n Coefficient Set C4A Register */
+#define VNC4B_REG	0xB4	/* Video n Coefficient Set C4B Register */
+#define VNC4C_REG	0xB8	/* Video n Coefficient Set C4C Register */
+#define VNC5A_REG	0xC0	/* Video n Coefficient Set C5A Register */
+#define VNC5B_REG	0xC4	/* Video n Coefficient Set C5B Register */
+#define VNC5C_REG	0xC8	/* Video n Coefficient Set C5C Register */
+#define VNC6A_REG	0xD0	/* Video n Coefficient Set C6A Register */
+#define VNC6B_REG	0xD4	/* Video n Coefficient Set C6B Register */
+#define VNC6C_REG	0xD8	/* Video n Coefficient Set C6C Register */
+#define VNC7A_REG	0xE0	/* Video n Coefficient Set C7A Register */
+#define VNC7B_REG	0xE4	/* Video n Coefficient Set C7B Register */
+#define VNC7C_REG	0xE8	/* Video n Coefficient Set C7C Register */
+#define VNC8A_REG	0xF0	/* Video n Coefficient Set C8A Register */
+#define VNC8B_REG	0xF4	/* Video n Coefficient Set C8B Register */
+#define VNC8C_REG	0xF8	/* Video n Coefficient Set C8C Register */
+
+/* Register bit fields for R-Car VIN */
+/* Video n Main Control Register bits */
+#define VNMC_FOC		(1 << 21)
+#define VNMC_YCAL		(1 << 19)
+#define VNMC_INF_YUV8_BT656	(0 << 16)
+#define VNMC_INF_YUV8_BT601	(1 << 16)
+#define VNMC_INF_YUV10_BT656	(2 << 16)
+#define VNMC_INF_YUV10_BT601	(3 << 16)
+#define VNMC_INF_YUV16		(5 << 16)
+#define VNMC_INF_RGB888		(6 << 16)
+#define VNMC_VUP		(1 << 10)
+#define VNMC_IM_ODD		(0 << 3)
+#define VNMC_IM_ODD_EVEN	(1 << 3)
+#define VNMC_IM_EVEN		(2 << 3)
+#define VNMC_IM_FULL		(3 << 3)
+#define VNMC_BPS		(1 << 1)
+#define VNMC_ME			(1 << 0)
+
+/* Video n Module Status Register bits */
+#define VNMS_FBS_MASK		(3 << 3)
+#define VNMS_FBS_SHIFT		3
+#define VNMS_AV			(1 << 1)
+#define VNMS_CA			(1 << 0)
+
+/* Video n Frame Capture Register bits */
+#define VNFC_C_FRAME		(1 << 1)
+#define VNFC_S_FRAME		(1 << 0)
+
+/* Video n Interrupt Enable Register bits */
+#define VNIE_FIE		(1 << 4)
+#define VNIE_EFE		(1 << 1)
+
+/* Video n Data Mode Register bits */
+#define VNDMR_EXRGB		(1 << 8)
+#define VNDMR_BPSM		(1 << 4)
+#define VNDMR_DTMD_YCSEP	(1 << 1)
+#define VNDMR_DTMD_ARGB1555	(1 << 0)
+
+/* Video n Data Mode Register 2 bits */
+#define VNDMR2_VPS		(1 << 30)
+#define VNDMR2_HPS		(1 << 29)
+#define VNDMR2_FTEV		(1 << 17)
+#define VNDMR2_VLV(n)		((n & 0xf) << 12)
+
+#define RVIN_HSYNC_ACTIVE_LOW       (1 << 0)
+#define RVIN_VSYNC_ACTIVE_LOW       (1 << 1)
+#define RVIN_BT601                  (1 << 2)
+#define RVIN_BT656                  (1 << 3)
+
+static void rvin_write(struct rvin_dev *vin, u32 value, u32 offset)
+{
+	iowrite32(value, vin->base + offset);
+}
+
+static u32 rvin_read(struct rvin_dev *vin, u32 offset)
+{
+	return ioread32(vin->base + offset);
+}
+
+int rvin_get_active_slot(struct rvin_dev *vin)
+{
+	if (is_continuous_transfer(vin))
+		return (rvin_read(vin, VNMS_REG) & VNMS_FBS_MASK)
+			>> VNMS_FBS_SHIFT;
+	return  0;
+}
+
+void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t addr)
+{
+	rvin_write(vin, addr, VNMB_REG(slot));
+}
+
+int rvin_setup(struct rvin_dev *vin)
+{
+	u32 vnmc, dmr, dmr2, interrupts;
+	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
+	int ret;
+
+	ret = rvin_scale_setup(vin);
+	if (ret < 0)
+		return ret;
+
+	switch (vin->format.field) {
+	case V4L2_FIELD_TOP:
+		vnmc = VNMC_IM_ODD;
+		break;
+	case V4L2_FIELD_BOTTOM:
+		vnmc = VNMC_IM_EVEN;
+		break;
+	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_INTERLACED_TB:
+		vnmc = VNMC_IM_FULL;
+		break;
+	case V4L2_FIELD_INTERLACED_BT:
+		vnmc = VNMC_IM_FULL | VNMC_FOC;
+		break;
+	case V4L2_FIELD_NONE:
+		if (is_continuous_transfer(vin)) {
+			vnmc = VNMC_IM_ODD_EVEN;
+			progressive = true;
+		} else {
+			vnmc = VNMC_IM_ODD;
+		}
+		break;
+	default:
+		vnmc = VNMC_IM_ODD;
+		break;
+	}
+
+	/*
+	 * Input interface
+	 */
+	switch (vin->fmtinfo->code) {
+	case MEDIA_BUS_FMT_YUYV8_1X16:
+		/* BT.601/BT.1358 16bit YCbCr422 */
+		vnmc |= VNMC_INF_YUV16;
+		input_is_yuv = true;
+		break;
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
+		vnmc |= vin->pdata_flags & RVIN_BT656 ?
+			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
+		input_is_yuv = true;
+		break;
+	case MEDIA_BUS_FMT_RGB888_1X24:
+		vnmc |= VNMC_INF_RGB888;
+		break;
+	case MEDIA_BUS_FMT_YUYV10_2X10:
+		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
+		vnmc |= vin->pdata_flags & RVIN_BT656 ?
+			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
+		input_is_yuv = true;
+		break;
+	default:
+		break;
+	}
+
+	/* Enable VSYNC Field Toogle mode after one VSYNC input */
+	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
+
+	/* Hsync Signal Polarity Select */
+	if (!(vin->pdata_flags & RVIN_HSYNC_ACTIVE_LOW))
+		dmr2 |= VNDMR2_HPS;
+
+	/* Vsync Signal Polarity Select */
+	if (!(vin->pdata_flags & RVIN_VSYNC_ACTIVE_LOW))
+		dmr2 |= VNDMR2_VPS;
+
+	rvin_write(vin, dmr2, VNDMR2_REG);
+
+	/*
+	 * Output format
+	 */
+	switch (vin->fmtinfo->fourcc) {
+	case V4L2_PIX_FMT_NV16:
+		rvin_write(vin,
+			ALIGN(vin->format.width * vin->format.height, 0x80),
+			VNUVAOF_REG);
+		dmr = VNDMR_DTMD_YCSEP;
+		output_is_yuv = true;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		dmr = VNDMR_BPSM;
+		output_is_yuv = true;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		dmr = 0;
+		output_is_yuv = true;
+		break;
+	case V4L2_PIX_FMT_RGB555X:
+		dmr = VNDMR_DTMD_ARGB1555;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		dmr = 0;
+		break;
+	case V4L2_PIX_FMT_RGB32:
+		if (vin->chip == RCAR_GEN2 || vin->chip == RCAR_H1 ||
+				vin->chip == RCAR_E1) {
+			dmr = VNDMR_EXRGB;
+			break;
+		}
+	default:
+		vin_warn(vin, "Invalid fourcc format (0x%x)\n",
+				vin->fmtinfo->fourcc);
+		return -EINVAL;
+	}
+
+	/* Always update on field change */
+	vnmc |= VNMC_VUP;
+
+	/* If input and output use the same colorspace, use bypass mode */
+	if (input_is_yuv == output_is_yuv)
+		vnmc |= VNMC_BPS;
+
+	/* Progressive or interlaced mode */
+	interrupts = progressive ? VNIE_FIE : VNIE_EFE;
+
+	/* Ack interrupts */
+	rvin_write(vin, interrupts, VNINTS_REG);
+	/* Enable interrupts */
+	rvin_write(vin, interrupts, VNIE_REG);
+	/* Start capturing */
+	rvin_write(vin, dmr, VNDMR_REG);
+	rvin_write(vin, vnmc | VNMC_ME, VNMC_REG);
+
+	return 0;
+}
+
+void rvin_capture(struct rvin_dev *vin)
+{
+	if (is_continuous_transfer(vin))
+		/* Continuous Frame Capture Mode */
+		rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
+	else
+		/* Single Frame Capture Mode */
+		rvin_write(vin, VNFC_S_FRAME, VNFC_REG);
+}
+
+void rvin_request_capture_stop(struct rvin_dev *vin)
+{
+	vin->state = STOPPING;
+
+	/* Set continuous & single transfer off */
+	rvin_write(vin, 0, VNFC_REG);
+	/* Disable capture (release DMA buffer), reset */
+	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
+
+	/* Update the status if stopped already */
+	if (!(rvin_read(vin, VNMS_REG) & VNMS_CA))
+		vin->state = STOPPED;
+}
+
+void rvin_disable_interrupts(struct rvin_dev *vin)
+{
+	rvin_write(vin, 0, VNIE_REG);
+}
+
+void rvin_disable_capture(struct rvin_dev *vin)
+{
+	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME,
+			VNMC_REG);
+}
+
+u32 rvin_get_interrupt_status(struct rvin_dev *vin)
+{
+	return rvin_read(vin, VNINTS_REG);
+}
+
+void rvin_ack_interrupt(struct rvin_dev *vin)
+{
+	rvin_write(vin, rvin_read(vin, VNINTS_REG), VNINTS_REG);
+}
+
+bool rvin_capture_active(struct rvin_dev *vin)
+{
+	return rvin_read(vin, VNMS_REG) & VNMS_CA;
+}
+
+/* -----------------------------------------------------------------------------
+ * Format Convertions
+ */
+
+static const struct rvin_video_format rvin_formats_conv[] = {
+
+	{
+		.code			= 0,
+		.fourcc                 = V4L2_PIX_FMT_NV16,
+		.name                   = "NV16",
+		.bits_per_sample        = 8,
+		.packing                = RVIN_MBUS_PACKING_2X8_PADHI,
+	},
+	{
+		.code			= 0,
+		.fourcc                 = V4L2_PIX_FMT_YUYV,
+		.name                   = "YUYV",
+		.bits_per_sample        = 16,
+		.packing                = RVIN_MBUS_PACKING_NONE,
+	},
+	{
+		.code			= 0,
+		.fourcc                 = V4L2_PIX_FMT_UYVY,
+		.name                   = "UYVY",
+		.bits_per_sample        = 16,
+		.packing                = RVIN_MBUS_PACKING_NONE,
+	},
+	{
+		.code			= 0,
+		.fourcc                 = V4L2_PIX_FMT_RGB565,
+		.name                   = "RGB565",
+		.bits_per_sample        = 16,
+		.packing                = RVIN_MBUS_PACKING_NONE,
+	},
+	{
+		.code			= 0,
+		.fourcc                 = V4L2_PIX_FMT_RGB555X,
+		.name                   = "ARGB1555",
+		.bits_per_sample        = 16,
+		.packing                = RVIN_MBUS_PACKING_NONE,
+	},
+	{
+		.code			= 0,
+		.fourcc                 = V4L2_PIX_FMT_RGB32,
+		.name                   = "RGB888",
+		.bits_per_sample        = 32,
+		.packing                = RVIN_MBUS_PACKING_NONE,
+	},
+};
+
+static const struct rvin_video_format rvin_formats_pass[] = {
+	{
+		.code = MEDIA_BUS_FMT_YVYU8_2X8,
+		.fourcc			= V4L2_PIX_FMT_YVYU,
+		.name			= "YVYU",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADHI,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_UYVY8_2X8,
+		.fourcc			= V4L2_PIX_FMT_UYVY,
+		.name			= "UYVY",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADHI,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_VYUY8_2X8,
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.name			= "VYUY",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADHI,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
+		.fourcc			= V4L2_PIX_FMT_RGB555,
+		.name			= "RGB555",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADHI,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE,
+		.fourcc			= V4L2_PIX_FMT_RGB555X,
+		.name			= "RGB555X",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADHI,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_RGB565_2X8_LE,
+		.fourcc			= V4L2_PIX_FMT_RGB565,
+		.name			= "RGB565",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADHI,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_RGB565_2X8_BE,
+		.fourcc			= V4L2_PIX_FMT_RGB565X,
+		.name			= "RGB565X",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADHI,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_RGB666_1X18,
+		.fourcc			= V4L2_PIX_FMT_RGB32,
+		.name			= "RGB666/32bpp",
+		.bits_per_sample	= 18,
+		.packing		= RVIN_MBUS_PACKING_EXTEND32,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_RGB888_2X12_BE,
+		.fourcc			= V4L2_PIX_FMT_RGB32,
+		.name			= "RGB888/32bpp",
+		.bits_per_sample	= 12,
+		.packing		= RVIN_MBUS_PACKING_EXTEND32,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_RGB888_2X12_LE,
+		.fourcc			= V4L2_PIX_FMT_RGB32,
+		.name			= "RGB888/32bpp",
+		.bits_per_sample	= 12,
+		.packing		= RVIN_MBUS_PACKING_EXTEND32,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SBGGR8_1X8,
+		.fourcc			= V4L2_PIX_FMT_SBGGR8,
+		.name			= "Bayer 8 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_NONE,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SBGGR10_1X10,
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 10,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_Y8_1X8,
+		.fourcc			= V4L2_PIX_FMT_GREY,
+		.name			= "Grey",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_NONE,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_Y10_1X10,
+		.fourcc			= V4L2_PIX_FMT_Y10,
+		.name			= "Grey 10bit",
+		.bits_per_sample	= 10,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE,
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADHI,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE,
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADLO,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE,
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADHI,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE,
+		.fourcc			= V4L2_PIX_FMT_SBGGR10,
+		.name			= "Bayer 10 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADLO,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_JPEG_1X8,
+		.fourcc                 = V4L2_PIX_FMT_JPEG,
+		.name                   = "JPEG",
+		.bits_per_sample        = 8,
+		.packing                = RVIN_MBUS_PACKING_VARIABLE,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE,
+		.fourcc			= V4L2_PIX_FMT_RGB444,
+		.name			= "RGB444",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_2X8_PADHI,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_YUYV8_1_5X8,
+		.fourcc			= V4L2_PIX_FMT_YUV420,
+		.name			= "YUYV 4:2:0",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_1_5X8,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_YVYU8_1_5X8,
+		.fourcc			= V4L2_PIX_FMT_YVU420,
+		.name			= "YVYU 4:2:0",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_1_5X8,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_UYVY8_1X16,
+		.fourcc			= V4L2_PIX_FMT_UYVY,
+		.name			= "UYVY 16bit",
+		.bits_per_sample	= 16,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_VYUY8_1X16,
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.name			= "VYUY 16bit",
+		.bits_per_sample	= 16,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_YVYU8_1X16,
+		.fourcc			= V4L2_PIX_FMT_YVYU,
+		.name			= "YVYU 16bit",
+		.bits_per_sample	= 16,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SGRBG8_1X8,
+		.fourcc			= V4L2_PIX_FMT_SGRBG8,
+		.name			= "Bayer 8 GRBG",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_NONE,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
+		.fourcc			= V4L2_PIX_FMT_SGRBG10DPCM8,
+		.name			= "Bayer 10 BGGR DPCM 8",
+		.bits_per_sample	= 8,
+		.packing		= RVIN_MBUS_PACKING_NONE,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SGBRG10_1X10,
+		.fourcc			= V4L2_PIX_FMT_SGBRG10,
+		.name			= "Bayer 10 GBRG",
+		.bits_per_sample	= 10,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SGRBG10_1X10,
+		.fourcc			= V4L2_PIX_FMT_SGRBG10,
+		.name			= "Bayer 10 GRBG",
+		.bits_per_sample	= 10,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SRGGB10_1X10,
+		.fourcc			= V4L2_PIX_FMT_SRGGB10,
+		.name			= "Bayer 10 RGGB",
+		.bits_per_sample	= 10,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SBGGR12_1X12,
+		.fourcc			= V4L2_PIX_FMT_SBGGR12,
+		.name			= "Bayer 12 BGGR",
+		.bits_per_sample	= 12,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SGBRG12_1X12,
+		.fourcc			= V4L2_PIX_FMT_SGBRG12,
+		.name			= "Bayer 12 GBRG",
+		.bits_per_sample	= 12,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SGRBG12_1X12,
+		.fourcc			= V4L2_PIX_FMT_SGRBG12,
+		.name			= "Bayer 12 GRBG",
+		.bits_per_sample	= 12,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+	{
+		.code			= MEDIA_BUS_FMT_SRGGB12_1X12,
+		.fourcc			= V4L2_PIX_FMT_SRGGB12,
+		.name			= "Bayer 12 RGGB",
+		.bits_per_sample	= 12,
+		.packing		= RVIN_MBUS_PACKING_EXTEND16,
+	},
+};
+
+static bool rvin_packing_supported(const struct rvin_video_format *fmt)
+{
+	return  fmt->packing == RVIN_MBUS_PACKING_NONE ||
+		(fmt->bits_per_sample > 8 &&
+		 fmt->packing == RVIN_MBUS_PACKING_EXTEND16);
+}
+
+static int rvin_add_formats(struct rvin_dev *vin, u32 code, bool *conv_done,
+		struct rvin_video_format *fmts)
+{
+	const struct rvin_video_format *fmt;
+	int i;
+
+	switch (code) {
+	default:
+		break;
+	case MEDIA_BUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV10_2X10:
+	case MEDIA_BUS_FMT_RGB888_1X24:
+		/* Add dynamic formats, once */
+		if (*conv_done)
+			return 0;
+		*conv_done = true;
+
+		if (fmts) {
+			for (i = 0; i < ARRAY_SIZE(rvin_formats_conv); i++) {
+				memcpy(fmts, &rvin_formats_conv[i],
+						sizeof(*fmts));
+				fmts->code = code;
+				vin_dbg(vin,
+						"Providing format %s using code %d\n",
+						fmts->name, code);
+				fmts++;
+			}
+		}
+		return ARRAY_SIZE(rvin_formats_conv);
+	}
+
+	fmt = NULL;
+	for (i = 0; i < ARRAY_SIZE(rvin_formats_pass); i++)
+		if (rvin_formats_pass[i].code == code)
+			fmt = &rvin_formats_pass[i];
+
+	if (!fmt) {
+		vin_warn(vin, "Unsupported format code: %d\n", code);
+		return 0;
+	}
+
+	if (!rvin_packing_supported(fmt))
+		return 0;
+
+	if (fmts) {
+		memcpy(fmts, fmt, sizeof(*fmts));
+		vin_dbg(vin, "Providing format %s in pass-through mode\n",
+				fmts->name);
+		fmts++;
+	}
+	return 1;
+}
+
+static int rvin_init_formats(struct rvin_dev *vin)
+{
+	struct v4l2_subdev *sd;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	bool conv_done;
+	int numfmts;
+
+	sd = vin_to_sd(vin);
+
+	/* First pass - Count formats this sensor configuration can provide */
+	code.index = 0;
+	conv_done = false;
+	numfmts = 0;
+	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
+		code.index++;
+		numfmts += rvin_add_formats(vin, code.code, &conv_done, NULL);
+	}
+
+	if (!numfmts)
+		return -ENXIO;
+
+	vin->sensor.formats = vmalloc(numfmts *
+			sizeof(struct rvin_video_format));
+	if (!vin->sensor.formats)
+		return -ENOMEM;
+
+	vin->sensor.num_formats = numfmts;
+	vin_dbg(vin, "Found %d supported formats.\n", vin->sensor.num_formats);
+
+
+	/* Second pass - Actually fill data formats */
+	code.index = 0;
+	conv_done = false;
+	numfmts = 0;
+	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
+		code.index++;
+		numfmts += rvin_add_formats(vin, code.code, &conv_done,
+				&vin->sensor.formats[numfmts]);
+	}
+
+	return 0;
+}
+
+static void rvin_free_formats(struct rvin_dev *vin)
+{
+	if (vin->sensor.formats) {
+		vin->sensor.num_formats = 0;
+		vfree(vin->sensor.formats);
+	}
+}
+
+const struct rvin_video_format *rvin_get_format_by_fourcc(struct rvin_dev *vin,
+		u32 fourcc)
+{
+	unsigned int i;
+
+	for (i = 0; i < vin->sensor.num_formats; i++) {
+		if (vin->sensor.formats[i].fourcc == fourcc)
+			return vin->sensor.formats + i;
+	}
+	return NULL;
+}
+
+s32 rvin_bytes_per_line(const struct rvin_video_format *info, u32 width)
+{
+	if (info->fourcc == V4L2_PIX_FMT_NV16)
+		return width * info->bits_per_sample / 8;
+
+	switch (info->packing) {
+	case RVIN_MBUS_PACKING_NONE:
+		return width * info->bits_per_sample / 8;
+	case RVIN_MBUS_PACKING_2X8_PADHI:
+	case RVIN_MBUS_PACKING_2X8_PADLO:
+	case RVIN_MBUS_PACKING_EXTEND16:
+		return width * 2;
+	case RVIN_MBUS_PACKING_1_5X8:
+		return width * 3 / 2;
+	case RVIN_MBUS_PACKING_VARIABLE:
+		return 0;
+	case RVIN_MBUS_PACKING_EXTEND32:
+		return width * 4;
+	}
+	return -EINVAL;
+}
+
+s32 rvin_image_size(const struct rvin_video_format *info, u32 bytes_per_line,
+		u32 height)
+{
+	if (info->fourcc != V4L2_PIX_FMT_NV16)
+		return bytes_per_line * height;
+
+	switch (info->packing) {
+	case RVIN_MBUS_PACKING_2X8_PADHI:
+	case RVIN_MBUS_PACKING_2X8_PADLO:
+		return bytes_per_line * height * 2;
+	case RVIN_MBUS_PACKING_1_5X8:
+		return bytes_per_line * height * 3 / 2;
+	default:
+		return -EINVAL;
+	}
+}
+
+/* -----------------------------------------------------------------------------
+ * Crop and Scaling Gen2
+ */
+
+struct vin_coeff {
+	unsigned short xs_value;
+	u32 coeff_set[24];
+};
+
+static const struct vin_coeff vin_coeff_set[] = {
+	{ 0x0000, {
+			  0x00000000, 0x00000000, 0x00000000,
+			  0x00000000, 0x00000000, 0x00000000,
+			  0x00000000, 0x00000000, 0x00000000,
+			  0x00000000, 0x00000000, 0x00000000,
+			  0x00000000, 0x00000000, 0x00000000,
+			  0x00000000, 0x00000000, 0x00000000,
+			  0x00000000, 0x00000000, 0x00000000,
+			  0x00000000, 0x00000000, 0x00000000 },
+	},
+	{ 0x1000, {
+			  0x000fa400, 0x000fa400, 0x09625902,
+			  0x000003f8, 0x00000403, 0x3de0d9f0,
+			  0x001fffed, 0x00000804, 0x3cc1f9c3,
+			  0x001003de, 0x00000c01, 0x3cb34d7f,
+			  0x002003d2, 0x00000c00, 0x3d24a92d,
+			  0x00200bca, 0x00000bff, 0x3df600d2,
+			  0x002013cc, 0x000007ff, 0x3ed70c7e,
+			  0x00100fde, 0x00000000, 0x3f87c036 },
+	},
+	{ 0x1200, {
+			  0x002ffff1, 0x002ffff1, 0x02a0a9c8,
+			  0x002003e7, 0x001ffffa, 0x000185bc,
+			  0x002007dc, 0x000003ff, 0x3e52859c,
+			  0x00200bd4, 0x00000002, 0x3d53996b,
+			  0x00100fd0, 0x00000403, 0x3d04ad2d,
+			  0x00000bd5, 0x00000403, 0x3d35ace7,
+			  0x3ff003e4, 0x00000801, 0x3dc674a1,
+			  0x3fffe800, 0x00000800, 0x3e76f461 },
+	},
+	{ 0x1400, {
+			  0x00100be3, 0x00100be3, 0x04d1359a,
+			  0x00000fdb, 0x002003ed, 0x0211fd93,
+			  0x00000fd6, 0x002003f4, 0x0002d97b,
+			  0x000007d6, 0x002ffffb, 0x3e93b956,
+			  0x3ff003da, 0x001003ff, 0x3db49926,
+			  0x3fffefe9, 0x00100001, 0x3d655cee,
+			  0x3fffd400, 0x00000003, 0x3d65f4b6,
+			  0x000fb421, 0x00000402, 0x3dc6547e },
+	},
+	{ 0x1600, {
+			  0x00000bdd, 0x00000bdd, 0x06519578,
+			  0x3ff007da, 0x00000be3, 0x03c24973,
+			  0x3ff003d9, 0x00000be9, 0x01b30d5f,
+			  0x3ffff7df, 0x001003f1, 0x0003c542,
+			  0x000fdfec, 0x001003f7, 0x3ec4711d,
+			  0x000fc400, 0x002ffffd, 0x3df504f1,
+			  0x001fa81a, 0x002ffc00, 0x3d957cc2,
+			  0x002f8c3c, 0x00100000, 0x3db5c891 },
+	},
+	{ 0x1800, {
+			  0x3ff003dc, 0x3ff003dc, 0x0791e558,
+			  0x000ff7dd, 0x3ff007de, 0x05328554,
+			  0x000fe7e3, 0x3ff00be2, 0x03232546,
+			  0x000fd7ee, 0x000007e9, 0x0143bd30,
+			  0x001fb800, 0x000007ee, 0x00044511,
+			  0x002fa015, 0x000007f4, 0x3ef4bcee,
+			  0x002f8832, 0x001003f9, 0x3e4514c7,
+			  0x001f7853, 0x001003fd, 0x3de54c9f },
+	},
+	{ 0x1a00, {
+			  0x000fefe0, 0x000fefe0, 0x08721d3c,
+			  0x001fdbe7, 0x000ffbde, 0x0652a139,
+			  0x001fcbf0, 0x000003df, 0x0463292e,
+			  0x002fb3ff, 0x3ff007e3, 0x0293a91d,
+			  0x002f9c12, 0x3ff00be7, 0x01241905,
+			  0x001f8c29, 0x000007ed, 0x3fe470eb,
+			  0x000f7c46, 0x000007f2, 0x3f04b8ca,
+			  0x3fef7865, 0x000007f6, 0x3e74e4a8 },
+	},
+	{ 0x1c00, {
+			  0x001fd3e9, 0x001fd3e9, 0x08f23d26,
+			  0x002fbff3, 0x001fe3e4, 0x0712ad23,
+			  0x002fa800, 0x000ff3e0, 0x05631d1b,
+			  0x001f9810, 0x000ffbe1, 0x03b3890d,
+			  0x000f8c23, 0x000003e3, 0x0233e8fa,
+			  0x3fef843b, 0x000003e7, 0x00f430e4,
+			  0x3fbf8456, 0x3ff00bea, 0x00046cc8,
+			  0x3f8f8c72, 0x3ff00bef, 0x3f3490ac },
+	},
+	{ 0x1e00, {
+			  0x001fbbf4, 0x001fbbf4, 0x09425112,
+			  0x001fa800, 0x002fc7ed, 0x0792b110,
+			  0x000f980e, 0x001fdbe6, 0x0613110a,
+			  0x3fff8c20, 0x001fe7e3, 0x04a368fd,
+			  0x3fcf8c33, 0x000ff7e2, 0x0343b8ed,
+			  0x3f9f8c4a, 0x000fffe3, 0x0203f8da,
+			  0x3f5f9c61, 0x000003e6, 0x00e428c5,
+			  0x3f1fb07b, 0x000003eb, 0x3fe440af },
+	},
+	{ 0x2000, {
+			  0x000fa400, 0x000fa400, 0x09625902,
+			  0x3fff980c, 0x001fb7f5, 0x0812b0ff,
+			  0x3fdf901c, 0x001fc7ed, 0x06b2fcfa,
+			  0x3faf902d, 0x001fd3e8, 0x055348f1,
+			  0x3f7f983f, 0x001fe3e5, 0x04038ce3,
+			  0x3f3fa454, 0x001fefe3, 0x02e3c8d1,
+			  0x3f0fb86a, 0x001ff7e4, 0x01c3e8c0,
+			  0x3ecfd880, 0x000fffe6, 0x00c404ac },
+	},
+	{ 0x2200, {
+			  0x3fdf9c0b, 0x3fdf9c0b, 0x09725cf4,
+			  0x3fbf9818, 0x3fffa400, 0x0842a8f1,
+			  0x3f8f9827, 0x000fb3f7, 0x0702f0ec,
+			  0x3f5fa037, 0x000fc3ef, 0x05d330e4,
+			  0x3f2fac49, 0x001fcfea, 0x04a364d9,
+			  0x3effc05c, 0x001fdbe7, 0x038394ca,
+			  0x3ecfdc6f, 0x001fe7e6, 0x0273b0bb,
+			  0x3ea00083, 0x001fefe6, 0x0183c0a9 },
+	},
+	{ 0x2400, {
+			  0x3f9fa014, 0x3f9fa014, 0x098260e6,
+			  0x3f7f9c23, 0x3fcf9c0a, 0x08629ce5,
+			  0x3f4fa431, 0x3fefa400, 0x0742d8e1,
+			  0x3f1fb440, 0x3fffb3f8, 0x062310d9,
+			  0x3eefc850, 0x000fbbf2, 0x050340d0,
+			  0x3ecfe062, 0x000fcbec, 0x041364c2,
+			  0x3ea00073, 0x001fd3ea, 0x03037cb5,
+			  0x3e902086, 0x001fdfe8, 0x022388a5 },
+	},
+	{ 0x2600, {
+			  0x3f5fa81e, 0x3f5fa81e, 0x096258da,
+			  0x3f3fac2b, 0x3f8fa412, 0x088290d8,
+			  0x3f0fbc38, 0x3fafa408, 0x0772c8d5,
+			  0x3eefcc47, 0x3fcfa800, 0x0672f4ce,
+			  0x3ecfe456, 0x3fefaffa, 0x05531cc6,
+			  0x3eb00066, 0x3fffbbf3, 0x047334bb,
+			  0x3ea01c77, 0x000fc7ee, 0x039348ae,
+			  0x3ea04486, 0x000fd3eb, 0x02b350a1 },
+	},
+	{ 0x2800, {
+			  0x3f2fb426, 0x3f2fb426, 0x094250ce,
+			  0x3f0fc032, 0x3f4fac1b, 0x086284cd,
+			  0x3eefd040, 0x3f7fa811, 0x0782acc9,
+			  0x3ecfe84c, 0x3f9fa807, 0x06a2d8c4,
+			  0x3eb0005b, 0x3fbfac00, 0x05b2f4bc,
+			  0x3eb0186a, 0x3fdfb3fa, 0x04c308b4,
+			  0x3eb04077, 0x3fefbbf4, 0x03f31ca8,
+			  0x3ec06884, 0x000fbff2, 0x03031c9e },
+	},
+	{ 0x2a00, {
+			  0x3f0fc42d, 0x3f0fc42d, 0x090240c4,
+			  0x3eefd439, 0x3f2fb822, 0x08526cc2,
+			  0x3edfe845, 0x3f4fb018, 0x078294bf,
+			  0x3ec00051, 0x3f6fac0f, 0x06b2b4bb,
+			  0x3ec0185f, 0x3f8fac07, 0x05e2ccb4,
+			  0x3ec0386b, 0x3fafac00, 0x0502e8ac,
+			  0x3ed05c77, 0x3fcfb3fb, 0x0432f0a3,
+			  0x3ef08482, 0x3fdfbbf6, 0x0372f898 },
+	},
+	{ 0x2c00, {
+			  0x3eefdc31, 0x3eefdc31, 0x08e238b8,
+			  0x3edfec3d, 0x3f0fc828, 0x082258b9,
+			  0x3ed00049, 0x3f1fc01e, 0x077278b6,
+			  0x3ed01455, 0x3f3fb815, 0x06c294b2,
+			  0x3ed03460, 0x3f5fb40d, 0x0602acac,
+			  0x3ef0506c, 0x3f7fb006, 0x0542c0a4,
+			  0x3f107476, 0x3f9fb400, 0x0472c89d,
+			  0x3f309c80, 0x3fbfb7fc, 0x03b2cc94 },
+	},
+	{ 0x2e00, {
+			  0x3eefec37, 0x3eefec37, 0x088220b0,
+			  0x3ee00041, 0x3effdc2d, 0x07f244ae,
+			  0x3ee0144c, 0x3f0fd023, 0x07625cad,
+			  0x3ef02c57, 0x3f1fc81a, 0x06c274a9,
+			  0x3f004861, 0x3f3fbc13, 0x060288a6,
+			  0x3f20686b, 0x3f5fb80c, 0x05529c9e,
+			  0x3f408c74, 0x3f6fb805, 0x04b2ac96,
+			  0x3f80ac7e, 0x3f8fb800, 0x0402ac8e },
+	},
+	{ 0x3000, {
+			  0x3ef0003a, 0x3ef0003a, 0x084210a6,
+			  0x3ef01045, 0x3effec32, 0x07b228a7,
+			  0x3f00284e, 0x3f0fdc29, 0x073244a4,
+			  0x3f104058, 0x3f0fd420, 0x06a258a2,
+			  0x3f305c62, 0x3f2fc818, 0x0612689d,
+			  0x3f508069, 0x3f3fc011, 0x05728496,
+			  0x3f80a072, 0x3f4fc00a, 0x04d28c90,
+			  0x3fc0c07b, 0x3f6fbc04, 0x04429088 },
+	},
+	{ 0x3200, {
+			  0x3f00103e, 0x3f00103e, 0x07f1fc9e,
+			  0x3f102447, 0x3f000035, 0x0782149d,
+			  0x3f203c4f, 0x3f0ff02c, 0x07122c9c,
+			  0x3f405458, 0x3f0fe424, 0x06924099,
+			  0x3f607061, 0x3f1fd41d, 0x06024c97,
+			  0x3f909068, 0x3f2fcc16, 0x05726490,
+			  0x3fc0b070, 0x3f3fc80f, 0x04f26c8a,
+			  0x0000d077, 0x3f4fc409, 0x04627484 },
+	},
+	{ 0x3400, {
+			  0x3f202040, 0x3f202040, 0x07a1e898,
+			  0x3f303449, 0x3f100c38, 0x0741fc98,
+			  0x3f504c50, 0x3f10002f, 0x06e21495,
+			  0x3f706459, 0x3f1ff028, 0x06722492,
+			  0x3fa08060, 0x3f1fe421, 0x05f2348f,
+			  0x3fd09c67, 0x3f1fdc19, 0x05824c89,
+			  0x0000bc6e, 0x3f2fd014, 0x04f25086,
+			  0x0040dc74, 0x3f3fcc0d, 0x04825c7f },
+	},
+	{ 0x3600, {
+			  0x3f403042, 0x3f403042, 0x0761d890,
+			  0x3f504848, 0x3f301c3b, 0x0701f090,
+			  0x3f805c50, 0x3f200c33, 0x06a2008f,
+			  0x3fa07458, 0x3f10002b, 0x06520c8d,
+			  0x3fd0905e, 0x3f1ff424, 0x05e22089,
+			  0x0000ac65, 0x3f1fe81d, 0x05823483,
+			  0x0030cc6a, 0x3f2fdc18, 0x04f23c81,
+			  0x0080e871, 0x3f2fd412, 0x0482407c },
+	},
+	{ 0x3800, {
+			  0x3f604043, 0x3f604043, 0x0721c88a,
+			  0x3f80544a, 0x3f502c3c, 0x06d1d88a,
+			  0x3fb06851, 0x3f301c35, 0x0681e889,
+			  0x3fd08456, 0x3f30082f, 0x0611fc88,
+			  0x00009c5d, 0x3f200027, 0x05d20884,
+			  0x0030b863, 0x3f2ff421, 0x05621880,
+			  0x0070d468, 0x3f2fe81b, 0x0502247c,
+			  0x00c0ec6f, 0x3f2fe015, 0x04a22877 },
+	},
+	{ 0x3a00, {
+			  0x3f904c44, 0x3f904c44, 0x06e1b884,
+			  0x3fb0604a, 0x3f70383e, 0x0691c885,
+			  0x3fe07451, 0x3f502c36, 0x0661d483,
+			  0x00009055, 0x3f401831, 0x0601ec81,
+			  0x0030a85b, 0x3f300c2a, 0x05b1f480,
+			  0x0070c061, 0x3f300024, 0x0562047a,
+			  0x00b0d867, 0x3f3ff41e, 0x05020c77,
+			  0x00f0f46b, 0x3f2fec19, 0x04a21474 },
+	},
+	{ 0x3c00, {
+			  0x3fb05c43, 0x3fb05c43, 0x06c1b07e,
+			  0x3fe06c4b, 0x3f902c3f, 0x0681c081,
+			  0x0000844f, 0x3f703838, 0x0631cc7d,
+			  0x00309855, 0x3f602433, 0x05d1d47e,
+			  0x0060b459, 0x3f50142e, 0x0581e47b,
+			  0x00a0c85f, 0x3f400828, 0x0531f078,
+			  0x00e0e064, 0x3f300021, 0x0501fc73,
+			  0x00b0fc6a, 0x3f3ff41d, 0x04a20873 },
+	},
+	{ 0x3e00, {
+			  0x3fe06444, 0x3fe06444, 0x0681a07a,
+			  0x00007849, 0x3fc0503f, 0x0641b07a,
+			  0x0020904d, 0x3fa0403a, 0x05f1c07a,
+			  0x0060a453, 0x3f803034, 0x05c1c878,
+			  0x0090b858, 0x3f70202f, 0x0571d477,
+			  0x00d0d05d, 0x3f501829, 0x0531e073,
+			  0x0110e462, 0x3f500825, 0x04e1e471,
+			  0x01510065, 0x3f40001f, 0x04a1f06d },
+	},
+	{ 0x4000, {
+			  0x00007044, 0x00007044, 0x06519476,
+			  0x00208448, 0x3fe05c3f, 0x0621a476,
+			  0x0050984d, 0x3fc04c3a, 0x05e1b075,
+			  0x0080ac52, 0x3fa03c35, 0x05a1b875,
+			  0x00c0c056, 0x3f803030, 0x0561c473,
+			  0x0100d45b, 0x3f70202b, 0x0521d46f,
+			  0x0140e860, 0x3f601427, 0x04d1d46e,
+			  0x01810064, 0x3f500822, 0x0491dc6b },
+	},
+	{ 0x5000, {
+			  0x0110a442, 0x0110a442, 0x0551545e,
+			  0x0140b045, 0x00e0983f, 0x0531585f,
+			  0x0160c047, 0x00c08c3c, 0x0511645e,
+			  0x0190cc4a, 0x00908039, 0x04f1685f,
+			  0x01c0dc4c, 0x00707436, 0x04d1705e,
+			  0x0200e850, 0x00506833, 0x04b1785b,
+			  0x0230f453, 0x00305c30, 0x0491805a,
+			  0x02710056, 0x0010542d, 0x04718059 },
+	},
+	{ 0x6000, {
+			  0x01c0bc40, 0x01c0bc40, 0x04c13052,
+			  0x01e0c841, 0x01a0b43d, 0x04c13851,
+			  0x0210cc44, 0x0180a83c, 0x04a13453,
+			  0x0230d845, 0x0160a03a, 0x04913c52,
+			  0x0260e047, 0x01409838, 0x04714052,
+			  0x0280ec49, 0x01208c37, 0x04514c50,
+			  0x02b0f44b, 0x01008435, 0x04414c50,
+			  0x02d1004c, 0x00e07c33, 0x0431544f },
+	},
+	{ 0x7000, {
+			  0x0230c83e, 0x0230c83e, 0x04711c4c,
+			  0x0250d03f, 0x0210c43c, 0x0471204b,
+			  0x0270d840, 0x0200b83c, 0x0451244b,
+			  0x0290dc42, 0x01e0b43a, 0x0441244c,
+			  0x02b0e443, 0x01c0b038, 0x0441284b,
+			  0x02d0ec44, 0x01b0a438, 0x0421304a,
+			  0x02f0f445, 0x0190a036, 0x04213449,
+			  0x0310f847, 0x01709c34, 0x04213848 },
+	},
+	{ 0x8000, {
+			  0x0280d03d, 0x0280d03d, 0x04310c48,
+			  0x02a0d43e, 0x0270c83c, 0x04311047,
+			  0x02b0dc3e, 0x0250c83a, 0x04311447,
+			  0x02d0e040, 0x0240c03a, 0x04211446,
+			  0x02e0e840, 0x0220bc39, 0x04111847,
+			  0x0300e842, 0x0210b438, 0x04012445,
+			  0x0310f043, 0x0200b037, 0x04012045,
+			  0x0330f444, 0x01e0ac36, 0x03f12445 },
+	},
+	{ 0xefff, {
+			  0x0340dc3a, 0x0340dc3a, 0x03b0ec40,
+			  0x0340e03a, 0x0330e039, 0x03c0f03e,
+			  0x0350e03b, 0x0330dc39, 0x03c0ec3e,
+			  0x0350e43a, 0x0320dc38, 0x03c0f43e,
+			  0x0360e43b, 0x0320d839, 0x03b0f03e,
+			  0x0360e83b, 0x0310d838, 0x03c0fc3b,
+			  0x0370e83b, 0x0310d439, 0x03a0f83d,
+			  0x0370e83c, 0x0300d438, 0x03b0fc3c },
+	}
+};
+
+static void rvin_set_coeff(struct rvin_dev *vin, unsigned short xs)
+{
+	int i;
+	const struct vin_coeff *p_prev_set = NULL;
+	const struct vin_coeff *p_set = NULL;
+
+	/* Look for suitable coefficient values */
+	for (i = 0; i < ARRAY_SIZE(vin_coeff_set); i++) {
+		p_prev_set = p_set;
+		p_set = &vin_coeff_set[i];
+
+		if (xs < p_set->xs_value)
+			break;
+	}
+
+	/* Use previous value if its XS value is closer */
+	if (p_prev_set && p_set &&
+			xs - p_prev_set->xs_value < p_set->xs_value - xs)
+		p_set = p_prev_set;
+
+	/* Set coefficient registers */
+	rvin_write(vin, p_set->coeff_set[0], VNC1A_REG);
+	rvin_write(vin, p_set->coeff_set[1], VNC1B_REG);
+	rvin_write(vin, p_set->coeff_set[2], VNC1C_REG);
+
+	rvin_write(vin, p_set->coeff_set[3], VNC2A_REG);
+	rvin_write(vin, p_set->coeff_set[4], VNC2B_REG);
+	rvin_write(vin, p_set->coeff_set[5], VNC2C_REG);
+
+	rvin_write(vin, p_set->coeff_set[6], VNC3A_REG);
+	rvin_write(vin, p_set->coeff_set[7], VNC3B_REG);
+	rvin_write(vin, p_set->coeff_set[8], VNC3C_REG);
+
+	rvin_write(vin, p_set->coeff_set[9], VNC4A_REG);
+	rvin_write(vin, p_set->coeff_set[10], VNC4B_REG);
+	rvin_write(vin, p_set->coeff_set[11], VNC4C_REG);
+
+	rvin_write(vin, p_set->coeff_set[12], VNC5A_REG);
+	rvin_write(vin, p_set->coeff_set[13], VNC5B_REG);
+	rvin_write(vin, p_set->coeff_set[14], VNC5C_REG);
+
+	rvin_write(vin, p_set->coeff_set[15], VNC6A_REG);
+	rvin_write(vin, p_set->coeff_set[16], VNC6B_REG);
+	rvin_write(vin, p_set->coeff_set[17], VNC6C_REG);
+
+	rvin_write(vin, p_set->coeff_set[18], VNC7A_REG);
+	rvin_write(vin, p_set->coeff_set[19], VNC7B_REG);
+	rvin_write(vin, p_set->coeff_set[20], VNC7C_REG);
+
+	rvin_write(vin, p_set->coeff_set[21], VNC8A_REG);
+	rvin_write(vin, p_set->coeff_set[22], VNC8B_REG);
+	rvin_write(vin, p_set->coeff_set[23], VNC8C_REG);
+}
+
+int rvin_scale_setup(struct rvin_dev *vin)
+{
+	unsigned char dsize = 0;
+	u32 value;
+
+	/* Crop and scale*/
+	struct v4l2_rect crop;
+	/* TODO: This should be set in vidioc_s_selection and not be static */
+	crop.left = 0;
+	crop.top = 0;
+	crop.width = vin->sensor.width;
+	crop.height = vin->sensor.height;
+
+	if (vin->fmtinfo->fourcc == V4L2_PIX_FMT_RGB32 && vin->chip == RCAR_E1)
+		dsize = 1;
+
+	/* Set Start/End Pixel/Line Pre-Clip */
+	vin_dbg(vin, "Pre-Clip: %ux%u@%u:%u\n", crop.width, crop.height,
+			crop.left, crop.top);
+	rvin_write(vin, crop.left << dsize, VNSPPRC_REG);
+	rvin_write(vin, (crop.left + crop.width - 1) << dsize,
+			VNEPPRC_REG);
+	switch (vin->format.field) {
+	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+		rvin_write(vin, crop.top / 2, VNSLPRC_REG);
+		rvin_write(vin, (crop.top + crop.height) / 2 - 1,
+				VNELPRC_REG);
+		break;
+	default:
+		rvin_write(vin, crop.top, VNSLPRC_REG);
+		rvin_write(vin, crop.top + crop.height - 1,
+				VNELPRC_REG);
+		break;
+	}
+	/* Set scaling coefficient */
+	value = 0;
+	if (crop.height != vin->format.height)
+		value = (4096 * crop.height) / vin->format.height;
+	vin_dbg(vin, "YS Value: 0x%x\n", value);
+	rvin_write(vin, value, VNYS_REG);
+
+	value = 0;
+	if (crop.width != vin->format.width)
+		value = (4096 * crop.width) / vin->format.width;
+
+	/* Horizontal upscaling is up to double size */
+	if (value > 0 && value < 2048)
+		value = 2048;
+
+	vin_dbg(vin, "XS Value: 0x%x\n", value);
+	rvin_write(vin, value, VNXS_REG);
+
+	/* Horizontal upscaling is done out by scaling down from double size */
+	if (value < 4096)
+		value *= 2;
+
+	rvin_set_coeff(vin, value);
+
+	/* Set Start/End Pixel/Line Post-Clip */
+	vin_dbg(vin, "Post-Clip: %ux%u@%u:%u\n", vin->format.width,
+			vin->format.height, 0, 0);
+	rvin_write(vin, 0, VNSPPOC_REG);
+	rvin_write(vin, 0, VNSLPOC_REG);
+	rvin_write(vin, (vin->format.width - 1) << dsize, VNEPPOC_REG);
+	switch (vin->format.field) {
+	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+		rvin_write(vin, vin->format.height / 2 - 1, VNELPOC_REG);
+		break;
+	default:
+		rvin_write(vin, vin->format.height - 1, VNELPOC_REG);
+		break;
+	}
+
+	rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
+
+	return 0;
+}
+
+int rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
+		u32 width, u32 height)
+{
+	/* All VIN channels on Gen2 have scalers */
+	pix->width = width;
+	pix->height = height;
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * Async notifier
+ */
+
+static int rvin_graph_notify_complete(struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_subdev *sd;
+	struct rvin_dev *vin = notifier_to_vin(notifier);
+	int ret;
+
+	sd = vin_to_sd(vin);
+
+	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
+	if (ret < 0) {
+		vin_err(vin, "failed to register subdev nodes\n");
+		return ret;
+	}
+
+	/* Figure out what formats are supported */
+	ret = rvin_init_formats(vin);
+	if (ret < 0)
+		return ret;
+
+	ret = rvin_dma_on(vin);
+	if (ret)
+		rvin_free_formats(vin);
+
+	return ret;
+}
+
+static int rvin_graph_notify_bound(struct v4l2_async_notifier *notifier,
+		struct v4l2_subdev *subdev,
+		struct v4l2_async_subdev *asd)
+{
+	struct rvin_dev *vin = notifier_to_vin(notifier);
+
+	vin_dbg(vin, "subdev %s bound\n", subdev->name);
+
+	vin->entity.entity = &subdev->entity;
+	vin->entity.subdev = subdev;
+
+	return 0;
+}
+
+static int rvin_graph_parse(struct rvin_dev *vin,
+		struct device_node *node)
+{
+	struct device_node *remote;
+	struct device_node *ep = NULL;
+	struct device_node *next;
+	int ret = 0;
+
+	while (1) {
+		next = of_graph_get_next_endpoint(node, ep);
+		if (!next)
+			break;
+
+		of_node_put(ep);
+		ep = next;
+
+		remote = of_graph_get_remote_port_parent(ep);
+		if (!remote) {
+			ret = -EINVAL;
+			break;
+		}
+
+		/* Skip entities that we have already processed. */
+		if (remote == vin->dev->of_node) {
+			of_node_put(remote);
+			continue;
+		}
+
+		/* Remote node to connect */
+		if (!vin->entity.node) {
+			vin->entity.node = remote;
+			vin->entity.asd.match_type = V4L2_ASYNC_MATCH_OF;
+			vin->entity.asd.match.of.node = remote;
+			ret++;
+		}
+	}
+
+	of_node_put(ep);
+
+	return ret;
+}
+
+static int rvin_graph_init(struct rvin_dev *vin)
+{
+	struct v4l2_async_subdev **subdevs = NULL;
+	int ret;
+
+	/* Parse the graph to extract a list of subdevice DT nodes. */
+	ret = rvin_graph_parse(vin, vin->dev->of_node);
+	if (ret < 0) {
+		vin_err(vin, "Graph parsing failed\n");
+		goto done;
+	}
+
+	if (!ret) {
+		vin_err(vin, "No subdev found in graph\n");
+		goto done;
+	}
+
+	if (ret != 1) {
+		vin_err(vin, "More then one subdev found in graph\n");
+		goto done;
+	}
+
+	/* Register the subdevices notifier. */
+	subdevs = devm_kzalloc(vin->dev, sizeof(*subdevs), GFP_KERNEL);
+	if (subdevs == NULL) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	subdevs[0] = &vin->entity.asd;
+
+	vin->notifier.subdevs = subdevs;
+	vin->notifier.num_subdevs = 1;
+	vin->notifier.bound = rvin_graph_notify_bound;
+	vin->notifier.complete = rvin_graph_notify_complete;
+
+	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
+	if (ret < 0) {
+		vin_err(vin, "Notifier registration failed\n");
+		goto done;
+	}
+
+	ret = 0;
+
+done:
+	if (ret < 0) {
+		v4l2_async_notifier_unregister(&vin->notifier);
+		of_node_put(vin->entity.node);
+	}
+
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * Platform Device Driver
+ */
+
+static const struct of_device_id rvin_of_id_table[] = {
+	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
+	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, rvin_of_id_table);
+
+static int rvin_get_pdata_flags(struct device *dev, unsigned int *pdata_flags)
+{
+	struct v4l2_of_endpoint ep;
+	struct device_node *np;
+	unsigned int flags;
+	int ret;
+
+	np = of_graph_get_next_endpoint(dev->of_node, NULL);
+	if (!np) {
+		dev_err(dev, "Could not find endpoint\n");
+		return -EINVAL;
+	}
+
+	ret = v4l2_of_parse_endpoint(np, &ep);
+	if (ret) {
+		dev_err(dev, "Could not parse endpoint\n");
+		return ret;
+	}
+
+	if (ep.bus_type == V4L2_MBUS_BT656)
+		flags = RVIN_BT656;
+	else {
+		flags = 0;
+		if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+			flags |= RVIN_HSYNC_ACTIVE_LOW;
+		if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+			flags |= RVIN_VSYNC_ACTIVE_LOW;
+	}
+
+	of_node_put(np);
+
+	*pdata_flags = flags;
+
+	return 0;
+}
+
+static int rvin_init(struct rvin_dev *vin, struct platform_device *pdev)
+{
+	const struct of_device_id *match = NULL;
+	struct resource *mem;
+	int ret;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (mem == NULL)
+		return -EINVAL;
+
+	vin->dev = &pdev->dev;
+
+	match = of_match_device(of_match_ptr(rvin_of_id_table), vin->dev);
+	if (!match)
+		return -ENODEV;
+	vin->chip = (enum chip_id)match->data;
+
+	ret = rvin_get_pdata_flags(vin->dev, &vin->pdata_flags);
+	if (ret)
+		return ret;
+
+	vin->base = devm_ioremap_resource(vin->dev, mem);
+	if (IS_ERR(vin->base))
+		return PTR_ERR(vin->base);
+
+	/* Initialize the top-level structure */
+	return v4l2_device_register(vin->dev, &vin->v4l2_dev);
+}
+
+static int rcar_vin_probe(struct platform_device *pdev)
+{
+	struct rvin_dev *vin;
+	int irq, ret;
+
+	vin = devm_kzalloc(&pdev->dev, sizeof(*vin), GFP_KERNEL);
+	if (!vin)
+		return -ENOMEM;
+
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0)
+		return -EINVAL;
+
+
+	ret = rvin_init(vin, pdev);
+	if (ret)
+		goto error;
+
+	ret = rvin_dma_init(vin, irq);
+	if (ret)
+		goto free_dev;
+
+	ret = rvin_graph_init(vin);
+	if (ret < 0)
+		goto free_dma;
+
+	pm_suspend_ignore_children(&pdev->dev, true);
+	pm_runtime_enable(&pdev->dev);
+
+	platform_set_drvdata(pdev, vin);
+
+	return 0;
+
+free_dma:
+	rvin_dma_cleanup(vin);
+free_dev:
+	v4l2_device_unregister(&vin->v4l2_dev);
+error:
+
+	return ret;
+}
+
+static int rcar_vin_remove(struct platform_device *pdev)
+{
+	struct rvin_dev *vin = platform_get_drvdata(pdev);
+
+	v4l2_async_notifier_unregister(&vin->notifier);
+
+	rvin_dma_cleanup(vin);
+
+	rvin_free_formats(vin);
+
+	pm_runtime_disable(&pdev->dev);
+
+	v4l2_device_unregister(&vin->v4l2_dev);
+
+	return 0;
+}
+
+static struct platform_driver rcar_vin_driver = {
+	.driver = {
+		.name = "rcar-vin",
+		.of_match_table = rvin_of_id_table,
+	},
+	.probe = rcar_vin_probe,
+	.remove = rcar_vin_remove,
+};
+
+module_platform_driver(rcar_vin_driver);
+
+MODULE_AUTHOR("Niklas Söderlund <niklas.soderlund@ragnatech.se>");
+MODULE_DESCRIPTION("Renesas R-Car VIN camera host driver");
+MODULE_LICENSE("GPL v2");
--
2.7.1

