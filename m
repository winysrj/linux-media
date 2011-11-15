Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:56126 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab1KORuL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 12:50:11 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6/9] as3645a: free resources in case of error properly
Date: Tue, 15 Nov 2011 19:49:58 +0200
Message-Id: <20ff3c96498a0e9e0a1c1d09690fbbf6a59bee15.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/as3645a.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index 541f8bc..9aebaa2 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -800,11 +800,13 @@ static int as3645a_probe(struct i2c_client *client,
 	flash->subdev.internal_ops = &as3645a_internal_ops;
 	flash->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
+	ret = as3645a_init_controls(flash);
+	if (ret < 0)
+		goto free_and_quit;
+
 	ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
-	if (ret < 0) {
-		kfree(flash);
-		return ret;
-	}
+	if (ret < 0)
+		goto free_and_quit;
 
 	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
 
@@ -812,13 +814,12 @@ static int as3645a_probe(struct i2c_client *client,
 
 	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
 
-	ret = as3645a_init_controls(flash);
-	if (ret < 0) {
-		kfree(flash);
-		return ret;
-	}
-
 	return 0;
+
+free_and_quit:
+	v4l2_ctrl_handler_free(&flash->ctrls);
+	kfree(flash);
+	return ret;
 }
 
 static int __exit as3645a_remove(struct i2c_client *client)
@@ -828,7 +829,7 @@ static int __exit as3645a_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(subdev);
 	v4l2_ctrl_handler_free(&flash->ctrls);
-
+	media_entity_cleanup(&flash->subdev.entity);
 	kfree(flash);
 
 	return 0;
-- 
1.7.7.1

