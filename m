Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57618 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933059Ab2JWPmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 11:42:54 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: timo.ahonen@nokia.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 2/6] smiapp-pll: Try other pre-pll divisors
Date: Tue, 23 Oct 2012 18:42:46 +0300
Message-Id: <1351006971-32308-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
References: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The smiapp pll calculator assumed that the minimum pre-pll divisor was
perfect. That may not always be the case, so let's try the others, too.
Typically there are just a few alternatives.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp-pll.c |  131 ++++++++++++++++++++++------------------
 1 files changed, 73 insertions(+), 58 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index e92dc46..d7e3475 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -58,7 +58,7 @@ static int bounds_check(struct device *dev, uint32_t val,
 	if (val >= min && val <= max)
 		return 0;
 
-	dev_warn(dev, "%s out of bounds: %d (%d--%d)\n", str, val, min, max);
+	dev_dbg(dev, "%s out of bounds: %d (%d--%d)\n", str, val, min, max);
 
 	return -EINVAL;
 }
@@ -87,14 +87,14 @@ static void print_pll(struct device *dev, struct smiapp_pll *pll)
 	dev_dbg(dev, "vt_pix_clk_freq_hz \t%d\n", pll->vt_pix_clk_freq_hz);
 }
 
-int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
-			 struct smiapp_pll *pll)
+static int __smiapp_pll_calculate(struct device *dev,
+				  struct smiapp_pll_limits *limits,
+				  struct smiapp_pll *pll, uint32_t mul,
+				  uint32_t div, uint32_t lane_op_clock_ratio)
 {
 	uint32_t sys_div;
 	uint32_t best_pix_div = INT_MAX >> 1;
 	uint32_t vt_op_binning_div;
-	uint32_t lane_op_clock_ratio;
-	uint32_t mul, div;
 	uint32_t more_mul_min, more_mul_max;
 	uint32_t more_mul_factor;
 	uint32_t min_vt_div, max_vt_div, vt_div;
@@ -102,54 +102,6 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 	unsigned int i;
 	int rval;
 
-	if (pll->flags & SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE)
-		lane_op_clock_ratio = pll->lanes;
-	else
-		lane_op_clock_ratio = 1;
-	dev_dbg(dev, "lane_op_clock_ratio: %d\n", lane_op_clock_ratio);
-
-	dev_dbg(dev, "binning: %dx%d\n", pll->binning_horizontal,
-		pll->binning_vertical);
-
-	/* CSI transfers 2 bits per clock per lane; thus times 2 */
-	pll->pll_op_clk_freq_hz = pll->link_freq * 2
-		* (pll->lanes / lane_op_clock_ratio);
-
-	/* Figure out limits for pre-pll divider based on extclk */
-	dev_dbg(dev, "min / max pre_pll_clk_div: %d / %d\n",
-		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
-	limits->max_pre_pll_clk_div =
-		min_t(uint16_t, limits->max_pre_pll_clk_div,
-		      clk_div_even(pll->ext_clk_freq_hz /
-				   limits->min_pll_ip_freq_hz));
-	limits->min_pre_pll_clk_div =
-		max_t(uint16_t, limits->min_pre_pll_clk_div,
-		      clk_div_even_up(
-			      DIV_ROUND_UP(pll->ext_clk_freq_hz,
-					   limits->max_pll_ip_freq_hz)));
-	dev_dbg(dev, "pre-pll check: min / max pre_pll_clk_div: %d / %d\n",
-		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
-
-	i = gcd(pll->pll_op_clk_freq_hz, pll->ext_clk_freq_hz);
-	mul = div_u64(pll->pll_op_clk_freq_hz, i);
-	div = pll->ext_clk_freq_hz / i;
-	dev_dbg(dev, "mul %d / div %d\n", mul, div);
-
-	limits->min_pre_pll_clk_div =
-		max_t(uint16_t, limits->min_pre_pll_clk_div,
-		      clk_div_even_up(
-			      DIV_ROUND_UP(mul * pll->ext_clk_freq_hz,
-					   limits->max_pll_op_freq_hz)));
-	dev_dbg(dev, "pll_op check: min / max pre_pll_clk_div: %d / %d\n",
-		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
-
-	if (limits->min_pre_pll_clk_div > limits->max_pre_pll_clk_div) {
-		dev_err(dev, "unable to compute pre_pll divisor\n");
-		return -EINVAL;
-	}
-
-	pll->pre_pll_clk_div = limits->min_pre_pll_clk_div;
-
 	/*
 	 * Get pre_pll_clk_div so that our pll_op_clk_freq_hz won't be
 	 * too high.
@@ -193,8 +145,8 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 		more_mul_min);
 
 	if (more_mul_min > more_mul_max) {
-		dev_warn(dev,
-			 "unable to compute more_mul_min and more_mul_max\n");
+		dev_dbg(dev,
+			"unable to compute more_mul_min and more_mul_max\n");
 		return -EINVAL;
 	}
 
@@ -209,7 +161,7 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 
 	dev_dbg(dev, "final more_mul: %d\n", i);
 	if (i > more_mul_max) {
-		dev_warn(dev, "final more_mul is bad, max %d\n", more_mul_max);
+		dev_dbg(dev, "final more_mul is bad, max %d\n", more_mul_max);
 		return -EINVAL;
 	}
 
@@ -354,8 +306,6 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 	pll->pixel_rate_csi =
 		pll->op_pix_clk_freq_hz * lane_op_clock_ratio;
 
-	print_pll(dev, pll);
-
 	rval = bounds_check(dev, pll->pre_pll_clk_div,
 			    limits->min_pre_pll_clk_div,
 			    limits->max_pre_pll_clk_div, "pre_pll_clk_div");
@@ -411,6 +361,71 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 
 	return rval;
 }
+
+int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
+			 struct smiapp_pll *pll)
+{
+	uint32_t lane_op_clock_ratio;
+	uint32_t mul, div;
+	unsigned int i;
+	int rval = -EINVAL;
+
+	if (pll->flags & SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE)
+		lane_op_clock_ratio = pll->lanes;
+	else
+		lane_op_clock_ratio = 1;
+	dev_dbg(dev, "lane_op_clock_ratio: %d\n", lane_op_clock_ratio);
+
+	dev_dbg(dev, "binning: %dx%d\n", pll->binning_horizontal,
+		pll->binning_vertical);
+
+	/* CSI transfers 2 bits per clock per lane; thus times 2 */
+	pll->pll_op_clk_freq_hz = pll->link_freq * 2
+		* (pll->lanes / lane_op_clock_ratio);
+
+	/* Figure out limits for pre-pll divider based on extclk */
+	dev_dbg(dev, "min / max pre_pll_clk_div: %d / %d\n",
+		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
+	limits->max_pre_pll_clk_div =
+		min_t(uint16_t, limits->max_pre_pll_clk_div,
+		      clk_div_even(pll->ext_clk_freq_hz /
+				   limits->min_pll_ip_freq_hz));
+	limits->min_pre_pll_clk_div =
+		max_t(uint16_t, limits->min_pre_pll_clk_div,
+		      clk_div_even_up(
+			      DIV_ROUND_UP(pll->ext_clk_freq_hz,
+					   limits->max_pll_ip_freq_hz)));
+	dev_dbg(dev, "pre-pll check: min / max pre_pll_clk_div: %d / %d\n",
+		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
+
+	i = gcd(pll->pll_op_clk_freq_hz, pll->ext_clk_freq_hz);
+	mul = div_u64(pll->pll_op_clk_freq_hz, i);
+	div = pll->ext_clk_freq_hz / i;
+	dev_dbg(dev, "mul %d / div %d\n", mul, div);
+
+	limits->min_pre_pll_clk_div =
+		max_t(uint16_t, limits->min_pre_pll_clk_div,
+		      clk_div_even_up(
+			      DIV_ROUND_UP(mul * pll->ext_clk_freq_hz,
+					   limits->max_pll_op_freq_hz)));
+	dev_dbg(dev, "pll_op check: min / max pre_pll_clk_div: %d / %d\n",
+		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
+
+	for (pll->pre_pll_clk_div = limits->min_pre_pll_clk_div;
+	     pll->pre_pll_clk_div <= limits->max_pre_pll_clk_div;
+	     pll->pre_pll_clk_div += 2 - (pll->pre_pll_clk_div & 1)) {
+		rval = __smiapp_pll_calculate(dev, limits, pll, mul, div,
+					      lane_op_clock_ratio);
+		if (rval)
+			continue;
+
+		print_pll(dev, pll);
+		return 0;
+	}
+
+	dev_info(dev, "unable to compute pre_pll divisor\n");
+	return rval;
+}
 EXPORT_SYMBOL_GPL(smiapp_pll_calculate);
 
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>");
-- 
1.7.2.5

