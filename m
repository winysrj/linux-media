Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39278 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1764251AbcIOLWl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:22:41 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 1F9A0600A5
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:22:35 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 07/17] smiapp: Always initialise the sensor in probe
Date: Thu, 15 Sep 2016 14:22:21 +0300
Message-Id: <1473938551-14503-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 5d251b4..13322f3 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2530,8 +2530,19 @@ static int smiapp_register_subdev(struct smiapp_sensor *sensor,
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
 	int rval;
 
 	if (sensor->scaler) {
@@ -2540,23 +2551,18 @@ static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
 			SMIAPP_PAD_SRC, SMIAPP_PAD_SINK,
 			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
 		if (rval < 0)
-			return rval;
+			goto out_err;
 	}
 
 	return smiapp_register_subdev(
 		sensor, sensor->pixel_array, sensor->binner,
 		SMIAPP_PA_PAD_SRC, SMIAPP_PAD_SINK,
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
@@ -2817,25 +2823,6 @@ out_power_off:
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
@@ -3077,11 +3064,9 @@ static int smiapp_probe(struct i2c_client *client,
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
2.1.4

