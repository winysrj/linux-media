Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:62555 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaAGWI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 17:08:57 -0500
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Compile runtime PM callbacks in conditionally
Date: Tue,  7 Jan 2014 23:08:48 +0100
Message-Id: <1389132528-21281-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enclose the runtime PM helpers in #ifdef CONFIG_PM_RUNTIME/#endif
to avoid following compile warning when CONFIG_PM_RUNTIME is disabled:

 CC      drivers/media/platform/exynos4-is/fimc-core.o
drivers/media/platform/exynos4-is/fimc-core.c:1040:12: warning: ‘fimc_runtime_resume’ defined but not used
drivers/media/platform/exynos4-is/fimc-core.c:1057:12: warning: ‘fimc_runtime_suspend’ defined but not used

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index dcbea59..da2fc86 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1037,6 +1037,7 @@ err_sclk:
 	return ret;
 }

+#ifdef CONFIG_PM_RUNTIME
 static int fimc_runtime_resume(struct device *dev)
 {
 	struct fimc_dev *fimc =	dev_get_drvdata(dev);
@@ -1069,6 +1070,7 @@ static int fimc_runtime_suspend(struct device *dev)
 	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
 	return ret;
 }
+#endif

 #ifdef CONFIG_PM_SLEEP
 static int fimc_resume(struct device *dev)
--
1.7.4.1

