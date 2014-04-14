Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbaDNJBA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:01:00 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 405D4214C5
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:56 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 18/21] smiapp: Use actual pixel rate calculated by the PLL calculator
Date: Mon, 14 Apr 2014 11:58:43 +0300
Message-Id: <1397465926-29724-19-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
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

