Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64565 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2KWL5I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:57:08 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so3502852pad.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 03:57:08 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 3/6] [media] s5p-fimc: Use devm_clk_get in fimc-lite.c
Date: Fri, 23 Nov 2012 17:20:40 +0530
Message-Id: <1353671443-2978-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
References: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_clk_get is device managed and makes error handling and cleanup
a bit simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/fimc-lite.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 70bcf39..02d0ff9 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -1382,23 +1382,17 @@ static void fimc_lite_clk_put(struct fimc_lite *fimc)
 		return;
 
 	clk_unprepare(fimc->clock);
-	clk_put(fimc->clock);
-	fimc->clock = NULL;
 }
 
 static int fimc_lite_clk_get(struct fimc_lite *fimc)
 {
 	int ret;
 
-	fimc->clock = clk_get(&fimc->pdev->dev, FLITE_CLK_NAME);
+	fimc->clock = devm_clk_get(&fimc->pdev->dev, FLITE_CLK_NAME);
 	if (IS_ERR(fimc->clock))
 		return PTR_ERR(fimc->clock);
 
 	ret = clk_prepare(fimc->clock);
-	if (ret < 0) {
-		clk_put(fimc->clock);
-		fimc->clock = NULL;
-	}
 	return ret;
 }
 
-- 
1.7.4.1

