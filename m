Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:28792 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaAPOtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 09:49:50 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZI00D501702050@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Jan 2014 23:49:48 +0900 (KST)
Content-transfer-encoding: 8BIT
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: fimc-lite: compile runtime PM callbacks in
 conditionally
Date: Thu, 16 Jan 2014 15:49:28 +0100
Message-id: <1389883768-7775-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enclose the runtime PM helpers in #ifdef CONFIG_PM_RUNTIME/#endif
to avoid following compile warning when CONFIG_PM_RUNTIME is disabled:

CC      drivers/media/platform/exynos4-is/fimc-lite.o
drivers/media/platform/exynos4-is/fimc-lite.c:1591:12: warning: ‘fimc_lite_runtime_resume’ defined but not used [-Wunused-function]
drivers/media/platform/exynos4-is/fimc-lite.c:1599:12: warning: ‘fimc_lite_runtime_suspend’ defined but not used [-Wunused-function]

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 5213ff0..779ec3c 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1588,6 +1588,7 @@ err_clk_put:
 	return ret;
 }
 
+#ifdef CONFIG_PM_RUNTIME
 static int fimc_lite_runtime_resume(struct device *dev)
 {
 	struct fimc_lite *fimc = dev_get_drvdata(dev);
@@ -1603,6 +1604,7 @@ static int fimc_lite_runtime_suspend(struct device *dev)
 	clk_disable(fimc->clock);
 	return 0;
 }
+#endif
 
 #ifdef CONFIG_PM_SLEEP
 static int fimc_lite_resume(struct device *dev)
-- 
1.7.9.5

