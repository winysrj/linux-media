Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10732 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753358AbcKIOYN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:13 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 03/12] exynos-gsc: Make driver functional when CONFIG_PM is
 unset
Date: Wed, 09 Nov 2016 15:23:52 +0100
Message-id: <1478701441-29107-4-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142408eucas1p1401c6b61321b52ea341a28ad063f4653@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ulf Hansson <ulf.hansson@linaro.org>

The driver depended on CONFIG_PM to be functional. Let's remove that
dependency, by enable the runtime PM resourses during ->probe() and
update the device's runtime PM status to reflect this.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[mszyprow: rebased onto v4.9-rc4]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index cb4e8bd..b5a99af 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1072,7 +1072,7 @@ static int gsc_probe(struct platform_device *pdev)
 		return PTR_ERR(gsc->clock);
 	}
 
-	ret = clk_prepare(gsc->clock);
+	ret = clk_prepare_enable(gsc->clock);
 	if (ret) {
 		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
 			GSC_CLOCK_GATE_NAME);
@@ -1095,24 +1095,23 @@ static int gsc_probe(struct platform_device *pdev)
 		goto err_v4l2;
 
 	platform_set_drvdata(pdev, gsc);
-	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
-		goto err_m2m;
+
+	gsc_hw_set_sw_reset(gsc);
+	gsc_wait_reset(gsc);
 
 	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 
 	dev_dbg(dev, "gsc-%d registered successfully\n", gsc->id);
 
-	pm_runtime_put(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	return 0;
 
-err_m2m:
-	gsc_unregister_m2m_device(gsc);
 err_v4l2:
 	v4l2_device_unregister(&gsc->v4l2_dev);
 err_clk:
-	clk_unprepare(gsc->clock);
+	clk_disable_unprepare(gsc->clock);
 	return ret;
 }
 
-- 
1.9.1

