Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7914 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbaDNJA6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:00:58 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id A29CC21488
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:54 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 10/21] smiapp-pll: Correct clock debug prints
Date: Mon, 14 Apr 2014 11:58:35 +0300
Message-Id: <1397465926-29724-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PLL flags were not used correctly.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 2335529..ab5d9a3 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -67,7 +67,7 @@ static void print_pll(struct device *dev, struct smiapp_pll *pll)
 {
 	dev_dbg(dev, "pre_pll_clk_div\t%d\n",  pll->pre_pll_clk_div);
 	dev_dbg(dev, "pll_multiplier \t%d\n",  pll->pll_multiplier);
-	if (pll->flags != SMIAPP_PLL_FLAG_NO_OP_CLOCKS) {
+	if (!(pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS)) {
 		dev_dbg(dev, "op_sys_clk_div \t%d\n", pll->op_sys_clk_div);
 		dev_dbg(dev, "op_pix_clk_div \t%d\n", pll->op_pix_clk_div);
 	}
@@ -77,7 +77,7 @@ static void print_pll(struct device *dev, struct smiapp_pll *pll)
 	dev_dbg(dev, "ext_clk_freq_hz \t%d\n", pll->ext_clk_freq_hz);
 	dev_dbg(dev, "pll_ip_clk_freq_hz \t%d\n", pll->pll_ip_clk_freq_hz);
 	dev_dbg(dev, "pll_op_clk_freq_hz \t%d\n", pll->pll_op_clk_freq_hz);
-	if (pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS) {
+	if (!(pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS)) {
 		dev_dbg(dev, "op_sys_clk_freq_hz \t%d\n",
 			pll->op_sys_clk_freq_hz);
 		dev_dbg(dev, "op_pix_clk_freq_hz \t%d\n",
-- 
1.8.3.2

