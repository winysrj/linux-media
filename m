Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:30110 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760603Ab2EQQaW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 12:30:22 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.199.25])
	by mgw-sa01.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4HGUJaP029642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:19 +0300
Received: from lanttu (lanttu-o.localdomain [192.168.239.74])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id 8C9A11F4C5A
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:18 +0300 (EEST)
Received: from sakke by lanttu with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1SV3ae-00086S-RX
	for linux-media@vger.kernel.org; Thu, 17 May 2012 19:30:12 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 02/10] smiapp: Pass struct sensor to register writing commands instead of i2c_client
Date: Thu, 17 May 2012 19:30:01 +0300
Message-Id: <1337272209-31061-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4FB52770.9000400@maxwell.research.nokia.com>
References: <4FB52770.9000400@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass struct sensor to register access commands. This allows taking quirks
into account in register access.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/smiapp/smiapp-core.c  |  154 ++++++++++++++---------------
 drivers/media/video/smiapp/smiapp-quirk.c |    4 +-
 drivers/media/video/smiapp/smiapp-regs.c  |    7 +-
 drivers/media/video/smiapp/smiapp-regs.h  |    6 +-
 4 files changed, 84 insertions(+), 87 deletions(-)

diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index 999f3fc..de5c947 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -75,12 +75,12 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
 	int embedded_start = -1, embedded_end = -1;
 	int image_start = 0;
 
-	rval = smiapp_read(client, SMIAPP_REG_U8_FRAME_FORMAT_MODEL_TYPE,
+	rval = smiapp_read(sensor, SMIAPP_REG_U8_FRAME_FORMAT_MODEL_TYPE,
 			   &fmt_model_type);
 	if (rval)
 		return rval;
 
-	rval = smiapp_read(client, SMIAPP_REG_U8_FRAME_FORMAT_MODEL_SUBTYPE,
+	rval = smiapp_read(sensor, SMIAPP_REG_U8_FRAME_FORMAT_MODEL_SUBTYPE,
 			   &fmt_model_subtype);
 	if (rval)
 		return rval;
@@ -106,7 +106,7 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
 
 		if (fmt_model_type == SMIAPP_FRAME_FORMAT_MODEL_TYPE_2BYTE) {
 			rval = smiapp_read(
-				client,
+				sensor,
 				SMIAPP_REG_U16_FRAME_FORMAT_DESCRIPTOR_2(i),
 				&desc);
 			if (rval)
@@ -120,7 +120,7 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
 		} else if (fmt_model_type
 			   == SMIAPP_FRAME_FORMAT_MODEL_TYPE_4BYTE) {
 			rval = smiapp_read(
-				client,
+				sensor,
 				SMIAPP_REG_U32_FRAME_FORMAT_DESCRIPTOR_4(i),
 				&desc);
 			if (rval)
@@ -199,44 +199,43 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
 
 static int smiapp_pll_configure(struct smiapp_sensor *sensor)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct smiapp_pll *pll = &sensor->pll;
 	int rval;
 
 	rval = smiapp_write(
-		client, SMIAPP_REG_U16_VT_PIX_CLK_DIV, pll->vt_pix_clk_div);
+		sensor, SMIAPP_REG_U16_VT_PIX_CLK_DIV, pll->vt_pix_clk_div);
 	if (rval < 0)
 		return rval;
 
 	rval = smiapp_write(
-		client, SMIAPP_REG_U16_VT_SYS_CLK_DIV, pll->vt_sys_clk_div);
+		sensor, SMIAPP_REG_U16_VT_SYS_CLK_DIV, pll->vt_sys_clk_div);
 	if (rval < 0)
 		return rval;
 
 	rval = smiapp_write(
-		client, SMIAPP_REG_U16_PRE_PLL_CLK_DIV, pll->pre_pll_clk_div);
+		sensor, SMIAPP_REG_U16_PRE_PLL_CLK_DIV, pll->pre_pll_clk_div);
 	if (rval < 0)
 		return rval;
 
 	rval = smiapp_write(
-		client, SMIAPP_REG_U16_PLL_MULTIPLIER, pll->pll_multiplier);
+		sensor, SMIAPP_REG_U16_PLL_MULTIPLIER, pll->pll_multiplier);
 	if (rval < 0)
 		return rval;
 
 	/* Lane op clock ratio does not apply here. */
 	rval = smiapp_write(
-		client, SMIAPP_REG_U32_REQUESTED_LINK_BIT_RATE_MBPS,
+		sensor, SMIAPP_REG_U32_REQUESTED_LINK_BIT_RATE_MBPS,
 		DIV_ROUND_UP(pll->op_sys_clk_freq_hz, 1000000 / 256 / 256));
 	if (rval < 0 || sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
 		return rval;
 
 	rval = smiapp_write(
-		client, SMIAPP_REG_U16_OP_PIX_CLK_DIV, pll->op_pix_clk_div);
+		sensor, SMIAPP_REG_U16_OP_PIX_CLK_DIV, pll->op_pix_clk_div);
 	if (rval < 0)
 		return rval;
 
 	return smiapp_write(
-		client, SMIAPP_REG_U16_OP_SYS_CLK_DIV, pll->op_sys_clk_div);
+		sensor, SMIAPP_REG_U16_OP_SYS_CLK_DIV, pll->op_sys_clk_div);
 }
 
 static int smiapp_pll_update(struct smiapp_sensor *sensor)
@@ -425,7 +424,6 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 	struct smiapp_sensor *sensor =
 		container_of(ctrl->handler, struct smiapp_subdev, ctrl_handler)
 			->sensor;
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	u32 orient = 0;
 	int exposure;
 	int rval;
@@ -433,12 +431,12 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 	switch (ctrl->id) {
 	case V4L2_CID_ANALOGUE_GAIN:
 		return smiapp_write(
-			client,
+			sensor,
 			SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_GLOBAL, ctrl->val);
 
 	case V4L2_CID_EXPOSURE:
 		return smiapp_write(
-			client,
+			sensor,
 			SMIAPP_REG_U16_COARSE_INTEGRATION_TIME, ctrl->val);
 
 	case V4L2_CID_HFLIP:
@@ -453,7 +451,7 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 			orient |= SMIAPP_IMAGE_ORIENTATION_VFLIP;
 
 		orient ^= sensor->hvflip_inv_mask;
-		rval = smiapp_write(client,
+		rval = smiapp_write(sensor,
 				    SMIAPP_REG_U8_IMAGE_ORIENTATION,
 				    orient);
 		if (rval < 0)
@@ -478,13 +476,13 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 		}
 
 		return smiapp_write(
-			client, SMIAPP_REG_U16_FRAME_LENGTH_LINES,
+			sensor, SMIAPP_REG_U16_FRAME_LENGTH_LINES,
 			sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height
 			+ ctrl->val);
 
 	case V4L2_CID_HBLANK:
 		return smiapp_write(
-			client, SMIAPP_REG_U16_LINE_LENGTH_PCK,
+			sensor, SMIAPP_REG_U16_LINE_LENGTH_PCK,
 			sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width
 			+ ctrl->val);
 
@@ -624,7 +622,7 @@ static int smiapp_get_limits(struct smiapp_sensor *sensor, int const *limit,
 
 	for (i = 0; i < n; i++) {
 		rval = smiapp_read(
-			client, smiapp_reg_limits[limit[i]].addr, &val);
+			sensor, smiapp_reg_limits[limit[i]].addr, &val);
 		if (rval)
 			return rval;
 		sensor->limits[limit[i]] = val;
@@ -696,13 +694,13 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 	int rval;
 
 	rval = smiapp_read(
-		client, SMIAPP_REG_U8_DATA_FORMAT_MODEL_TYPE, &type);
+		sensor, SMIAPP_REG_U8_DATA_FORMAT_MODEL_TYPE, &type);
 	if (rval)
 		return rval;
 
 	dev_dbg(&client->dev, "data_format_model_type %d\n", type);
 
-	rval = smiapp_read(client, SMIAPP_REG_U8_PIXEL_ORDER,
+	rval = smiapp_read(sensor, SMIAPP_REG_U8_PIXEL_ORDER,
 			   &pixel_order);
 	if (rval)
 		return rval;
@@ -733,7 +731,7 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 		unsigned int fmt, j;
 
 		rval = smiapp_read(
-			client,
+			sensor,
 			SMIAPP_REG_U16_DATA_FORMAT_DESCRIPTOR(i), &fmt);
 		if (rval)
 			return rval;
@@ -831,13 +829,13 @@ static int smiapp_update_mode(struct smiapp_sensor *sensor)
 			| sensor->binning_vertical;
 
 		rval = smiapp_write(
-			client, SMIAPP_REG_U8_BINNING_TYPE, binning_type);
+			sensor, SMIAPP_REG_U8_BINNING_TYPE, binning_type);
 		if (rval < 0)
 			return rval;
 
 		binning_mode = 1;
 	}
-	rval = smiapp_write(client, SMIAPP_REG_U8_BINNING_MODE, binning_mode);
+	rval = smiapp_write(sensor, SMIAPP_REG_U8_BINNING_MODE, binning_mode);
 	if (rval < 0)
 		return rval;
 
@@ -874,19 +872,18 @@ static int smiapp_update_mode(struct smiapp_sensor *sensor)
 static int smiapp_read_nvm(struct smiapp_sensor *sensor,
 			   unsigned char *nvm)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	u32 i, s, p, np, v;
 	int rval, rval2;
 
 	np = sensor->nvm_size / SMIAPP_NVM_PAGE_SIZE;
 	for (p = 0; p < np; p++) {
 		rval = smiapp_write(
-			client,
+			sensor,
 			SMIAPP_REG_U8_DATA_TRANSFER_IF_1_PAGE_SELECT, p);
 		if (rval)
 			goto out;
 
-		rval = smiapp_write(client,
+		rval = smiapp_write(sensor,
 				    SMIAPP_REG_U8_DATA_TRANSFER_IF_1_CTRL,
 				    SMIAPP_DATA_TRANSFER_IF_1_CTRL_EN |
 				    SMIAPP_DATA_TRANSFER_IF_1_CTRL_RD_EN);
@@ -895,7 +892,7 @@ static int smiapp_read_nvm(struct smiapp_sensor *sensor,
 
 		for (i = 0; i < 1000; i++) {
 			rval = smiapp_read(
-				client,
+				sensor,
 				SMIAPP_REG_U8_DATA_TRANSFER_IF_1_STATUS, &s);
 
 			if (rval)
@@ -913,7 +910,7 @@ static int smiapp_read_nvm(struct smiapp_sensor *sensor,
 
 		for (i = 0; i < SMIAPP_NVM_PAGE_SIZE; i++) {
 			rval = smiapp_read(
-				client,
+				sensor,
 				SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_0 + i,
 				&v);
 			if (rval)
@@ -924,7 +921,7 @@ static int smiapp_read_nvm(struct smiapp_sensor *sensor,
 	}
 
 out:
-	rval2 = smiapp_write(client, SMIAPP_REG_U8_DATA_TRANSFER_IF_1_CTRL, 0);
+	rval2 = smiapp_write(sensor, SMIAPP_REG_U8_DATA_TRANSFER_IF_1_CTRL, 0);
 	if (rval < 0)
 		return rval;
 	else
@@ -944,7 +941,7 @@ static int smiapp_change_cci_addr(struct smiapp_sensor *sensor)
 
 	client->addr = sensor->platform_data->i2c_addr_dfl;
 
-	rval = smiapp_write(client,
+	rval = smiapp_write(sensor,
 			    SMIAPP_REG_U8_CCI_ADDRESS_CONTROL,
 			    sensor->platform_data->i2c_addr_alt << 1);
 	if (rval)
@@ -953,7 +950,7 @@ static int smiapp_change_cci_addr(struct smiapp_sensor *sensor)
 	client->addr = sensor->platform_data->i2c_addr_alt;
 
 	/* verify addr change went ok */
-	rval = smiapp_read(client, SMIAPP_REG_U8_CCI_ADDRESS_CONTROL, &val);
+	rval = smiapp_read(sensor, SMIAPP_REG_U8_CCI_ADDRESS_CONTROL, &val);
 	if (rval)
 		return rval;
 
@@ -970,7 +967,6 @@ static int smiapp_change_cci_addr(struct smiapp_sensor *sensor)
  */
 static int smiapp_setup_flash_strobe(struct smiapp_sensor *sensor)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct smiapp_flash_strobe_parms *strobe_setup;
 	unsigned int ext_freq = sensor->platform_data->ext_clk;
 	u32 tmp;
@@ -1060,33 +1056,33 @@ static int smiapp_setup_flash_strobe(struct smiapp_sensor *sensor)
 	strobe_width_high_rs = (tmp + strobe_adjustment - 1) /
 				strobe_adjustment;
 
-	rval = smiapp_write(client, SMIAPP_REG_U8_FLASH_MODE_RS,
+	rval = smiapp_write(sensor, SMIAPP_REG_U8_FLASH_MODE_RS,
 			    strobe_setup->mode);
 	if (rval < 0)
 		goto out;
 
-	rval = smiapp_write(client, SMIAPP_REG_U8_FLASH_STROBE_ADJUSTMENT,
+	rval = smiapp_write(sensor, SMIAPP_REG_U8_FLASH_STROBE_ADJUSTMENT,
 			    strobe_adjustment);
 	if (rval < 0)
 		goto out;
 
 	rval = smiapp_write(
-		client, SMIAPP_REG_U16_TFLASH_STROBE_WIDTH_HIGH_RS_CTRL,
+		sensor, SMIAPP_REG_U16_TFLASH_STROBE_WIDTH_HIGH_RS_CTRL,
 		strobe_width_high_rs);
 	if (rval < 0)
 		goto out;
 
-	rval = smiapp_write(client, SMIAPP_REG_U16_TFLASH_STROBE_DELAY_RS_CTRL,
+	rval = smiapp_write(sensor, SMIAPP_REG_U16_TFLASH_STROBE_DELAY_RS_CTRL,
 			    strobe_setup->strobe_delay);
 	if (rval < 0)
 		goto out;
 
-	rval = smiapp_write(client, SMIAPP_REG_U16_FLASH_STROBE_START_POINT,
+	rval = smiapp_write(sensor, SMIAPP_REG_U16_FLASH_STROBE_START_POINT,
 			    strobe_setup->stobe_start_point);
 	if (rval < 0)
 		goto out;
 
-	rval = smiapp_write(client, SMIAPP_REG_U8_FLASH_TRIGGER_RS,
+	rval = smiapp_write(sensor, SMIAPP_REG_U8_FLASH_TRIGGER_RS,
 			    strobe_setup->trigger);
 
 out:
@@ -1148,7 +1144,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 		}
 	}
 
-	rval = smiapp_write(client, SMIAPP_REG_U8_SOFTWARE_RESET,
+	rval = smiapp_write(sensor, SMIAPP_REG_U8_SOFTWARE_RESET,
 			    SMIAPP_SOFTWARE_RESET);
 	if (rval < 0) {
 		dev_err(&client->dev, "software reset failed\n");
@@ -1163,7 +1159,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 		}
 	}
 
-	rval = smiapp_write(client, SMIAPP_REG_U16_COMPRESSION_MODE,
+	rval = smiapp_write(sensor, SMIAPP_REG_U16_COMPRESSION_MODE,
 			    SMIAPP_COMPRESSION_MODE_SIMPLE_PREDICTOR);
 	if (rval) {
 		dev_err(&client->dev, "compression mode set failed\n");
@@ -1171,28 +1167,28 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	}
 
 	rval = smiapp_write(
-		client, SMIAPP_REG_U16_EXTCLK_FREQUENCY_MHZ,
+		sensor, SMIAPP_REG_U16_EXTCLK_FREQUENCY_MHZ,
 		sensor->platform_data->ext_clk / (1000000 / (1 << 8)));
 	if (rval) {
 		dev_err(&client->dev, "extclk frequency set failed\n");
 		goto out_cci_addr_fail;
 	}
 
-	rval = smiapp_write(client, SMIAPP_REG_U8_CSI_LANE_MODE,
+	rval = smiapp_write(sensor, SMIAPP_REG_U8_CSI_LANE_MODE,
 			    sensor->platform_data->lanes - 1);
 	if (rval) {
 		dev_err(&client->dev, "csi lane mode set failed\n");
 		goto out_cci_addr_fail;
 	}
 
-	rval = smiapp_write(client, SMIAPP_REG_U8_FAST_STANDBY_CTRL,
+	rval = smiapp_write(sensor, SMIAPP_REG_U8_FAST_STANDBY_CTRL,
 			    SMIAPP_FAST_STANDBY_CTRL_IMMEDIATE);
 	if (rval) {
 		dev_err(&client->dev, "fast standby set failed\n");
 		goto out_cci_addr_fail;
 	}
 
-	rval = smiapp_write(client, SMIAPP_REG_U8_CSI_SIGNALLING_MODE,
+	rval = smiapp_write(sensor, SMIAPP_REG_U8_CSI_SIGNALLING_MODE,
 			    sensor->platform_data->csi_signalling_mode);
 	if (rval) {
 		dev_err(&client->dev, "csi signalling mode set failed\n");
@@ -1200,7 +1196,7 @@ static int smiapp_power_on(struct smiapp_sensor *sensor)
 	}
 
 	/* DPHY control done by sensor based on requested link rate */
-	rval = smiapp_write(client, SMIAPP_REG_U8_DPHY_CTRL,
+	rval = smiapp_write(sensor, SMIAPP_REG_U8_DPHY_CTRL,
 			    SMIAPP_DPHY_CTRL_UI);
 	if (rval < 0)
 		return rval;
@@ -1247,8 +1243,6 @@ out_xclk_fail:
 
 static void smiapp_power_off(struct smiapp_sensor *sensor)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-
 	/*
 	 * Currently power/clock to lens are enable/disabled separately
 	 * but they are essentially the same signals. So if the sensor is
@@ -1257,7 +1251,7 @@ static void smiapp_power_off(struct smiapp_sensor *sensor)
 	 * will fail. So do a soft reset explicitly here.
 	 */
 	if (sensor->platform_data->i2c_addr_alt)
-		smiapp_write(client,
+		smiapp_write(sensor,
 			     SMIAPP_REG_U8_SOFTWARE_RESET,
 			     SMIAPP_SOFTWARE_RESET);
 
@@ -1315,7 +1309,7 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 
 	mutex_lock(&sensor->mutex);
 
-	rval = smiapp_write(client, SMIAPP_REG_U16_CSI_DATA_FORMAT,
+	rval = smiapp_write(sensor, SMIAPP_REG_U16_CSI_DATA_FORMAT,
 			    (sensor->csi_format->width << 8) |
 			    sensor->csi_format->compressed);
 	if (rval)
@@ -1326,26 +1320,26 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 		goto out;
 
 	/* Analog crop start coordinates */
-	rval = smiapp_write(client, SMIAPP_REG_U16_X_ADDR_START,
+	rval = smiapp_write(sensor, SMIAPP_REG_U16_X_ADDR_START,
 			    sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].left);
 	if (rval < 0)
 		goto out;
 
-	rval = smiapp_write(client, SMIAPP_REG_U16_Y_ADDR_START,
+	rval = smiapp_write(sensor, SMIAPP_REG_U16_Y_ADDR_START,
 			    sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].top);
 	if (rval < 0)
 		goto out;
 
 	/* Analog crop end coordinates */
 	rval = smiapp_write(
-		client, SMIAPP_REG_U16_X_ADDR_END,
+		sensor, SMIAPP_REG_U16_X_ADDR_END,
 		sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].left
 		+ sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width - 1);
 	if (rval < 0)
 		goto out;
 
 	rval = smiapp_write(
-		client, SMIAPP_REG_U16_Y_ADDR_END,
+		sensor, SMIAPP_REG_U16_Y_ADDR_END,
 		sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].top
 		+ sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height - 1);
 	if (rval < 0)
@@ -1360,25 +1354,25 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 	if (sensor->limits[SMIAPP_LIMIT_DIGITAL_CROP_CAPABILITY]
 	    == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP) {
 		rval = smiapp_write(
-			client, SMIAPP_REG_U16_DIGITAL_CROP_X_OFFSET,
+			sensor, SMIAPP_REG_U16_DIGITAL_CROP_X_OFFSET,
 			sensor->scaler->crop[SMIAPP_PAD_SINK].left);
 		if (rval < 0)
 			goto out;
 
 		rval = smiapp_write(
-			client, SMIAPP_REG_U16_DIGITAL_CROP_Y_OFFSET,
+			sensor, SMIAPP_REG_U16_DIGITAL_CROP_Y_OFFSET,
 			sensor->scaler->crop[SMIAPP_PAD_SINK].top);
 		if (rval < 0)
 			goto out;
 
 		rval = smiapp_write(
-			client, SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_WIDTH,
+			sensor, SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_WIDTH,
 			sensor->scaler->crop[SMIAPP_PAD_SINK].width);
 		if (rval < 0)
 			goto out;
 
 		rval = smiapp_write(
-			client, SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_HEIGHT,
+			sensor, SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_HEIGHT,
 			sensor->scaler->crop[SMIAPP_PAD_SINK].height);
 		if (rval < 0)
 			goto out;
@@ -1387,23 +1381,23 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 	/* Scaling */
 	if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
 	    != SMIAPP_SCALING_CAPABILITY_NONE) {
-		rval = smiapp_write(client, SMIAPP_REG_U16_SCALING_MODE,
+		rval = smiapp_write(sensor, SMIAPP_REG_U16_SCALING_MODE,
 				    sensor->scaling_mode);
 		if (rval < 0)
 			goto out;
 
-		rval = smiapp_write(client, SMIAPP_REG_U16_SCALE_M,
+		rval = smiapp_write(sensor, SMIAPP_REG_U16_SCALE_M,
 				    sensor->scale_m);
 		if (rval < 0)
 			goto out;
 	}
 
 	/* Output size from sensor */
-	rval = smiapp_write(client, SMIAPP_REG_U16_X_OUTPUT_SIZE,
+	rval = smiapp_write(sensor, SMIAPP_REG_U16_X_OUTPUT_SIZE,
 			    sensor->src->crop[SMIAPP_PAD_SRC].width);
 	if (rval < 0)
 		goto out;
-	rval = smiapp_write(client, SMIAPP_REG_U16_Y_OUTPUT_SIZE,
+	rval = smiapp_write(sensor, SMIAPP_REG_U16_Y_OUTPUT_SIZE,
 			    sensor->src->crop[SMIAPP_PAD_SRC].height);
 	if (rval < 0)
 		goto out;
@@ -1424,7 +1418,7 @@ static int smiapp_start_streaming(struct smiapp_sensor *sensor)
 		goto out;
 	}
 
-	rval = smiapp_write(client, SMIAPP_REG_U8_MODE_SELECT,
+	rval = smiapp_write(sensor, SMIAPP_REG_U8_MODE_SELECT,
 			    SMIAPP_MODE_SELECT_STREAMING);
 
 out:
@@ -1439,7 +1433,7 @@ static int smiapp_stop_streaming(struct smiapp_sensor *sensor)
 	int rval;
 
 	mutex_lock(&sensor->mutex);
-	rval = smiapp_write(client, SMIAPP_REG_U8_MODE_SELECT,
+	rval = smiapp_write(sensor, SMIAPP_REG_U8_MODE_SELECT,
 			    SMIAPP_MODE_SELECT_SOFTWARE_STANDBY);
 	if (rval)
 		goto out;
@@ -2203,50 +2197,50 @@ static int smiapp_identify_module(struct v4l2_subdev *subdev)
 	minfo->name = SMIAPP_NAME;
 
 	/* Module info */
-	rval = smiapp_read(client, SMIAPP_REG_U8_MANUFACTURER_ID,
+	rval = smiapp_read(sensor, SMIAPP_REG_U8_MANUFACTURER_ID,
 			   &minfo->manufacturer_id);
 	if (!rval)
-		rval = smiapp_read(client, SMIAPP_REG_U16_MODEL_ID,
+		rval = smiapp_read(sensor, SMIAPP_REG_U16_MODEL_ID,
 				   &minfo->model_id);
 	if (!rval)
-		rval = smiapp_read(client, SMIAPP_REG_U8_REVISION_NUMBER_MAJOR,
+		rval = smiapp_read(sensor, SMIAPP_REG_U8_REVISION_NUMBER_MAJOR,
 				   &minfo->revision_number_major);
 	if (!rval)
-		rval = smiapp_read(client, SMIAPP_REG_U8_REVISION_NUMBER_MINOR,
+		rval = smiapp_read(sensor, SMIAPP_REG_U8_REVISION_NUMBER_MINOR,
 				   &minfo->revision_number_minor);
 	if (!rval)
-		rval = smiapp_read(client, SMIAPP_REG_U8_MODULE_DATE_YEAR,
+		rval = smiapp_read(sensor, SMIAPP_REG_U8_MODULE_DATE_YEAR,
 				   &minfo->module_year);
 	if (!rval)
-		rval = smiapp_read(client, SMIAPP_REG_U8_MODULE_DATE_MONTH,
+		rval = smiapp_read(sensor, SMIAPP_REG_U8_MODULE_DATE_MONTH,
 				   &minfo->module_month);
 	if (!rval)
-		rval = smiapp_read(client, SMIAPP_REG_U8_MODULE_DATE_DAY,
+		rval = smiapp_read(sensor, SMIAPP_REG_U8_MODULE_DATE_DAY,
 				   &minfo->module_day);
 
 	/* Sensor info */
 	if (!rval)
-		rval = smiapp_read(client,
+		rval = smiapp_read(sensor,
 				   SMIAPP_REG_U8_SENSOR_MANUFACTURER_ID,
 				   &minfo->sensor_manufacturer_id);
 	if (!rval)
-		rval = smiapp_read(client, SMIAPP_REG_U16_SENSOR_MODEL_ID,
+		rval = smiapp_read(sensor, SMIAPP_REG_U16_SENSOR_MODEL_ID,
 				   &minfo->sensor_model_id);
 	if (!rval)
-		rval = smiapp_read(client,
+		rval = smiapp_read(sensor,
 				   SMIAPP_REG_U8_SENSOR_REVISION_NUMBER,
 				   &minfo->sensor_revision_number);
 	if (!rval)
-		rval = smiapp_read(client,
+		rval = smiapp_read(sensor,
 				   SMIAPP_REG_U8_SENSOR_FIRMWARE_VERSION,
 				   &minfo->sensor_firmware_version);
 
 	/* SMIA */
 	if (!rval)
-		rval = smiapp_read(client, SMIAPP_REG_U8_SMIA_VERSION,
+		rval = smiapp_read(sensor, SMIAPP_REG_U8_SMIA_VERSION,
 				   &minfo->smia_version);
 	if (!rval)
-		rval = smiapp_read(client, SMIAPP_REG_U8_SMIAPP_VERSION,
+		rval = smiapp_read(sensor, SMIAPP_REG_U8_SMIAPP_VERSION,
 				   &minfo->smiapp_version);
 
 	if (rval) {
@@ -2415,7 +2409,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	if (sensor->limits[SMIAPP_LIMIT_BINNING_CAPABILITY]) {
 		u32 val;
 
-		rval = smiapp_read(client,
+		rval = smiapp_read(sensor,
 				   SMIAPP_REG_U8_BINNING_SUBTYPES, &val);
 		if (rval < 0) {
 			rval = -ENODEV;
@@ -2426,7 +2420,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 
 		for (i = 0; i < sensor->nbinning_subtypes; i++) {
 			rval = smiapp_read(
-				client, SMIAPP_REG_U8_BINNING_TYPE_n(i), &val);
+				sensor, SMIAPP_REG_U8_BINNING_TYPE_n(i), &val);
 			if (rval < 0) {
 				rval = -ENODEV;
 				goto out_power_off;
@@ -2600,7 +2594,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	sensor->dev_init_done = true;
 
 	/* check flash capability */
-	rval = smiapp_read(client, SMIAPP_REG_U8_FLASH_MODE_CAPABILITY, &tmp);
+	rval = smiapp_read(sensor, SMIAPP_REG_U8_FLASH_MODE_CAPABILITY, &tmp);
 	sensor->flash_capability = tmp;
 	if (rval)
 		goto out_nvm_release;
diff --git a/drivers/media/video/smiapp/smiapp-quirk.c b/drivers/media/video/smiapp/smiapp-quirk.c
index fb018de..81c2be3 100644
--- a/drivers/media/video/smiapp/smiapp-quirk.c
+++ b/drivers/media/video/smiapp/smiapp-quirk.c
@@ -28,9 +28,7 @@
 
 static int smiapp_write_8(struct smiapp_sensor *sensor, u16 reg, u8 val)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-
-	return smiapp_write(client, (SMIA_REG_8BIT << 16) | reg, val);
+	return smiapp_write(sensor, (SMIA_REG_8BIT << 16) | reg, val);
 }
 
 static int smiapp_write_8s(struct smiapp_sensor *sensor,
diff --git a/drivers/media/video/smiapp/smiapp-regs.c b/drivers/media/video/smiapp/smiapp-regs.c
index a5055f1..e5e5f43 100644
--- a/drivers/media/video/smiapp/smiapp-regs.c
+++ b/drivers/media/video/smiapp/smiapp-regs.c
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 
+#include "smiapp.h"
 #include "smiapp-regs.h"
 
 static uint32_t float_to_u32_mul_1000000(struct i2c_client *client,
@@ -77,8 +78,9 @@ static uint32_t float_to_u32_mul_1000000(struct i2c_client *client,
  * Read a 8/16/32-bit i2c register.  The value is returned in 'val'.
  * Returns zero if successful, or non-zero otherwise.
  */
-int smiapp_read(struct i2c_client *client, u32 reg, u32 *val)
+int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct i2c_msg msg;
 	unsigned char data[4];
 	unsigned int len = (u8)(reg >> 16);
@@ -145,8 +147,9 @@ err:
  * Write to a 8/16-bit register.
  * Returns zero if successful, or non-zero otherwise.
  */
-int smiapp_write(struct i2c_client *client, u32 reg, u32 val)
+int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	struct i2c_msg msg;
 	unsigned char data[6];
 	unsigned int retries;
diff --git a/drivers/media/video/smiapp/smiapp-regs.h b/drivers/media/video/smiapp/smiapp-regs.h
index 58e8009..1edfd20 100644
--- a/drivers/media/video/smiapp/smiapp-regs.h
+++ b/drivers/media/video/smiapp/smiapp-regs.h
@@ -40,7 +40,9 @@ struct smia_reg {
 	u32 val;			/* 8/16/32-bit value */
 };
 
-int smiapp_read(struct i2c_client *client, u32 reg, u32 *val);
-int smiapp_write(struct i2c_client *client, u32 reg, u32 val);
+struct smiapp_sensor;
+
+int smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val);
+int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val);
 
 #endif
-- 
1.7.2.5

