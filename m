Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44028 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2GCKG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2012 06:06:58 -0400
Received: by gglu4 with SMTP id u4so5058798ggl.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2012 03:06:57 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: andrzej.p@samsung.com, sachin.kamat@linaro.org,
	mchehab@infradead.org, s.nawrocki@samsung.com, patches@linaro.org
Subject: [PATCH 1/1] [media] s5p-jpeg: Use module_platform_driver in jpeg-core.c file
Date: Tue,  3 Jul 2012 15:24:33 +0530
Message-Id: <1341309273-1279-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

module_platform_driver makes the code simpler by eliminating module_init
and module_exit calls.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-jpeg/jpeg-core.c |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index 28b5225d..e40e79b 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -1503,29 +1503,7 @@ static struct platform_driver s5p_jpeg_driver = {
 	},
 };
 
-static int __init
-s5p_jpeg_register(void)
-{
-	int ret;
-
-	pr_info("S5P JPEG V4L2 Driver, (c) 2011 Samsung Electronics\n");
-
-	ret = platform_driver_register(&s5p_jpeg_driver);
-
-	if (ret)
-		pr_err("%s: failed to register jpeg driver\n", __func__);
-
-	return ret;
-}
-
-static void __exit
-s5p_jpeg_unregister(void)
-{
-	platform_driver_unregister(&s5p_jpeg_driver);
-}
-
-module_init(s5p_jpeg_register);
-module_exit(s5p_jpeg_unregister);
+module_platform_driver(s5p_jpeg_driver);
 
 MODULE_AUTHOR("Andrzej Pietrasiewicz <andrzej.p@samsung.com>");
 MODULE_DESCRIPTION("Samsung JPEG codec driver");
-- 
1.7.4.1

