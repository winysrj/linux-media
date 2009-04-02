Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39889 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755411AbZDBJtu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2009 05:49:50 -0400
Date: Thu, 2 Apr 2009 11:49:55 +0200 (CEST)
From: Guennadi Liakhovetski <lg@denx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] mx3-camera: fix to match the new clock naming
Message-ID: <Pine.LNX.4.64.0904021145040.5263@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the i.MX31 transition to clkdev clock names have changed, fix the 
driver to use the new name.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 70629e1..7e6b51d 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -1100,7 +1100,7 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	}
 	memset(mx3_cam, 0, sizeof(*mx3_cam));
 
-	mx3_cam->clk = clk_get(&pdev->dev, "csi_clk");
+	mx3_cam->clk = clk_get(&pdev->dev, "csi");
 	if (IS_ERR(mx3_cam->clk)) {
 		err = PTR_ERR(mx3_cam->clk);
 		goto eclkget;
