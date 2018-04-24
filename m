Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37722 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757851AbeDXMpV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 08:45:21 -0400
Received: by mail-wm0-f65.google.com with SMTP id l16so615242wmh.2
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 05:45:20 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 12/28] venus: helpers: make a commmon function for power_enable
Date: Tue, 24 Apr 2018 15:44:20 +0300
Message-Id: <20180424124436.26955-13-stanimir.varbanov@linaro.org>
In-Reply-To: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make common function which will enable power when enabling/disabling
clocks and also covers Venus 3xx/4xx versions.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 51 +++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/helpers.h |  2 ++
 drivers/media/platform/qcom/venus/vdec.c    | 25 ++++----------
 drivers/media/platform/qcom/venus/venc.c    | 25 ++++----------
 4 files changed, 67 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index d9065cc8a7d3..2b21f6ed7502 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -13,6 +13,7 @@
  *
  */
 #include <linux/clk.h>
+#include <linux/iopoll.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/pm_runtime.h>
@@ -24,6 +25,7 @@
 #include "core.h"
 #include "helpers.h"
 #include "hfi_helper.h"
+#include "hfi_venus_io.h"
 
 struct intbuf {
 	struct list_head list;
@@ -781,3 +783,52 @@ void venus_helper_init_instance(struct venus_inst *inst)
 	}
 }
 EXPORT_SYMBOL_GPL(venus_helper_init_instance);
+
+int venus_helper_power_enable(struct venus_core *core, u32 session_type,
+			      bool enable)
+{
+	void __iomem *ctrl, *stat;
+	u32 val;
+	int ret;
+
+	if (!IS_V3(core) && !IS_V4(core))
+		return -EINVAL;
+
+	if (IS_V3(core)) {
+		if (session_type == VIDC_SESSION_TYPE_DEC)
+			ctrl = core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL;
+		else
+			ctrl = core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL;
+		if (enable)
+			writel(0, ctrl);
+		else
+			writel(1, ctrl);
+
+		return 0;
+	}
+
+	if (session_type == VIDC_SESSION_TYPE_DEC) {
+		ctrl = core->base + WRAPPER_VCODEC0_MMCC_POWER_CONTROL;
+		stat = core->base + WRAPPER_VCODEC0_MMCC_POWER_STATUS;
+	} else {
+		ctrl = core->base + WRAPPER_VCODEC1_MMCC_POWER_CONTROL;
+		stat = core->base + WRAPPER_VCODEC1_MMCC_POWER_STATUS;
+	}
+
+	if (enable) {
+		writel(0, ctrl);
+
+		ret = readl_poll_timeout(stat, val, val & BIT(1), 1, 100);
+		if (ret)
+			return ret;
+	} else {
+		writel(1, ctrl);
+
+		ret = readl_poll_timeout(stat, val, !(val & BIT(1)), 1, 100);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(venus_helper_power_enable);
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index 971392be5df5..0e64aa95624a 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -43,4 +43,6 @@ int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
 void venus_helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf);
 void venus_helper_release_buf_ref(struct venus_inst *inst, unsigned int idx);
 void venus_helper_init_instance(struct venus_inst *inst);
+int venus_helper_power_enable(struct venus_core *core, u32 session_type,
+			      bool enable);
 #endif
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index cd278a695899..0ddc2c4df934 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1131,26 +1131,21 @@ static int vdec_remove(struct platform_device *pdev)
 static __maybe_unused int vdec_runtime_suspend(struct device *dev)
 {
 	struct venus_core *core = dev_get_drvdata(dev);
+	int ret;
 
 	if (IS_V1(core))
 		return 0;
 
-	if (IS_V3(core))
-		writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
-	else if (IS_V4(core))
-		writel(0, core->base + WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
+	ret = venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, true);
 
 	if (IS_V4(core))
 		clk_disable_unprepare(core->core0_bus_clk);
 
 	clk_disable_unprepare(core->core0_clk);
 
-	if (IS_V3(core))
-		writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
-	else if (IS_V4(core))
-		writel(1, core->base + WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
+	ret |= venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, false);
 
-	return 0;
+	return ret;
 }
 
 static __maybe_unused int vdec_runtime_resume(struct device *dev)
@@ -1161,20 +1156,14 @@ static __maybe_unused int vdec_runtime_resume(struct device *dev)
 	if (IS_V1(core))
 		return 0;
 
-	if (IS_V3(core))
-		writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
-	else if (IS_V4(core))
-		writel(0, core->base + WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
+	ret = venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, true);
 
-	ret = clk_prepare_enable(core->core0_clk);
+	ret |= clk_prepare_enable(core->core0_clk);
 
 	if (IS_V4(core))
 		ret |= clk_prepare_enable(core->core0_bus_clk);
 
-	if (IS_V3(core))
-		writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
-	else if (IS_V4(core))
-		writel(1, core->base + WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
+	ret |= venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, false);
 
 	return ret;
 }
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index be8ea3326386..f87d891325ea 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1267,26 +1267,21 @@ static int venc_remove(struct platform_device *pdev)
 static __maybe_unused int venc_runtime_suspend(struct device *dev)
 {
 	struct venus_core *core = dev_get_drvdata(dev);
+	int ret;
 
 	if (IS_V1(core))
 		return 0;
 
-	if (IS_V3(core))
-		writel(0, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
-	else if (IS_V4(core))
-		writel(0, core->base + WRAPPER_VCODEC1_MMCC_POWER_CONTROL);
+	ret = venus_helper_power_enable(core, VIDC_SESSION_TYPE_ENC, true);
 
 	if (IS_V4(core))
 		clk_disable_unprepare(core->core1_bus_clk);
 
 	clk_disable_unprepare(core->core1_clk);
 
-	if (IS_V3(core))
-		writel(1, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
-	else if (IS_V4(core))
-		writel(1, core->base + WRAPPER_VCODEC1_MMCC_POWER_CONTROL);
+	ret |= venus_helper_power_enable(core, VIDC_SESSION_TYPE_ENC, false);
 
-	return 0;
+	return ret;
 }
 
 static __maybe_unused int venc_runtime_resume(struct device *dev)
@@ -1297,20 +1292,14 @@ static __maybe_unused int venc_runtime_resume(struct device *dev)
 	if (IS_V1(core))
 		return 0;
 
-	if (IS_V3(core))
-		writel(0, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
-	else if (IS_V4(core))
-		writel(0, core->base + WRAPPER_VCODEC1_MMCC_POWER_CONTROL);
+	ret = venus_helper_power_enable(core, VIDC_SESSION_TYPE_ENC, true);
 
-	ret = clk_prepare_enable(core->core1_clk);
+	ret |= clk_prepare_enable(core->core1_clk);
 
 	if (IS_V4(core))
 		ret |= clk_prepare_enable(core->core1_bus_clk);
 
-	if (IS_V3(core))
-		writel(1, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
-	else if (IS_V4(core))
-		writel(1, core->base + WRAPPER_VCODEC1_MMCC_POWER_CONTROL);
+	ret |= venus_helper_power_enable(core, VIDC_SESSION_TYPE_ENC, false);
 
 	return ret;
 }
-- 
2.14.1
