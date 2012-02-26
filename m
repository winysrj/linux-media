Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58438 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2BZD1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 22:27:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH 08/11] mt9m032: Compute PLL parameters at runtime
Date: Sun, 26 Feb 2012 04:27:34 +0100
Message-Id: <1330226857-8651-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the PLL parameters from platform data and pass the external clock
and desired internal clock frequencies instead. The PLL parameters are
now computed at runtime.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m032.c |   16 ++++++----------
 include/media/mt9m032.h       |    4 +---
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index 7b458d9..b636ad4 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -221,21 +221,17 @@ static int mt9m032_setup_pll(struct mt9m032 *sensor)
 	struct mt9m032_platform_data* pdata = sensor->pdata;
 	u16 reg_pll1;
 	unsigned int pre_div;
+	unsigned int pll_out_div;
+	unsigned int pll_mul;
 	int res, ret;
 
-	/* TODO: also support other pre-div values */
-	if (pdata->pll_pre_div != 6) {
-		dev_warn(to_dev(sensor),
-			"Unsupported PLL pre-divisor value %u, using default 6\n",
-			pdata->pll_pre_div);
-	}
 	pre_div = 6;
 
-	sensor->pix_clock = pdata->ext_clock * pdata->pll_mul /
-		(pre_div * pdata->pll_out_div);
+	sensor->pix_clock = pdata->ext_clock * pll_mul /
+		(pre_div * pll_out_div);
 
-	reg_pll1 = ((pdata->pll_out_div - 1) & MT9M032_PLL_CONFIG1_OUTDIV_MASK)
-		   | pdata->pll_mul << MT9M032_PLL_CONFIG1_MUL_SHIFT;
+	reg_pll1 = ((pll_out_div - 1) & MT9M032_PLL_CONFIG1_OUTDIV_MASK)
+		 | (pll_mul << MT9M032_PLL_CONFIG1_MUL_SHIFT);
 
 	ret = mt9m032_write_reg(client, MT9M032_PLL_CONFIG1, reg_pll1);
 	if (!ret)
diff --git a/include/media/mt9m032.h b/include/media/mt9m032.h
index 94cefc5..4e84840 100644
--- a/include/media/mt9m032.h
+++ b/include/media/mt9m032.h
@@ -29,9 +29,7 @@
 
 struct mt9m032_platform_data {
 	u32 ext_clock;
-	u32 pll_pre_div;
-	u32 pll_mul;
-	u32 pll_out_div;
+	u32 int_clock;
 	int invert_pixclock;
 
 };
-- 
1.7.3.4

