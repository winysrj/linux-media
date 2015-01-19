Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:61782 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbbASNXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 08:23:11 -0500
Received: by mail-la0-f51.google.com with SMTP id ge10so7748244lab.10
        for <linux-media@vger.kernel.org>; Mon, 19 Jan 2015 05:23:10 -0800 (PST)
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH V2 7/8] [media] exynos-gsc: Make system PM callbacks available for CONFIG_PM_SLEEP
Date: Mon, 19 Jan 2015 14:22:39 +0100
Message-Id: <1421673760-2600-8-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
References: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are no need to set up the system PM callbacks unless they are
being used. It also causes compiler warnings about unused functions.

Silence the warnings by making them available for CONFIG_PM_SLEEP.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 0b126eb..194f9fc 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1188,6 +1188,7 @@ static int gsc_runtime_suspend(struct device *dev)
 }
 #endif
 
+#ifdef CONFIG_PM_SLEEP
 static int gsc_resume(struct device *dev)
 {
 	struct gsc_dev *gsc = dev_get_drvdata(dev);
@@ -1224,10 +1225,10 @@ static int gsc_suspend(struct device *dev)
 
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

