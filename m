Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60070 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3CEFEI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 00:04:08 -0500
Received: by mail-pb0-f49.google.com with SMTP id xa12so3911646pbc.36
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 21:04:07 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 1/3] [media] sh_veu: Use module_platform_driver_probe macro
Date: Tue,  5 Mar 2013 10:23:36 +0530
Message-Id: <1362459218-13314-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

module_platform_driver_probe() eliminates the boilerplate and simplifies
the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/sh_veu.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 362d88e..0b32cc3 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -1249,18 +1249,7 @@ static struct platform_driver __refdata sh_veu_pdrv = {
 	},
 };
 
-static int __init sh_veu_init(void)
-{
-	return platform_driver_probe(&sh_veu_pdrv, sh_veu_probe);
-}
-
-static void __exit sh_veu_exit(void)
-{
-	platform_driver_unregister(&sh_veu_pdrv);
-}
-
-module_init(sh_veu_init);
-module_exit(sh_veu_exit);
+module_platform_driver_probe(sh_veu_pdrv, sh_veu_probe);
 
 MODULE_DESCRIPTION("sh-mobile VEU mem2mem driver");
 MODULE_AUTHOR("Guennadi Liakhovetski, <g.liakhovetski@gmx.de>");
-- 
1.7.4.1

