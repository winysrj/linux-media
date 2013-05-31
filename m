Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:23546 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3EaQrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 12:47:43 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO007279BEUYR0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Jun 2013 01:47:42 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, yhwan.joo@samsung.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 1/7] exynos4-is: Remove leftovers of non-dt FIMC-LITE
 support
Date: Fri, 31 May 2013 18:46:59 +0200
Message-id: <1370018825-13088-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
References: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIMC-LITE devices are never looked up by iterating over all platform
devices with bus_for_each_device() as these IP blocks are available
only on dt-only Exynos SoC platforms.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index f8ada95..af49e0f 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -804,8 +804,6 @@ static int fimc_md_pdev_match(struct device *dev, void *data)
 
 	if (!strcmp(pdev->name, CSIS_DRIVER_NAME)) {
 		plat_entity = IDX_CSIS;
-	} else if (!strcmp(pdev->name, FIMC_LITE_DRV_NAME)) {
-		plat_entity = IDX_FLITE;
 	} else {
 		p = strstr(pdev->name, "fimc");
 		if (p && *(p + 4) == 0)
-- 
1.7.9.5

