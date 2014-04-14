Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaDNJA6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:00:58 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 4A2932096A
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:55 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 13/21] smiapp-pll: Use 64-bit types limits
Date: Mon, 14 Apr 2014 11:58:38 +0300
Message-Id: <1397465926-29724-14-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Limits may exceed the value range of 32-bit unsigned integers. Thus use 64
bits for all of them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c | 72 +++++++++++++++++++++++-------------------
 drivers/media/i2c/smiapp-pll.h | 20 ++++++------
 2 files changed, 50 insertions(+), 42 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index d14af5c..ec9f8bb 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -28,6 +28,11 @@
 
 #include "smiapp-pll.h"
 
+static inline uint64_t div_u64_round_up(uint64_t dividend, uint32_t divisor)
+{
+	return div_u64(dividend + divisor - 1, divisor);
+}
+
 /* Return an even number or one. */
 static inline uint32_t clk_div_even(uint32_t a)
 {
@@ -52,13 +57,14 @@ static inline uint32_t is_one_or_even(uint32_t a)
 	return 1;
 }
 
-static int bounds_check(struct device *dev, uint32_t val,
-			uint32_t min, uint32_t max, char *str)
+static int bounds_check(struct device *dev, uint64_t val,
+			uint64_t min, uint64_t max, char *str)
 {
 	if (val >= min && val <= max)
 		return 0;
 
-	dev_dbg(dev, "%s out of bounds: %d (%d--%d)\n", str, val, min, max);
+	dev_dbg(dev, "%s out of bounds: %llu (%llu--%llu)\n", str, val, min,
+		max);
 
 	return -EINVAL;
 }
@@ -75,15 +81,15 @@ static void print_pll(struct device *dev, struct smiapp_pll *pll)
 	dev_dbg(dev, "vt_pix_clk_div \t%u\n",  pll->vt_pix_clk_div);
 
 	dev_dbg(dev, "ext_clk_freq_hz \t%u\n", pll->ext_clk_freq_hz);
-	dev_dbg(dev, "pll_ip_clk_freq_hz \t%u\n", pll->pll_ip_clk_freq_hz);
-	dev_dbg(dev, "pll_op_clk_freq_hz \t%u\n", pll->pll_op_clk_freq_hz);
+	dev_dbg(dev, "pll_ip_clk_freq_hz \t%llu\n", pll->pll_ip_clk_freq_hz);
+	dev_dbg(dev, "pll_op_clk_freq_hz \t%llu\n", pll->pll_op_clk_freq_hz);
 	if (!(pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS)) {
-		dev_dbg(dev, "op_sys_clk_freq_hz \t%u\n",
+		dev_dbg(dev, "op_sys_clk_freq_hz \t%llu\n",
 			pll->op_sys_clk_freq_hz);
 		dev_dbg(dev, "op_pix_clk_freq_hz \t%u\n",
 			pll->op_pix_clk_freq_hz);
 	}
-	dev_dbg(dev, "vt_sys_clk_freq_hz \t%u\n", pll->vt_sys_clk_freq_hz);
+	dev_dbg(dev, "vt_sys_clk_freq_hz \t%llu\n", pll->vt_sys_clk_freq_hz);
 	dev_dbg(dev, "vt_pix_clk_freq_hz \t%u\n", pll->vt_pix_clk_freq_hz);
 }
 
@@ -131,10 +137,11 @@ static int __smiapp_pll_calculate(struct device *dev,
 		more_mul_max);
 	/* Don't go above max pll op frequency. */
 	more_mul_max =
-		min_t(uint32_t,
+		min_t(uint64_t,
 		      more_mul_max,
-		      limits->max_pll_op_freq_hz
-		      / (pll->ext_clk_freq_hz / pll->pre_pll_clk_div * mul));
+		      div_u64(limits->max_pll_op_freq_hz,
+			      (pll->ext_clk_freq_hz /
+			       pll->pre_pll_clk_div * mul)));
 	dev_dbg(dev, "more_mul_max: max_pll_op_freq_hz check: %u\n",
 		more_mul_max);
 	/* Don't go above the division capability of op sys clock divider. */
@@ -150,9 +157,9 @@ static int __smiapp_pll_calculate(struct device *dev,
 		more_mul_max);
 
 	/* Ensure we won't go below min_pll_op_freq_hz. */
-	more_mul_min = DIV_ROUND_UP(limits->min_pll_op_freq_hz,
-				    pll->ext_clk_freq_hz / pll->pre_pll_clk_div
-				    * mul);
+	more_mul_min = div_u64_round_up(
+		limits->min_pll_op_freq_hz,
+		pll->ext_clk_freq_hz / pll->pre_pll_clk_div * mul);
 	dev_dbg(dev, "more_mul_min: min_pll_op_freq_hz check: %u\n",
 		more_mul_min);
 	/* Ensure we won't go below min_pll_multiplier. */
@@ -194,13 +201,13 @@ static int __smiapp_pll_calculate(struct device *dev,
 
 	/* Derive pll_op_clk_freq_hz. */
 	pll->op_sys_clk_freq_hz =
-		pll->pll_op_clk_freq_hz / pll->op_sys_clk_div;
+		div_u64(pll->pll_op_clk_freq_hz, pll->op_sys_clk_div);
 
 	pll->op_pix_clk_div = pll->bits_per_pixel;
 	dev_dbg(dev, "op_pix_clk_div: %u\n", pll->op_pix_clk_div);
 
 	pll->op_pix_clk_freq_hz =
-		pll->op_sys_clk_freq_hz / pll->op_pix_clk_div;
+		div_u64(pll->op_sys_clk_freq_hz, pll->op_pix_clk_div);
 
 	/*
 	 * Some sensors perform analogue binning and some do this
@@ -235,9 +242,9 @@ static int __smiapp_pll_calculate(struct device *dev,
 
 	/* Find smallest and biggest allowed vt divisor. */
 	dev_dbg(dev, "min_vt_div: %u\n", min_vt_div);
-	min_vt_div = max(min_vt_div,
-			 DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
-				      limits->vt.max_pix_clk_freq_hz));
+	min_vt_div = max_t(uint32_t, min_vt_div,
+			   div_u64_round_up(pll->pll_op_clk_freq_hz,
+					    limits->vt.max_pix_clk_freq_hz));
 	dev_dbg(dev, "min_vt_div: max_vt_pix_clk_freq_hz: %u\n",
 		min_vt_div);
 	min_vt_div = max_t(uint32_t, min_vt_div,
@@ -247,9 +254,9 @@ static int __smiapp_pll_calculate(struct device *dev,
 
 	max_vt_div = limits->vt.max_sys_clk_div * limits->vt.max_pix_clk_div;
 	dev_dbg(dev, "max_vt_div: %u\n", max_vt_div);
-	max_vt_div = min(max_vt_div,
-			 DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
-				      limits->vt.min_pix_clk_freq_hz));
+	max_vt_div = min_t(uint32_t, max_vt_div,
+			   div_u64_round_up(pll->pll_op_clk_freq_hz,
+					    limits->vt.min_pix_clk_freq_hz));
 	dev_dbg(dev, "max_vt_div: min_vt_pix_clk_freq_hz: %u\n",
 		max_vt_div);
 
@@ -263,9 +270,9 @@ static int __smiapp_pll_calculate(struct device *dev,
 			  DIV_ROUND_UP(min_vt_div,
 				       limits->vt.max_pix_clk_div));
 	dev_dbg(dev, "min_sys_div: max_vt_pix_clk_div: %u\n", min_sys_div);
-	min_sys_div = max(min_sys_div,
-			  pll->pll_op_clk_freq_hz
-			  / limits->vt.max_sys_clk_freq_hz);
+	min_sys_div = max_t(uint32_t, min_sys_div,
+			    pll->pll_op_clk_freq_hz
+			    / limits->vt.max_sys_clk_freq_hz);
 	dev_dbg(dev, "min_sys_div: max_pll_op_clk_freq_hz: %u\n", min_sys_div);
 	min_sys_div = clk_div_even_up(min_sys_div);
 	dev_dbg(dev, "min_sys_div: one or even: %u\n", min_sys_div);
@@ -276,9 +283,9 @@ static int __smiapp_pll_calculate(struct device *dev,
 			  DIV_ROUND_UP(max_vt_div,
 				       limits->vt.min_pix_clk_div));
 	dev_dbg(dev, "max_sys_div: min_vt_pix_clk_div: %u\n", max_sys_div);
-	max_sys_div = min(max_sys_div,
-			  DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
-				       limits->vt.min_pix_clk_freq_hz));
+	max_sys_div = min_t(uint32_t, max_sys_div,
+			    div_u64_round_up(pll->pll_op_clk_freq_hz,
+					     limits->vt.min_pix_clk_freq_hz));
 	dev_dbg(dev, "max_sys_div: min_vt_pix_clk_freq_hz: %u\n", max_sys_div);
 
 	/*
@@ -316,9 +323,9 @@ static int __smiapp_pll_calculate(struct device *dev,
 	pll->vt_pix_clk_div = best_pix_div;
 
 	pll->vt_sys_clk_freq_hz =
-		pll->pll_op_clk_freq_hz / pll->vt_sys_clk_div;
+		div_u64(pll->pll_op_clk_freq_hz, pll->vt_sys_clk_div);
 	pll->vt_pix_clk_freq_hz =
-		pll->vt_sys_clk_freq_hz / pll->vt_pix_clk_div;
+		div_u64(pll->vt_sys_clk_freq_hz, pll->vt_pix_clk_div);
 
 	pll->pixel_rate_csi =
 		pll->op_pix_clk_freq_hz * lane_op_clock_ratio;
@@ -402,9 +409,10 @@ int smiapp_pll_calculate(struct device *dev,
 			* (pll->csi2.lanes / lane_op_clock_ratio);
 		break;
 	case SMIAPP_PLL_BUS_TYPE_PARALLEL:
-		pll->pll_op_clk_freq_hz = pll->link_freq * pll->bits_per_pixel
-			/ DIV_ROUND_UP(pll->bits_per_pixel,
-				       pll->parallel.bus_width);
+		pll->pll_op_clk_freq_hz = div_u64(
+			pll->link_freq * pll->bits_per_pixel,
+			DIV_ROUND_UP(pll->bits_per_pixel,
+				     pll->parallel.bus_width));
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index 5ce2b61..bb5ae28 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -63,11 +63,11 @@ struct smiapp_pll {
 	uint16_t vt_pix_clk_div;
 
 	uint32_t ext_clk_freq_hz;
-	uint32_t pll_ip_clk_freq_hz;
-	uint32_t pll_op_clk_freq_hz;
-	uint32_t op_sys_clk_freq_hz;
+	uint64_t pll_ip_clk_freq_hz;
+	uint64_t pll_op_clk_freq_hz;
+	uint64_t op_sys_clk_freq_hz;
 	uint32_t op_pix_clk_freq_hz;
-	uint32_t vt_sys_clk_freq_hz;
+	uint64_t vt_sys_clk_freq_hz;
 	uint32_t vt_pix_clk_freq_hz;
 
 	uint32_t pixel_rate_csi;
@@ -76,12 +76,12 @@ struct smiapp_pll {
 struct smiapp_pll_branch_limits {
 	uint16_t min_sys_clk_div;
 	uint16_t max_sys_clk_div;
-	uint32_t min_sys_clk_freq_hz;
-	uint32_t max_sys_clk_freq_hz;
+	uint64_t min_sys_clk_freq_hz;
+	uint64_t max_sys_clk_freq_hz;
 	uint16_t min_pix_clk_div;
 	uint16_t max_pix_clk_div;
-	uint32_t min_pix_clk_freq_hz;
-	uint32_t max_pix_clk_freq_hz;
+	uint64_t min_pix_clk_freq_hz;
+	uint64_t max_pix_clk_freq_hz;
 };
 
 struct smiapp_pll_limits {
@@ -94,8 +94,8 @@ struct smiapp_pll_limits {
 	uint32_t max_pll_ip_freq_hz;
 	uint16_t min_pll_multiplier;
 	uint16_t max_pll_multiplier;
-	uint32_t min_pll_op_freq_hz;
-	uint32_t max_pll_op_freq_hz;
+	uint64_t min_pll_op_freq_hz;
+	uint64_t max_pll_op_freq_hz;
 
 	struct smiapp_pll_branch_limits vt;
 	struct smiapp_pll_branch_limits op;
-- 
1.8.3.2

