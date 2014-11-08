Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53004 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752786AbaKHXJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 18:09:43 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 04/10] smiapp: Register async subdev
Date: Sun,  9 Nov 2014 01:09:25 +0200
Message-Id: <1415488171-27636-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1415488171-27636-1-git-send-email-sakari.ailus@iki.fi>
References: <1415488171-27636-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Register and unregister async sub-device for DT.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 512eeed..7c79e72 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2943,8 +2943,21 @@ static int smiapp_probe(struct i2c_client *client,
 	sensor->src->sensor = sensor;
 
 	sensor->src->pads[0].flags = MEDIA_PAD_FL_SOURCE;
-	return media_entity_init(&sensor->src->sd.entity, 2,
+	rval = media_entity_init(&sensor->src->sd.entity, 2,
 				 sensor->src->pads, 0);
+	if (rval < 0)
+		return rval;
+
+	rval = v4l2_async_register_subdev(&sensor->src->sd);
+	if (rval < 0)
+		goto out_media_entity_cleanup;
+
+	return 0;
+
+out_media_entity_cleanup:
+	media_entity_cleanup(&sensor->src->sd.entity);
+
+	return rval;
 }
 
 static int smiapp_remove(struct i2c_client *client)
@@ -2953,6 +2966,8 @@ static int smiapp_remove(struct i2c_client *client)
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	unsigned int i;
 
+	v4l2_async_unregister_subdev(subdev);
+
 	if (sensor->power_count) {
 		if (gpio_is_valid(sensor->platform_data->xshutdown))
 			gpio_set_value(sensor->platform_data->xshutdown, 0);
-- 
1.7.10.4

