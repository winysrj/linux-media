Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49947 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab3LDTPx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 14:15:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Enric Balletbo i Serra <eballetbo@gmail.com>
Subject: [PATCH 5/6] mt9v032: Add support for model-specific parameters
Date: Wed,  4 Dec 2013 20:15:52 +0100
Message-Id: <1386184553-12770-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To prepare support of the MT9V034, add the necessary infrastructure to
support model-specific parameters.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9v032.c | 82 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 67 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index a31d6d1..62db26b 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -126,15 +126,51 @@ enum mt9v032_model {
 	MT9V032_MODEL_MONO,
 };
 
+struct mt9v032_model_version {
+	unsigned int version;
+	const char *name;
+};
+
+struct mt9v032_model_data {
+	unsigned int min_row_time;
+	unsigned int min_hblank;
+	unsigned int min_vblank;
+	unsigned int max_vblank;
+	unsigned int min_shutter;
+	unsigned int max_shutter;
+	unsigned int pclk_reg;
+};
+
 struct mt9v032_model_info {
+	const struct mt9v032_model_data *data;
 	bool color;
 };
 
+static const struct mt9v032_model_version mt9v032_versions[] = {
+	{ MT9V032_CHIP_ID_REV1, "MT9V032 rev1/2" },
+	{ MT9V032_CHIP_ID_REV3, "MT9V032 rev3" },
+};
+
+static const struct mt9v032_model_data mt9v032_model_data[] = {
+	{
+		/* MT9V032 revisions 1/2/3 */
+		.min_row_time = 660,
+		.min_hblank = MT9V032_HORIZONTAL_BLANKING_MIN,
+		.min_vblank = MT9V032_VERTICAL_BLANKING_MIN,
+		.max_vblank = MT9V032_VERTICAL_BLANKING_MAX,
+		.min_shutter = MT9V032_TOTAL_SHUTTER_WIDTH_MIN,
+		.max_shutter = MT9V032_TOTAL_SHUTTER_WIDTH_MAX,
+		.pclk_reg = MT9V032_PIXEL_CLOCK,
+	},
+};
+
 static const struct mt9v032_model_info mt9v032_models[] = {
 	[MT9V032_MODEL_COLOR] = {
+		.data = &mt9v032_model_data[0],
 		.color = true,
 	},
 	[MT9V032_MODEL_MONO] = {
+		.data = &mt9v032_model_data[0],
 		.color = false,
 	},
 };
@@ -161,6 +197,7 @@ struct mt9v032 {
 
 	struct mt9v032_platform_data *pdata;
 	const struct mt9v032_model_info *model;
+	const struct mt9v032_model_version *version;
 
 	u32 sysclk;
 	u16 chip_control;
@@ -232,9 +269,11 @@ mt9v032_update_hblank(struct mt9v032 *mt9v032)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
 	struct v4l2_rect *crop = &mt9v032->crop;
+	unsigned int hblank;
 
-	return mt9v032_write(client, MT9V032_HORIZONTAL_BLANKING,
-			     max_t(s32, mt9v032->hblank, 660 - crop->width));
+	hblank = max_t(s32, mt9v032->hblank,
+		       mt9v032->model->data->min_row_time - crop->width);
+	return mt9v032_write(client, MT9V032_HORIZONTAL_BLANKING, hblank);
 }
 
 static int mt9v032_power_on(struct mt9v032 *mt9v032)
@@ -279,7 +318,7 @@ static int __mt9v032_set_power(struct mt9v032 *mt9v032, bool on)
 
 	/* Configure the pixel clock polarity */
 	if (mt9v032->pdata && mt9v032->pdata->clk_pol) {
-		ret = mt9v032_write(client, MT9V032_PIXEL_CLOCK,
+		ret = mt9v032_write(client, mt9v032->model->data->pclk_reg,
 				MT9V032_PIXEL_CLOCK_INV_PXL_CLK);
 		if (ret < 0)
 			return ret;
@@ -678,7 +717,8 @@ static int mt9v032_registered(struct v4l2_subdev *subdev)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(subdev);
 	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
-	s32 data;
+	unsigned int i;
+	s32 version;
 	int ret;
 
 	dev_info(&client->dev, "Probing MT9V032 at address 0x%02x\n",
@@ -691,17 +731,29 @@ static int mt9v032_registered(struct v4l2_subdev *subdev)
 	}
 
 	/* Read and check the sensor version */
-	data = mt9v032_read(client, MT9V032_CHIP_VERSION);
-	if (data != MT9V032_CHIP_ID_REV1 && data != MT9V032_CHIP_ID_REV3) {
-		dev_err(&client->dev, "MT9V032 not detected, wrong version "
-				"0x%04x\n", data);
+	version = mt9v032_read(client, MT9V032_CHIP_VERSION);
+	if (version < 0) {
+		dev_err(&client->dev, "Failed reading chip version\n");
+		return version;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mt9v032_versions); ++i) {
+		if (mt9v032_versions[i].version == version) {
+			mt9v032->version = &mt9v032_versions[i];
+			break;
+		}
+	}
+
+	if (mt9v032->version == NULL) {
+		dev_err(&client->dev, "Unsupported chip version 0x%04x\n",
+			version);
 		return -ENODEV;
 	}
 
 	mt9v032_power_off(mt9v032);
 
-	dev_info(&client->dev, "MT9V032 detected at address 0x%02x\n",
-			client->addr);
+	dev_info(&client->dev, "%s detected at address 0x%02x\n",
+		 mt9v032->version->name, client->addr);
 
 	mt9v032_configure_pixel_rate(mt9v032);
 
@@ -811,16 +863,16 @@ static int mt9v032_probe(struct i2c_client *client,
 			       V4L2_CID_EXPOSURE_AUTO, V4L2_EXPOSURE_MANUAL, 0,
 			       V4L2_EXPOSURE_AUTO);
 	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
-			  V4L2_CID_EXPOSURE, MT9V032_TOTAL_SHUTTER_WIDTH_MIN,
-			  MT9V032_TOTAL_SHUTTER_WIDTH_MAX, 1,
+			  V4L2_CID_EXPOSURE, mt9v032->model->data->min_shutter,
+			  mt9v032->model->data->max_shutter, 1,
 			  MT9V032_TOTAL_SHUTTER_WIDTH_DEF);
 	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
-			  V4L2_CID_HBLANK, MT9V032_HORIZONTAL_BLANKING_MIN,
+			  V4L2_CID_HBLANK, mt9v032->model->data->min_hblank,
 			  MT9V032_HORIZONTAL_BLANKING_MAX, 1,
 			  MT9V032_HORIZONTAL_BLANKING_DEF);
 	v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
-			  V4L2_CID_VBLANK, MT9V032_VERTICAL_BLANKING_MIN,
-			  MT9V032_VERTICAL_BLANKING_MAX, 1,
+			  V4L2_CID_VBLANK, mt9v032->model->data->min_vblank,
+			  mt9v032->model->data->max_vblank, 1,
 			  MT9V032_VERTICAL_BLANKING_DEF);
 	mt9v032->test_pattern = v4l2_ctrl_new_std_menu_items(&mt9v032->ctrls,
 				&mt9v032_ctrl_ops, V4L2_CID_TEST_PATTERN,
-- 
1.8.3.2

