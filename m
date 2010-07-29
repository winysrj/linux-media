Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36475 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949Ab0G2QHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 12:07:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v3 08/10] v4l: Add a media_device pointer to the v4l2_device structure
Date: Thu, 29 Jul 2010 18:06:41 +0200
Message-Id: <1280419616-7658-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pointer will later be used to register/unregister media entities
when registering/unregistering a v4l2_subdev or a video_device.

With the introduction of media devices, device drivers need to store a
pointer to a driver-specific structure in the device's drvdata.
v4l2_device can't claim ownership of the drvdata anymore.

To maintain compatibility with drivers that rely on v4l2_device storing
a pointer to itself in the device's drvdata, v4l2_device_register() will
keep doing so if the drvdata is NULL.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/video4linux/v4l2-framework.txt |   17 ++++++++++++-----
 drivers/media/video/v4l2-device.c            |   13 +++++++------
 include/media/v4l2-device.h                  |    2 ++
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 89bd881..8a3f14e 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -83,11 +83,17 @@ You must register the device instance:
 
 	v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev);
 
-Registration will initialize the v4l2_device struct and link dev->driver_data
-to v4l2_dev. If v4l2_dev->name is empty then it will be set to a value derived
-from dev (driver name followed by the bus_id, to be precise). If you set it
-up before calling v4l2_device_register then it will be untouched. If dev is
-NULL, then you *must* setup v4l2_dev->name before calling v4l2_device_register.
+Registration will initialize the v4l2_device struct. If the dev->driver_data
+field is NULL, it will be linked to v4l2_dev. Drivers that use the media
+device framework in addition to the V4L2 framework need to set
+dev->driver_data manually to point to the driver-specific device structure
+that embed the struct v4l2_device instance. This is achieved by a
+dev_set_drvdata() call before registering the V4L2 device instance.
+
+If v4l2_dev->name is empty then it will be set to a value derived from dev
+(driver name followed by the bus_id, to be precise). If you set it up before
+calling v4l2_device_register then it will be untouched. If dev is NULL, then
+you *must* setup v4l2_dev->name before calling v4l2_device_register.
 
 You can use v4l2_device_set_name() to set the name based on a driver name and
 a driver-global atomic_t instance. This will generate names like ivtv0, ivtv1,
@@ -108,6 +114,7 @@ You unregister with:
 
 	v4l2_device_unregister(struct v4l2_device *v4l2_dev);
 
+If the dev->driver_data field points to v4l2_dev, it will be reset to NULL.
 Unregistering will also automatically unregister all subdevs from the device.
 
 If you have a hotpluggable device (e.g. a USB device), then when a disconnect
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index b287aaa..91452cd 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -45,9 +45,8 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 	if (!v4l2_dev->name[0])
 		snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s %s",
 			dev->driver->name, dev_name(dev));
-	if (dev_get_drvdata(dev))
-		v4l2_warn(v4l2_dev, "Non-NULL drvdata on register\n");
-	dev_set_drvdata(dev, v4l2_dev);
+	if (!dev_get_drvdata(dev))
+		dev_set_drvdata(dev, v4l2_dev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register);
@@ -70,10 +69,12 @@ EXPORT_SYMBOL_GPL(v4l2_device_set_name);
 
 void v4l2_device_disconnect(struct v4l2_device *v4l2_dev)
 {
-	if (v4l2_dev->dev) {
+	if (v4l2_dev->dev == NULL)
+		return;
+
+	if (dev_get_drvdata(v4l2_dev->dev) == v4l2_dev)
 		dev_set_drvdata(v4l2_dev->dev, NULL);
-		v4l2_dev->dev = NULL;
-	}
+	v4l2_dev->dev = NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_disconnect);
 
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 5d5d550..83b5966 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -21,6 +21,7 @@
 #ifndef _V4L2_DEVICE_H
 #define _V4L2_DEVICE_H
 
+#include <media/media-device.h>
 #include <media/v4l2-subdev.h>
 
 /* Each instance of a V4L2 device should create the v4l2_device struct,
@@ -37,6 +38,7 @@ struct v4l2_device {
 	   Note: dev might be NULL if there is no parent device
 	   as is the case with e.g. ISA devices. */
 	struct device *dev;
+	struct media_device *mdev;
 	/* used to keep track of the registered subdevs */
 	struct list_head subdevs;
 	/* lock this struct; can be used by the driver as well if this
-- 
1.7.1

