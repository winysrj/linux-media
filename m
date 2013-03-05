Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:37467 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3CEMCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 07:02:46 -0500
Received: by mail-pb0-f52.google.com with SMTP id ma3so4342963pbc.25
        for <linux-media@vger.kernel.org>; Tue, 05 Mar 2013 04:02:45 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, prabhakar.lad@ti.com, sachin.kamat@linaro.org,
	manjunath.hadli@ti.com
Subject: [PATCH 1/1] [media] davinci_vpfe: Use module_platform_driver macro
Date: Tue,  5 Mar 2013 17:22:14 +0530
Message-Id: <1362484334-18804-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

module_platform_driver() eliminates the boilerplate and simplifies
the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index 7b35171..c7ae7d7 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -719,22 +719,4 @@ static struct platform_driver vpfe_driver = {
 	.remove = vpfe_remove,
 };
 
-/**
- * vpfe_init : This function registers device driver
- */
-static __init int vpfe_init(void)
-{
-	/* Register driver to the kernel */
-	return platform_driver_register(&vpfe_driver);
-}
-
-/**
- * vpfe_cleanup : This function un-registers device driver
- */
-static void vpfe_cleanup(void)
-{
-	platform_driver_unregister(&vpfe_driver);
-}
-
-module_init(vpfe_init);
-module_exit(vpfe_cleanup);
+module_platform_driver(vpfe_driver);
-- 
1.7.4.1

