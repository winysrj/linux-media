Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:23946 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3DVOHa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:07:30 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN00JMYTW396L0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:07:29 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 12/12] exynos4-is: Fix runtime PM handling on fimc-is probe
 error path
Date: Mon, 22 Apr 2013 16:03:47 +0200
Message-id: <1366639427-14253-13-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure there is no unbalanced pm_runtime_put().

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 5e89077..47c6363 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -847,16 +847,17 @@ static int fimc_is_probe(struct platform_device *pdev)
 		goto err_irq;
 
 	ret = fimc_is_setup_clocks(is);
+	pm_runtime_put_sync(dev);
+
 	if (ret < 0)
 		goto err_irq;
 
-	pm_runtime_put_sync(dev);
 	is->clk_init = true;
 
 	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(is->alloc_ctx)) {
 		ret = PTR_ERR(is->alloc_ctx);
-		goto err_pm;
+		goto err_irq;
 	}
 	/*
 	 * Register FIMC-IS V4L2 subdevs to this driver. The video nodes
@@ -885,8 +886,6 @@ err_sd:
 	fimc_is_unregister_subdevs(is);
 err_irq:
 	free_irq(is->irq, is);
-err_pm:
-	pm_runtime_put(dev);
 err_clk:
 	fimc_is_put_clocks(is);
 	return ret;
-- 
1.7.9.5

