Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50539 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751266AbaJBIqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:46:43 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 09/18] smiapp: The PLL calculator handles sensors with VT clocks only
Date: Thu,  2 Oct 2014 11:45:59 +0300
Message-Id: <1412239568-8524-10-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

No need to pretend the OP limits are there anymore.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 389e775..d0ea7a3 100644
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

