Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:54835 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3ACLGQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 06:06:16 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG100HUGQU6CKX0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Jan 2013 20:06:15 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MG100FOEQU7KHB0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Jan 2013 20:06:14 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/3 RESEND] s5p-mfc: Move firmware allocation point to avoid
 allocation problems
Date: Thu, 03 Jan 2013 12:06:02 +0100
Message-id: <1357211164-27443-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move firmware allocation from open to probe to avoid problems
when using CMA for allocation. In certain circumstances CMA may allocate
buffer that is not in the beginning of the MFC memory area.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   29 +++--
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   10 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |  149 +++++++++++------------
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h   |    3 +-
 4 files changed, 94 insertions(+), 97 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 3afe879..3c35be7 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -791,14 +791,16 @@ static int s5p_mfc_open(struct file *file)
 			goto err_pwr_enable;
 		}
 		s5p_mfc_clock_on();
-		ret = s5p_mfc_alloc_and_load_firmware(dev);
-		if (ret)
-			goto err_alloc_fw;
+		ret = s5p_mfc_load_firmware(dev);
+		if (ret) {
+			s5p_mfc_clock_off();
+			goto err_load_fw;
+		}
 		/* Init the FW */
 		ret = s5p_mfc_init_hw(dev);
+		s5p_mfc_clock_off();
 		if (ret)
 			goto err_init_hw;
-		s5p_mfc_clock_off();
 	}
 	/* Init videobuf2 queue for CAPTURE */
 	q = &ctx->vq_dst;
@@ -847,17 +849,16 @@ static int s5p_mfc_open(struct file *file)
 	return ret;
 	/* Deinit when failure occured */
 err_queue_init:
+	if (dev->num_inst == 1)
+		s5p_mfc_deinit_hw(dev);
 err_init_hw:
-	s5p_mfc_release_firmware(dev);
-err_alloc_fw:
+err_load_fw:
 	dev->ctx[ctx->num] = NULL;
 	del_timer_sync(&dev->watchdog_timer);
-	s5p_mfc_clock_off();
 err_pwr_enable:
 	if (dev->num_inst == 1) {
 		if (s5p_mfc_power_off() < 0)
 			mfc_err("power off failed\n");
-		s5p_mfc_release_firmware(dev);
 	}
 err_ctrls_setup:
 	s5p_mfc_dec_ctrls_delete(ctx);
@@ -915,11 +916,8 @@ static int s5p_mfc_release(struct file *file)
 		clear_bit(0, &dev->hw_lock);
 	dev->num_inst--;
 	if (dev->num_inst == 0) {
-		mfc_debug(2, "Last instance - release firmware\n");
-		/* reset <-> F/W release */
-		s5p_mfc_reset(dev);
+		mfc_debug(2, "Last instance\n");
 		s5p_mfc_deinit_hw(dev);
-		s5p_mfc_release_firmware(dev);
 		del_timer_sync(&dev->watchdog_timer);
 		if (s5p_mfc_power_off() < 0)
 			mfc_err("Power off failed\n");
@@ -1110,6 +1108,10 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 
 	mutex_init(&dev->mfc_mutex);
 
+	ret = s5p_mfc_alloc_firmware(dev);
+	if (ret)
+		goto err_alloc_fw;
+
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		goto err_v4l2_dev_reg;
@@ -1191,6 +1193,8 @@ err_dec_reg:
 err_dec_alloc:
 	v4l2_device_unregister(&dev->v4l2_dev);
 err_v4l2_dev_reg:
+	s5p_mfc_release_firmware(dev);
+err_alloc_fw:
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
 err_mem_init_ctx_1:
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
@@ -1216,6 +1220,7 @@ static int __devexit s5p_mfc_remove(struct platform_device *pdev)
 	video_unregister_device(dev->vfd_enc);
 	video_unregister_device(dev->vfd_dec);
 	v4l2_device_unregister(&dev->v4l2_dev);
+	s5p_mfc_release_firmware(dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index f02e049..2298d27 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -277,8 +277,9 @@ struct s5p_mfc_priv_buf {
  * @int_err:		error number for last interrupt
  * @queue:		waitqueue for waiting for completion of device commands
  * @fw_size:		size of firmware
- * @bank1:		address of the beggining of bank 1 memory
- * @bank2:		address of the beggining of bank 2 memory
+ * @fw_virt_addr:	virtual firmware address
+ * @bank1:		address of the beginning of bank 1 memory
+ * @bank2:		address of the beginning of bank 2 memory
  * @hw_lock:		used for hardware locking
  * @ctx:		array of driver contexts
  * @curr_ctx:		number of the currently running context
@@ -317,8 +318,9 @@ struct s5p_mfc_dev {
 	unsigned int int_err;
 	wait_queue_head_t queue;
 	size_t fw_size;
-	size_t bank1;
-	size_t bank2;
+	void *fw_virt_addr;
+	dma_addr_t bank1;
+	dma_addr_t bank2;
 	unsigned long hw_lock;
 	struct s5p_mfc_ctx *ctx[MFC_NUM_CONTEXTS];
 	int curr_ctx;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 585b7b0e..ca95a93 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -22,16 +22,64 @@
 #include "s5p_mfc_opr.h"
 #include "s5p_mfc_pm.h"
 
-static void *s5p_mfc_bitproc_buf;
-static size_t s5p_mfc_bitproc_phys;
-static unsigned char *s5p_mfc_bitproc_virt;
+/* Allocate memory for firmware */
+int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
+{
+	void *bank2_virt;
+	dma_addr_t bank2_dma_addr;
+
+	dev->fw_size = dev->variant->buf_size->fw;
+
+	if (dev->fw_virt_addr) {
+		mfc_err("Attempting to allocate firmware when it seems that it is already loaded\n");
+		return -ENOMEM;
+	}
+
+	dev->fw_virt_addr = dma_alloc_coherent(dev->mem_dev_l, dev->fw_size,
+					&dev->bank1, GFP_KERNEL);
+
+	if (IS_ERR(dev->fw_virt_addr)) {
+		dev->fw_virt_addr = NULL;
+		mfc_err("Allocating bitprocessor buffer failed\n");
+		return -ENOMEM;
+	}
+
+	dev->bank1 = dev->bank1;
+
+	if (HAS_PORTNUM(dev) && IS_TWOPORT(dev)) {
+		bank2_virt = dma_alloc_coherent(dev->mem_dev_r, 1 << MFC_BASE_ALIGN_ORDER,
+					&bank2_dma_addr, GFP_KERNEL);
+
+		if (IS_ERR(dev->fw_virt_addr)) {
+			mfc_err("Allocating bank2 base failed\n");
+			dma_free_coherent(dev->mem_dev_l, dev->fw_size,
+				dev->fw_virt_addr, dev->bank1);
+			dev->fw_virt_addr = NULL;
+			return -ENOMEM;
+		}
+
+		/* Valid buffers passed to MFC encoder with LAST_FRAME command
+		 * should not have address of bank2 - MFC will treat it as a null frame.
+		 * To avoid such situation we set bank2 address below the pool address.
+		 */
+		dev->bank2 = bank2_dma_addr - (1 << MFC_BASE_ALIGN_ORDER);
+
+		dma_free_coherent(dev->mem_dev_r, 1 << MFC_BASE_ALIGN_ORDER,
+			bank2_virt, bank2_dma_addr);
+
+	} else {
+		/* In this case bank2 can point to the same address as bank1.
+		 * Firmware will always occupy the beggining of this area so it is 
+		 * impossible having a video frame buffer with zero address. */
+		dev->bank2 = dev->bank1;
+	}
+	return 0;
+}
 
-/* Allocate and load firmware */
-int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
+/* Load firmware */
+int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
 {
 	struct firmware *fw_blob;
-	size_t bank2_base_phys;
-	void *b_base;
 	int err;
 
 	/* Firmare has to be present as a separate file or compiled
@@ -44,77 +92,17 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 		mfc_err("Firmware is not present in the /lib/firmware directory nor compiled in kernel\n");
 		return -EINVAL;
 	}
-	dev->fw_size = dev->variant->buf_size->fw;
 	if (fw_blob->size > dev->fw_size) {
 		mfc_err("MFC firmware is too big to be loaded\n");
 		release_firmware(fw_blob);
 		return -ENOMEM;
 	}
-	if (s5p_mfc_bitproc_buf) {
-		mfc_err("Attempting to allocate firmware when it seems that it is already loaded\n");
-		release_firmware(fw_blob);
-		return -ENOMEM;
-	}
-	s5p_mfc_bitproc_buf = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], dev->fw_size);
-	if (IS_ERR(s5p_mfc_bitproc_buf)) {
-		s5p_mfc_bitproc_buf = NULL;
-		mfc_err("Allocating bitprocessor buffer failed\n");
+	if (!dev->fw_virt_addr) {
+		mfc_err("MFC firmware is not allocated\n");
 		release_firmware(fw_blob);
-		return -ENOMEM;
-	}
-	s5p_mfc_bitproc_phys = s5p_mfc_mem_cookie(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], s5p_mfc_bitproc_buf);
-	if (s5p_mfc_bitproc_phys & ((1 << MFC_BASE_ALIGN_ORDER) - 1)) {
-		mfc_err("The base memory for bank 1 is not aligned to 128KB\n");
-		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
-		s5p_mfc_bitproc_phys = 0;
-		s5p_mfc_bitproc_buf = NULL;
-		release_firmware(fw_blob);
-		return -EIO;
-	}
-	s5p_mfc_bitproc_virt = vb2_dma_contig_memops.vaddr(s5p_mfc_bitproc_buf);
-	if (!s5p_mfc_bitproc_virt) {
-		mfc_err("Bitprocessor memory remap failed\n");
-		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
-		s5p_mfc_bitproc_phys = 0;
-		s5p_mfc_bitproc_buf = NULL;
-		release_firmware(fw_blob);
-		return -EIO;
-	}
-	dev->bank1 = s5p_mfc_bitproc_phys;
-	if (HAS_PORTNUM(dev) && IS_TWOPORT(dev)) {
-		b_base = vb2_dma_contig_memops.alloc(
-			dev->alloc_ctx[MFC_BANK2_ALLOC_CTX],
-			1 << MFC_BASE_ALIGN_ORDER);
-		if (IS_ERR(b_base)) {
-			vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
-			s5p_mfc_bitproc_phys = 0;
-			s5p_mfc_bitproc_buf = NULL;
-			mfc_err("Allocating bank2 base failed\n");
-			release_firmware(fw_blob);
-			return -ENOMEM;
-		}
-		bank2_base_phys = s5p_mfc_mem_cookie(
-			dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], b_base);
-		vb2_dma_contig_memops.put(b_base);
-		if (bank2_base_phys & ((1 << MFC_BASE_ALIGN_ORDER) - 1)) {
-			mfc_err("The base memory for bank 2 is not aligned to 128KB\n");
-			vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
-			s5p_mfc_bitproc_phys = 0;
-			s5p_mfc_bitproc_buf = NULL;
-			release_firmware(fw_blob);
-			return -EIO;
-		}
-		/* Valid buffers passed to MFC encoder with LAST_FRAME command
-		 * should not have address of bank2 - MFC will treat it as a null frame.
-		 * To avoid such situation we set bank2 address below the pool address.
-		 */
-		dev->bank2 = bank2_base_phys - (1 << MFC_BASE_ALIGN_ORDER);
-	} else {
-		dev->bank2 = dev->bank1;
+		return -EINVAL;
 	}
-	memcpy(s5p_mfc_bitproc_virt, fw_blob->data, fw_blob->size);
+	memcpy(dev->fw_virt_addr, fw_blob->data, fw_blob->size);
 	wmb();
 	release_firmware(fw_blob);
 	mfc_debug_leave();
@@ -142,12 +130,12 @@ int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev)
 		release_firmware(fw_blob);
 		return -ENOMEM;
 	}
-	if (s5p_mfc_bitproc_buf == NULL || s5p_mfc_bitproc_phys == 0) {
-		mfc_err("MFC firmware is not allocated or was not mapped correctly\n");
+	if (dev->fw_virt_addr) {
+		mfc_err("MFC firmware is not allocated\n");
 		release_firmware(fw_blob);
 		return -EINVAL;
 	}
-	memcpy(s5p_mfc_bitproc_virt, fw_blob->data, fw_blob->size);
+	memcpy(dev->fw_virt_addr, fw_blob->data, fw_blob->size);
 	wmb();
 	release_firmware(fw_blob);
 	mfc_debug_leave();
@@ -159,12 +147,11 @@ int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
 {
 	/* Before calling this function one has to make sure
 	 * that MFC is no longer processing */
-	if (!s5p_mfc_bitproc_buf)
+	if (!dev->fw_virt_addr)
 		return -EINVAL;
-	vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
-	s5p_mfc_bitproc_virt = NULL;
-	s5p_mfc_bitproc_phys = 0;
-	s5p_mfc_bitproc_buf = NULL;
+	dma_free_coherent(dev->mem_dev_l, dev->fw_size, dev->fw_virt_addr,
+						dev->bank1);
+	dev->fw_virt_addr = NULL;
 	return 0;
 }
 
@@ -257,8 +244,10 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	int ret;
 
 	mfc_debug_enter();
-	if (!s5p_mfc_bitproc_buf)
+	if (!dev->fw_virt_addr) {
+		mfc_err("Firmware memory is not allocated.\n");
 		return -EINVAL;
+	}
 
 	/* 0. MFC reset */
 	mfc_debug(2, "MFC reset..\n");
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
index 90aa9b9..6a9b6f8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
@@ -16,7 +16,8 @@
 #include "s5p_mfc_common.h"
 
 int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev);
-int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev);
 int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev);
 
 int s5p_mfc_init_hw(struct s5p_mfc_dev *dev);
-- 
1.7.9.5

