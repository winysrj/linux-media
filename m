Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57621 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933068Ab2JWPmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 11:42:54 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: timo.ahonen@nokia.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 3/6] smiapp: Input for PLL configuration is mostly static
Date: Tue, 23 Oct 2012 18:42:47 +0300
Message-Id: <1351006971-32308-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
References: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The input values for PLL configuration are mostly static. So set them when
the sensor is registered.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e08e588..868ad0b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -276,11 +276,6 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 	struct smiapp_pll *pll = &sensor->pll;
 	int rval;
 
-	memset(&sensor->pll, 0, sizeof(sensor->pll));
-
-	pll->lanes = sensor->platform_data->lanes;
-	pll->ext_clk_freq_hz = sensor->platform_data->ext_clk;
-
 	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0) {
 		/*
 		 * Fill in operational clock divisors limits from the
@@ -296,20 +291,13 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 		lim.max_op_sys_clk_freq_hz = lim.max_vt_sys_clk_freq_hz;
 		lim.min_op_pix_clk_freq_hz = lim.min_vt_pix_clk_freq_hz;
 		lim.max_op_pix_clk_freq_hz = lim.max_vt_pix_clk_freq_hz;
-		/* Profile 0 sensors have no separate OP clock branch. */
-		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
 	}
 
-	if (smiapp_needs_quirk(sensor,
-			       SMIAPP_QUIRK_FLAG_OP_PIX_CLOCK_PER_LANE))
-		pll->flags |= SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE;
-
 	pll->binning_horizontal = sensor->binning_horizontal;
 	pll->binning_vertical = sensor->binning_vertical;
 	pll->link_freq =
 		sensor->link_freq->qmenu_int[sensor->link_freq->val];
 	pll->scale_m = sensor->scale_m;
-	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
 	pll->bits_per_pixel = sensor->csi_format->compressed;
 
 	rval = smiapp_pll_calculate(&client->dev, &lim, pll);
@@ -2369,6 +2357,7 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct smiapp_pll *pll = &sensor->pll;
 	struct smiapp_subdev *last = NULL;
 	u32 tmp;
 	unsigned int i;
@@ -2635,6 +2624,17 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	if (rval < 0)
 		goto out_nvm_release;
 
+	/* prepare PLL configuration input values */
+	pll->lanes = sensor->platform_data->lanes;
+	pll->ext_clk_freq_hz = sensor->platform_data->ext_clk;
+	/* Profile 0 sensors have no separate OP clock branch. */
+	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
+		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
+	if (smiapp_needs_quirk(sensor,
+			       SMIAPP_QUIRK_FLAG_OP_PIX_CLOCK_PER_LANE))
+		pll->flags |= SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE;
+	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
+
 	rval = smiapp_update_mode(sensor);
 	if (rval) {
 		dev_err(&client->dev, "update mode failed\n");
-- 
1.7.2.5

