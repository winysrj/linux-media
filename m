Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32961 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaFCJgM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 05:36:12 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 4/5] [media] mt9v032: add support for mt9v022 and mt9v024
Date: Tue,  3 Jun 2014 11:35:54 +0200
Message-Id: <1401788155-3690-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1401788155-3690-1-git-send-email-p.zabel@pengutronix.de>
References: <1401788155-3690-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From the looks of it, mt9v022 and mt9v032 are very similar,
as are mt9v024 and mt9v034. With minimal changes it is possible
to support mt9v02[24] with the same driver.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Removed code changes for fault pixel correction bit on mt9v02x
---
 drivers/media/i2c/mt9v032.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index d969663..cb7c6df 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -1,5 +1,5 @@
 /*
- * Driver for MT9V032 CMOS Image Sensor from Micron
+ * Driver for MT9V022, MT9V024, MT9V032, and MT9V034 CMOS Image Sensors
  *
  * Copyright (C) 2010, Laurent Pinchart <laurent.pinchart@ideasonboard.com>
  *
@@ -134,8 +134,12 @@
 #define MT9V032_THERMAL_INFO				0xc1
 
 enum mt9v032_model {
-	MT9V032_MODEL_V032_COLOR,
-	MT9V032_MODEL_V032_MONO,
+	MT9V032_MODEL_V022_COLOR,	/* MT9V022IX7ATC */
+	MT9V032_MODEL_V022_MONO,	/* MT9V022IX7ATM */
+	MT9V032_MODEL_V024_COLOR,	/* MT9V024IA7XTC */
+	MT9V032_MODEL_V024_MONO,	/* MT9V024IA7XTM */
+	MT9V032_MODEL_V032_COLOR,	/* MT9V032C12STM */
+	MT9V032_MODEL_V032_MONO,	/* MT9V032C12STC */
 	MT9V032_MODEL_V034_COLOR,
 	MT9V032_MODEL_V034_MONO,
 };
@@ -161,14 +165,14 @@ struct mt9v032_model_info {
 };
 
 static const struct mt9v032_model_version mt9v032_versions[] = {
-	{ MT9V032_CHIP_ID_REV1, "MT9V032 rev1/2" },
-	{ MT9V032_CHIP_ID_REV3, "MT9V032 rev3" },
-	{ MT9V034_CHIP_ID_REV1, "MT9V034 rev1" },
+	{ MT9V032_CHIP_ID_REV1, "MT9V022/MT9V032 rev1/2" },
+	{ MT9V032_CHIP_ID_REV3, "MT9V022/MT9V032 rev3" },
+	{ MT9V034_CHIP_ID_REV1, "MT9V024/MT9V034 rev1" },
 };
 
 static const struct mt9v032_model_data mt9v032_model_data[] = {
 	{
-		/* MT9V032 revisions 1/2/3 */
+		/* MT9V022, MT9V032 revisions 1/2/3 */
 		.min_row_time = 660,
 		.min_hblank = MT9V032_HORIZONTAL_BLANKING_MIN,
 		.min_vblank = MT9V032_VERTICAL_BLANKING_MIN,
@@ -177,7 +181,7 @@ static const struct mt9v032_model_data mt9v032_model_data[] = {
 		.max_shutter = MT9V032_TOTAL_SHUTTER_WIDTH_MAX,
 		.pclk_reg = MT9V032_PIXEL_CLOCK,
 	}, {
-		/* MT9V034 */
+		/* MT9V024, MT9V034 */
 		.min_row_time = 690,
 		.min_hblank = MT9V034_HORIZONTAL_BLANKING_MIN,
 		.min_vblank = MT9V034_VERTICAL_BLANKING_MIN,
@@ -189,6 +193,22 @@ static const struct mt9v032_model_data mt9v032_model_data[] = {
 };
 
 static const struct mt9v032_model_info mt9v032_models[] = {
+	[MT9V032_MODEL_V022_COLOR] = {
+		.data = &mt9v032_model_data[0],
+		.color = true,
+	},
+	[MT9V032_MODEL_V022_MONO] = {
+		.data = &mt9v032_model_data[0],
+		.color = false,
+	},
+	[MT9V032_MODEL_V024_COLOR] = {
+		.data = &mt9v032_model_data[1],
+		.color = true,
+	},
+	[MT9V032_MODEL_V024_MONO] = {
+		.data = &mt9v032_model_data[1],
+		.color = false,
+	},
 	[MT9V032_MODEL_V032_COLOR] = {
 		.data = &mt9v032_model_data[0],
 		.color = true,
@@ -1022,6 +1042,10 @@ static int mt9v032_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id mt9v032_id[] = {
+	{ "mt9v022", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V022_COLOR] },
+	{ "mt9v022m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V022_MONO] },
+	{ "mt9v024", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V024_COLOR] },
+	{ "mt9v024m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V024_MONO] },
 	{ "mt9v032", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V032_COLOR] },
 	{ "mt9v032m", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V032_MONO] },
 	{ "mt9v034", (kernel_ulong_t)&mt9v032_models[MT9V032_MODEL_V034_COLOR] },
-- 
2.0.0.rc2

