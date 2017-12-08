Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:44870 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdLHBJD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 20:09:03 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v9 19/28] rcar-vin: use different v4l2 operations in media controller mode
Date: Fri,  8 Dec 2017 02:08:33 +0100
Message-Id: <20171208010842.20047-20-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
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
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  |   3 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 155 +++++++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |   1 +
 3 files changed, 155 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index d2788d8bb9565aaa..6c5df13b30d6dd14 100644
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
index 0ffbf0c16fb7b00e..5fea2856fd61030f 100644
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
@@ -671,6 +674,84 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
+/* -----------------------------------------------------------------------------
+ * V4L2 Media Controller
+ */
+
+static int __rvin_mc_try_format(struct rvin_dev *vin,
+				struct v4l2_pix_format *pix)
+{
+	/* Keep current field if no specific one is asked for */
+	if (pix->field == V4L2_FIELD_ANY)
+		pix->field = vin->format.field;
+
+	return rvin_format_align(vin, pix);
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
 /* -----------------------------------------------------------------------------
  * File Operations
  */
@@ -814,6 +895,60 @@ static const struct v4l2_file_operations rvin_fops = {
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
+	pm_runtime_get_sync(vin->dev);
+	v4l2_pipeline_pm_use(&vin->vdev.entity, 1);
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
+	int ret;
+
+	mutex_lock(&vin->lock);
+
+	/* the release helper will cleanup any on-going streaming */
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
@@ -849,19 +984,33 @@ int rvin_v4l2_register(struct rvin_dev *vin)
 	vin->v4l2_dev.notify = rvin_notify;
 
 	/* video node */
-	vdev->fops = &rvin_fops;
 	vdev->v4l2_dev = &vin->v4l2_dev;
 	vdev->queue = &vin->queue;
 	snprintf(vdev->name, sizeof(vdev->name), "%s %s", KBUILD_MODNAME,
 		 dev_name(vin->dev));
 	vdev->release = video_device_release_empty;
-	vdev->ioctl_ops = &rvin_ioctl_ops;
 	vdev->lock = &vin->lock;
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
 
+	/* Set some form of default format */
 	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
-	rvin_reset_format(vin);
+	vin->format.width = RVIN_DEFAULT_WIDTH;
+	vin->format.height = RVIN_DEFAULT_HEIGHT;
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
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 0747873c2b9cb74c..fd3cd781be0ab1cf 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -21,6 +21,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-mc.h>
 #include <media/videobuf2-v4l2.h>
 
 /* Number of HW buffers */
-- 
2.15.0
