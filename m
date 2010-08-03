Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58896 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab0HCJik (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 05:38:40 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: baruch@tkos.co.il, g.liakhovetski@gmx.de, s.hauer@pengutronix.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 1/5] mx2_camera: change to register and probe
Date: Tue,  3 Aug 2010 11:37:52 +0200
Message-Id: <1280828276-483-2-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

change this driver back to register and probe, since some platforms
first have to initialize an already registered power regulator to switch
on the camera.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/media/video/mx2_camera.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 98c93fa..c77a673 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1491,13 +1491,15 @@ static struct platform_driver mx2_camera_driver = {
 	.driver 	= {
 		.name	= MX2_CAM_DRV_NAME,
 	},
+
+	.probe          = mx2_camera_probe,
 	.remove		= __devexit_p(mx2_camera_remove),
 };
 
 
 static int __init mx2_camera_init(void)
 {
-	return platform_driver_probe(&mx2_camera_driver, &mx2_camera_probe);
+	return platform_driver_register(&mx2_camera_driver);
 }
 
 static void __exit mx2_camera_exit(void)
-- 
1.7.1

