Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:33863 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753431AbcJEHOh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 03:14:37 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 3A48420077
        for <linux-media@vger.kernel.org>; Wed,  5 Oct 2016 10:14:29 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: flash led class: Fix of_node release in probe() error path
Date: Wed,  5 Oct 2016 10:13:10 +0300
Message-Id: <1475651590-22111-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sub-device's OF node was used (of_node_get()) if it was set, but
device's OF node was always put. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-flash-led-class.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
index ae7544d..6b31c0a 100644
--- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
+++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
@@ -638,7 +638,7 @@ struct v4l2_flash *v4l2_flash_init(
 	v4l2_flash->iled_cdev = iled_cdev;
 	v4l2_flash->ops = ops;
 	sd->dev = dev;
-	sd->of_node = of_node;
+	sd->of_node = of_node ? of_node : led_cdev->dev->of_node;
 	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
 	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
@@ -654,10 +654,7 @@ struct v4l2_flash *v4l2_flash_init(
 	if (ret < 0)
 		goto err_init_controls;
 
-	if (sd->of_node)
-		of_node_get(sd->of_node);
-	else
-		of_node_get(led_cdev->dev->of_node);
+	of_node_get(sd->of_node);
 
 	ret = v4l2_async_register_subdev(sd);
 	if (ret < 0)
@@ -666,7 +663,7 @@ struct v4l2_flash *v4l2_flash_init(
 	return v4l2_flash;
 
 err_async_register_sd:
-	of_node_put(led_cdev->dev->of_node);
+	of_node_put(sd->of_node);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 err_init_controls:
 	media_entity_cleanup(&sd->entity);
@@ -688,10 +685,7 @@ void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
 
 	v4l2_async_unregister_subdev(sd);
 
-	if (sd->of_node)
-		of_node_put(sd->of_node);
-	else
-		of_node_put(led_cdev->dev->of_node);
+	of_node_put(sd->of_node);
 
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	media_entity_cleanup(&sd->entity);
-- 
2.7.4

