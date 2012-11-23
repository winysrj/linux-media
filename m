Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50490 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab2KWLLL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:11:11 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so3478794pad.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 03:11:11 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v2 3/4] [media] exynos-gsc: Use devm_clk_get()
Date: Fri, 23 Nov 2012 16:34:41 +0530
Message-Id: <1353668682-13366-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353668682-13366-1-git-send-email-sachin.kamat@linaro.org>
References: <1353668682-13366-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_clk_get() is a device managed function and makes error handling
a bit simpler.

Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 99ee1a9..5a285b2 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1006,8 +1006,6 @@ static void gsc_clk_put(struct gsc_dev *gsc)
 		return;
 
 	clk_unprepare(gsc->clock);
-	clk_put(gsc->clock);
-	gsc->clock = NULL;
 }
 
 static int gsc_clk_get(struct gsc_dev *gsc)
@@ -1016,26 +1014,21 @@ static int gsc_clk_get(struct gsc_dev *gsc)
 
 	dev_dbg(&gsc->pdev->dev, "gsc_clk_get Called\n");
 
-	gsc->clock = clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
+	gsc->clock = devm_clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
 	if (IS_ERR(gsc->clock)) {
 		dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
 			GSC_CLOCK_GATE_NAME);
-		goto err;
+		return PTR_ERR(gsc->clock);
 	}
 
 	ret = clk_prepare(gsc->clock);
 	if (ret < 0) {
 		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
 			GSC_CLOCK_GATE_NAME);
-		clk_put(gsc->clock);
-		gsc->clock = NULL;
-		goto err;
+		return ret;
 	}
 
 	return 0;
-
-err:
-	return -ENXIO;
 }
 
 static int gsc_m2m_suspend(struct gsc_dev *gsc)
-- 
1.7.4.1

