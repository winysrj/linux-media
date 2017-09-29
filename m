Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37648 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751800AbdI2KkI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 06:40:08 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1002])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 1CCF0600EC
        for <linux-media@vger.kernel.org>; Fri, 29 Sep 2017 13:40:07 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] smiapp: Rely on runtime PM
Date: Fri, 29 Sep 2017 13:40:06 +0300
Message-Id: <20170929104006.29892-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20170929104006.29892-1-sakari.ailus@linux.intel.com>
References: <20170929104006.29892-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of relying on a mix of runtime PM and the s_power() callback, drop
the s_power() callback altogether and use runtime PM solely.

As device access is required during device power-on and power-off
sequences, runtime PM alone cannot tell whether the device is available.
Thus the "active" field is introduced in struct smiapp_sensor to tell
whether it is safe to write to the device.

Consequently there is no need to power on the device whenever a file
handle is open. This functionality is removed as well. The user may still
control the device power management through sysfs. Autosuspend remains
enabled, with 1 s delay.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 101 ++++++++++++---------------------
 drivers/media/i2c/smiapp/smiapp-regs.c |   3 +
 drivers/media/i2c/smiapp/smiapp.h      |   1 +
 3 files changed, 40 insertions(+), 65 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 8de444080b8f..faf567569799 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1239,6 +1239,10 @@ static int smiapp_power_on(struct device *dev)
 	sleep = SMIAPP_RESET_DELAY(sensor->hwcfg->ext_clk);
 	usleep_range(sleep, sleep);
 
+	mutex_lock(&sensor->mutex);
+
+	sensor->active = true;
+
 	/*
 	 * Failures to respond to the address change command have been noticed.
 	 * Those failures seem to be caused by the sensor requiring a longer
@@ -1321,32 +1325,28 @@ static int smiapp_power_on(struct device *dev)
 		goto out_cci_addr_fail;
 	}
 
-	/* Are we still initialising...? If yes, return here. */
-	if (!sensor->pixel_array)
-		return 0;
-
-	mutex_lock(&sensor->mutex);
-
-	rval = __v4l2_ctrl_handler_setup(&sensor->pixel_array->ctrl_handler);
-	if (rval)
-		goto out_unlock;
+	/* Are we still initialising...? If not, proceed with control setup. */
+	if (sensor->pixel_array) {
+		rval = __v4l2_ctrl_handler_setup(
+			&sensor->pixel_array->ctrl_handler);
+		if (rval)
+			goto out_cci_addr_fail;
 
-	rval = __v4l2_ctrl_handler_setup(&sensor->src->ctrl_handler);
-	if (rval)
-		goto out_unlock;
+		rval = __v4l2_ctrl_handler_setup(&sensor->src->ctrl_handler);
+		if (rval)
+			goto out_cci_addr_fail;
 
-	rval = smiapp_update_mode(sensor);
-	if (rval < 0)
-		goto out_unlock;
+		rval = smiapp_update_mode(sensor);
+		if (rval < 0)
+			goto out_cci_addr_fail;
+	}
 
 	mutex_unlock(&sensor->mutex);
 
 	return 0;
 
-out_unlock:
-	mutex_unlock(&sensor->mutex);
-
 out_cci_addr_fail:
+	mutex_unlock(&sensor->mutex);
 	gpiod_set_value(sensor->xshutdown, 0);
 	clk_disable_unprepare(sensor->ext_clk);
 
@@ -1364,6 +1364,8 @@ static int smiapp_power_off(struct device *dev)
 	struct smiapp_sensor *sensor =
 		container_of(ssd, struct smiapp_sensor, ssds[0]);
 
+	mutex_lock(&sensor->mutex);
+
 	/*
 	 * Currently power/clock to lens are enable/disabled separately
 	 * but they are essentially the same signals. So if the sensor is
@@ -1376,6 +1378,10 @@ static int smiapp_power_off(struct device *dev)
 			     SMIAPP_REG_U8_SOFTWARE_RESET,
 			     SMIAPP_SOFTWARE_RESET);
 
+	sensor->active = false;
+
+	mutex_unlock(&sensor->mutex);
+
 	gpiod_set_value(sensor->xshutdown, 0);
 	clk_disable_unprepare(sensor->ext_clk);
 	usleep_range(5000, 5000);
@@ -1385,29 +1391,6 @@ static int smiapp_power_off(struct device *dev)
 	return 0;
 }
 
-static int smiapp_set_power(struct v4l2_subdev *subdev, int on)
-{
-	int rval;
-
-	if (!on) {
-		pm_runtime_mark_last_busy(subdev->dev);
-		pm_runtime_put_autosuspend(subdev->dev);
-
-		return 0;
-	}
-
-	rval = pm_runtime_get_sync(subdev->dev);
-	if (rval >= 0)
-		return 0;
-
-	if (rval != -EBUSY && rval != -EAGAIN)
-		pm_runtime_set_active(subdev->dev);
-
-	pm_runtime_put(subdev->dev);
-
-	return rval;
-}
-
 /* -----------------------------------------------------------------------------
  * Video stream management
  */
@@ -1564,19 +1547,31 @@ static int smiapp_stop_streaming(struct smiapp_sensor *sensor)
 static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	int rval;
 
 	if (sensor->streaming == enable)
 		return 0;
 
 	if (enable) {
+		rval = pm_runtime_get_sync(&client->dev);
+		if (rval < 0) {
+			if (rval != -EBUSY && rval != -EAGAIN)
+				pm_runtime_set_active(&client->dev);
+			pm_runtime_put(&client->dev);
+			return rval;
+		}
+
 		sensor->streaming = true;
+
 		rval = smiapp_start_streaming(sensor);
 		if (rval < 0)
 			sensor->streaming = false;
 	} else {
 		rval = smiapp_stop_streaming(sensor);
 		sensor->streaming = false;
+		pm_runtime_mark_last_busy(&client->dev);
+		pm_runtime_put_autosuspend(&client->dev);
 	}
 
 	return rval;
@@ -2654,7 +2649,6 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	struct smiapp_subdev *ssd = to_smiapp_subdev(sd);
 	struct smiapp_sensor *sensor = ssd->sensor;
 	unsigned int i;
-	int rval;
 
 	mutex_lock(&sensor->mutex);
 
@@ -2681,22 +2675,6 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 	mutex_unlock(&sensor->mutex);
 
-	rval = pm_runtime_get_sync(sd->dev);
-	if (rval >= 0)
-		return 0;
-
-	if (rval != -EBUSY && rval != -EAGAIN)
-		pm_runtime_set_active(sd->dev);
-	pm_runtime_put(sd->dev);
-
-	return rval;
-}
-
-static int smiapp_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
-{
-	pm_runtime_mark_last_busy(sd->dev);
-	pm_runtime_put_autosuspend(sd->dev);
-
 	return 0;
 }
 
@@ -2704,10 +2682,6 @@ static const struct v4l2_subdev_video_ops smiapp_video_ops = {
 	.s_stream = smiapp_set_stream,
 };
 
-static const struct v4l2_subdev_core_ops smiapp_core_ops = {
-	.s_power = smiapp_set_power,
-};
-
 static const struct v4l2_subdev_pad_ops smiapp_pad_ops = {
 	.enum_mbus_code = smiapp_enum_mbus_code,
 	.get_fmt = smiapp_get_format,
@@ -2722,7 +2696,6 @@ static const struct v4l2_subdev_sensor_ops smiapp_sensor_ops = {
 };
 
 static const struct v4l2_subdev_ops smiapp_ops = {
-	.core = &smiapp_core_ops,
 	.video = &smiapp_video_ops,
 	.pad = &smiapp_pad_ops,
 	.sensor = &smiapp_sensor_ops,
@@ -2736,12 +2709,10 @@ static const struct v4l2_subdev_internal_ops smiapp_internal_src_ops = {
 	.registered = smiapp_registered,
 	.unregistered = smiapp_unregistered,
 	.open = smiapp_open,
-	.close = smiapp_close,
 };
 
 static const struct v4l2_subdev_internal_ops smiapp_internal_ops = {
 	.open = smiapp_open,
-	.close = smiapp_close,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index d6779e35d36f..145653dc81da 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -231,6 +231,9 @@ int smiapp_write_no_quirk(struct smiapp_sensor *sensor, u32 reg, u32 val)
 	     len != SMIAPP_REG_32BIT) || flags)
 		return -EINVAL;
 
+	if (!sensor->active)
+		return 0;
+
 	msg.addr = client->addr;
 	msg.flags = 0; /* Write */
 	msg.len = 2 + len;
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index f74d695018b9..e6a5ab402d7f 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -206,6 +206,7 @@ struct smiapp_sensor {
 
 	u8 hvflip_inv_mask; /* H/VFLIP inversion due to sensor orientation */
 	u8 frame_skip;
+	bool active; /* is the sensor powered on? */
 	u16 embedded_start; /* embedded data start line */
 	u16 embedded_end;
 	u16 image_start; /* image data start line */
-- 
2.11.0
