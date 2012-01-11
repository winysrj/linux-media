Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38420 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2AKC6g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 21:58:36 -0500
Received: by ggdk6 with SMTP id k6so128387ggd.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 18:58:35 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] drivers: video: mx3_camera: Convert mx3_camera to use module_platform_driver()
Date: Wed, 11 Jan 2012 00:58:28 -0200
Message-Id: <1326250708-17643-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using module_platform_driver makes the code smaller and simpler.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/video/mx3_camera.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index f44323f..7452277 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -1286,19 +1286,7 @@ static struct platform_driver mx3_camera_driver = {
 	.remove		= __devexit_p(mx3_camera_remove),
 };
 
-
-static int __init mx3_camera_init(void)
-{
-	return platform_driver_register(&mx3_camera_driver);
-}
-
-static void __exit mx3_camera_exit(void)
-{
-	platform_driver_unregister(&mx3_camera_driver);
-}
-
-module_init(mx3_camera_init);
-module_exit(mx3_camera_exit);
+module_platform_driver(mx3_camera_driver);
 
 MODULE_DESCRIPTION("i.MX3x SoC Camera Host driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
-- 
1.7.1

