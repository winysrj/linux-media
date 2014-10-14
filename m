Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35822 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbaJNHQF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 03:16:05 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so7814157lbi.9
        for <linux-media@vger.kernel.org>; Tue, 14 Oct 2014 00:16:04 -0700 (PDT)
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kevin Hilman <khilman@linaro.org>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Philipp Zabel <philipp.zabel@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Pavel Machek <pavel@ucw.cz>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5/7] [media] exynos-gsc: Fixup system PM
Date: Tue, 14 Oct 2014 09:15:38 +0200
Message-Id: <1413270940-4378-6-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
References: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We had several issues with the system PM support.
1) It were depending on CONFIG_PM_RUNTIME.
2) It unnecessarily tracked the suspend state in a flag.
3) If userspace through sysfs prevents runtime PM operations, could
cause the device to stay in low power after a system PM resume, which
is not reflected properly.

Solve all the above issues by using pm_runtime_force_suspend|resume() as
the system PM callbacks.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 41 ++--------------------------
 drivers/media/platform/exynos-gsc/gsc-core.h |  3 --
 2 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 361a807..1b9f3d7 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1183,46 +1183,9 @@ static int gsc_runtime_suspend(struct device *dev)
 }
 #endif
 
-static int gsc_resume(struct device *dev)
-{
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
-	if (!pm_runtime_suspended(dev))
-		return gsc_runtime_resume(dev);
-
-	return 0;
-}
-
-static int gsc_suspend(struct device *dev)
-{
-	struct gsc_dev *gsc = dev_get_drvdata(dev);
-
-	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
-
-	if (test_and_set_bit(ST_SUSPEND, &gsc->state))
-		return 0;
-
-	if (!pm_runtime_suspended(dev))
-		return gsc_runtime_suspend(dev);
-
-	return 0;
-}
-
 static const struct dev_pm_ops gsc_pm_ops = {
-	.suspend		= gsc_suspend,
-	.resume			= gsc_resume,
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 	SET_PM_RUNTIME_PM_OPS(gsc_runtime_suspend, gsc_runtime_resume, NULL)
 };
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index ef0a656..2dbaa20 100644
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

