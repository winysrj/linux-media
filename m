Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:62470 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbaJNHQB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 03:16:01 -0400
Received: by mail-la0-f54.google.com with SMTP id gm9so7752529lab.41
        for <linux-media@vger.kernel.org>; Tue, 14 Oct 2014 00:15:59 -0700 (PDT)
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
Subject: [PATCH 3/7] [media] exynos-gsc: Make driver functional without CONFIG_PM_RUNTIME
Date: Tue, 14 Oct 2014 09:15:36 +0200
Message-Id: <1413270940-4378-4-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
References: <1413270940-4378-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver depended on CONFIG_PM_RUNTIME to be functional, which isn't
necessary.

The solution to the above is to enable all runtime PM resourses during
probe and update the device's runtime PM status to active.

Since driver core invokes pm_request_idle() after ->probe(), unused gsc
devices will be runtime PM suspended and thus we will still benefit
from using CONFIG_PM_RUNTIME.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 13d0226..c3a050e 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1085,7 +1085,7 @@ static int gsc_probe(struct platform_device *pdev)
 		return PTR_ERR(gsc->clock);
 	}
 
-	ret = clk_prepare(gsc->clock);
+	ret = clk_prepare_enable(gsc->clock);
 	if (ret) {
 		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
 			GSC_CLOCK_GATE_NAME);
@@ -1108,30 +1108,30 @@ static int gsc_probe(struct platform_device *pdev)
 		goto err_v4l2;
 
 	platform_set_drvdata(pdev, gsc);
-	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
-		goto err_m2m;
+
+	gsc_hw_set_sw_reset(gsc);
+	gsc_wait_reset(gsc);
+	gsc_m2m_resume(gsc);
 
 	/* Initialize continious memory allocator */
 	gsc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(gsc->alloc_ctx)) {
 		ret = PTR_ERR(gsc->alloc_ctx);
-		goto err_pm;
+		goto err_m2m;
 	}
 
 	dev_dbg(dev, "gsc-%d registered successfully\n", gsc->id);
 
-	pm_runtime_put(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	return 0;
-err_pm:
-	pm_runtime_put(dev);
 err_m2m:
 	gsc_unregister_m2m_device(gsc);
 err_v4l2:
 	v4l2_device_unregister(&gsc->v4l2_dev);
 err_clk:
-	clk_unprepare(gsc->clock);
+	clk_disable_unprepare(gsc->clock);
 	return ret;
 }
 
-- 
1.9.1

