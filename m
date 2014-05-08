Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:46529 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbaEHRgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 13:36:01 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH V2 1/4] exynos4-is: Free FIMC-IS CPU memory only when allocated
Date: Thu, 08 May 2014 19:35:15 +0200
Message-id: <1399570516-29782-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure dma_free_coherent() is not called with incorrect arguments
and only when the memory was actually allocated. This will prevent
possible crashes on error paths of the top level media device driver,
when fimc-is device gets unregistered and its driver detached.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 128b73b..5476dce 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -367,6 +367,9 @@ static void fimc_is_free_cpu_memory(struct fimc_is *is)
 {
 	struct device *dev = &is->pdev->dev;
 
+	if (is->memory.vaddr == NULL)
+		return;
+
 	dma_free_coherent(dev, is->memory.size, is->memory.vaddr,
 			  is->memory.paddr);
 }
-- 
1.7.9.5

