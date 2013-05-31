Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:16700 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab3EaOlK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 10:41:10 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO007F83GLUYP0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 23:41:09 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hj210.choi@samsung.com,
	arun.kk@samsung.com, shaik.ameer@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH v2 07/11] exynos4-is: Remove WARN_ON() from
 __fimc_pipeline_close()
Date: Fri, 31 May 2013 16:37:23 +0200
Message-id: <1370011047-11488-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
References: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
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
index e95a6d5..973f8a9 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -220,16 +220,16 @@ static int __fimc_pipeline_close(struct exynos_media_pipeline *ep)
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

