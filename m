Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:7352 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1164154AbeCBB7T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:59:19 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 21/32] rcar-vin: use different v4l2 operations in media controller mode
Date: Fri,  2 Mar 2018 02:57:40 +0100
Message-Id: <20180302015751.25596-22-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the driver runs in media controller mode it should not directly
control the subdevice instead userspace will be responsible for
configuring the pipeline. To be able to run in this mode a different set
of v4l2 operations needs to be used.

Add a new set of v4l2 operations to support operation without directly
interacting with the source subdevice.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  |   3 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 161 +++++++++++++++++++++++++++-
 2 files changed, 160 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 3fb9c325285c5a5a..27d0c098f1da40f9 100644
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
index 20be21cb1cf521e5..8d92710efffa7276 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -18,12 +18,16 @@
 
 #include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-mc.h>
 #include <media/v4l2-rect.h>
 
 #include "rcar-vin.h"
 
 #define RVIN_DEFAULT_FORMAT	V4L2_PIX_FMT_YUYV
+#define RVIN_DEFAULT_WIDTH	800
+#define RVIN_DEFAULT_HEIGHT	600
 #define RVIN_DEFAULT_FIELD	V4L2_FIELD_NONE
+#define RVIN_DEFAULT_COLORSPACE	V4L2_COLORSPACE_SRGB
 
 /* -----------------------------------------------------------------------------
  * Format Conversions
@@ -667,6 +671,74 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
+/* -----------------------------------------------------------------------------
+ * V4L2 Media Controller
+ */
+
+static int rvin_mc_try_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_format *f)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+
+	return rvin_format_align(vin, &f->fmt.pix);
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
+	ret = rvin_format_align(vin, &f->fmt.pix);
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
 /* -----------------------------------------------------------------------------
  * File Operations
  */
@@ -810,6 +882,74 @@ static const struct v4l2_file_operations rvin_fops = {
 	.read		= vb2_fop_read,
 };
 
+/* -----------------------------------------------------------------------------
+ * Media controller file operations
+ */
+
+static int rvin_mc_open(struct file *file)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	int ret;
+
+	ret = mutex_lock_interruptible(&vin->lock);
+	if (ret)
+		return ret;
+
+	ret = pm_runtime_get_sync(vin->dev);
+	if (ret < 0)
+		goto err_pm;
+
+	ret = v4l2_pipeline_pm_use(&vin->vdev.entity, 1);
+	if (ret < 0)
+		goto err_v4l2pm;
+
+	file->private_data = vin;
+
+	ret = v4l2_fh_open(file);
+	if (ret)
+		goto err_open;
+
+	mutex_unlock(&vin->lock);
+
+	return 0;
+err_open:
+	v4l2_pipeline_pm_use(&vin->vdev.entity, 0);
+err_v4l2pm:
+	pm_runtime_put(vin->dev);
+err_pm:
+	mutex_unlock(&vin->lock);
+
+	return ret;
+}
+
+static int rvin_mc_release(struct file *file)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+	int ret;
+
+	mutex_lock(&vin->lock);
+
+	/* the release helper will cleanup any on-going streaming. */
+	ret = _vb2_fop_release(file, NULL);
+
+	v4l2_pipeline_pm_use(&vin->vdev.entity, 0);
+	pm_runtime_put(vin->dev);
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
 void rvin_v4l2_unregister(struct rvin_dev *vin)
 {
 	if (!video_is_registered(&vin->vdev))
@@ -845,18 +985,33 @@ int rvin_v4l2_register(struct rvin_dev *vin)
 	vin->v4l2_dev.notify = rvin_notify;
 
 	/* video node */
-	vdev->fops = &rvin_fops;
 	vdev->v4l2_dev = &vin->v4l2_dev;
 	vdev->queue = &vin->queue;
 	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
 	vdev->release = video_device_release_empty;
-	vdev->ioctl_ops = &rvin_ioctl_ops;
 	vdev->lock = &vin->lock;
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
 
+	/* Set a default format */
 	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
-	rvin_reset_format(vin);
+	vin->format.width = RVIN_DEFAULT_WIDTH;
+	vin->format.height = RVIN_DEFAULT_HEIGHT;
+	vin->format.field = RVIN_DEFAULT_FIELD;
+	vin->format.colorspace = RVIN_DEFAULT_COLORSPACE;
+
+	if (vin->info->use_mc) {
+		vdev->fops = &rvin_mc_fops;
+		vdev->ioctl_ops = &rvin_mc_ioctl_ops;
+	} else {
+		vdev->fops = &rvin_fops;
+		vdev->ioctl_ops = &rvin_ioctl_ops;
+		rvin_reset_format(vin);
+	}
+
+	ret = rvin_format_align(vin, &vin->format);
+	if (ret)
+		return ret;
 
 	ret = video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret) {
-- 
2.16.2
