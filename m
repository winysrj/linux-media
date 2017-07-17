Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:34556 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdGQI6a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 04:58:30 -0400
Received: by mail-wm0-f43.google.com with SMTP id 70so20747537wmo.1
        for <linux-media@vger.kernel.org>; Mon, 17 Jul 2017 01:58:30 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 2/4] media: venus: don't abuse dma_alloc for non-DMA allocations
Date: Mon, 17 Jul 2017 11:56:48 +0300
Message-Id: <20170717085650.12185-3-stanimir.varbanov@linaro.org>
In-Reply-To: <20170717085650.12185-1-stanimir.varbanov@linaro.org>
References: <20170717085650.12185-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In venus_boot(), we pass a pointer to a phys_addr_t
into dmam_alloc_coherent, which the compiler warns about:

platform/qcom/venus/firmware.c: In function 'venus_boot':
platform/qcom/venus/firmware.c:63:49: error: passing argument 3 of 'dmam_alloc_coherent' from incompatible pointer type [-Werror=incompatible-pointer-types]

To avoid the error refactor venus_boot function by discard
dma_alloc_coherent usage because we don't want to map the
memory for the device. The meaning of venus_boot is to
copy the content of the firmware buffer into the reserved
(and memblock removed) block of memory and pass the physical
address to the remote processor.

Now we parse memory-region property by hand and memremap
the physical address to CPU, call mdt_load to load firmware
segments into proper places and unmap reserved memory.

Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.c     | 10 ++--
 drivers/media/platform/qcom/venus/core.h     |  1 -
 drivers/media/platform/qcom/venus/firmware.c | 74 ++++++++++++----------------
 drivers/media/platform/qcom/venus/firmware.h |  5 +-
 4 files changed, 39 insertions(+), 51 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 694f57a78288..a70368cb713f 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -76,7 +76,7 @@ static void venus_sys_error_handler(struct work_struct *work)
 	hfi_core_deinit(core, true);
 	hfi_destroy(core);
 	mutex_lock(&core->lock);
-	venus_shutdown(&core->dev_fw);
+	venus_shutdown(core->dev);
 
 	pm_runtime_put_sync(core->dev);
 
@@ -84,7 +84,7 @@ static void venus_sys_error_handler(struct work_struct *work)
 
 	pm_runtime_get_sync(core->dev);
 
-	ret |= venus_boot(core->dev, &core->dev_fw, core->res->fwname);
+	ret |= venus_boot(core->dev, core->res->fwname);
 
 	ret |= hfi_core_resume(core, true);
 
@@ -207,7 +207,7 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_runtime_disable;
 
-	ret = venus_boot(dev, &core->dev_fw, core->res->fwname);
+	ret = venus_boot(dev, core->res->fwname);
 	if (ret)
 		goto err_runtime_disable;
 
@@ -238,7 +238,7 @@ static int venus_probe(struct platform_device *pdev)
 err_core_deinit:
 	hfi_core_deinit(core, false);
 err_venus_shutdown:
-	venus_shutdown(&core->dev_fw);
+	venus_shutdown(dev);
 err_runtime_disable:
 	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
@@ -259,7 +259,7 @@ static int venus_remove(struct platform_device *pdev)
 	WARN_ON(ret);
 
 	hfi_destroy(core);
-	venus_shutdown(&core->dev_fw);
+	venus_shutdown(dev);
 	of_platform_depopulate(dev);
 
 	pm_runtime_put_sync(dev);
diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index e542700eee32..cba092bcb76d 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -101,7 +101,6 @@ struct venus_core {
 	struct device *dev;
 	struct device *dev_dec;
 	struct device *dev_enc;
-	struct device dev_fw;
 	struct mutex lock;
 	struct list_head instances;
 	atomic_t insts_count;
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 1b1a4f355918..d6d9560c1c19 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -12,29 +12,27 @@
  *
  */
 
-#include <linux/dma-mapping.h>
+#include <linux/device.h>
 #include <linux/firmware.h>
 #include <linux/kernel.h>
+#include <linux/io.h>
 #include <linux/of.h>
-#include <linux/of_reserved_mem.h>
-#include <linux/slab.h>
+#include <linux/of_address.h>
 #include <linux/qcom_scm.h>
+#include <linux/sizes.h>
 #include <linux/soc/qcom/mdt_loader.h>
 
 #include "firmware.h"
 
 #define VENUS_PAS_ID			9
-#define VENUS_FW_MEM_SIZE		SZ_8M
+#define VENUS_FW_MEM_SIZE		(6 * SZ_1M)
 
-static void device_release_dummy(struct device *dev)
-{
-	of_reserved_mem_device_release(dev);
-}
-
-int venus_boot(struct device *parent, struct device *fw_dev, const char *fwname)
+int venus_boot(struct device *dev, const char *fwname)
 {
 	const struct firmware *mdt;
+	struct device_node *node;
 	phys_addr_t mem_phys;
+	struct resource r;
 	ssize_t fw_size;
 	size_t mem_size;
 	void *mem_va;
@@ -43,66 +41,58 @@ int venus_boot(struct device *parent, struct device *fw_dev, const char *fwname)
 	if (!qcom_scm_is_available())
 		return -EPROBE_DEFER;
 
-	fw_dev->parent = parent;
-	fw_dev->release = device_release_dummy;
+	node = of_parse_phandle(dev->of_node, "memory-region", 0);
+	if (!node) {
+		dev_err(dev, "no memory-region specified\n");
+		return -EINVAL;
+	}
 
-	ret = dev_set_name(fw_dev, "%s:%s", dev_name(parent), "firmware");
+	ret = of_address_to_resource(node, 0, &r);
 	if (ret)
 		return ret;
 
-	ret = device_register(fw_dev);
-	if (ret < 0)
-		return ret;
+	mem_phys = r.start;
+	mem_size = resource_size(&r);
 
-	ret = of_reserved_mem_device_init_by_idx(fw_dev, parent->of_node, 0);
-	if (ret)
-		goto err_unreg_device;
+	if (mem_size < VENUS_FW_MEM_SIZE)
+		return -EINVAL;
 
-	mem_size = VENUS_FW_MEM_SIZE;
-
-	mem_va = dmam_alloc_coherent(fw_dev, mem_size, &mem_phys, GFP_KERNEL);
+	mem_va = memremap(r.start, mem_size, MEMREMAP_WC);
 	if (!mem_va) {
-		ret = -ENOMEM;
-		goto err_unreg_device;
+		dev_err(dev, "unable to map memory region: %pa+%zx\n",
+			&r.start, mem_size);
+		return -ENOMEM;
 	}
 
-	ret = request_firmware(&mdt, fwname, fw_dev);
+	ret = request_firmware(&mdt, fwname, dev);
 	if (ret < 0)
-		goto err_unreg_device;
+		goto err_unmap;
 
 	fw_size = qcom_mdt_get_size(mdt);
 	if (fw_size < 0) {
 		ret = fw_size;
 		release_firmware(mdt);
-		goto err_unreg_device;
+		goto err_unmap;
 	}
 
-	ret = qcom_mdt_load(fw_dev, mdt, fwname, VENUS_PAS_ID, mem_va, mem_phys,
+	ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va, mem_phys,
 			    mem_size);
 
 	release_firmware(mdt);
 
 	if (ret)
-		goto err_unreg_device;
+		goto err_unmap;
 
 	ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
 	if (ret)
-		goto err_unreg_device;
-
-	return 0;
+		goto err_unmap;
 
-err_unreg_device:
-	device_unregister(fw_dev);
+err_unmap:
+	memunmap(mem_va);
 	return ret;
 }
 
-int venus_shutdown(struct device *fw_dev)
+int venus_shutdown(struct device *dev)
 {
-	int ret;
-
-	ret = qcom_scm_pas_shutdown(VENUS_PAS_ID);
-	device_unregister(fw_dev);
-	memset(fw_dev, 0, sizeof(*fw_dev));
-
-	return ret;
+	return qcom_scm_pas_shutdown(VENUS_PAS_ID);
 }
diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
index f81a98979798..428efb56d339 100644
--- a/drivers/media/platform/qcom/venus/firmware.h
+++ b/drivers/media/platform/qcom/venus/firmware.h
@@ -16,8 +16,7 @@
 
 struct device;
 
-int venus_boot(struct device *parent, struct device *fw_dev,
-	       const char *fwname);
-int venus_shutdown(struct device *fw_dev);
+int venus_boot(struct device *dev, const char *fwname);
+int venus_shutdown(struct device *dev);
 
 #endif
-- 
2.11.0
