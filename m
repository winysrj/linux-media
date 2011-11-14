Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:43675 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304Ab1KNI3Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 03:29:16 -0500
Received: by mail-bw0-f47.google.com with SMTP id zs2so6500096bkb.20
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 00:29:15 -0800 (PST)
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: linux-media@vger.kernel.org, hvaibhav@ti.com
Cc: archit@ti.com, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH] omap_vout: fix crash if no driver for a display
Date: Mon, 14 Nov 2011 10:28:59 +0200
Message-Id: <1321259339-5202-1-git-send-email-tomi.valkeinen@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

omap_vout crashes on start if a corresponding driver is not loaded for a
display device.

This patch changes omap_vout init sequence to skip devices without a
driver.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 9c5c19f..2d2a136 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -2169,6 +2169,14 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 	vid_dev->num_displays = 0;
 	for_each_dss_dev(dssdev) {
 		omap_dss_get_device(dssdev);
+
+		if (!dssdev->driver) {
+			dev_warn(&pdev->dev, "no driver for display: %s\n",
+					dssdev->name);
+			omap_dss_put_device(dssdev);
+			continue;
+		}
+
 		vid_dev->displays[vid_dev->num_displays++] = dssdev;
 	}
 
-- 
1.7.4.1

