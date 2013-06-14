Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42105 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3FNSGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 14:06:54 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Drop drvdata handling in fimc-lite for non-dt
 platforms
Date: Fri, 14 Jun 2013 20:05:31 +0200
Message-id: <1371233131-4294-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FIMC-LITE IP block is available only on platforms instantiated
from device tree.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |    3 ---
 drivers/media/platform/exynos4-is/fimc-lite.h |    3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 3f76f8a..00c525c 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1449,9 +1449,6 @@ static int fimc_lite_probe(struct platform_device *pdev)
 		if (of_id)
 			drv_data = (struct flite_drvdata *)of_id->data;
 		fimc->index = of_alias_get_id(dev->of_node, "fimc-lite");
-	} else {
-		drv_data = fimc_lite_get_drvdata(pdev);
-		fimc->index = pdev->id;
 	}
 
 	if (!drv_data || fimc->index < 0 || fimc->index >= FIMC_LITE_MAX_DEVS)
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index c7aa084..4b10684 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -56,9 +56,6 @@ struct flite_drvdata {
 	unsigned short out_hor_offs_align;
 };
 
-#define fimc_lite_get_drvdata(_pdev) \
-	((struct flite_drvdata *) platform_get_device_id(_pdev)->driver_data)
-
 struct fimc_lite_events {
 	unsigned int data_overflow;
 };
-- 
1.7.9.5

