Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55055 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756231AbaIQUpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:32 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id ADDF86009F
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:29 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/17] smiapp-pll: Correct clock debug prints
Date: Wed, 17 Sep 2014 23:45:25 +0300
Message-Id: <1410986741-6801-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The PLL flags were not used correctly.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c |    4 ++--
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
1.7.10.4

