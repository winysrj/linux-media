Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35938 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932110AbcKOM6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 07:58:39 -0500
From: Geliang Tang <geliangtang@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] sh_mobile_ceu_camera: use module_platform_driver
Date: Tue, 15 Nov 2016 20:58:35 +0800
Message-Id: <7530fe1018a26f83366e82c8563001a2de3174d0.1479214627.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use module_platform_driver() helper to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index a15bfb5..96dc017 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1801,18 +1801,7 @@ static struct platform_driver sh_mobile_ceu_driver = {
 	.remove		= sh_mobile_ceu_remove,
 };
 
-static int __init sh_mobile_ceu_init(void)
-{
-	return platform_driver_register(&sh_mobile_ceu_driver);
-}
-
-static void __exit sh_mobile_ceu_exit(void)
-{
-	platform_driver_unregister(&sh_mobile_ceu_driver);
-}
-
-module_init(sh_mobile_ceu_init);
-module_exit(sh_mobile_ceu_exit);
+module_platform_driver(sh_mobile_ceu_driver);
 
 MODULE_DESCRIPTION("SuperH Mobile CEU driver");
 MODULE_AUTHOR("Magnus Damm");
-- 
2.9.3

