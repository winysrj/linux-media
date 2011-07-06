Return-path: <mchehab@localhost>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56033 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1GFRNs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 13:13:48 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNX00ASW96ZB6@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 18:13:47 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNX00L1V96X26@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 18:13:45 +0100 (BST)
Date: Wed, 06 Jul 2011 19:13:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/3] s5p-csis: Rework of the system suspend/resume helpers
In-reply-to: <1309972421-29690-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1309972421-29690-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309972421-29690-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Do not resume the device during system resume if it was idle
before system suspend, as this causes resume from suspend
to RAM failures on exynos4. For this purpose runtime PM and
system sleep helpers are separated.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/mipi-csis.c |   45 ++++++++++++++++--------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index 4a529b4..5b38be7 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -561,7 +561,6 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	/* .. and a pointer to the subdev. */
 	platform_set_drvdata(pdev, &state->sd);
 
-	state->flags = ST_SUSPENDED;
 	pm_runtime_enable(&pdev->dev);
 
 	return 0;
@@ -582,7 +581,7 @@ e_free:
 	return ret;
 }
 
-static int s5pcsis_suspend(struct device *dev)
+static int s5pcsis_pm_suspend(struct device *dev, bool runtime)
 {
 	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
 	struct platform_device *pdev = to_platform_device(dev);
@@ -607,14 +606,15 @@ static int s5pcsis_suspend(struct device *dev)
 		}
 		clk_disable(state->clock[CSIS_CLK_GATE]);
 		state->flags &= ~ST_POWERED;
+		if (!runtime)
+			state->flags |= ST_SUSPENDED;
 	}
-	state->flags |= ST_SUSPENDED;
  unlock:
 	mutex_unlock(&state->lock);
 	return ret ? -EAGAIN : 0;
 }
 
-static int s5pcsis_resume(struct device *dev)
+static int s5pcsis_pm_resume(struct device *dev, bool runtime)
 {
 	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
 	struct platform_device *pdev = to_platform_device(dev);
@@ -626,7 +626,7 @@ static int s5pcsis_resume(struct device *dev)
 		 __func__, state->flags);
 
 	mutex_lock(&state->lock);
-	if (!(state->flags & ST_SUSPENDED))
+	if (!runtime && !(state->flags & ST_SUSPENDED))
 		goto unlock;
 
 	if (!(state->flags & ST_POWERED)) {
@@ -647,32 +647,34 @@ static int s5pcsis_resume(struct device *dev)
 	}
 	if (state->flags & ST_STREAMING)
 		s5pcsis_start_stream(state);
-
-	state->flags &= ~ST_SUSPENDED;
+	if (!runtime)
+		state->flags &= ~ST_SUSPENDED;
  unlock:
 	mutex_unlock(&state->lock);
 	return ret ? -EAGAIN : 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int s5pcsis_pm_suspend(struct device *dev)
+static int s5pcsis_suspend(struct device *dev)
 {
-	return s5pcsis_suspend(dev);
+	return s5pcsis_pm_suspend(dev, false);
 }
 
-static int s5pcsis_pm_resume(struct device *dev)
+static int s5pcsis_resume(struct device *dev)
 {
-	int ret;
-
-	ret = s5pcsis_resume(dev);
+	return s5pcsis_pm_resume(dev, false);
+}
+#endif
 
-	if (!ret) {
-		pm_runtime_disable(dev);
-		ret = pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
-	}
+#ifdef CONFIG_PM_RUNTIME
+static int s5pcsis_runtime_suspend(struct device *dev)
+{
+	return s5pcsis_pm_suspend(dev, true);
+}
 
-	return ret;
+static int s5pcsis_runtime_resume(struct device *dev)
+{
+	return s5pcsis_pm_resume(dev, true);
 }
 #endif
 
@@ -700,8 +702,9 @@ static int __devexit s5pcsis_remove(struct platform_device *pdev)
 }
 
 static const struct dev_pm_ops s5pcsis_pm_ops = {
-	SET_RUNTIME_PM_OPS(s5pcsis_suspend, s5pcsis_resume, NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(s5pcsis_pm_suspend, s5pcsis_pm_resume)
+	SET_RUNTIME_PM_OPS(s5pcsis_runtime_suspend, s5pcsis_runtime_resume,
+			   NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(s5pcsis_suspend, s5pcsis_resume)
 };
 
 static struct platform_driver s5pcsis_driver = {
-- 
1.7.5.4

