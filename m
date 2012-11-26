Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56097 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2KZG1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 01:27:03 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7770073pbc.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 22:27:03 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: shaik.ameer@samsung.com, sylvester.nawrocki@gmail.com,
	s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v2 3/3] [media] exynos-gsc: Use devm_clk_get()
Date: Mon, 26 Nov 2012 11:50:21 +0530
Message-Id: <1353910821-21408-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353910821-21408-1-git-send-email-sachin.kamat@linaro.org>
References: <1353910821-21408-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_clk_get() is a device managed function and makes error handling
a bit simpler.

Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index c8b82c0..0c22ad5 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1002,11 +1002,8 @@ static void *gsc_get_drv_data(struct platform_device *pdev)
 
 static void gsc_clk_put(struct gsc_dev *gsc)
 {
-	if (!IS_ERR(gsc->clock)) {
+	if (!IS_ERR(gsc->clock))
 		clk_unprepare(gsc->clock);
-		clk_put(gsc->clock);
-		gsc->clock = NULL;
-	}
 }
 
 static int gsc_clk_get(struct gsc_dev *gsc)
@@ -1015,28 +1012,22 @@ static int gsc_clk_get(struct gsc_dev *gsc)
 
 	dev_dbg(&gsc->pdev->dev, "gsc_clk_get Called\n");
 
-	gsc->clock = clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
+	gsc->clock = devm_clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
 	if (IS_ERR(gsc->clock)) {
 		dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
 			GSC_CLOCK_GATE_NAME);
-		goto err_clk_get;
+		return PTR_ERR(gsc->clock);
 	}
 
 	ret = clk_prepare(gsc->clock);
 	if (ret < 0) {
 		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
 			GSC_CLOCK_GATE_NAME);
-		clk_put(gsc->clock);
 		gsc->clock = ERR_PTR(-EINVAL);
-		goto err_clk_prepare;
+		return ret;
 	}
 
 	return 0;
-
-err_clk_prepare:
-	gsc_clk_put(gsc);
-err_clk_get:
-	return -ENXIO;
 }
 
 static int gsc_m2m_suspend(struct gsc_dev *gsc)
-- 
1.7.4.1

