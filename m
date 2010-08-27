Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40574 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab0H0MjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 08:39:08 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, baruch@tkos.co.il,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH v2] mx2_camera: add informative camera clock frequency printout
Date: Fri, 27 Aug 2010 14:39:05 +0200
Message-Id: <1282912745-15623-1-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280828276-483-6-git-send-email-m.grzeschik@pengutronix.de>
References: <1280828276-483-6-git-send-email-m.grzeschik@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mx2_camera.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 61241af..a3e04b6 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1415,6 +1415,9 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	if (err)
 		goto exit_free_emma;
 
+	dev_info(&pdev->dev, "MX2 Camera (CSI) driver probed, clock frequency: %ld\n",
+			clk_get_rate(pcdev->clk_csi));
+
 	return 0;
 
 exit_free_emma:
-- 
1.7.1

