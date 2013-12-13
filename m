Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44536 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3LMMBW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 07:01:22 -0500
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id ED7FA202A2
	for <linux-media@vger.kernel.org>; Fri, 13 Dec 2013 14:01:18 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [RFC 2/2] media: v4l: Only get module if it's different than the driver for v4l2_dev
Date: Fri, 13 Dec 2013 14:03:36 +0200
Message-Id: <1386936216-32296-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1386936216-32296-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1386936216-32296-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the sub-device is registered, increment the use count of the sub-device
owner only if it's different from the owner of the driver for the media
device. This avoids increasing the use count by the module itself and thus
making it possible to unload it when it's not in use.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-device.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 02d1b63..9f6d1ec 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -158,7 +158,8 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	/* Warn if we apparently re-register a subdev */
 	WARN_ON(sd->v4l2_dev != NULL);
 
-	if (!try_module_get(sd->owner))
+	if (sd->owner != v4l2_dev->dev->driver->owner &&
+	    !try_module_get(sd->owner))
 		return -ENODEV;
 
 	sd->v4l2_dev = v4l2_dev;
@@ -192,7 +193,8 @@ error_unregister:
 	if (sd->internal_ops && sd->internal_ops->unregistered)
 		sd->internal_ops->unregistered(sd);
 error_module:
-	module_put(sd->owner);
+	if (sd->owner != v4l2_dev->dev->driver->owner)
+		module_put(sd->owner);
 	sd->v4l2_dev = NULL;
 	return err;
 }
@@ -280,6 +282,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 	}
 #endif
 	video_unregister_device(sd->devnode);
-	module_put(sd->owner);
+	if (sd->owner != v4l2_dev->dev->driver->owner)
+		module_put(sd->owner);
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
-- 
1.8.3.2

