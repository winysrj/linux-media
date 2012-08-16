Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39683 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2HPLbY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 07:31:24 -0400
Received: by pbbrr13 with SMTP id rr13so1450458pbb.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 04:31:24 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, sakari.ailus@iki.fi,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] smiapp: Use devm_kzalloc() in smiapp-core.c file
Date: Thu, 16 Aug 2012 16:59:30 +0530
Message-Id: <1345116570-27335-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_kzalloc is a device managed function and makes code a bit
smaller and cleaner.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
This patch is based on Mauro's re-organized tree
(media_tree staging/for_v3.7) and is compile tested.
---
 drivers/media/i2c/smiapp/smiapp-core.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 1cf914d..7d4280e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2801,12 +2801,11 @@ static int smiapp_probe(struct i2c_client *client,
 			const struct i2c_device_id *devid)
 {
 	struct smiapp_sensor *sensor;
-	int rval;
 
 	if (client->dev.platform_data == NULL)
 		return -ENODEV;
 
-	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
+	sensor = devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
 	if (sensor == NULL)
 		return -ENOMEM;
 
@@ -2821,12 +2820,8 @@ static int smiapp_probe(struct i2c_client *client,
 	sensor->src->sensor = sensor;
 
 	sensor->src->pads[0].flags = MEDIA_PAD_FL_SOURCE;
-	rval = media_entity_init(&sensor->src->sd.entity, 2,
+	return media_entity_init(&sensor->src->sd.entity, 2,
 				 sensor->src->pads, 0);
-	if (rval < 0)
-		kfree(sensor);
-
-	return rval;
 }
 
 static int __exit smiapp_remove(struct i2c_client *client)
@@ -2862,8 +2857,6 @@ static int __exit smiapp_remove(struct i2c_client *client)
 	if (sensor->vana)
 		regulator_put(sensor->vana);
 
-	kfree(sensor);
-
 	return 0;
 }
 
-- 
1.7.4.1

