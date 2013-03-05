Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37211 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3CEFEK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 00:04:10 -0500
Received: by mail-pb0-f53.google.com with SMTP id un1so3890270pbc.12
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 21:04:10 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 2/3] [media] sh_vou: Use module_platform_driver_probe macro
Date: Tue,  5 Mar 2013 10:23:37 +0530
Message-Id: <1362459218-13314-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1362459218-13314-1-git-send-email-sachin.kamat@linaro.org>
References: <1362459218-13314-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

module_platform_driver_probe() eliminates the boilerplate and simplifies
the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/sh_vou.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 66c8da1..d853162 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1485,18 +1485,7 @@ static struct platform_driver __refdata sh_vou = {
 	},
 };
 
-static int __init sh_vou_init(void)
-{
-	return platform_driver_probe(&sh_vou, sh_vou_probe);
-}
-
-static void __exit sh_vou_exit(void)
-{
-	platform_driver_unregister(&sh_vou);
-}
-
-module_init(sh_vou_init);
-module_exit(sh_vou_exit);
+module_platform_driver_probe(sh_vou, sh_vou_probe);
 
 MODULE_DESCRIPTION("SuperH VOU driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
-- 
1.7.4.1

