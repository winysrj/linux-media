Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:14233 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaGUE5r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 00:57:47 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N91001BBPS91TA0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jul 2014 13:57:45 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, pawel@osciak.com, shaik.samsung@gmail.com,
	joshi@samsung.com, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH] [media] exynos-gsc: Remove PM_RUNTIME dependency
Date: Mon, 21 Jul 2014 10:24:48 +0530
Message-id: <1405918488-26142-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1] Currently Gscaler clock is enabled only inside pm_runtime callbacks.
   If PM_RUNTIME is disabled, driver hangs. This patch removes the
   PM_RUNTIME dependency by keeping the clock enable/disable functions
   in m2m start/stop streaming callbacks.

2] For Exynos5420/5800, Gscaler clock has to be Turned ON before powering
   on/off the Gscaler power domain. This dependency is taken care by
   this patch at driver level.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |   10 ++--------
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |   13 +++++++++++++
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 9d0cc04..39c0953 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1132,23 +1132,17 @@ static int gsc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, gsc);
 	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
-		goto err_m2m;
 
 	/* Initialize continious memory allocator */
 	gsc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(gsc->alloc_ctx)) {
 		ret = PTR_ERR(gsc->alloc_ctx);
-		goto err_pm;
+		goto err_m2m;
 	}
 
 	dev_dbg(dev, "gsc-%d registered successfully\n", gsc->id);
-
-	pm_runtime_put(dev);
 	return 0;
-err_pm:
-	pm_runtime_put(dev);
+
 err_m2m:
 	gsc_unregister_m2m_device(gsc);
 err_v4l2:
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index e434f1f0..a98462c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -60,19 +60,32 @@ static void __gsc_m2m_job_abort(struct gsc_ctx *ctx)
 static int gsc_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct gsc_ctx *ctx = q->drv_priv;
+	struct gsc_dev *gsc = ctx->gsc_dev;
 	int ret;
 
+	ret = clk_enable(gsc->clock);
+	if (ret)
+		return ret;
+
 	ret = pm_runtime_get_sync(&ctx->gsc_dev->pdev->dev);
+
+	if (!pm_runtime_enabled(&gsc->pdev->dev)) {
+		gsc_hw_set_sw_reset(gsc);
+		gsc_wait_reset(gsc);
+	}
+
 	return ret > 0 ? 0 : ret;
 }
 
 static void gsc_m2m_stop_streaming(struct vb2_queue *q)
 {
 	struct gsc_ctx *ctx = q->drv_priv;
+	struct gsc_dev *gsc = ctx->gsc_dev;
 
 	__gsc_m2m_job_abort(ctx);
 
 	pm_runtime_put(&ctx->gsc_dev->pdev->dev);
+	clk_disable(gsc->clock);
 }
 
 void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
-- 
1.7.9.5

