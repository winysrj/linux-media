Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14194 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753456AbcKIOYN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:13 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 04/12] exynos-gsc: Make runtime PM callbacks available for
 CONFIG_PM
Date: Wed, 09 Nov 2016 15:23:53 +0100
Message-id: <1478701441-29107-5-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142408eucas1p24bd5bce9a6046e186948a2f4f65c7d7d@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ulf Hansson <ulf.hansson@linaro.org>

There are no need to set up the runtime PM callbacks unless they are
being used. It also causes compiler warnings about unused functions.

Silence the warnings by making them available for CONFIG_PM.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[mszyprow: rebased onto v4.9-rc4]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 79 ++++++++++++++--------------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index b5a99af..7e99fda 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -988,43 +988,6 @@ static void *gsc_get_drv_data(struct platform_device *pdev)
 	return driver_data;
 }
 
-static int gsc_m2m_suspend(struct gsc_dev *gsc)
-{
-	unsigned long flags;
-	int timeout;
-
-	spin_lock_irqsave(&gsc->slock, flags);
-	if (!gsc_m2m_pending(gsc)) {
-		spin_unlock_irqrestore(&gsc->slock, flags);
-		return 0;
-	}
-	clear_bit(ST_M2M_SUSPENDED, &gsc->state);
-	set_bit(ST_M2M_SUSPENDING, &gsc->state);
-	spin_unlock_irqrestore(&gsc->slock, flags);
-
-	timeout = wait_event_timeout(gsc->irq_queue,
-			     test_bit(ST_M2M_SUSPENDED, &gsc->state),
-			     GSC_SHUTDOWN_TIMEOUT);
-
-	clear_bit(ST_M2M_SUSPENDING, &gsc->state);
-	return timeout == 0 ? -EAGAIN : 0;
-}
-
-static void gsc_m2m_resume(struct gsc_dev *gsc)
-{
-	struct gsc_ctx *ctx;
-	unsigned long flags;
-
-	spin_lock_irqsave(&gsc->slock, flags);
-	/* Clear for full H/W setup in first run after resume */
-	ctx = gsc->m2m.ctx;
-	gsc->m2m.ctx = NULL;
-	spin_unlock_irqrestore(&gsc->slock, flags);
-
-	if (test_and_clear_bit(ST_M2M_SUSPENDED, &gsc->state))
-		gsc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
-}
-
 static int gsc_probe(struct platform_device *pdev)
 {
 	struct gsc_dev *gsc;
@@ -1130,6 +1093,44 @@ static int gsc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int gsc_m2m_suspend(struct gsc_dev *gsc)
+{
+	unsigned long flags;
+	int timeout;
+
+	spin_lock_irqsave(&gsc->slock, flags);
+	if (!gsc_m2m_pending(gsc)) {
+		spin_unlock_irqrestore(&gsc->slock, flags);
+		return 0;
+	}
+	clear_bit(ST_M2M_SUSPENDED, &gsc->state);
+	set_bit(ST_M2M_SUSPENDING, &gsc->state);
+	spin_unlock_irqrestore(&gsc->slock, flags);
+
+	timeout = wait_event_timeout(gsc->irq_queue,
+			     test_bit(ST_M2M_SUSPENDED, &gsc->state),
+			     GSC_SHUTDOWN_TIMEOUT);
+
+	clear_bit(ST_M2M_SUSPENDING, &gsc->state);
+	return timeout == 0 ? -EAGAIN : 0;
+}
+
+static void gsc_m2m_resume(struct gsc_dev *gsc)
+{
+	struct gsc_ctx *ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gsc->slock, flags);
+	/* Clear for full H/W setup in first run after resume */
+	ctx = gsc->m2m.ctx;
+	gsc->m2m.ctx = NULL;
+	spin_unlock_irqrestore(&gsc->slock, flags);
+
+	if (test_and_clear_bit(ST_M2M_SUSPENDED, &gsc->state))
+		gsc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
+}
+
 static int gsc_runtime_resume(struct device *dev)
 {
 	struct gsc_dev *gsc = dev_get_drvdata(dev);
@@ -1160,6 +1161,7 @@ static int gsc_runtime_suspend(struct device *dev)
 	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
 	return ret;
 }
+#endif
 
 static int gsc_resume(struct device *dev)
 {
@@ -1201,8 +1203,7 @@ static int gsc_suspend(struct device *dev)
 static const struct dev_pm_ops gsc_pm_ops = {
 	.suspend		= gsc_suspend,
 	.resume			= gsc_resume,
-	.runtime_suspend	= gsc_runtime_suspend,
-	.runtime_resume		= gsc_runtime_resume,
+	SET_RUNTIME_PM_OPS(gsc_runtime_suspend, gsc_runtime_resume, NULL)
 };
 
 static struct platform_driver gsc_driver = {
-- 
1.9.1

