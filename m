Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55061 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756878AbaIQUpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:35 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 2F5D06009F
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:33 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 17/17] smiapp: Decrease link frequency if media bus pixel format BPP requires
Date: Wed, 17 Sep 2014 23:45:41 +0300
Message-Id: <1410986741-6801-18-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Decrease the link frequency to the next lower if the user chooses a media
bus code (BPP) cannot be achieved using the selected link frequency.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 537ca92..ce2c34d 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -286,11 +286,27 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 
 	pll->binning_horizontal = sensor->binning_horizontal;
 	pll->binning_vertical = sensor->binning_vertical;
-	pll->link_freq =
-		sensor->link_freq->qmenu_int[sensor->link_freq->val];
 	pll->scale_m = sensor->scale_m;
 	pll->bits_per_pixel = sensor->csi_format->compressed;
 
+	if (!test_bit(sensor->link_freq->val,
+		      &sensor->valid_link_freqs[
+			      sensor->csi_format->compressed
+			      - SMIAPP_COMPRESSED_BASE])) {
+		/*
+		 * Setting the link frequency will perform PLL
+		 * re-calculation already, so skip that.
+		 */
+		return __v4l2_ctrl_s_ctrl(
+			sensor->link_freq,
+			__ffs(sensor->valid_link_freqs[
+				      sensor->csi_format->compressed
+				      - SMIAPP_COMPRESSED_BASE]));
+	}
+
+	pll->link_freq =
+		sensor->link_freq->qmenu_int[sensor->link_freq->val];
+
 	rval = smiapp_pll_try(sensor, pll);
 	if (rval < 0)
 		return rval;
-- 
1.7.10.4

