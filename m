Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49946 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab3LDTPx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 14:15:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Enric Balletbo i Serra <eballetbo@gmail.com>
Subject: [PATCH 6/6] mt9v032: Add support for the MT9V034
Date: Wed,  4 Dec 2013 20:15:53 +0100
Message-Id: <1386184553-12770-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MT9V034 sensor is very similar to the MT9V032, with a couple of
different registers and parameters.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9v032.c | 54 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 62db26b..0d2b4a8 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -36,6 +36,7 @@
 #define MT9V032_CHIP_VERSION				0x00
 #define		MT9V032_CHIP_ID_REV1			0x1311
 #define		MT9V032_CHIP_ID_REV3			0x1313
+#define		MT9V034_CHIP_ID_REV1			0X1324
 #define MT9V032_COLUMN_START				0x01
 #define		MT9V032_COLUMN_START_MIN		1
 #define		MT9V032_COLUMN_START_DEF		1
@@ -54,12 +55,15 @@
 #define		MT9V032_WINDOW_WIDTH_MAX		752
 #define MT9V032_HORIZONTAL_BLANKING			0x05
 #define		MT9V032_HORIZONTAL_BLANKING_MIN		43
+#define		MT9V034_HORIZONTAL_BLANKING_MIN		61
 #define		MT9V032_HORIZONTAL_BLANKING_DEF		94
 #define		MT9V032_HORIZONTAL_BLANKING_MAX		1023
 #define MT9V032_VERTICAL_BLANKING			0x06
 #define		MT9V032_VERTICAL_BLANKING_MIN		4
+#define		MT9V034_VERTICAL_BLANKING_MIN		2
 #define		MT9V032_VERTICAL_BLANKING_DEF		45
 #define		MT9V032_VERTICAL_BLANKING_MAX		3000
+#define		MT9V034_VERTICAL_BLANKING_MAX		32288
 #define MT9V032_CHIP_CONTROL				0x07
 #define		MT9V032_CHIP_CONTROL_MASTER_MODE	(1 << 3)
 #define		MT9V032_CHIP_CONTROL_DOUT_ENABLE	(1 << 7)
@@ -69,8 +73,10 @@
 #define MT9V032_SHUTTER_WIDTH_CONTROL			0x0a
 #define MT9V032_TOTAL_SHUTTER_WIDTH			0x0b
 #define		MT9V032_TOTAL_SHUTTER_WIDTH_MIN		1
+#define		MT9V034_TOTAL_SHUTTER_WIDTH_MIN		0
 #define		MT9V032_TOTAL_SHUTTER_WIDTH_DEF		480
 #define		MT9V032_TOTAL_SHUTTER_WIDTH_MAX		32767
+#define		MT9V034_TOTAL_SHUTTER_WIDTH_MAX		32765
 #define MT9V032_RESET					0x0c
 #define MT9V032_READ_MODE				0x0d
 #define		MT9V032_READ_MODE_ROW_BIN_MASK		(3 << 0)
@@ -82,6 +88,8 @@
 #define		MT9V032_READ_MODE_DARK_COLUMNS		(1 << 6)
 #define		MT9V032_READ_MODE_DARK_ROWS		(1 << 7)
 #define MT9V032_PIXEL_OPERATION_MODE			0x0f
+#define		MT9V034_PIXEL_OPERATION_MODE_HDR	(1 << 0)
+#define		MT9V034_PIXEL_OPERATION_MODE_COLOR	(1 << 1)
 #define		MT9V032_PIXEL_OPERATION_MODE_COLOR	(1 << 2)
 #define		MT9V032_PIXEL_OPERATION_MODE_HDR	(1 << 6)
 #define MT9V032_ANALOG_GAIN				0x35
@@ -97,9 +105,12 @@
 #define		MT9V032_DARK_AVG_HIGH_THRESH_MASK	(255 << 8)
 #define		MT9V032_DARK_AVG_HIGH_THRESH_SHIFT	8
 #define MT9V032_ROW_NOISE_CORR_CONTROL			0x70
+#define		MT9V034_ROW_NOISE_CORR_ENABLE		(1 << 0)
+#define		MT9V034_ROW_NOISE_CORR_USE_BLK_AVG	(1 << 1)
 #define		MT9V032_ROW_NOISE_CORR_ENABLE		(1 << 5)
 #define		MT9V032_ROW_NOISE_CORR_USE_BLK_AVG	(1 << 7)
 #define MT9V032_PIXEL_CLOCK				0x74
+#define MT9V034_PIXEL_CLOCK				0x72
 #define		MT9V032_PIXEL_CLOCK_INV_LINE		(1 << 0)
 #define		MT9V032_PIXEL_CLOCK_INV_FRAME		(1 << 1)
 #define		MT9V032_PIXEL_CLOCK_XOR_LINE		(1 << 2)
@@ -122,8 +133,10 @@
 #define MT9V032_THERMAL_INFO				0xc1
 
 enum mt9v032_model {
-	MT9V032_MODEL_COLOR,
-	MT9V032_MODEL_MONO,
+	MT9V032_MODEL_V032_COLOR,
+	MT9V032_MODEL_V032_MONO,
+	MT9V032_MODEL_V034_COLOR,
+	MT9V032_MODEL_V034_MONO,
 };
 
 struct mt9v032_model_version {
@@ -149,6 +162,7 @@ struct mt9v032_model_info {
 static const struct mt9v032_model_version mt9v032_versions[] = {
 	{ MT9V032_CHIP_ID_REV1, "MT9V032 rev1/2" },
 	{ MT9V032_CHIP_ID_REV3, "MT9V032 rev3" },
+	{ MT9V034_CHIP_ID_REV1, "MT9V034 rev1" },
 };
 
 static const struct mt9v032_model_data mt9v032_model_data[] = {
@@ -161,18 +175,35 @@ static const struct mt9v032_model_data mt9v032_model_data[] = {
 		.min_shutter = MT9V032_TOTAL_SHUTTER_WIDTH_MIN,
 		.max_shutter = MT9V032_TOTAL_SHUTTER_WIDTH_MAX,
 		.pclk_reg = MT9V032_PIXEL_CLOCK,
+	}, {
+		/* MT9V034 */
+		.min_row_time = 690,
+		.min_hblank = MT9V034_HORIZONTAL_BLANKING_MIN,
+		.min_vblank = MT9V034_VERTICAL_BLANKING_MIN,
+		.max_vblank = MT9V034_VERTICAL_BLANKING_MAX,
+		.min_shutter = MT9V034_TOTAL_SHUTTER_WIDTH_MIN,
+		.max_shutter = MT9V034_TOTAL_SHUTTER_WIDTH_MAX,
+		.pclk_reg = MT9V034_PIXEL_CLOCK,
 	},
 };
 
 static const struct mt9v032_model_info mt9v032_models[] = {
-	[MT9V032_MODEL_COLOR] = {
+	[MT9V032_MODEL_V032_COLOR] = {
 		.data = &mt9v032_model_data[0],
 		.color = true,
 	},
-	[MT9V032_MODEL_MONO] = {
+	[MT9V032_MODEL_V032_MONO] = {
 		.data = &mt9v032_model_data[0],
 		.color = false,
 	},
+	[MT9V032_MODEL_V034_COLOR] = {
+		.data = &mt9v032_model_data[1],
+		.color = true,
+	},
+	[MT9V032_MODEL_V034_MONO] = {
+		.data = &mt9v032_model_data[1],
+		.color = false,
+	},
 };
 
 struct mt9v032 {
@@ -269,10 +300,15 @@ mt9v032_update_hblank(struct mt9v032 *mt9v032)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
 	struct v4l2_rect *crop = &mt9v032->crop;
+	unsigned int min_hblank = mt9v032->model->data->min_hblank;
 	unsigned int hblank;
 
-	hblank = max_t(s32, mt9v032->hblank,
-		       mt9v032->model->data->min_row_time - crop->width);
+	if (mt9v032->version->version == MT9V034_CHIP_ID_REV1)
+		min_hblank += (mt9v032->hratio - 1) * 10;
+	min_hblank = max((int)mt9v032->model->data->min_row_time - crop->width,
+			 (int)min_hblank);
+	hblank = max_t(unsigned int, mt9v032->hblank, min_hblank);
+
 	return mt9v032_write(client, MT9V032_HORIZONTAL_BLANKING, hblank);
 }
 
@@ -958,8 +994,10 @@ static int mt9v032_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id mt9v032_id[] = {
-	{ "mt9v032", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_COLOR] },
-	{ "mt9v032m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_MONO] },
+	{ "mt9v032", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V032_COLOR] },
+	{ "mt9v032m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V032_MONO] },
+	{ "mt9v034", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V034_COLOR] },
+	{ "mt9v034m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V034_MONO] },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, mt9v032_id);
-- 
1.8.3.2

