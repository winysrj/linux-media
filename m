Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41315 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2IEL2R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 07:28:17 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so300122dad.19
        for <linux-media@vger.kernel.org>; Wed, 05 Sep 2012 04:28:16 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, g.liakhovetski@gmx.de
Subject: [PATCH 2/2] [media] soc_camera: Use module_platform_driver macro
Date: Wed,  5 Sep 2012 16:55:27 +0530
Message-Id: <1346844327-5524-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1346844327-5524-1-git-send-email-sachin.kamat@linaro.org>
References: <1346844327-5524-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

module_platform_driver simplifies the code by eliminating
module_init and module_exit calls.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/soc_camera/soc_camera.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index acf5289..4c7d509 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1575,18 +1575,7 @@ static struct platform_driver __refdata soc_camera_pdrv = {
 	},
 };
 
-static int __init soc_camera_init(void)
-{
-	return platform_driver_register(&soc_camera_pdrv);
-}
-
-static void __exit soc_camera_exit(void)
-{
-	platform_driver_unregister(&soc_camera_pdrv);
-}
-
-module_init(soc_camera_init);
-module_exit(soc_camera_exit);
+module_platform_driver(soc_camera_pdrv);
 
 MODULE_DESCRIPTION("Image capture bus driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
-- 
1.7.4.1

