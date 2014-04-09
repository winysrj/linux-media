Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6257 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934332AbaDITY7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 15:24:59 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 18CFA212AB
	for <linux-media@vger.kernel.org>; Wed,  9 Apr 2014 22:24:54 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 10/17] smiapp-pll: Add support for odd pre-pll divisors
Date: Wed,  9 Apr 2014 22:25:02 +0300
Message-Id: <1397071509-2071-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some sensors support odd pre-pll divisor.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c | 39 ++++++++++++++++++++++++++-------------
 drivers/media/i2c/smiapp-pll.h |  2 ++
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 8c196c6..93a8214 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -34,14 +34,18 @@ static inline uint64_t div_u64_round_up(uint64_t dividend, uint32_t divisor)
 }
 
 /* Return an even number or one. */
-static inline uint32_t clk_div_even(uint32_t a)
+static inline uint32_t clk_div_even(uint32_t a, bool allow_odd)
 {
+	if (allow_odd)
+		return a;
 	return max_t(uint32_t, 1, a & ~1);
 }
 
 /* Return an even number or one. */
-static inline uint32_t clk_div_even_up(uint32_t a)
+static inline uint32_t clk_div_even_up(uint32_t a, bool allow_odd)
 {
+	if (allow_odd)
+		return a;
 	if (a == 1)
 		return 1;
 	return (a + 1) & ~1;
@@ -268,13 +272,13 @@ static int __smiapp_pll_calculate(struct device *dev,
 	min_sys_div = max(min_sys_div,
 			  DIV_ROUND_UP(min_vt_div,
 				       limits->vt.max_pix_clk_div));
-	dev_dbg(dev, "min_sys_div: max_vt_pix_clk_div: %u\n", min_sys_div);
+	dev_dbg(dev, "min_sys_div: max_vt_pix_clk_div: %d\n", min_sys_div);
 	min_sys_div = max_t(uint32_t, min_sys_div,
 			    pll->pll_op_clk_freq_hz
 			    / limits->vt.max_sys_clk_freq_hz);
-	dev_dbg(dev, "min_sys_div: max_pll_op_clk_freq_hz: %u\n", min_sys_div);
-	min_sys_div = clk_div_even_up(min_sys_div);
-	dev_dbg(dev, "min_sys_div: one or even: %u\n", min_sys_div);
+	dev_dbg(dev, "min_sys_div: max_pll_op_clk_freq_hz: %d\n", min_sys_div);
+	min_sys_div = clk_div_even_up(min_sys_div, 0);
+	dev_dbg(dev, "min_sys_div: one or even: %d\n", min_sys_div);
 
 	max_sys_div = limits->vt.max_sys_clk_div;
 	dev_dbg(dev, "max_sys_div: %u\n", max_sys_div);
@@ -422,14 +426,19 @@ int smiapp_pll_calculate(struct device *dev,
 		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
 	max_pre_pll_clk_div =
 		min_t(uint16_t, limits->max_pre_pll_clk_div,
-		      clk_div_even(pll->ext_clk_freq_hz /
-				   limits->min_pll_ip_freq_hz));
+		      clk_div_even(
+			      pll->ext_clk_freq_hz /
+			      limits->min_pll_ip_freq_hz,
+			      pll->flags
+			      & SMIAPP_PLL_FLAG_ALLOW_ODD_PRE_PLL_CLK_DIV));
 	min_pre_pll_clk_div =
 		max_t(uint16_t, limits->min_pre_pll_clk_div,
 		      clk_div_even_up(
 			      DIV_ROUND_UP(pll->ext_clk_freq_hz,
-					   limits->max_pll_ip_freq_hz)));
-	dev_dbg(dev, "pre-pll check: min / max pre_pll_clk_div: %u / %u\n",
+					   limits->max_pll_ip_freq_hz),
+			      pll->flags
+			      & SMIAPP_PLL_FLAG_ALLOW_ODD_PRE_PLL_CLK_DIV));
+	dev_dbg(dev, "pre-pll check: min / max pre_pll_clk_div: %d / %d\n",
 		min_pre_pll_clk_div, max_pre_pll_clk_div);
 
 	i = gcd(pll->pll_op_clk_freq_hz, pll->ext_clk_freq_hz);
@@ -441,13 +450,17 @@ int smiapp_pll_calculate(struct device *dev,
 		max_t(uint16_t, min_pre_pll_clk_div,
 		      clk_div_even_up(
 			      DIV_ROUND_UP(mul * pll->ext_clk_freq_hz,
-					   limits->max_pll_op_freq_hz)));
-	dev_dbg(dev, "pll_op check: min / max pre_pll_clk_div: %u / %u\n",
+					   limits->max_pll_op_freq_hz),
+			      pll->flags
+			      & SMIAPP_PLL_FLAG_ALLOW_ODD_PRE_PLL_CLK_DIV));
+	dev_dbg(dev, "pll_op check: min / max pre_pll_clk_div: %d / %d\n",
 		min_pre_pll_clk_div, max_pre_pll_clk_div);
 
 	for (pll->pre_pll_clk_div = min_pre_pll_clk_div;
 	     pll->pre_pll_clk_div <= max_pre_pll_clk_div;
-	     pll->pre_pll_clk_div += 2 - (pll->pre_pll_clk_div & 1)) {
+	     pll->pre_pll_clk_div +=
+		     pll->flags & SMIAPP_PLL_FLAG_ALLOW_ODD_PRE_PLL_CLK_DIV
+		     ? 1 : (2 - (pll->pre_pll_clk_div & 1))) {
 		rval = __smiapp_pll_calculate(dev, limits, pll, mul, div,
 					      lane_op_clock_ratio);
 		if (rval)
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index bb5ae28..a25f550 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -34,6 +34,8 @@
 /* op pix clock is for all lanes in total normally */
 #define SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE			(1 << 0)
 #define SMIAPP_PLL_FLAG_NO_OP_CLOCKS				(1 << 1)
+/* the pre-pll div may be odd */
+#define SMIAPP_PLL_FLAG_ALLOW_ODD_PRE_PLL_CLK_DIV		(1 << 2)
 
 struct smiapp_pll {
 	/* input values */
-- 
1.8.3.2

