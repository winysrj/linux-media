Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55065 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756762AbaIQUpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:34 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id B9DF3600A9
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:31 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 11/17] smiapp: Use actual pixel rate calculated by the PLL calculator
Date: Wed, 17 Sep 2014 23:45:35 +0300
Message-Id: <1410986741-6801-12-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 54cb136..6db0e8d 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -289,7 +289,7 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 		return rval;
 
 	__v4l2_ctrl_s_ctrl_int64(sensor->pixel_rate_parray,
-				 pll->vt.pix_clk_freq_hz);
+				 pll->pixel_rate_pixel_array);
 	__v4l2_ctrl_s_ctrl_int64(sensor->pixel_rate_csi, pll->pixel_rate_csi);
 
 	return 0;
@@ -894,7 +894,7 @@ static int smiapp_update_mode(struct smiapp_sensor *sensor)
 	dev_dbg(&client->dev, "hblank\t\t%d\n", sensor->hblank->val);
 
 	dev_dbg(&client->dev, "real timeperframe\t100/%d\n",
-		sensor->pll.vt.pix_clk_freq_hz /
+		sensor->pll.pixel_rate_pixel_array /
 		((sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width
 		  + sensor->hblank->val) *
 		 (sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height
-- 
1.7.10.4

