Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60050 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752000AbdGRTEI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:08 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 13/19] v4l2-device: Register sub-device nodes at sub-device registration time
Date: Tue, 18 Jul 2017 22:03:55 +0300
Message-Id: <20170718190401.14797-14-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-device.c | 146 ++++++++++++++++------------------
 include/media/v4l2-device.h           |  12 ---
 2 files changed, 67 insertions(+), 91 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 0c0c4772c00a..4da8f07fc373 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -151,70 +151,6 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister);
 
-int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
-				struct v4l2_subdev *sd)
-{
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	struct media_entity *entity = &sd->entity;
-#endif
-	int err;
-
-	/* Check for valid input */
-	if (!v4l2_dev || !sd || sd->v4l2_dev || !sd->name[0])
-		return -EINVAL;
-
-	/*
-	 * The reason to acquire the module here is to avoid unloading
-	 * a module of sub-device which is registered to a media
-	 * device. To make it possible to unload modules for media
-	 * devices that also register sub-devices, do not
-	 * try_module_get() such sub-device owners.
-	 */
-	sd->owner_v4l2_dev = v4l2_dev->dev && v4l2_dev->dev->driver &&
-		sd->owner == v4l2_dev->dev->driver->owner;
-
-	if (!sd->owner_v4l2_dev && !try_module_get(sd->owner))
-		return -ENODEV;
-
-	sd->v4l2_dev = v4l2_dev;
-	/* This just returns 0 if either of the two args is NULL */
-	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler, NULL);
-	if (err)
-		goto error_module;
-
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	/* Register the entity. */
-	if (v4l2_dev->mdev) {
-		err = media_device_register_entity(v4l2_dev->mdev, entity);
-		if (err < 0)
-			goto error_module;
-	}
-#endif
-
-	if (sd->internal_ops && sd->internal_ops->registered) {
-		err = sd->internal_ops->registered(sd);
-		if (err)
-			goto error_unregister;
-	}
-
-	spin_lock(&v4l2_dev->lock);
-	list_add_tail(&sd->list, &v4l2_dev->subdevs);
-	spin_unlock(&v4l2_dev->lock);
-
-	return 0;
-
-error_unregister:
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	media_device_unregister_entity(entity);
-#endif
-error_module:
-	if (!sd->owner_v4l2_dev)
-		module_put(sd->owner);
-	sd->v4l2_dev = NULL;
-	return err;
-}
-EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
-
 static void v4l2_device_release_subdev_node(struct video_device *vdev)
 {
 	struct v4l2_subdev *sd = video_get_drvdata(vdev);
@@ -222,8 +158,8 @@ static void v4l2_device_release_subdev_node(struct video_device *vdev)
 	kfree(vdev);
 }
 
-int v4l2_device_register_subdev_node(struct v4l2_device *v4l2_dev,
-				     struct v4l2_subdev *sd)
+static int v4l2_device_register_subdev_node(struct v4l2_device *v4l2_dev,
+					    struct v4l2_subdev *sd)
 {
 	struct video_device *vdev;
 	int err;
@@ -278,31 +214,83 @@ int v4l2_device_register_subdev_node(struct v4l2_device *v4l2_dev,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(v4l2_device_register_subdev_node);
 
-int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
+int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
+				struct v4l2_subdev *sd)
 {
-	struct v4l2_subdev *sd;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_entity *entity = &sd->entity;
+#endif
 	int err;
 
-	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
-		int err;
+	/* Check for valid input */
+	if (!v4l2_dev || !sd || sd->v4l2_dev || !sd->name[0])
+		return -EINVAL;
 
-		err = v4l2_device_register_subdev_node(v4l2_dev, sd);
+	/*
+	 * The reason to acquire the module here is to avoid unloading
+	 * a module of sub-device which is registered to a media
+	 * device. To make it possible to unload modules for media
+	 * devices that also register sub-devices, do not
+	 * try_module_get() such sub-device owners.
+	 */
+	sd->owner_v4l2_dev = v4l2_dev->dev && v4l2_dev->dev->driver &&
+		sd->owner == v4l2_dev->dev->driver->owner;
+
+	if (!sd->owner_v4l2_dev && !try_module_get(sd->owner))
+		return -ENODEV;
+
+	sd->v4l2_dev = v4l2_dev;
+	/* This just returns 0 if either of the two args is NULL */
+	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler, NULL);
+	if (err)
+		goto error_module;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	/* Register the entity. */
+	if (v4l2_dev->mdev) {
+		err = media_device_register_entity(v4l2_dev->mdev, entity);
 		if (err < 0)
-			goto clean_up;
+			goto error_module;
 	}
-	return 0;
+#endif
 
-clean_up:
-	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
-		if (!sd->devnode)
-			break;
-		video_unregister_device(sd->devnode);
+	if (sd->internal_ops && sd->internal_ops->registered) {
+		err = sd->internal_ops->registered(sd);
+		if (err)
+			goto error_unregister;
 	}
 
+	err = v4l2_device_register_subdev_node(v4l2_dev, sd);
+	if (err)
+		goto error_subdev_node;
+
+	spin_lock(&v4l2_dev->lock);
+	list_add_tail(&sd->list, &v4l2_dev->subdevs);
+	spin_unlock(&v4l2_dev->lock);
+
+	return 0;
+
+error_subdev_node:
+	if (sd->internal_ops && sd->internal_ops->unregistered)
+		sd->internal_ops->unregistered(sd);
+
+error_unregister:
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_device_unregister_entity(entity);
+#endif
+error_module:
+	if (!sd->owner_v4l2_dev)
+		module_put(sd->owner);
+	sd->v4l2_dev = NULL;
 	return err;
 }
+EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
+
+int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
+{
+	return 0;
+}
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev_nodes);
 
 void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 8b19c1f5bacd..8ffa94009d1a 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -189,18 +189,6 @@ int __must_check v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
 
 /**
- * v4l2_device_register_subdev_node - Registers device nodes for a subdev
- *	of the v4l2 device. The call is a no-op unless the
- *	%V4L2_SUBDEV_FL_HAS_DEVNODE subdev flag is set.
- *
- * @v4l2_dev: pointer to struct v4l2_device
- * @sd: pointer to struct v4l2_subdev
- */
-int __must_check
-v4l2_device_register_subdev_node(struct v4l2_device *v4l2_dev,
-				 struct v4l2_subdev *sd);
-
-/**
  * v4l2_device_register_subdev_nodes - Registers device nodes for all subdevs
  *	of the v4l2 device that are marked with
  *	the %V4L2_SUBDEV_FL_HAS_DEVNODE flag.
-- 
2.11.0
