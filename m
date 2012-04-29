Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40713 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2D2RNt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 13:13:49 -0400
Received: from localhost.localdomain (unknown [91.178.160.63])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2AA5035F87
	for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 19:13:48 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] mt9p031: Identify color/mono models using I2C device name
Date: Sun, 29 Apr 2012 19:14:06 +0200
Message-Id: <1335719648-18239-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335719648-18239-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1335719648-18239-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of passing a color/monochrome flag through platform data, rely
on the I2C device name to identify the chip model.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9p031.c |   14 +++++++++++---
 include/media/mt9p031.h       |    6 ------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index c81eaf4..5b8a396 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -99,6 +99,11 @@
 #define MT9P031_TEST_PATTERN_RED			0xa2
 #define MT9P031_TEST_PATTERN_BLUE			0xa3
 
+enum mt9p031_model {
+	MT9P031_MODEL_COLOR,
+	MT9P031_MODEL_MONOCHROME,
+};
+
 struct mt9p031 {
 	struct v4l2_subdev subdev;
 	struct media_pad pad;
@@ -109,6 +114,7 @@ struct mt9p031 {
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
 
+	enum mt9p031_model model;
 	struct aptina_pll pll;
 
 	/* Registers cache */
@@ -764,7 +770,7 @@ static int mt9p031_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 
 	format = v4l2_subdev_get_try_format(fh, 0);
 
-	if (mt9p031->pdata->version == MT9P031_MONOCHROME_VERSION)
+	if (mt9p031->model == MT9P031_MODEL_MONOCHROME)
 		format->code = V4L2_MBUS_FMT_Y12_1X12;
 	else
 		format->code = V4L2_MBUS_FMT_SGRBG12_1X12;
@@ -842,6 +848,7 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->pdata = pdata;
 	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
 	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
+	mt9p031->model = did->driver_data;
 
 	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 4);
 
@@ -882,7 +889,7 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->crop.left = MT9P031_COLUMN_START_DEF;
 	mt9p031->crop.top = MT9P031_ROW_START_DEF;
 
-	if (mt9p031->pdata->version == MT9P031_MONOCHROME_VERSION)
+	if (mt9p031->model == MT9P031_MODEL_MONOCHROME)
 		mt9p031->format.code = V4L2_MBUS_FMT_Y12_1X12;
 	else
 		mt9p031->format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
@@ -918,7 +925,8 @@ static int mt9p031_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id mt9p031_id[] = {
-	{ "mt9p031", 0 },
+	{ "mt9p031", MT9P031_MODEL_COLOR },
+	{ "mt9p031m", MT9P031_MODEL_MONOCHROME },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, mt9p031_id);
diff --git a/include/media/mt9p031.h b/include/media/mt9p031.h
index 96448c7..5b5090f 100644
--- a/include/media/mt9p031.h
+++ b/include/media/mt9p031.h
@@ -3,17 +3,11 @@
 
 struct v4l2_subdev;
 
-enum {
-	MT9P031_COLOR_VERSION,
-	MT9P031_MONOCHROME_VERSION,
-};
-
 struct mt9p031_platform_data {
 	int (*set_xclk)(struct v4l2_subdev *subdev, int hz);
 	int (*reset)(struct v4l2_subdev *subdev, int active);
 	int ext_freq; /* input frequency to the mt9p031 for PLL dividers */
 	int target_freq; /* frequency target for the PLL */
-	int version; /* MT9P031_COLOR_VERSION or MT9P031_MONOCHROME_VERSION */
 };
 
 #endif
-- 
1.7.3.4

