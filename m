Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34314 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754547AbcIGKcH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 06:32:07 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id C6FE422E98
        for <linux-media@vger.kernel.org>; Wed,  7 Sep 2016 13:31:23 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 7/7] smiapp: Always initialise the sensor in probe
Date: Wed,  7 Sep 2016 13:30:15 +0300
Message-Id: <1473244215-19432-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473244215-19432-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473244215-19432-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialise the sensor in probe. The reason why it wasn't previously done
in case of platform data was that the probe() of the driver that provided
the clock through the set_xclk() callback would need to finish before the
probe() function of the smiapp driver. The set_xclk() callback no longer
exists.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 53 ++++++++++++----------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 7a25969..27b48f3 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2519,8 +2519,19 @@ static int smiapp_register_subdev(struct smiapp_sensor *sensor,
 	return 0;
 }
 
-static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
+static void smiapp_cleanup(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+
+	device_remove_file(&client->dev, &dev_attr_nvm);
+	device_remove_file(&client->dev, &dev_attr_ident);
+
+	smiapp_free_controls(sensor);
+}
+
+static int smiapp_registered(struct v4l2_subdev *subdev)
 {
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	int rval = 0;
 
 	if (sensor->scaler)
@@ -2529,22 +2540,17 @@ static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
 			sensor->binner->sink_pad, sensor->scaler->source_pad,
 			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
 	if (rval < 0)
-		return rval;
+		goto out_err;
 
 	return smiapp_register_subdev(
 		sensor, sensor->pixel_array, sensor->binner,
 		sensor->pixel_array->sink_pad, sensor->binner->source_pad,
 		MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
-}
 
-static void smiapp_cleanup(struct smiapp_sensor *sensor)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-
-	device_remove_file(&client->dev, &dev_attr_nvm);
-	device_remove_file(&client->dev, &dev_attr_ident);
+out_err:
+	smiapp_cleanup(sensor);
 
-	smiapp_free_controls(sensor);
+	return rval;
 }
 
 static void smiapp_create_subdev(struct smiapp_sensor *sensor,
@@ -2805,25 +2811,6 @@ out_power_off:
 	return rval;
 }
 
-static int smiapp_registered(struct v4l2_subdev *subdev)
-{
-	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
-	struct i2c_client *client = v4l2_get_subdevdata(subdev);
-	int rval;
-
-	if (!client->dev.of_node) {
-		rval = smiapp_init(sensor);
-		if (rval)
-			return rval;
-	}
-
-	rval = smiapp_register_subdevs(sensor);
-	if (rval)
-		smiapp_cleanup(sensor);
-
-	return rval;
-}
-
 static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct smiapp_subdev *ssd = to_smiapp_subdev(sd);
@@ -3065,11 +3052,9 @@ static int smiapp_probe(struct i2c_client *client,
 	sensor->src->sensor = sensor;
 	sensor->src->pads[0].flags = MEDIA_PAD_FL_SOURCE;
 
-	if (client->dev.of_node) {
-		rval = smiapp_init(sensor);
-		if (rval)
-			goto out_media_entity_cleanup;
-	}
+	rval = smiapp_init(sensor);
+	if (rval)
+		goto out_media_entity_cleanup;
 
 	rval = media_entity_pads_init(&sensor->src->sd.entity, 2,
 				 sensor->src->pads);
-- 
2.7.4

