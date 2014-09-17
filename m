Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55062 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756625AbaIQUpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:34 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 239EA600A6
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:31 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 08/17] smiapp: The PLL calculator handles sensors with VT clocks only
Date: Wed, 17 Sep 2014 23:45:32 +0300
Message-Id: <1410986741-6801-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

No need to pretend the OP limits are there anymore.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 2f81c9c..54cb136 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -277,16 +277,6 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 	struct smiapp_pll *pll = &sensor->pll;
 	int rval;
 
-	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0) {
-		/*
-		 * Fill in operational clock divisors limits from the
-		 * video timing ones. On profile 0 sensors the
-		 * requirements regarding them are essentially the
-		 * same as on VT ones.
-		 */
-		lim.op = lim.vt;
-	}
-
 	pll->binning_horizontal = sensor->binning_horizontal;
 	pll->binning_vertical = sensor->binning_vertical;
 	pll->link_freq =
-- 
1.7.10.4

