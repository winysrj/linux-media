Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:41417 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab3EaMlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 08:41:05 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNN000KAXW8JPU0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 21:41:04 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/3] exynos4-is: Ensure fimc-is clocks are not enabled until
 properly configured
Date: Fri, 31 May 2013 14:40:36 +0200
Message-id: <1370004037-18314-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370004037-18314-1-git-send-email-s.nawrocki@samsung.com>
References: <1370004037-18314-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use clk_prepare_enable/clk_unprepare_disable instead of preparing the
clocks during the driver initalization and then using just clk_disable/
clk_enable. The clock framework doesn't guarantee a clock will not get
enabled during e.g. clk_set_parent if clk_prepare has been called on it.
So we ensure clk_prepare() is called only when it is safe to enable
the clocks, i.e. the parent clocks and the clocks' frequencies are set.

It must be ensured the FIMC-IS clocks have proper frequencies before they
are enabled, otherwise the whole system will hang.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyunmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 140c58f..520e439 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -70,7 +70,6 @@ static void fimc_is_put_clocks(struct fimc_is *is)
 	for (i = 0; i < ISS_CLKS_MAX; i++) {
 		if (IS_ERR(is->clocks[i]))
 			continue;
-		clk_unprepare(is->clocks[i]);
 		clk_put(is->clocks[i]);
 		is->clocks[i] = ERR_PTR(-EINVAL);
 	}
@@ -89,12 +88,6 @@ static int fimc_is_get_clocks(struct fimc_is *is)
 			ret = PTR_ERR(is->clocks[i]);
 			goto err;
 		}
-		ret = clk_prepare(is->clocks[i]);
-		if (ret < 0) {
-			clk_put(is->clocks[i]);
-			is->clocks[i] = ERR_PTR(-EINVAL);
-			goto err;
-		}
 	}
 
 	return 0;
@@ -102,7 +95,7 @@ err:
 	fimc_is_put_clocks(is);
 	dev_err(&is->pdev->dev, "failed to get clock: %s\n",
 		fimc_is_clocks[i]);
-	return -ENXIO;
+	return ret;
 }
 
 static int fimc_is_setup_clocks(struct fimc_is *is)
@@ -143,7 +136,7 @@ int fimc_is_enable_clocks(struct fimc_is *is)
 	for (i = 0; i < ISS_GATE_CLKS_MAX; i++) {
 		if (IS_ERR(is->clocks[i]))
 			continue;
-		ret = clk_enable(is->clocks[i]);
+		ret = clk_prepare_enable(is->clocks[i]);
 		if (ret < 0) {
 			dev_err(&is->pdev->dev, "clock %s enable failed\n",
 				fimc_is_clocks[i]);
@@ -162,7 +155,7 @@ void fimc_is_disable_clocks(struct fimc_is *is)
 
 	for (i = 0; i < ISS_GATE_CLKS_MAX; i++) {
 		if (!IS_ERR(is->clocks[i])) {
-			clk_disable(is->clocks[i]);
+			clk_disable_unprepare(is->clocks[i]);
 			pr_debug("disabled clock: %s\n", fimc_is_clocks[i]);
 		}
 	}
-- 
1.7.9.5

