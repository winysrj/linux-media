Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26527 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaGKOFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:22 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH/RFC v4 13/21] v4l2-device: add v4l2_device_register_subdev_node
 API
Date: Fri, 11 Jul 2014 16:04:16 +0200
Message-id: <1405087464-13762-14-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extract the code executed for each entry of the subdev list
and put it to the separate function. Export it as a public API.
It allows for registering single sub-device at a time.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-device.c |   63 +++++++++++++++++++--------------
 include/media/v4l2-device.h           |    7 ++++
 2 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 015f92a..0e91ef7 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -216,9 +216,43 @@ static void v4l2_device_release_subdev_node(struct video_device *vdev)
 	kfree(vdev);
 }
 
-int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
+int v4l2_device_register_subdev_node(struct v4l2_subdev *sd,
+				     struct v4l2_device *v4l2_dev)
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
 
@@ -226,32 +260,9 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
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
+		err = v4l2_device_register_subdev_node(sd, v4l2_dev);
+		if (err < 0)
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
index ffb69da..76594fc 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -114,6 +114,13 @@ int __must_check v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
    wasn't registered. In that case it will do nothing. */
 void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
 
+/* Register device node for the subdev of the v4l2 device if it is marked with
+ * the V4L2_SUBDEV_FL_HAS_DEVNODE flag.
+ */
+int __must_check
+v4l2_device_register_subdev_node(struct v4l2_subdev *sd,
+					struct v4l2_device *v4l2_dev);
+
 /* Register device nodes for all subdev of the v4l2 device that are marked with
  * the V4L2_SUBDEV_FL_HAS_DEVNODE flag.
  */
-- 
1.7.9.5

