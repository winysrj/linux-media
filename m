Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:55430 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab2KWLLI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:11:08 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so2599382dak.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 03:11:08 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v2 2/4] [media] exynos-gsc: Remove gsc_clk_put call from gsc_clk_get
Date: Fri, 23 Nov 2012 16:34:40 +0530
Message-Id: <1353668682-13366-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353668682-13366-1-git-send-email-sachin.kamat@linaro.org>
References: <1353668682-13366-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since this function just returns (since gsc->clock is NULL),
remove it and make the exit code simpler.

Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 45bcfa7..99ee1a9 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1020,7 +1020,7 @@ static int gsc_clk_get(struct gsc_dev *gsc)
 	if (IS_ERR(gsc->clock)) {
 		dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
 			GSC_CLOCK_GATE_NAME);
-		goto err_clk_get;
+		goto err;
 	}
 
 	ret = clk_prepare(gsc->clock);
@@ -1029,14 +1029,12 @@ static int gsc_clk_get(struct gsc_dev *gsc)
 			GSC_CLOCK_GATE_NAME);
 		clk_put(gsc->clock);
 		gsc->clock = NULL;
-		goto err_clk_prepare;
+		goto err;
 	}
 
 	return 0;
 
-err_clk_prepare:
-	gsc_clk_put(gsc);
-err_clk_get:
+err:
 	return -ENXIO;
 }
 
-- 
1.7.4.1

