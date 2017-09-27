Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:37265 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbdI0SZR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:25:17 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 09/13] staging: atomisp: Remove unused members of camera_sensor_platform_data
Date: Wed, 27 Sep 2017 21:25:04 +0300
Message-Id: <20170927182508.52119-10-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
References: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused members along with dead code.

Mostly done with help of coccinelle.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/gc0310.c                  | 13 -------------
 drivers/staging/media/atomisp/i2c/gc2235.c                  | 13 -------------
 drivers/staging/media/atomisp/i2c/mt9m114.c                 |  9 ---------
 drivers/staging/media/atomisp/i2c/ov2722.c                  | 13 -------------
 drivers/staging/media/atomisp/i2c/ov8858.c                  | 13 -------------
 .../staging/media/atomisp/include/linux/atomisp_platform.h  |  5 -----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c   |  9 +--------
 .../atomisp/platform/intel-mid/atomisp_gmin_platform.c      | 12 ------------
 8 files changed, 1 insertion(+), 86 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index b6b1956293c0..0b32c8a94e5c 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -1156,13 +1156,6 @@ static int gc0310_s_config(struct v4l2_subdev *sd,
 		(struct camera_sensor_platform_data *)platform_data;
 
 	mutex_lock(&dev->input_lock);
-	if (dev->platform_data->platform_init) {
-		ret = dev->platform_data->platform_init(client);
-		if (ret) {
-			dev_err(&client->dev, "platform init err\n");
-			goto platform_init_failed;
-		}
-	}
 	/* power off the module, then power on it in future
 	 * as first power on by board may not fulfill the
 	 * power on sequqence needed by the module
@@ -1207,9 +1200,6 @@ static int gc0310_s_config(struct v4l2_subdev *sd,
 	power_down(sd);
 	dev_err(&client->dev, "sensor power-gating failed\n");
 fail_power_off:
-	if (dev->platform_data->platform_deinit)
-		dev->platform_data->platform_deinit();
-platform_init_failed:
 	mutex_unlock(&dev->input_lock);
 	return ret;
 }
@@ -1353,9 +1343,6 @@ static int gc0310_remove(struct i2c_client *client)
 	struct gc0310_device *dev = to_gc0310_sensor(sd);
 	dev_dbg(&client->dev, "gc0310_remove...\n");
 
-	if (dev->platform_data->platform_deinit)
-		dev->platform_data->platform_deinit();
-
 	dev->platform_data->csi_cfg(sd, 0);
 
 	v4l2_device_unregister_subdev(sd);
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 46e063dcdc19..bcfcdc220803 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -897,13 +897,6 @@ static int gc2235_s_config(struct v4l2_subdev *sd,
 		(struct camera_sensor_platform_data *)platform_data;
 
 	mutex_lock(&dev->input_lock);
-	if (dev->platform_data->platform_init) {
-		ret = dev->platform_data->platform_init(client);
-		if (ret) {
-			dev_err(&client->dev, "platform init err\n");
-			goto platform_init_failed;
-		}
-	}
 	/* power off the module, then power on it in future
 	 * as first power on by board may not fulfill the
 	 * power on sequqence needed by the module
@@ -947,9 +940,6 @@ static int gc2235_s_config(struct v4l2_subdev *sd,
 	power_down(sd);
 	dev_err(&client->dev, "sensor power-gating failed\n");
 fail_power_off:
-	if (dev->platform_data->platform_deinit)
-		dev->platform_data->platform_deinit();
-platform_init_failed:
 	mutex_unlock(&dev->input_lock);
 	return ret;
 }
@@ -1092,9 +1082,6 @@ static int gc2235_remove(struct i2c_client *client)
 	struct gc2235_device *dev = to_gc2235_sensor(sd);
 	dev_dbg(&client->dev, "gc2235_remove...\n");
 
-	if (dev->platform_data->platform_deinit)
-		dev->platform_data->platform_deinit();
-
 	dev->platform_data->csi_cfg(sd, 0);
 
 	v4l2_device_unregister_subdev(sd);
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 950627efa977..09018d5ccaf2 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -1575,13 +1575,6 @@ mt9m114_s_config(struct v4l2_subdev *sd, int irq, void *platform_data)
 	dev->platform_data =
 	    (struct camera_sensor_platform_data *)platform_data;
 
-	if (dev->platform_data->platform_init) {
-		ret = dev->platform_data->platform_init(client);
-		if (ret) {
-			v4l2_err(client, "mt9m114 platform init err\n");
-			return ret;
-		}
-	}
 	ret = power_up(sd);
 	if (ret) {
 		v4l2_err(client, "mt9m114 power-up err");
@@ -1835,8 +1828,6 @@ static int mt9m114_remove(struct i2c_client *client)
 
 	dev = container_of(sd, struct mt9m114_device, sd);
 	dev->platform_data->csi_cfg(sd, 0);
-	if (dev->platform_data->platform_deinit)
-		dev->platform_data->platform_deinit();
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&dev->sd.entity);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.c b/drivers/staging/media/atomisp/i2c/ov2722.c
index 39296a784162..c348a93c4100 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/ov2722.c
@@ -1035,13 +1035,6 @@ static int ov2722_s_config(struct v4l2_subdev *sd,
 		(struct camera_sensor_platform_data *)platform_data;
 
 	mutex_lock(&dev->input_lock);
-	if (dev->platform_data->platform_init) {
-		ret = dev->platform_data->platform_init(client);
-		if (ret) {
-			dev_err(&client->dev, "platform init err\n");
-			goto platform_init_failed;
-		}
-	}
 
 	/* power off the module, then power on it in future
 	 * as first power on by board may not fulfill the
@@ -1086,9 +1079,6 @@ static int ov2722_s_config(struct v4l2_subdev *sd,
 	power_down(sd);
 	dev_err(&client->dev, "sensor power-gating failed\n");
 fail_power_off:
-	if (dev->platform_data->platform_deinit)
-		dev->platform_data->platform_deinit();
-platform_init_failed:
 	mutex_unlock(&dev->input_lock);
 	return ret;
 }
@@ -1232,9 +1222,6 @@ static int ov2722_remove(struct i2c_client *client)
 	struct ov2722_device *dev = to_ov2722_sensor(sd);
 	dev_dbg(&client->dev, "ov2722_remove...\n");
 
-	if (dev->platform_data->platform_deinit)
-		dev->platform_data->platform_deinit();
-
 	dev->platform_data->csi_cfg(sd, 0);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_device_unregister_subdev(sd);
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.c b/drivers/staging/media/atomisp/i2c/ov8858.c
index a13bbfb44652..51bda5c73128 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.c
+++ b/drivers/staging/media/atomisp/i2c/ov8858.c
@@ -1567,15 +1567,6 @@ static int ov8858_s_config(struct v4l2_subdev *sd,
 
 	mutex_lock(&dev->input_lock);
 
-	if (dev->platform_data->platform_init) {
-		ret = dev->platform_data->platform_init(client);
-		if (ret) {
-			mutex_unlock(&dev->input_lock);
-			dev_err(&client->dev, "platform init error %d!\n", ret);
-			return ret;
-		}
-	}
-
 	ret = __ov8858_s_power(sd, 1);
 	if (ret) {
 		dev_err(&client->dev, "power-up error %d!\n", ret);
@@ -1620,8 +1611,6 @@ static int ov8858_s_config(struct v4l2_subdev *sd,
 fail_csi_cfg:
 	__ov8858_s_power(sd, 0);
 fail_update:
-	if (dev->platform_data->platform_deinit)
-		dev->platform_data->platform_deinit();
 	mutex_unlock(&dev->input_lock);
 	dev_err(&client->dev, "sensor power-gating failed\n");
 	return ret;
@@ -1922,8 +1911,6 @@ static int ov8858_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct ov8858_device *dev = to_ov8858_sensor(sd);
-	if (dev->platform_data->platform_deinit)
-		dev->platform_data->platform_deinit();
 
 	media_entity_cleanup(&dev->sd.entity);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
index 5ce8678dacf3..a8c1825e1d0d 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
@@ -207,11 +207,6 @@ struct camera_vcm_control {
 struct camera_sensor_platform_data {
 	int (*flisclk_ctrl)(struct v4l2_subdev *subdev, int flag);
 	int (*csi_cfg)(struct v4l2_subdev *subdev, int flag);
-	bool (*low_fps)(void);
-	int (*platform_init)(struct i2c_client *);
-	int (*platform_deinit)(void);
-	char *(*msr_file_name)(void);
-	struct atomisp_camera_caps *(*get_camera_caps)(void);
 
 	/*
 	 * New G-Min power and GPIO interface to control individual
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index e85b3819bffa..5a6dd3789acd 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -750,7 +750,6 @@ static int atomisp_subdev_probe(struct atomisp_device *isp)
 			&subdevs->v4l2_subdev.board_info;
 		struct i2c_adapter *adapter =
 			i2c_get_adapter(subdevs->v4l2_subdev.i2c_adapter_id);
-		struct camera_sensor_platform_data *sensor_pdata;
 		int sensor_num, i;
 
 		if (adapter == NULL) {
@@ -802,13 +801,7 @@ static int atomisp_subdev_probe(struct atomisp_device *isp)
 			 * pixel_format.
 			 */
 			isp->inputs[isp->input_cnt].frame_size.pixel_format = 0;
-			sensor_pdata = (struct camera_sensor_platform_data *)
-					board_info->platform_data;
-			if (sensor_pdata->get_camera_caps)
-				isp->inputs[isp->input_cnt].camera_caps =
-					sensor_pdata->get_camera_caps();
-			else
-				isp->inputs[isp->input_cnt].camera_caps =
+			isp->inputs[isp->input_cnt].camera_caps =
 					atomisp_get_default_camera_caps();
 			sensor_num = isp->inputs[isp->input_cnt]
 				.camera_caps->sensor_num;
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 0c5d09bdb93a..3f7814a3a5a4 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -331,16 +331,6 @@ static const struct {
 
 #define CFG_VAR_NAME_MAX 64
 
-static int gmin_platform_init(struct i2c_client *client)
-{
-	return 0;
-}
-
-static int gmin_platform_deinit(void)
-{
-	return 0;
-}
-
 #define GMIN_PMC_CLK_NAME 14 /* "pmc_plt_clk_[0..5]" */
 static char gmin_pmc_clk_name[GMIN_PMC_CLK_NAME];
 
@@ -621,8 +611,6 @@ static struct camera_sensor_platform_data gmin_plat = {
 	.v2p8_ctrl = gmin_v2p8_ctrl,
 	.v1p2_ctrl = gmin_v1p2_ctrl,
 	.flisclk_ctrl = gmin_flisclk_ctrl,
-	.platform_init = gmin_platform_init,
-	.platform_deinit = gmin_platform_deinit,
 	.csi_cfg = gmin_csi_cfg,
 	.get_vcm_ctrl = gmin_get_vcm_ctrl,
 };
-- 
2.14.1
