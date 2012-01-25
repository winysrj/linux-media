Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27152 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2AYP3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:29:07 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LYD001HU1OGFN70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Jan 2012 15:29:04 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYD00F9W1OGBO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Jan 2012 15:29:04 +0000 (GMT)
Date: Wed, 25 Jan 2012 16:28:58 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-fimc: Use correct API for register memory region release
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1327505338-2128-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the memory region is requested with request_mem_region use the proper 
paired method for releasing it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 81bcbb9..14d3755 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1764,8 +1764,8 @@ err_clk:
 err_regs_unmap:
 	iounmap(fimc->regs);
 err_req_region:
-	release_resource(fimc->regs_res);
-	kfree(fimc->regs_res);
+	release_mem_region(fimc->regs_res->start,
+			   resource_size(fimc->regs_res));
 err_info:
 	kfree(fimc);
 	return ret;
@@ -1856,8 +1856,8 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	fimc_clk_put(fimc);
 	free_irq(fimc->irq, fimc);
 	iounmap(fimc->regs);
-	release_resource(fimc->regs_res);
-	kfree(fimc->regs_res);
+	release_mem_region(fimc->regs_res->start,
+			   resource_size(fimc->regs_res));
 	kfree(fimc);
 
 	dev_info(&pdev->dev, "driver unloaded\n");
-- 
1.7.8.3

