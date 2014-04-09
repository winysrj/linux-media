Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933402AbaDITZA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 15:25:00 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 527D6212C6
	for <linux-media@vger.kernel.org>; Wed,  9 Apr 2014 22:24:54 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 11/17] smiapp: Remove validation of op_pix_clk_div
Date: Wed,  9 Apr 2014 22:25:03 +0300
Message-Id: <1397071509-2071-12-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

op_pix_clk_div is directly assigned and not calculated. There's no need to
verify it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 93a8214..be94921 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -354,11 +354,6 @@ static int __smiapp_pll_calculate(struct device *dev,
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

