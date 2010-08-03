Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58900 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab0HCJik (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 05:38:40 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: baruch@tkos.co.il, g.liakhovetski@gmx.de, s.hauer@pengutronix.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Teresa Gamez <T.Gamez@phytec.de>
Subject: [PATCH 5/5] mx2_camera: add informative camera clock frequency printout
Date: Tue,  3 Aug 2010 11:37:56 +0200
Message-Id: <1280828276-483-6-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ported mx27_camera to 2.6.33.2
Signed-off-by: Teresa Gamez <T.Gamez@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mx2_camera.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 7f27492..fb1b1cb 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1360,6 +1360,9 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 			goto exit_dma_free;
 	}
 
+	dev_info(&pdev->dev, "Camera clock frequency: %ld\n",
+			clk_get_rate(pcdev->clk_csi));
+
 	INIT_LIST_HEAD(&pcdev->capture);
 	INIT_LIST_HEAD(&pcdev->active_bufs);
 	spin_lock_init(&pcdev->lock);
-- 
1.7.1

