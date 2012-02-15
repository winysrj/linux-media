Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56304 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759150Ab2BONda (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 08:33:30 -0500
Received: by yhoo21 with SMTP id o21so610315yho.19
        for <linux-media@vger.kernel.org>; Wed, 15 Feb 2012 05:33:30 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, javier.martin@vista-silicon.com,
	kernel@pengutronix.de, mchehab@infradead.org,
	Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/3] media: video: mx2_camera.c: Fix build warning by initializing 'res_emma'
Date: Wed, 15 Feb 2012 11:33:19 -0200
Message-Id: <1329312801-20501-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following build warning:

drivers/media/video/mx2_camera.c: In function 'mx2_camera_probe':
drivers/media/video/mx2_camera.c:1527: warning: 'res_emma' may be used uninitialized in this function

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/mx2_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 04aab0c..5888e33 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1524,7 +1524,7 @@ out:
 static int __devinit mx2_camera_probe(struct platform_device *pdev)
 {
 	struct mx2_camera_dev *pcdev;
-	struct resource *res_csi, *res_emma;
+	struct resource *res_csi, *res_emma = NULL;
 	void __iomem *base_csi;
 	int irq_csi, irq_emma;
 	irq_handler_t mx2_cam_irq_handler = cpu_is_mx25() ? mx25_camera_irq
-- 
1.7.1

