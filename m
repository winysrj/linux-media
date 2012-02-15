Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44088 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759175Ab2BONdg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 08:33:36 -0500
Received: by ggnh1 with SMTP id h1so590708ggn.19
        for <linux-media@vger.kernel.org>; Wed, 15 Feb 2012 05:33:35 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, javier.martin@vista-silicon.com,
	kernel@pengutronix.de, mchehab@infradead.org,
	Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 3/3] media: video: mx2_camera.c: Remove unneeded dev_dbg
Date: Wed, 15 Feb 2012 11:33:21 -0200
Message-Id: <1329312801-20501-3-git-send-email-festevam@gmail.com>
In-Reply-To: <1329312801-20501-1-git-send-email-festevam@gmail.com>
References: <1329312801-20501-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

csi clock frequency is already shown by:

dev_info(&pdev->dev, "MX2 Camera (CSI) driver probed, clock frequency: %ld\n",
		clk_get_rate(pcdev->clk_csi));

,so no need to have the dev_dbg call to present the same information.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/mx2_camera.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 689cb42..42ad401 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1555,9 +1555,6 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		goto exit_kfree;
 	}
 
-	dev_dbg(&pdev->dev, "Camera clock frequency: %ld\n",
-			clk_get_rate(pcdev->clk_csi));
-
 	/* Initialize DMA */
 #ifdef CONFIG_MACH_MX27
 	if (cpu_is_mx27()) {
-- 
1.7.1

