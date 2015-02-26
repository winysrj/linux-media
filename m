Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33536 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbbBZSFy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 13:05:54 -0500
Received: by wevk48 with SMTP id k48so13394167wev.0
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2015 10:05:53 -0800 (PST)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: mt9p031: make sure we destroy the mutex
Date: Thu, 26 Feb 2015 18:05:38 +0000
Message-Id: <1424973938-26121-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch makes sure to call mutex_destroy() in
case of probe failure or module unload.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/mt9p031.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index e3acae9..af5a09d 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -1071,6 +1071,8 @@ static int mt9p031_probe(struct i2c_client *client,
 		return ret;
 	}
 
+	mutex_init(&mt9p031->power_lock);
+
 	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 6);
 
 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
@@ -1108,7 +1110,6 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->blc_offset = v4l2_ctrl_find(&mt9p031->ctrls,
 					     V4L2_CID_BLC_DIGITAL_OFFSET);
 
-	mutex_init(&mt9p031->power_lock);
 	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
 	mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;
 
@@ -1149,6 +1150,7 @@ done:
 	if (ret < 0) {
 		v4l2_ctrl_handler_free(&mt9p031->ctrls);
 		media_entity_cleanup(&mt9p031->subdev.entity);
+		mutex_destroy(&mt9p031->power_lock);
 	}
 
 	return ret;
@@ -1162,6 +1164,7 @@ static int mt9p031_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&mt9p031->ctrls);
 	v4l2_device_unregister_subdev(subdev);
 	media_entity_cleanup(&subdev->entity);
+	mutex_destroy(&mt9p031->power_lock);
 
 	return 0;
 }
-- 
1.9.1

