Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50541 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751544AbaJBIqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:46:44 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 12/18] smiapp: Use actual pixel rate calculated by the PLL calculator
Date: Thu,  2 Oct 2014 11:46:02 +0300
Message-Id: <1412239568-8524-13-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index d0ea7a3..861312e 100644
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

