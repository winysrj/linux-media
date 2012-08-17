Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47852 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2HQEu7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 00:50:59 -0400
Received: by pbbrr13 with SMTP id rr13so2715040pbb.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 21:50:59 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, sakari.ailus@iki.fi,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v2] smiapp: Use devm_* functions in smiapp-core.c file
Date: Fri, 17 Aug 2012 10:19:02 +0530
Message-Id: <1345178942-6771-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_* functions are device managed functions and make code a bit
smaller and cleaner.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Changes since v1:
Used devm_kzalloc for sensor->nvm.
Used devm_clk_get and devm_regulator_get functions.

This patch is based on Mauro's re-organized tree
(media_tree staging/for_v3.7) and is compile tested.
---
 drivers/media/i2c/smiapp/smiapp-core.c |   47 +++++++------------------------
 1 files changed, 11 insertions(+), 36 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 1cf914d..4f1c8d6 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2355,20 +2355,19 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	unsigned int i;
 	int rval;
 
-	sensor->vana = regulator_get(&client->dev, "VANA");
+	sensor->vana = devm_regulator_get(&client->dev, "VANA");
 	if (IS_ERR(sensor->vana)) {
 		dev_err(&client->dev, "could not get regulator for vana\n");
 		return -ENODEV;
 	}
 
 	if (!sensor->platform_data->set_xclk) {
-		sensor->ext_clk = clk_get(&client->dev,
-					  sensor->platform_data->ext_clk_name);
+		sensor->ext_clk = devm_clk_get(&client->dev,
+					sensor->platform_data->ext_clk_name);
 		if (IS_ERR(sensor->ext_clk)) {
 			dev_err(&client->dev, "could not get clock %s\n",
 				sensor->platform_data->ext_clk_name);
-			rval = -ENODEV;
-			goto out_clk_get;
+			return -ENODEV;
 		}
 
 		rval = clk_set_rate(sensor->ext_clk,
@@ -2378,8 +2377,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 				"unable to set clock %s freq to %u\n",
 				sensor->platform_data->ext_clk_name,
 				sensor->platform_data->ext_clk);
-			rval = -ENODEV;
-			goto out_clk_set_rate;
+			return -ENODEV;
 		}
 	}
 
@@ -2389,8 +2387,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 			dev_err(&client->dev,
 				"unable to acquire reset gpio %d\n",
 				sensor->platform_data->xshutdown);
-			rval = -ENODEV;
-			goto out_clk_set_rate;
+			return -ENODEV;
 		}
 	}
 
@@ -2470,8 +2467,8 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	 * when it is first requested by userspace.
 	 */
 	if (sensor->minfo.smiapp_version && sensor->platform_data->nvm_size) {
-		sensor->nvm = kzalloc(sensor->platform_data->nvm_size,
-				      GFP_KERNEL);
+		sensor->nvm = devm_kzalloc(&client->dev,
+				sensor->platform_data->nvm_size, GFP_KERNEL);
 		if (sensor->nvm == NULL) {
 			dev_err(&client->dev, "nvm buf allocation failed\n");
 			rval = -ENOMEM;
@@ -2637,21 +2634,12 @@ out_nvm_release:
 	device_remove_file(&client->dev, &dev_attr_nvm);
 
 out_power_off:
-	kfree(sensor->nvm);
-	sensor->nvm = NULL;
 	smiapp_power_off(sensor);
 
 out_smiapp_power_on:
 	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
 		gpio_free(sensor->platform_data->xshutdown);
 
-out_clk_set_rate:
-	clk_put(sensor->ext_clk);
-	sensor->ext_clk = NULL;
-
-out_clk_get:
-	regulator_put(sensor->vana);
-	sensor->vana = NULL;
 	return rval;
 }
 
@@ -2801,12 +2789,11 @@ static int smiapp_probe(struct i2c_client *client,
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
 
@@ -2821,12 +2808,8 @@ static int smiapp_probe(struct i2c_client *client,
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
@@ -2845,10 +2828,8 @@ static int __exit smiapp_remove(struct i2c_client *client)
 		sensor->power_count = 0;
 	}
 
-	if (sensor->nvm) {
+	if (sensor->nvm)
 		device_remove_file(&client->dev, &dev_attr_nvm);
-		kfree(sensor->nvm);
-	}
 
 	for (i = 0; i < sensor->ssds_used; i++) {
 		media_entity_cleanup(&sensor->ssds[i].sd.entity);
@@ -2857,12 +2838,6 @@ static int __exit smiapp_remove(struct i2c_client *client)
 	smiapp_free_controls(sensor);
 	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
 		gpio_free(sensor->platform_data->xshutdown);
-	if (sensor->ext_clk)
-		clk_put(sensor->ext_clk);
-	if (sensor->vana)
-		regulator_put(sensor->vana);
-
-	kfree(sensor);
 
 	return 0;
 }
-- 
1.7.4.1

