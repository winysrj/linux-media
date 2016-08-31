Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:31187 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932635AbcHaHnE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 03:43:04 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id ED7AC205B5
        for <linux-media@vger.kernel.org>; Wed, 31 Aug 2016 10:43:00 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] smiapp: Rename smiapp_platform_data as smiapp_hwconfig
Date: Wed, 31 Aug 2016 10:42:02 +0300
Message-Id: <1472629325-30875-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is really configuration to the driver originating from DT or
elsewhere. Do not call it platform data.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c  | 140 ++++++++++++++++----------------
 drivers/media/i2c/smiapp/smiapp-quirk.c |   4 +-
 drivers/media/i2c/smiapp/smiapp.h       |   2 +-
 include/media/i2c/smiapp.h              |   2 +-
 4 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index d08ab6c..92a6859 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -625,12 +625,12 @@ static int smiapp_init_late_controls(struct smiapp_sensor *sensor)
 				0, max_value, 1, max_value);
 	}
 
-	for (max = 0; sensor->platform_data->op_sys_clock[max + 1]; max++);
+	for (max = 0; sensor->hwcfg->op_sys_clock[max + 1]; max++);
 
 	sensor->link_freq = v4l2_ctrl_new_int_menu(
 		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
 		V4L2_CID_LINK_FREQ, __fls(*valid_link_freqs),
-		__ffs(*valid_link_freqs), sensor->platform_data->op_sys_clock);
+		__ffs(*valid_link_freqs), sensor->hwcfg->op_sys_clock);
 
 	return sensor->src->ctrl_handler.error;
 }
@@ -833,8 +833,8 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 
 		pll->bits_per_pixel = f->compressed;
 
-		for (j = 0; sensor->platform_data->op_sys_clock[j]; j++) {
-			pll->link_freq = sensor->platform_data->op_sys_clock[j];
+		for (j = 0; sensor->hwcfg->op_sys_clock[j]; j++) {
+			pll->link_freq = sensor->hwcfg->op_sys_clock[j];
 
 			rval = smiapp_pll_try(sensor, pll);
 			dev_dbg(&client->dev, "link freq %u Hz, bpp %u %s\n",
@@ -1032,22 +1032,22 @@ static int smiapp_change_cci_addr(struct smiapp_sensor *sensor)
 	int rval;
 	u32 val;
 
-	client->addr = sensor->platform_data->i2c_addr_dfl;
+	client->addr = sensor->hwcfg->i2c_addr_dfl;
 
 	rval = smiapp_write(sensor,
 			    SMIAPP_REG_U8_CCI_ADDRESS_CONTROL,
-			    sensor->platform_data->i2c_addr_alt << 1);
+			    sensor->hwcfg->i2c_addr_alt << 1);
 	if (rval)
 		return rval;
 
-	client->addr = sensor->platform_data->i2c_addr_alt;
+	client->addr = sensor->hwcfg->i2c_addr_alt;
 
 	/* verify addr change went ok */
 	rval = smiapp_read(sensor, SMIAPP_REG_U8_CCI_ADDRESS_CONTROL, &val);
 	if (rval)
 		return rval;
 
-	if (val != sensor->platform_data->i2c_addr_alt << 1)
+	if (val != sensor->hwcfg->i2c_addr_alt << 1)
 		return -ENODEV;
 
 	return 0;
@@ -1061,13 +1061,13 @@ static int smiapp_change_cci_addr(struct smiapp_sensor *sensor)
 static int smiapp_setup_flash_strobe(struct smiapp_sensor *sensor)
 {
 	struct smiapp_flash_strobe_parms *strobe_setup;
-	unsigned int ext_freq = sensor->platform_data->ext_clk;
+	unsigned int ext_freq = sensor->hwcfg->ext_clk;
 	u32 tmp;
 	u32 strobe_adjustment;
 	u32 strobe_width_high_rs;
 	int rval;
 
-	strobe_setup = sensor->platform_data->strobe_setup;
+	strobe_setup = sensor->hwcfg->strobe_setup;
 
 	/*
 	 * How to calculate registers related to strobe length. Please
@@ -1179,7 +1179,7 @@ static int smiapp_setup_flash_strobe(struct smiapp_sensor *sensor)
 			    strobe_setup->trigger);
 
 out:
-	sensor->platform_data->strobe_setup->trigger = 0;
+	sensor->hwcfg->strobe_setup->trigger = 0;
 
 	return rval;
 }
@@ -1201,9 +1201,9 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	}
 	usleep_range(1000, 1000);
 
-	if (sensor->platform_data->set_xclk)
-		rval = sensor->platform_data->set_xclk(
-			&sensor->src->sd, sensor->platform_data->ext_clk);
+	if (sensor->hwcfg->set_xclk)
+		rval = sensor->hwcfg->set_xclk(
+			&sensor->src->sd, sensor->hwcfg->ext_clk);
 	else
 		rval = clk_prepare_enable(sensor->ext_clk);
 	if (rval < 0) {
@@ -1212,10 +1212,10 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	}
 	usleep_range(1000, 1000);
 
-	if (gpio_is_valid(sensor->platform_data->xshutdown))
-		gpio_set_value(sensor->platform_data->xshutdown, 1);
+	if (gpio_is_valid(sensor->hwcfg->xshutdown))
+		gpio_set_value(sensor->hwcfg->xshutdown, 1);
 
-	sleep = SMIAPP_RESET_DELAY(sensor->platform_data->ext_clk);
+	sleep = SMIAPP_RESET_DELAY(sensor->hwcfg->ext_clk);
 	usleep_range(sleep, sleep);
 
 	/*
@@ -1229,7 +1229,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	 * is found.
 	 */
 
-	if (sensor->platform_data->i2c_addr_alt) {
+	if (sensor->hwcfg->i2c_addr_alt) {
 		rval = smiapp_change_cci_addr(sensor);
 		if (rval) {
 			dev_err(&client->dev, "cci address change error\n");
@@ -1244,7 +1244,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 		goto out_cci_addr_fail;
 	}
 
-	if (sensor->platform_data->i2c_addr_alt) {
+	if (sensor->hwcfg->i2c_addr_alt) {
 		rval = smiapp_change_cci_addr(sensor);
 		if (rval) {
 			dev_err(&client->dev, "cci address change error\n");
@@ -1261,14 +1261,14 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 
 	rval = smiapp_write(
 		sensor, SMIAPP_REG_U16_EXTCLK_FREQUENCY_MHZ,
-		sensor->platform_data->ext_clk / (1000000 / (1 << 8)));
+		sensor->hwcfg->ext_clk / (1000000 / (1 << 8)));
 	if (rval) {
 		dev_err(&client->dev, "extclk frequency set failed\n");
 		goto out_cci_addr_fail;
 	}
 
 	rval = smiapp_write(sensor, SMIAPP_REG_U8_CSI_LANE_MODE,
-			    sensor->platform_data->lanes - 1);
+			    sensor->hwcfg->lanes - 1);
 	if (rval) {
 		dev_err(&client->dev, "csi lane mode set failed\n");
 		goto out_cci_addr_fail;
@@ -1282,7 +1282,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	}
 
 	rval = smiapp_write(sensor, SMIAPP_REG_U8_CSI_SIGNALLING_MODE,
-			    sensor->platform_data->csi_signalling_mode);
+			    sensor->hwcfg->csi_signalling_mode);
 	if (rval) {
 		dev_err(&client->dev, "csi signalling mode set failed\n");
 		goto out_cci_addr_fail;
@@ -1322,10 +1322,10 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	return 0;
 
 out_cci_addr_fail:
-	if (gpio_is_valid(sensor->platform_data->xshutdown))
-		gpio_set_value(sensor->platform_data->xshutdown, 0);
-	if (sensor->platform_data->set_xclk)
-		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+	if (gpio_is_valid(sensor->hwcfg->xshutdown))
+		gpio_set_value(sensor->hwcfg->xshutdown, 0);
+	if (sensor->hwcfg->set_xclk)
+		sensor->hwcfg->set_xclk(&sensor->src->sd, 0);
 	else
 		clk_disable_unprepare(sensor->ext_clk);
 
@@ -1343,15 +1343,15 @@ static void smiapp_power_off(struct smiapp_sensor *sensor)
 	 * really see a power off and next time the cci address change
 	 * will fail. So do a soft reset explicitly here.
 	 */
-	if (sensor->platform_data->i2c_addr_alt)
+	if (sensor->hwcfg->i2c_addr_alt)
 		smiapp_write(sensor,
 			     SMIAPP_REG_U8_SOFTWARE_RESET,
 			     SMIAPP_SOFTWARE_RESET);
 
-	if (gpio_is_valid(sensor->platform_data->xshutdown))
-		gpio_set_value(sensor->platform_data->xshutdown, 0);
-	if (sensor->platform_data->set_xclk)
-		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+	if (gpio_is_valid(sensor->hwcfg->xshutdown))
+		gpio_set_value(sensor->hwcfg->xshutdown, 0);
+	if (sensor->hwcfg->set_xclk)
+		sensor->hwcfg->set_xclk(&sensor->src->sd, 0);
 	else
 		clk_disable_unprepare(sensor->ext_clk);
 	usleep_range(5000, 5000);
@@ -1491,8 +1491,8 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 	if ((sensor->limits[SMIAPP_LIMIT_FLASH_MODE_CAPABILITY] &
 	     (SMIAPP_FLASH_MODE_CAPABILITY_SINGLE_STROBE |
 	      SMIAPP_FLASH_MODE_CAPABILITY_MULTIPLE_STROBE)) &&
-	    sensor->platform_data->strobe_setup != NULL &&
-	    sensor->platform_data->strobe_setup->trigger != 0) {
+	    sensor->hwcfg->strobe_setup != NULL &&
+	    sensor->hwcfg->strobe_setup->trigger != 0) {
 		rval = smiapp_setup_flash_strobe(sensor);
 		if (rval)
 			goto out;
@@ -2309,7 +2309,7 @@ smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
 
 	if (!sensor->nvm_size) {
 		/* NVM not read yet - read it now */
-		sensor->nvm_size = sensor->platform_data->nvm_size;
+		sensor->nvm_size = sensor->hwcfg->nvm_size;
 		if (smiapp_set_power(subdev, 1) < 0)
 			return -ENODEV;
 		if (smiapp_read_nvm(sensor, sensor->nvm)) {
@@ -2554,7 +2554,7 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 		return PTR_ERR(sensor->vana);
 	}
 
-	if (!sensor->platform_data->set_xclk) {
+	if (!sensor->hwcfg->set_xclk) {
 		sensor->ext_clk = devm_clk_get(&client->dev, NULL);
 		if (IS_ERR(sensor->ext_clk)) {
 			dev_err(&client->dev, "could not get clock\n");
@@ -2562,23 +2562,23 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 		}
 
 		rval = clk_set_rate(sensor->ext_clk,
-				    sensor->platform_data->ext_clk);
+				    sensor->hwcfg->ext_clk);
 		if (rval < 0) {
 			dev_err(&client->dev,
 				"unable to set clock freq to %u\n",
-				sensor->platform_data->ext_clk);
+				sensor->hwcfg->ext_clk);
 			return rval;
 		}
 	}
 
-	if (gpio_is_valid(sensor->platform_data->xshutdown)) {
+	if (gpio_is_valid(sensor->hwcfg->xshutdown)) {
 		rval = devm_gpio_request_one(
-			&client->dev, sensor->platform_data->xshutdown, 0,
+			&client->dev, sensor->hwcfg->xshutdown, 0,
 			"SMIA++ xshutdown");
 		if (rval < 0) {
 			dev_err(&client->dev,
 				"unable to acquire reset gpio %d\n",
-				sensor->platform_data->xshutdown);
+				sensor->hwcfg->xshutdown);
 			return rval;
 		}
 	}
@@ -2612,7 +2612,7 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	 *
 	 * Rotation also changes the bayer pattern.
 	 */
-	if (sensor->platform_data->module_board_orient ==
+	if (sensor->hwcfg->module_board_orient ==
 	    SMIAPP_MODULE_BOARD_ORIENT_180)
 		sensor->hvflip_inv_mask = SMIAPP_IMAGE_ORIENTATION_HFLIP |
 					  SMIAPP_IMAGE_ORIENTATION_VFLIP;
@@ -2661,9 +2661,9 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 	/* SMIA++ NVM initialization - it will be read from the sensor
 	 * when it is first requested by userspace.
 	 */
-	if (sensor->minfo.smiapp_version && sensor->platform_data->nvm_size) {
+	if (sensor->minfo.smiapp_version && sensor->hwcfg->nvm_size) {
 		sensor->nvm = devm_kzalloc(&client->dev,
-				sensor->platform_data->nvm_size, GFP_KERNEL);
+				sensor->hwcfg->nvm_size, GFP_KERNEL);
 		if (sensor->nvm == NULL) {
 			dev_err(&client->dev, "nvm buf allocation failed\n");
 			rval = -ENOMEM;
@@ -2706,8 +2706,8 @@ static int smiapp_init(struct smiapp_sensor *sensor)
 
 	/* prepare PLL configuration input values */
 	pll->bus_type = SMIAPP_PLL_BUS_TYPE_CSI2;
-	pll->csi2.lanes = sensor->platform_data->lanes;
-	pll->ext_clk_freq_hz = sensor->platform_data->ext_clk;
+	pll->csi2.lanes = sensor->hwcfg->lanes;
+	pll->ext_clk_freq_hz = sensor->hwcfg->ext_clk;
 	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
 	/* Profile 0 sensors have no separate OP clock branch. */
 	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
@@ -2984,9 +2984,9 @@ static int smiapp_resume(struct device *dev)
 
 #endif /* CONFIG_PM */
 
-static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
+static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 {
-	struct smiapp_platform_data *pdata;
+	struct smiapp_hwconfig *hwcfg;
 	struct v4l2_of_endpoint *bus_cfg;
 	struct device_node *ep;
 	int i;
@@ -3003,58 +3003,58 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 	if (IS_ERR(bus_cfg))
 		goto out_err;
 
-	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
+	hwcfg = devm_kzalloc(dev, sizeof(*hwcfg), GFP_KERNEL);
+	if (!hwcfg)
 		goto out_err;
 
 	switch (bus_cfg->bus_type) {
 	case V4L2_MBUS_CSI2:
-		pdata->csi_signalling_mode = SMIAPP_CSI_SIGNALLING_MODE_CSI2;
+		hwcfg->csi_signalling_mode = SMIAPP_CSI_SIGNALLING_MODE_CSI2;
 		break;
 		/* FIXME: add CCP2 support. */
 	default:
 		goto out_err;
 	}
 
-	pdata->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
-	dev_dbg(dev, "lanes %u\n", pdata->lanes);
+	hwcfg->lanes = bus_cfg->bus.mipi_csi2.num_data_lanes;
+	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
 
 	/* xshutdown GPIO is optional */
-	pdata->xshutdown = of_get_named_gpio(dev->of_node, "reset-gpios", 0);
+	hwcfg->xshutdown = of_get_named_gpio(dev->of_node, "reset-gpios", 0);
 
 	/* NVM size is not mandatory */
 	of_property_read_u32(dev->of_node, "nokia,nvm-size",
-				    &pdata->nvm_size);
+				    &hwcfg->nvm_size);
 
 	rval = of_property_read_u32(dev->of_node, "clock-frequency",
-				    &pdata->ext_clk);
+				    &hwcfg->ext_clk);
 	if (rval) {
 		dev_warn(dev, "can't get clock-frequency\n");
 		goto out_err;
 	}
 
-	dev_dbg(dev, "reset %d, nvm %d, clk %d, csi %d\n", pdata->xshutdown,
-		pdata->nvm_size, pdata->ext_clk, pdata->csi_signalling_mode);
+	dev_dbg(dev, "reset %d, nvm %d, clk %d, csi %d\n", hwcfg->xshutdown,
+		hwcfg->nvm_size, hwcfg->ext_clk, hwcfg->csi_signalling_mode);
 
 	if (!bus_cfg->nr_of_link_frequencies) {
 		dev_warn(dev, "no link frequencies defined\n");
 		goto out_err;
 	}
 
-	pdata->op_sys_clock = devm_kcalloc(
+	hwcfg->op_sys_clock = devm_kcalloc(
 		dev, bus_cfg->nr_of_link_frequencies + 1 /* guardian */,
-		sizeof(*pdata->op_sys_clock), GFP_KERNEL);
-	if (!pdata->op_sys_clock)
+		sizeof(*hwcfg->op_sys_clock), GFP_KERNEL);
+	if (!hwcfg->op_sys_clock)
 		goto out_err;
 
 	for (i = 0; i < bus_cfg->nr_of_link_frequencies; i++) {
-		pdata->op_sys_clock[i] = bus_cfg->link_frequencies[i];
-		dev_dbg(dev, "freq %d: %lld\n", i, pdata->op_sys_clock[i]);
+		hwcfg->op_sys_clock[i] = bus_cfg->link_frequencies[i];
+		dev_dbg(dev, "freq %d: %lld\n", i, hwcfg->op_sys_clock[i]);
 	}
 
 	v4l2_of_free_endpoint(bus_cfg);
 	of_node_put(ep);
-	return pdata;
+	return hwcfg;
 
 out_err:
 	v4l2_of_free_endpoint(bus_cfg);
@@ -3066,17 +3066,17 @@ static int smiapp_probe(struct i2c_client *client,
 			const struct i2c_device_id *devid)
 {
 	struct smiapp_sensor *sensor;
-	struct smiapp_platform_data *pdata = smiapp_get_pdata(&client->dev);
+	struct smiapp_hwconfig *hwcfg = smiapp_get_hwconfig(&client->dev);
 	int rval;
 
-	if (pdata == NULL)
+	if (hwcfg == NULL)
 		return -ENODEV;
 
 	sensor = devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
 	if (sensor == NULL)
 		return -ENOMEM;
 
-	sensor->platform_data = pdata;
+	sensor->hwcfg = hwcfg;
 	mutex_init(&sensor->mutex);
 	mutex_init(&sensor->power_mutex);
 	sensor->src = &sensor->ssds[sensor->ssds_used];
@@ -3119,10 +3119,10 @@ static int smiapp_remove(struct i2c_client *client)
 	v4l2_async_unregister_subdev(subdev);
 
 	if (sensor->power_count) {
-		if (gpio_is_valid(sensor->platform_data->xshutdown))
-			gpio_set_value(sensor->platform_data->xshutdown, 0);
-		if (sensor->platform_data->set_xclk)
-			sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+		if (gpio_is_valid(sensor->hwcfg->xshutdown))
+			gpio_set_value(sensor->hwcfg->xshutdown, 0);
+		if (sensor->hwcfg->set_xclk)
+			sensor->hwcfg->set_xclk(&sensor->src->sd, 0);
 		else
 			clk_disable_unprepare(sensor->ext_clk);
 		sensor->power_count = 0;
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index abf9ea7..d7e22bc 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -178,13 +178,13 @@ static int jt8ev1_post_poweron(struct smiapp_sensor *sensor)
 	if (rval < 0)
 		return rval;
 
-	switch (sensor->platform_data->ext_clk) {
+	switch (sensor->hwcfg->ext_clk) {
 	case 9600000:
 		return smiapp_write_8s(sensor, regs_96,
 				       ARRAY_SIZE(regs_96));
 	default:
 		dev_warn(&client->dev, "no MSRs for %d Hz ext_clk\n",
-			 sensor->platform_data->ext_clk);
+			 sensor->hwcfg->ext_clk);
 		return 0;
 	}
 }
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index 2174f89..6ff095a 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -197,7 +197,7 @@ struct smiapp_sensor {
 	struct smiapp_subdev *binner;
 	struct smiapp_subdev *scaler;
 	struct smiapp_subdev *pixel_array;
-	struct smiapp_platform_data *platform_data;
+	struct smiapp_hwconfig *hwcfg;
 	struct regulator *vana;
 	struct clk *ext_clk;
 	u32 limits[SMIAPP_LIMIT_LAST];
diff --git a/include/media/i2c/smiapp.h b/include/media/i2c/smiapp.h
index 029142d..a4a1b51 100644
--- a/include/media/i2c/smiapp.h
+++ b/include/media/i2c/smiapp.h
@@ -57,7 +57,7 @@ struct smiapp_flash_strobe_parms {
 	u8 trigger;
 };
 
-struct smiapp_platform_data {
+struct smiapp_hwconfig {
 	/*
 	 * Change the cci address if i2c_addr_alt is set.
 	 * Both default and alternate cci addr need to be present
-- 
2.7.4

