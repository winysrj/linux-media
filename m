Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50298 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab1IGQBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 12:01:08 -0400
Date: Wed, 7 Sep 2011 15:49:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH] V4L: omap1-camera: fix Oops with NULL platform data
Message-ID: <Pine.LNX.4.64.1109071548070.14818@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Consistently check for platform data != NULL before dereferencing.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 drivers/media/video/omap1_camera.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index f24bcaf..e87ae2f 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -1579,10 +1579,10 @@ static int __init omap1_cam_probe(struct platform_device *pdev)
 	pcdev->clk = clk;
 
 	pcdev->pdata = pdev->dev.platform_data;
-	pcdev->pflags = pcdev->pdata->flags;
-
-	if (pcdev->pdata)
+	if (pcdev->pdata) {
+		pcdev->pflags = pcdev->pdata->flags;
 		pcdev->camexclk = pcdev->pdata->camexclk_khz * 1000;
+	}
 
 	switch (pcdev->camexclk) {
 	case 6000000:
@@ -1592,6 +1592,7 @@ static int __init omap1_cam_probe(struct platform_device *pdev)
 	case 24000000:
 		break;
 	default:
+		/* pcdev->camexclk != 0 => pcdev->pdata != NULL */
 		dev_warn(&pdev->dev,
 				"Incorrect sensor clock frequency %ld kHz, "
 				"should be one of 0, 6, 8, 9.6, 12 or 24 MHz, "
@@ -1599,8 +1600,7 @@ static int __init omap1_cam_probe(struct platform_device *pdev)
 				pcdev->pdata->camexclk_khz);
 		pcdev->camexclk = 0;
 	case 0:
-		dev_info(&pdev->dev,
-				"Not providing sensor clock\n");
+		dev_info(&pdev->dev, "Not providing sensor clock\n");
 	}
 
 	INIT_LIST_HEAD(&pcdev->capture);
-- 
1.7.2.5

