Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10732 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754100AbcKIOYR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:17 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 07/12] exynos-gsc: Make system PM callbacks available for
 CONFIG_PM_SLEEP
Date: Wed, 09 Nov 2016 15:23:56 +0100
Message-id: <1478701441-29107-8-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142410eucas1p1ce029aa84c383de34c7b354e1633c783@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ulf Hansson <ulf.hansson@linaro.org>

There are no need to set up the system PM callbacks unless they are
being used. It also causes compiler warnings about unused functions.

Silence the warnings by making them available for CONFIG_PM_SLEEP.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[mszyprow: rebased onto v4.9-rc4]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 9ba1619..af6502c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1166,6 +1166,7 @@ static int gsc_runtime_suspend(struct device *dev)
 }
 #endif
 
+#ifdef CONFIG_PM_SLEEP
 static int gsc_resume(struct device *dev)
 {
 	struct gsc_dev *gsc = dev_get_drvdata(dev);
@@ -1202,10 +1203,10 @@ static int gsc_suspend(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static const struct dev_pm_ops gsc_pm_ops = {
-	.suspend		= gsc_suspend,
-	.resume			= gsc_resume,
+	SET_SYSTEM_SLEEP_PM_OPS(gsc_suspend, gsc_resume)
 	SET_RUNTIME_PM_OPS(gsc_runtime_suspend, gsc_runtime_resume, NULL)
 };
 
-- 
1.9.1

