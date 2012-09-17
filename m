Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64439 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab2IQFgy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 01:36:54 -0400
Received: by pbbrr13 with SMTP id rr13so8486026pbb.19
        for <linux-media@vger.kernel.org>; Sun, 16 Sep 2012 22:36:54 -0700 (PDT)
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 26/34] media: mx2_camera: remove dead code in mx2_camera_add_device
Date: Mon, 17 Sep 2012 13:34:55 +0800
Message-Id: <1347860103-4141-27-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org>
References: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a piece of code becoming dead since commit 2c9ba37 ([media]
V4L: mx2_camera: remove unsupported i.MX27 DMA mode, make EMMA
mandatory).  It should have been removed together with the commit.
Remove it now.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/mx2_camera.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 965427f..89c7e28 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -441,11 +441,9 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 
 	csicr1 = CSICR1_MCLKEN;
 
-	if (cpu_is_mx27()) {
+	if (cpu_is_mx27())
 		csicr1 |= CSICR1_PRP_IF_EN | CSICR1_FCC |
 			CSICR1_RXFF_LEVEL(0);
-	} else if (cpu_is_mx27())
-		csicr1 |= CSICR1_SOF_INTEN | CSICR1_RXFF_LEVEL(2);
 
 	pcdev->csicr1 = csicr1;
 	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
-- 
1.7.9.5

