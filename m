Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:60023 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbASNXQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 08:23:16 -0500
Received: by mail-la0-f51.google.com with SMTP id ge10so7748536lab.10
        for <linux-media@vger.kernel.org>; Mon, 19 Jan 2015 05:23:14 -0800 (PST)
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH V2 8/8] [media] exynos-gsc: Simplify system PM
Date: Mon, 19 Jan 2015 14:22:40 +0100
Message-Id: <1421673760-2600-9-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
References: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's not needed to keep a local flag about the current system PM state.
Let's just remove that code and the corresponding debug print.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 21 ---------------------
 drivers/media/platform/exynos-gsc/gsc-core.h |  3 ---
 2 files changed, 24 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 194f9fc..71b227c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1191,20 +1191,6 @@ static int gsc_runtime_suspend(struct device *dev)
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
 
@@ -1213,13 +1199,6 @@ static int gsc_resume(struct device *dev)
 
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
index fa572aa..2f62271 100644
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

