Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39656 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933721AbcIOL33 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:29:29 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id B69C1600A4
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:29:25 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] smiapp: Use runtime PM
Date: Thu, 15 Sep 2016 14:29:20 +0300
Message-Id: <1473938961-16067-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use runtime PM to manage power. The s_power() core sub-device callback is
removed as it is no longer needed.

The power management of the sensor is changed so that it is no longer
dependent on open file descriptors on sub-device or use_count in the media
entity but solely will be powered on as needed for probing and streaming.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 139 +++++++++++++++++----------------
 drivers/media/i2c/smiapp/smiapp.h      |  11 +--
 2 files changed, 71 insertions(+), 79 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e1d1459..ba5ad36 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -26,6 +26,7 @@
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <linux/module.h>
+#include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/smiapp.h>
@@ -415,10 +416,14 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 	struct smiapp_sensor *sensor =
 		container_of(ctrl->handler, struct smiapp_subdev, ctrl_handler)
 			->sensor;
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	u32 orient = 0;
 	int exposure;
 	int rval;
 
+	if (pm_runtime_suspended(&client->dev))
+		return 0;
+
 	switch (ctrl->id) {
 	case V4L2_CID_ANALOGUE_GAIN:
 		return smiapp_write(
@@ -922,6 +927,9 @@ static int smiapp_update_mode(struct smiapp_sensor *sensor)
 	unsigned int binning_mode;
 	int rval;
 
+	if (pm_runtime_suspended(&client->dev))
+		return 0;
+
 	/* Binning has to be set up here; it affects limits */
 	if (sensor->binning_horizontal == 1 &&
 	    sensor->binning_vertical == 1) {
@@ -1198,9 +1206,17 @@ out:
  * Power management
  */
 
-static int smiapp_power_on(struct smiapp_sensor *sensor)
+static int smiapp_power_on(struct device *dev)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
+	/*
+	 * The sub-device related to the I2C device is always the
+	 * source one, i.e. ssds[0].
+	 */
+	struct smiapp_sensor *sensor =
+		container_of(ssd, struct smiapp_sensor, ssds[0]);
 	unsigned int sleep;
 	int rval;
 
@@ -1326,6 +1342,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	return 0;
 
 out_cci_addr_fail:
+
 	gpiod_set_value(sensor->xshutdown, 0);
 	clk_disable_unprepare(sensor->ext_clk);
 
@@ -1334,8 +1351,14 @@ out_xclk_fail:
 	return rval;
 }
 
-static void smiapp_power_off(struct smiapp_sensor *sensor)
+static int smiapp_power_off(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
+	struct smiapp_sensor *sensor =
+		container_of(ssd, struct smiapp_sensor, ssds[0]);
+
 	/*
 	 * Currently power/clock to lens are enable/disabled separately
 	 * but they are essentially the same signals. So if the sensor is
@@ -1353,31 +1376,8 @@ static void smiapp_power_off(struct smiapp_sensor *sensor)
 	usleep_range(5000, 5000);
 	regulator_disable(sensor->vana);
 	sensor->streaming = false;
-}
-
-static int smiapp_set_power(struct v4l2_subdev *subdev, int on)
-{
-	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
-	int ret = 0;
-
-	mutex_lock(&sensor->power_mutex);
-
-	if (on && !sensor->power_count) {
-		/* Power on and perform initialisation. */
-		ret = smiapp_power_on(sensor);
-		if (ret < 0)
-			goto out;
-	} else if (!on && sensor->power_count == 1) {
-		smiapp_power_off(sensor);
-	}
-
-	/* Update the power count. */
-	sensor->power_count += on ? 1 : -1;
-	WARN_ON(sensor->power_count < 0);
 
-out:
-	mutex_unlock(&sensor->power_mutex);
-	return ret;
+	return 0;
 }
 
 /* -----------------------------------------------------------------------------
@@ -1535,6 +1535,7 @@ out:
 
 static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	int rval;
 
@@ -1542,13 +1543,23 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
 		return 0;
 
 	if (enable) {
+		rval = pm_runtime_get_sync(&client->dev);
+		if (rval < 0) {
+			pm_runtime_put(&client->dev);
+			return rval;
+		}
+
 		sensor->streaming = true;
 		rval = smiapp_start_streaming(sensor);
-		if (rval < 0)
+		if (rval < 0) {
+			pm_runtime_put(&client->dev);
 			sensor->streaming = false;
+		}
 	} else {
 		rval = smiapp_stop_streaming(sensor);
 		sensor->streaming = false;
+
+		pm_runtime_put(&client->dev);
 	}
 
 	return rval;
@@ -2308,13 +2319,15 @@ smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
 	if (!sensor->nvm_size) {
 		/* NVM not read yet - read it now */
 		sensor->nvm_size = sensor->hwcfg->nvm_size;
-		if (smiapp_set_power(subdev, 1) < 0)
+		if (pm_runtime_get_sync(&client->dev) < 0) {
+			pm_runtime_put(&client->dev);
 			return -ENODEV;
+		}
 		if (smiapp_read_nvm(sensor, sensor->nvm)) {
 			dev_err(&client->dev, "nvm read failed\n");
 			return -ENODEV;
 		}
-		smiapp_set_power(subdev, 0);
+		pm_runtime_put(&client->dev);
 	}
 	/*
 	 * NVM is still way below a PAGE_SIZE, so we can safely
@@ -2624,22 +2637,13 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 	mutex_unlock(&sensor->mutex);
 
-	return smiapp_set_power(sd, 1);
-}
-
-static int smiapp_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
-{
-	return smiapp_set_power(sd, 0);
+	return 0;
 }
 
 static const struct v4l2_subdev_video_ops smiapp_video_ops = {
 	.s_stream = smiapp_set_stream,
 };
 
-static const struct v4l2_subdev_core_ops smiapp_core_ops = {
-	.s_power = smiapp_set_power,
-};
-
 static const struct v4l2_subdev_pad_ops smiapp_pad_ops = {
 	.enum_mbus_code = smiapp_enum_mbus_code,
 	.get_fmt = smiapp_get_format,
@@ -2654,7 +2658,6 @@ static const struct v4l2_subdev_sensor_ops smiapp_sensor_ops = {
 };
 
 static const struct v4l2_subdev_ops smiapp_ops = {
-	.core = &smiapp_core_ops,
 	.video = &smiapp_video_ops,
 	.pad = &smiapp_pad_ops,
 	.sensor = &smiapp_sensor_ops,
@@ -2667,12 +2670,10 @@ static const struct media_entity_operations smiapp_entity_ops = {
 static const struct v4l2_subdev_internal_ops smiapp_internal_src_ops = {
 	.registered = smiapp_registered,
 	.open = smiapp_open,
-	.close = smiapp_close,
 };
 
 static const struct v4l2_subdev_internal_ops smiapp_internal_ops = {
 	.open = smiapp_open,
-	.close = smiapp_close,
 };
 
 /* -----------------------------------------------------------------------------
@@ -2686,18 +2687,18 @@ static int smiapp_suspend(struct device *dev)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
-	bool streaming;
+	bool streaming = sensor->streaming;
+	int rval;
 
-	if (sensor->power_count == 0)
-		return 0;
+	rval = pm_runtime_get_sync(dev);
+	if (rval < 0) {
+		pm_runtime_put(dev);
+		return -EAGAIN;
+	}
 
 	if (sensor->streaming)
 		smiapp_stop_streaming(sensor);
 
-	streaming = sensor->streaming;
-
-	smiapp_power_off(sensor);
-
 	/* save state for resume */
 	sensor->streaming = streaming;
 
@@ -2709,14 +2710,9 @@ static int smiapp_resume(struct device *dev)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
-	int rval;
-
-	if (sensor->power_count == 0)
-		return 0;
+	int rval = 0;
 
-	rval = smiapp_power_on(sensor);
-	if (rval)
-		return rval;
+	pm_runtime_put(dev);
 
 	if (sensor->streaming)
 		rval = smiapp_start_streaming(sensor);
@@ -2823,7 +2819,6 @@ static int smiapp_probe(struct i2c_client *client,
 
 	sensor->hwcfg = hwcfg;
 	mutex_init(&sensor->mutex);
-	mutex_init(&sensor->power_mutex);
 	sensor->src = &sensor->ssds[sensor->ssds_used];
 
 	v4l2_i2c_subdev_init(&sensor->src->sd, client, &smiapp_ops);
@@ -2855,9 +2850,13 @@ static int smiapp_probe(struct i2c_client *client,
 	if (IS_ERR(sensor->xshutdown))
 		return PTR_ERR(sensor->xshutdown);
 
-	rval = smiapp_power_on(sensor);
-	if (rval)
-		return -ENODEV;
+	pm_runtime_enable(&client->dev);
+
+	rval = pm_runtime_get_sync(&client->dev);
+	if (rval < 0) {
+		rval = -ENODEV;
+		goto out_power_off;
+	}
 
 	rval = smiapp_identify_module(sensor);
 	if (rval) {
@@ -3030,8 +3029,6 @@ static int smiapp_probe(struct i2c_client *client,
 	sensor->streaming = false;
 	sensor->dev_init_done = true;
 
-	smiapp_power_off(sensor);
-
 	rval = media_entity_pads_init(&sensor->src->sd.entity, 2,
 				 sensor->src->pads);
 	if (rval < 0)
@@ -3041,6 +3038,8 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		goto out_media_entity_cleanup;
 
+	pm_runtime_put(&client->dev);
+
 	return 0;
 
 out_media_entity_cleanup:
@@ -3050,7 +3049,9 @@ out_cleanup:
 	smiapp_cleanup(sensor);
 
 out_power_off:
-	smiapp_power_off(sensor);
+	pm_runtime_put(&client->dev);
+	pm_runtime_disable(&client->dev);
+
 	return rval;
 }
 
@@ -3062,11 +3063,7 @@ static int smiapp_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(subdev);
 
-	if (sensor->power_count) {
-		gpiod_set_value(sensor->xshutdown, 0);
-		clk_disable_unprepare(sensor->ext_clk);
-		sensor->power_count = 0;
-	}
+	smiapp_set_stream(subdev, 0);
 
 	for (i = 0; i < sensor->ssds_used; i++) {
 		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);
@@ -3074,6 +3071,9 @@ static int smiapp_remove(struct i2c_client *client)
 	}
 	smiapp_cleanup(sensor);
 
+	pm_runtime_suspend(&client->dev);
+	pm_runtime_disable(&client->dev);
+
 	return 0;
 }
 
@@ -3091,6 +3091,7 @@ MODULE_DEVICE_TABLE(i2c, smiapp_id_table);
 
 static const struct dev_pm_ops smiapp_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(smiapp_suspend, smiapp_resume)
+	SET_RUNTIME_PM_OPS(smiapp_power_off, smiapp_power_on, NULL)
 };
 
 static struct i2c_driver smiapp_i2c_driver = {
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index d7b52a6..f74d695 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -176,16 +176,9 @@ struct smiapp_sensor {
 	 * "mutex" is used to serialise access to all fields here
 	 * except v4l2_ctrls at the end of the struct. "mutex" is also
 	 * used to serialise access to file handle specific
-	 * information. The exception to this rule is the power_mutex
-	 * below.
+	 * information.
 	 */
 	struct mutex mutex;
-	/*
-	 * power_mutex is used to serialise power management related
-	 * activities. Acquiring "mutex" at that time isn't necessary
-	 * since there are no other users anyway.
-	 */
-	struct mutex power_mutex;
 	struct smiapp_subdev ssds[SMIAPP_SUBDEVS];
 	u32 ssds_used;
 	struct smiapp_subdev *src;
@@ -218,8 +211,6 @@ struct smiapp_sensor {
 	u16 image_start; /* image data start line */
 	u16 visible_pixel_start; /* start pixel of the visible image */
 
-	int power_count;
-
 	bool streaming;
 	bool dev_init_done;
 	u8 compressed_min_bpp;
-- 
2.1.4

