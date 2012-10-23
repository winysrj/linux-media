Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57625 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933152Ab2JWPmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 11:42:55 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: timo.ahonen@nokia.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 5/6] smiapp-pll: Create a structure for OP and VT limits
Date: Tue, 23 Oct 2012 18:42:49 +0300
Message-Id: <1351006971-32308-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
References: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

OP and VT limits have identical fields, create a shared structure for
both.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/smiapp-pll.c         |   54 ++++++++++++++++----------------
 drivers/media/i2c/smiapp-pll.h         |   30 ++++++++----------
 drivers/media/i2c/smiapp/smiapp-core.c |   43 ++++++++++---------------
 3 files changed, 58 insertions(+), 69 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index d324360..cbef446 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -122,7 +122,7 @@ static int __smiapp_pll_calculate(struct device *dev,
 		more_mul_max);
 	/* Don't go above the division capability of op sys clock divider. */
 	more_mul_max = min(more_mul_max,
-			   limits->max_op_sys_clk_div * pll->pre_pll_clk_div
+			   limits->op.max_sys_clk_div * pll->pre_pll_clk_div
 			   / div);
 	dev_dbg(dev, "more_mul_max: max_op_sys_clk_div check: %d\n",
 		more_mul_max);
@@ -152,7 +152,7 @@ static int __smiapp_pll_calculate(struct device *dev,
 
 	more_mul_factor = lcm(div, pll->pre_pll_clk_div) / div;
 	dev_dbg(dev, "more_mul_factor: %d\n", more_mul_factor);
-	more_mul_factor = lcm(more_mul_factor, limits->min_op_sys_clk_div);
+	more_mul_factor = lcm(more_mul_factor, limits->op.min_sys_clk_div);
 	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %d\n",
 		more_mul_factor);
 	i = roundup(more_mul_min, more_mul_factor);
@@ -220,19 +220,19 @@ static int __smiapp_pll_calculate(struct device *dev,
 	dev_dbg(dev, "min_vt_div: %d\n", min_vt_div);
 	min_vt_div = max(min_vt_div,
 			 DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
-				      limits->max_vt_pix_clk_freq_hz));
+				      limits->vt.max_pix_clk_freq_hz));
 	dev_dbg(dev, "min_vt_div: max_vt_pix_clk_freq_hz: %d\n",
 		min_vt_div);
 	min_vt_div = max_t(uint32_t, min_vt_div,
-			   limits->min_vt_pix_clk_div
-			   * limits->min_vt_sys_clk_div);
+			   limits->vt.min_pix_clk_div
+			   * limits->vt.min_sys_clk_div);
 	dev_dbg(dev, "min_vt_div: min_vt_clk_div: %d\n", min_vt_div);
 
-	max_vt_div = limits->max_vt_sys_clk_div * limits->max_vt_pix_clk_div;
+	max_vt_div = limits->vt.max_sys_clk_div * limits->vt.max_pix_clk_div;
 	dev_dbg(dev, "max_vt_div: %d\n", max_vt_div);
 	max_vt_div = min(max_vt_div,
 			 DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
-				      limits->min_vt_pix_clk_freq_hz));
+				      limits->vt.min_pix_clk_freq_hz));
 	dev_dbg(dev, "max_vt_div: min_vt_pix_clk_freq_hz: %d\n",
 		max_vt_div);
 
@@ -240,28 +240,28 @@ static int __smiapp_pll_calculate(struct device *dev,
 	 * Find limitsits for sys_clk_div. Not all values are possible
 	 * with all values of pix_clk_div.
 	 */
-	min_sys_div = limits->min_vt_sys_clk_div;
+	min_sys_div = limits->vt.min_sys_clk_div;
 	dev_dbg(dev, "min_sys_div: %d\n", min_sys_div);
 	min_sys_div = max(min_sys_div,
 			  DIV_ROUND_UP(min_vt_div,
-				       limits->max_vt_pix_clk_div));
+				       limits->vt.max_pix_clk_div));
 	dev_dbg(dev, "min_sys_div: max_vt_pix_clk_div: %d\n", min_sys_div);
 	min_sys_div = max(min_sys_div,
 			  pll->pll_op_clk_freq_hz
-			  / limits->max_vt_sys_clk_freq_hz);
+			  / limits->vt.max_sys_clk_freq_hz);
 	dev_dbg(dev, "min_sys_div: max_pll_op_clk_freq_hz: %d\n", min_sys_div);
 	min_sys_div = clk_div_even_up(min_sys_div);
 	dev_dbg(dev, "min_sys_div: one or even: %d\n", min_sys_div);
 
-	max_sys_div = limits->max_vt_sys_clk_div;
+	max_sys_div = limits->vt.max_sys_clk_div;
 	dev_dbg(dev, "max_sys_div: %d\n", max_sys_div);
 	max_sys_div = min(max_sys_div,
 			  DIV_ROUND_UP(max_vt_div,
-				       limits->min_vt_pix_clk_div));
+				       limits->vt.min_pix_clk_div));
 	dev_dbg(dev, "max_sys_div: min_vt_pix_clk_div: %d\n", max_sys_div);
 	max_sys_div = min(max_sys_div,
 			  DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
-				       limits->min_vt_pix_clk_freq_hz));
+				       limits->vt.min_pix_clk_freq_hz));
 	dev_dbg(dev, "max_sys_div: min_vt_pix_clk_freq_hz: %d\n", max_sys_div);
 
 	/*
@@ -276,13 +276,13 @@ static int __smiapp_pll_calculate(struct device *dev,
 		     sys_div += 2 - (sys_div & 1)) {
 			uint16_t pix_div = DIV_ROUND_UP(vt_div, sys_div);
 
-			if (pix_div < limits->min_vt_pix_clk_div
-			    || pix_div > limits->max_vt_pix_clk_div) {
+			if (pix_div < limits->vt.min_pix_clk_div
+			    || pix_div > limits->vt.max_pix_clk_div) {
 				dev_dbg(dev,
 					"pix_div %d too small or too big (%d--%d)\n",
 					pix_div,
-					limits->min_vt_pix_clk_div,
-					limits->max_vt_pix_clk_div);
+					limits->vt.min_pix_clk_div,
+					limits->vt.max_pix_clk_div);
 				continue;
 			}
 
@@ -327,36 +327,36 @@ static int __smiapp_pll_calculate(struct device *dev,
 	if (!rval)
 		rval = bounds_check(
 			dev, pll->op_sys_clk_div,
-			limits->min_op_sys_clk_div, limits->max_op_sys_clk_div,
+			limits->op.min_sys_clk_div, limits->op.max_sys_clk_div,
 			"op_sys_clk_div");
 	if (!rval)
 		rval = bounds_check(
 			dev, pll->op_pix_clk_div,
-			limits->min_op_pix_clk_div, limits->max_op_pix_clk_div,
+			limits->op.min_pix_clk_div, limits->op.max_pix_clk_div,
 			"op_pix_clk_div");
 	if (!rval)
 		rval = bounds_check(
 			dev, pll->op_sys_clk_freq_hz,
-			limits->min_op_sys_clk_freq_hz,
-			limits->max_op_sys_clk_freq_hz,
+			limits->op.min_sys_clk_freq_hz,
+			limits->op.max_sys_clk_freq_hz,
 			"op_sys_clk_freq_hz");
 	if (!rval)
 		rval = bounds_check(
 			dev, pll->op_pix_clk_freq_hz,
-			limits->min_op_pix_clk_freq_hz,
-			limits->max_op_pix_clk_freq_hz,
+			limits->op.min_pix_clk_freq_hz,
+			limits->op.max_pix_clk_freq_hz,
 			"op_pix_clk_freq_hz");
 	if (!rval)
 		rval = bounds_check(
 			dev, pll->vt_sys_clk_freq_hz,
-			limits->min_vt_sys_clk_freq_hz,
-			limits->max_vt_sys_clk_freq_hz,
+			limits->vt.min_sys_clk_freq_hz,
+			limits->vt.max_sys_clk_freq_hz,
 			"vt_sys_clk_freq_hz");
 	if (!rval)
 		rval = bounds_check(
 			dev, pll->vt_pix_clk_freq_hz,
-			limits->min_vt_pix_clk_freq_hz,
-			limits->max_vt_pix_clk_freq_hz,
+			limits->vt.min_pix_clk_freq_hz,
+			limits->vt.max_pix_clk_freq_hz,
 			"vt_pix_clk_freq_hz");
 
 	return rval;
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index 439fe5d..8500e6e 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -73,6 +73,17 @@ struct smiapp_pll {
 	uint32_t pixel_rate_csi;
 };
 
+struct smiapp_pll_branch_limits {
+	uint16_t min_sys_clk_div;
+	uint16_t max_sys_clk_div;
+	uint32_t min_sys_clk_freq_hz;
+	uint32_t max_sys_clk_freq_hz;
+	uint16_t min_pix_clk_div;
+	uint16_t max_pix_clk_div;
+	uint32_t min_pix_clk_freq_hz;
+	uint32_t max_pix_clk_freq_hz;
+};
+
 struct smiapp_pll_limits {
 	/* Strict PLL limits */
 	uint32_t min_ext_clk_freq_hz;
@@ -86,23 +97,8 @@ struct smiapp_pll_limits {
 	uint32_t min_pll_op_freq_hz;
 	uint32_t max_pll_op_freq_hz;
 
-	uint16_t min_vt_sys_clk_div;
-	uint16_t max_vt_sys_clk_div;
-	uint32_t min_vt_sys_clk_freq_hz;
-	uint32_t max_vt_sys_clk_freq_hz;
-	uint16_t min_vt_pix_clk_div;
-	uint16_t max_vt_pix_clk_div;
-	uint32_t min_vt_pix_clk_freq_hz;
-	uint32_t max_vt_pix_clk_freq_hz;
-
-	uint16_t min_op_sys_clk_div;
-	uint16_t max_op_sys_clk_div;
-	uint32_t min_op_sys_clk_freq_hz;
-	uint32_t max_op_sys_clk_freq_hz;
-	uint16_t min_op_pix_clk_div;
-	uint16_t max_op_pix_clk_div;
-	uint32_t min_op_pix_clk_freq_hz;
-	uint32_t max_op_pix_clk_freq_hz;
+	struct smiapp_pll_branch_limits vt;
+	struct smiapp_pll_branch_limits op;
 
 	/* Other relevant limits */
 	uint32_t min_line_length_pck_bin;
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 42316cb..81ec4ac 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -252,23 +252,23 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 		.min_pll_op_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_PLL_OP_FREQ_HZ],
 		.max_pll_op_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_PLL_OP_FREQ_HZ],
 
-		.min_op_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_OP_SYS_CLK_DIV],
-		.max_op_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_OP_SYS_CLK_DIV],
-		.min_op_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_OP_PIX_CLK_DIV],
-		.max_op_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_OP_PIX_CLK_DIV],
-		.min_op_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_OP_SYS_CLK_FREQ_HZ],
-		.max_op_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_OP_SYS_CLK_FREQ_HZ],
-		.min_op_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_OP_PIX_CLK_FREQ_HZ],
-		.max_op_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_OP_PIX_CLK_FREQ_HZ],
-
-		.min_vt_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_VT_SYS_CLK_DIV],
-		.max_vt_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_VT_SYS_CLK_DIV],
-		.min_vt_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_VT_PIX_CLK_DIV],
-		.max_vt_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_VT_PIX_CLK_DIV],
-		.min_vt_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_VT_SYS_CLK_FREQ_HZ],
-		.max_vt_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_VT_SYS_CLK_FREQ_HZ],
-		.min_vt_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_VT_PIX_CLK_FREQ_HZ],
-		.max_vt_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_VT_PIX_CLK_FREQ_HZ],
+		.op.min_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_OP_SYS_CLK_DIV],
+		.op.max_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_OP_SYS_CLK_DIV],
+		.op.min_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_OP_PIX_CLK_DIV],
+		.op.max_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_OP_PIX_CLK_DIV],
+		.op.min_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_OP_SYS_CLK_FREQ_HZ],
+		.op.max_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_OP_SYS_CLK_FREQ_HZ],
+		.op.min_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_OP_PIX_CLK_FREQ_HZ],
+		.op.max_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_OP_PIX_CLK_FREQ_HZ],
+
+		.vt.min_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_VT_SYS_CLK_DIV],
+		.vt.max_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_VT_SYS_CLK_DIV],
+		.vt.min_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_VT_PIX_CLK_DIV],
+		.vt.max_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_VT_PIX_CLK_DIV],
+		.vt.min_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_VT_SYS_CLK_FREQ_HZ],
+		.vt.max_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_VT_SYS_CLK_FREQ_HZ],
+		.vt.min_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_VT_PIX_CLK_FREQ_HZ],
+		.vt.max_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_VT_PIX_CLK_FREQ_HZ],
 
 		.min_line_length_pck_bin = sensor->limits[SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_BIN],
 		.min_line_length_pck = sensor->limits[SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK],
@@ -283,14 +283,7 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 		 * requirements regarding them are essentially the
 		 * same as on VT ones.
 		 */
-		lim.min_op_sys_clk_div = lim.min_vt_sys_clk_div;
-		lim.max_op_sys_clk_div = lim.max_vt_sys_clk_div;
-		lim.min_op_pix_clk_div = lim.min_vt_pix_clk_div;
-		lim.max_op_pix_clk_div = lim.max_vt_pix_clk_div;
-		lim.min_op_sys_clk_freq_hz = lim.min_vt_sys_clk_freq_hz;
-		lim.max_op_sys_clk_freq_hz = lim.max_vt_sys_clk_freq_hz;
-		lim.min_op_pix_clk_freq_hz = lim.min_vt_pix_clk_freq_hz;
-		lim.max_op_pix_clk_freq_hz = lim.max_vt_pix_clk_freq_hz;
+		lim.op = lim.vt;
 	}
 
 	pll->binning_horizontal = sensor->binning_horizontal;
-- 
1.7.2.5

