Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55056 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756213AbaIQUpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:32 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id E068F600A0
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:29 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 02/17] smiapp-pll: The clock tree values are unsigned --- fix debug prints
Date: Wed, 17 Sep 2014 23:45:26 +0300
Message-Id: <1410986741-6801-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

These values are unsigned, so use %u instead of %d.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c |   94 ++++++++++++++++++++--------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index ab5d9a3..d14af5c 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -65,26 +65,26 @@ static int bounds_check(struct device *dev, uint32_t val,
 
 static void print_pll(struct device *dev, struct smiapp_pll *pll)
 {
-	dev_dbg(dev, "pre_pll_clk_div\t%d\n",  pll->pre_pll_clk_div);
-	dev_dbg(dev, "pll_multiplier \t%d\n",  pll->pll_multiplier);
+	dev_dbg(dev, "pre_pll_clk_div\t%u\n",  pll->pre_pll_clk_div);
+	dev_dbg(dev, "pll_multiplier \t%u\n",  pll->pll_multiplier);
 	if (!(pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS)) {
-		dev_dbg(dev, "op_sys_clk_div \t%d\n", pll->op_sys_clk_div);
-		dev_dbg(dev, "op_pix_clk_div \t%d\n", pll->op_pix_clk_div);
+		dev_dbg(dev, "op_sys_clk_div \t%u\n", pll->op_sys_clk_div);
+		dev_dbg(dev, "op_pix_clk_div \t%u\n", pll->op_pix_clk_div);
 	}
-	dev_dbg(dev, "vt_sys_clk_div \t%d\n",  pll->vt_sys_clk_div);
-	dev_dbg(dev, "vt_pix_clk_div \t%d\n",  pll->vt_pix_clk_div);
+	dev_dbg(dev, "vt_sys_clk_div \t%u\n",  pll->vt_sys_clk_div);
+	dev_dbg(dev, "vt_pix_clk_div \t%u\n",  pll->vt_pix_clk_div);
 
-	dev_dbg(dev, "ext_clk_freq_hz \t%d\n", pll->ext_clk_freq_hz);
-	dev_dbg(dev, "pll_ip_clk_freq_hz \t%d\n", pll->pll_ip_clk_freq_hz);
-	dev_dbg(dev, "pll_op_clk_freq_hz \t%d\n", pll->pll_op_clk_freq_hz);
+	dev_dbg(dev, "ext_clk_freq_hz \t%u\n", pll->ext_clk_freq_hz);
+	dev_dbg(dev, "pll_ip_clk_freq_hz \t%u\n", pll->pll_ip_clk_freq_hz);
+	dev_dbg(dev, "pll_op_clk_freq_hz \t%u\n", pll->pll_op_clk_freq_hz);
 	if (!(pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS)) {
-		dev_dbg(dev, "op_sys_clk_freq_hz \t%d\n",
+		dev_dbg(dev, "op_sys_clk_freq_hz \t%u\n",
 			pll->op_sys_clk_freq_hz);
-		dev_dbg(dev, "op_pix_clk_freq_hz \t%d\n",
+		dev_dbg(dev, "op_pix_clk_freq_hz \t%u\n",
 			pll->op_pix_clk_freq_hz);
 	}
-	dev_dbg(dev, "vt_sys_clk_freq_hz \t%d\n", pll->vt_sys_clk_freq_hz);
-	dev_dbg(dev, "vt_pix_clk_freq_hz \t%d\n", pll->vt_pix_clk_freq_hz);
+	dev_dbg(dev, "vt_sys_clk_freq_hz \t%u\n", pll->vt_sys_clk_freq_hz);
+	dev_dbg(dev, "vt_pix_clk_freq_hz \t%u\n", pll->vt_pix_clk_freq_hz);
 }
 
 /*
@@ -123,11 +123,11 @@ static int __smiapp_pll_calculate(struct device *dev,
 	 * Get pre_pll_clk_div so that our pll_op_clk_freq_hz won't be
 	 * too high.
 	 */
-	dev_dbg(dev, "pre_pll_clk_div %d\n", pll->pre_pll_clk_div);
+	dev_dbg(dev, "pre_pll_clk_div %u\n", pll->pre_pll_clk_div);
 
 	/* Don't go above max pll multiplier. */
 	more_mul_max = limits->max_pll_multiplier / mul;
-	dev_dbg(dev, "more_mul_max: max_pll_multiplier check: %d\n",
+	dev_dbg(dev, "more_mul_max: max_pll_multiplier check: %u\n",
 		more_mul_max);
 	/* Don't go above max pll op frequency. */
 	more_mul_max =
@@ -135,30 +135,30 @@ static int __smiapp_pll_calculate(struct device *dev,
 		      more_mul_max,
 		      limits->max_pll_op_freq_hz
 		      / (pll->ext_clk_freq_hz / pll->pre_pll_clk_div * mul));
-	dev_dbg(dev, "more_mul_max: max_pll_op_freq_hz check: %d\n",
+	dev_dbg(dev, "more_mul_max: max_pll_op_freq_hz check: %u\n",
 		more_mul_max);
 	/* Don't go above the division capability of op sys clock divider. */
 	more_mul_max = min(more_mul_max,
 			   limits->op.max_sys_clk_div * pll->pre_pll_clk_div
 			   / div);
-	dev_dbg(dev, "more_mul_max: max_op_sys_clk_div check: %d\n",
+	dev_dbg(dev, "more_mul_max: max_op_sys_clk_div check: %u\n",
 		more_mul_max);
 	/* Ensure we won't go above min_pll_multiplier. */
 	more_mul_max = min(more_mul_max,
 			   DIV_ROUND_UP(limits->max_pll_multiplier, mul));
-	dev_dbg(dev, "more_mul_max: min_pll_multiplier check: %d\n",
+	dev_dbg(dev, "more_mul_max: min_pll_multiplier check: %u\n",
 		more_mul_max);
 
 	/* Ensure we won't go below min_pll_op_freq_hz. */
 	more_mul_min = DIV_ROUND_UP(limits->min_pll_op_freq_hz,
 				    pll->ext_clk_freq_hz / pll->pre_pll_clk_div
 				    * mul);
-	dev_dbg(dev, "more_mul_min: min_pll_op_freq_hz check: %d\n",
+	dev_dbg(dev, "more_mul_min: min_pll_op_freq_hz check: %u\n",
 		more_mul_min);
 	/* Ensure we won't go below min_pll_multiplier. */
 	more_mul_min = max(more_mul_min,
 			   DIV_ROUND_UP(limits->min_pll_multiplier, mul));
-	dev_dbg(dev, "more_mul_min: min_pll_multiplier check: %d\n",
+	dev_dbg(dev, "more_mul_min: min_pll_multiplier check: %u\n",
 		more_mul_min);
 
 	if (more_mul_min > more_mul_max) {
@@ -168,23 +168,23 @@ static int __smiapp_pll_calculate(struct device *dev,
 	}
 
 	more_mul_factor = lcm(div, pll->pre_pll_clk_div) / div;
-	dev_dbg(dev, "more_mul_factor: %d\n", more_mul_factor);
+	dev_dbg(dev, "more_mul_factor: %u\n", more_mul_factor);
 	more_mul_factor = lcm(more_mul_factor, limits->op.min_sys_clk_div);
-	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %d\n",
+	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %u\n",
 		more_mul_factor);
 	i = roundup(more_mul_min, more_mul_factor);
 	if (!is_one_or_even(i))
 		i <<= 1;
 
-	dev_dbg(dev, "final more_mul: %d\n", i);
+	dev_dbg(dev, "final more_mul: %u\n", i);
 	if (i > more_mul_max) {
-		dev_dbg(dev, "final more_mul is bad, max %d\n", more_mul_max);
+		dev_dbg(dev, "final more_mul is bad, max %u\n", more_mul_max);
 		return -EINVAL;
 	}
 
 	pll->pll_multiplier = mul * i;
 	pll->op_sys_clk_div = div * i / pll->pre_pll_clk_div;
-	dev_dbg(dev, "op_sys_clk_div: %d\n", pll->op_sys_clk_div);
+	dev_dbg(dev, "op_sys_clk_div: %u\n", pll->op_sys_clk_div);
 
 	pll->pll_ip_clk_freq_hz = pll->ext_clk_freq_hz
 		/ pll->pre_pll_clk_div;
@@ -197,7 +197,7 @@ static int __smiapp_pll_calculate(struct device *dev,
 		pll->pll_op_clk_freq_hz / pll->op_sys_clk_div;
 
 	pll->op_pix_clk_div = pll->bits_per_pixel;
-	dev_dbg(dev, "op_pix_clk_div: %d\n", pll->op_pix_clk_div);
+	dev_dbg(dev, "op_pix_clk_div: %u\n", pll->op_pix_clk_div);
 
 	pll->op_pix_clk_freq_hz =
 		pll->op_sys_clk_freq_hz / pll->op_pix_clk_div;
@@ -214,7 +214,7 @@ static int __smiapp_pll_calculate(struct device *dev,
 		vt_op_binning_div = pll->binning_horizontal;
 	else
 		vt_op_binning_div = 1;
-	dev_dbg(dev, "vt_op_binning_div: %d\n", vt_op_binning_div);
+	dev_dbg(dev, "vt_op_binning_div: %u\n", vt_op_binning_div);
 
 	/*
 	 * Profile 2 supports vt_pix_clk_div E [4, 10]
@@ -227,30 +227,30 @@ static int __smiapp_pll_calculate(struct device *dev,
 	 *
 	 * Find absolute limits for the factor of vt divider.
 	 */
-	dev_dbg(dev, "scale_m: %d\n", pll->scale_m);
+	dev_dbg(dev, "scale_m: %u\n", pll->scale_m);
 	min_vt_div = DIV_ROUND_UP(pll->op_pix_clk_div * pll->op_sys_clk_div
 				  * pll->scale_n,
 				  lane_op_clock_ratio * vt_op_binning_div
 				  * pll->scale_m);
 
 	/* Find smallest and biggest allowed vt divisor. */
-	dev_dbg(dev, "min_vt_div: %d\n", min_vt_div);
+	dev_dbg(dev, "min_vt_div: %u\n", min_vt_div);
 	min_vt_div = max(min_vt_div,
 			 DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
 				      limits->vt.max_pix_clk_freq_hz));
-	dev_dbg(dev, "min_vt_div: max_vt_pix_clk_freq_hz: %d\n",
+	dev_dbg(dev, "min_vt_div: max_vt_pix_clk_freq_hz: %u\n",
 		min_vt_div);
 	min_vt_div = max_t(uint32_t, min_vt_div,
 			   limits->vt.min_pix_clk_div
 			   * limits->vt.min_sys_clk_div);
-	dev_dbg(dev, "min_vt_div: min_vt_clk_div: %d\n", min_vt_div);
+	dev_dbg(dev, "min_vt_div: min_vt_clk_div: %u\n", min_vt_div);
 
 	max_vt_div = limits->vt.max_sys_clk_div * limits->vt.max_pix_clk_div;
-	dev_dbg(dev, "max_vt_div: %d\n", max_vt_div);
+	dev_dbg(dev, "max_vt_div: %u\n", max_vt_div);
 	max_vt_div = min(max_vt_div,
 			 DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
 				      limits->vt.min_pix_clk_freq_hz));
-	dev_dbg(dev, "max_vt_div: min_vt_pix_clk_freq_hz: %d\n",
+	dev_dbg(dev, "max_vt_div: min_vt_pix_clk_freq_hz: %u\n",
 		max_vt_div);
 
 	/*
@@ -258,28 +258,28 @@ static int __smiapp_pll_calculate(struct device *dev,
 	 * with all values of pix_clk_div.
 	 */
 	min_sys_div = limits->vt.min_sys_clk_div;
-	dev_dbg(dev, "min_sys_div: %d\n", min_sys_div);
+	dev_dbg(dev, "min_sys_div: %u\n", min_sys_div);
 	min_sys_div = max(min_sys_div,
 			  DIV_ROUND_UP(min_vt_div,
 				       limits->vt.max_pix_clk_div));
-	dev_dbg(dev, "min_sys_div: max_vt_pix_clk_div: %d\n", min_sys_div);
+	dev_dbg(dev, "min_sys_div: max_vt_pix_clk_div: %u\n", min_sys_div);
 	min_sys_div = max(min_sys_div,
 			  pll->pll_op_clk_freq_hz
 			  / limits->vt.max_sys_clk_freq_hz);
-	dev_dbg(dev, "min_sys_div: max_pll_op_clk_freq_hz: %d\n", min_sys_div);
+	dev_dbg(dev, "min_sys_div: max_pll_op_clk_freq_hz: %u\n", min_sys_div);
 	min_sys_div = clk_div_even_up(min_sys_div);
-	dev_dbg(dev, "min_sys_div: one or even: %d\n", min_sys_div);
+	dev_dbg(dev, "min_sys_div: one or even: %u\n", min_sys_div);
 
 	max_sys_div = limits->vt.max_sys_clk_div;
-	dev_dbg(dev, "max_sys_div: %d\n", max_sys_div);
+	dev_dbg(dev, "max_sys_div: %u\n", max_sys_div);
 	max_sys_div = min(max_sys_div,
 			  DIV_ROUND_UP(max_vt_div,
 				       limits->vt.min_pix_clk_div));
-	dev_dbg(dev, "max_sys_div: min_vt_pix_clk_div: %d\n", max_sys_div);
+	dev_dbg(dev, "max_sys_div: min_vt_pix_clk_div: %u\n", max_sys_div);
 	max_sys_div = min(max_sys_div,
 			  DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
 				       limits->vt.min_pix_clk_freq_hz));
-	dev_dbg(dev, "max_sys_div: min_vt_pix_clk_freq_hz: %d\n", max_sys_div);
+	dev_dbg(dev, "max_sys_div: min_vt_pix_clk_freq_hz: %u\n", max_sys_div);
 
 	/*
 	 * Find pix_div such that a legal pix_div * sys_div results
@@ -296,7 +296,7 @@ static int __smiapp_pll_calculate(struct device *dev,
 			if (pix_div < limits->vt.min_pix_clk_div
 			    || pix_div > limits->vt.max_pix_clk_div) {
 				dev_dbg(dev,
-					"pix_div %d too small or too big (%d--%d)\n",
+					"pix_div %u too small or too big (%u--%u)\n",
 					pix_div,
 					limits->vt.min_pix_clk_div,
 					limits->vt.max_pix_clk_div);
@@ -390,9 +390,9 @@ int smiapp_pll_calculate(struct device *dev,
 		lane_op_clock_ratio = pll->csi2.lanes;
 	else
 		lane_op_clock_ratio = 1;
-	dev_dbg(dev, "lane_op_clock_ratio: %d\n", lane_op_clock_ratio);
+	dev_dbg(dev, "lane_op_clock_ratio: %u\n", lane_op_clock_ratio);
 
-	dev_dbg(dev, "binning: %dx%d\n", pll->binning_horizontal,
+	dev_dbg(dev, "binning: %ux%u\n", pll->binning_horizontal,
 		pll->binning_vertical);
 
 	switch (pll->bus_type) {
@@ -411,7 +411,7 @@ int smiapp_pll_calculate(struct device *dev,
 	}
 
 	/* Figure out limits for pre-pll divider based on extclk */
-	dev_dbg(dev, "min / max pre_pll_clk_div: %d / %d\n",
+	dev_dbg(dev, "min / max pre_pll_clk_div: %u / %u\n",
 		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
 	max_pre_pll_clk_div =
 		min_t(uint16_t, limits->max_pre_pll_clk_div,
@@ -422,20 +422,20 @@ int smiapp_pll_calculate(struct device *dev,
 		      clk_div_even_up(
 			      DIV_ROUND_UP(pll->ext_clk_freq_hz,
 					   limits->max_pll_ip_freq_hz)));
-	dev_dbg(dev, "pre-pll check: min / max pre_pll_clk_div: %d / %d\n",
+	dev_dbg(dev, "pre-pll check: min / max pre_pll_clk_div: %u / %u\n",
 		min_pre_pll_clk_div, max_pre_pll_clk_div);
 
 	i = gcd(pll->pll_op_clk_freq_hz, pll->ext_clk_freq_hz);
 	mul = div_u64(pll->pll_op_clk_freq_hz, i);
 	div = pll->ext_clk_freq_hz / i;
-	dev_dbg(dev, "mul %d / div %d\n", mul, div);
+	dev_dbg(dev, "mul %u / div %u\n", mul, div);
 
 	min_pre_pll_clk_div =
 		max_t(uint16_t, min_pre_pll_clk_div,
 		      clk_div_even_up(
 			      DIV_ROUND_UP(mul * pll->ext_clk_freq_hz,
 					   limits->max_pll_op_freq_hz)));
-	dev_dbg(dev, "pll_op check: min / max pre_pll_clk_div: %d / %d\n",
+	dev_dbg(dev, "pll_op check: min / max pre_pll_clk_div: %u / %u\n",
 		min_pre_pll_clk_div, max_pre_pll_clk_div);
 
 	for (pll->pre_pll_clk_div = min_pre_pll_clk_div;
-- 
1.7.10.4

