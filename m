Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:44844 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdLHBI6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 20:08:58 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v9 04/28] rcar-vin: move subdevice handling to async callbacks
Date: Fri,  8 Dec 2017 02:08:18 +0100
Message-Id: <20171208010842.20047-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for Gen3 support move the subdevice initialization and
clean up from rvin_v4l2_{register,unregister}() directly to the async
callbacks. This simplifies the addition of Gen3 support as the
rvin_v4l2_register() can be shared for both Gen2 and Gen3 while direct
subdevice control are only used on Gen2.

While moving this code drop a large comment which is copied from the
framework documentation and fold rvin_mbus_supported() into its only
caller.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 105 ++++++++++++++++++----------
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  35 ----------
 2 files changed, 67 insertions(+), 73 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 6d99542ec74b49a7..6ab51acd676641ec 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -46,47 +46,11 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
 	return -EINVAL;
 }
 
-static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
-{
-	struct v4l2_subdev *sd = entity->subdev;
-	struct v4l2_subdev_mbus_code_enum code = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-
-	code.index = 0;
-	code.pad = entity->source_pad;
-	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
-		code.index++;
-		switch (code.code) {
-		case MEDIA_BUS_FMT_YUYV8_1X16:
-		case MEDIA_BUS_FMT_UYVY8_2X8:
-		case MEDIA_BUS_FMT_UYVY10_2X10:
-		case MEDIA_BUS_FMT_RGB888_1X24:
-			entity->code = code.code;
-			return true;
-		default:
-			break;
-		}
-	}
-
-	return false;
-}
-
 static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 	int ret;
 
-	/* Verify subdevices mbus format */
-	if (!rvin_mbus_supported(vin->digital)) {
-		vin_err(vin, "Unsupported media bus format for %s\n",
-			vin->digital->subdev->name);
-		return -EINVAL;
-	}
-
-	vin_dbg(vin, "Found media bus format for %s: %d\n",
-		vin->digital->subdev->name, vin->digital->code);
-
 	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
 	if (ret < 0) {
 		vin_err(vin, "Failed to register subdev nodes\n");
@@ -103,8 +67,16 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 
 	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
+
+	mutex_lock(&vin->lock);
+
 	rvin_v4l2_unregister(vin);
+	v4l2_ctrl_handler_free(&vin->ctrl_handler);
+
+	vin->vdev.ctrl_handler = NULL;
 	vin->digital->subdev = NULL;
+
+	mutex_unlock(&vin->lock);
 }
 
 static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
@@ -112,12 +84,14 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
 				     struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int ret;
 
 	v4l2_set_subdev_hostdata(subdev, vin);
 
 	/* Find source and sink pad of remote subdevice */
-
 	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
 	if (ret < 0)
 		return ret;
@@ -126,21 +100,74 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
 	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
 	vin->digital->sink_pad = ret < 0 ? 0 : ret;
 
+	/* Find compatible subdevices mbus format */
+	vin->digital->code = 0;
+	code.index = 0;
+	code.pad = vin->digital->source_pad;
+	while (!vin->digital->code &&
+	       !v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
+		code.index++;
+		switch (code.code) {
+		case MEDIA_BUS_FMT_YUYV8_1X16:
+		case MEDIA_BUS_FMT_UYVY8_2X8:
+		case MEDIA_BUS_FMT_UYVY10_2X10:
+		case MEDIA_BUS_FMT_RGB888_1X24:
+			vin->digital->code = code.code;
+			vin_dbg(vin, "Found media bus format for %s: %d\n",
+				subdev->name, vin->digital->code);
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (!vin->digital->code) {
+		vin_err(vin, "Unsupported media bus format for %s\n",
+			subdev->name);
+		return -EINVAL;
+	}
+
+	/* Read tvnorms */
+	ret = v4l2_subdev_call(subdev, video, g_tvnorms, &vin->vdev.tvnorms);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
+
+	mutex_lock(&vin->lock);
+
+	/* Add the controls */
+	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
+	if (ret < 0)
+		goto err;
+
+	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, subdev->ctrl_handler,
+				    NULL);
+	if (ret < 0)
+		goto err_ctrl;
+
+	vin->vdev.ctrl_handler = &vin->ctrl_handler;
+
 	vin->digital->subdev = subdev;
 
+	mutex_unlock(&vin->lock);
+
 	vin_dbg(vin, "bound subdev %s source pad: %u sink pad: %u\n",
 		subdev->name, vin->digital->source_pad,
 		vin->digital->sink_pad);
 
 	return 0;
+err_ctrl:
+	v4l2_ctrl_handler_free(&vin->ctrl_handler);
+err:
+	mutex_unlock(&vin->lock);
+	return ret;
 }
+
 static const struct v4l2_async_notifier_operations rvin_digital_notify_ops = {
 	.bound = rvin_digital_notify_bound,
 	.unbind = rvin_digital_notify_unbind,
 	.complete = rvin_digital_notify_complete,
 };
 
-
 static int rvin_digital_parse_v4l2(struct device *dev,
 				   struct v4l2_fwnode_endpoint *vep,
 				   struct v4l2_async_subdev *asd)
@@ -277,6 +304,8 @@ static int rcar_vin_remove(struct platform_device *pdev)
 	v4l2_async_notifier_unregister(&vin->notifier);
 	v4l2_async_notifier_cleanup(&vin->notifier);
 
+	v4l2_ctrl_handler_free(&vin->ctrl_handler);
+
 	rvin_dma_unregister(vin);
 
 	return 0;
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 32a658214f48fa49..4a0610a6b4503501 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -847,9 +847,6 @@ void rvin_v4l2_unregister(struct rvin_dev *vin)
 	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
 		  video_device_node_name(&vin->vdev));
 
-	/* Checks internaly if handlers have been init or not */
-	v4l2_ctrl_handler_free(&vin->ctrl_handler);
-
 	/* Checks internaly if vdev have been init or not */
 	video_unregister_device(&vin->vdev);
 }
@@ -872,41 +869,10 @@ static void rvin_notify(struct v4l2_subdev *sd,
 int rvin_v4l2_register(struct rvin_dev *vin)
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
@@ -915,7 +881,6 @@ int rvin_v4l2_register(struct rvin_dev *vin)
 	vdev->release = video_device_release_empty;
 	vdev->ioctl_ops = &rvin_ioctl_ops;
 	vdev->lock = &vin->lock;
-	vdev->ctrl_handler = &vin->ctrl_handler;
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
 
-- 
2.15.0
