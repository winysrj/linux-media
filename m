Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35318 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753334AbcISWDN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:13 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 09/18] smiapp: Merge smiapp_init() with smiapp_probe()
Date: Tue, 20 Sep 2016 01:02:42 +0300
Message-Id: <1474322571-20290-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The smiapp_probe() is the sole caller of smiapp_init(). Unify the two.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 423 ++++++++++++++++-----------------
 1 file changed, 204 insertions(+), 219 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 9d7af8b..384a13b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2622,223 +2622,6 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
 	v4l2_set_subdevdata(&ssd->sd, client);
 }
 
-static int smiapp_init(struct smiapp_sensor *sensor)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-	struct smiapp_pll *pll = &sensor->pll;
-	unsigned int i;
-	int rval;
-
-	sensor->vana = devm_regulator_get(&client->dev, "vana");
-	if (IS_ERR(sensor->vana)) {
-		dev_err(&client->dev, "could not get regulator for vana\n");
-		return PTR_ERR(sensor->vana);
-	}
-
-	sensor->ext_clk = devm_clk_get(&client->dev, NULL);
-	if (IS_ERR(sensor->ext_clk)) {
-		dev_err(&client->dev, "could not get clock (%ld)\n",
-			PTR_ERR(sensor->ext_clk));
-		return -EPROBE_DEFER;
-	}
-
-	rval = clk_set_rate(sensor->ext_clk,
-			    sensor->hwcfg->ext_clk);
-	if (rval < 0) {
-		dev_err(&client->dev,
-			"unable to set clock freq to %u\n",
-			sensor->hwcfg->ext_clk);
-		return rval;
-	}
-
-	sensor->xshutdown = devm_gpiod_get_optional(&client->dev, "xshutdown",
-						    GPIOD_OUT_LOW);
-	if (IS_ERR(sensor->xshutdown))
-		return PTR_ERR(sensor->xshutdown);
-
-	rval = smiapp_power_on(sensor);
-	if (rval)
-		return -ENODEV;
-
-	rval = smiapp_identify_module(sensor);
-	if (rval) {
-		rval = -ENODEV;
-		goto out_power_off;
-	}
-
-	rval = smiapp_get_all_limits(sensor);
-	if (rval) {
-		rval = -ENODEV;
-		goto out_power_off;
-	}
-
-	/*
-	 * Handle Sensor Module orientation on the board.
-	 *
-	 * The application of H-FLIP and V-FLIP on the sensor is modified by
-	 * the sensor orientation on the board.
-	 *
-	 * For SMIAPP_BOARD_SENSOR_ORIENT_180 the default behaviour is to set
-	 * both H-FLIP and V-FLIP for normal operation which also implies
-	 * that a set/unset operation for user space HFLIP and VFLIP v4l2
-	 * controls will need to be internally inverted.
-	 *
-	 * Rotation also changes the bayer pattern.
-	 */
-	if (sensor->hwcfg->module_board_orient ==
-	    SMIAPP_MODULE_BOARD_ORIENT_180)
-		sensor->hvflip_inv_mask = SMIAPP_IMAGE_ORIENTATION_HFLIP |
-					  SMIAPP_IMAGE_ORIENTATION_VFLIP;
-
-	rval = smiapp_call_quirk(sensor, limits);
-	if (rval) {
-		dev_err(&client->dev, "limits quirks failed\n");
-		goto out_power_off;
-	}
-
-	if (sensor->limits[SMIAPP_LIMIT_BINNING_CAPABILITY]) {
-		u32 val;
-
-		rval = smiapp_read(sensor,
-				   SMIAPP_REG_U8_BINNING_SUBTYPES, &val);
-		if (rval < 0) {
-			rval = -ENODEV;
-			goto out_power_off;
-		}
-		sensor->nbinning_subtypes = min_t(u8, val,
-						  SMIAPP_BINNING_SUBTYPES);
-
-		for (i = 0; i < sensor->nbinning_subtypes; i++) {
-			rval = smiapp_read(
-				sensor, SMIAPP_REG_U8_BINNING_TYPE_n(i), &val);
-			if (rval < 0) {
-				rval = -ENODEV;
-				goto out_power_off;
-			}
-			sensor->binning_subtypes[i] =
-				*(struct smiapp_binning_subtype *)&val;
-
-			dev_dbg(&client->dev, "binning %xx%x\n",
-				sensor->binning_subtypes[i].horizontal,
-				sensor->binning_subtypes[i].vertical);
-		}
-	}
-	sensor->binning_horizontal = 1;
-	sensor->binning_vertical = 1;
-
-	if (device_create_file(&client->dev, &dev_attr_ident) != 0) {
-		dev_err(&client->dev, "sysfs ident entry creation failed\n");
-		rval = -ENOENT;
-		goto out_power_off;
-	}
-	/* SMIA++ NVM initialization - it will be read from the sensor
-	 * when it is first requested by userspace.
-	 */
-	if (sensor->minfo.smiapp_version && sensor->hwcfg->nvm_size) {
-		sensor->nvm = devm_kzalloc(&client->dev,
-				sensor->hwcfg->nvm_size, GFP_KERNEL);
-		if (sensor->nvm == NULL) {
-			dev_err(&client->dev, "nvm buf allocation failed\n");
-			rval = -ENOMEM;
-			goto out_cleanup;
-		}
-
-		if (device_create_file(&client->dev, &dev_attr_nvm) != 0) {
-			dev_err(&client->dev, "sysfs nvm entry failed\n");
-			rval = -EBUSY;
-			goto out_cleanup;
-		}
-	}
-
-	/* We consider this as profile 0 sensor if any of these are zero. */
-	if (!sensor->limits[SMIAPP_LIMIT_MIN_OP_SYS_CLK_DIV] ||
-	    !sensor->limits[SMIAPP_LIMIT_MAX_OP_SYS_CLK_DIV] ||
-	    !sensor->limits[SMIAPP_LIMIT_MIN_OP_PIX_CLK_DIV] ||
-	    !sensor->limits[SMIAPP_LIMIT_MAX_OP_PIX_CLK_DIV]) {
-		sensor->minfo.smiapp_profile = SMIAPP_PROFILE_0;
-	} else if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
-		   != SMIAPP_SCALING_CAPABILITY_NONE) {
-		if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
-		    == SMIAPP_SCALING_CAPABILITY_HORIZONTAL)
-			sensor->minfo.smiapp_profile = SMIAPP_PROFILE_1;
-		else
-			sensor->minfo.smiapp_profile = SMIAPP_PROFILE_2;
-		sensor->scaler = &sensor->ssds[sensor->ssds_used];
-		sensor->ssds_used++;
-	} else if (sensor->limits[SMIAPP_LIMIT_DIGITAL_CROP_CAPABILITY]
-		   == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP) {
-		sensor->scaler = &sensor->ssds[sensor->ssds_used];
-		sensor->ssds_used++;
-	}
-	sensor->binner = &sensor->ssds[sensor->ssds_used];
-	sensor->ssds_used++;
-	sensor->pixel_array = &sensor->ssds[sensor->ssds_used];
-	sensor->ssds_used++;
-
-	sensor->scale_m = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
-
-	/* prepare PLL configuration input values */
-	pll->bus_type = SMIAPP_PLL_BUS_TYPE_CSI2;
-	pll->csi2.lanes = sensor->hwcfg->lanes;
-	pll->ext_clk_freq_hz = sensor->hwcfg->ext_clk;
-	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
-	/* Profile 0 sensors have no separate OP clock branch. */
-	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
-		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
-
-	smiapp_create_subdev(sensor, sensor->scaler, "scaler", 2);
-	smiapp_create_subdev(sensor, sensor->binner, "binner", 2);
-	smiapp_create_subdev(sensor, sensor->pixel_array, "pixel_array", 1);
-
-	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
-
-	sensor->pixel_array->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
-
-	/* final steps */
-	smiapp_read_frame_fmt(sensor);
-	rval = smiapp_init_controls(sensor);
-	if (rval < 0)
-		goto out_cleanup;
-
-	rval = smiapp_call_quirk(sensor, init);
-	if (rval)
-		goto out_cleanup;
-
-	rval = smiapp_get_mbus_formats(sensor);
-	if (rval) {
-		rval = -ENODEV;
-		goto out_cleanup;
-	}
-
-	rval = smiapp_init_late_controls(sensor);
-	if (rval) {
-		rval = -ENODEV;
-		goto out_cleanup;
-	}
-
-	mutex_lock(&sensor->mutex);
-	rval = smiapp_update_mode(sensor);
-	mutex_unlock(&sensor->mutex);
-	if (rval) {
-		dev_err(&client->dev, "update mode failed\n");
-		goto out_cleanup;
-	}
-
-	sensor->streaming = false;
-	sensor->dev_init_done = true;
-
-	smiapp_power_off(sensor);
-
-	return 0;
-
-out_cleanup:
-	smiapp_cleanup(sensor);
-
-out_power_off:
-	smiapp_power_off(sensor);
-	return rval;
-}
-
 static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct smiapp_subdev *ssd = to_smiapp_subdev(sd);
@@ -3061,6 +2844,7 @@ static int smiapp_probe(struct i2c_client *client,
 {
 	struct smiapp_sensor *sensor;
 	struct smiapp_hwconfig *hwcfg = smiapp_get_hwconfig(&client->dev);
+	unsigned int i;
 	int rval;
 
 	if (hwcfg == NULL)
@@ -3081,9 +2865,205 @@ static int smiapp_probe(struct i2c_client *client,
 	sensor->src->sensor = sensor;
 	sensor->src->pads[0].flags = MEDIA_PAD_FL_SOURCE;
 
-	rval = smiapp_init(sensor);
+	sensor->vana = devm_regulator_get(&client->dev, "vana");
+	if (IS_ERR(sensor->vana)) {
+		dev_err(&client->dev, "could not get regulator for vana\n");
+		return PTR_ERR(sensor->vana);
+	}
+
+	sensor->ext_clk = devm_clk_get(&client->dev, NULL);
+	if (IS_ERR(sensor->ext_clk)) {
+		dev_err(&client->dev, "could not get clock (%ld)\n",
+			PTR_ERR(sensor->ext_clk));
+		return -EPROBE_DEFER;
+	}
+
+	rval = clk_set_rate(sensor->ext_clk,
+			    sensor->hwcfg->ext_clk);
+	if (rval < 0) {
+		dev_err(&client->dev,
+			"unable to set clock freq to %u\n",
+			sensor->hwcfg->ext_clk);
+		return rval;
+	}
+
+	sensor->xshutdown = devm_gpiod_get_optional(&client->dev, "xshutdown",
+						    GPIOD_OUT_LOW);
+	if (IS_ERR(sensor->xshutdown))
+		return PTR_ERR(sensor->xshutdown);
+
+	rval = smiapp_power_on(sensor);
 	if (rval)
-		goto out_media_entity_cleanup;
+		return -ENODEV;
+
+	rval = smiapp_identify_module(sensor);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_power_off;
+	}
+
+	rval = smiapp_get_all_limits(sensor);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_power_off;
+	}
+
+	/*
+	 * Handle Sensor Module orientation on the board.
+	 *
+	 * The application of H-FLIP and V-FLIP on the sensor is modified by
+	 * the sensor orientation on the board.
+	 *
+	 * For SMIAPP_BOARD_SENSOR_ORIENT_180 the default behaviour is to set
+	 * both H-FLIP and V-FLIP for normal operation which also implies
+	 * that a set/unset operation for user space HFLIP and VFLIP v4l2
+	 * controls will need to be internally inverted.
+	 *
+	 * Rotation also changes the bayer pattern.
+	 */
+	if (sensor->hwcfg->module_board_orient ==
+	    SMIAPP_MODULE_BOARD_ORIENT_180)
+		sensor->hvflip_inv_mask = SMIAPP_IMAGE_ORIENTATION_HFLIP |
+					  SMIAPP_IMAGE_ORIENTATION_VFLIP;
+
+	rval = smiapp_call_quirk(sensor, limits);
+	if (rval) {
+		dev_err(&client->dev, "limits quirks failed\n");
+		goto out_power_off;
+	}
+
+	if (sensor->limits[SMIAPP_LIMIT_BINNING_CAPABILITY]) {
+		u32 val;
+
+		rval = smiapp_read(sensor,
+				   SMIAPP_REG_U8_BINNING_SUBTYPES, &val);
+		if (rval < 0) {
+			rval = -ENODEV;
+			goto out_power_off;
+		}
+		sensor->nbinning_subtypes = min_t(u8, val,
+						  SMIAPP_BINNING_SUBTYPES);
+
+		for (i = 0; i < sensor->nbinning_subtypes; i++) {
+			rval = smiapp_read(
+				sensor, SMIAPP_REG_U8_BINNING_TYPE_n(i), &val);
+			if (rval < 0) {
+				rval = -ENODEV;
+				goto out_power_off;
+			}
+			sensor->binning_subtypes[i] =
+				*(struct smiapp_binning_subtype *)&val;
+
+			dev_dbg(&client->dev, "binning %xx%x\n",
+				sensor->binning_subtypes[i].horizontal,
+				sensor->binning_subtypes[i].vertical);
+		}
+	}
+	sensor->binning_horizontal = 1;
+	sensor->binning_vertical = 1;
+
+	if (device_create_file(&client->dev, &dev_attr_ident) != 0) {
+		dev_err(&client->dev, "sysfs ident entry creation failed\n");
+		rval = -ENOENT;
+		goto out_power_off;
+	}
+	/* SMIA++ NVM initialization - it will be read from the sensor
+	 * when it is first requested by userspace.
+	 */
+	if (sensor->minfo.smiapp_version && sensor->hwcfg->nvm_size) {
+		sensor->nvm = devm_kzalloc(&client->dev,
+				sensor->hwcfg->nvm_size, GFP_KERNEL);
+		if (sensor->nvm == NULL) {
+			dev_err(&client->dev, "nvm buf allocation failed\n");
+			rval = -ENOMEM;
+			goto out_cleanup;
+		}
+
+		if (device_create_file(&client->dev, &dev_attr_nvm) != 0) {
+			dev_err(&client->dev, "sysfs nvm entry failed\n");
+			rval = -EBUSY;
+			goto out_cleanup;
+		}
+	}
+
+	/* We consider this as profile 0 sensor if any of these are zero. */
+	if (!sensor->limits[SMIAPP_LIMIT_MIN_OP_SYS_CLK_DIV] ||
+	    !sensor->limits[SMIAPP_LIMIT_MAX_OP_SYS_CLK_DIV] ||
+	    !sensor->limits[SMIAPP_LIMIT_MIN_OP_PIX_CLK_DIV] ||
+	    !sensor->limits[SMIAPP_LIMIT_MAX_OP_PIX_CLK_DIV]) {
+		sensor->minfo.smiapp_profile = SMIAPP_PROFILE_0;
+	} else if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
+		   != SMIAPP_SCALING_CAPABILITY_NONE) {
+		if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
+		    == SMIAPP_SCALING_CAPABILITY_HORIZONTAL)
+			sensor->minfo.smiapp_profile = SMIAPP_PROFILE_1;
+		else
+			sensor->minfo.smiapp_profile = SMIAPP_PROFILE_2;
+		sensor->scaler = &sensor->ssds[sensor->ssds_used];
+		sensor->ssds_used++;
+	} else if (sensor->limits[SMIAPP_LIMIT_DIGITAL_CROP_CAPABILITY]
+		   == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP) {
+		sensor->scaler = &sensor->ssds[sensor->ssds_used];
+		sensor->ssds_used++;
+	}
+	sensor->binner = &sensor->ssds[sensor->ssds_used];
+	sensor->ssds_used++;
+	sensor->pixel_array = &sensor->ssds[sensor->ssds_used];
+	sensor->ssds_used++;
+
+	sensor->scale_m = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
+
+	/* prepare PLL configuration input values */
+	sensor->pll.bus_type = SMIAPP_PLL_BUS_TYPE_CSI2;
+	sensor->pll.csi2.lanes = sensor->hwcfg->lanes;
+	sensor->pll.ext_clk_freq_hz = sensor->hwcfg->ext_clk;
+	sensor->pll.scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
+	/* Profile 0 sensors have no separate OP clock branch. */
+	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
+		sensor->pll.flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
+
+	smiapp_create_subdev(sensor, sensor->scaler, "scaler", 2);
+	smiapp_create_subdev(sensor, sensor->binner, "binner", 2);
+	smiapp_create_subdev(sensor, sensor->pixel_array, "pixel_array", 1);
+
+	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
+
+	sensor->pixel_array->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+
+	/* final steps */
+	smiapp_read_frame_fmt(sensor);
+	rval = smiapp_init_controls(sensor);
+	if (rval < 0)
+		goto out_cleanup;
+
+	rval = smiapp_call_quirk(sensor, init);
+	if (rval)
+		goto out_cleanup;
+
+	rval = smiapp_get_mbus_formats(sensor);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_cleanup;
+	}
+
+	rval = smiapp_init_late_controls(sensor);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_cleanup;
+	}
+
+	mutex_lock(&sensor->mutex);
+	rval = smiapp_update_mode(sensor);
+	mutex_unlock(&sensor->mutex);
+	if (rval) {
+		dev_err(&client->dev, "update mode failed\n");
+		goto out_cleanup;
+	}
+
+	sensor->streaming = false;
+	sensor->dev_init_done = true;
+
+	smiapp_power_off(sensor);
 
 	rval = media_entity_pads_init(&sensor->src->sd.entity, 2,
 				 sensor->src->pads);
@@ -3099,6 +3079,11 @@ static int smiapp_probe(struct i2c_client *client,
 out_media_entity_cleanup:
 	media_entity_cleanup(&sensor->src->sd.entity);
 
+out_cleanup:
+	smiapp_cleanup(sensor);
+
+out_power_off:
+	smiapp_power_off(sensor);
 	return rval;
 }
 
-- 
2.1.4

