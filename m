Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56767 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1DEOJF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 10:09:05 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 05 Apr 2011 16:06:48 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5/7] v4l: s5p-fimc: add pm_runtime support
In-reply-to: <1302012410-17984-1-git-send-email-m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Pietrasiwiecz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Kukjin Kim <kgene.kim@samsung.com>
Message-id: <1302012410-17984-6-git-send-email-m.szyprowski@samsung.com>
References: <1302012410-17984-1-git-send-email-m.szyprowski@samsung.com>
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
index 95f8b4e1..f697ed1 100644
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
@@ -398,6 +399,8 @@ static int fimc_capture_open(struct file *file)
 	if (fimc_m2m_active(fimc))
 		return -EBUSY;
 
+	pm_runtime_get_sync(&fimc->pdev->dev);
+
 	if (++fimc->vid_cap.refcnt == 1) {
 		ret = fimc_isp_subdev_init(fimc, 0);
 		if (ret) {
@@ -428,6 +431,8 @@ static int fimc_capture_close(struct file *file)
 		fimc_subdev_unregister(fimc);
 	}
 
+	pm_runtime_put_sync(&fimc->pdev->dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 6c919b3..ead5c0a 100644
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
@@ -1410,6 +1411,8 @@ static int fimc_m2m_open(struct file *file)
 	if (fimc->vid_cap.refcnt > 0)
 		return -EBUSY;
 
+	pm_runtime_get_sync(&fimc->pdev->dev);
+
 	fimc->m2m.refcnt++;
 	set_bit(ST_OUTDMA_RUN, &fimc->state);
 
@@ -1452,6 +1455,8 @@ static int fimc_m2m_release(struct file *file)
 	if (--fimc->m2m.refcnt <= 0)
 		clear_bit(ST_OUTDMA_RUN, &fimc->state);
 
+	pm_runtime_put_sync(&fimc->pdev->dev);
+
 	return 0;
 }
 
@@ -1649,6 +1654,11 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_req_region;
 	}
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
+	pm_runtime_get_sync(&pdev->dev);
+
 	fimc->num_clocks = MAX_FIMC_CLOCKS - 1;
 
 	/* Check if a video capture node needs to be registered. */
@@ -1706,6 +1716,8 @@ static int fimc_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "%s(): fimc-%d registered successfully\n",
 		__func__, fimc->id);
 
+	pm_runtime_put_sync(&pdev->dev);
+
 	return 0;
 
 err_m2m:
@@ -1740,6 +1752,8 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 
+	pm_runtime_disable(&pdev->dev);
+
 	iounmap(fimc->regs);
 	release_resource(fimc->regs_res);
 	kfree(fimc->regs_res);
-- 
1.7.1.569.g6f426
