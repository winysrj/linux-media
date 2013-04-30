Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:59979 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3D3FEX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 01:04:23 -0400
Received: by mail-da0-f53.google.com with SMTP id n34so73904dal.40
        for <linux-media@vger.kernel.org>; Mon, 29 Apr 2013 22:04:23 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] exynos4-is: Remove redundant NULL check in fimc-lite.c
Date: Tue, 30 Apr 2013 10:21:33 +0530
Message-Id: <1367297493-31782-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clk_unprepare checks for NULL pointer. Hence convert IS_ERR_OR_NULL
to IS_ERR only.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 661d0d1..2a0ef82 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1416,7 +1416,7 @@ static void fimc_lite_unregister_capture_subdev(struct fimc_lite *fimc)
 
 static void fimc_lite_clk_put(struct fimc_lite *fimc)
 {
-	if (IS_ERR_OR_NULL(fimc->clock))
+	if (IS_ERR(fimc->clock))
 		return;
 
 	clk_unprepare(fimc->clock);
-- 
1.7.9.5

