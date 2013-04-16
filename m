Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46852 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3DPGOp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 02:14:45 -0400
Received: by mail-pd0-f171.google.com with SMTP id z10so111097pdj.2
        for <linux-media@vger.kernel.org>; Mon, 15 Apr 2013 23:14:45 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 3/5] [media] exynos4-is: Staticize local symbols
Date: Tue, 16 Apr 2013 11:32:21 +0530
Message-Id: <1366092143-5482-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1366092143-5482-1-git-send-email-sachin.kamat@linaro.org>
References: <1366092143-5482-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These symbols are used only in their respective files and hence
should be made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos4-is/fimc-is-i2c.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-param.c |    6 +++---
 drivers/media/platform/exynos4-is/fimc-is.c       |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.c b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
index 1ec6b3c..ac0b46c 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-i2c.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
@@ -96,7 +96,7 @@ static int fimc_is_i2c_resume(struct device *dev)
 	return clk_prepare_enable(isp_i2c->clock);
 }
 
-UNIVERSAL_DEV_PM_OPS(fimc_is_i2c_pm_ops, fimc_is_i2c_suspend,
+static UNIVERSAL_DEV_PM_OPS(fimc_is_i2c_pm_ops, fimc_is_i2c_suspend,
 		     fimc_is_i2c_resume, NULL);
 
 static const struct of_device_id fimc_is_i2c_of_match[] = {
diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.c b/drivers/media/platform/exynos4-is/fimc-is-param.c
index 53fe2a2..64e41b8 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-param.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.c
@@ -38,7 +38,7 @@ static void __hw_param_copy(void *dst, void *src)
 	memcpy(dst, src, FIMC_IS_PARAM_MAX_SIZE);
 }
 
-void __fimc_is_hw_update_param_global_shotmode(struct fimc_is *is)
+static void __fimc_is_hw_update_param_global_shotmode(struct fimc_is *is)
 {
 	struct param_global_shotmode *dst, *src;
 
@@ -47,7 +47,7 @@ void __fimc_is_hw_update_param_global_shotmode(struct fimc_is *is)
 	__hw_param_copy(dst, src);
 }
 
-void __fimc_is_hw_update_param_sensor_framerate(struct fimc_is *is)
+static void __fimc_is_hw_update_param_sensor_framerate(struct fimc_is *is)
 {
 	struct param_sensor_framerate *dst, *src;
 
@@ -56,7 +56,7 @@ void __fimc_is_hw_update_param_sensor_framerate(struct fimc_is *is)
 	__hw_param_copy(dst, src);
 }
 
-int __fimc_is_hw_update_param(struct fimc_is *is, u32 offset)
+static int __fimc_is_hw_update_param(struct fimc_is *is, u32 offset)
 {
 	struct is_param_region *par = &is->is_p_region->parameter;
 	struct chain_config *cfg = &is->config[is->config_index];
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 3c81c88..59529df 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -137,7 +137,7 @@ static int fimc_is_setup_clocks(struct fimc_is *is)
 					ATCLK_MCUISP_FREQUENCY);
 }
 
-int fimc_is_enable_clocks(struct fimc_is *is)
+static int fimc_is_enable_clocks(struct fimc_is *is)
 {
 	int i, ret;
 
@@ -157,7 +157,7 @@ int fimc_is_enable_clocks(struct fimc_is *is)
 	return 0;
 }
 
-void fimc_is_disable_clocks(struct fimc_is *is)
+static void fimc_is_disable_clocks(struct fimc_is *is)
 {
 	int i;
 
-- 
1.7.9.5

