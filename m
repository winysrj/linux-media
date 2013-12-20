Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:42435 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab3LTWYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 17:24:22 -0500
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/6] exynos4-is: Correct clean up sequence on error path in fimc_is_probe()
Date: Fri, 20 Dec 2013 23:23:25 +0100
Message-Id: <1387578207-17625-5-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
References: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The memory allocator is being initialized before registering the subdevs
so reverse the cleanup sequence to avoid trying unregister not registered
subdevs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 9770fa9..8cb70c2 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -867,10 +867,10 @@ static int fimc_is_probe(struct platform_device *pdev)
 
 err_dfs:
 	fimc_is_debugfs_remove(is);
-err_vb:
-	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
 err_sd:
 	fimc_is_unregister_subdevs(is);
+err_vb:
+	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
 err_irq:
 	free_irq(is->irq, is);
 err_clk:
-- 
1.7.4.1

