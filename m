Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbeISFTJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 01:19:09 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, arnd@arndb.de, bjorn.andersson@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
Subject: [PATCH v9 3/5] venus: firmware: register separate platform_device for firmware loader
Date: Wed, 19 Sep 2018 05:13:10 +0530
Message-Id: <1537314192-26892-4-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1537314192-26892-1-git-send-email-vgarodia@codeaurora.org>
References: <1537314192-26892-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

This registers a firmware platform_device and associate it with
video-firmware DT subnode. Then calls dma configure to initialize
dma and iommu.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.c     | 14 +++++---
 drivers/media/platform/qcom/venus/core.h     |  3 ++
 drivers/media/platform/qcom/venus/firmware.c | 54 ++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/firmware.h |  2 ++
 4 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 75b9785..440f25f 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -284,6 +284,14 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_runtime_disable;
 
+	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+	if (ret)
+		goto err_runtime_disable;
+
+	ret = venus_firmware_init(core);
+	if (ret)
+		goto err_runtime_disable;
+
 	ret = venus_boot(core);
 	if (ret)
 		goto err_runtime_disable;
@@ -308,10 +316,6 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_core_deinit;
 
-	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
-	if (ret)
-		goto err_dev_unregister;
-
 	ret = pm_runtime_put_sync(dev);
 	if (ret)
 		goto err_dev_unregister;
@@ -347,6 +351,8 @@ static int venus_remove(struct platform_device *pdev)
 	venus_shutdown(dev);
 	of_platform_depopulate(dev);
 
+	venus_firmware_deinit(core);
+
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index dfd5c10..6f2c82d 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -130,6 +130,9 @@ struct venus_core {
 	struct device *dev;
 	struct device *dev_dec;
 	struct device *dev_enc;
+	struct video_firmware {
+		struct device *dev;
+	} fw;
 	bool no_tz;
 	struct mutex lock;
 	struct list_head instances;
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 16faba6..f4d2b4b 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -18,6 +18,8 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/of_device.h>
 #include <linux/qcom_scm.h>
 #include <linux/sizes.h>
 #include <linux/soc/qcom/mdt_loader.h>
@@ -144,3 +146,55 @@ int venus_shutdown(struct device *dev)
 {
 	return qcom_scm_pas_shutdown(VENUS_PAS_ID);
 }
+
+int venus_firmware_init(struct venus_core *core)
+{
+	struct platform_device_info info;
+	struct platform_device *pdev;
+	struct device_node *np;
+	int ret;
+
+	np = of_get_child_by_name(core->dev->of_node, "video-firmware");
+	if (!np)
+		return 0;
+
+	memset(&info, 0, sizeof(info));
+	info.fwnode = &np->fwnode;
+	info.parent = core->dev;
+	info.name = np->name;
+	info.dma_mask = DMA_BIT_MASK(32);
+
+	pdev = platform_device_register_full(&info);
+	if (IS_ERR(pdev)) {
+		of_node_put(np);
+		return PTR_ERR(pdev);
+	}
+
+	pdev->dev.of_node = np;
+
+	ret = of_dma_configure(&pdev->dev, np, true);
+	if (ret) {
+		dev_err(core->dev, "dma configure fail\n");
+		goto err_unregister;
+	}
+
+	core->fw.dev = &pdev->dev;
+	core->no_tz = true;
+
+	of_node_put(np);
+
+	return 0;
+
+err_unregister:
+	platform_device_unregister(pdev);
+	of_node_put(np);
+	return ret;
+}
+
+void venus_firmware_deinit(struct venus_core *core)
+{
+	if (!core->fw.dev)
+		return;
+
+	platform_device_unregister(to_platform_device(core->fw.dev));
+}
diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
index 1343747..fd7edf0 100644
--- a/drivers/media/platform/qcom/venus/firmware.h
+++ b/drivers/media/platform/qcom/venus/firmware.h
@@ -16,6 +16,8 @@
 
 struct device;
 
+int venus_firmware_init(struct venus_core *core);
+void venus_firmware_deinit(struct venus_core *core);
 int venus_boot(struct venus_core *core);
 int venus_shutdown(struct device *dev);
 int venus_set_hw_state(struct venus_core *core, bool suspend);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
