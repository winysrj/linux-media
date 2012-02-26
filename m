Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58435 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2BZD1b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 22:27:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH 02/11] mt9m032: Reorder code into section and whitespace cleanups
Date: Sun, 26 Feb 2012 04:27:28 +0100
Message-Id: <1330226857-8651-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m032.c |  162 +++++++++++++++++++++-------------------
 1 files changed, 85 insertions(+), 77 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index eb701e7..31ba86b 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -30,12 +30,11 @@
 #include <linux/v4l2-mediabus.h>
 
 #include <media/media-entity.h>
+#include <media/mt9m032.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
-#include <media/mt9m032.h>
-
 #define MT9M032_CHIP_VERSION			0x00
 #define     MT9M032_CHIP_VERSION_VALUE		0x1402
 #define MT9M032_ROW_START			0x01
@@ -73,24 +72,18 @@
 #define     MT9M032_FORMATTER2_DOUT_EN		0x1000
 #define     MT9M032_FORMATTER2_PIXCLK_EN	0x2000
 
-#define MT9M032_MAX_BLANKING_ROWS		0x7ff
-
-
 /*
- * The availible MT9M032 datasheet is missing documentation for register 0x10
+ * The available MT9M032 datasheet is missing documentation for register 0x10
  * MT9P031 seems to be close enough, so use constants from that datasheet for
  * now.
  * But keep the name MT9P031 to remind us, that this isn't really confirmed
  * for this sensor.
  */
-
 #define MT9P031_PLL_CONTROL			0x10
 #define     MT9P031_PLL_CONTROL_PWROFF		0x0050
 #define     MT9P031_PLL_CONTROL_PWRON		0x0051
 #define     MT9P031_PLL_CONTROL_USEPLL		0x0052
 
-
-
 /*
  * width and height include active boundry and black parts
  *
@@ -108,9 +101,7 @@
 #define MT9M032_WIDTH				1600
 #define MT9M032_HEIGHT				1152
 #define MT9M032_MINIMALSIZE			32
-
-#define to_mt9m032(sd)	container_of(sd, struct mt9m032, subdev)
-#define to_dev(sensor)	&((struct i2c_client *)v4l2_get_subdevdata(&sensor->subdev))->dev
+#define MT9M032_MAX_BLANKING_ROWS		0x7ff
 
 struct mt9m032 {
 	struct v4l2_subdev subdev;
@@ -129,6 +120,8 @@ struct mt9m032 {
 	struct v4l2_ctrl *hflip, *vflip;
 };
 
+#define to_mt9m032(sd)	container_of(sd, struct mt9m032, subdev)
+#define to_dev(sensor)	&((struct i2c_client *)v4l2_get_subdevdata(&sensor->subdev))->dev
 
 static int mt9m032_read_reg(struct mt9m032 *sensor, u8 reg)
 {
@@ -145,7 +138,6 @@ static int mt9m032_write_reg(struct mt9m032 *sensor, u8 reg,
 	return i2c_smbus_write_word_swapped(client, reg, data);
 }
 
-
 static unsigned long mt9m032_row_time(struct mt9m032 *sensor, int width)
 {
 	int effective_width;
@@ -173,23 +165,23 @@ static int mt9m032_update_timing(struct mt9m032 *sensor,
 	row_time = mt9m032_row_time(sensor, crop->width);
 
 	additional_blanking_rows = div_u64(((u64)1000000000) * interval->numerator,
-	                                  ((u64)interval->denominator) * row_time)
-	                           - crop->height;
+					  ((u64)interval->denominator) * row_time)
+				   - crop->height;
 
 	if (additional_blanking_rows > MT9M032_MAX_BLANKING_ROWS) {
 		/* hardware limits to 11 bit values */
 		interval->denominator = 1000;
 		interval->numerator = div_u64((crop->height + MT9M032_MAX_BLANKING_ROWS)
-		                              * ((u64)row_time) * interval->denominator,
+					      * ((u64)row_time) * interval->denominator,
 					      1000000000);
 		additional_blanking_rows = div_u64(((u64)1000000000) * interval->numerator,
-	                                  ((u64)interval->denominator) * row_time)
-	                           - crop->height;
+					  ((u64)interval->denominator) * row_time)
+				   - crop->height;
 	}
 	/* enforce minimal 1.6ms blanking time. */
 	min_blank = 1600000 / row_time;
 	additional_blanking_rows = clamp(additional_blanking_rows,
-	                                 min_blank, MT9M032_MAX_BLANKING_ROWS);
+					 min_blank, MT9M032_MAX_BLANKING_ROWS);
 
 	return mt9m032_write_reg(sensor, MT9M032_VBLANK, additional_blanking_rows);
 }
@@ -224,17 +216,51 @@ static int update_formatter2(struct mt9m032 *sensor, bool streaming)
 	return mt9m032_write_reg(sensor, MT9M032_FORMATTER2, reg_val);
 }
 
-static int mt9m032_s_stream(struct v4l2_subdev *subdev, int streaming)
+static int mt9m032_setup_pll(struct mt9m032 *sensor)
 {
-	struct mt9m032 *sensor = to_mt9m032(subdev);
-	int ret;
+	struct mt9m032_platform_data* pdata = sensor->pdata;
+	u16 reg_pll1;
+	unsigned int pre_div;
+	int res, ret;
 
-	ret = update_formatter2(sensor, streaming);
+	/* TODO: also support other pre-div values */
+	if (pdata->pll_pre_div != 6) {
+		dev_warn(to_dev(sensor),
+			"Unsupported PLL pre-divisor value %u, using default 6\n",
+			pdata->pll_pre_div);
+	}
+	pre_div = 6;
+
+	sensor->pix_clock = pdata->ext_clock * pdata->pll_mul /
+		(pre_div * pdata->pll_out_div);
+
+	reg_pll1 = ((pdata->pll_out_div - 1) & MT9M032_PLL_CONFIG1_OUTDIV_MASK)
+		   | pdata->pll_mul << MT9M032_PLL_CONFIG1_MUL_SHIFT;
+
+	ret = mt9m032_write_reg(sensor, MT9M032_PLL_CONFIG1, reg_pll1);
 	if (!ret)
-		sensor->streaming = streaming;
+		ret = mt9m032_write_reg(sensor,
+					MT9P031_PLL_CONTROL,
+					MT9P031_PLL_CONTROL_PWRON | MT9P031_PLL_CONTROL_USEPLL);
+
+	if (!ret)
+		ret = mt9m032_write_reg(sensor, MT9M032_READ_MODE1, 0x8006);
+							/* more reserved, Continuous */
+							/* Master Mode */
+	if (!ret)
+		res = mt9m032_read_reg(sensor, MT9M032_READ_MODE1);
+
+	if (!ret)
+		ret = mt9m032_write_reg(sensor, MT9M032_FORMATTER1, 0x111e);
+					/* Set 14-bit mode, select 7 divider */
+
 	return ret;
 }
 
+/* -----------------------------------------------------------------------------
+ * Subdev pad operations
+ */
+
 static int mt9m032_enum_mbus_code(struct v4l2_subdev *subdev,
 				  struct v4l2_subdev_fh *fh,
 				  struct v4l2_subdev_mbus_code_enum *code)
@@ -424,6 +450,21 @@ static int mt9m032_set_frame_interval(struct v4l2_subdev *subdev,
 	return ret;
 }
 
+static int mt9m032_s_stream(struct v4l2_subdev *subdev, int streaming)
+{
+	struct mt9m032 *sensor = to_mt9m032(subdev);
+	int ret;
+
+	ret = update_formatter2(sensor, streaming);
+	if (!ret)
+		sensor->streaming = streaming;
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev core operations
+ */
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9m032_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
@@ -466,6 +507,10 @@ static int mt9m032_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev control operations
+ */
+
 static int update_read_mode2(struct mt9m032 *sensor, bool vflip, bool hflip)
 {
 	int reg_val = (!!vflip) << MT9M032_READ_MODE2_VFLIP_SHIFT
@@ -532,51 +577,10 @@ static int mt9m032_set_gain(struct mt9m032 *sensor, s32 val)
 	return mt9m032_write_reg(sensor, MT9M032_GAIN_ALL, reg_val);
 }
 
-static int mt9m032_setup_pll(struct mt9m032 *sensor)
-{
-	struct mt9m032_platform_data* pdata = sensor->pdata;
-	u16 reg_pll1;
-	unsigned int pre_div;
-	int res, ret;
-
-	/* TODO: also support other pre-div values */
-	if (pdata->pll_pre_div != 6) {
-		dev_warn(to_dev(sensor),
-			"Unsupported PLL pre-divisor value %u, using default 6\n",
-			pdata->pll_pre_div);
-	}
-	pre_div = 6;
-
-	sensor->pix_clock = pdata->ext_clock * pdata->pll_mul /
-		(pre_div * pdata->pll_out_div);
-
-	reg_pll1 = ((pdata->pll_out_div - 1) & MT9M032_PLL_CONFIG1_OUTDIV_MASK)
-		   | pdata->pll_mul << MT9M032_PLL_CONFIG1_MUL_SHIFT;
-
-	ret = mt9m032_write_reg(sensor, MT9M032_PLL_CONFIG1, reg_pll1);
-	if (!ret)
-		ret = mt9m032_write_reg(sensor,
-		                        MT9P031_PLL_CONTROL,
-		                        MT9P031_PLL_CONTROL_PWRON | MT9P031_PLL_CONTROL_USEPLL);
-
-	if (!ret)
-		ret = mt9m032_write_reg(sensor, MT9M032_READ_MODE1, 0x8006);
-							/* more reserved, Continuous */
-							/* Master Mode */
-	if (!ret)
-		res = mt9m032_read_reg(sensor, MT9M032_READ_MODE1);
-
-	if (!ret)
-		ret = mt9m032_write_reg(sensor, MT9M032_FORMATTER1, 0x111e);
-					/* Set 14-bit mode, select 7 divider */
-
-	return ret;
-}
-
 static int mt9m032_try_ctrl(struct v4l2_ctrl *ctrl)
 {
 	if (ctrl->id == V4L2_CID_GAIN && ctrl->val >= 63) {
-		 /* round because of multiplier used for values >= 63 */
+		/* round because of multiplier used for values >= 63 */
 		ctrl->val &= ~1;
 	}
 
@@ -605,17 +609,12 @@ static int mt9m032_set_ctrl(struct v4l2_ctrl *ctrl)
 	}
 }
 
-static const struct v4l2_subdev_video_ops mt9m032_video_ops = {
-	.s_stream = mt9m032_s_stream,
-	.g_frame_interval = mt9m032_get_frame_interval,
-	.s_frame_interval = mt9m032_set_frame_interval,
-};
-
 static struct v4l2_ctrl_ops mt9m032_ctrl_ops = {
 	.s_ctrl = mt9m032_set_ctrl,
 	.try_ctrl = mt9m032_try_ctrl,
 };
 
+/* -------------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops mt9m032_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -624,6 +623,12 @@ static const struct v4l2_subdev_core_ops mt9m032_core_ops = {
 #endif
 };
 
+static const struct v4l2_subdev_video_ops mt9m032_video_ops = {
+	.s_stream = mt9m032_s_stream,
+	.g_frame_interval = mt9m032_get_frame_interval,
+	.s_frame_interval = mt9m032_set_frame_interval,
+};
+
 static const struct v4l2_subdev_pad_ops mt9m032_pad_ops = {
 	.enum_mbus_code = mt9m032_enum_mbus_code,
 	.enum_frame_size = mt9m032_enum_frame_size,
@@ -639,6 +644,10 @@ static const struct v4l2_subdev_ops mt9m032_ops = {
 	.pad = &mt9m032_pad_ops,
 };
 
+/* -----------------------------------------------------------------------------
+ * Driver initialization and probing
+ */
+
 static int mt9m032_probe(struct i2c_client *client,
 			 const struct i2c_device_id *devid)
 {
@@ -706,7 +715,6 @@ static int mt9m032_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
 			  V4L2_CID_EXPOSURE, 0, 8000, 1, 1700);    /* 1.7ms */
 
-
 	if (sensor->ctrls.error) {
 		ret = sensor->ctrls.error;
 		dev_err(&client->dev, "control initialization error %d\n", ret);
@@ -793,16 +801,16 @@ static int mt9m032_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id mt9m032_id_table[] = {
-	{MT9M032_NAME, 0},
-	{}
+	{ MT9M032_NAME, 0 },
+	{ }
 };
 
 MODULE_DEVICE_TABLE(i2c, mt9m032_id_table);
 
 static struct i2c_driver mt9m032_i2c_driver = {
 	.driver = {
-		   .name = MT9M032_NAME,
-		   },
+		.name = MT9M032_NAME,
+	},
 	.probe = mt9m032_probe,
 	.remove = mt9m032_remove,
 	.id_table = mt9m032_id_table,
-- 
1.7.3.4

