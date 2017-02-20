Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21520 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753039AbdBTNjT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 08:39:19 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v2 07/15] media: s5p-mfc: Put firmware to private buffer
 structure
Date: Mon, 20 Feb 2017 14:38:56 +0100
Message-id: <1487597944-2000-8-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1487597944-2000-1-git-send-email-m.szyprowski@samsung.com>
References: <1487597944-2000-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170220133914eucas1p1745bc1bb6a62938ed3cc6d9998bb0102@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use s5p_mfc_priv_buf structure for keeping the firmware image. This will
help handling of firmware buffer allocation in the next patches.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  3 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   | 36 ++++++++++++-------------
 3 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
index 8c4739ca16d6..4c80bb4243be 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
@@ -47,7 +47,7 @@ static int s5p_mfc_sys_init_cmd_v5(struct s5p_mfc_dev *dev)
 	struct s5p_mfc_cmd_args h2r_args;
 
 	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
-	h2r_args.arg[0] = dev->fw_size;
+	h2r_args.arg[0] = dev->fw_buf.size;
 	return s5p_mfc_cmd_host2risc_v5(dev, S5P_FIMV_H2R_CMD_SYS_INIT,
 			&h2r_args);
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 9cf860f34c71..cea17a737ef7 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -314,8 +314,7 @@ struct s5p_mfc_dev {
 	int int_type;
 	unsigned int int_err;
 	wait_queue_head_t queue;
-	size_t fw_size;
-	void *fw_virt_addr;
+	struct s5p_mfc_priv_buf fw_buf;
 	dma_addr_t dma_base[BANK_CTX_NUM];
 	unsigned long hw_lock;
 	struct s5p_mfc_ctx *ctx[MFC_NUM_CONTEXTS];
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index c9bff3d0655f..50d698968049 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -29,21 +29,22 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 	void *bank2_virt;
 	dma_addr_t bank2_dma_addr;
 	unsigned int align_size = 1 << MFC_BASE_ALIGN_ORDER;
+	struct s5p_mfc_priv_buf *fw_buf = &dev->fw_buf;
 
-	dev->fw_size = dev->variant->buf_size->fw;
+	fw_buf->size = dev->variant->buf_size->fw;
 
-	if (dev->fw_virt_addr) {
+	if (fw_buf->virt) {
 		mfc_err("Attempting to allocate firmware when it seems that it is already loaded\n");
 		return -ENOMEM;
 	}
 
-	dev->fw_virt_addr = dma_alloc_coherent(dev->mem_dev[BANK1_CTX],
-					dev->fw_size, &dev->dma_base[BANK1_CTX],
-					GFP_KERNEL);
-	if (!dev->fw_virt_addr) {
+	fw_buf->virt = dma_alloc_coherent(dev->mem_dev[BANK1_CTX], fw_buf->size,
+					 &fw_buf->dma, GFP_KERNEL);
+	if (!fw_buf->virt) {
 		mfc_err("Allocating bitprocessor buffer failed\n");
 		return -ENOMEM;
 	}
+	dev->dma_base[BANK1_CTX] = fw_buf->dma;
 
 	if (HAS_PORTNUM(dev) && IS_TWOPORT(dev)) {
 		bank2_virt = dma_alloc_coherent(dev->mem_dev[BANK2_CTX],
@@ -51,10 +52,9 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 
 		if (!bank2_virt) {
 			mfc_err("Allocating bank2 base failed\n");
-			dma_free_coherent(dev->mem_dev[BANK1_CTX], dev->fw_size,
-					  dev->fw_virt_addr,
-					  dev->dma_base[BANK1_CTX]);
-			dev->fw_virt_addr = NULL;
+			dma_free_coherent(dev->mem_dev[BANK1_CTX], fw_buf->size,
+					  fw_buf->virt, fw_buf->dma);
+			fw_buf->virt = NULL;
 			return -ENOMEM;
 		}
 
@@ -101,17 +101,17 @@ int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
 		mfc_err("Firmware is not present in the /lib/firmware directory nor compiled in kernel\n");
 		return -EINVAL;
 	}
-	if (fw_blob->size > dev->fw_size) {
+	if (fw_blob->size > dev->fw_buf.size) {
 		mfc_err("MFC firmware is too big to be loaded\n");
 		release_firmware(fw_blob);
 		return -ENOMEM;
 	}
-	if (!dev->fw_virt_addr) {
+	if (!dev->fw_buf.virt) {
 		mfc_err("MFC firmware is not allocated\n");
 		release_firmware(fw_blob);
 		return -EINVAL;
 	}
-	memcpy(dev->fw_virt_addr, fw_blob->data, fw_blob->size);
+	memcpy(dev->fw_buf.virt, fw_blob->data, fw_blob->size);
 	wmb();
 	release_firmware(fw_blob);
 	mfc_debug_leave();
@@ -123,11 +123,11 @@ int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
 {
 	/* Before calling this function one has to make sure
 	 * that MFC is no longer processing */
-	if (!dev->fw_virt_addr)
+	if (!dev->fw_buf.virt)
 		return -EINVAL;
-	dma_free_coherent(dev->mem_dev[BANK1_CTX], dev->fw_size,
-			  dev->fw_virt_addr, dev->dma_base[BANK1_CTX]);
-	dev->fw_virt_addr = NULL;
+	dma_free_coherent(dev->mem_dev[BANK1_CTX], dev->fw_buf.size,
+			  dev->fw_buf.virt, dev->fw_buf.dma);
+	dev->fw_buf.virt = NULL;
 	return 0;
 }
 
@@ -246,7 +246,7 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	int ret;
 
 	mfc_debug_enter();
-	if (!dev->fw_virt_addr) {
+	if (!dev->fw_buf.virt) {
 		mfc_err("Firmware memory is not allocated.\n");
 		return -EINVAL;
 	}
-- 
1.9.1
