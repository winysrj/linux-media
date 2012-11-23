Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64565 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2KWL5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:57:06 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so3502852pad.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 03:57:05 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/6] [media] s5p-fimc: Use devm_clk_get in fimc-core.c
Date: Fri, 23 Nov 2012 17:20:39 +0530
Message-Id: <1353671443-2978-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
References: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_clk_get is device managed and makes error handling and cleanup
a bit simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/fimc-core.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 8d0d2b9..0c45127 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -814,8 +814,6 @@ static void fimc_clk_put(struct fimc_dev *fimc)
 		if (IS_ERR_OR_NULL(fimc->clock[i]))
 			continue;
 		clk_unprepare(fimc->clock[i]);
-		clk_put(fimc->clock[i]);
-		fimc->clock[i] = NULL;
 	}
 }
 
@@ -824,19 +822,15 @@ static int fimc_clk_get(struct fimc_dev *fimc)
 	int i, ret;
 
 	for (i = 0; i < MAX_FIMC_CLOCKS; i++) {
-		fimc->clock[i] = clk_get(&fimc->pdev->dev, fimc_clocks[i]);
+		fimc->clock[i] = devm_clk_get(&fimc->pdev->dev, fimc_clocks[i]);
 		if (IS_ERR(fimc->clock[i]))
 			goto err;
 		ret = clk_prepare(fimc->clock[i]);
-		if (ret < 0) {
-			clk_put(fimc->clock[i]);
-			fimc->clock[i] = NULL;
+		if (ret < 0)
 			goto err;
-		}
 	}
 	return 0;
 err:
-	fimc_clk_put(fimc);
 	dev_err(&fimc->pdev->dev, "failed to get clock: %s\n",
 		fimc_clocks[i]);
 	return -ENXIO;
-- 
1.7.4.1

