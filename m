Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2EYRjQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 13:39:16 -0400
Received: by pbbrp8 with SMTP id rp8so2035056pbb.19
        for <linux-media@vger.kernel.org>; Fri, 25 May 2012 10:39:15 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/4] [media] s5p-fimc: Add missing static storage class in fimc-mdevice.c file
Date: Fri, 25 May 2012 23:08:51 +0530
Message-Id: <1337967533-22240-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1337967533-22240-1-git-send-email-sachin.kamat@linaro.org>
References: <1337967533-22240-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warnings:
drivers/media/video/s5p-fimc/fimc-mdevice.c:183:5: warning: symbol '__fimc_pipeline_shutdown' was not declared. Should it be static?
drivers/media/video/s5p-fimc/fimc-mdevice.c:1013:12: warning: symbol 'fimc_md_init' was not declared. Should it be static?
drivers/media/video/s5p-fimc/fimc-mdevice.c:1024:13: warning: symbol 'fimc_md_exit' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-fimc/fimc-mdevice.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 52cef48..e65bb28 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -180,7 +180,7 @@ EXPORT_SYMBOL_GPL(fimc_pipeline_initialize);
  * sensor clock.
  * Called with the graph mutex held.
  */
-int __fimc_pipeline_shutdown(struct fimc_pipeline *p)
+static int __fimc_pipeline_shutdown(struct fimc_pipeline *p)
 {
 	int ret = 0;
 
@@ -1010,7 +1010,7 @@ static struct platform_driver fimc_md_driver = {
 	}
 };
 
-int __init fimc_md_init(void)
+static int __init fimc_md_init(void)
 {
 	int ret;
 
@@ -1021,7 +1021,8 @@ int __init fimc_md_init(void)
 
 	return platform_driver_register(&fimc_md_driver);
 }
-void __exit fimc_md_exit(void)
+
+static void __exit fimc_md_exit(void)
 {
 	platform_driver_unregister(&fimc_md_driver);
 	fimc_unregister_driver();
-- 
1.7.5.4

