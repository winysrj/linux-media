Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34503 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaDOROn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 13:14:43 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Fix compilation for !CONFIG_COMMON_CLK
Date: Tue, 15 Apr 2014 19:14:29 +0200
Message-id: <1397582069-27941-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_COMMON_CLK is not enabled on S5PV210 platform, so include
some clk API data structures conditionally to avoid compilation
errors. These #ifdefs will be removed for next kernel release,
when the S5PV210 platform moves to DT and the common clk API.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c |    2 +-
 drivers/media/platform/exynos4-is/media-dev.h |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 2a2d42e..002abbf 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1523,7 +1523,7 @@ err:
 }
 #else
 #define fimc_md_register_clk_provider(fmd) (0)
-#define fimc_md_unregister_clk_provider(fmd) (0)
+#define fimc_md_unregister_clk_provider(fmd)
 #endif
 
 static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index ee1e251..58c4945 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -94,7 +94,9 @@ struct fimc_sensor_info {
 };
 
 struct cam_clk {
+#ifdef CONFIG_COMMON_CLK
 	struct clk_hw hw;
+#endif
 	struct fimc_md *fmd;
 };
 #define to_cam_clk(_hw) container_of(_hw, struct cam_clk, hw)
@@ -142,7 +144,9 @@ struct fimc_md {
 
 	struct cam_clk_provider {
 		struct clk *clks[FIMC_MAX_CAMCLKS];
+#ifdef CONFIG_COMMON_CLK
 		struct clk_onecell_data clk_data;
+#endif
 		struct device_node *of_node;
 		struct cam_clk camclk[FIMC_MAX_CAMCLKS];
 		int num_clocks;
-- 
1.7.9.5

