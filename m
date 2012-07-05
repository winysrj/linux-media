Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60431 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2GEUio (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 16:38:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 1/9] soc-camera: Don't fail at module init time if no device is present
Date: Thu,  5 Jul 2012 22:38:40 +0200
Message-Id: <1341520728-2707-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The soc-camera module exports functions that are needed by soc-camera
client drivers even when not running in soc-camera mode. Replace the
platform_driver_probe() with a platform_driver_register() call to avoid
module load failures if no soc-camera device is present.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/soc_camera.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 0421bf9..e7c6809 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1518,6 +1518,7 @@ static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver __refdata soc_camera_pdrv = {
+	.probe = soc_camera_pdrv_probe,
 	.remove  = __devexit_p(soc_camera_pdrv_remove),
 	.driver  = {
 		.name	= "soc-camera-pdrv",
@@ -1527,7 +1528,7 @@ static struct platform_driver __refdata soc_camera_pdrv = {
 
 static int __init soc_camera_init(void)
 {
-	return platform_driver_probe(&soc_camera_pdrv, soc_camera_pdrv_probe);
+	return platform_driver_register(&soc_camera_pdrv);
 }
 
 static void __exit soc_camera_exit(void)
-- 
1.7.8.6

