Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbaDNJBA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:01:00 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 1E16B203D6
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:55 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 12/21] smiapp: Limits can be 64 bits
Date: Mon, 14 Apr 2014 11:58:37 +0300
Message-Id: <1397465926-29724-13-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Limits may exceed the value range of 32 bit unsigned integers. Thus use 64
bits instead.

Use typed min/max/clamp macros. Debug printing changes as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c  | 30 ++++++++++++++++--------------
 drivers/media/i2c/smiapp/smiapp-quirk.c |  4 ++--
 drivers/media/i2c/smiapp/smiapp-quirk.h |  2 +-
 drivers/media/i2c/smiapp/smiapp.h       |  2 +-
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 3af8df8..6d940f0 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -502,7 +502,8 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 		V4L2_CID_ANALOGUE_GAIN,
 		sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MIN],
 		sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MAX],
-		max(sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_STEP], 1U),
+		max_t(uint32_t,
+		      sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_STEP], 1U),
 		sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MIN]);
 
 	/* Exposure limits will be updated soon, use just something here. */
@@ -679,7 +680,7 @@ static int smiapp_get_limits_binning(struct smiapp_sensor *sensor)
 
 	for (i = 0; i < ARRAY_SIZE(limits); i++) {
 		dev_dbg(&client->dev,
-			"replace limit 0x%8.8x \"%s\" = %d, 0x%x\n",
+			"replace limit 0x%8.8x \"%s\" = %llu, 0x%llx\n",
 			smiapp_reg_limits[limits[i]].addr,
 			smiapp_reg_limits[limits[i]].what,
 			sensor->limits[limits_replace[i]],
@@ -1689,13 +1690,13 @@ static int smiapp_set_format(struct v4l2_subdev *subdev,
 	fmt->format.height &= ~1;
 
 	fmt->format.width =
-		clamp(fmt->format.width,
-		      sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE],
-		      sensor->limits[SMIAPP_LIMIT_MAX_X_OUTPUT_SIZE]);
+		clamp_t(uint32_t, fmt->format.width,
+			sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE],
+			sensor->limits[SMIAPP_LIMIT_MAX_X_OUTPUT_SIZE]);
 	fmt->format.height =
-		clamp(fmt->format.height,
-		      sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE],
-		      sensor->limits[SMIAPP_LIMIT_MAX_Y_OUTPUT_SIZE]);
+		clamp_t(uint32_t, fmt->format.height,
+			sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE],
+			sensor->limits[SMIAPP_LIMIT_MAX_Y_OUTPUT_SIZE]);
 
 	smiapp_get_crop_compose(subdev, fh, crops, NULL, fmt->which);
 
@@ -1834,12 +1835,13 @@ static void smiapp_set_compose_scaler(struct v4l2_subdev *subdev,
 		* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN]
 		/ sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE];
 
-	a = clamp(a, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
-		  sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
-	b = clamp(b, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
-		  sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
-	max_m = clamp(max_m, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
-		      sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
+	a = clamp_t(uint32_t, a, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
+		    sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
+	b = clamp_t(uint32_t, b, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
+		    sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
+	max_m = clamp_t(uint32_t, max_m,
+			sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
+			sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
 
 	dev_dbg(&client->dev, "scaling: a %d b %d max_m %d\n", a, b, max_m);
 
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index e0bee87..108ea23 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -51,11 +51,11 @@ static int smiapp_write_8s(struct smiapp_sensor *sensor,
 }
 
 void smiapp_replace_limit(struct smiapp_sensor *sensor,
-			  u32 limit, u32 val)
+			  u32 limit, u64 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 
-	dev_dbg(&client->dev, "quirk: 0x%8.8x \"%s\" = %d, 0x%x\n",
+	dev_dbg(&client->dev, "quirk: 0x%8.8x \"%s\" = %llu, 0x%llx\n",
 		smiapp_reg_limits[limit].addr,
 		smiapp_reg_limits[limit].what, val, val);
 	sensor->limits[limit] = val;
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index dddb62b..b8b4087 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -53,7 +53,7 @@ struct smiapp_reg_8 {
 };
 
 void smiapp_replace_limit(struct smiapp_sensor *sensor,
-			  u32 limit, u32 val);
+			  u32 limit, u64 val);
 
 #define SMIAPP_MK_QUIRK_REG_8(_reg, _val) \
 	{				\
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index 7cc5aae..0a26487 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -199,7 +199,7 @@ struct smiapp_sensor {
 	struct smiapp_platform_data *platform_data;
 	struct regulator *vana;
 	struct clk *ext_clk;
-	u32 limits[SMIAPP_LIMIT_LAST];
+	u64 limits[SMIAPP_LIMIT_LAST];
 	u8 nbinning_subtypes;
 	struct smiapp_binning_subtype binning_subtypes[SMIAPP_BINNING_SUBTYPES];
 	u32 mbus_frame_fmts;
-- 
1.8.3.2

