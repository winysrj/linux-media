Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56709 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab3LQNrF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 08:47:05 -0500
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 65D3F2018F
	for <linux-media@vger.kernel.org>; Tue, 17 Dec 2013 15:47:02 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [RFC v1.1 2/2] media: v4l: Only get module if it's different than the driver for v4l2_dev
Date: Tue, 17 Dec 2013 15:49:24 +0200
Message-Id: <1387288164-15250-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1386936216-32296-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1386936216-32296-2-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the sub-device is registered, increment the use count of the sub-device
owner only if it's different from the owner of the driver for the media
device. This avoids increasing the use count by the module itself and thus
making it possible to unload it when it's not in use.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Changes since v1:

- Check that v4l2_dev->dev and v4l2_dev->dev->driver are non-NULL before
  using them.
- Store the information on the same owner into struct v4l2_subdev. This avoids
  issues related to unregistering subdevs through v4l2_device_unregister().

 drivers/media/v4l2-core/v4l2-device.c | 18 +++++++++++++++---
 include/media/v4l2-subdev.h           |  1 +
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 02d1b63..015f92a 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -158,7 +158,17 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	/* Warn if we apparently re-register a subdev */
 	WARN_ON(sd->v4l2_dev != NULL);
 
-	if (!try_module_get(sd->owner))
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
 		return -ENODEV;
 
 	sd->v4l2_dev = v4l2_dev;
@@ -192,7 +202,8 @@ error_unregister:
 	if (sd->internal_ops && sd->internal_ops->unregistered)
 		sd->internal_ops->unregistered(sd);
 error_module:
-	module_put(sd->owner);
+	if (!sd->owner_v4l2_dev)
+		module_put(sd->owner);
 	sd->v4l2_dev = NULL;
 	return err;
 }
@@ -280,6 +291,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 	}
 #endif
 	video_unregister_device(sd->devnode);
-	module_put(sd->owner);
+	if (!sd->owner_v4l2_dev)
+		module_put(sd->owner);
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index d67210a..6d03b54 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -579,6 +579,7 @@ struct v4l2_subdev {
 #endif
 	struct list_head list;
 	struct module *owner;
+	bool owner_v4l2_dev;
 	u32 flags;
 	struct v4l2_device *v4l2_dev;
 	const struct v4l2_subdev_ops *ops;
-- 
1.8.3.2

