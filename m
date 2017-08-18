Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:33939 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753510AbdHROQu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 10:16:50 -0400
Received: by mail-wr0-f174.google.com with SMTP id y96so68403998wrc.1
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 07:16:50 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 3/7] media: venus: mark venc and vdec PM functions as __maybe_unused
Date: Fri, 18 Aug 2017 17:16:02 +0300
Message-Id: <20170818141606.4835-4-stanimir.varbanov@linaro.org>
In-Reply-To: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
References: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without PM support gcc could warns about unused functions, thus
mark runtime_suspend/resume as __maybe_unused.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 6 ++----
 drivers/media/platform/qcom/venus/venc.c | 6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index eb0c1c51cfef..44d4848e878a 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1103,8 +1103,7 @@ static int vdec_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int vdec_runtime_suspend(struct device *dev)
+static __maybe_unused int vdec_runtime_suspend(struct device *dev)
 {
 	struct venus_core *core = dev_get_drvdata(dev);
 
@@ -1118,7 +1117,7 @@ static int vdec_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int vdec_runtime_resume(struct device *dev)
+static __maybe_unused int vdec_runtime_resume(struct device *dev)
 {
 	struct venus_core *core = dev_get_drvdata(dev);
 	int ret;
@@ -1132,7 +1131,6 @@ static int vdec_runtime_resume(struct device *dev)
 
 	return ret;
 }
-#endif
 
 static const struct dev_pm_ops vdec_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 01af1ac89edf..4bffadd67238 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1226,8 +1226,7 @@ static int venc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int venc_runtime_suspend(struct device *dev)
+static __maybe_unused int venc_runtime_suspend(struct device *dev)
 {
 	struct venus_core *core = dev_get_drvdata(dev);
 
@@ -1241,7 +1240,7 @@ static int venc_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int venc_runtime_resume(struct device *dev)
+static __maybe_unused int venc_runtime_resume(struct device *dev)
 {
 	struct venus_core *core = dev_get_drvdata(dev);
 	int ret;
@@ -1255,7 +1254,6 @@ static int venc_runtime_resume(struct device *dev)
 
 	return ret;
 }
-#endif
 
 static const struct dev_pm_ops venc_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
-- 
2.11.0
