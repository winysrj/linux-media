Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36980 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdGQI6E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 04:58:04 -0400
Received: by mail-wm0-f54.google.com with SMTP id b134so40589650wma.0
        for <linux-media@vger.kernel.org>; Mon, 17 Jul 2017 01:58:04 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/4] venus: mark PM functions as __maybe_unused
Date: Mon, 17 Jul 2017 11:56:47 +0300
Message-Id: <20170717085650.12185-2-stanimir.varbanov@linaro.org>
In-Reply-To: <20170717085650.12185-1-stanimir.varbanov@linaro.org>
References: <20170717085650.12185-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

Without PM support, gcc warns about two unused functions:

platform/qcom/venus/core.c:146:13: error: 'venus_clks_disable' defined but not used [-Werror=unused-function]
platform/qcom/venus/core.c:126:12: error: 'venus_clks_enable' defined but not used [-Werror=unused-function]

The problem as usual are incorrect #ifdefs, so the easiest fix
is to do away with the #ifdef completely and mark the suspend/resume
handlers as __maybe_unused, which they are.

Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 776d2bae6979..694f57a78288 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -270,8 +270,7 @@ static int venus_remove(struct platform_device *pdev)
 	return ret;
 }
 
-#ifdef CONFIG_PM
-static int venus_runtime_suspend(struct device *dev)
+static __maybe_unused int venus_runtime_suspend(struct device *dev)
 {
 	struct venus_core *core = dev_get_drvdata(dev);
 	int ret;
@@ -283,7 +282,7 @@ static int venus_runtime_suspend(struct device *dev)
 	return ret;
 }
 
-static int venus_runtime_resume(struct device *dev)
+static __maybe_unused int venus_runtime_resume(struct device *dev)
 {
 	struct venus_core *core = dev_get_drvdata(dev);
 	int ret;
@@ -302,7 +301,6 @@ static int venus_runtime_resume(struct device *dev)
 	venus_clks_disable(core);
 	return ret;
 }
-#endif
 
 static const struct dev_pm_ops venus_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
-- 
2.11.0
