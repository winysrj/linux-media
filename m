Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54368 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755361AbcIOWxd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 18:53:33 -0400
Received: from lanttu.localdomain (lanttu-e.localdomain [192.168.1.64])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 1E0F86009F
        for <linux-media@vger.kernel.org>; Fri, 16 Sep 2016 01:53:28 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v1.1 4/5] smiapp: Use runtime PM
Date: Fri, 16 Sep 2016 01:53:29 +0300
Message-Id: <1473980009-19377-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938961-16067-5-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938961-16067-5-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use runtime PM to manage power. The s_power() core sub-device callback is
removed as it is no longer needed.

The power management of the sensor is changed so that it is no longer
dependent on open file descriptors on sub-device or use_count in the media
entity but solely will be powered on as needed for probing and streaming.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v1:

- Both smiapp_set_ctrl() and smiapp_update_mode() perform work which is
  unrelated to the power state of the device. Instead, check the power
  state in smiapp_write() which is more appropriate.

- Don't explicitly disable streaming in smiapp_remove(). It'd be an
  unrelated change.

 drivers/media/i2c/smiapp/smiapp-core.c | 130 ++++++++++++++++-----------------
 drivers/media/i2c/smiapp/smiapp-regs.c |   5 ++
 drivers/media/i2c/smiapp/smiapp.h      |  11 +--
 3 files changed, 67 insertions(+), 79 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e1d1459..d7f3738 100644
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
@@ -1198,9 +1199,17 @@ out:
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
 
@@ -1326,6 +1335,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	return 0;
 
 out_cci_addr_fail:
+
 	gpiod_set_value(sensor->xshutdown, 0);
 	clk_disable_unprepare(sensor->ext_clk);
 
@@ -1334,8 +1344,14 @@ out_xclk_fail:
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
@@ -1353,31 +1369,8 @@ static void smiapp_power_off(struct smiapp_sensor *sensor)
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
@@ -1535,6 +1528,7 @@ out:
 
 static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	int rval;
 
@@ -1542,13 +1536,23 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
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
@@ -2308,13 +2312,15 @@ smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
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
@@ -2624,22 +2630,13 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
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
@@ -2654,7 +2651,6 @@ static const struct v4l2_subdev_sensor_ops smiapp_sensor_ops = {
 };
 
 static const struct v4l2_subdev_ops smiapp_ops = {
-	.core = &smiapp_core_ops,
 	.video = &smiapp_video_ops,
 	.pad = &smiapp_pad_ops,
 	.sensor = &smiapp_sensor_ops,
@@ -2667,12 +2663,10 @@ static const struct media_entity_operations smiapp_entity_ops = {
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
@@ -2686,18 +2680,18 @@ static int smiapp_suspend(struct device *dev)
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
 
@@ -2709,14 +2703,9 @@ static int smiapp_resume(struct device *dev)
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
@@ -2823,7 +2812,6 @@ static int smiapp_probe(struct i2c_client *client,
 
 	sensor->hwcfg = hwcfg;
 	mutex_init(&sensor->mutex);
-	mutex_init(&sensor->power_mutex);
 	sensor->src = &sensor->ssds[sensor->ssds_used];
 
 	v4l2_i2c_subdev_init(&sensor->src->sd, client, &smiapp_ops);
@@ -2855,9 +2843,13 @@ static int smiapp_probe(struct i2c_client *client,
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
@@ -3030,8 +3022,6 @@ static int smiapp_probe(struct i2c_client *client,
 	sensor->streaming = false;
 	sensor->dev_init_done = true;
 
-	smiapp_power_off(sensor);
-
 	rval = media_entity_pads_init(&sensor->src->sd.entity, 2,
 				 sensor->src->pads);
 	if (rval < 0)
@@ -3041,6 +3031,8 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		goto out_media_entity_cleanup;
 
+	pm_runtime_put(&client->dev);
+
 	return 0;
 
 out_media_entity_cleanup:
@@ -3050,7 +3042,9 @@ out_cleanup:
 	smiapp_cleanup(sensor);
 
 out_power_off:
-	smiapp_power_off(sensor);
+	pm_runtime_put(&client->dev);
+	pm_runtime_disable(&client->dev);
+
 	return rval;
 }
 
@@ -3062,11 +3056,8 @@ static int smiapp_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(subdev);
 
-	if (sensor->power_count) {
-		gpiod_set_value(sensor->xshutdown, 0);
-		clk_disable_unprepare(sensor->ext_clk);
-		sensor->power_count = 0;
-	}
+	pm_runtime_suspend(&client->dev);
+	pm_runtime_disable(&client->dev);
 
 	for (i = 0; i < sensor->ssds_used; i++) {
 		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);
@@ -3091,6 +3082,7 @@ MODULE_DEVICE_TABLE(i2c, smiapp_id_table);
 
 static const struct dev_pm_ops smiapp_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(smiapp_suspend, smiapp_resume)
+	SET_RUNTIME_PM_OPS(smiapp_power_off, smiapp_power_on, NULL)
 };
 
 static struct i2c_driver smiapp_i2c_driver = {
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index 1e501c0..a9c7baf 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -18,6 +18,7 @@
 
 #include <linux/delay.h>
 #include <linux/i2c.h>
+#include <linux/pm_runtime.h>
 
 #include "smiapp.h"
 #include "smiapp-regs.h"
@@ -288,8 +289,12 @@ int smiapp_write_no_quirk(struct smiapp_sensor *sensor, u32 reg, u32 val)
  */
 int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	int rval;
 
+	if (pm_runtime_suspended(&client->dev))
+		return 0;
+
 	rval = smiapp_call_quirk(sensor, reg_access, true, &reg, &val);
 	if (rval == -ENOIOCTLCMD)
 		return 0;
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

