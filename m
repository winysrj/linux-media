Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51524 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752245AbbBYMdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 07:33:44 -0500
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 4E7C8600A0
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2015 14:33:38 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 2/3] smiapp: Correctly serialise stream start / stop
Date: Wed, 25 Feb 2015 14:33:26 +0200
Message-Id: <1424867607-4082-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1424867607-4082-1-git-send-email-sakari.ailus@iki.fi>
References: <1424867607-4082-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The stream state was stored in sensor->streaming, but access to it was not
serialised properly. Fix this by moving the mutex to smiapp_set_stream().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   54 ++++++++++++++------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index d47eff5..e534f1b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1391,28 +1391,26 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	int rval;
 
-	mutex_lock(&sensor->mutex);
-
 	rval = smiapp_write(sensor, SMIAPP_REG_U16_CSI_DATA_FORMAT,
 			    (sensor->csi_format->width << 8) |
 			    sensor->csi_format->compressed);
 	if (rval)
-		goto out;
+		return rval;
 
 	rval = smiapp_pll_configure(sensor);
 	if (rval)
-		goto out;
+		return rval;
 
 	/* Analog crop start coordinates */
 	rval = smiapp_write(sensor, SMIAPP_REG_U16_X_ADDR_START,
 			    sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].left);
 	if (rval < 0)
-		goto out;
+		return rval;
 
 	rval = smiapp_write(sensor, SMIAPP_REG_U16_Y_ADDR_START,
 			    sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].top);
 	if (rval < 0)
-		goto out;
+		return rval;
 
 	/* Analog crop end coordinates */
 	rval = smiapp_write(
@@ -1420,14 +1418,14 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 		sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].left
 		+ sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width - 1);
 	if (rval < 0)
-		goto out;
+		return rval;
 
 	rval = smiapp_write(
 		sensor, SMIAPP_REG_U16_Y_ADDR_END,
 		sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].top
 		+ sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height - 1);
 	if (rval < 0)
-		goto out;
+		return rval;
 
 	/*
 	 * Output from pixel array, including blanking, is set using
@@ -1441,25 +1439,25 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 			sensor, SMIAPP_REG_U16_DIGITAL_CROP_X_OFFSET,
 			sensor->scaler->crop[SMIAPP_PAD_SINK].left);
 		if (rval < 0)
-			goto out;
+			return rval;
 
 		rval = smiapp_write(
 			sensor, SMIAPP_REG_U16_DIGITAL_CROP_Y_OFFSET,
 			sensor->scaler->crop[SMIAPP_PAD_SINK].top);
 		if (rval < 0)
-			goto out;
+			return rval;
 
 		rval = smiapp_write(
 			sensor, SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_WIDTH,
 			sensor->scaler->crop[SMIAPP_PAD_SINK].width);
 		if (rval < 0)
-			goto out;
+			return rval;
 
 		rval = smiapp_write(
 			sensor, SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_HEIGHT,
 			sensor->scaler->crop[SMIAPP_PAD_SINK].height);
 		if (rval < 0)
-			goto out;
+			return rval;
 	}
 
 	/* Scaling */
@@ -1468,23 +1466,23 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 		rval = smiapp_write(sensor, SMIAPP_REG_U16_SCALING_MODE,
 				    sensor->scaling_mode);
 		if (rval < 0)
-			goto out;
+			return rval;
 
 		rval = smiapp_write(sensor, SMIAPP_REG_U16_SCALE_M,
 				    sensor->scale_m);
 		if (rval < 0)
-			goto out;
+			return rval;
 	}
 
 	/* Output size from sensor */
 	rval = smiapp_write(sensor, SMIAPP_REG_U16_X_OUTPUT_SIZE,
 			    sensor->src->crop[SMIAPP_PAD_SRC].width);
 	if (rval < 0)
-		goto out;
+		return rval;
 	rval = smiapp_write(sensor, SMIAPP_REG_U16_Y_OUTPUT_SIZE,
 			    sensor->src->crop[SMIAPP_PAD_SRC].height);
 	if (rval < 0)
-		goto out;
+		return rval;
 
 	if ((sensor->limits[SMIAPP_LIMIT_FLASH_MODE_CAPABILITY] &
 	     (SMIAPP_FLASH_MODE_CAPABILITY_SINGLE_STROBE |
@@ -1493,22 +1491,17 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 	    sensor->platform_data->strobe_setup->trigger != 0) {
 		rval = smiapp_setup_flash_strobe(sensor);
 		if (rval)
-			goto out;
+			return rval;
 	}
 
 	rval = smiapp_call_quirk(sensor, pre_streamon);
 	if (rval) {
 		dev_err(&client->dev, "pre_streamon quirks failed\n");
-		goto out;
+		return rval;
 	}
 
-	rval = smiapp_write(sensor, SMIAPP_REG_U8_MODE_SELECT,
+	return smiapp_write(sensor, SMIAPP_REG_U8_MODE_SELECT,
 			    SMIAPP_MODE_SELECT_STREAMING);
-
-out:
-	mutex_unlock(&sensor->mutex);
-
-	return rval;
 }
 
 static int smiapp_stop_streaming(struct smiapp_sensor *sensor)
@@ -1516,18 +1509,15 @@ static int smiapp_stop_streaming(struct smiapp_sensor *sensor)
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	int rval;
 
-	mutex_lock(&sensor->mutex);
 	rval = smiapp_write(sensor, SMIAPP_REG_U8_MODE_SELECT,
 			    SMIAPP_MODE_SELECT_SOFTWARE_STANDBY);
 	if (rval)
-		goto out;
+		return rval;
 
 	rval = smiapp_call_quirk(sensor, post_streamoff);
 	if (rval)
 		dev_err(&client->dev, "post_streamoff quirks failed\n");
 
-out:
-	mutex_unlock(&sensor->mutex);
 	return rval;
 }
 
@@ -1538,10 +1528,12 @@ out:
 static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
-	int rval;
+	int rval = 0;
+
+	mutex_lock(&sensor->mutex);
 
 	if (sensor->streaming == enable)
-		return 0;
+		goto out;
 
 	if (enable) {
 		sensor->streaming = true;
@@ -1553,6 +1545,8 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
 		sensor->streaming = false;
 	}
 
+out:
+	mutex_unlock(&sensor->mutex);
 	return rval;
 }
 
-- 
1.7.10.4

