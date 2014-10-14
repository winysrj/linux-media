Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35243 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaJNHQD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 03:16:03 -0400
Received: by mail-lb0-f174.google.com with SMTP id p9so7663712lbv.19
        for <linux-media@vger.kernel.org>; Tue, 14 Oct 2014 00:16:01 -0700 (PDT)
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
Subject: [PATCH 4/7] [media] exynos-gsc: Make runtime PM callbacks available for CONFIG_PM
Date: Tue, 14 Oct 2014 09:15:37 +0200
Message-Id: <1413270940-4378-5-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
References: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are no need to set up the runtime PM callbacks unless they are
being used. Let's make them available for CONFIG_PM.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index c3a050e..361a807 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1150,6 +1150,7 @@ static int gsc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static int gsc_runtime_resume(struct device *dev)
 {
 	struct gsc_dev *gsc = dev_get_drvdata(dev);
@@ -1180,6 +1181,7 @@ static int gsc_runtime_suspend(struct device *dev)
 	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
 	return ret;
 }
+#endif
 
 static int gsc_resume(struct device *dev)
 {
@@ -1221,8 +1223,7 @@ static int gsc_suspend(struct device *dev)
 static const struct dev_pm_ops gsc_pm_ops = {
 	.suspend		= gsc_suspend,
 	.resume			= gsc_resume,
-	.runtime_suspend	= gsc_runtime_suspend,
-	.runtime_resume		= gsc_runtime_resume,
+	SET_PM_RUNTIME_PM_OPS(gsc_runtime_suspend, gsc_runtime_resume, NULL)
 };
 
 static struct platform_driver gsc_driver = {
-- 
1.9.1

