Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60786 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751379AbeEQLdZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 07:33:25 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: hverkuil@xs4all.nl, mchehab@kernel.org, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        acourbot@google.com, Vikash Garodia <vgarodia@codeaurora.org>
Subject: [PATCH 4/4] media: venus: add PIL support
Date: Thu, 17 May 2018 17:02:20 +0530
Message-Id: <1526556740-25494-5-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
References: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support to load the video firmware
and bring ARM9 out of reset. This is useful
for platforms which does not have trustzone
to reset the ARM9.

Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
---
 .../devicetree/bindings/media/qcom,venus.txt       |   8 +-
 drivers/media/platform/qcom/venus/core.c           |  67 +++++++--
 drivers/media/platform/qcom/venus/core.h           |   6 +
 drivers/media/platform/qcom/venus/firmware.c       | 163 +++++++++++++++++----
 drivers/media/platform/qcom/venus/firmware.h       |  10 +-
 5 files changed, 217 insertions(+), 37 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
index 00d0d1b..0ff0f2d 100644
--- a/Documentation/devicetree/bindings/media/qcom,venus.txt
+++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
@@ -53,7 +53,7 @@
 
 * Subnodes
 The Venus video-codec node must contain two subnodes representing
-video-decoder and video-encoder.
+video-decoder and video-encoder, one optional firmware subnode.
 
 Every of video-encoder or video-decoder subnode should have:
 
@@ -79,6 +79,8 @@ Every of video-encoder or video-decoder subnode should have:
 		    power domain which is responsible for collapsing
 		    and restoring power to the subcore.
 
+The firmware sub node must contain the iommus specifiers for ARM9.
+
 * An Example
 	video-codec@1d00000 {
 		compatible = "qcom,msm8916-venus";
@@ -105,4 +107,8 @@ Every of video-encoder or video-decoder subnode should have:
 			clock-names = "core";
 			power-domains = <&mmcc VENUS_CORE1_GDSC>;
 		};
+		firmware {
+			compatible = "qcom,venus-pil-no-tz";
+			iommus = <&apps_smmu 0x10b2 0x0>;
+		}
 	};
diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 1308488..16910558 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/pm_runtime.h>
+#include <linux/iommu.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-ioctl.h>
@@ -30,6 +31,7 @@
 #include "vdec.h"
 #include "venc.h"
 #include "firmware.h"
+#include "hfi_venus.h"
 
 static void venus_event_notify(struct venus_core *core, u32 event)
 {
@@ -76,7 +78,7 @@ static void venus_sys_error_handler(struct work_struct *work)
 	hfi_core_deinit(core, true);
 	hfi_destroy(core);
 	mutex_lock(&core->lock);
-	venus_shutdown(core->dev);
+	venus_shutdown(core);
 
 	pm_runtime_put_sync(core->dev);
 
@@ -84,7 +86,7 @@ static void venus_sys_error_handler(struct work_struct *work)
 
 	pm_runtime_get_sync(core->dev);
 
-	ret |= venus_boot(core->dev, core->res->fwname);
+	ret |= venus_boot(core);
 
 	ret |= hfi_core_resume(core, true);
 
@@ -179,6 +181,20 @@ static u32 to_v4l2_codec_type(u32 codec)
 	}
 }
 
+static int store_firmware_dev(struct device *dev, void *data)
+{
+	struct venus_core *core;
+
+	core = (struct venus_core *)data;
+	if (!core)
+		return -EINVAL;
+
+	if (of_device_is_compatible(dev->of_node, "qcom,venus-pil-no-tz"))
+		core->fw.dev = dev;
+
+	return 0;
+}
+
 static int venus_enumerate_codecs(struct venus_core *core, u32 type)
 {
 	const struct hfi_inst_ops dummy_ops = {};
@@ -229,6 +245,7 @@ static int venus_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct venus_core *core;
 	struct resource *r;
+	struct iommu_domain *iommu_domain;
 	int ret;
 
 	core = devm_kzalloc(dev, sizeof(*core), GFP_KERNEL);
@@ -279,7 +296,14 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_runtime_disable;
 
-	ret = venus_boot(dev, core->res->fwname);
+	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+	if (ret)
+		goto err_runtime_disable;
+
+	/* Attempt to register child devices */
+	ret = device_for_each_child(dev, core, store_firmware_dev);
+
+	ret = venus_boot(core);
 	if (ret)
 		goto err_runtime_disable;
 
@@ -303,14 +327,17 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_core_deinit;
 
-	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+	ret = pm_runtime_put_sync(dev);
 	if (ret)
 		goto err_dev_unregister;
 
-	ret = pm_runtime_put_sync(dev);
-	if (ret)
+	iommu_domain = iommu_get_domain_for_dev(dev);
+	if (!iommu_domain)
 		goto err_dev_unregister;
 
+	iommu_domain->geometry.aperture_start = VENUS_FW_MEM_SIZE;
+	iommu_domain->geometry.aperture_end = VENUS_MAX_MEM_REGION;
+
 	return 0;
 
 err_dev_unregister:
@@ -318,7 +345,7 @@ static int venus_probe(struct platform_device *pdev)
 err_core_deinit:
 	hfi_core_deinit(core, false);
 err_venus_shutdown:
-	venus_shutdown(dev);
+	venus_shutdown(core);
 err_runtime_disable:
 	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
@@ -339,7 +366,7 @@ static int venus_remove(struct platform_device *pdev)
 	WARN_ON(ret);
 
 	hfi_destroy(core);
-	venus_shutdown(dev);
+	venus_shutdown(core);
 	of_platform_depopulate(dev);
 
 	pm_runtime_put_sync(dev);
@@ -483,7 +510,29 @@ static __maybe_unused int venus_runtime_resume(struct device *dev)
 		.pm = &venus_pm_ops,
 	},
 };
-module_platform_driver(qcom_venus_driver);
+
+static int __init venus_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&qcom_video_firmware_driver);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&qcom_venus_driver);
+	if (ret)
+		platform_driver_unregister(&qcom_video_firmware_driver);
+
+	return ret;
+}
+module_init(venus_init);
+
+static void __exit venus_exit(void)
+{
+	platform_driver_unregister(&qcom_venus_driver);
+	platform_driver_unregister(&qcom_video_firmware_driver);
+}
+module_exit(venus_exit);
 
 MODULE_ALIAS("platform:qcom-venus");
 MODULE_DESCRIPTION("Qualcomm Venus video encoder and decoder driver");
diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 85e66e2..68fc8af 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -80,6 +80,11 @@ struct venus_caps {
 	bool valid;
 };
 
+struct video_firmware {
+	struct device *dev;
+	dma_addr_t iova;
+	struct iommu_domain *iommu_domain;
+};
 /**
  * struct venus_core - holds core parameters valid for all instances
  *
@@ -124,6 +129,7 @@ struct venus_core {
 	struct device *dev;
 	struct device *dev_dec;
 	struct device *dev_enc;
+	struct video_firmware fw;
 	struct mutex lock;
 	struct list_head instances;
 	atomic_t insts_count;
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 8f25375..614c805 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -12,8 +12,12 @@
  *
  */
 
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
+#include <linux/iommu.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/io.h>
@@ -27,8 +31,10 @@
 #include "firmware.h"
 #include "hfi_venus_io.h"
 
-#define VENUS_PAS_ID			9
-#define VENUS_FW_MEM_SIZE		(6 * SZ_1M)
+static const struct of_device_id firmware_dt_match[] = {
+	{ .compatible = "qcom,venus-pil-no-tz" },
+	{ }
+};
 
 void venus_reset_hw(struct venus_core *core)
 {
@@ -53,40 +59,37 @@ void venus_reset_hw(struct venus_core *core)
 	/* Bring Arm9 out of reset */
 	writel_relaxed(0, reg_base + WRAPPER_A9SS_SW_RESET);
 }
-int venus_boot(struct device *dev, const char *fwname)
+EXPORT_SYMBOL_GPL(venus_reset_hw);
+
+int venus_load_fw(struct device *dev, const char *fwname,
+		phys_addr_t *mem_phys, size_t *mem_size)
 {
 	const struct firmware *mdt;
 	struct device_node *node;
-	phys_addr_t mem_phys;
 	struct resource r;
 	ssize_t fw_size;
-	size_t mem_size;
 	void *mem_va;
 	int ret;
 
-	if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) || !qcom_scm_is_available())
-		return -EPROBE_DEFER;
-
 	node = of_parse_phandle(dev->of_node, "memory-region", 0);
 	if (!node) {
 		dev_err(dev, "no memory-region specified\n");
 		return -EINVAL;
 	}
-
 	ret = of_address_to_resource(node, 0, &r);
 	if (ret)
 		return ret;
 
-	mem_phys = r.start;
-	mem_size = resource_size(&r);
+	*mem_phys = r.start;
+	*mem_size = resource_size(&r);
 
-	if (mem_size < VENUS_FW_MEM_SIZE)
+	if (*mem_size < VENUS_FW_MEM_SIZE)
 		return -EINVAL;
 
-	mem_va = memremap(r.start, mem_size, MEMREMAP_WC);
+	mem_va = memremap(r.start, *mem_size, MEMREMAP_WC);
 	if (!mem_va) {
 		dev_err(dev, "unable to map memory region: %pa+%zx\n",
-			&r.start, mem_size);
+			&r.start, *mem_size);
 		return -ENOMEM;
 	}
 
@@ -101,24 +104,134 @@ int venus_boot(struct device *dev, const char *fwname)
 		goto err_unmap;
 	}
 
-	ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va, mem_phys,
-			    mem_size, NULL);
+	ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va, *mem_phys,
+			    *mem_size, NULL);
 
 	release_firmware(mdt);
 
-	if (ret)
-		goto err_unmap;
-
-	ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
-	if (ret)
-		goto err_unmap;
-
 err_unmap:
 	memunmap(mem_va);
 	return ret;
 }
 
-int venus_shutdown(struct device *dev)
+int venus_boot_noTZ(struct venus_core *core, phys_addr_t mem_phys,
+							size_t mem_size)
 {
-	return qcom_scm_pas_shutdown(VENUS_PAS_ID);
+	struct iommu_domain *iommu;
+	struct device *dev;
+	int ret;
+
+	if (!core->fw.dev)
+		return -EPROBE_DEFER;
+
+	dev = core->fw.dev;
+
+	iommu = iommu_domain_alloc(&platform_bus_type);
+	if (!iommu) {
+		dev_err(dev, "Failed to allocate iommu domain\n");
+		return -ENOMEM;
+	}
+
+	iommu->geometry.aperture_start = 0x0;
+	iommu->geometry.aperture_end = VENUS_FW_MEM_SIZE;
+
+	ret = iommu_attach_device(iommu, dev);
+	if (ret) {
+		dev_err(dev, "could not attach device\n");
+		goto err_attach;
+	}
+
+	ret = iommu_map(iommu, core->fw.iova, mem_phys, mem_size,
+			IOMMU_READ|IOMMU_WRITE|IOMMU_PRIV);
+	if (ret) {
+		dev_err(dev, "could not map video firmware region\n");
+		goto err_map;
+	}
+	core->fw.iommu_domain = iommu;
+	venus_reset_hw(core);
+
+	return 0;
+
+err_map:
+	iommu_detach_device(iommu, dev);
+err_attach:
+	iommu_domain_free(iommu);
+	return ret;
 }
+
+int venus_shutdown_noTZ(struct venus_core *core)
+{
+	struct iommu_domain *iommu;
+	u32 reg;
+	struct device *dev = core->fw.dev;
+	void __iomem *reg_base = core->base;
+
+	/* Assert the reset to ARM9 */
+	reg = readl_relaxed(reg_base + WRAPPER_A9SS_SW_RESET);
+	reg |= BIT(4);
+	writel_relaxed(reg, reg_base + WRAPPER_A9SS_SW_RESET);
+
+	/* Make sure reset is asserted before the mapping is removed */
+	mb();
+
+	iommu = core->fw.iommu_domain;
+
+	iommu_unmap(iommu, core->fw.iova, VENUS_FW_MEM_SIZE);
+	iommu_detach_device(iommu, dev);
+	iommu_domain_free(iommu);
+
+	return 0;
+}
+
+int venus_boot(struct venus_core *core)
+{
+	phys_addr_t mem_phys;
+	size_t mem_size;
+	int ret;
+	struct device *dev;
+
+	if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER))
+		return -EPROBE_DEFER;
+
+	dev = core->dev;
+
+	ret = venus_load_fw(dev, core->res->fwname, &mem_phys, &mem_size);
+	if (ret) {
+		dev_err(dev, "fail to load video firmware\n");
+		return -EINVAL;
+	}
+
+	if (qcom_scm_is_available())
+		ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
+	else
+		ret = venus_boot_noTZ(core, mem_phys, mem_size);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(venus_boot);
+
+int venus_shutdown(struct venus_core *core)
+{
+	int ret = 0;
+
+	if (qcom_scm_is_available())
+		qcom_scm_pas_shutdown(VENUS_PAS_ID);
+	else
+		ret = venus_shutdown_noTZ(core);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(venus_shutdown);
+
+MODULE_DEVICE_TABLE(of, firmware_dt_match);
+
+struct platform_driver qcom_video_firmware_driver = {
+	.driver = {
+			.name = "qcom-video-firmware",
+			.of_match_table = firmware_dt_match,
+	},
+};
+
+MODULE_ALIAS("platform:qcom-video-firmware");
+MODULE_DESCRIPTION("Qualcomm Venus firmware driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
index d56f5b2..bce8f0a 100644
--- a/drivers/media/platform/qcom/venus/firmware.h
+++ b/drivers/media/platform/qcom/venus/firmware.h
@@ -14,10 +14,16 @@
 #ifndef __VENUS_FIRMWARE_H__
 #define __VENUS_FIRMWARE_H__
 
+#define VENUS_PAS_ID			9
+#define VENUS_FW_MEM_SIZE		(6 * SZ_1M)
+#define VENUS_MAX_MEM_REGION	0xE0000000
+
 struct device;
 
-int venus_boot(struct device *dev, const char *fwname);
-int venus_shutdown(struct device *dev);
+extern struct platform_driver qcom_video_firmware_driver;
+
+int venus_boot(struct venus_core *core);
+int venus_shutdown(struct venus_core *core);
 void venus_reset_hw(struct venus_core *core);
 
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
