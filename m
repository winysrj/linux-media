Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39017 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab3ABLQB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 06:16:01 -0500
Received: from avalon.ideasonboard.com (unknown [91.178.66.146])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5466135A69
	for <linux-media@vger.kernel.org>; Wed,  2 Jan 2013 12:16:00 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] mt9p031: Use devm_* managed helpers
Date: Wed,  2 Jan 2013 12:17:27 +0100
Message-Id: <1357125447-6321-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace kzalloc and gpio_request_one by their managed equivalents.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index e328332..e0bad59 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -927,7 +927,7 @@ static int mt9p031_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	mt9p031 = kzalloc(sizeof(*mt9p031), GFP_KERNEL);
+	mt9p031 = devm_kzalloc(&client->dev, sizeof(*mt9p031), GFP_KERNEL);
 	if (mt9p031 == NULL)
 		return -ENOMEM;
 
@@ -1001,8 +1001,8 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
 
 	if (pdata->reset != -1) {
-		ret = gpio_request_one(pdata->reset, GPIOF_OUT_INIT_LOW,
-				       "mt9p031_rst");
+		ret = devm_gpio_request_one(&client->dev, pdata->reset,
+					    GPIOF_OUT_INIT_LOW, "mt9p031_rst");
 		if (ret < 0)
 			goto done;
 
@@ -1013,12 +1013,8 @@ static int mt9p031_probe(struct i2c_client *client,
 
 done:
 	if (ret < 0) {
-		if (mt9p031->reset != -1)
-			gpio_free(mt9p031->reset);
-
 		v4l2_ctrl_handler_free(&mt9p031->ctrls);
 		media_entity_cleanup(&mt9p031->subdev.entity);
-		kfree(mt9p031);
 	}
 
 	return ret;
@@ -1032,9 +1028,6 @@ static int mt9p031_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&mt9p031->ctrls);
 	v4l2_device_unregister_subdev(subdev);
 	media_entity_cleanup(&subdev->entity);
-	if (mt9p031->reset != -1)
-		gpio_free(mt9p031->reset);
-	kfree(mt9p031);
 
 	return 0;
 }
-- 
Regards,

Laurent Pinchart

