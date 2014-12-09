Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53101 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754932AbaLIAEu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 19:04:50 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, mark.rutland@arm.com
Subject: [REVIEW PATCH v3 06/12] smiapp: Register async subdev
Date: Tue,  9 Dec 2014 02:04:14 +0200
Message-Id: <1418083460-28556-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
References: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Register and unregister async sub-device for DT.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 92a7840..9852c5f 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2942,8 +2942,21 @@ static int smiapp_probe(struct i2c_client *client,
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
@@ -2952,6 +2965,8 @@ static int smiapp_remove(struct i2c_client *client)
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	unsigned int i;
 
+	v4l2_async_unregister_subdev(subdev);
+
 	if (sensor->power_count) {
 		if (gpio_is_valid(sensor->platform_data->xshutdown))
 			gpio_set_value(sensor->platform_data->xshutdown, 0);
-- 
1.7.10.4

