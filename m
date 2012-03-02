Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:31155 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab2CBQFO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 11:05:14 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] omap3isp: Handle omap3isp_csi2_reset() errors
Date: Fri,  2 Mar 2012 18:03:01 +0200
Message-Id: <1330704181-31718-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Handle errors from omap3isp_csi2_reset() in omap3isp_csiphy_acquire().

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispcsiphy.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispcsiphy.c b/drivers/media/video/omap3isp/ispcsiphy.c
index 902477d..a53f457 100644
--- a/drivers/media/video/omap3isp/ispcsiphy.c
+++ b/drivers/media/video/omap3isp/ispcsiphy.c
@@ -213,7 +213,9 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
 	if (rval < 0)
 		goto done;
 
-	omap3isp_csi2_reset(phy->csi2);
+	rval = omap3isp_csi2_reset(phy->csi2);
+	if (rval < 0)
+		goto done;
 
 	rval = omap3isp_csiphy_config(phy);
 	if (rval < 0)
-- 
1.7.2.5

