Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50542 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751355AbaJBIqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:46:44 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 14/18] smiapp: Gather information on valid link rate and BPP combinations
Date: Thu,  2 Oct 2014 11:46:04 +0300
Message-Id: <1412239568-8524-15-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not all link rates are possible with all BPP values.

Also rearrange other initialisation a little. Obtaining possible PLL
configurations earlier requires that.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   69 ++++++++++++++++++++++++--------
 drivers/media/i2c/smiapp/smiapp.h      |    8 ++++
 2 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 4d3dc25..d65521a 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -742,6 +742,7 @@ static int smiapp_get_limits_binning(struct smiapp_sensor *sensor)
 static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	struct smiapp_pll *pll = &sensor->pll;
 	unsigned int type, n;
 	unsigned int i, pixel_order;
 	int rval;
@@ -816,6 +817,41 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 		}
 	}
 
+	/* Figure out which BPP values can be used with which formats. */
+	pll->binning_horizontal = 1;
+	pll->binning_vertical = 1;
+	pll->scale_m = sensor->scale_m;
+
+	for (i = 0; i < ARRAY_SIZE(smiapp_csi_data_formats); i++) {
+		const struct smiapp_csi_data_format *f =
+			&smiapp_csi_data_formats[i];
+		unsigned long *valid_link_freqs =
+			&sensor->valid_link_freqs[
+				f->compressed - SMIAPP_COMPRESSED_BASE];
+		unsigned int j;
+
+		BUG_ON(f->compressed < SMIAPP_COMPRESSED_BASE);
+		BUG_ON(f->compressed > SMIAPP_COMPRESSED_MAX);
+
+		if (!(sensor->default_mbus_frame_fmts & 1 << i))
+			continue;
+
+		pll->bits_per_pixel = f->compressed;
+
+		for (j = 0; sensor->platform_data->op_sys_clock[j]; j++) {
+			pll->link_freq = sensor->platform_data->op_sys_clock[j];
+
+			rval = smiapp_pll_try(sensor, pll);
+			dev_dbg(&client->dev, "link freq %u Hz, bpp %u %s\n",
+				pll->link_freq, pll->bits_per_pixel,
+				rval ? "not ok" : "ok");
+			if (rval)
+				continue;
+
+			set_bit(j, valid_link_freqs);
+		}
+	}
+
 	if (!sensor->csi_format) {
 		dev_err(&client->dev, "no supported mbus code found\n");
 		return -EINVAL;
@@ -2479,12 +2515,6 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		goto out_power_off;
 	}
 
-	rval = smiapp_get_mbus_formats(sensor);
-	if (rval) {
-		rval = -ENODEV;
-		goto out_power_off;
-	}
-
 	if (sensor->limits[SMIAPP_LIMIT_BINNING_CAPABILITY]) {
 		u32 val;
 
@@ -2566,6 +2596,22 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 
 	sensor->scale_m = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
 
+	/* prepare PLL configuration input values */
+	pll->bus_type = SMIAPP_PLL_BUS_TYPE_CSI2;
+	pll->csi2.lanes = sensor->platform_data->lanes;
+	pll->ext_clk_freq_hz = sensor->platform_data->ext_clk;
+	pll->flags = smiapp_call_quirk(sensor, pll_flags);
+	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
+	/* Profile 0 sensors have no separate OP clock branch. */
+	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
+		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
+
+	rval = smiapp_get_mbus_formats(sensor);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_nvm_release;
+	}
+
 	for (i = 0; i < SMIAPP_SUBDEVS; i++) {
 		struct {
 			struct smiapp_subdev *ssd;
@@ -2663,17 +2709,6 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	if (rval < 0)
 		goto out_nvm_release;
 
-	/* prepare PLL configuration input values */
-	pll->bus_type = SMIAPP_PLL_BUS_TYPE_CSI2;
-	pll->csi2.lanes = sensor->platform_data->lanes;
-	pll->ext_clk_freq_hz = sensor->platform_data->ext_clk;
-	pll->flags = smiapp_call_quirk(sensor, pll_flags);
-
-	/* Profile 0 sensors have no separate OP clock branch. */
-	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
-		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
-	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
-
 	mutex_lock(&sensor->mutex);
 	rval = smiapp_update_mode(sensor);
 	mutex_unlock(&sensor->mutex);
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index 874b49f..f88f8ec 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -156,6 +156,11 @@ struct smiapp_csi_data_format {
 #define SMIAPP_PAD_SRC			1
 #define SMIAPP_PADS			2
 
+#define SMIAPP_COMPRESSED_BASE		8
+#define SMIAPP_COMPRESSED_MAX		12
+#define SMIAPP_NR_OF_COMPRESSED		(SMIAPP_COMPRESSED_MAX - \
+					 SMIAPP_COMPRESSED_BASE + 1)
+
 struct smiapp_binning_subtype {
 	u8 horizontal:4;
 	u8 vertical:4;
@@ -232,6 +237,9 @@ struct smiapp_sensor {
 
 	struct smiapp_pll pll;
 
+	/* Is a default format supported for a given BPP? */
+	unsigned long valid_link_freqs[SMIAPP_NR_OF_COMPRESSED];
+
 	/* Pixel array controls */
 	struct v4l2_ctrl *analog_gain;
 	struct v4l2_ctrl *exposure;
-- 
1.7.10.4

