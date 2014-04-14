Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbaDNJBC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:01:02 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id EFAF4214BD
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:55 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 16/21] smiapp-pll: Add quirk for op clk divisor == bits per pixel / 2
Date: Mon, 14 Apr 2014 11:58:41 +0300
Message-Id: <1397465926-29724-17-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For some sensors in some configurations the effective value of op clk div is
bits per pixel divided by two. The output clock is correctly calculated
whereas some of the rest of the clock tree uses higher clocks than
calculated. This also limits the bpp to even values if the number of lanes
is four.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c | 10 ++++++++++
 drivers/media/i2c/smiapp-pll.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 6bde587..aca0ed7 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -208,6 +208,8 @@ static int __smiapp_pll_calculate(struct device *dev,
 		div_u64(pll->pll_op_clk_freq_hz, pll->op_sys_clk_div);
 
 	pll->op_pix_clk_div = pll->bits_per_pixel;
+	if (pll->flags & SMIAPP_PLL_FLAG_OP_PIX_DIV_HALF)
+		pll->op_pix_clk_div /= 2;
 	dev_dbg(dev, "op_pix_clk_div: %u\n", pll->op_pix_clk_div);
 
 	pll->op_pix_clk_freq_hz =
@@ -417,6 +419,14 @@ int smiapp_pll_calculate(struct device *dev,
 		return -EINVAL;
 	}
 
+	/*
+	 * Half op pix divisor will give us double the rate compared
+	 * to the regular case. Thus divide the desired pll op clock
+	 * frequency by two.
+	 */
+	if (pll->flags & SMIAPP_PLL_FLAG_OP_PIX_DIV_HALF)
+		pll->pll_op_clk_freq_hz /= 2;
+
 	/* Figure out limits for pre-pll divider based on extclk */
 	dev_dbg(dev, "min / max pre_pll_clk_div: %u / %u\n",
 		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index a25f550..02d11db 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -36,6 +36,8 @@
 #define SMIAPP_PLL_FLAG_NO_OP_CLOCKS				(1 << 1)
 /* the pre-pll div may be odd */
 #define SMIAPP_PLL_FLAG_ALLOW_ODD_PRE_PLL_CLK_DIV		(1 << 2)
+/* op pix div value is half of the bits-per-pixel value */
+#define SMIAPP_PLL_FLAG_OP_PIX_DIV_HALF				(1 << 3)
 
 struct smiapp_pll {
 	/* input values */
-- 
1.8.3.2

