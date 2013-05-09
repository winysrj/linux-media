Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:35684 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3EIPiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 11:38:03 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ005BMFF8JR20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 May 2013 00:38:02 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, dh09.lee@samsung.com, a.hajda@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 13/13] exynos4-is: Remove WARN_ON() from __fimc_pipeline_close()
Date: Thu, 09 May 2013 17:36:45 +0200
Message-id: <1368113805-20233-14-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
References: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's not a critical error to call __fimc_pipeline_close() with missing
sensor subdev entity. Replace WARN_ON() with pr_warn() and return 0
instead of -EINVAL to fix control flow in some conditions.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index bf932d7..beec27b 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -247,16 +247,16 @@ static int __fimc_pipeline_close(struct exynos_media_pipeline *ep)
 	struct fimc_pipeline *p = to_fimc_pipeline(ep);
 	struct v4l2_subdev *sd = p ? p->subdevs[IDX_SENSOR] : NULL;
 	struct fimc_md *fmd;
-	int ret = 0;
-
-	if (WARN_ON(sd == NULL))
-		return -EINVAL;
+	int ret;
 
-	if (p->subdevs[IDX_SENSOR]) {
-		ret = fimc_pipeline_s_power(p, 0);
-		fimc_md_set_camclk(sd, false);
+	if (sd == NULL) {
+		pr_warn("%s(): No sensor subdev\n", __func__);
+		return 0;
 	}
 
+	ret = fimc_pipeline_s_power(p, 0);
+	fimc_md_set_camclk(sd, false);
+
 	fmd = entity_to_fimc_mdev(&sd->entity);
 
 	/* Disable PXLASYNC clock if this pipeline includes FIMC-IS */
-- 
1.7.9.5

