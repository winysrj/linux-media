Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42663 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbeIAP4B (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2018 11:56:01 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: awalls@md.metrocast.net, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()
Date: Sat,  1 Sep 2018 19:44:09 +0800
Message-Id: <20180901114409.29446-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver may sleep in a interrupt handler.

The function call paths (from bottom to top) in Linux-4.16 are:

[FUNC] kzalloc(GFP_KERNEL)
drivers/media/pci/ivtv/ivtv-yuv.c, 938: 
	kzalloc in ivtv_yuv_init
drivers/media/pci/ivtv/ivtv-yuv.c, 960: 
	ivtv_yuv_init in ivtv_yuv_next_free
drivers/media/pci/ivtv/ivtv-yuv.c, 1126: 
	ivtv_yuv_next_free in ivtv_yuv_setup_stream_frame
drivers/media/pci/ivtv/ivtv-irq.c, 827: 
	ivtv_yuv_setup_stream_frame in ivtv_irq_dec_data_req
drivers/media/pci/ivtv/ivtv-irq.c, 1013: 
	ivtv_irq_dec_data_req in ivtv_irq_handler

To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC.

This bug is found by my static analysis tool DSAC.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/pci/ivtv/ivtv-yuv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
index 44936d6d7c39..1380474519f2 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -935,7 +935,7 @@ static void ivtv_yuv_init(struct ivtv *itv)
 	}
 
 	/* We need a buffer for blanking when Y plane is offset - non-fatal if we can't get one */
-	yi->blanking_ptr = kzalloc(720 * 16, GFP_KERNEL|__GFP_NOWARN);
+	yi->blanking_ptr = kzalloc(720 * 16, GFP_ATOMIC|__GFP_NOWARN);
 	if (yi->blanking_ptr) {
 		yi->blanking_dmaptr = pci_map_single(itv->pdev, yi->blanking_ptr, 720*16, PCI_DMA_TODEVICE);
 	} else {
-- 
2.17.0
