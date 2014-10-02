Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50537 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751408AbaJBIqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:46:43 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 07/18] smiapp-pll: Calculate OP clocks only for sensors that have them
Date: Thu,  2 Oct 2014 11:45:57 +0300
Message-Id: <1412239568-8524-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Profile 0 sensors have no OP clock branck in the clock tree. The PLL
calculator still calculated them, they just weren't used for anything.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c |   82 +++++++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 30 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 40a18ba..cac1407 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -89,7 +89,9 @@ static void print_pll(struct device *dev, struct smiapp_pll *pll)
 
 static int check_all_bounds(struct device *dev,
 			    const struct smiapp_pll_limits *limits,
-			    struct smiapp_pll *pll)
+			    const struct smiapp_pll_branch_limits *op_limits,
+			    struct smiapp_pll *pll,
+			    struct smiapp_pll_branch *op_pll)
 {
 	int rval;
 
@@ -109,25 +111,25 @@ static int check_all_bounds(struct device *dev,
 			"pll_op_clk_freq_hz");
 	if (!rval)
 		rval = bounds_check(
-			dev, pll->op.sys_clk_div,
-			limits->op.min_sys_clk_div, limits->op.max_sys_clk_div,
+			dev, op_pll->sys_clk_div,
+			op_limits->min_sys_clk_div, op_limits->max_sys_clk_div,
 			"op_sys_clk_div");
 	if (!rval)
 		rval = bounds_check(
-			dev, pll->op.pix_clk_div,
-			limits->op.min_pix_clk_div, limits->op.max_pix_clk_div,
+			dev, op_pll->pix_clk_div,
+			op_limits->min_pix_clk_div, op_limits->max_pix_clk_div,
 			"op_pix_clk_div");
 	if (!rval)
 		rval = bounds_check(
-			dev, pll->op.sys_clk_freq_hz,
-			limits->op.min_sys_clk_freq_hz,
-			limits->op.max_sys_clk_freq_hz,
+			dev, op_pll->sys_clk_freq_hz,
+			op_limits->min_sys_clk_freq_hz,
+			op_limits->max_sys_clk_freq_hz,
 			"op_sys_clk_freq_hz");
 	if (!rval)
 		rval = bounds_check(
-			dev, pll->op.pix_clk_freq_hz,
-			limits->op.min_pix_clk_freq_hz,
-			limits->op.max_pix_clk_freq_hz,
+			dev, op_pll->pix_clk_freq_hz,
+			op_limits->min_pix_clk_freq_hz,
+			op_limits->max_pix_clk_freq_hz,
 			"op_pix_clk_freq_hz");
 	if (!rval)
 		rval = bounds_check(
@@ -156,10 +158,11 @@ static int check_all_bounds(struct device *dev,
  *
  * @return Zero on success, error code on error.
  */
-static int __smiapp_pll_calculate(struct device *dev,
-				  const struct smiapp_pll_limits *limits,
-				  struct smiapp_pll *pll, uint32_t mul,
-				  uint32_t div, uint32_t lane_op_clock_ratio)
+static int __smiapp_pll_calculate(
+	struct device *dev, const struct smiapp_pll_limits *limits,
+	const struct smiapp_pll_branch_limits *op_limits,
+	struct smiapp_pll *pll, struct smiapp_pll_branch *op_pll, uint32_t mul,
+	uint32_t div, uint32_t lane_op_clock_ratio)
 {
 	uint32_t sys_div;
 	uint32_t best_pix_div = INT_MAX >> 1;
@@ -196,7 +199,7 @@ static int __smiapp_pll_calculate(struct device *dev,
 		more_mul_max);
 	/* Don't go above the division capability of op sys clock divider. */
 	more_mul_max = min(more_mul_max,
-			   limits->op.max_sys_clk_div * pll->pre_pll_clk_div
+			   op_limits->max_sys_clk_div * pll->pre_pll_clk_div
 			   / div);
 	dev_dbg(dev, "more_mul_max: max_op_sys_clk_div check: %u\n",
 		more_mul_max);
@@ -226,8 +229,8 @@ static int __smiapp_pll_calculate(struct device *dev,
 
 	more_mul_factor = lcm(div, pll->pre_pll_clk_div) / div;
 	dev_dbg(dev, "more_mul_factor: %u\n", more_mul_factor);
-	more_mul_factor = lcm(more_mul_factor, limits->op.min_sys_clk_div);
-	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %u\n",
+	more_mul_factor = lcm(more_mul_factor, op_limits->min_sys_clk_div);
+	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %d\n",
 		more_mul_factor);
 	i = roundup(more_mul_min, more_mul_factor);
 	if (!is_one_or_even(i))
@@ -240,8 +243,8 @@ static int __smiapp_pll_calculate(struct device *dev,
 	}
 
 	pll->pll_multiplier = mul * i;
-	pll->op.sys_clk_div = div * i / pll->pre_pll_clk_div;
-	dev_dbg(dev, "op_sys_clk_div: %u\n", pll->op.sys_clk_div);
+	op_pll->sys_clk_div = div * i / pll->pre_pll_clk_div;
+	dev_dbg(dev, "op_sys_clk_div: %u\n", op_pll->sys_clk_div);
 
 	pll->pll_ip_clk_freq_hz = pll->ext_clk_freq_hz
 		/ pll->pre_pll_clk_div;
@@ -250,14 +253,19 @@ static int __smiapp_pll_calculate(struct device *dev,
 		* pll->pll_multiplier;
 
 	/* Derive pll_op_clk_freq_hz. */
-	pll->op.sys_clk_freq_hz =
-		pll->pll_op_clk_freq_hz / pll->op.sys_clk_div;
+	op_pll->sys_clk_freq_hz =
+		pll->pll_op_clk_freq_hz / op_pll->sys_clk_div;
 
-	pll->op.pix_clk_div = pll->bits_per_pixel;
-	dev_dbg(dev, "op_pix_clk_div: %u\n", pll->op.pix_clk_div);
+	op_pll->pix_clk_div = pll->bits_per_pixel;
+	dev_dbg(dev, "op_pix_clk_div: %u\n", op_pll->pix_clk_div);
 
-	pll->op.pix_clk_freq_hz =
-		pll->op.sys_clk_freq_hz / pll->op.pix_clk_div;
+	op_pll->pix_clk_freq_hz =
+		op_pll->sys_clk_freq_hz / op_pll->pix_clk_div;
+
+	if (pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS) {
+		/* No OP clocks --- VT clocks are used instead. */
+		goto out_skip_vt_calc;
+	}
 
 	/*
 	 * Some sensors perform analogue binning and some do this
@@ -285,7 +293,7 @@ static int __smiapp_pll_calculate(struct device *dev,
 	 * Find absolute limits for the factor of vt divider.
 	 */
 	dev_dbg(dev, "scale_m: %u\n", pll->scale_m);
-	min_vt_div = DIV_ROUND_UP(pll->op.pix_clk_div * pll->op.sys_clk_div
+	min_vt_div = DIV_ROUND_UP(op_pll->pix_clk_div * op_pll->sys_clk_div
 				  * pll->scale_n,
 				  lane_op_clock_ratio * vt_op_binning_div
 				  * pll->scale_m);
@@ -377,16 +385,19 @@ static int __smiapp_pll_calculate(struct device *dev,
 	pll->vt.pix_clk_freq_hz =
 		pll->vt.sys_clk_freq_hz / pll->vt.pix_clk_div;
 
+out_skip_vt_calc:
 	pll->pixel_rate_csi =
-		pll->op.pix_clk_freq_hz * lane_op_clock_ratio;
+		op_pll->pix_clk_freq_hz * lane_op_clock_ratio;
 
-	return check_all_bounds(dev, limits, pll);
+	return check_all_bounds(dev, limits, op_limits, pll, op_pll);
 }
 
 int smiapp_pll_calculate(struct device *dev,
 			 const struct smiapp_pll_limits *limits,
 			 struct smiapp_pll *pll)
 {
+	const struct smiapp_pll_branch_limits *op_limits = &limits->op;
+	struct smiapp_pll_branch *op_pll = &pll->op;
 	uint16_t min_pre_pll_clk_div;
 	uint16_t max_pre_pll_clk_div;
 	uint32_t lane_op_clock_ratio;
@@ -394,6 +405,16 @@ int smiapp_pll_calculate(struct device *dev,
 	unsigned int i;
 	int rval = -EINVAL;
 
+	if (pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS) {
+		/*
+		 * If there's no OP PLL at all, use the VT values
+		 * instead. The OP values are ignored for the rest of
+		 * the PLL calculation.
+		 */
+		op_limits = &limits->vt;
+		op_pll = &pll->vt;
+	}
+
 	if (pll->flags & SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE)
 		lane_op_clock_ratio = pll->csi2.lanes;
 	else
@@ -449,7 +470,8 @@ int smiapp_pll_calculate(struct device *dev,
 	for (pll->pre_pll_clk_div = min_pre_pll_clk_div;
 	     pll->pre_pll_clk_div <= max_pre_pll_clk_div;
 	     pll->pre_pll_clk_div += 2 - (pll->pre_pll_clk_div & 1)) {
-		rval = __smiapp_pll_calculate(dev, limits, pll, mul, div,
+		rval = __smiapp_pll_calculate(dev, limits, op_limits, pll,
+					      op_pll, mul, div,
 					      lane_op_clock_ratio);
 		if (rval)
 			continue;
-- 
1.7.10.4

