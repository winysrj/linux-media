Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:47470 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbdJIMZX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 08:25:23 -0400
Received: by mail-wm0-f41.google.com with SMTP id t69so22007390wmt.2
        for <linux-media@vger.kernel.org>; Mon, 09 Oct 2017 05:25:22 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 1/2] media: venus: fix wrong size on dma_free
Date: Mon,  9 Oct 2017 15:24:57 +0300
Message-Id: <20171009122458.3053-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change will fix an issue with dma_free size found with
DMA API debug enabled.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 1caae8feaa36..734ce11b0ed0 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -344,7 +344,7 @@ static int venus_alloc(struct venus_hfi_device *hdev, struct mem_desc *desc,
 	desc->attrs = DMA_ATTR_WRITE_COMBINE;
 	desc->size = ALIGN(size, SZ_4K);
 
-	desc->kva = dma_alloc_attrs(dev, size, &desc->da, GFP_KERNEL,
+	desc->kva = dma_alloc_attrs(dev, desc->size, &desc->da, GFP_KERNEL,
 				    desc->attrs);
 	if (!desc->kva)
 		return -ENOMEM;
@@ -710,10 +710,8 @@ static int venus_interface_queues_init(struct venus_hfi_device *hdev)
 	if (ret)
 		return ret;
 
-	hdev->ifaceq_table.kva = desc.kva;
-	hdev->ifaceq_table.da = desc.da;
-	hdev->ifaceq_table.size = IFACEQ_TABLE_SIZE;
-	offset = hdev->ifaceq_table.size;
+	hdev->ifaceq_table = desc;
+	offset = IFACEQ_TABLE_SIZE;
 
 	for (i = 0; i < IFACEQ_NUM; i++) {
 		queue = &hdev->queues[i];
@@ -755,9 +753,7 @@ static int venus_interface_queues_init(struct venus_hfi_device *hdev)
 	if (ret) {
 		hdev->sfr.da = 0;
 	} else {
-		hdev->sfr.da = desc.da;
-		hdev->sfr.kva = desc.kva;
-		hdev->sfr.size = ALIGNED_SFR_SIZE;
+		hdev->sfr = desc;
 		sfr = hdev->sfr.kva;
 		sfr->buf_size = ALIGNED_SFR_SIZE;
 	}
-- 
2.11.0
