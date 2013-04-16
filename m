Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57741 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3DPGOj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 02:14:39 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so110719pbb.5
        for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 23:14:38 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/5] [media] exynos4-is: Fix potential null pointer dereferencing
Date: Tue, 16 Apr 2013 11:32:19 +0530
Message-Id: <1366092143-5482-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If fimc->drv_data is NULL, then fimc->drv_data->num_entities would
cause NULL pointer dereferencing. Hence remove it from print statement.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos4-is/fimc-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index f25807d..a8eaad0 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -955,8 +955,8 @@ static int fimc_probe(struct platform_device *pdev)
 	}
 	if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities ||
 	    fimc->id < 0) {
-		dev_err(dev, "Invalid driver data or device id (%d/%d)\n",
-			fimc->id, fimc->drv_data->num_entities);
+		dev_err(dev, "Invalid driver data or device id (%d)\n",
+			fimc->id);
 		return -EINVAL;
 	}
 	if (!dev->of_node)
-- 
1.7.9.5

