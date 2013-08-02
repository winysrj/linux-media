Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57495 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab3HBJP1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 05:15:27 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so468414pbb.6
        for <linux-media@vger.kernel.org>; Fri, 02 Aug 2013 02:15:26 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v2 3/3] [media] exynos4-is: Fix potential NULL pointer dereference
Date: Fri,  2 Aug 2013 14:28:25 +0530
Message-Id: <1375433905-30369-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dev->of_node could be NULL. Hence check for the same and return before
dereferencing it in the subsequent error message.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Changes since v1:
Moved the NULL check to beginning of probe.
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 08fbfed..318d4c3 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1504,16 +1504,17 @@ static int fimc_lite_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
+	if (!dev->of_node)
+		return -ENODEV;
+
 	fimc = devm_kzalloc(dev, sizeof(*fimc), GFP_KERNEL);
 	if (!fimc)
 		return -ENOMEM;
 
-	if (dev->of_node) {
-		of_id = of_match_node(flite_of_match, dev->of_node);
-		if (of_id)
-			drv_data = (struct flite_drvdata *)of_id->data;
-		fimc->index = of_alias_get_id(dev->of_node, "fimc-lite");
-	}
+	of_id = of_match_node(flite_of_match, dev->of_node);
+	if (of_id)
+		drv_data = (struct flite_drvdata *)of_id->data;
+	fimc->index = of_alias_get_id(dev->of_node, "fimc-lite");
 
 	if (!drv_data || fimc->index >= drv_data->num_instances ||
 						fimc->index < 0) {
-- 
1.7.9.5

