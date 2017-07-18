Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60048 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751987AbdGRTEH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 12/19] v4l2-subdev: Support registering V4L2 sub-device nodes one by one
Date: Tue, 18 Jul 2017 22:03:54 +0300
Message-Id: <20170718190401.14797-13-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like video devices, V4L2 sub-device nodes can and should be registered
as soon as possible. Support this by providing
v4l2_device_register_subdev_node() function.
v4l2_device_register_subdev_nodes() continues to work just as it used to.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-device.c | 99 ++++++++++++++++++++---------------
 include/media/v4l2-device.h           | 12 +++++
 2 files changed, 70 insertions(+), 41 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 937c6de85606..0c0c4772c00a 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -222,58 +222,75 @@ static void v4l2_device_release_subdev_node(struct video_device *vdev)
 	kfree(vdev);
 }
 
-int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
+int v4l2_device_register_subdev_node(struct v4l2_device *v4l2_dev,
+				     struct v4l2_subdev *sd)
 {
 	struct video_device *vdev;
-	struct v4l2_subdev *sd;
 	int err;
 
-	/* Register a device node for every subdev marked with the
-	 * V4L2_SUBDEV_FL_HAS_DEVNODE flag.
-	 */
-	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
-		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
-			continue;
+	/* Bail out if the V4L2_SUBDEV_FL_HAS_DEVNODE flag isn't set. */
+	if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
+		return 0;
 
-		if (sd->devnode)
-			continue;
+	/* Was the device node already registered? If yes, then return here. */
+	if (sd->devnode)
+		return 0;
 
-		vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-		if (!vdev) {
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
+	if (err < 0)
+		goto clean_up;
+
+	sd->devnode = vdev;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	sd->entity.info.dev.major = VIDEO_MAJOR;
+	sd->entity.info.dev.minor = vdev->minor;
+
+	/* Interface is created by __video_register_device() */
+	if (vdev->v4l2_dev->mdev) {
+		struct media_link *link;
+
+		link = media_create_intf_link(&sd->entity,
+					      &vdev->intf_devnode->intf,
+					      MEDIA_LNK_FL_ENABLED);
+		if (!link) {
 			err = -ENOMEM;
 			goto clean_up;
 		}
+	}
+#endif
 
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
+	return 0;
+
+clean_up:
+	video_unregister_device(vdev);
+	kfree(vdev);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(v4l2_device_register_subdev_node);
+
+int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
+{
+	struct v4l2_subdev *sd;
+	int err;
+
+	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
+		int err;
+
+		err = v4l2_device_register_subdev_node(v4l2_dev, sd);
+		if (err < 0)
 			goto clean_up;
-		}
-		sd->devnode = vdev;
-#if defined(CONFIG_MEDIA_CONTROLLER)
-		sd->entity.info.dev.major = VIDEO_MAJOR;
-		sd->entity.info.dev.minor = vdev->minor;
-
-		/* Interface is created by __video_register_device() */
-		if (vdev->v4l2_dev->mdev) {
-			struct media_link *link;
-
-			link = media_create_intf_link(&sd->entity,
-						      &vdev->intf_devnode->intf,
-						      MEDIA_LNK_FL_ENABLED);
-			if (!link) {
-				err = -ENOMEM;
-				goto clean_up;
-			}
-		}
-#endif
 	}
 	return 0;
 
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 8ffa94009d1a..8b19c1f5bacd 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -189,6 +189,18 @@ int __must_check v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
 
 /**
+ * v4l2_device_register_subdev_node - Registers device nodes for a subdev
+ *	of the v4l2 device. The call is a no-op unless the
+ *	%V4L2_SUBDEV_FL_HAS_DEVNODE subdev flag is set.
+ *
+ * @v4l2_dev: pointer to struct v4l2_device
+ * @sd: pointer to struct v4l2_subdev
+ */
+int __must_check
+v4l2_device_register_subdev_node(struct v4l2_device *v4l2_dev,
+				 struct v4l2_subdev *sd);
+
+/**
  * v4l2_device_register_subdev_nodes - Registers device nodes for all subdevs
  *	of the v4l2 device that are marked with
  *	the %V4L2_SUBDEV_FL_HAS_DEVNODE flag.
-- 
2.11.0
