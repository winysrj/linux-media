Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55063 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756231AbaIQUpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:34 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 5586D600A7
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:31 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 09/17] smiapp: Remove validation of op_pix_clk_div
Date: Wed, 17 Sep 2014 23:45:33 +0300
Message-Id: <1410986741-6801-10-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

op_pix_clk_div is directly assigned and not calculated. There's no need to
verify it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index 862ca0c..0d5c503 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -116,11 +116,6 @@ static int check_all_bounds(struct device *dev,
 			"op_sys_clk_div");
 	if (!rval)
 		rval = bounds_check(
-			dev, op_pll->pix_clk_div,
-			op_limits->min_pix_clk_div, op_limits->max_pix_clk_div,
-			"op_pix_clk_div");
-	if (!rval)
-		rval = bounds_check(
 			dev, op_pll->sys_clk_freq_hz,
 			op_limits->min_sys_clk_freq_hz,
 			op_limits->max_sys_clk_freq_hz,
-- 
1.7.10.4

