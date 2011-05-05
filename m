Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37390 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab1EENxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 09:53:23 -0400
Received: by wwa36 with SMTP id 36so2386546wwa.1
        for <linux-media@vger.kernel.org>; Thu, 05 May 2011 06:53:22 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] OMAP3: ISP: Fix unbalanced use of omap3isp_get().
Date: Thu,  5 May 2011 15:53:08 +0200
Message-Id: <1304603588-3178-1-git-send-email-javier.martin@vista-silicon.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Do not use omap3isp_get() when what we really want to do is just
enable clocks, since omap3isp_get() has additional, unwanted, side
effects as an increase of the counter.

This prevented omap3isp of working with Beagleboard xM and it has
been tested only with that platform + mt9p031 sensor.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/omap3isp/isp.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 472a693..ca0831f 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -85,9 +85,11 @@ module_param(autoidle, int, 0444);
 MODULE_PARM_DESC(autoidle, "Enable OMAP3ISP AUTOIDLE support");
 
 static void isp_save_ctx(struct isp_device *isp);
-
 static void isp_restore_ctx(struct isp_device *isp);
 
+static int isp_enable_clocks(struct isp_device *isp);
+static void isp_disable_clocks(struct isp_device *isp);
+
 static const struct isp_res_mapping isp_res_maps[] = {
 	{
 		.isp_rev = ISP_REVISION_2_0,
@@ -239,10 +241,10 @@ static u32 isp_set_xclk(struct isp_device *isp, u32 xclk, u8 xclksel)
 
 	/* Do we go from stable whatever to clock? */
 	if (divisor >= 2 && isp->xclk_divisor[xclksel - 1] < 2)
-		omap3isp_get(isp);
+		isp_enable_clocks(isp);
 	/* Stopping the clock. */
 	else if (divisor < 2 && isp->xclk_divisor[xclksel - 1] >= 2)
-		omap3isp_put(isp);
+		isp_disable_clocks(isp);
 
 	isp->xclk_divisor[xclksel - 1] = divisor;
 
-- 
1.7.0.4

