Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:49205 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3DPGOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 02:14:52 -0400
Received: by mail-pd0-f180.google.com with SMTP id q11so109142pdj.25
        for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 23:14:51 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 5/5] [media] exynos4-is: Remove unused functions
Date: Tue, 16 Apr 2013 11:32:23 +0530
Message-Id: <1366092143-5482-5-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1366092143-5482-1-git-send-email-sachin.kamat@linaro.org>
References: <1366092143-5482-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These functions do not have any callers yet and hence could
be removed for now.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos4-is/fimc-is-param.c |   21 ---------------------
 drivers/media/platform/exynos4-is/fimc-is-regs.c  |   12 ------------
 2 files changed, 33 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.c b/drivers/media/platform/exynos4-is/fimc-is-param.c
index 64e41b8..91258d5 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-param.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.c
@@ -288,27 +288,6 @@ void __is_set_sensor(struct fimc_is *is, int fps)
 	fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
 }
 
-void __is_set_init_isp_aa(struct fimc_is *is)
-{
-	struct isp_param *isp;
-
-	isp = &is->config[is->config_index].isp;
-
-	isp->aa.cmd = ISP_AA_COMMAND_START;
-	isp->aa.target = ISP_AA_TARGET_AF | ISP_AA_TARGET_AE |
-			 ISP_AA_TARGET_AWB;
-	isp->aa.mode = 0;
-	isp->aa.scene = 0;
-	isp->aa.sleep = 0;
-	isp->aa.face = 0;
-	isp->aa.touch_x = 0;
-	isp->aa.touch_y = 0;
-	isp->aa.manual_af_setting = 0;
-	isp->aa.err = ISP_AF_ERROR_NONE;
-
-	fimc_is_set_param_bit(is, PARAM_ISP_AA);
-}
-
 void __is_set_isp_flash(struct fimc_is *is, u32 cmd, u32 redeye)
 {
 	unsigned int index = is->config_index;
diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
index b0ff67b..93b446f 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -96,18 +96,6 @@ int fimc_is_hw_set_param(struct fimc_is *is)
 	return 0;
 }
 
-int fimc_is_hw_set_tune(struct fimc_is *is)
-{
-	fimc_is_hw_wait_intmsr0_intmsd0(is);
-
-	mcuctl_write(HIC_SET_TUNE, is, MCUCTL_REG_ISSR(0));
-	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
-	mcuctl_write(is->h2i_cmd.entry_id, is, MCUCTL_REG_ISSR(2));
-
-	fimc_is_hw_set_intgr0_gd0(is);
-	return 0;
-}
-
 #define FIMC_IS_MAX_PARAMS	4
 
 int fimc_is_hw_get_params(struct fimc_is *is, unsigned int num_args)
-- 
1.7.9.5

