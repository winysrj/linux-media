Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:40133
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758561Ab2K3PGd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Nov 2012 10:06:33 -0500
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] mx2_camera: Convert it to platform driver
Date: Fri, 30 Nov 2012 13:06:21 -0200
Message-ID: <1354287981-24545-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Converting it to platform code can make the code smaller.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/soc_camera/mx2_camera.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 791cd1d..36b4ee0 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1912,22 +1912,11 @@ static struct platform_driver mx2_camera_driver = {
 		.name	= MX2_CAM_DRV_NAME,
 	},
 	.id_table	= mx2_camera_devtype,
+	.probe		= mx2_camera_probe,
 	.remove		= __devexit_p(mx2_camera_remove),
 };
 
-
-static int __init mx2_camera_init(void)
-{
-	return platform_driver_probe(&mx2_camera_driver, &mx2_camera_probe);
-}
-
-static void __exit mx2_camera_exit(void)
-{
-	return platform_driver_unregister(&mx2_camera_driver);
-}
-
-module_init(mx2_camera_init);
-module_exit(mx2_camera_exit);
+module_platform_driver(mx2_camera_driver);
 
 MODULE_DESCRIPTION("i.MX27/i.MX25 SoC Camera Host driver");
 MODULE_AUTHOR("Sascha Hauer <sha@pengutronix.de>");
-- 
1.7.9.5


