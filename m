Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:52021 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbbASNaC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 08:30:02 -0500
Received: by mail-la0-f42.google.com with SMTP id ms9so6552511lab.1
        for <linux-media@vger.kernel.org>; Mon, 19 Jan 2015 05:30:01 -0800 (PST)
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH V2 3/8] [media] exynos-gsc: Make driver functional when CONFIG_PM is unset
Date: Mon, 19 Jan 2015 14:22:35 +0100
Message-Id: <1421673760-2600-4-git-send-email-ulf.hansson@linaro.org>
In-Reply-To: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
References: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver depended on CONFIG_PM to be functional. Let's remove that
dependency, by enable the runtime PM resourses during ->probe() and
update the device's runtime PM status to reflect this.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 1865738..532daa8 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1088,7 +1088,7 @@ static int gsc_probe(struct platform_device *pdev)
 		return PTR_ERR(gsc->clock);
 	}
 
-	ret = clk_prepare(gsc->clock);
+	ret = clk_prepare_enable(gsc->clock);
 	if (ret) {
 		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
 			GSC_CLOCK_GATE_NAME);
@@ -1111,30 +1111,29 @@ static int gsc_probe(struct platform_device *pdev)
 		goto err_v4l2;
 
 	platform_set_drvdata(pdev, gsc);
-	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
-		goto err_m2m;
+
+	gsc_hw_set_sw_reset(gsc);
+	gsc_wait_reset(gsc);
 
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

