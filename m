Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37413 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdCNTGn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:43 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 19/27] rcar-vin: use different v4l2 operations in media controller mode
Date: Tue, 14 Mar 2017 20:03:00 +0100
Message-Id: <20170314190308.25790-20-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the driver runs in media controller mode it should not directly
control the subdevice instead userspace will be responsible for
configuring the pipeline. To be able to run in this mode a different set
of v4l2 operations needs to be used.

Add a new set of v4l2 operations to support the running without directly
interacting with the source subdevice.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c |  25 ++-
 drivers/media/platform/rcar-vin/rcar-dma.c  |   3 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 239 ++++++++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h  |   3 +
 4 files changed, 268 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 8b30d8d3ec7d9c04..7aaa01dee014d64b 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -256,6 +256,21 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 }
 
 /* -----------------------------------------------------------------------------
+ * Group async notifier
+ */
+
+static int rvin_group_init(struct rvin_dev *vin)
+{
+	int ret;
+
+	ret = rvin_v4l2_mc_probe(vin);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
  * Platform Device Driver
  */
 
@@ -347,7 +362,10 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = rvin_digital_graph_init(vin);
+	if (vin->info->use_mc)
+		ret = rvin_group_init(vin);
+	else
+		ret = rvin_digital_graph_init(vin);
 	if (ret < 0)
 		goto error;
 
@@ -371,6 +389,11 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	v4l2_async_notifier_unregister(&vin->notifier);
 
+	if (vin->info->use_mc)
+		rvin_v4l2_mc_remove(vin);
+	else
+		rvin_v4l2_remove(vin);
+
 	rvin_dma_remove(vin);
 
 	return 0;
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index fef31aac0ed40979..34f01f32bab7bd32 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -628,7 +628,8 @@ static int rvin_setup(struct rvin_dev *vin)
 		/* Default to TB */
 		vnmc = VNMC_IM_FULL;
 		/* Use BT if video standard can be read and is 60 Hz format */
-		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
+		if (!vin->info->use_mc &&
+		    !v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
 			if (std & V4L2_STD_525_60)
 				vnmc = VNMC_IM_FULL | VNMC_FOC;
 		}
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 1ee9dcb621350f77..ae6910ac87ec7f6a 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -23,6 +23,9 @@
 #include "rcar-vin.h"
 
 #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
+#define RVIN_DEFAULT_WIDTH	800
+#define RVIN_DEFAULT_HEIGHT	600
+#define RVIN_DEFAULT_COLORSPACE	V4L2_COLORSPACE_SRGB
 
 /* -----------------------------------------------------------------------------
  * Format Conversions
@@ -694,6 +697,126 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 };
 
 /* -----------------------------------------------------------------------------
+ * V4L2 Media Controller
+ */
+
+static int __rvin_mc_try_format(struct rvin_dev *vin,
+				struct v4l2_pix_format *pix)
+{
+	const struct rvin_video_format *info;
+	u32 walign;
+
+	/* Keep current field if no specific one is asked for */
+	if (pix->field == V4L2_FIELD_ANY)
+		pix->field = vin->format.field;
+
+	switch (pix->field) {
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_ALTERNATE:
+	case V4L2_FIELD_NONE:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_INTERLACED:
+		break;
+	default:
+		pix->field = V4L2_FIELD_NONE;
+		break;
+	}
+
+	/* Check that colorspace is resonable, if not keep current */
+	if (!pix->colorspace || pix->colorspace >= 0xff)
+		pix->colorspace = vin->format.colorspace;
+
+	info = rvin_format_from_pixel(pix->pixelformat);
+	if (!info) {
+		vin_dbg(vin, "Format %x not found, keeping %x\n",
+			pix->pixelformat, vin->format.pixelformat);
+		pix->pixelformat = vin->format.pixelformat;
+		info = rvin_format_from_pixel(pix->pixelformat);
+	}
+
+	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
+	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
+
+	/* Limit to VIN capabilities */
+	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
+			      &pix->height, 4, vin->info->max_height, 2, 0);
+
+	pix->bytesperline = rvin_format_bytesperline(pix);
+	pix->sizeimage = rvin_format_sizeimage(pix);
+
+	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
+		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
+
+	return 0;
+}
+
+static int rvin_mc_try_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_format *f)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+
+	return __rvin_mc_try_format(vin, &f->fmt.pix);
+}
+
+static int rvin_mc_s_fmt_vid_cap(struct file *file, void *priv,
+				 struct v4l2_format *f)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	int ret;
+
+	if (vb2_is_busy(&vin->queue))
+		return -EBUSY;
+
+	ret = __rvin_mc_try_format(vin, &f->fmt.pix);
+	if (ret)
+		return ret;
+
+	vin->format = f->fmt.pix;
+
+	return 0;
+}
+
+static int rvin_mc_enum_input(struct file *file, void *priv,
+			      struct v4l2_input *i)
+{
+	if (i->index != 0)
+		return -EINVAL;
+
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	strlcpy(i->name, "Camera", sizeof(i->name));
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops rvin_mc_ioctl_ops = {
+	.vidioc_querycap		= rvin_querycap,
+	.vidioc_try_fmt_vid_cap		= rvin_mc_try_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= rvin_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= rvin_mc_s_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap	= rvin_enum_fmt_vid_cap,
+
+	.vidioc_enum_input		= rvin_mc_enum_input,
+	.vidioc_g_input			= rvin_g_input,
+	.vidioc_s_input			= rvin_s_input,
+
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= rvin_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+};
+
+/* -----------------------------------------------------------------------------
  * File Operations
  */
 
@@ -836,6 +959,68 @@ static const struct v4l2_file_operations rvin_fops = {
 	.read		= vb2_fop_read,
 };
 
+/* -----------------------------------------------------------------------------
+ * Media controller file Operations
+ */
+
+static int rvin_mc_open(struct file *file)
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
+	if (v4l2_fh_is_singular_file(file)) {
+		pm_runtime_get_sync(vin->dev);
+		v4l2_pipeline_pm_use(&vin->vdev->entity, 1);
+	}
+
+unlock:
+	mutex_unlock(&vin->lock);
+
+	return ret;
+}
+
+static int rvin_mc_release(struct file *file)
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
+	if (fh_singular) {
+		v4l2_pipeline_pm_use(&vin->vdev->entity, 0);
+		pm_runtime_put(vin->dev);
+	}
+
+	mutex_unlock(&vin->lock);
+
+	return ret;
+}
+
+static const struct v4l2_file_operations rvin_mc_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= video_ioctl2,
+	.open		= rvin_mc_open,
+	.release	= rvin_mc_release,
+	.poll		= vb2_fop_poll,
+	.mmap		= vb2_fop_mmap,
+	.read		= vb2_fop_read,
+};
+
 void rvin_v4l2_remove(struct rvin_dev *vin)
 {
 	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
@@ -934,3 +1119,57 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 
 	return ret;
 }
+
+void rvin_v4l2_mc_remove(struct rvin_dev *vin)
+{
+	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
+		  video_device_node_name(vin->vdev));
+
+	/* Checks internaly if vdev have been init or not */
+	video_unregister_device(vin->vdev);
+}
+
+int rvin_v4l2_mc_probe(struct rvin_dev *vin)
+{
+	struct video_device *vdev;
+	int ret;
+
+	vin->v4l2_dev.notify = rvin_notify;
+
+	vdev = video_device_alloc();
+
+	vdev->fops = &rvin_mc_fops;
+	vdev->v4l2_dev = &vin->v4l2_dev;
+	vdev->queue = &vin->queue;
+	snprintf(vdev->name, sizeof(vdev->name), "%s %s", KBUILD_MODNAME,
+		 dev_name(vin->dev));
+	vdev->release = video_device_release;
+	vdev->ioctl_ops = &rvin_mc_ioctl_ops;
+	vdev->lock = &vin->lock;
+	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+		V4L2_CAP_READWRITE;
+
+	/* Set some form of default format */
+	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
+	vin->format.width = RVIN_DEFAULT_WIDTH;
+	vin->format.height = RVIN_DEFAULT_HEIGHT;
+	vin->format.colorspace = RVIN_DEFAULT_COLORSPACE;
+	ret = __rvin_mc_try_format(vin, &vin->format);
+	if (ret)
+		return ret;
+
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		vin_err(vin, "Failed to register video device\n");
+		return ret;
+	}
+
+	video_set_drvdata(vdev, vin);
+
+	v4l2_info(&vin->v4l2_dev, "Device registered as %s\n",
+		  video_device_node_name(vdev));
+
+	vin->vdev = vdev;
+
+	return ret;
+}
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 512e67fdefd15015..6f2b1e28381678a9 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -21,6 +21,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-mc.h>
 #include <media/videobuf2-v4l2.h>
 
 /* Number of HW buffers */
@@ -162,6 +163,8 @@ void rvin_dma_remove(struct rvin_dev *vin);
 
 int rvin_v4l2_probe(struct rvin_dev *vin);
 void rvin_v4l2_remove(struct rvin_dev *vin);
+int rvin_v4l2_mc_probe(struct rvin_dev *vin);
+void rvin_v4l2_mc_remove(struct rvin_dev *vin);
 
 const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 
-- 
2.12.0
