Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53586 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbeINSkH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 14:40:07 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, arnd@arndb.de, bjorn.andersson@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
Subject: [PATCH v7 4/5] venus: firmware: add no TZ boot and shutdown routine
Date: Fri, 14 Sep 2018 18:54:36 +0530
Message-Id: <1536931477-13018-5-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1536931477-13018-1-git-send-email-vgarodia@codeaurora.org>
References: <1536931477-13018-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Video hardware is mainly comprised of vcodec subsystem and video
control subsystem. Video control has ARM9 which executes the video
firmware instructions whereas vcodec does the video frame processing.
This change adds support to load the video firmware and bring ARM9
out of reset for platforms which does not have trustzone.
An iommu domain is associated and managed with the firmware device.

Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
---
 drivers/media/platform/qcom/venus/core.c         |  6 +-
 drivers/media/platform/qcom/venus/core.h         |  1 +
 drivers/media/platform/qcom/venus/firmware.c     | 94 +++++++++++++++++++++++-
 drivers/media/platform/qcom/venus/firmware.h     |  2 +-
 drivers/media/platform/qcom/venus/hfi_venus_io.h |  1 +
 5 files changed, 97 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 440f25f..3bd3b8a 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -76,7 +76,7 @@ static void venus_sys_error_handler(struct work_struct *work)
 	hfi_core_deinit(core, true);
 	hfi_destroy(core);
 	mutex_lock(&core->lock);
-	venus_shutdown(core->dev);
+	venus_shutdown(core);
 
 	pm_runtime_put_sync(core->dev);
 
@@ -327,7 +327,7 @@ static int venus_probe(struct platform_device *pdev)
 err_core_deinit:
 	hfi_core_deinit(core, false);
 err_venus_shutdown:
-	venus_shutdown(dev);
+	venus_shutdown(core);
 err_runtime_disable:
 	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
@@ -348,7 +348,7 @@ static int venus_remove(struct platform_device *pdev)
 	WARN_ON(ret);
 
 	hfi_destroy(core);
-	venus_shutdown(dev);
+	venus_shutdown(core);
 	of_platform_depopulate(dev);
 
 	venus_firmware_deinit(core);
diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 3a53d5d..b9a9dc9 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -132,6 +132,7 @@ struct venus_core {
 	struct device *dev_enc;
 	struct video_firmware {
 	struct device *dev;
+	struct iommu_domain *iommu_domain;
 	} fw;
 	bool no_tz;
 	struct mutex lock;
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 69a99cd..badca87 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/firmware.h>
 #include <linux/kernel.h>
+#include <linux/iommu.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -122,6 +123,56 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 	return ret;
 }
 
+static int venus_boot_no_tz(struct venus_core *core, phys_addr_t mem_phys,
+			    size_t mem_size)
+{
+	struct iommu_domain *iommu;
+	struct device *dev;
+	int ret;
+
+	dev = core->fw.dev;
+	if (!dev)
+		return -EPROBE_DEFER;
+
+	iommu = core->fw.iommu_domain;
+
+	ret = iommu_map(iommu, VENUS_FW_START_ADDR, mem_phys, mem_size,
+			IOMMU_READ | IOMMU_WRITE | IOMMU_PRIV);
+	if (ret) {
+		dev_err(dev, "could not map video firmware region\n");
+		return ret;
+	}
+
+	venus_reset_cpu(core);
+
+	return 0;
+}
+
+static int venus_shutdown_no_tz(struct venus_core *core)
+{
+	struct iommu_domain *iommu;
+	size_t unmapped;
+	u32 reg;
+	struct device *dev = core->fw.dev;
+	void __iomem *base = core->base;
+
+	/* Assert the reset to ARM9 */
+	reg = readl_relaxed(base + WRAPPER_A9SS_SW_RESET);
+	reg |= WRAPPER_A9SS_SW_RESET_BIT;
+	writel_relaxed(reg, base + WRAPPER_A9SS_SW_RESET);
+
+	/* Make sure reset is asserted before the mapping is removed */
+	mb();
+
+	iommu = core->fw.iommu_domain;
+
+	unmapped = iommu_unmap(iommu, VENUS_FW_START_ADDR, VENUS_FW_MEM_SIZE);
+	if (unmapped != VENUS_FW_MEM_SIZE)
+		dev_err(dev, "failed to unmap firmware\n");
+
+	return 0;
+}
+
 int venus_boot(struct venus_core *core)
 {
 	struct device *dev = core->dev;
@@ -139,17 +190,30 @@ int venus_boot(struct venus_core *core)
 		return -EINVAL;
 	}
 
-	return qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
+	if (core->no_tz)
+		ret = venus_boot_no_tz(core, mem_phys, mem_size);
+	else
+		ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
+
+	return ret;
 }
 
-int venus_shutdown(struct device *dev)
+int venus_shutdown(struct venus_core *core)
 {
-	return qcom_scm_pas_shutdown(VENUS_PAS_ID);
+	int ret;
+
+	if (core->no_tz)
+		ret = venus_shutdown_no_tz(core);
+	else
+		ret = qcom_scm_pas_shutdown(VENUS_PAS_ID);
+
+	return ret;
 }
 
 int venus_firmware_init(struct venus_core *core)
 {
 	struct platform_device_info info;
+	struct iommu_domain *iommu_dom;
 	struct platform_device *pdev;
 	struct device_node *np;
 	int ret;
@@ -179,12 +243,29 @@ int venus_firmware_init(struct venus_core *core)
 	}
 
 	core->fw.dev = &pdev->dev;
+
+	iommu_dom = iommu_domain_alloc(&platform_bus_type);
+	if (!iommu_dom) {
+		dev_err(core->fw.dev, "Failed to allocate iommu domain\n");
+		ret = -ENOMEM;
+		goto err_unregister;
+	}
+
+	ret = iommu_attach_device(iommu_dom, core->fw.dev);
+	if (ret) {
+		dev_err(core->fw.dev, "could not attach device\n");
+		goto err_iommu_free;
+	}
+
 	core->no_tz = true;
+	core->fw.iommu_domain = iommu_dom;
 
 	of_node_put(np);
 
 	return 0;
 
+err_iommu_free:
+	iommu_domain_free(iommu_dom);
 err_unregister:
 	platform_device_unregister(pdev);
 	of_node_put(np);
@@ -193,8 +274,15 @@ int venus_firmware_init(struct venus_core *core)
 
 void venus_firmware_deinit(struct venus_core *core)
 {
+	struct iommu_domain *iommu;
+
 	if (!core->fw.dev)
 		return;
 
+	iommu = core->fw.iommu_domain;
+
+	iommu_detach_device(iommu, core->fw.dev);
+	iommu_domain_free(iommu);
+
 	platform_device_unregister(to_platform_device(core->fw.dev));
 }
diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
index fd7edf0..119a9a4 100644
--- a/drivers/media/platform/qcom/venus/firmware.h
+++ b/drivers/media/platform/qcom/venus/firmware.h
@@ -19,7 +19,7 @@
 int venus_firmware_init(struct venus_core *core);
 void venus_firmware_deinit(struct venus_core *core);
 int venus_boot(struct venus_core *core);
-int venus_shutdown(struct device *dev);
+int venus_shutdown(struct venus_core *core);
 int venus_set_hw_state(struct venus_core *core, bool suspend);
 
 static inline int venus_set_hw_state_suspend(struct venus_core *core)
diff --git a/drivers/media/platform/qcom/venus/hfi_venus_io.h b/drivers/media/platform/qcom/venus/hfi_venus_io.h
index 483348d..cf63864 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus_io.h
+++ b/drivers/media/platform/qcom/venus/hfi_venus_io.h
@@ -119,6 +119,7 @@
 #define WRAPPER_NP_START_ADDR			(WRAPPER_BASE + 0x1030)
 #define WRAPPER_NP_END_ADDR			(WRAPPER_BASE + 0x1034)
 #define WRAPPER_A9SS_SW_RESET			(WRAPPER_BASE + 0x3000)
+#define WRAPPER_A9SS_SW_RESET_BIT		BIT(4)
 
 /* Venus 4xx */
 #define WRAPPER_VCODEC0_MMCC_POWER_STATUS	(WRAPPER_BASE + 0x90)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
