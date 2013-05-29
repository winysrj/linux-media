Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35783 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3E2EX7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 00:23:59 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb11so7323075pad.23
        for <linux-media@vger.kernel.org>; Tue, 28 May 2013 21:23:58 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, sylvester.nawrocki@gmail.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] s5p-mfc: Add NULL check for allocated buffer
Date: Wed, 29 May 2013 09:40:00 +0530
Message-Id: <1369800600-19929-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In certain cases, dma_alloc_coherent returns NULL. Add check for
NULL pointer.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 2e5f30b..dc1fc94 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -38,7 +38,7 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 	dev->fw_virt_addr = dma_alloc_coherent(dev->mem_dev_l, dev->fw_size,
 					&dev->bank1, GFP_KERNEL);
 
-	if (IS_ERR(dev->fw_virt_addr)) {
+	if (IS_ERR_OR_NULL(dev->fw_virt_addr)) {
 		dev->fw_virt_addr = NULL;
 		mfc_err("Allocating bitprocessor buffer failed\n");
 		return -ENOMEM;
-- 
1.7.9.5

