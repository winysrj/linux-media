Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35003 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932502AbdCJEyl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 23:54:41 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v5 24/39] media: imx: Add Capture Device Interface
Date: Thu,  9 Mar 2017 20:53:04 -0800
Message-Id: <1489121599-23206-25-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the capture device interface driver that provides the v4l2
user interface. Frames can be received from various sources:

- directly from CSI for capturing unconverted images directly from
  camera sensors.

- from the IC pre-process encode task.

- from the IC pre-process viewfinder task.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/Makefile            |   1 +
 drivers/staging/media/imx/imx-media-capture.c | 655 ++++++++++++++++++++++++++
 2 files changed, 656 insertions(+)
 create mode 100644 drivers/staging/media/imx/imx-media-capture.c

diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
index ddd7d94..4606a3a 100644
--- a/drivers/staging/media/imx/Makefile
+++ b/drivers/staging/media/imx/Makefile
@@ -3,3 +3,4 @@ imx-media-common-objs := imx-media-utils.o imx-media-fim.o
 
 obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
 obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
+obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-capture.o
diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
new file mode 100644
index 0000000..704ed85
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -0,0 +1,655 @@
+/*
+ * Video Capture Subdev for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2012-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-mc.h>
+#include <media/v4l2-subdev.h>
+#include <media/videobuf2-dma-contig.h>
+#include <video/imx-ipu-v3.h>
+#include <media/imx.h>
+#include "imx-media.h"
+
+struct capture_priv {
+	struct imx_media_video_dev vdev;
+
+	struct v4l2_subdev    *src_sd;
+	int                   src_sd_pad;
+	struct device         *dev;
+
+	struct media_pipeline mp;
+	struct imx_media_dev  *md;
+
+	struct media_pad      vdev_pad;
+
+	struct mutex          mutex;       /* capture device mutex */
+
+	/* the videobuf2 queue */
+	struct vb2_queue       q;
+	/* list of ready imx_media_buffer's from q */
+	struct list_head       ready_q;
+	/* protect ready_q */
+	spinlock_t             q_lock;
+
+	/* controls inherited from subdevs */
+	struct v4l2_ctrl_handler ctrl_hdlr;
+
+	/* misc status */
+	bool                  stop;          /* streaming is stopping */
+};
+
+#define to_capture_priv(v) container_of(v, struct capture_priv, vdev)
+
+/* In bytes, per queue */
+#define VID_MEM_LIMIT	SZ_64M
+
+static struct vb2_ops capture_qops;
+
+/*
+ * Video ioctls follow
+ */
+
+static int vidioc_querycap(struct file *file, void *fh,
+			   struct v4l2_capability *cap)
+{
+	struct capture_priv *priv = video_drvdata(file);
+
+	strncpy(cap->driver, "imx-media-capture", sizeof(cap->driver) - 1);
+	strncpy(cap->card, "imx-media-capture", sizeof(cap->card) - 1);
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+		 "platform:%s", dev_name(priv->dev));
+
+	return 0;
+}
+
+static int capture_enum_fmt_vid_cap(struct file *file, void *fh,
+				    struct v4l2_fmtdesc *f)
+{
+	u32 fourcc;
+	int ret;
+
+	ret = imx_media_enum_format(&fourcc, NULL, f->index, true, true);
+	if (ret)
+		return ret;
+
+	f->pixelformat = fourcc;
+
+	return 0;
+}
+
+static int capture_g_fmt_vid_cap(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct capture_priv *priv = video_drvdata(file);
+
+	*f = priv->vdev.fmt;
+
+	return 0;
+}
+
+static int capture_try_fmt_vid_cap(struct file *file, void *fh,
+				   struct v4l2_format *f)
+{
+	struct capture_priv *priv = video_drvdata(file);
+	struct v4l2_subdev_format fmt_src;
+	const struct imx_media_pixfmt *cc, *src_cc;
+	u32 fourcc;
+	int ret;
+
+	fourcc = f->fmt.pix.pixelformat;
+	cc = imx_media_find_format(fourcc, 0, true, true);
+	if (!cc) {
+		imx_media_enum_format(&fourcc, NULL, 0, true, true);
+		cc = imx_media_find_format(fourcc, 0, true, true);
+	}
+
+	/*
+	 * user frame dimensions are the same as src_sd's pad.
+	 */
+	fmt_src.pad = priv->src_sd_pad;
+	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
+	if (ret)
+		return ret;
+
+	/*
+	 * but we can allow planar pixel formats if the src_sd's
+	 * pad configured a YUV format
+	 */
+	src_cc = imx_media_find_format(0, fmt_src.format.code, true, false);
+	if (src_cc->cs == IPUV3_COLORSPACE_YUV &&
+	    cc->cs == IPUV3_COLORSPACE_YUV) {
+		imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix,
+					      &fmt_src.format, cc);
+	} else {
+		imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix,
+					      &fmt_src.format, src_cc);
+	}
+
+	return 0;
+}
+
+static int capture_s_fmt_vid_cap(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct capture_priv *priv = video_drvdata(file);
+	int ret;
+
+	if (vb2_is_busy(&priv->q)) {
+		v4l2_err(priv->src_sd, "%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
+	ret = capture_try_fmt_vid_cap(file, priv, f);
+	if (ret)
+		return ret;
+
+	priv->vdev.fmt.fmt.pix = f->fmt.pix;
+	priv->vdev.cc = imx_media_find_format(f->fmt.pix.pixelformat, 0,
+					      true, true);
+
+	return 0;
+}
+
+static int capture_querystd(struct file *file, void *fh, v4l2_std_id *std)
+{
+	struct capture_priv *priv = video_drvdata(file);
+
+	return v4l2_subdev_call(priv->src_sd, video, querystd, std);
+}
+
+static int capture_g_std(struct file *file, void *fh, v4l2_std_id *std)
+{
+	struct capture_priv *priv = video_drvdata(file);
+
+	return v4l2_subdev_call(priv->src_sd, video, g_std, std);
+}
+
+static int capture_s_std(struct file *file, void *fh, v4l2_std_id std)
+{
+	struct capture_priv *priv = video_drvdata(file);
+
+	if (vb2_is_busy(&priv->q))
+		return -EBUSY;
+
+	return v4l2_subdev_call(priv->src_sd, video, s_std, std);
+}
+
+static int capture_g_parm(struct file *file, void *fh,
+			  struct v4l2_streamparm *a)
+{
+	struct capture_priv *priv = video_drvdata(file);
+	struct v4l2_subdev_frame_interval fi;
+	int ret;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	memset(&fi, 0, sizeof(fi));
+	fi.pad = priv->src_sd_pad;
+	ret = v4l2_subdev_call(priv->src_sd, video, g_frame_interval, &fi);
+	if (ret < 0)
+		return ret;
+
+	a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
+	a->parm.capture.timeperframe = fi.interval;
+
+	return 0;
+}
+
+static int capture_s_parm(struct file *file, void *fh,
+			  struct v4l2_streamparm *a)
+{
+	struct capture_priv *priv = video_drvdata(file);
+	struct v4l2_subdev_frame_interval fi;
+	int ret;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	memset(&fi, 0, sizeof(fi));
+	fi.pad = priv->src_sd_pad;
+	fi.interval = a->parm.capture.timeperframe;
+	ret = v4l2_subdev_call(priv->src_sd, video, s_frame_interval, &fi);
+	if (ret < 0)
+		return ret;
+
+	a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
+	a->parm.capture.timeperframe = fi.interval;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops capture_ioctl_ops = {
+	.vidioc_querycap	= vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap        = capture_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap           = capture_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap         = capture_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap           = capture_s_fmt_vid_cap,
+
+	.vidioc_querystd        = capture_querystd,
+	.vidioc_g_std           = capture_g_std,
+	.vidioc_s_std           = capture_s_std,
+
+	.vidioc_g_parm          = capture_g_parm,
+	.vidioc_s_parm          = capture_s_parm,
+
+	.vidioc_reqbufs		= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs     = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf     = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf	= vb2_ioctl_querybuf,
+	.vidioc_qbuf		= vb2_ioctl_qbuf,
+	.vidioc_dqbuf		= vb2_ioctl_dqbuf,
+	.vidioc_expbuf		= vb2_ioctl_expbuf,
+	.vidioc_streamon	= vb2_ioctl_streamon,
+	.vidioc_streamoff	= vb2_ioctl_streamoff,
+};
+
+/*
+ * Queue operations
+ */
+
+static int capture_queue_setup(struct vb2_queue *vq,
+			       unsigned int *nbuffers,
+			       unsigned int *nplanes,
+			       unsigned int sizes[],
+			       struct device *alloc_devs[])
+{
+	struct capture_priv *priv = vb2_get_drv_priv(vq);
+	struct v4l2_pix_format *pix = &priv->vdev.fmt.fmt.pix;
+	unsigned int count = *nbuffers;
+
+	if (vq->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (*nplanes) {
+		if (*nplanes != 1 || sizes[0] < pix->sizeimage)
+			return -EINVAL;
+		count += vq->num_buffers;
+	}
+
+	count = min_t(__u32, VID_MEM_LIMIT / pix->sizeimage, count);
+
+	if (*nplanes)
+		*nbuffers = (count < vq->num_buffers) ? 0 :
+			count - vq->num_buffers;
+	else
+		*nbuffers = count;
+
+	*nplanes = 1;
+	sizes[0] = pix->sizeimage;
+
+	return 0;
+}
+
+static int capture_buf_init(struct vb2_buffer *vb)
+{
+	struct imx_media_buffer *buf = to_imx_media_vb(vb);
+
+	INIT_LIST_HEAD(&buf->list);
+
+	return 0;
+}
+
+static int capture_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct capture_priv *priv = vb2_get_drv_priv(vq);
+	struct v4l2_pix_format *pix = &priv->vdev.fmt.fmt.pix;
+
+	if (vb2_plane_size(vb, 0) < pix->sizeimage) {
+		v4l2_err(priv->src_sd,
+			 "data will not fit into plane (%lu < %lu)\n",
+			 vb2_plane_size(vb, 0), (long)pix->sizeimage);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, pix->sizeimage);
+
+	return 0;
+}
+
+static void capture_buf_queue(struct vb2_buffer *vb)
+{
+	struct capture_priv *priv = vb2_get_drv_priv(vb->vb2_queue);
+	struct imx_media_buffer *buf = to_imx_media_vb(vb);
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->q_lock, flags);
+
+	list_add_tail(&buf->list, &priv->ready_q);
+
+	spin_unlock_irqrestore(&priv->q_lock, flags);
+}
+
+static int capture_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct capture_priv *priv = vb2_get_drv_priv(vq);
+	struct imx_media_buffer *buf, *tmp;
+	unsigned long flags;
+	int ret;
+
+	if (vb2_is_streaming(vq))
+		return 0;
+
+	ret = imx_media_pipeline_set_stream(priv->md, &priv->src_sd->entity,
+					    &priv->mp, true);
+	if (ret) {
+		v4l2_err(priv->src_sd, "pipeline start failed with %d\n", ret);
+		goto return_bufs;
+	}
+
+	priv->stop = false;
+
+	return 0;
+
+return_bufs:
+	spin_lock_irqsave(&priv->q_lock, flags);
+	list_for_each_entry_safe(buf, tmp, &priv->ready_q, list) {
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vbuf.vb2_buf, VB2_BUF_STATE_QUEUED);
+	}
+	spin_unlock_irqrestore(&priv->q_lock, flags);
+	return ret;
+}
+
+static void capture_stop_streaming(struct vb2_queue *vq)
+{
+	struct capture_priv *priv = vb2_get_drv_priv(vq);
+	struct imx_media_buffer *frame;
+	unsigned long flags;
+	int ret;
+
+	if (!vb2_is_streaming(vq))
+		return;
+
+	spin_lock_irqsave(&priv->q_lock, flags);
+	priv->stop = true;
+	spin_unlock_irqrestore(&priv->q_lock, flags);
+
+	ret = imx_media_pipeline_set_stream(priv->md, &priv->src_sd->entity,
+					    &priv->mp, false);
+	if (ret)
+		v4l2_warn(priv->src_sd, "pipeline stop failed with %d\n", ret);
+
+	/* release all active buffers */
+	spin_lock_irqsave(&priv->q_lock, flags);
+	while (!list_empty(&priv->ready_q)) {
+		frame = list_entry(priv->ready_q.next,
+				   struct imx_media_buffer, list);
+		list_del(&frame->list);
+		vb2_buffer_done(&frame->vbuf.vb2_buf, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock_irqrestore(&priv->q_lock, flags);
+}
+
+static struct vb2_ops capture_qops = {
+	.queue_setup	 = capture_queue_setup,
+	.buf_init        = capture_buf_init,
+	.buf_prepare	 = capture_buf_prepare,
+	.buf_queue	 = capture_buf_queue,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
+	.start_streaming = capture_start_streaming,
+	.stop_streaming  = capture_stop_streaming,
+};
+
+/*
+ * File operations
+ */
+static int capture_open(struct file *file)
+{
+	struct capture_priv *priv = video_drvdata(file);
+	int ret;
+
+	if (mutex_lock_interruptible(&priv->mutex))
+		return -ERESTARTSYS;
+
+	ret = v4l2_fh_open(file);
+	if (ret)
+		v4l2_err(priv->src_sd, "v4l2_fh_open failed\n");
+
+	mutex_unlock(&priv->mutex);
+	return ret;
+}
+
+static int capture_release(struct file *file)
+{
+	struct capture_priv *priv = video_drvdata(file);
+	struct vb2_queue *vq = &priv->q;
+	int ret = 0;
+
+	mutex_lock(&priv->mutex);
+
+	if (file->private_data == vq->owner) {
+		vb2_queue_release(vq);
+		vq->owner = NULL;
+	}
+
+	v4l2_fh_release(file);
+	mutex_unlock(&priv->mutex);
+	return ret;
+}
+
+static const struct v4l2_file_operations capture_fops = {
+	.owner		= THIS_MODULE,
+	.open		= capture_open,
+	.release	= capture_release,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= vb2_fop_mmap,
+};
+
+static struct video_device capture_videodev = {
+	.fops		= &capture_fops,
+	.ioctl_ops	= &capture_ioctl_ops,
+	.minor		= -1,
+	.release	= video_device_release,
+	.vfl_dir	= VFL_DIR_RX,
+	.tvnorms	= V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM,
+	.device_caps	= V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING,
+};
+
+struct imx_media_buffer *
+imx_media_capture_device_next_buf(struct imx_media_video_dev *vdev)
+{
+	struct capture_priv *priv = to_capture_priv(vdev);
+	struct imx_media_buffer *buf = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->q_lock, flags);
+
+	/* get next queued buffer */
+	if (!list_empty(&priv->ready_q)) {
+		buf = list_entry(priv->ready_q.next, struct imx_media_buffer,
+				 list);
+		list_del(&buf->list);
+	}
+
+	spin_unlock_irqrestore(&priv->q_lock, flags);
+
+	return buf;
+}
+EXPORT_SYMBOL_GPL(imx_media_capture_device_next_buf);
+
+void imx_media_capture_device_error(struct imx_media_video_dev *vdev)
+{
+	struct capture_priv *priv = to_capture_priv(vdev);
+	struct vb2_queue *vq = &priv->q;
+	unsigned long flags;
+
+	if (!vb2_is_streaming(vq))
+		return;
+
+	spin_lock_irqsave(&priv->q_lock, flags);
+	vb2_queue_error(vq);
+	spin_unlock_irqrestore(&priv->q_lock, flags);
+}
+EXPORT_SYMBOL_GPL(imx_media_capture_device_error);
+
+int imx_media_capture_device_register(struct imx_media_video_dev *vdev)
+{
+	struct capture_priv *priv = to_capture_priv(vdev);
+	struct v4l2_subdev *sd = priv->src_sd;
+	struct video_device *vfd = vdev->vfd;
+	struct vb2_queue *vq = &priv->q;
+	struct v4l2_subdev_format fmt_src;
+	int ret;
+
+	/* get media device */
+	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
+
+	vfd->v4l2_dev = sd->v4l2_dev;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		v4l2_err(sd, "Failed to register video device\n");
+		return ret;
+	}
+
+	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	vq->drv_priv = priv;
+	vq->buf_struct_size = sizeof(struct imx_media_buffer);
+	vq->ops = &capture_qops;
+	vq->mem_ops = &vb2_dma_contig_memops;
+	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	vq->lock = &priv->mutex;
+	vq->min_buffers_needed = 2;
+	vq->dev = priv->dev;
+
+	ret = vb2_queue_init(vq);
+	if (ret) {
+		v4l2_err(sd, "vb2_queue_init failed\n");
+		goto unreg;
+	}
+
+	INIT_LIST_HEAD(&priv->ready_q);
+
+	priv->vdev_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_pads_init(&vfd->entity, 1, &priv->vdev_pad);
+	if (ret) {
+		v4l2_err(sd, "failed to init dev pad\n");
+		goto unreg;
+	}
+
+	/* create the link from the src_sd devnode pad to device node */
+	ret = media_create_pad_link(&sd->entity, priv->src_sd_pad,
+				    &vfd->entity, 0, 0);
+	if (ret) {
+		v4l2_err(sd, "failed to create link to device node\n");
+		goto unreg;
+	}
+
+	/* setup default format */
+	fmt_src.pad = priv->src_sd_pad;
+	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt_src);
+	if (ret) {
+		v4l2_err(sd, "failed to get src_sd format\n");
+		goto unreg;
+	}
+
+	vdev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix,
+				      &fmt_src.format, NULL);
+	vdev->cc = imx_media_find_format(0, fmt_src.format.code,
+					 true, false);
+
+	v4l2_info(sd, "Registered %s as /dev/%s\n", vfd->name,
+		  video_device_node_name(vfd));
+
+	vfd->ctrl_handler = &priv->ctrl_hdlr;
+
+	return 0;
+unreg:
+	video_unregister_device(vfd);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(imx_media_capture_device_register);
+
+void imx_media_capture_device_unregister(struct imx_media_video_dev *vdev)
+{
+	struct capture_priv *priv = to_capture_priv(vdev);
+	struct video_device *vfd = priv->vdev.vfd;
+
+	mutex_lock(&priv->mutex);
+
+	if (video_is_registered(vfd)) {
+		video_unregister_device(vfd);
+		media_entity_cleanup(&vfd->entity);
+	}
+
+	mutex_unlock(&priv->mutex);
+}
+EXPORT_SYMBOL_GPL(imx_media_capture_device_unregister);
+
+struct imx_media_video_dev *
+imx_media_capture_device_init(struct v4l2_subdev *src_sd, int pad)
+{
+	struct capture_priv *priv;
+	struct video_device *vfd;
+
+	priv = devm_kzalloc(src_sd->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	priv->src_sd = src_sd;
+	priv->src_sd_pad = pad;
+	priv->dev = src_sd->dev;
+
+	mutex_init(&priv->mutex);
+	spin_lock_init(&priv->q_lock);
+
+	snprintf(capture_videodev.name, sizeof(capture_videodev.name),
+		 "%s capture", src_sd->name);
+
+	vfd = video_device_alloc();
+	if (!vfd)
+		return ERR_PTR(-ENOMEM);
+
+	*vfd = capture_videodev;
+	vfd->lock = &priv->mutex;
+	vfd->queue = &priv->q;
+	priv->vdev.vfd = vfd;
+
+	video_set_drvdata(vfd, priv);
+
+	v4l2_ctrl_handler_init(&priv->ctrl_hdlr, 0);
+
+	return &priv->vdev;
+}
+EXPORT_SYMBOL_GPL(imx_media_capture_device_init);
+
+void imx_media_capture_device_remove(struct imx_media_video_dev *vdev)
+{
+	struct capture_priv *priv = to_capture_priv(vdev);
+
+	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+}
+EXPORT_SYMBOL_GPL(imx_media_capture_device_remove);
+
+MODULE_DESCRIPTION("i.MX5/6 v4l2 video capture interface driver");
+MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
+MODULE_LICENSE("GPL");
-- 
2.7.4
