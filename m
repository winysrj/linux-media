Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51792 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab0HCK5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 06:57:54 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Philipp Wiesner <p.wiesner@phytec.de>
Subject: [PATCH v2 10/11] mt9m111: rewrite set_pixfmt
Date: Tue,  3 Aug 2010 12:57:48 +0200
Message-Id: <1280833069-26993-11-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

added more supported BE colour formats
and also support BGR565 swapped pixel formats

removed pixfmt helper functions and option flags
setting the configuration register directly in set_pixfmt

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
Changes v1 -> v2
	* removed unrelated OPMODE handling in this function

 drivers/media/video/mt9m111.c |  143 ++++++++++++++++-------------------------
 1 files changed, 56 insertions(+), 87 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index e865938..25b2317 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -101,7 +101,8 @@
 
 #define MT9M111_OPMODE_AUTOEXPO_EN	(1 << 14)
 #define MT9M111_OPMODE_AUTOWHITEBAL_EN	(1 << 1)
-
+#define MT9M111_OUTFMT_FLIP_BAYER_COL  (1 << 9)
+#define MT9M111_OUTFMT_FLIP_BAYER_ROW  (1 << 8)
 #define MT9M111_OUTFMT_PROCESSED_BAYER	(1 << 14)
 #define MT9M111_OUTFMT_BYPASS_IFP	(1 << 10)
 #define MT9M111_OUTFMT_INV_PIX_CLOCK	(1 << 9)
@@ -119,6 +120,7 @@
 #define MT9M111_OUTFMT_SWAP_YCbCr_C_Y	(1 << 1)
 #define MT9M111_OUTFMT_SWAP_RGB_EVEN	(1 << 1)
 #define MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr	(1 << 0)
+#define MT9M111_OUTFMT_SWAP_RGB_R_B	(1 << 0)
 
 /*
  * Camera control register addresses (0x200..0x2ff not implemented)
@@ -161,7 +163,11 @@ static const struct mt9m111_datafmt mt9m111_colour_fmts[] = {
 	{V4L2_MBUS_FMT_YUYV8_2X8_BE, V4L2_COLORSPACE_JPEG},
 	{V4L2_MBUS_FMT_YVYU8_2X8_BE, V4L2_COLORSPACE_JPEG},
 	{V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE, V4L2_COLORSPACE_SRGB},
 	{V4L2_MBUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_BGR565_2X8_LE, V4L2_COLORSPACE_SRGB},
+	{V4L2_MBUS_FMT_BGR565_2X8_BE, V4L2_COLORSPACE_SRGB},
 	{V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_COLORSPACE_SRGB},
 	{V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
 };
@@ -184,10 +190,6 @@ struct mt9m111 {
 	unsigned int powered:1;
 	unsigned int hflip:1;
 	unsigned int vflip:1;
-	unsigned int swap_rgb_even_odd:1;
-	unsigned int swap_rgb_red_blue:1;
-	unsigned int swap_yuv_y_chromas:1;
-	unsigned int swap_yuv_cb_cr:1;
 	unsigned int autowhitebalance:1;
 };
 
@@ -329,68 +331,6 @@ static int mt9m111_setup_rect(struct i2c_client *client,
 	return ret;
 }
 
-static int mt9m111_setup_pixfmt(struct i2c_client *client, u16 outfmt)
-{
-	int ret;
-
-	ret = reg_write(OUTPUT_FORMAT_CTRL2_A, outfmt);
-	if (!ret)
-		ret = reg_write(OUTPUT_FORMAT_CTRL2_B, outfmt);
-	return ret;
-}
-
-static int mt9m111_setfmt_bayer8(struct i2c_client *client)
-{
-	return mt9m111_setup_pixfmt(client, MT9M111_OUTFMT_PROCESSED_BAYER |
-				    MT9M111_OUTFMT_RGB);
-}
-
-static int mt9m111_setfmt_bayer10(struct i2c_client *client)
-{
-	return mt9m111_setup_pixfmt(client, MT9M111_OUTFMT_BYPASS_IFP);
-}
-
-static int mt9m111_setfmt_rgb565(struct i2c_client *client)
-{
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	int val = 0;
-
-	if (mt9m111->swap_rgb_red_blue)
-		val |= MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr;
-	if (mt9m111->swap_rgb_even_odd)
-		val |= MT9M111_OUTFMT_SWAP_RGB_EVEN;
-	val |= MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB565;
-
-	return mt9m111_setup_pixfmt(client, val);
-}
-
-static int mt9m111_setfmt_rgb555(struct i2c_client *client)
-{
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	int val = 0;
-
-	if (mt9m111->swap_rgb_red_blue)
-		val |= MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr;
-	if (mt9m111->swap_rgb_even_odd)
-		val |= MT9M111_OUTFMT_SWAP_RGB_EVEN;
-	val |= MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB555;
-
-	return mt9m111_setup_pixfmt(client, val);
-}
-
-static int mt9m111_setfmt_yuv(struct i2c_client *client)
-{
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
-	int val = 0;
-
-	if (mt9m111->swap_yuv_cb_cr)
-		val |= MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr;
-	if (mt9m111->swap_yuv_y_chromas)
-		val |= MT9M111_OUTFMT_SWAP_YCbCr_C_Y;
-
-	return mt9m111_setup_pixfmt(client, val);
-}
-
 static int mt9m111_enable(struct i2c_client *client)
 {
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
@@ -518,41 +458,54 @@ static int mt9m111_g_fmt(struct v4l2_subdev *sd,
 static int mt9m111_set_pixfmt(struct i2c_client *client,
 			      enum v4l2_mbus_pixelcode code)
 {
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
+	u16 data_outfmt1 = 0, data_outfmt2 = 0, mask_outfmt1, mask_outfmt2;
 	int ret;
 
 	switch (code) {
 	case V4L2_MBUS_FMT_SBGGR8_1X8:
-		ret = mt9m111_setfmt_bayer8(client);
+		data_outfmt1 = MT9M111_OUTFMT_FLIP_BAYER_ROW;
+		data_outfmt2 = MT9M111_OUTFMT_PROCESSED_BAYER |
+			MT9M111_OUTFMT_RGB;
 		break;
 	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
-		ret = mt9m111_setfmt_bayer10(client);
+		data_outfmt2 = MT9M111_OUTFMT_BYPASS_IFP | MT9M111_OUTFMT_RGB;
 		break;
 	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
-		ret = mt9m111_setfmt_rgb555(client);
+		data_outfmt2 = MT9M111_OUTFMT_SWAP_RGB_EVEN |
+			MT9M111_OUTFMT_RGB |
+			MT9M111_OUTFMT_RGB555;
+		break;
+	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE:
+		data_outfmt2 = MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB555;
 		break;
 	case V4L2_MBUS_FMT_RGB565_2X8_LE:
-		ret = mt9m111_setfmt_rgb565(client);
+		data_outfmt2 = MT9M111_OUTFMT_SWAP_RGB_EVEN |
+			MT9M111_OUTFMT_RGB |
+			MT9M111_OUTFMT_RGB565;
+		break;
+	case V4L2_MBUS_FMT_RGB565_2X8_BE:
+		data_outfmt2 = MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB565;
+		break;
+	case V4L2_MBUS_FMT_BGR565_2X8_LE:
+		data_outfmt2 = MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr |
+			MT9M111_OUTFMT_SWAP_RGB_EVEN |
+			MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB565;
+		break;
+	case V4L2_MBUS_FMT_BGR565_2X8_BE:
+		data_outfmt2 = MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr |
+			MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB565;
 		break;
 	case V4L2_MBUS_FMT_YUYV8_2X8_BE:
-		mt9m111->swap_yuv_y_chromas = 0;
-		mt9m111->swap_yuv_cb_cr = 0;
-		ret = mt9m111_setfmt_yuv(client);
 		break;
 	case V4L2_MBUS_FMT_YVYU8_2X8_BE:
-		mt9m111->swap_yuv_y_chromas = 0;
-		mt9m111->swap_yuv_cb_cr = 1;
-		ret = mt9m111_setfmt_yuv(client);
+		data_outfmt2 = MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr;
 		break;
 	case V4L2_MBUS_FMT_YUYV8_2X8_LE:
-		mt9m111->swap_yuv_y_chromas = 1;
-		mt9m111->swap_yuv_cb_cr = 0;
-		ret = mt9m111_setfmt_yuv(client);
+		data_outfmt2 = MT9M111_OUTFMT_SWAP_YCbCr_C_Y;
 		break;
 	case V4L2_MBUS_FMT_YVYU8_2X8_LE:
-		mt9m111->swap_yuv_y_chromas = 1;
-		mt9m111->swap_yuv_cb_cr = 1;
-		ret = mt9m111_setfmt_yuv(client);
+		data_outfmt2 = MT9M111_OUTFMT_SWAP_YCbCr_C_Y |
+			MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr;
 		break;
 	default:
 		dev_err(&client->dev, "Pixel format not handled : %x\n",
@@ -560,6 +513,25 @@ static int mt9m111_set_pixfmt(struct i2c_client *client,
 		ret = -EINVAL;
 	}
 
+	mask_outfmt1 = MT9M111_OUTFMT_FLIP_BAYER_COL |
+		MT9M111_OUTFMT_FLIP_BAYER_ROW;
+
+	mask_outfmt2 = MT9M111_OUTFMT_PROCESSED_BAYER |
+		MT9M111_OUTFMT_BYPASS_IFP | MT9M111_OUTFMT_RGB |
+		MT9M111_OUTFMT_RGB565 | MT9M111_OUTFMT_RGB555 |
+		MT9M111_OUTFMT_RGB444x | MT9M111_OUTFMT_RGBx444 |
+		MT9M111_OUTFMT_SWAP_YCbCr_C_Y | MT9M111_OUTFMT_SWAP_RGB_EVEN |
+		MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr | MT9M111_OUTFMT_SWAP_RGB_R_B;
+
+	ret = reg_mask(OUTPUT_FORMAT_CTRL, data_outfmt1, mask_outfmt1);
+
+	if (!ret)
+		ret = reg_mask(OUTPUT_FORMAT_CTRL2_A, data_outfmt2,
+			mask_outfmt2);
+	if (!ret)
+		ret = reg_mask(OUTPUT_FORMAT_CTRL2_B, data_outfmt2,
+			mask_outfmt2);
+
 	return ret;
 }
 
@@ -989,9 +961,6 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 	mt9m111->autoexposure = 1;
 	mt9m111->autowhitebalance = 1;
 
-	mt9m111->swap_rgb_even_odd = 1;
-	mt9m111->swap_rgb_red_blue = 1;
-
 	data = reg_read(CHIP_VERSION);
 
 	switch (data) {
-- 
1.7.1

