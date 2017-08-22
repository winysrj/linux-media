Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:55942 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752376AbdHVX2l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 19:28:41 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v6 02/25] rcar-vin: register the video device at probe time
Date: Wed, 23 Aug 2017 01:26:17 +0200
Message-Id: <20170822232640.26147-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver registers the video device from the async complete callback
and unregistered in the async unbind callback. This creates problems if
if the subdevice is bound, unbound and later rebound. The second time
video_register_device() is called it fails:

   kobject (eb3be918): tried to init an initialized object, something is seriously wrong.

To prevent this register the video device at prob time and don't allow
user-space to open the video device if the subdevice have not yet been
bound.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 42 +++++++++++++++++++++++++++--
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 42 +++++------------------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  1 +
 3 files changed, 47 insertions(+), 38 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 77dff047c41c803e..aefbe8e3ccddb3e4 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -74,6 +74,7 @@ static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
 static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct v4l2_subdev *sd = vin_to_source(vin);
 	int ret;
 
 	/* Verify subdevices mbus format */
@@ -92,7 +93,35 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
-	return rvin_v4l2_probe(vin);
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
+		return ret;
+
+	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
+	if (ret < 0)
+		return ret;
+
+	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
+
+	if (vin->vdev.tvnorms == 0) {
+		/* Disable the STD API if there are no tvnorms defined */
+		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
+		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
+		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
+	}
+
+	return rvin_reset_format(vin);
 }
 
 static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
@@ -102,7 +131,7 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 
 	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
-	rvin_v4l2_remove(vin);
+	v4l2_ctrl_handler_free(&vin->ctrl_handler);
 	vin->digital.subdev = NULL;
 }
 
@@ -231,6 +260,10 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 	vin->notifier.unbind = rvin_digital_notify_unbind;
 	vin->notifier.complete = rvin_digital_notify_complete;
 
+	ret = rvin_v4l2_probe(vin);
+	if (ret)
+		return ret;
+
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
 	if (ret < 0) {
 		vin_err(vin, "Notifier registration failed\n");
@@ -314,6 +347,11 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	v4l2_async_notifier_unregister(&vin->notifier);
 
+	/* Checks internaly if handlers have been init or not */
+	v4l2_ctrl_handler_free(&vin->ctrl_handler);
+
+	rvin_v4l2_remove(vin);
+
 	rvin_dma_remove(vin);
 
 	return 0;
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index dd37ea8116804df3..81ff59c3b4744075 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -103,7 +103,7 @@ static void rvin_reset_crop_compose(struct rvin_dev *vin)
 	vin->compose.height = vin->format.height;
 }
 
-static int rvin_reset_format(struct rvin_dev *vin)
+int rvin_reset_format(struct rvin_dev *vin)
 {
 	struct v4l2_subdev_format fmt = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
@@ -781,6 +781,11 @@ static int rvin_open(struct file *file)
 
 	mutex_lock(&vin->lock);
 
+	if (!vin->digital.subdev) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
 	file->private_data = vin;
 
 	ret = v4l2_fh_open(file);
@@ -844,9 +849,6 @@ void rvin_v4l2_remove(struct rvin_dev *vin)
 	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
 		  video_device_node_name(&vin->vdev));
 
-	/* Checks internaly if handlers have been init or not */
-	v4l2_ctrl_handler_free(&vin->ctrl_handler);
-
 	/* Checks internaly if vdev have been init or not */
 	video_unregister_device(&vin->vdev);
 }
@@ -869,41 +871,10 @@ static void rvin_notify(struct v4l2_subdev *sd,
 int rvin_v4l2_probe(struct rvin_dev *vin)
 {
 	struct video_device *vdev = &vin->vdev;
-	struct v4l2_subdev *sd = vin_to_source(vin);
 	int ret;
 
-	v4l2_set_subdev_hostdata(sd, vin);
-
 	vin->v4l2_dev.notify = rvin_notify;
 
-	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		return ret;
-
-	if (vin->vdev.tvnorms == 0) {
-		/* Disable the STD API if there are no tvnorms defined */
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
-	}
-
-	/* Add the controls */
-	/*
-	 * Currently the subdev with the largest number of controls (13) is
-	 * ov6550. So let's pick 16 as a hint for the control handler. Note
-	 * that this is a hint only: too large and you waste some memory, too
-	 * small and there is a (very) small performance hit when looking up
-	 * controls in the internal hash.
-	 */
-	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
-	if (ret < 0)
-		return ret;
-
-	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
-	if (ret < 0)
-		return ret;
-
 	/* video node */
 	vdev->fops = &rvin_fops;
 	vdev->v4l2_dev = &vin->v4l2_dev;
@@ -917,7 +888,6 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 		V4L2_CAP_READWRITE;
 
 	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
-	rvin_reset_format(vin);
 
 	ret = video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret) {
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 9bfb5a7c4dc4f215..9d0d4a5001b6ccd8 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -158,6 +158,7 @@ void rvin_dma_remove(struct rvin_dev *vin);
 
 int rvin_v4l2_probe(struct rvin_dev *vin);
 void rvin_v4l2_remove(struct rvin_dev *vin);
+int rvin_reset_format(struct rvin_dev *vin);
 
 const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 
-- 
2.14.0
