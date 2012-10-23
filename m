Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57629 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933160Ab2JWPm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 11:42:56 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: timo.ahonen@nokia.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 6/6] smiapp-pll: Constify limits argument to smiapp_pll_calculate()
Date: Tue, 23 Oct 2012 18:42:50 +0300
Message-Id: <1351006971-32308-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
References: <20121023154231.GB23685@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

The limits are input parameters and should not be modified by the
smiapp_pll_calculate() function. Make them const.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/smiapp-pll.c |   35 +++++++++++++++++------------------
 drivers/media/i2c/smiapp-pll.h |    3 ++-
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index cbef446..61e2401 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -88,7 +88,7 @@ static void print_pll(struct device *dev, struct smiapp_pll *pll)
 }
 
 static int __smiapp_pll_calculate(struct device *dev,
-				  struct smiapp_pll_limits *limits,
+				  const struct smiapp_pll_limits *limits,
 				  struct smiapp_pll *pll, uint32_t mul,
 				  uint32_t div, uint32_t lane_op_clock_ratio)
 {
@@ -306,14 +306,10 @@ static int __smiapp_pll_calculate(struct device *dev,
 	pll->pixel_rate_csi =
 		pll->op_pix_clk_freq_hz * lane_op_clock_ratio;
 
-	rval = bounds_check(dev, pll->pre_pll_clk_div,
-			    limits->min_pre_pll_clk_div,
-			    limits->max_pre_pll_clk_div, "pre_pll_clk_div");
-	if (!rval)
-		rval = bounds_check(
-			dev, pll->pll_ip_clk_freq_hz,
-			limits->min_pll_ip_freq_hz, limits->max_pll_ip_freq_hz,
-			"pll_ip_clk_freq_hz");
+	rval = bounds_check(dev, pll->pll_ip_clk_freq_hz,
+			    limits->min_pll_ip_freq_hz,
+			    limits->max_pll_ip_freq_hz,
+			    "pll_ip_clk_freq_hz");
 	if (!rval)
 		rval = bounds_check(
 			dev, pll->pll_multiplier,
@@ -362,9 +358,12 @@ static int __smiapp_pll_calculate(struct device *dev,
 	return rval;
 }
 
-int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
+int smiapp_pll_calculate(struct device *dev,
+			 const struct smiapp_pll_limits *limits,
 			 struct smiapp_pll *pll)
 {
+	uint16_t min_pre_pll_clk_div;
+	uint16_t max_pre_pll_clk_div;
 	uint32_t lane_op_clock_ratio;
 	uint32_t mul, div;
 	unsigned int i;
@@ -397,33 +396,33 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 	/* Figure out limits for pre-pll divider based on extclk */
 	dev_dbg(dev, "min / max pre_pll_clk_div: %d / %d\n",
 		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
-	limits->max_pre_pll_clk_div =
+	max_pre_pll_clk_div =
 		min_t(uint16_t, limits->max_pre_pll_clk_div,
 		      clk_div_even(pll->ext_clk_freq_hz /
 				   limits->min_pll_ip_freq_hz));
-	limits->min_pre_pll_clk_div =
+	min_pre_pll_clk_div =
 		max_t(uint16_t, limits->min_pre_pll_clk_div,
 		      clk_div_even_up(
 			      DIV_ROUND_UP(pll->ext_clk_freq_hz,
 					   limits->max_pll_ip_freq_hz)));
 	dev_dbg(dev, "pre-pll check: min / max pre_pll_clk_div: %d / %d\n",
-		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
+		min_pre_pll_clk_div, max_pre_pll_clk_div);
 
 	i = gcd(pll->pll_op_clk_freq_hz, pll->ext_clk_freq_hz);
 	mul = div_u64(pll->pll_op_clk_freq_hz, i);
 	div = pll->ext_clk_freq_hz / i;
 	dev_dbg(dev, "mul %d / div %d\n", mul, div);
 
-	limits->min_pre_pll_clk_div =
-		max_t(uint16_t, limits->min_pre_pll_clk_div,
+	min_pre_pll_clk_div =
+		max_t(uint16_t, min_pre_pll_clk_div,
 		      clk_div_even_up(
 			      DIV_ROUND_UP(mul * pll->ext_clk_freq_hz,
 					   limits->max_pll_op_freq_hz)));
 	dev_dbg(dev, "pll_op check: min / max pre_pll_clk_div: %d / %d\n",
-		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
+		min_pre_pll_clk_div, max_pre_pll_clk_div);
 
-	for (pll->pre_pll_clk_div = limits->min_pre_pll_clk_div;
-	     pll->pre_pll_clk_div <= limits->max_pre_pll_clk_div;
+	for (pll->pre_pll_clk_div = min_pre_pll_clk_div;
+	     pll->pre_pll_clk_div <= max_pre_pll_clk_div;
 	     pll->pre_pll_clk_div += 2 - (pll->pre_pll_clk_div & 1)) {
 		rval = __smiapp_pll_calculate(dev, limits, pll, mul, div,
 					      lane_op_clock_ratio);
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index 8500e6e..9491a41 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -107,7 +107,8 @@ struct smiapp_pll_limits {
 
 struct device;
 
-int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
+int smiapp_pll_calculate(struct device *dev,
+			 const struct smiapp_pll_limits *limits,
 			 struct smiapp_pll *pll);
 
 #endif /* SMIAPP_PLL_H */
-- 
1.7.2.5

