Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56796 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab2KWEvd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 23:51:33 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so6266460pbc.19
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 20:51:33 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH 3/4] [media] exynos-gsc: Use devm_clk_get()
Date: Fri, 23 Nov 2012 10:15:01 +0530
Message-Id: <1353645902-7467-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353645902-7467-1-git-send-email-sachin.kamat@linaro.org>
References: <1353645902-7467-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_clk_get() is a device managed function and makes error handling
a bit simpler.

Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 99ee1a9..b89afec 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1006,8 +1006,6 @@ static void gsc_clk_put(struct gsc_dev *gsc)
 		return;
 
 	clk_unprepare(gsc->clock);
-	clk_put(gsc->clock);
-	gsc->clock = NULL;
 }
 
 static int gsc_clk_get(struct gsc_dev *gsc)
@@ -1016,7 +1014,7 @@ static int gsc_clk_get(struct gsc_dev *gsc)
 
 	dev_dbg(&gsc->pdev->dev, "gsc_clk_get Called\n");
 
-	gsc->clock = clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
+	gsc->clock = devm_clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
 	if (IS_ERR(gsc->clock)) {
 		dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
 			GSC_CLOCK_GATE_NAME);
@@ -1027,8 +1025,6 @@ static int gsc_clk_get(struct gsc_dev *gsc)
 	if (ret < 0) {
 		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
 			GSC_CLOCK_GATE_NAME);
-		clk_put(gsc->clock);
-		gsc->clock = NULL;
 		goto err;
 	}
 
-- 
1.7.4.1

