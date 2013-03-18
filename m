Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:41805 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3CRJoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 05:44:01 -0400
Received: by mail-bk0-f52.google.com with SMTP id jk13so2373036bkc.11
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2013 02:44:00 -0700 (PDT)
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-media@vger.kernel.org
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] mx2_camera: use module_platform_driver_probe()
Date: Mon, 18 Mar 2013 10:43:56 +0100
Message-Id: <1363599836-15824-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The commit 39793c6 "[media] mx2_camera: Convert it to platform driver"
used module_platform_driver() to make code smaller,
but since the driver used platform_driver_probe is more appropriate
to use module_platform_driver_probe().

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/soc_camera/mx2_camera.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index ffba7d9..848dff9 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1619,10 +1619,9 @@ static struct platform_driver mx2_camera_driver = {
 	},
 	.id_table	= mx2_camera_devtype,
 	.remove		= mx2_camera_remove,
-	.probe		= mx2_camera_probe,
 };
 
-module_platform_driver(mx2_camera_driver);
+module_platform_driver_probe(mx2_camera_driver, mx2_camera_probe);
 
 MODULE_DESCRIPTION("i.MX27 SoC Camera Host driver");
 MODULE_AUTHOR("Sascha Hauer <sha@pengutronix.de>");
-- 
1.8.2

