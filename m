Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47147 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbdCNTKI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:10:08 -0400
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
Subject: [PATCH 14/16] rcar-vin: make use of video_device_alloc() and video_device_release()
Date: Tue, 14 Mar 2017 19:59:55 +0100
Message-Id: <20170314185957.25253-15-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make use of the helper functions video_device_alloc() and
video_device_release() to control the lifetime of the struct
video_device.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 44 ++++++++++++++++-------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  2 +-
 2 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index be6f41bf82ac3bc5..c40f5bc3e3d26472 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -489,7 +489,7 @@ static int rvin_enum_input(struct file *file, void *priv,
 		i->std = 0;
 	} else {
 		i->capabilities = V4L2_IN_CAP_STD;
-		i->std = vin->vdev.tvnorms;
+		i->std = vin->vdev->tvnorms;
 	}
 
 	strlcpy(i->name, "Camera", sizeof(i->name));
@@ -752,8 +752,8 @@ static int rvin_initialize_device(struct file *file)
 	if (ret < 0)
 		return ret;
 
-	pm_runtime_enable(&vin->vdev.dev);
-	ret = pm_runtime_resume(&vin->vdev.dev);
+	pm_runtime_enable(&vin->vdev->dev);
+	ret = pm_runtime_resume(&vin->vdev->dev);
 	if (ret < 0 && ret != -ENOSYS)
 		goto eresume;
 
@@ -771,7 +771,7 @@ static int rvin_initialize_device(struct file *file)
 
 	return 0;
 esfmt:
-	pm_runtime_disable(&vin->vdev.dev);
+	pm_runtime_disable(&vin->vdev->dev);
 eresume:
 	rvin_power_off(vin);
 
@@ -823,8 +823,8 @@ static int rvin_release(struct file *file)
 	 * Then de-initialize hw module.
 	 */
 	if (fh_singular) {
-		pm_runtime_suspend(&vin->vdev.dev);
-		pm_runtime_disable(&vin->vdev.dev);
+		pm_runtime_suspend(&vin->vdev->dev);
+		pm_runtime_disable(&vin->vdev->dev);
 		rvin_power_off(vin);
 	}
 
@@ -846,13 +846,13 @@ static const struct v4l2_file_operations rvin_fops = {
 void rvin_v4l2_remove(struct rvin_dev *vin)
 {
 	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
-		  video_device_node_name(&vin->vdev));
+		  video_device_node_name(vin->vdev));
 
 	/* Checks internaly if handlers have been init or not */
 	v4l2_ctrl_handler_free(&vin->ctrl_handler);
 
 	/* Checks internaly if vdev have been init or not */
-	video_unregister_device(&vin->vdev);
+	video_unregister_device(vin->vdev);
 }
 
 static void rvin_notify(struct v4l2_subdev *sd,
@@ -863,7 +863,7 @@ static void rvin_notify(struct v4l2_subdev *sd,
 
 	switch (notification) {
 	case V4L2_DEVICE_NOTIFY_EVENT:
-		v4l2_event_queue(&vin->vdev, arg);
+		v4l2_event_queue(vin->vdev, arg);
 		break;
 	default:
 		break;
@@ -872,7 +872,7 @@ static void rvin_notify(struct v4l2_subdev *sd,
 
 int rvin_v4l2_probe(struct rvin_dev *vin)
 {
-	struct video_device *vdev = &vin->vdev;
+	struct video_device *vdev;
 	struct v4l2_subdev *sd = vin_to_source(vin);
 	int ret;
 
@@ -880,16 +880,18 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 
 	vin->v4l2_dev.notify = rvin_notify;
 
-	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
+	vdev = video_device_alloc();
+
+	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vdev->tvnorms);
 	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
 		return ret;
 
-	if (vin->vdev.tvnorms == 0) {
+	if (vdev->tvnorms == 0) {
 		/* Disable the STD API if there are no tvnorms defined */
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
+		v4l2_disable_ioctl(vdev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(vdev, VIDIOC_S_STD);
+		v4l2_disable_ioctl(vdev, VIDIOC_QUERYSTD);
+		v4l2_disable_ioctl(vdev, VIDIOC_ENUMSTD);
 	}
 
 	/* Add the controls */
@@ -913,7 +915,7 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vdev->v4l2_dev = &vin->v4l2_dev;
 	vdev->queue = &vin->queue;
 	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
-	vdev->release = video_device_release_empty;
+	vdev->release = video_device_release;
 	vdev->ioctl_ops = &rvin_ioctl_ops;
 	vdev->lock = &vin->lock;
 	vdev->ctrl_handler = &vin->ctrl_handler;
@@ -923,16 +925,18 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
 	rvin_reset_format(vin);
 
-	ret = video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		vin_err(vin, "Failed to register video device\n");
 		return ret;
 	}
 
-	video_set_drvdata(&vin->vdev, vin);
+	video_set_drvdata(vdev, vin);
 
 	v4l2_info(&vin->v4l2_dev, "Device registered as %s\n",
-		  video_device_node_name(&vin->vdev));
+		  video_device_node_name(vdev));
+
+	vin->vdev = vdev;
 
 	return ret;
 }
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 9bfb5a7c4dc4f215..9454ef80bc2b3961 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -122,7 +122,7 @@ struct rvin_dev {
 	void __iomem *base;
 	enum chip_id chip;
 
-	struct video_device vdev;
+	struct video_device *vdev;
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_async_notifier notifier;
-- 
2.12.0
