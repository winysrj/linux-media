Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47450 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab2EYXPW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 19:15:22 -0400
Received: by mail-vc0-f174.google.com with SMTP id f11so727674vcb.19
        for <linux-media@vger.kernel.org>; Fri, 25 May 2012 16:15:21 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: kernel@pengutronix.de
Cc: shawn.guo@freescale.com,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>
Subject: [PATCH 06/15] video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepare
Date: Fri, 25 May 2012 20:14:47 -0300
Message-Id: <1337987696-31728-6-git-send-email-festevam@gmail.com>
In-Reply-To: <1337987696-31728-1-git-send-email-festevam@gmail.com>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Prepare the clock before enabling it.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/mx1_camera.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 4296a83..dc58084 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -402,7 +402,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 
 	dev_dbg(pcdev->icd->parent, "Activate device\n");
 
-	clk_enable(pcdev->clk);
+	clk_prepare_enable(pcdev->clk);
 
 	/* enable CSI before doing anything else */
 	__raw_writel(csicr1, pcdev->base + CSICR1);
@@ -421,7 +421,7 @@ static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
 	/* Disable all CSI interface */
 	__raw_writel(0x00, pcdev->base + CSICR1);
 
-	clk_disable(pcdev->clk);
+	clk_disable_unprepare(pcdev->clk);
 }
 
 /*
-- 
1.7.1

