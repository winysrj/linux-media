Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54816 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3CEFEN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 00:04:13 -0500
Received: by mail-pb0-f41.google.com with SMTP id um15so3926824pbc.14
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 21:04:12 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 3/3] [media] soc_camera/mx1_camera: Use module_platform_driver_probe macro
Date: Tue,  5 Mar 2013 10:23:38 +0530
Message-Id: <1362459218-13314-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1362459218-13314-1-git-send-email-sachin.kamat@linaro.org>
References: <1362459218-13314-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

module_platform_driver_probe() eliminates the boilerplate and simplifies
the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/soc_camera/mx1_camera.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
index 25b2a28..4389f43 100644
--- a/drivers/media/platform/soc_camera/mx1_camera.c
+++ b/drivers/media/platform/soc_camera/mx1_camera.c
@@ -859,18 +859,7 @@ static struct platform_driver mx1_camera_driver = {
 	.remove		= __exit_p(mx1_camera_remove),
 };
 
-static int __init mx1_camera_init(void)
-{
-	return platform_driver_probe(&mx1_camera_driver, mx1_camera_probe);
-}
-
-static void __exit mx1_camera_exit(void)
-{
-	return platform_driver_unregister(&mx1_camera_driver);
-}
-
-module_init(mx1_camera_init);
-module_exit(mx1_camera_exit);
+module_platform_driver_probe(mx1_camera_driver, mx1_camera_probe);
 
 MODULE_DESCRIPTION("i.MX1/i.MXL SoC Camera Host driver");
 MODULE_AUTHOR("Paulius Zaleckas <paulius.zaleckas@teltonika.lt>");
-- 
1.7.4.1

