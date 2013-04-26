Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59263 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab3DZJFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 05:05:38 -0400
Received: by mail-pb0-f54.google.com with SMTP id jt11so1088239pbb.13
        for <linux-media@vger.kernel.org>; Fri, 26 Apr 2013 02:05:38 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v2] [media] exynos4-is: Fix potential null pointer dereference in mipi-csis.c
Date: Fri, 26 Apr 2013 14:22:57 +0530
Message-Id: <1366966377-15808-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When 'node' is NULL, the print statement tries to dereference it.
Hence replace the variable with the one that is accessible.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Changes since v1:
Used pdev->dev.of_node->full_name for node name.
---
 drivers/media/platform/exynos4-is/mipi-csis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index a2eda9d..254d70f 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -746,7 +746,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 	node = v4l2_of_get_next_endpoint(node, NULL);
 	if (!node) {
 		dev_err(&pdev->dev, "No port node at %s\n",
-					node->full_name);
+				pdev->dev.of_node->full_name);
 		return -EINVAL;
 	}
 	/* Get port node and validate MIPI-CSI channel id. */
-- 
1.7.9.5

