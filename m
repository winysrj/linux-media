Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64629 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964940AbaDITZO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 15:25:14 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 519DF20E92
	for <linux-media@vger.kernel.org>; Wed,  9 Apr 2014 22:24:55 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 15/17] smiapp-pll: Add quirk flag for sensors that effectively use double pix clks
Date: Wed,  9 Apr 2014 22:25:07 +0300
Message-Id: <1397071509-2071-16-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some sensors have effectively the double pixel (and other clocks) compared
to calculations.

The frequency of the bus is also affected similarly so take this into
account when calculating pll_op_clock frequency.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c | 10 ++++++++++
 drivers/media/i2c/smiapp-pll.h |  6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index a83597e..8c48bdc 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -335,6 +335,10 @@ static int __smiapp_pll_calculate(struct device *dev,
 	pll->pixel_rate_csi =
 		pll->op_pix_clk_freq_hz * lane_op_clock_ratio;
 	pll->pixel_rate_pixel_array = pll->vt_pix_clk_freq_hz;
+	if (pll->flags & SMIAPP_PLL_FLAG_PIX_CLOCK_DOUBLE) {
+		pll->pixel_rate_csi *= 2;
+		pll->pixel_rate_pixel_array *= 2;
+	}
 
 	rval = bounds_check(dev, pll->pll_ip_clk_freq_hz,
 			    limits->min_pll_ip_freq_hz,
@@ -426,6 +430,12 @@ int smiapp_pll_calculate(struct device *dev,
 	 */
 	if (pll->flags & SMIAPP_PLL_FLAG_OP_PIX_DIV_HALF)
 		pll->pll_op_clk_freq_hz /= 2;
+	/*
+	 * If it'll be multiplied by two in the end divide it now to
+	 * avoid achieving double the desired clock.
+	 */
+	if (pll->flags & SMIAPP_PLL_FLAG_PIX_CLOCK_DOUBLE)
+		pll->pll_op_clk_freq_hz /= 2;
 
 	/* Figure out limits for pre-pll divider based on extclk */
 	dev_dbg(dev, "min / max pre_pll_clk_div: %u / %u\n",
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index c6ad809..9eaac54 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -38,6 +38,12 @@
 #define SMIAPP_PLL_FLAG_ALLOW_ODD_PRE_PLL_CLK_DIV		(1 << 2)
 /* op pix div value is half of the bits-per-pixel value */
 #define SMIAPP_PLL_FLAG_OP_PIX_DIV_HALF				(1 << 3)
+/*
+ * The effective vt and op pix clocks are twice as high as the
+ * calculated value. The limits are still against the regular limit
+ * values.
+ */
+#define SMIAPP_PLL_FLAG_PIX_CLOCK_DOUBLE			(1 << 4)
 
 struct smiapp_pll {
 	/* input values */
-- 
1.8.3.2

