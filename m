Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:59588 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaD3IOc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 04:14:32 -0400
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH] omap3isp: Make isp_register_entities() fail when sensor registration fails
Date: Wed, 30 Apr 2014 10:14:31 +0200
Message-Id: <1398845671-12989-1-git-send-email-pmeerw@pmeerw.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

isp_register_entities() ignores registration failure of the sensor,
/dev/video* devices are created nevertheless

if the sensor fails, all entities should not be created

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
I'm not too sure about the ENODEV error code

 drivers/media/platform/omap3isp/isp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 06a0df4..1ef6b5d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1903,8 +1903,10 @@ static int isp_register_entities(struct isp_device *isp)
 		unsigned int i;
 
 		sensor = isp_register_subdev_group(isp, subdevs->subdevs);
-		if (sensor == NULL)
-			continue;
+		if (sensor == NULL) {
+			ret = -ENODEV;
+			goto done;
+		}
 
 		sensor->host_priv = subdevs;
 
-- 
1.7.9.5

