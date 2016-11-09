Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60632 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753182AbcKIOYR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:17 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 08/12] exynos-gsc: Simplify system PM
Date: Wed, 09 Nov 2016 15:23:57 +0100
Message-id: <1478701441-29107-9-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142410eucas1p198a52c69c695e97965c968d7b899bae8@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ulf Hansson <ulf.hansson@linaro.org>

It's not needed to keep a local flag about the current system PM state.
Let's just remove that code and the corresponding debug print.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[mszyprow: rebased onto v4.9-rc4]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 21 ---------------------
 drivers/media/platform/exynos-gsc/gsc-core.h |  3 ---
 2 files changed, 24 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index af6502c..4859727 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1169,20 +1169,6 @@ static int gsc_runtime_suspend(struct device *dev)
 #ifdef CONFIG_PM_SLEEP
 static int gsc_resume(struct device *dev)
 {
-	struct gsc_dev *gsc = dev_get_drvdata(dev);
-	unsigned long flags;
-
-	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
-
-	/* Do not resume if the device was idle before system suspend */
-	spin_lock_irqsave(&gsc->slock, flags);
-	if (!test_and_clear_bit(ST_SUSPEND, &gsc->state) ||
-	    !gsc_m2m_opened(gsc)) {
-		spin_unlock_irqrestore(&gsc->slock, flags);
-		return 0;
-	}
-	spin_unlock_irqrestore(&gsc->slock, flags);
-
 	if (!pm_runtime_suspended(dev))
 		return gsc_runtime_resume(dev);
 
@@ -1191,13 +1177,6 @@ static int gsc_resume(struct device *dev)
 
 static int gsc_suspend(struct device *dev)
 {
-	struct gsc_dev *gsc = dev_get_drvdata(dev);
-
-	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
-
-	if (test_and_set_bit(ST_SUSPEND, &gsc->state))
-		return 0;
-
 	if (!pm_runtime_suspended(dev))
 		return gsc_runtime_suspend(dev);
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 7ad7b9d..8480aec 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -48,9 +48,6 @@
 #define	GSC_CTX_ABORT			(1 << 7)
 
 enum gsc_dev_flags {
-	/* for global */
-	ST_SUSPEND,
-
 	/* for m2m node */
 	ST_M2M_OPEN,
 	ST_M2M_RUN,
-- 
1.9.1

