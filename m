Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55809 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1KDOUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 10:20:10 -0400
Date: Fri, 04 Nov 2011 15:19:57 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/8] s5p-fimc: Fix initialization for proper system suspend
 support
In-reply-to: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320416402-22883-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ST_LPM bit must not be initially set, so the first resume helper
call properly quiesce the device's operation.
Also fimc_runtime_suspend() at device remove is unneeded and
leads to unbalanced clock disable so remove it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 19ca6db..ef53528 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1615,7 +1615,6 @@ static int fimc_probe(struct platform_device *pdev)
 	pdata = pdev->dev.platform_data;
 	fimc->pdata = pdata;
 
-	set_bit(ST_LPM, &fimc->state);
 
 	init_waitqueue_head(&fimc->irq_queue);
 	spin_lock_init(&fimc->slock);
@@ -1780,7 +1779,6 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	struct fimc_dev *fimc = platform_get_drvdata(pdev);
 
 	pm_runtime_disable(&pdev->dev);
-	fimc_runtime_suspend(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
-- 
1.7.7.1

