Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50591 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752085AbaJBIrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:47:09 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 10/18] smiapp: Remove validation of op_pix_clk_div
Date: Thu,  2 Oct 2014 11:46:00 +0300
Message-Id: <1412239568-8524-11-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
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

