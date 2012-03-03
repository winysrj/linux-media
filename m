Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33412 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab2CCP2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2012 10:28:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 06/10] mt9m032: Pass an i2c_client pointer to the register read/write functions
Date: Sat,  3 Mar 2012 16:28:11 +0100
Message-Id: <1330788495-18762-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the mt9m032 * argument to register read/write functions with an
i2c_client *. As the register access functions are often called several
times in a single location, this removes several casts at runtime.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m032.c |   78 +++++++++++++++++++++--------------------
 1 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index 74f0cdd..cfed53a 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -124,18 +124,13 @@ struct mt9m032 {
 #define to_dev(sensor) \
 	(&((struct i2c_client *)v4l2_get_subdevdata(&(sensor)->subdev))->dev)
 
-static int mt9m032_read_reg(struct mt9m032 *sensor, u8 reg)
+static int mt9m032_read_reg(struct i2c_client *client, u8 reg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
-
 	return i2c_smbus_read_word_swapped(client, reg);
 }
 
-static int mt9m032_write_reg(struct mt9m032 *sensor, u8 reg,
-		     const u16 data)
+static int mt9m032_write_reg(struct i2c_client *client, u8 reg, const u16 data)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
-
 	return i2c_smbus_write_word_swapped(client, reg, data);
 }
 
@@ -153,6 +148,7 @@ static unsigned long mt9m032_row_time(struct mt9m032 *sensor, int width)
 static int mt9m032_update_timing(struct mt9m032 *sensor,
 				 struct v4l2_fract *interval)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
 	struct v4l2_rect *crop = &sensor->crop;
 	unsigned long row_time;
 	int additional_blanking_rows;
@@ -182,24 +178,26 @@ static int mt9m032_update_timing(struct mt9m032 *sensor,
 	additional_blanking_rows = clamp(additional_blanking_rows,
 					 min_blank, MT9M032_MAX_BLANKING_ROWS);
 
-	return mt9m032_write_reg(sensor, MT9M032_VBLANK, additional_blanking_rows);
+	return mt9m032_write_reg(client, MT9M032_VBLANK,
+				 additional_blanking_rows);
 }
 
 static int mt9m032_update_geom_timing(struct mt9m032 *sensor)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
 	int ret;
 
-	ret = mt9m032_write_reg(sensor, MT9M032_COLUMN_SIZE,
+	ret = mt9m032_write_reg(client, MT9M032_COLUMN_SIZE,
 				sensor->crop.width - 1);
 	if (!ret)
-		ret = mt9m032_write_reg(sensor, MT9M032_ROW_SIZE,
+		ret = mt9m032_write_reg(client, MT9M032_ROW_SIZE,
 					sensor->crop.height - 1);
 	/* offsets compensate for black border */
 	if (!ret)
-		ret = mt9m032_write_reg(sensor, MT9M032_COLUMN_START,
+		ret = mt9m032_write_reg(client, MT9M032_COLUMN_START,
 					sensor->crop.left);
 	if (!ret)
-		ret = mt9m032_write_reg(sensor, MT9M032_ROW_START,
+		ret = mt9m032_write_reg(client, MT9M032_ROW_START,
 					sensor->crop.top);
 	if (!ret)
 		ret = mt9m032_update_timing(sensor, NULL);
@@ -208,6 +206,7 @@ static int mt9m032_update_geom_timing(struct mt9m032 *sensor)
 
 static int update_formatter2(struct mt9m032 *sensor, bool streaming)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
 	u16 reg_val =   MT9M032_FORMATTER2_DOUT_EN
 		      | 0x0070;  /* parts reserved! */
 				 /* possibly for changing to 14-bit mode */
@@ -215,11 +214,12 @@ static int update_formatter2(struct mt9m032 *sensor, bool streaming)
 	if (streaming)
 		reg_val |= MT9M032_FORMATTER2_PIXCLK_EN;   /* pixclock enable */
 
-	return mt9m032_write_reg(sensor, MT9M032_FORMATTER2, reg_val);
+	return mt9m032_write_reg(client, MT9M032_FORMATTER2, reg_val);
 }
 
 static int mt9m032_setup_pll(struct mt9m032 *sensor)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
 	struct mt9m032_platform_data* pdata = sensor->pdata;
 	u16 reg_pll1;
 	unsigned int pre_div;
@@ -239,21 +239,21 @@ static int mt9m032_setup_pll(struct mt9m032 *sensor)
 	reg_pll1 = ((pdata->pll_out_div - 1) & MT9M032_PLL_CONFIG1_OUTDIV_MASK)
 		   | pdata->pll_mul << MT9M032_PLL_CONFIG1_MUL_SHIFT;
 
-	ret = mt9m032_write_reg(sensor, MT9M032_PLL_CONFIG1, reg_pll1);
+	ret = mt9m032_write_reg(client, MT9M032_PLL_CONFIG1, reg_pll1);
 	if (!ret)
-		ret = mt9m032_write_reg(sensor,
+		ret = mt9m032_write_reg(client,
 					MT9P031_PLL_CONTROL,
 					MT9P031_PLL_CONTROL_PWRON | MT9P031_PLL_CONTROL_USEPLL);
 
 	if (!ret)
-		ret = mt9m032_write_reg(sensor, MT9M032_READ_MODE1, 0x8006);
+		ret = mt9m032_write_reg(client, MT9M032_READ_MODE1, 0x8006);
 							/* more reserved, Continuous */
 							/* Master Mode */
 	if (!ret)
-		res = mt9m032_read_reg(sensor, MT9M032_READ_MODE1);
+		res = mt9m032_read_reg(client, MT9M032_READ_MODE1);
 
 	if (!ret)
-		ret = mt9m032_write_reg(sensor, MT9M032_FORMATTER1, 0x111e);
+		ret = mt9m032_write_reg(client, MT9M032_FORMATTER1, 0x111e);
 					/* Set 14-bit mode, select 7 divider */
 
 	return ret;
@@ -469,7 +469,7 @@ static int mt9m032_g_register(struct v4l2_subdev *sd,
 	if (reg->match.addr != client->addr)
 		return -ENODEV;
 
-	val = mt9m032_read_reg(sensor, reg->reg);
+	val = mt9m032_read_reg(client, reg->reg);
 	if (val < 0)
 		return -EIO;
 
@@ -491,10 +491,7 @@ static int mt9m032_s_register(struct v4l2_subdev *sd,
 	if (reg->match.addr != client->addr)
 		return -ENODEV;
 
-	if (mt9m032_write_reg(sensor, reg->reg, reg->val) < 0)
-		return -EIO;
-
-	return 0;
+	return mt9m032_write_reg(client, reg->reg, reg->val);
 }
 #endif
 
@@ -504,12 +501,13 @@ static int mt9m032_s_register(struct v4l2_subdev *sd,
 
 static int update_read_mode2(struct mt9m032 *sensor, bool vflip, bool hflip)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
 	int reg_val = (!!vflip) << MT9M032_READ_MODE2_VFLIP_SHIFT
 		      | (!!hflip) << MT9M032_READ_MODE2_HFLIP_SHIFT
 		      | MT9M032_READ_MODE2_ROW_BLC
 		      | 0x0007;
 
-	return mt9m032_write_reg(sensor, MT9M032_READ_MODE2, reg_val);
+	return mt9m032_write_reg(client, MT9M032_READ_MODE2, reg_val);
 }
 
 static int mt9m032_set_hflip(struct mt9m032 *sensor, s32 val)
@@ -524,6 +522,7 @@ static int mt9m032_set_vflip(struct mt9m032 *sensor, s32 val)
 
 static int mt9m032_set_exposure(struct mt9m032 *sensor, s32 val)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
 	int shutter_width;
 	u16 high_val, low_val;
 	int ret;
@@ -534,15 +533,17 @@ static int mt9m032_set_exposure(struct mt9m032 *sensor, s32 val)
 	high_val = (shutter_width >> 16) & 0xf;
 	low_val = shutter_width & 0xffff;
 
-	ret = mt9m032_write_reg(sensor, MT9M032_SHUTTER_WIDTH_HIGH, high_val);
+	ret = mt9m032_write_reg(client, MT9M032_SHUTTER_WIDTH_HIGH, high_val);
 	if (!ret)
-		ret = mt9m032_write_reg(sensor, MT9M032_SHUTTER_WIDTH_LOW, low_val);
+		ret = mt9m032_write_reg(client, MT9M032_SHUTTER_WIDTH_LOW,
+					low_val);
 
 	return ret;
 }
 
 static int mt9m032_set_gain(struct mt9m032 *sensor, s32 val)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
 	int digital_gain_val;	/* in 1/8th (0..127) */
 	int analog_mul;		/* 0 or 1 */
 	int analog_gain_val;	/* in 1/16th. (0..63) */
@@ -565,7 +566,7 @@ static int mt9m032_set_gain(struct mt9m032 *sensor, s32 val)
 		  | (analog_mul & 1) << MT9M032_GAIN_AMUL_SHIFT
 		  | (analog_gain_val & MT9M032_GAIN_ANALOG_MASK);
 
-	return mt9m032_write_reg(sensor, MT9M032_GAIN_ALL, reg_val);
+	return mt9m032_write_reg(client, MT9M032_GAIN_ALL, reg_val);
 }
 
 static int mt9m032_try_ctrl(struct v4l2_ctrl *ctrl)
@@ -670,7 +671,7 @@ static int mt9m032_probe(struct i2c_client *client,
 	 * the code will need to be extended with the appropriate platform
 	 * callback to setup the clock.
 	 */
-	chip_version = mt9m032_read_reg(sensor, MT9M032_CHIP_VERSION);
+	chip_version = mt9m032_read_reg(client, MT9M032_CHIP_VERSION);
 	if (chip_version == MT9M032_CHIP_VERSION_VALUE) {
 		dev_info(&client->dev, "mt9m032: detected sensor.\n");
 	} else {
@@ -718,10 +719,10 @@ static int mt9m032_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto free_ctrl;
 
-	ret = mt9m032_write_reg(sensor, MT9M032_RESET, 1);	/* reset on */
+	ret = mt9m032_write_reg(client, MT9M032_RESET, 1);	/* reset on */
 	if (ret < 0)
 		goto free_ctrl;
-	mt9m032_write_reg(sensor, MT9M032_RESET, 0);	/* reset off */
+	mt9m032_write_reg(client, MT9M032_RESET, 0);	/* reset off */
 	if (ret < 0)
 		goto free_ctrl;
 
@@ -737,31 +738,32 @@ static int mt9m032_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto free_ctrl;
 
-	ret = mt9m032_write_reg(sensor, 0x41, 0x0000);	/* reserved !!! */
+	ret = mt9m032_write_reg(client, 0x41, 0x0000);	/* reserved !!! */
 	if (ret < 0)
 		goto free_ctrl;
-	ret = mt9m032_write_reg(sensor, 0x42, 0x0003);	/* reserved !!! */
+	ret = mt9m032_write_reg(client, 0x42, 0x0003);	/* reserved !!! */
 	if (ret < 0)
 		goto free_ctrl;
-	ret = mt9m032_write_reg(sensor, 0x43, 0x0003);	/* reserved !!! */
+	ret = mt9m032_write_reg(client, 0x43, 0x0003);	/* reserved !!! */
 	if (ret < 0)
 		goto free_ctrl;
-	ret = mt9m032_write_reg(sensor, 0x7f, 0x0000);	/* reserved !!! */
+	ret = mt9m032_write_reg(client, 0x7f, 0x0000);	/* reserved !!! */
 	if (ret < 0)
 		goto free_ctrl;
 	if (sensor->pdata->invert_pixclock) {
-		mt9m032_write_reg(sensor, MT9M032_PIX_CLK_CTRL, MT9M032_PIX_CLK_CTRL_INV_PIXCLK);
+		mt9m032_write_reg(client, MT9M032_PIX_CLK_CTRL,
+				  MT9M032_PIX_CLK_CTRL_INV_PIXCLK);
 		if (ret < 0)
 			goto free_ctrl;
 	}
 
-	res = mt9m032_read_reg(sensor, MT9M032_PIX_CLK_CTRL);
+	res = mt9m032_read_reg(client, MT9M032_PIX_CLK_CTRL);
 
-	ret = mt9m032_write_reg(sensor, MT9M032_RESTART, 1); /* Restart on */
+	ret = mt9m032_write_reg(client, MT9M032_RESTART, 1); /* Restart on */
 	if (ret < 0)
 		goto free_ctrl;
 	msleep(100);
-	ret = mt9m032_write_reg(sensor, MT9M032_RESTART, 0); /* Restart off */
+	ret = mt9m032_write_reg(client, MT9M032_RESTART, 0); /* Restart off */
 	if (ret < 0)
 		goto free_ctrl;
 	msleep(100);
-- 
1.7.3.4

