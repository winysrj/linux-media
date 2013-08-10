Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44031 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753053Ab3HJRnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Aug 2013 13:43:43 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: andriy.shevchenko@intel.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 2/4] smiapp-pll: Add a few comments to PLL calculation
Date: Sat, 10 Aug 2013 20:49:46 +0300
Message-Id: <1376156988-4009-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1376156988-4009-1-git-send-email-sakari.ailus@iki.fi>
References: <1376156988-4009-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PLL calculation heuristics is rather complicated and and is often
difficult to understand to its original author.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp-pll.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index d8d5da7..c83d301 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -87,6 +87,17 @@ static void print_pll(struct device *dev, struct smiapp_pll *pll)
 	dev_dbg(dev, "vt_pix_clk_freq_hz \t%d\n", pll->vt_pix_clk_freq_hz);
 }
 
+/*
+ * Heuristically guess the PLL tree for a given common multiplier and
+ * divisor. Begin with the operational timing and continue to video
+ * timing once operational timing has been verified.
+ *
+ * @mul is the PLL multiplier and @div is the common divisor
+ * (pre_pll_clk_div and op_sys_clk_div combined). The final PLL
+ * multiplier will be a multiple of @mul.
+ *
+ * @return Zero on success, error code on error.
+ */
 static int __smiapp_pll_calculate(struct device *dev,
 				  const struct smiapp_pll_limits *limits,
 				  struct smiapp_pll *pll, uint32_t mul,
@@ -95,6 +106,12 @@ static int __smiapp_pll_calculate(struct device *dev,
 	uint32_t sys_div;
 	uint32_t best_pix_div = INT_MAX >> 1;
 	uint32_t vt_op_binning_div;
+	/*
+	 * Higher multipliers (and divisors) are often required than
+	 * necessitated by the external clock and the output clocks. 
+	 * There are limits for all values in the clock tree. These
+	 * are the minimum and maximum multiplier for mul.
+	 */
 	uint32_t more_mul_min, more_mul_max;
 	uint32_t more_mul_factor;
 	uint32_t min_vt_div, max_vt_div, vt_div;
-- 
1.7.10.4

