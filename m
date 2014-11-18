Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46551 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752783AbaKRFoN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 00:44:13 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 1A34760098
	for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 07:44:10 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH v2 11/11] smiapp: Fully probe the device in probe
Date: Tue, 18 Nov 2014 07:43:46 +0200
Message-Id: <1416289426-804-12-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289426-804-1-git-send-email-sakari.ailus@iki.fi>
References: <1416289426-804-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the case of platform data, ISPs that provide clocks to the sensor must
probe before the sensor does. Accessing the sensor does require the clocks,
and thus, probe cannot access the sensor in such a system.

This limitation does not exist in the case of the DT. Perform all
initialisation except Media entity initialisation, link creation and
sub-device registration in probe.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   58 +++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 8663dfb..5c85b89 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2520,7 +2520,16 @@ static int smiapp_register_subdevs(struct v4l2_subdev *subdev)
 	return 0;
 }
 
-static int smiapp_registered(struct v4l2_subdev *subdev)
+static void smiapp_subdev_cleanup(struct v4l2_subdev *subdev)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+
+	device_remove_file(&client->dev, &dev_attr_nvm);
+	device_remove_file(&client->dev, &dev_attr_ident);
+}
+
+static int smiapp_subdev_init(struct v4l2_subdev *subdev)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	struct i2c_client *client = v4l2_get_subdevdata(subdev);
@@ -2649,13 +2658,13 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		if (sensor->nvm == NULL) {
 			dev_err(&client->dev, "nvm buf allocation failed\n");
 			rval = -ENOMEM;
-			goto out_ident_release;
+			goto out_cleanup;
 		}
 
 		if (device_create_file(&client->dev, &dev_attr_nvm) != 0) {
 			dev_err(&client->dev, "sysfs nvm entry failed\n");
 			rval = -EBUSY;
-			goto out_ident_release;
+			goto out_cleanup;
 		}
 	}
 
@@ -2699,7 +2708,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	rval = smiapp_get_mbus_formats(sensor);
 	if (rval) {
 		rval = -ENODEV;
-		goto out_nvm_release;
+		goto out_cleanup;
 	}
 
 	for (i = 0; i < SMIAPP_SUBDEVS; i++) {
@@ -2761,10 +2770,6 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		last = this;
 	}
 
-	rval = smiapp_register_subdevs(&sensor->src->sd);
-	if (rval)
-		goto out_nvm_release;
-
 	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
 
 	sensor->pixel_array->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
@@ -2773,14 +2778,14 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	smiapp_read_frame_fmt(sensor);
 	rval = smiapp_init_controls(sensor);
 	if (rval < 0)
-		goto out_nvm_release;
+		goto out_cleanup;
 
 	mutex_lock(&sensor->mutex);
 	rval = smiapp_update_mode(sensor);
 	mutex_unlock(&sensor->mutex);
 	if (rval) {
 		dev_err(&client->dev, "update mode failed\n");
-		goto out_nvm_release;
+		goto out_cleanup;
 	}
 
 	sensor->streaming = false;
@@ -2790,23 +2795,38 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	rval = smiapp_read(sensor, SMIAPP_REG_U8_FLASH_MODE_CAPABILITY, &tmp);
 	sensor->flash_capability = tmp;
 	if (rval)
-		goto out_nvm_release;
+		goto out_cleanup;
 
 	smiapp_power_off(sensor);
 
 	return 0;
 
-out_nvm_release:
-	device_remove_file(&client->dev, &dev_attr_nvm);
-
-out_ident_release:
-	device_remove_file(&client->dev, &dev_attr_ident);
+out_cleanup:
+	smiapp_subdev_cleanup(&sensor->src->sd);
 
 out_power_off:
 	smiapp_power_off(sensor);
 	return rval;
 }
 
+static int smiapp_registered(struct v4l2_subdev *subdev)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	int rval;
+
+	if (!client->dev.of_node) {
+		rval = smiapp_subdev_init(subdev);
+		if (rval)
+			return rval;
+	}
+
+	rval = smiapp_register_subdevs(subdev);
+	if (rval)
+		smiapp_subdev_cleanup(subdev);
+
+	return rval;
+}
+
 static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct smiapp_subdev *ssd = to_smiapp_subdev(sd);
@@ -3066,6 +3086,12 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		return rval;
 
+	if (client->dev.of_node) {
+		rval = smiapp_subdev_init(&sensor->src->sd);
+		if (rval)
+			goto out_media_entity_cleanup;
+	}
+
 	rval = v4l2_async_register_subdev(&sensor->src->sd);
 	if (rval < 0)
 		goto out_media_entity_cleanup;
-- 
1.7.10.4

