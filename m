Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45779 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2JQLQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 07:16:46 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so7059174pbb.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 04:16:46 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 6/8] [media] exynos-gsc: Fix compilation warning
Date: Wed, 17 Oct 2012 16:41:49 +0530
Message-Id: <1350472311-9748-6-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used type casting to avoid the following compilation warning:

drivers/media/platform/exynos-gsc/gsc-core.c:983:37: warning:
incorrect type in assignment (different modifiers)
drivers/media/platform/exynos-gsc/gsc-core.c:983:37:
expected struct gsc_driverdata *driver_data
drivers/media/platform/exynos-gsc/gsc-core.c:983:37:
got void const *data

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index d11668b..9b86ef6 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -980,7 +980,7 @@ static void *gsc_get_drv_data(struct platform_device *pdev)
 		match = of_match_node(of_match_ptr(exynos_gsc_match),
 					pdev->dev.of_node);
 		if (match)
-			driver_data =  match->data;
+			driver_data = (struct gsc_driverdata *)match->data;
 	} else {
 		driver_data = (struct gsc_driverdata *)
 			platform_get_device_id(pdev)->driver_data;
-- 
1.7.4.1

