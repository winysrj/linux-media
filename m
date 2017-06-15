Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:33654 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdFOQd2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 12:33:28 -0400
Received: by mail-wr0-f179.google.com with SMTP id r103so25475835wrb.0
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 09:33:27 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v11 18/19] media: venus: update firmware path with linux-firmware place
Date: Thu, 15 Jun 2017 19:31:59 +0300
Message-Id: <1497544320-2269-19-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes firmware name and path part of venus_resources
structure and initialize it properly depending on the SoC and
firmware version.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.c     | 6 ++++--
 drivers/media/platform/qcom/venus/core.h     | 1 +
 drivers/media/platform/qcom/venus/firmware.c | 9 ++++-----
 drivers/media/platform/qcom/venus/firmware.h | 3 ++-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 48391d87d5c3..776d2bae6979 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -84,7 +84,7 @@ static void venus_sys_error_handler(struct work_struct *work)
 
 	pm_runtime_get_sync(core->dev);
 
-	ret |= venus_boot(core->dev, &core->dev_fw);
+	ret |= venus_boot(core->dev, &core->dev_fw, core->res->fwname);
 
 	ret |= hfi_core_resume(core, true);
 
@@ -207,7 +207,7 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_runtime_disable;
 
-	ret = venus_boot(dev, &core->dev_fw);
+	ret = venus_boot(dev, &core->dev_fw, core->res->fwname);
 	if (ret)
 		goto err_runtime_disable;
 
@@ -335,6 +335,7 @@ static const struct venus_resources msm8916_res = {
 	.vmem_size = 0,
 	.vmem_addr = 0,
 	.dma_mask = 0xddc00000 - 1,
+	.fwname = "qcom/venus-1.8/venus.mdt",
 };
 
 static const struct freq_tbl msm8996_freq_table[] = {
@@ -363,6 +364,7 @@ static const struct venus_resources msm8996_res = {
 	.vmem_size = 0,
 	.vmem_addr = 0,
 	.dma_mask = 0xddc00000 - 1,
+	.fwname = "qcom/venus-4.2/venus.mdt",
 };
 
 static const struct of_device_id venus_dt_match[] = {
diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 2f8492090224..e542700eee32 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -48,6 +48,7 @@ struct venus_resources {
 	unsigned int vmem_id;
 	u32 vmem_size;
 	u32 vmem_addr;
+	const char *fwname;
 };
 
 struct venus_format {
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 365e64010920..1b1a4f355918 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -23,7 +23,6 @@
 
 #include "firmware.h"
 
-#define VENUS_FIRMWARE_NAME		"venus.mdt"
 #define VENUS_PAS_ID			9
 #define VENUS_FW_MEM_SIZE		SZ_8M
 
@@ -32,7 +31,7 @@ static void device_release_dummy(struct device *dev)
 	of_reserved_mem_device_release(dev);
 }
 
-int venus_boot(struct device *parent, struct device *fw_dev)
+int venus_boot(struct device *parent, struct device *fw_dev, const char *fwname)
 {
 	const struct firmware *mdt;
 	phys_addr_t mem_phys;
@@ -67,7 +66,7 @@ int venus_boot(struct device *parent, struct device *fw_dev)
 		goto err_unreg_device;
 	}
 
-	ret = request_firmware(&mdt, VENUS_FIRMWARE_NAME, fw_dev);
+	ret = request_firmware(&mdt, fwname, fw_dev);
 	if (ret < 0)
 		goto err_unreg_device;
 
@@ -78,8 +77,8 @@ int venus_boot(struct device *parent, struct device *fw_dev)
 		goto err_unreg_device;
 	}
 
-	ret = qcom_mdt_load(fw_dev, mdt, VENUS_FIRMWARE_NAME, VENUS_PAS_ID,
-			    mem_va, mem_phys, mem_size);
+	ret = qcom_mdt_load(fw_dev, mdt, fwname, VENUS_PAS_ID, mem_va, mem_phys,
+			    mem_size);
 
 	release_firmware(mdt);
 
diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
index 782e64ae291a..f81a98979798 100644
--- a/drivers/media/platform/qcom/venus/firmware.h
+++ b/drivers/media/platform/qcom/venus/firmware.h
@@ -16,7 +16,8 @@
 
 struct device;
 
-int venus_boot(struct device *parent, struct device *fw_dev);
+int venus_boot(struct device *parent, struct device *fw_dev,
+	       const char *fwname);
 int venus_shutdown(struct device *fw_dev);
 
 #endif
-- 
2.7.4
