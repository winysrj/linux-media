Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37251 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3EWFFF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 01:05:05 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl1so682157pab.20
        for <linux-media@vger.kernel.org>; Wed, 22 May 2013 22:05:04 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sylvester.nawrocki@gmail.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/2] [media] exynos-gsc: Remove redundant use of of_match_ptr macro
Date: Thu, 23 May 2013 10:21:18 +0530
Message-Id: <1369284679-14716-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a DT only driver and exynos_gsc_match is always compiled
in. Hence of_match_ptr is unnecessary.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 33b5ffc..559fab2 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -988,7 +988,7 @@ static void *gsc_get_drv_data(struct platform_device *pdev)
 
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
-		match = of_match_node(of_match_ptr(exynos_gsc_match),
+		match = of_match_node(exynos_gsc_match,
 					pdev->dev.of_node);
 		if (match)
 			driver_data = (struct gsc_driverdata *)match->data;
-- 
1.7.9.5

