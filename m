Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:43685 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S940573AbdEZNCB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 09:02:01 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 1/1] ad5820: unregister async sub-device
Date: Fri, 26 May 2017 16:00:48 +0300
Message-Id: <1495803648-29261-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The async sub-device was not unregistered in ad5820_remove() as it should
have been; do it now. Also remove the now-redundant
v4l2_device_unregister_subdev().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ad5820.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 3d2a3c6..034ebf7 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -341,7 +341,7 @@ static int ad5820_remove(struct i2c_client *client)
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct ad5820_device *coil = to_ad5820_device(subdev);
 
-	v4l2_device_unregister_subdev(&coil->subdev);
+	v4l2_async_unregister_subdev(&coil->subdev);
 	v4l2_ctrl_handler_free(&coil->ctrls);
 	media_entity_cleanup(&coil->subdev.entity);
 	mutex_destroy(&coil->power_lock);
-- 
2.7.4
