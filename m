Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:24108 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030789Ab3HITZ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 15:25:29 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, arun.kk@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Tomasz Figa <t.figa@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 03/10] exynos4-is: Handle suspend/resume of fimc-is-i2c
 correctly
Date: Fri, 09 Aug 2013 21:24:05 +0200
Message-id: <1376076252-30150-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1376076252-30150-1-git-send-email-s.nawrocki@samsung.com>
References: <1376076122-29963-1-git-send-email-s.nawrocki@samsung.com>
 <1376076252-30150-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Figa <t.figa@samsung.com>

If the same callbacks are used for runtime and system suspend/resume,
clocks can get disabled twice, which can lead to negative reference
counts and kernel warnings.

This patch splits suspend/resume callbacks into separate runtime and
system-wide functions, so clock gating is done correctly.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-i2c.c |   33 ++++++++++++++++++++---
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.c b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
index 617a798..6bc481a 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-i2c.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
@@ -83,21 +83,46 @@ static int fimc_is_i2c_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int fimc_is_i2c_suspend(struct device *dev)
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+static int fimc_is_i2c_runtime_suspend(struct device *dev)
 {
 	struct fimc_is_i2c *isp_i2c = dev_get_drvdata(dev);
+
 	clk_disable_unprepare(isp_i2c->clock);
 	return 0;
 }
 
-static int fimc_is_i2c_resume(struct device *dev)
+static int fimc_is_i2c_runtime_resume(struct device *dev)
 {
 	struct fimc_is_i2c *isp_i2c = dev_get_drvdata(dev);
+
 	return clk_prepare_enable(isp_i2c->clock);
 }
+#endif
 
-static UNIVERSAL_DEV_PM_OPS(fimc_is_i2c_pm_ops, fimc_is_i2c_suspend,
-		     fimc_is_i2c_resume, NULL);
+#ifdef CONFIG_PM_SLEEP
+static int fimc_is_i2c_suspend(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return fimc_is_i2c_runtime_suspend(dev);
+}
+
+static int fimc_is_i2c_resume(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return fimc_is_i2c_runtime_resume(dev);
+}
+#endif
+
+static struct dev_pm_ops fimc_is_i2c_pm_ops = {
+	SET_RUNTIME_PM_OPS(fimc_is_i2c_runtime_suspend,
+					fimc_is_i2c_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(fimc_is_i2c_suspend, fimc_is_i2c_resume)
+};
 
 static const struct of_device_id fimc_is_i2c_of_match[] = {
 	{ .compatible = FIMC_IS_I2C_COMPATIBLE },
-- 
1.7.9.5

