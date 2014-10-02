Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50525 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751334AbaJBIql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:46:41 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 06/18] smiapp-pll: Unify OP and VT PLL structs
Date: Thu,  2 Oct 2014 11:45:56 +0300
Message-Id: <1412239568-8524-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Uniform representation for VT and OP clocks. This is preparation for
calculating the VT clocks using the OP clock code.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c         |   60 ++++++++++++++++----------------
 drivers/media/i2c/smiapp-pll.h         |   18 +++++-----
 drivers/media/i2c/smiapp/smiapp-core.c |   14 ++++----
 3 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index bde8eb8..40a18ba 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -68,23 +68,23 @@ static void print_pll(struct device *dev, struct smiapp_pll *pll)
 	dev_dbg(dev, "pre_pll_clk_div\t%u\n",  pll->pre_pll_clk_div);
 	dev_dbg(dev, "pll_multiplier \t%u\n",  pll->pll_multiplier);
 	if (!(pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS)) {
-		dev_dbg(dev, "op_sys_clk_div \t%u\n", pll->op_sys_clk_div);
-		dev_dbg(dev, "op_pix_clk_div \t%u\n", pll->op_pix_clk_div);
+		dev_dbg(dev, "op_sys_clk_div \t%u\n", pll->op.sys_clk_div);
+		dev_dbg(dev, "op_pix_clk_div \t%u\n", pll->op.pix_clk_div);
 	}
-	dev_dbg(dev, "vt_sys_clk_div \t%u\n",  pll->vt_sys_clk_div);
-	dev_dbg(dev, "vt_pix_clk_div \t%u\n",  pll->vt_pix_clk_div);
+	dev_dbg(dev, "vt_sys_clk_div \t%u\n",  pll->vt.sys_clk_div);
+	dev_dbg(dev, "vt_pix_clk_div \t%u\n",  pll->vt.pix_clk_div);
 
 	dev_dbg(dev, "ext_clk_freq_hz \t%u\n", pll->ext_clk_freq_hz);
 	dev_dbg(dev, "pll_ip_clk_freq_hz \t%u\n", pll->pll_ip_clk_freq_hz);
 	dev_dbg(dev, "pll_op_clk_freq_hz \t%u\n", pll->pll_op_clk_freq_hz);
 	if (!(pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS)) {
 		dev_dbg(dev, "op_sys_clk_freq_hz \t%u\n",
-			pll->op_sys_clk_freq_hz);
+			pll->op.sys_clk_freq_hz);
 		dev_dbg(dev, "op_pix_clk_freq_hz \t%u\n",
-			pll->op_pix_clk_freq_hz);
+			pll->op.pix_clk_freq_hz);
 	}
-	dev_dbg(dev, "vt_sys_clk_freq_hz \t%u\n", pll->vt_sys_clk_freq_hz);
-	dev_dbg(dev, "vt_pix_clk_freq_hz \t%u\n", pll->vt_pix_clk_freq_hz);
+	dev_dbg(dev, "vt_sys_clk_freq_hz \t%u\n", pll->vt.sys_clk_freq_hz);
+	dev_dbg(dev, "vt_pix_clk_freq_hz \t%u\n", pll->vt.pix_clk_freq_hz);
 }
 
 static int check_all_bounds(struct device *dev,
@@ -109,35 +109,35 @@ static int check_all_bounds(struct device *dev,
 			"pll_op_clk_freq_hz");
 	if (!rval)
 		rval = bounds_check(
-			dev, pll->op_sys_clk_div,
+			dev, pll->op.sys_clk_div,
 			limits->op.min_sys_clk_div, limits->op.max_sys_clk_div,
 			"op_sys_clk_div");
 	if (!rval)
 		rval = bounds_check(
-			dev, pll->op_pix_clk_div,
+			dev, pll->op.pix_clk_div,
 			limits->op.min_pix_clk_div, limits->op.max_pix_clk_div,
 			"op_pix_clk_div");
 	if (!rval)
 		rval = bounds_check(
-			dev, pll->op_sys_clk_freq_hz,
+			dev, pll->op.sys_clk_freq_hz,
 			limits->op.min_sys_clk_freq_hz,
 			limits->op.max_sys_clk_freq_hz,
 			"op_sys_clk_freq_hz");
 	if (!rval)
 		rval = bounds_check(
-			dev, pll->op_pix_clk_freq_hz,
+			dev, pll->op.pix_clk_freq_hz,
 			limits->op.min_pix_clk_freq_hz,
 			limits->op.max_pix_clk_freq_hz,
 			"op_pix_clk_freq_hz");
 	if (!rval)
 		rval = bounds_check(
-			dev, pll->vt_sys_clk_freq_hz,
+			dev, pll->vt.sys_clk_freq_hz,
 			limits->vt.min_sys_clk_freq_hz,
 			limits->vt.max_sys_clk_freq_hz,
 			"vt_sys_clk_freq_hz");
 	if (!rval)
 		rval = bounds_check(
-			dev, pll->vt_pix_clk_freq_hz,
+			dev, pll->vt.pix_clk_freq_hz,
 			limits->vt.min_pix_clk_freq_hz,
 			limits->vt.max_pix_clk_freq_hz,
 			"vt_pix_clk_freq_hz");
@@ -240,8 +240,8 @@ static int __smiapp_pll_calculate(struct device *dev,
 	}
 
 	pll->pll_multiplier = mul * i;
-	pll->op_sys_clk_div = div * i / pll->pre_pll_clk_div;
-	dev_dbg(dev, "op_sys_clk_div: %u\n", pll->op_sys_clk_div);
+	pll->op.sys_clk_div = div * i / pll->pre_pll_clk_div;
+	dev_dbg(dev, "op_sys_clk_div: %u\n", pll->op.sys_clk_div);
 
 	pll->pll_ip_clk_freq_hz = pll->ext_clk_freq_hz
 		/ pll->pre_pll_clk_div;
@@ -250,14 +250,14 @@ static int __smiapp_pll_calculate(struct device *dev,
 		* pll->pll_multiplier;
 
 	/* Derive pll_op_clk_freq_hz. */
-	pll->op_sys_clk_freq_hz =
-		pll->pll_op_clk_freq_hz / pll->op_sys_clk_div;
+	pll->op.sys_clk_freq_hz =
+		pll->pll_op_clk_freq_hz / pll->op.sys_clk_div;
 
-	pll->op_pix_clk_div = pll->bits_per_pixel;
-	dev_dbg(dev, "op_pix_clk_div: %u\n", pll->op_pix_clk_div);
+	pll->op.pix_clk_div = pll->bits_per_pixel;
+	dev_dbg(dev, "op_pix_clk_div: %u\n", pll->op.pix_clk_div);
 
-	pll->op_pix_clk_freq_hz =
-		pll->op_sys_clk_freq_hz / pll->op_pix_clk_div;
+	pll->op.pix_clk_freq_hz =
+		pll->op.sys_clk_freq_hz / pll->op.pix_clk_div;
 
 	/*
 	 * Some sensors perform analogue binning and some do this
@@ -285,7 +285,7 @@ static int __smiapp_pll_calculate(struct device *dev,
 	 * Find absolute limits for the factor of vt divider.
 	 */
 	dev_dbg(dev, "scale_m: %u\n", pll->scale_m);
-	min_vt_div = DIV_ROUND_UP(pll->op_pix_clk_div * pll->op_sys_clk_div
+	min_vt_div = DIV_ROUND_UP(pll->op.pix_clk_div * pll->op.sys_clk_div
 				  * pll->scale_n,
 				  lane_op_clock_ratio * vt_op_binning_div
 				  * pll->scale_m);
@@ -369,16 +369,16 @@ static int __smiapp_pll_calculate(struct device *dev,
 			break;
 	}
 
-	pll->vt_sys_clk_div = DIV_ROUND_UP(min_vt_div, best_pix_div);
-	pll->vt_pix_clk_div = best_pix_div;
+	pll->vt.sys_clk_div = DIV_ROUND_UP(min_vt_div, best_pix_div);
+	pll->vt.pix_clk_div = best_pix_div;
 
-	pll->vt_sys_clk_freq_hz =
-		pll->pll_op_clk_freq_hz / pll->vt_sys_clk_div;
-	pll->vt_pix_clk_freq_hz =
-		pll->vt_sys_clk_freq_hz / pll->vt_pix_clk_div;
+	pll->vt.sys_clk_freq_hz =
+		pll->pll_op_clk_freq_hz / pll->vt.sys_clk_div;
+	pll->vt.pix_clk_freq_hz =
+		pll->vt.sys_clk_freq_hz / pll->vt.pix_clk_div;
 
 	pll->pixel_rate_csi =
-		pll->op_pix_clk_freq_hz * lane_op_clock_ratio;
+		pll->op.pix_clk_freq_hz * lane_op_clock_ratio;
 
 	return check_all_bounds(dev, limits, pll);
 }
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index 2885cd7..b7c0e66 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -35,6 +35,13 @@
 #define SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE			(1 << 0)
 #define SMIAPP_PLL_FLAG_NO_OP_CLOCKS				(1 << 1)
 
+struct smiapp_pll_branch {
+	uint16_t sys_clk_div;
+	uint16_t pix_clk_div;
+	uint32_t sys_clk_freq_hz;
+	uint32_t pix_clk_freq_hz;
+};
+
 struct smiapp_pll {
 	/* input values */
 	uint8_t bus_type;
@@ -58,17 +65,10 @@ struct smiapp_pll {
 	/* output values */
 	uint16_t pre_pll_clk_div;
 	uint16_t pll_multiplier;
-	uint16_t op_sys_clk_div;
-	uint16_t op_pix_clk_div;
-	uint16_t vt_sys_clk_div;
-	uint16_t vt_pix_clk_div;
-
 	uint32_t pll_ip_clk_freq_hz;
 	uint32_t pll_op_clk_freq_hz;
-	uint32_t op_sys_clk_freq_hz;
-	uint32_t op_pix_clk_freq_hz;
-	uint32_t vt_sys_clk_freq_hz;
-	uint32_t vt_pix_clk_freq_hz;
+	struct smiapp_pll_branch vt;
+	struct smiapp_pll_branch op;
 
 	uint32_t pixel_rate_csi;
 };
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 6174a59..389e775 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -205,12 +205,12 @@ static int smiapp_pll_configure(struct smiapp_sensor *sensor)
 	int rval;
 
 	rval = smiapp_write(
-		sensor, SMIAPP_REG_U16_VT_PIX_CLK_DIV, pll->vt_pix_clk_div);
+		sensor, SMIAPP_REG_U16_VT_PIX_CLK_DIV, pll->vt.pix_clk_div);
 	if (rval < 0)
 		return rval;
 
 	rval = smiapp_write(
-		sensor, SMIAPP_REG_U16_VT_SYS_CLK_DIV, pll->vt_sys_clk_div);
+		sensor, SMIAPP_REG_U16_VT_SYS_CLK_DIV, pll->vt.sys_clk_div);
 	if (rval < 0)
 		return rval;
 
@@ -227,17 +227,17 @@ static int smiapp_pll_configure(struct smiapp_sensor *sensor)
 	/* Lane op clock ratio does not apply here. */
 	rval = smiapp_write(
 		sensor, SMIAPP_REG_U32_REQUESTED_LINK_BIT_RATE_MBPS,
-		DIV_ROUND_UP(pll->op_sys_clk_freq_hz, 1000000 / 256 / 256));
+		DIV_ROUND_UP(pll->op.sys_clk_freq_hz, 1000000 / 256 / 256));
 	if (rval < 0 || sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
 		return rval;
 
 	rval = smiapp_write(
-		sensor, SMIAPP_REG_U16_OP_PIX_CLK_DIV, pll->op_pix_clk_div);
+		sensor, SMIAPP_REG_U16_OP_PIX_CLK_DIV, pll->op.pix_clk_div);
 	if (rval < 0)
 		return rval;
 
 	return smiapp_write(
-		sensor, SMIAPP_REG_U16_OP_SYS_CLK_DIV, pll->op_sys_clk_div);
+		sensor, SMIAPP_REG_U16_OP_SYS_CLK_DIV, pll->op.sys_clk_div);
 }
 
 static int smiapp_pll_update(struct smiapp_sensor *sensor)
@@ -299,7 +299,7 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 		return rval;
 
 	__v4l2_ctrl_s_ctrl_int64(sensor->pixel_rate_parray,
-				 pll->vt_pix_clk_freq_hz);
+				 pll->vt.pix_clk_freq_hz);
 	__v4l2_ctrl_s_ctrl_int64(sensor->pixel_rate_csi, pll->pixel_rate_csi);
 
 	return 0;
@@ -904,7 +904,7 @@ static int smiapp_update_mode(struct smiapp_sensor *sensor)
 	dev_dbg(&client->dev, "hblank\t\t%d\n", sensor->hblank->val);
 
 	dev_dbg(&client->dev, "real timeperframe\t100/%d\n",
-		sensor->pll.vt_pix_clk_freq_hz /
+		sensor->pll.vt.pix_clk_freq_hz /
 		((sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width
 		  + sensor->hblank->val) *
 		 (sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height
-- 
1.7.10.4

