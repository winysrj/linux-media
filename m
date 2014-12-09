Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53112 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755261AbaLIAEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 19:04:51 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, mark.rutland@arm.com
Subject: [REVIEW PATCH v3 12/12] smiapp: Fully probe the device in probe
Date: Tue,  9 Dec 2014 02:04:20 +0200
Message-Id: <1418083460-28556-13-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
References: <1418083460-28556-1-git-send-email-sakari.ailus@iki.fi>
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
 drivers/media/i2c/smiapp/smiapp-core.c |   68 +++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 22 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index c2bf718..48e1a1f 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2334,10 +2334,9 @@ static DEVICE_ATTR(ident, S_IRUGO, smiapp_sysfs_ident_read, NULL);
  * V4L2 subdev core operations
  */
 
-static int smiapp_identify_module(struct v4l2_subdev *subdev)
+static int smiapp_identify_module(struct smiapp_sensor *sensor)
 {
-	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
-	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct smiapp_module_info *minfo = &sensor->minfo;
 	unsigned int i;
 	int rval = 0;
@@ -2517,10 +2516,17 @@ static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
 	return 0;
 }
 
-static int smiapp_registered(struct v4l2_subdev *subdev)
+static void smiapp_cleanup(struct smiapp_sensor *sensor)
 {
-	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
-	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+
+	device_remove_file(&client->dev, &dev_attr_nvm);
+	device_remove_file(&client->dev, &dev_attr_ident);
+}
+
+static int smiapp_init(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct smiapp_pll *pll = &sensor->pll;
 	struct smiapp_subdev *last = NULL;
 	u32 tmp;
@@ -2566,7 +2572,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	if (rval)
 		return -ENODEV;
 
-	rval = smiapp_identify_module(subdev);
+	rval = smiapp_identify_module(sensor);
 	if (rval) {
 		rval = -ENODEV;
 		goto out_power_off;
@@ -2646,13 +2652,13 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
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
 
@@ -2696,7 +2702,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	rval = smiapp_get_mbus_formats(sensor);
 	if (rval) {
 		rval = -ENODEV;
-		goto out_nvm_release;
+		goto out_cleanup;
 	}
 
 	for (i = 0; i < SMIAPP_SUBDEVS; i++) {
@@ -2758,10 +2764,6 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		last = this;
 	}
 
-	rval = smiapp_register_subdevs(sensor);
-	if (rval)
-		goto out_nvm_release;
-
 	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
 
 	sensor->pixel_array->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
@@ -2770,14 +2772,14 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
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
@@ -2787,23 +2789,39 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
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
+	smiapp_cleanup(sensor);
 
 out_power_off:
 	smiapp_power_off(sensor);
 	return rval;
 }
 
+static int smiapp_registered(struct v4l2_subdev *subdev)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	int rval;
+
+	if (!client->dev.of_node) {
+		rval = smiapp_init(sensor);
+		if (rval)
+			return rval;
+	}
+
+	rval = smiapp_register_subdevs(sensor);
+	if (rval)
+		smiapp_cleanup(sensor);
+
+	return rval;
+}
+
 static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct smiapp_subdev *ssd = to_smiapp_subdev(sd);
@@ -3077,6 +3095,12 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		return rval;
 
+	if (client->dev.of_node) {
+		rval = smiapp_init(sensor);
+		if (rval)
+			goto out_media_entity_cleanup;
+	}
+
 	rval = v4l2_async_register_subdev(&sensor->src->sd);
 	if (rval < 0)
 		goto out_media_entity_cleanup;
-- 
1.7.10.4

