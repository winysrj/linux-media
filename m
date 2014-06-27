Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaF0J3B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 05:29:01 -0400
From: Maurizio Lombardi <mlombard@redhat.com>
To: kyungmin.park@samsung.com
Cc: k.debski@samsung.com, jtp.park@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH] s5p: fix error code path when failing to allocate DMA memory
Date: Fri, 27 Jun 2014 11:28:31 +0200
Message-Id: <1403861311-7951-1-git-send-email-mlombard@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the s5p_mfc_alloc_firmware() function there are some mistakes
where the code checks whether the DMA memory is properly allocated or
not.

First of all dma_alloc_coherent() returns NULL in case of error.
The code also checked two times fw_virt_addr, ignoring
the bank2_virt pointer.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 6c3f8f7..390ca20 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -38,8 +38,7 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 	dev->fw_virt_addr = dma_alloc_coherent(dev->mem_dev_l, dev->fw_size,
 					&dev->bank1, GFP_KERNEL);
 
-	if (IS_ERR_OR_NULL(dev->fw_virt_addr)) {
-		dev->fw_virt_addr = NULL;
+	if (!dev->fw_virt_addr) {
 		mfc_err("Allocating bitprocessor buffer failed\n");
 		return -ENOMEM;
 	}
@@ -48,7 +47,7 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 		bank2_virt = dma_alloc_coherent(dev->mem_dev_r, 1 << MFC_BASE_ALIGN_ORDER,
 					&bank2_dma_addr, GFP_KERNEL);
 
-		if (IS_ERR(dev->fw_virt_addr)) {
+		if (!bank2_virt) {
 			mfc_err("Allocating bank2 base failed\n");
 			dma_free_coherent(dev->mem_dev_l, dev->fw_size,
 				dev->fw_virt_addr, dev->bank1);
-- 
Maurizio Lombardi

