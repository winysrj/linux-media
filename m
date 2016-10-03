Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50222 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751365AbcJCIzr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Oct 2016 04:55:47 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v1.2 4/5] smiapp: Use runtime PM
Date: Mon,  3 Oct 2016 11:55:43 +0300
Message-Id: <1475484943-20374-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473980009-19377-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473980009-19377-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to runtime PM in sensor power management. The internal power count
is thus removed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v1.1:

- Keep the behaviour the same, i.e. the sensor is powered on through open
  file descriptors or s_power() callback.

 drivers/media/i2c/smiapp/smiapp-core.c | 131 +++++++++++++++++++++------------
 drivers/media/i2c/smiapp/smiapp.h      |  11 +--
 2 files changed, 83 insertions(+), 59 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 88ad4b9..68adc1b 100644
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
@@ -1202,9 +1203,17 @@ out:
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
 
@@ -1330,16 +1339,24 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	return 0;
 
 out_cci_addr_fail:
+
 	gpiod_set_value(sensor->xshutdown, 0);
 	clk_disable_unprepare(sensor->ext_clk);
 
 out_xclk_fail:
 	regulator_disable(sensor->vana);
+
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
@@ -1357,31 +1374,26 @@ static void smiapp_power_off(struct smiapp_sensor *sensor)
 	usleep_range(5000, 5000);
 	regulator_disable(sensor->vana);
 	sensor->streaming = false;
+
+	return 0;
 }
 
 static int smiapp_set_power(struct v4l2_subdev *subdev, int on)
 {
-	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
-	int ret = 0;
+	int rval = 0;
 
-	mutex_lock(&sensor->power_mutex);
+	if (on) {
+		rval = pm_runtime_get_sync(subdev->dev);
+		if (rval >= 0)
+			return 0;
 
-	if (on && !sensor->power_count) {
-		/* Power on and perform initialisation. */
-		ret = smiapp_power_on(sensor);
-		if (ret < 0)
-			goto out;
-	} else if (!on && sensor->power_count == 1) {
-		smiapp_power_off(sensor);
+		if (rval != -EBUSY && rval != -EAGAIN)
+			pm_runtime_set_active(subdev->dev);
 	}
 
-	/* Update the power count. */
-	sensor->power_count += on ? 1 : -1;
-	WARN_ON(sensor->power_count < 0);
+	pm_runtime_put(subdev->dev);
 
-out:
-	mutex_unlock(&sensor->power_mutex);
-	return ret;
+	return rval;
 }
 
 /* -----------------------------------------------------------------------------
@@ -2310,15 +2322,25 @@ smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
 		return -EBUSY;
 
 	if (!sensor->nvm_size) {
+		int rval;
+
 		/* NVM not read yet - read it now */
 		sensor->nvm_size = sensor->hwcfg->nvm_size;
-		if (smiapp_set_power(subdev, 1) < 0)
+
+		rval = pm_runtime_get_sync(&client->dev);
+		if (rval < 0) {
+			if (rval != -EBUSY && rval != -EAGAIN)
+				pm_runtime_set_active(&client->dev);
+			pm_runtime_put(&client->dev);
 			return -ENODEV;
+		}
+
 		if (smiapp_read_nvm(sensor, sensor->nvm)) {
 			dev_err(&client->dev, "nvm read failed\n");
 			return -ENODEV;
 		}
-		smiapp_set_power(subdev, 0);
+
+		pm_runtime_put(&client->dev);
 	}
 	/*
 	 * NVM is still way below a PAGE_SIZE, so we can safely
@@ -2619,6 +2641,7 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	struct smiapp_subdev *ssd = to_smiapp_subdev(sd);
 	struct smiapp_sensor *sensor = ssd->sensor;
 	unsigned int i;
+	int rval;
 
 	mutex_lock(&sensor->mutex);
 
@@ -2645,12 +2668,22 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 	mutex_unlock(&sensor->mutex);
 
-	return smiapp_set_power(sd, 1);
+	rval = pm_runtime_get_sync(sd->dev);
+	if (rval >= 0)
+		return 0;
+
+	if (rval != -EBUSY && rval != -EAGAIN)
+		pm_runtime_set_active(sd->dev);
+	pm_runtime_put(sd->dev);
+
+	return rval;
 }
 
 static int smiapp_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	return smiapp_set_power(sd, 0);
+	pm_runtime_put(sd->dev);
+
+	return 0;
 }
 
 static const struct v4l2_subdev_video_ops smiapp_video_ops = {
@@ -2708,18 +2741,20 @@ static int smiapp_suspend(struct device *dev)
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
+		if (rval != -EBUSY && rval != -EAGAIN)
+			pm_runtime_set_active(&client->dev);
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
 
@@ -2731,14 +2766,9 @@ static int smiapp_resume(struct device *dev)
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
@@ -2845,7 +2875,6 @@ static int smiapp_probe(struct i2c_client *client,
 
 	sensor->hwcfg = hwcfg;
 	mutex_init(&sensor->mutex);
-	mutex_init(&sensor->power_mutex);
 	sensor->src = &sensor->ssds[sensor->ssds_used];
 
 	v4l2_i2c_subdev_init(&sensor->src->sd, client, &smiapp_ops);
@@ -2877,9 +2906,13 @@ static int smiapp_probe(struct i2c_client *client,
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
@@ -3051,8 +3084,6 @@ static int smiapp_probe(struct i2c_client *client,
 	sensor->streaming = false;
 	sensor->dev_init_done = true;
 
-	smiapp_power_off(sensor);
-
 	rval = media_entity_pads_init(&sensor->src->sd.entity, 2,
 				 sensor->src->pads);
 	if (rval < 0)
@@ -3062,6 +3093,8 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		goto out_media_entity_cleanup;
 
+	pm_runtime_put(&client->dev);
+
 	return 0;
 
 out_media_entity_cleanup:
@@ -3071,7 +3104,9 @@ out_cleanup:
 	smiapp_cleanup(sensor);
 
 out_power_off:
-	smiapp_power_off(sensor);
+	pm_runtime_put(&client->dev);
+	pm_runtime_disable(&client->dev);
+
 	return rval;
 }
 
@@ -3083,11 +3118,8 @@ static int smiapp_remove(struct i2c_client *client)
 
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
@@ -3112,6 +3144,7 @@ MODULE_DEVICE_TABLE(i2c, smiapp_id_table);
 
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

