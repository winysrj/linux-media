Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48310 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab3HBGsu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 02:48:50 -0400
Received: by mail-pd0-f172.google.com with SMTP id z11so325584pdj.17
        for <linux-media@vger.kernel.org>; Thu, 01 Aug 2013 23:48:50 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/3] [media] exynos4-is: Staticize local symbol
Date: Fri,  2 Aug 2013 12:02:12 +0530
Message-Id: <1375425134-17080-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

__fimc_is_hw_update_param is used only in this file. Make it static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos4-is/fimc-is-param.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.c b/drivers/media/platform/exynos4-is/fimc-is-param.c
index c7e7f69..a353be0 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-param.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.c
@@ -56,7 +56,7 @@ static void __fimc_is_hw_update_param_sensor_framerate(struct fimc_is *is)
 	__hw_param_copy(dst, src);
 }
 
-int __fimc_is_hw_update_param(struct fimc_is *is, u32 offset)
+static int __fimc_is_hw_update_param(struct fimc_is *is, u32 offset)
 {
 	struct is_param_region *par = &is->is_p_region->parameter;
 	struct chain_config *cfg = &is->config[is->config_index];
-- 
1.7.9.5

