Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35268 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1IZL7h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 07:59:37 -0400
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: <tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>,
	<sumit.semwal@ti.com>, <linux-media@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 4/4] OMAP_VOUT: Don't trigger updates in omap_vout_probe
Date: Mon, 26 Sep 2011 17:29:25 +0530
Message-ID: <1317038365-30650-5-git-send-email-archit@ti.com>
In-Reply-To: <1317038365-30650-1-git-send-email-archit@ti.com>
References: <1317038365-30650-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the code in omap_vout_probe() which calls display->driver->update() for
all the displays. This isn't correct because:

- An update in probe doesn't make sense, because we don't have any valid content
  to show at this time.
- Calling update for a panel which isn't enabled is not supported by DSS2. This
  leads to a crash at probe.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 7b8e87a..3d9c83e 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -2213,14 +2213,6 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 	if (ret)
 		goto probe_err2;
 
-	for (i = 0; i < vid_dev->num_displays; i++) {
-		struct omap_dss_device *display = vid_dev->displays[i];
-
-		if (display->driver->update)
-			display->driver->update(display, 0, 0,
-					display->panel.timings.x_res,
-					display->panel.timings.y_res);
-	}
 	return 0;
 
 probe_err2:
-- 
1.7.1

