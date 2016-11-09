Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10732 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752968AbcKIOYO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:14 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 05/12] exynos-gsc: Fixup clock management at ->remove()
Date: Wed, 09 Nov 2016 15:23:54 +0100
Message-id: <1478701441-29107-6-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142409eucas1p1984158008caee2ed6645bfa3666e8900@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ulf Hansson <ulf.hansson@linaro.org>

To make sure the clock is fully gated in ->remove(), we first need to
to bring the device into full power by invoking pm_runtime_get_sync().

Then, let's both unprepare and disable the clock.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[mszyprow: rebased onto v4.9-rc4]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 7e99fda..1d3bde3 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1082,12 +1082,15 @@ static int gsc_remove(struct platform_device *pdev)
 {
 	struct gsc_dev *gsc = platform_get_drvdata(pdev);
 
+	pm_runtime_get_sync(&pdev->dev);
+
 	gsc_unregister_m2m_device(gsc);
 	v4l2_device_unregister(&gsc->v4l2_dev);
 
 	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-	clk_unprepare(gsc->clock);
+	clk_disable_unprepare(gsc->clock);
+
+	pm_runtime_put_noidle(&pdev->dev);
 
 	dev_dbg(&pdev->dev, "%s driver unloaded\n", pdev->name);
 	return 0;
-- 
1.9.1

