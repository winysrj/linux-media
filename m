Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54495 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab1HEHKp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2011 03:10:45 -0400
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>, <linux-media@vger.kernel.org>
CC: <koen@dominion.thruhere.net>, <tomi.valkeinen@ti.com>,
	<linux-omap@vger.kernel.org>, Archit Taneja <archit@ti.com>
Subject: [PATCH] [media] OMAP_VOUT: Fix build break caused by update_mode removal in DSS2
Date: Fri, 5 Aug 2011 12:49:21 +0530
Message-ID: <1312528761-18241-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DSS2 driver does not support the configuration of the update_mode of a
panel anymore. Remove the setting of update_mode done in omap_vout_probe().
Ignore configuration of TE since omap_vout driver doesn't support manual update
displays anyway.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/video/omap/omap_vout.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index b5ef362..b3a5ecd 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -2194,19 +2194,6 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 					"'%s' Display already enabled\n",
 					def_display->name);
 			}
-			/* set the update mode */
-			if (def_display->caps &
-					OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE) {
-				if (dssdrv->enable_te)
-					dssdrv->enable_te(def_display, 0);
-				if (dssdrv->set_update_mode)
-					dssdrv->set_update_mode(def_display,
-							OMAP_DSS_UPDATE_MANUAL);
-			} else {
-				if (dssdrv->set_update_mode)
-					dssdrv->set_update_mode(def_display,
-							OMAP_DSS_UPDATE_AUTO);
-			}
 		}
 	}
 
-- 
1.7.1

