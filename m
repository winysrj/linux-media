Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15387 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934320AbcHaM43 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 08:56:29 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 6/6] media: s5p-jpeg: fix system and runtime pm integration
Date: Wed, 31 Aug 2016 14:55:59 +0200
Message-id: <1472648159-9814-7-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1472648159-9814-1-git-send-email-m.szyprowski@samsung.com>
References: <1472648159-9814-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use generic helpers instead of open-coding usage of runtime pm for system
sleep pm, which was potentially broken for some corner cases.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 785e6936c881..739ee49b9790 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2996,27 +2996,11 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
 }
 #endif /* CONFIG_PM */
 
-#ifdef CONFIG_PM_SLEEP
-static int s5p_jpeg_suspend(struct device *dev)
-{
-	if (pm_runtime_suspended(dev))
-		return 0;
-
-	return s5p_jpeg_runtime_suspend(dev);
-}
-
-static int s5p_jpeg_resume(struct device *dev)
-{
-	if (pm_runtime_suspended(dev))
-		return 0;
-
-	return s5p_jpeg_runtime_resume(dev);
-}
-#endif
-
 static const struct dev_pm_ops s5p_jpeg_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(s5p_jpeg_suspend, s5p_jpeg_resume)
-	SET_RUNTIME_PM_OPS(s5p_jpeg_runtime_suspend, s5p_jpeg_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+	SET_RUNTIME_PM_OPS(s5p_jpeg_runtime_suspend, s5p_jpeg_runtime_resume,
+			   NULL)
 };
 
 static struct s5p_jpeg_variant s5p_jpeg_drvdata = {
-- 
1.9.1

