Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:62866 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab2KWEvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 23:51:25 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so2471532dak.19
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 20:51:25 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH 1/4] [media] exynos-gsc: Rearrange error messages for valid prints
Date: Fri, 23 Nov 2012 10:14:59 +0530
Message-Id: <1353645902-7467-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353645902-7467-1-git-send-email-sachin.kamat@linaro.org>
References: <1353645902-7467-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case of clk_prepare failure, the function gsc_clk_get also prints
"failed to get clock" which is not correct. Hence move the error
messages to their respective blocks. While at it, also renamed the labels
meaningfully.

Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 6d6f65d..45bcfa7 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1017,25 +1017,26 @@ static int gsc_clk_get(struct gsc_dev *gsc)
 	dev_dbg(&gsc->pdev->dev, "gsc_clk_get Called\n");
 
 	gsc->clock = clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
-	if (IS_ERR(gsc->clock))
-		goto err_print;
+	if (IS_ERR(gsc->clock)) {
+		dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
+			GSC_CLOCK_GATE_NAME);
+		goto err_clk_get;
+	}
 
 	ret = clk_prepare(gsc->clock);
 	if (ret < 0) {
+		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
+			GSC_CLOCK_GATE_NAME);
 		clk_put(gsc->clock);
 		gsc->clock = NULL;
-		goto err;
+		goto err_clk_prepare;
 	}
 
 	return 0;
 
-err:
-	dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
-					GSC_CLOCK_GATE_NAME);
+err_clk_prepare:
 	gsc_clk_put(gsc);
-err_print:
-	dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
-					GSC_CLOCK_GATE_NAME);
+err_clk_get:
 	return -ENXIO;
 }
 
-- 
1.7.4.1

