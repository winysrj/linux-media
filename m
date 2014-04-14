Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:10238 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbaDNJA5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:00:57 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id C2DB520981
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:55 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 15/21] smiapp: Remove validation of op_pix_clk_div
Date: Mon, 14 Apr 2014 11:58:40 +0300
Message-Id: <1397465926-29724-16-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

op_pix_clk_div is directly assigned and not calculated. There's no need to
verify it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index bed44c0..6bde587 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -355,11 +355,6 @@ static int __smiapp_pll_calculate(struct device *dev,
 			"op_sys_clk_div");
 	if (!rval)
 		rval = bounds_check(
-			dev, pll->op_pix_clk_div,
-			limits->op.min_pix_clk_div, limits->op.max_pix_clk_div,
-			"op_pix_clk_div");
-	if (!rval)
-		rval = bounds_check(
 			dev, pll->op_sys_clk_freq_hz,
 			limits->op.min_sys_clk_freq_hz,
 			limits->op.max_sys_clk_freq_hz,
-- 
1.8.3.2

