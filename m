Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55057 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756245AbaIQUpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:32 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 1E0F2600A1
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:30 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 03/17] smiapp-pll: Separate bounds checking into a separate function
Date: Wed, 17 Sep 2014 23:45:27 +0300
Message-Id: <1410986741-6801-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Enough work for this function already.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c |  110 +++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 51 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index d14af5c..bde8eb8 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -87,6 +87,64 @@ static void print_pll(struct device *dev, struct smiapp_pll *pll)
 	dev_dbg(dev, "vt_pix_clk_freq_hz \t%u\n", pll->vt_pix_clk_freq_hz);
 }
 
+static int check_all_bounds(struct device *dev,
+			    const struct smiapp_pll_limits *limits,
+			    struct smiapp_pll *pll)
+{
+	int rval;
+
+	rval = bounds_check(dev, pll->pll_ip_clk_freq_hz,
+			    limits->min_pll_ip_freq_hz,
+			    limits->max_pll_ip_freq_hz,
+			    "pll_ip_clk_freq_hz");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->pll_multiplier,
+			limits->min_pll_multiplier, limits->max_pll_multiplier,
+			"pll_multiplier");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->pll_op_clk_freq_hz,
+			limits->min_pll_op_freq_hz, limits->max_pll_op_freq_hz,
+			"pll_op_clk_freq_hz");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->op_sys_clk_div,
+			limits->op.min_sys_clk_div, limits->op.max_sys_clk_div,
+			"op_sys_clk_div");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->op_pix_clk_div,
+			limits->op.min_pix_clk_div, limits->op.max_pix_clk_div,
+			"op_pix_clk_div");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->op_sys_clk_freq_hz,
+			limits->op.min_sys_clk_freq_hz,
+			limits->op.max_sys_clk_freq_hz,
+			"op_sys_clk_freq_hz");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->op_pix_clk_freq_hz,
+			limits->op.min_pix_clk_freq_hz,
+			limits->op.max_pix_clk_freq_hz,
+			"op_pix_clk_freq_hz");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->vt_sys_clk_freq_hz,
+			limits->vt.min_sys_clk_freq_hz,
+			limits->vt.max_sys_clk_freq_hz,
+			"vt_sys_clk_freq_hz");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->vt_pix_clk_freq_hz,
+			limits->vt.min_pix_clk_freq_hz,
+			limits->vt.max_pix_clk_freq_hz,
+			"vt_pix_clk_freq_hz");
+
+	return rval;
+}
+
 /*
  * Heuristically guess the PLL tree for a given common multiplier and
  * divisor. Begin with the operational timing and continue to video
@@ -117,7 +175,6 @@ static int __smiapp_pll_calculate(struct device *dev,
 	uint32_t min_vt_div, max_vt_div, vt_div;
 	uint32_t min_sys_div, max_sys_div;
 	unsigned int i;
-	int rval;
 
 	/*
 	 * Get pre_pll_clk_div so that our pll_op_clk_freq_hz won't be
@@ -323,56 +380,7 @@ static int __smiapp_pll_calculate(struct device *dev,
 	pll->pixel_rate_csi =
 		pll->op_pix_clk_freq_hz * lane_op_clock_ratio;
 
-	rval = bounds_check(dev, pll->pll_ip_clk_freq_hz,
-			    limits->min_pll_ip_freq_hz,
-			    limits->max_pll_ip_freq_hz,
-			    "pll_ip_clk_freq_hz");
-	if (!rval)
-		rval = bounds_check(
-			dev, pll->pll_multiplier,
-			limits->min_pll_multiplier, limits->max_pll_multiplier,
-			"pll_multiplier");
-	if (!rval)
-		rval = bounds_check(
-			dev, pll->pll_op_clk_freq_hz,
-			limits->min_pll_op_freq_hz, limits->max_pll_op_freq_hz,
-			"pll_op_clk_freq_hz");
-	if (!rval)
-		rval = bounds_check(
-			dev, pll->op_sys_clk_div,
-			limits->op.min_sys_clk_div, limits->op.max_sys_clk_div,
-			"op_sys_clk_div");
-	if (!rval)
-		rval = bounds_check(
-			dev, pll->op_pix_clk_div,
-			limits->op.min_pix_clk_div, limits->op.max_pix_clk_div,
-			"op_pix_clk_div");
-	if (!rval)
-		rval = bounds_check(
-			dev, pll->op_sys_clk_freq_hz,
-			limits->op.min_sys_clk_freq_hz,
-			limits->op.max_sys_clk_freq_hz,
-			"op_sys_clk_freq_hz");
-	if (!rval)
-		rval = bounds_check(
-			dev, pll->op_pix_clk_freq_hz,
-			limits->op.min_pix_clk_freq_hz,
-			limits->op.max_pix_clk_freq_hz,
-			"op_pix_clk_freq_hz");
-	if (!rval)
-		rval = bounds_check(
-			dev, pll->vt_sys_clk_freq_hz,
-			limits->vt.min_sys_clk_freq_hz,
-			limits->vt.max_sys_clk_freq_hz,
-			"vt_sys_clk_freq_hz");
-	if (!rval)
-		rval = bounds_check(
-			dev, pll->vt_pix_clk_freq_hz,
-			limits->vt.min_pix_clk_freq_hz,
-			limits->vt.max_pix_clk_freq_hz,
-			"vt_pix_clk_freq_hz");
-
-	return rval;
+	return check_all_bounds(dev, limits, pll);
 }
 
 int smiapp_pll_calculate(struct device *dev,
-- 
1.7.10.4

