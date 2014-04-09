Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39630 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964939AbaDITZO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 15:25:14 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 2B261200CB
	for <linux-media@vger.kernel.org>; Wed,  9 Apr 2014 22:24:55 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 14/17] smiapp: Use actual pixel rate calculated by the PLL calculator
Date: Wed,  9 Apr 2014 22:25:06 +0300
Message-Id: <1397071509-2071-15-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 6d940f0..284df17 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -297,7 +297,7 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 	if (rval < 0)
 		return rval;
 
-	sensor->pixel_rate_parray->cur.val64 = pll->vt_pix_clk_freq_hz;
+	sensor->pixel_rate_parray->cur.val64 = pll->pixel_rate_pixel_array;
 	sensor->pixel_rate_csi->cur.val64 = pll->pixel_rate_csi;
 
 	return 0;
@@ -865,7 +865,7 @@ static int smiapp_update_mode(struct smiapp_sensor *sensor)
 	dev_dbg(&client->dev, "hblank\t\t%d\n", sensor->hblank->val);
 
 	dev_dbg(&client->dev, "real timeperframe\t100/%d\n",
-		sensor->pll.vt_pix_clk_freq_hz /
+		sensor->pll.pixel_rate_pixel_array /
 		((sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width
 		  + sensor->hblank->val) *
 		 (sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height
-- 
1.8.3.2

