Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:30698 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab3GWSl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 14:41:27 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 3/6] exynos4-is: Simplify sclk_cam clocks handling
Date: Tue, 23 Jul 2013 20:39:34 +0200
Message-id: <1374604777-15523-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
References: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use clk_prepare_enable()/clk_disable_unprepare() instead of
separately prearing/unparing the clk_cam clocks. This simplifies
the code that is now mostly not going to be used, function
__fimc_md_set_camclk() is only left for S5PV210 platform which
is not yet converted to Device Tree.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 91f21e2..41366fe 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1150,7 +1150,6 @@ static void fimc_md_put_clocks(struct fimc_md *fmd)
 	while (--i >= 0) {
 		if (IS_ERR(fmd->camclk[i].clock))
 			continue;
-		clk_unprepare(fmd->camclk[i].clock);
 		clk_put(fmd->camclk[i].clock);
 		fmd->camclk[i].clock = ERR_PTR(-EINVAL);
 	}
@@ -1169,7 +1168,7 @@ static int fimc_md_get_clocks(struct fimc_md *fmd)
 	struct device *dev = NULL;
 	char clk_name[32];
 	struct clk *clock;
-	int ret, i;
+	int i, ret = 0;
 
 	for (i = 0; i < FIMC_MAX_CAMCLKS; i++)
 		fmd->camclk[i].clock = ERR_PTR(-EINVAL);
@@ -1187,12 +1186,6 @@ static int fimc_md_get_clocks(struct fimc_md *fmd)
 			ret = PTR_ERR(clock);
 			break;
 		}
-		ret = clk_prepare(clock);
-		if (ret < 0) {
-			clk_put(clock);
-			fmd->camclk[i].clock = ERR_PTR(-EINVAL);
-			break;
-		}
 		fmd->camclk[i].clock = clock;
 	}
 	if (ret)
@@ -1249,7 +1242,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 			ret = pm_runtime_get_sync(fmd->pmf);
 			if (ret < 0)
 				return ret;
-			ret = clk_enable(camclk->clock);
+			ret = clk_prepare_enable(camclk->clock);
 			dbg("Enabled camclk %d: f: %lu", si->clk_id,
 			    clk_get_rate(camclk->clock));
 		}
@@ -1260,7 +1253,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 		return 0;
 
 	if (--camclk->use_count == 0) {
-		clk_disable(camclk->clock);
+		clk_disable_unprepare(camclk->clock);
 		pm_runtime_put(fmd->pmf);
 		dbg("Disabled camclk %d", si->clk_id);
 	}
-- 
1.7.9.5

