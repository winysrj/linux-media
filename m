Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40538 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936021AbeFMPJX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 11:09:23 -0400
Received: by mail-wr0-f193.google.com with SMTP id l41-v6so3135558wre.7
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2018 08:09:22 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v3 11/27] venus: core,helpers: add two more clocks found in Venus 4xx
Date: Wed, 13 Jun 2018 18:07:45 +0300
Message-Id: <20180613150801.11702-12-stanimir.varbanov@linaro.org>
In-Reply-To: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
References: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two more clocks for Venus 4xx in core structure and create
a new power enable function to handle it for 3xx/4xx versions.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.h    |  4 +++
 drivers/media/platform/qcom/venus/helpers.c | 51 +++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/helpers.h |  2 ++
 drivers/media/platform/qcom/venus/vdec.c    | 44 ++++++++++++++++++++-----
 drivers/media/platform/qcom/venus/venc.c    | 44 ++++++++++++++++++++-----
 5 files changed, 129 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 8d3e150800c9..2bf8839784fa 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -65,6 +65,8 @@ struct venus_format {
  * @clks:	an array of struct clk pointers
  * @core0_clk:	a struct clk pointer for core0
  * @core1_clk:	a struct clk pointer for core1
+ * @core0_bus_clk: a struct clk pointer for core0 bus clock
+ * @core1_bus_clk: a struct clk pointer for core1 bus clock
  * @vdev_dec:	a reference to video device structure for decoder instances
  * @vdev_enc:	a reference to video device structure for encoder instances
  * @v4l2_dev:	a holder for v4l2 device structure
@@ -94,6 +96,8 @@ struct venus_core {
 	struct clk *clks[VIDC_CLKS_NUM_MAX];
 	struct clk *core0_clk;
 	struct clk *core1_clk;
+	struct clk *core0_bus_clk;
+	struct clk *core1_bus_clk;
 	struct video_device *vdev_dec;
 	struct video_device *vdev_enc;
 	struct v4l2_device v4l2_dev;
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index d9065cc8a7d3..228084e72fb7 100644
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
+		return 0;
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
index 261a51adeef2..3cf243ddcdb8 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1081,12 +1081,18 @@ static int vdec_probe(struct platform_device *pdev)
 	if (!core)
 		return -EPROBE_DEFER;
 
-	if (core->res->hfi_version == HFI_VERSION_3XX) {
+	if (IS_V3(core) || IS_V4(core)) {
 		core->core0_clk = devm_clk_get(dev, "core");
 		if (IS_ERR(core->core0_clk))
 			return PTR_ERR(core->core0_clk);
 	}
 
+	if (IS_V4(core)) {
+		core->core0_bus_clk = devm_clk_get(dev, "bus");
+		if (IS_ERR(core->core0_bus_clk))
+			return PTR_ERR(core->core0_bus_clk);
+	}
+
 	platform_set_drvdata(pdev, core);
 
 	vdev = video_device_alloc();
@@ -1131,15 +1137,21 @@ static int vdec_remove(struct platform_device *pdev)
 static __maybe_unused int vdec_runtime_suspend(struct device *dev)
 {
 	struct venus_core *core = dev_get_drvdata(dev);
+	int ret;
 
-	if (core->res->hfi_version == HFI_VERSION_1XX)
+	if (IS_V1(core))
 		return 0;
 
-	writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
+	ret = venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, true);
+
+	if (IS_V4(core))
+		clk_disable_unprepare(core->core0_bus_clk);
+
 	clk_disable_unprepare(core->core0_clk);
-	writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
 
-	return 0;
+	ret |= venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, false);
+
+	return ret;
 }
 
 static __maybe_unused int vdec_runtime_resume(struct device *dev)
@@ -1147,13 +1159,29 @@ static __maybe_unused int vdec_runtime_resume(struct device *dev)
 	struct venus_core *core = dev_get_drvdata(dev);
 	int ret;
 
-	if (core->res->hfi_version == HFI_VERSION_1XX)
+	if (IS_V1(core))
 		return 0;
 
-	writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
+	ret = venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, true);
+	if (ret)
+		return ret;
+
 	ret = clk_prepare_enable(core->core0_clk);
-	writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
+	if (ret)
+		goto err_power_disable;
+
+	if (IS_V4(core))
+		ret = clk_prepare_enable(core->core0_bus_clk);
 
+	if (ret)
+		goto err_unprepare_core0;
+
+	return venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, false);
+
+err_unprepare_core0:
+	clk_disable_unprepare(core->core0_clk);
+err_power_disable:
+	venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, false);
 	return ret;
 }
 
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 947001170a77..2cd7b342b208 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1225,12 +1225,18 @@ static int venc_probe(struct platform_device *pdev)
 	if (!core)
 		return -EPROBE_DEFER;
 
-	if (core->res->hfi_version == HFI_VERSION_3XX) {
+	if (IS_V3(core) || IS_V4(core)) {
 		core->core1_clk = devm_clk_get(dev, "core");
 		if (IS_ERR(core->core1_clk))
 			return PTR_ERR(core->core1_clk);
 	}
 
+	if (IS_V4(core)) {
+		core->core1_bus_clk = devm_clk_get(dev, "bus");
+		if (IS_ERR(core->core1_bus_clk))
+			return PTR_ERR(core->core1_bus_clk);
+	}
+
 	platform_set_drvdata(pdev, core);
 
 	vdev = video_device_alloc();
@@ -1275,15 +1281,21 @@ static int venc_remove(struct platform_device *pdev)
 static __maybe_unused int venc_runtime_suspend(struct device *dev)
 {
 	struct venus_core *core = dev_get_drvdata(dev);
+	int ret;
 
-	if (core->res->hfi_version == HFI_VERSION_1XX)
+	if (IS_V1(core))
 		return 0;
 
-	writel(0, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
+	ret = venus_helper_power_enable(core, VIDC_SESSION_TYPE_ENC, true);
+
+	if (IS_V4(core))
+		clk_disable_unprepare(core->core1_bus_clk);
+
 	clk_disable_unprepare(core->core1_clk);
-	writel(1, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
 
-	return 0;
+	ret |= venus_helper_power_enable(core, VIDC_SESSION_TYPE_ENC, false);
+
+	return ret;
 }
 
 static __maybe_unused int venc_runtime_resume(struct device *dev)
@@ -1291,13 +1303,29 @@ static __maybe_unused int venc_runtime_resume(struct device *dev)
 	struct venus_core *core = dev_get_drvdata(dev);
 	int ret;
 
-	if (core->res->hfi_version == HFI_VERSION_1XX)
+	if (IS_V1(core))
 		return 0;
 
-	writel(0, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
+	ret = venus_helper_power_enable(core, VIDC_SESSION_TYPE_ENC, true);
+	if (ret)
+		return ret;
+
 	ret = clk_prepare_enable(core->core1_clk);
-	writel(1, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
+	if (ret)
+		goto err_power_disable;
+
+	if (IS_V4(core))
+		ret = clk_prepare_enable(core->core1_bus_clk);
 
+	if (ret)
+		goto err_unprepare_core1;
+
+	return venus_helper_power_enable(core, VIDC_SESSION_TYPE_ENC, false);
+
+err_unprepare_core1:
+	clk_disable_unprepare(core->core1_clk);
+err_power_disable:
+	venus_helper_power_enable(core, VIDC_SESSION_TYPE_ENC, false);
 	return ret;
 }
 
-- 
2.14.1
