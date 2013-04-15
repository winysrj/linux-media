Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56438 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3DOMQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 08:16:11 -0400
Received: by mail-pa0-f52.google.com with SMTP id fb10so2523700pad.39
        for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 05:16:10 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] exynos4-is: Fix potential null pointer dereferencing
Date: Mon, 15 Apr 2013 17:33:58 +0530
Message-Id: <1366027438-4560-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If fimc->drv_data is NULL, then fimc->drv_data->num_entities would
cause NULL pointer dereferencing.
While at it also remove the check for fimc->id being negative as 'id' is
unsigned variable and can't be less than 0.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos4-is/fimc-core.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index f25807d..d388832 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -953,10 +953,9 @@ static int fimc_probe(struct platform_device *pdev)
 		fimc->drv_data = fimc_get_drvdata(pdev);
 		fimc->id = pdev->id;
 	}
-	if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities ||
-	    fimc->id < 0) {
-		dev_err(dev, "Invalid driver data or device id (%d/%d)\n",
-			fimc->id, fimc->drv_data->num_entities);
+	if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities) {
+		dev_err(dev, "Invalid driver data or device id (%d)\n",
+			fimc->id);
 		return -EINVAL;
 	}
 	if (!dev->of_node)
-- 
1.7.9.5

