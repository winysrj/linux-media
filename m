Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48816 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3HBGsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 02:48:54 -0400
Received: by mail-pa0-f51.google.com with SMTP id lf11so332966pab.24
        for <linux-media@vger.kernel.org>; Thu, 01 Aug 2013 23:48:53 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/3] [media] exynos4-is: Annotate unused functions
Date: Fri,  2 Aug 2013 12:02:13 +0530
Message-Id: <1375425134-17080-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1375425134-17080-1-git-send-email-sachin.kamat@linaro.org>
References: <1375425134-17080-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

__is_set_init_isp_aa and fimc_is_hw_set_tune currently do not have
any callers. However these functions may be used in the future. Hence
instead of deleting them, staticize and annotate them with __maybe_unused
flag to avoid compiler warnings.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos4-is/fimc-is-param.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.c b/drivers/media/platform/exynos4-is/fimc-is-param.c
index a353be0..9bf3ddd 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-param.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.c
@@ -287,7 +287,7 @@ void __is_set_sensor(struct fimc_is *is, int fps)
 	fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
 }
 
-void __is_set_init_isp_aa(struct fimc_is *is)
+static void __maybe_unused __is_set_init_isp_aa(struct fimc_is *is)
 {
 	struct isp_param *isp;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
index 63c68ec..cf2e13a 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -96,7 +96,7 @@ int fimc_is_hw_set_param(struct fimc_is *is)
 	return 0;
 }
 
-int fimc_is_hw_set_tune(struct fimc_is *is)
+static int __maybe_unused fimc_is_hw_set_tune(struct fimc_is *is)
 {
 	fimc_is_hw_wait_intmsr0_intmsd0(is);
 
-- 
1.7.9.5

