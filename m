Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:63797 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3DZE4z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 00:56:55 -0400
Received: by mail-pb0-f52.google.com with SMTP id mc17so805693pbc.39
        for <linux-media@vger.kernel.org>; Thu, 25 Apr 2013 21:56:55 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] exynos4-is: Fix potential null pointer dereference in mipi-csis.c
Date: Fri, 26 Apr 2013 10:14:07 +0530
Message-Id: <1366951447-6202-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When 'node' is NULL, the print statement tries to dereference it.
Remove it from the error message.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos4-is/mipi-csis.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index a2eda9d..6ddc69f 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -745,8 +745,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 
 	node = v4l2_of_get_next_endpoint(node, NULL);
 	if (!node) {
-		dev_err(&pdev->dev, "No port node at %s\n",
-					node->full_name);
+		dev_err(&pdev->dev, "Port node not available\n");
 		return -EINVAL;
 	}
 	/* Get port node and validate MIPI-CSI channel id. */
-- 
1.7.9.5

