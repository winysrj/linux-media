Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35630 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2KYAkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Nov 2012 19:40:23 -0500
Received: from avalon.ideasonboard.com (unknown [91.178.178.202])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D4E9735A40
	for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 01:40:21 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: Reset subdev v4l2_dev field to NULL if registration fails
Date: Sun, 25 Nov 2012 01:41:20 +0100
Message-Id: <1353804080-25492-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When subdev registration fails the subdev v4l2_dev field is left to a
non-NULL value. Later calls to v4l2_device_unregister_subdev() will
consider the subdev as registered and will module_put() the subdev
module without any matching module_get().

Fix this by setting the subdev v4l2_dev field to NULL in
v4l2_device_register_subdev() when the function fails.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-device.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 513969f..98a7f5e 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -159,31 +159,21 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	sd->v4l2_dev = v4l2_dev;
 	if (sd->internal_ops && sd->internal_ops->registered) {
 		err = sd->internal_ops->registered(sd);
-		if (err) {
-			module_put(sd->owner);
-			return err;
-		}
+		if (err)
+			goto error_module;
 	}
 
 	/* This just returns 0 if either of the two args is NULL */
 	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler, NULL);
-	if (err) {
-		if (sd->internal_ops && sd->internal_ops->unregistered)
-			sd->internal_ops->unregistered(sd);
-		module_put(sd->owner);
-		return err;
-	}
+	if (err)
+		goto error_unregister;
 
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
+			goto error_unregister;
 	}
 #endif
 
@@ -192,6 +182,14 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	spin_unlock(&v4l2_dev->lock);
 
 	return 0;
+
+error_unregister:
+	if (sd->internal_ops && sd->internal_ops->unregistered)
+		sd->internal_ops->unregistered(sd);
+error_module:
+	module_put(sd->owner);
+	sd->v4l2_dev = NULL;
+	return err;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
 
-- 
1.7.8.6

