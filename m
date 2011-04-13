Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:49183 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab1DMJOk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 05:14:40 -0400
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [RFC 1/1] v4l: Improve error handling in v4l2_device_register_subdev()
Date: Wed, 13 Apr 2011 12:17:04 +0300
Message-Id: <1302686224-32616-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In some cases v4l2_device_register_subdev() did not module_put() a module
the user count of which was incremented by try_module_get() earlier.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
Hi,

I'm sending this as an RFC since technically this leaves still room for
improvement.

v4l2_ctrl_add_handler() error handling is still to be implemented. The
controls are added to the parent and that needs to be cleaned up ---
actually, even if v4l2_ctrl_add_handler() fails, the added controls would
have to be removed from the v4l2_dev parent.

I don't see an easy way to do this, except to call v4l2_ctrl_handler_free().
But that also cleans up the existing controls in the parent, which might not
be desirable.

As far as I understand, no driver initialises the v4l2_dev->ctrl_handler for
the moment.

---
 drivers/media/video/v4l2-device.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 5aeaf87..773146d 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -156,27 +156,20 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	if (sd->internal_ops && sd->internal_ops->registered) {
 		err = sd->internal_ops->registered(sd);
 		if (err)
-			return err;
+			goto err_registered;
 	}
 
 	/* This just returns 0 if either of the two args is NULL */
 	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler);
-	if (err) {
-		if (sd->internal_ops && sd->internal_ops->unregistered)
-			sd->internal_ops->unregistered(sd);
-		return err;
-	}
+	if (err)
+		goto err_v4l2_ctrl_add_handler;
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	/* Register the entity. */
 	if (v4l2_dev->mdev) {
 		err = media_device_register_entity(v4l2_dev->mdev, entity);
-		if (err < 0) {
-			if (sd->internal_ops && sd->internal_ops->unregistered)
-				sd->internal_ops->unregistered(sd);
-			module_put(sd->owner);
-			return err;
-		}
+		if (err < 0)
+			goto err_media_device_register_entity;
 	}
 #endif
 
@@ -185,6 +178,19 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	spin_unlock(&v4l2_dev->lock);
 
 	return 0;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+err_media_device_register_entity:
+#endif
+err_v4l2_ctrl_add_handler:
+	/* FIXME: v4l2_ctrl_add_handler() error handling. */
+	if (sd->internal_ops && sd->internal_ops->unregistered)
+		sd->internal_ops->unregistered(sd);
+
+err_registered:
+	module_put(sd->owner);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
 
-- 
1.7.2.5

