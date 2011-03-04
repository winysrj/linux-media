Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52486 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283Ab1CDJB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 04:01:29 -0500
Date: Fri, 04 Mar 2011 10:01:12 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5/7] s5p-fimc: add pm_runtime support
In-reply-to: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, andrzej.p@samsung.com,
	t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Message-id: <1299229274-9753-6-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds basic support for pm_runtime to s5p-fimc driver. PM
runtime support is required to enable the driver on S5PV310 series with
power domain driver enabled.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    5 +++++
 drivers/media/video/s5p-fimc/fimc-core.c    |   14 ++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 59123a6..f8d7de5 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
@@ -395,6 +396,8 @@ static int fimc_capture_open(struct file *file)
 	if (fimc_m2m_active(fimc))
 		return -EBUSY;
 
+	pm_runtime_get_sync(&fimc->pdev->dev);
+
 	if (++fimc->vid_cap.refcnt == 1) {
 		ret = fimc_isp_subdev_init(fimc, 0);
 		if (ret) {
@@ -425,6 +428,8 @@ static int fimc_capture_close(struct file *file)
 		fimc_subdev_unregister(fimc);
 	}
 
+	pm_runtime_put_sync(&fimc->pdev->dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index db3e730..c92dbdb 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/slab.h>
@@ -1407,6 +1408,8 @@ static int fimc_m2m_open(struct file *file)
 	if (fimc->vid_cap.refcnt > 0)
 		return -EBUSY;
 
+	pm_runtime_get_sync(&fimc->pdev->dev);
+
 	fimc->m2m.refcnt++;
 	set_bit(ST_OUTDMA_RUN, &fimc->state);
 
@@ -1449,6 +1452,8 @@ static int fimc_m2m_release(struct file *file)
 	if (--fimc->m2m.refcnt <= 0)
 		clear_bit(ST_OUTDMA_RUN, &fimc->state);
 
+	pm_runtime_put_sync(&fimc->pdev->dev);
+
 	return 0;
 }
 
@@ -1646,6 +1651,11 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_req_region;
 	}
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
+	pm_runtime_get_sync(&pdev->dev);
+
 	fimc->num_clocks = MAX_FIMC_CLOCKS - 1;
 
 	/* Check if a video capture node needs to be registered. */
@@ -1703,6 +1713,8 @@ static int fimc_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "%s(): fimc-%d registered successfully\n",
 		__func__, fimc->id);
 
+	pm_runtime_put_sync(&pdev->dev);
+
 	return 0;
 
 err_m2m:
@@ -1737,6 +1749,8 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 
+	pm_runtime_disable(&pdev->dev);
+
 	iounmap(fimc->regs);
 	release_resource(fimc->regs_res);
 	kfree(fimc->regs_res);
-- 
1.7.1.569.g6f426
