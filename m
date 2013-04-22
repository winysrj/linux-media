Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63101 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3DVOGs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:06:48 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN00CO9TUILVJ0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:06:47 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 09/12] exynos4-is: Remove redundant module_put() for MIPI-CSIS
 module
Date: Mon, 22 Apr 2013 16:03:44 +0200
Message-id: <1366639427-14253-10-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently there is unbalanced module_put() on the s5p-csis module
which prevents it from being unloaded. The subdev's owner module
has reference count decremented in v4l2_device_unregister_subdev()
so just remove this erroneous call.

Cc: stable@vger.kernel.org # 3.8
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index a371ee5..15ef8f2 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -814,7 +814,6 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 		if (fmd->csis[i].sd == NULL)
 			continue;
 		v4l2_device_unregister_subdev(fmd->csis[i].sd);
-		module_put(fmd->csis[i].sd->owner);
 		fmd->csis[i].sd = NULL;
 	}
 	for (i = 0; i < fmd->num_sensors; i++) {
-- 
1.7.9.5

