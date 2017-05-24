Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:46769 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765675AbdEXARF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:17:05 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 15/17] rcar-vin: register the video device at probe time
Date: Wed, 24 May 2017 02:15:38 +0200
Message-Id: <20170524001540.13613-16-niklas.soderlund@ragnatech.se>
In-Reply-To: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
References: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

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
 drivers/media/platform/rcar-vin/rcar-core.c | 47 ++++++++++++++++++++++++++---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 42 ++++----------------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  1 +
 3 files changed, 50 insertions(+), 40 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index dcca906ba58435f5..0e1757301a0bca1e 100644
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
 
@@ -290,9 +319,13 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	ret = rvin_v4l2_probe(vin);
+	if (ret)
+		goto error_dma;
+
 	ret = rvin_digital_graph_init(vin);
 	if (ret < 0)
-		goto error;
+		goto error_v4l2;
 
 	pm_suspend_ignore_children(&pdev->dev, true);
 	pm_runtime_enable(&pdev->dev);
@@ -300,7 +333,9 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, vin);
 
 	return 0;
-error:
+error_v4l2:
+	rvin_v4l2_remove(vin);
+error_dma:
 	rvin_dma_remove(vin);
 
 	return ret;
@@ -314,6 +349,10 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	v4l2_async_notifier_unregister(&vin->notifier);
 
+	/* Checks internaly if handlers have been init or not */
+	v4l2_ctrl_handler_free(&vin->ctrl_handler);
+
+	rvin_v4l2_remove(vin);
 	rvin_dma_remove(vin);
 
 	return 0;
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index be6f41bf82ac3bc5..6f1c27fc828fe57e 100644
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
@@ -785,6 +785,11 @@ static int rvin_open(struct file *file)
 
 	mutex_lock(&vin->lock);
 
+	if (!vin->digital.subdev) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
 	file->private_data = vin;
 
 	ret = v4l2_fh_open(file);
@@ -848,9 +853,6 @@ void rvin_v4l2_remove(struct rvin_dev *vin)
 	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
 		  video_device_node_name(&vin->vdev));
 
-	/* Checks internaly if handlers have been init or not */
-	v4l2_ctrl_handler_free(&vin->ctrl_handler);
-
 	/* Checks internaly if vdev have been init or not */
 	video_unregister_device(&vin->vdev);
 }
@@ -873,41 +875,10 @@ static void rvin_notify(struct v4l2_subdev *sd,
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
@@ -921,7 +892,6 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
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
2.13.0
