Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33014 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbaFLRGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [RFC PATCH 11/26] [media] v4l2: subdev: Add v4l2_device_register_subdev_node function
Date: Thu, 12 Jun 2014 19:06:25 +0200
Message-Id: <1402592800-2925-12-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sascha Hauer <s.hauer@pengutronix.de>

We currently only have a function that registers all subdev
device nodes for a v4l2 device at once. This assumes that
there is a point when all subdevices are known and that all
subdevices are needed to make a functional device. With the
advent of asynchronous subdevices this may no longer be the
case, so add a function which registers a single subdevice for
a given v4l2 device only and let v4l2_device_register_subdev_nodes
use this function.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/v4l2-core/v4l2-device.c | 63 ++++++++++++++++++++---------------
 include/media/v4l2-device.h           |  5 +++
 2 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 02d1b63..4211163 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -205,9 +205,43 @@ static void v4l2_device_release_subdev_node(struct video_device *vdev)
 	kfree(vdev);
 }
 
-int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
+int v4l2_device_register_subdev_node(struct v4l2_device *v4l2_dev,
+		struct v4l2_subdev *sd)
 {
 	struct video_device *vdev;
+	int err;
+
+	if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
+		return 0;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	video_set_drvdata(vdev, sd);
+	strlcpy(vdev->name, sd->name, sizeof(vdev->name));
+	vdev->v4l2_dev = v4l2_dev;
+	vdev->fops = &v4l2_subdev_fops;
+	vdev->release = v4l2_device_release_subdev_node;
+	vdev->ctrl_handler = sd->ctrl_handler;
+	err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
+				      sd->owner);
+	if (err < 0) {
+		kfree(vdev);
+		return err;
+	}
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	sd->entity.info.v4l.major = VIDEO_MAJOR;
+	sd->entity.info.v4l.minor = vdev->minor;
+#endif
+	sd->devnode = vdev;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_device_register_subdev_node);
+
+int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
+{
 	struct v4l2_subdev *sd;
 	int err;
 
@@ -215,32 +249,9 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 	 * V4L2_SUBDEV_FL_HAS_DEVNODE flag.
 	 */
 	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
-		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
-			continue;
-
-		vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-		if (!vdev) {
-			err = -ENOMEM;
-			goto clean_up;
-		}
-
-		video_set_drvdata(vdev, sd);
-		strlcpy(vdev->name, sd->name, sizeof(vdev->name));
-		vdev->v4l2_dev = v4l2_dev;
-		vdev->fops = &v4l2_subdev_fops;
-		vdev->release = v4l2_device_release_subdev_node;
-		vdev->ctrl_handler = sd->ctrl_handler;
-		err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
-					      sd->owner);
-		if (err < 0) {
-			kfree(vdev);
+		err = v4l2_device_register_subdev_node(v4l2_dev, sd);
+		if (err)
 			goto clean_up;
-		}
-#if defined(CONFIG_MEDIA_CONTROLLER)
-		sd->entity.info.v4l.major = VIDEO_MAJOR;
-		sd->entity.info.v4l.minor = vdev->minor;
-#endif
-		sd->devnode = vdev;
 	}
 	return 0;
 
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index c9b1593..512cc4b 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -120,6 +120,11 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
 int __must_check
 v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev);
 
+/* Register a single device node for a subdev of a v4l2 device. */
+int __must_check
+v4l2_device_register_subdev_node(struct v4l2_device *v4l2_dev,
+				struct v4l2_subdev *sd);
+
 /* Iterate over all subdevs. */
 #define v4l2_device_for_each_subdev(sd, v4l2_dev)			\
 	list_for_each_entry(sd, &(v4l2_dev)->subdevs, list)
-- 
2.0.0.rc2

