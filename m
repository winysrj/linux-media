Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33298 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbbIVIST (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 04:18:19 -0400
Received: by pacex6 with SMTP id ex6so2987710pac.0
        for <linux-media@vger.kernel.org>; Tue, 22 Sep 2015 01:18:19 -0700 (PDT)
From: Terry Heo <terryheo@google.com>
To: linux-media@vger.kernel.org
Cc: Terry Heo <terryheo@google.com>
Subject: [PATCH] [media] cx231xx: fix bulk transfer mode
Date: Tue, 22 Sep 2015 17:18:05 +0900
Message-Id: <1442909885-26277-1-git-send-email-terryheo@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current cx231xx driver doesn't work with bulk transfer mode.
This patch makes it possible to use bulk transfer mode.

Signed-off-by: Terry Heo <terryheo@google.com>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index a2fd49b..f497888 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -914,6 +914,7 @@ EXPORT_SYMBOL_GPL(cx231xx_uninit_isoc);
  */
 void cx231xx_uninit_bulk(struct cx231xx *dev)
 {
+	struct cx231xx_dmaqueue *dma_q = &dev->video_mode.vidq;
 	struct urb *urb;
 	int i;
 
@@ -931,7 +932,7 @@ void cx231xx_uninit_bulk(struct cx231xx *dev)
 			if (dev->video_mode.bulk_ctl.transfer_buffer[i]) {
 				usb_free_coherent(dev->udev,
 						urb->transfer_buffer_length,
-						dev->video_mode.isoc_ctl.
+						dev->video_mode.bulk_ctl.
 						transfer_buffer[i],
 						urb->transfer_dma);
 			}
@@ -943,10 +944,12 @@ void cx231xx_uninit_bulk(struct cx231xx *dev)
 
 	kfree(dev->video_mode.bulk_ctl.urb);
 	kfree(dev->video_mode.bulk_ctl.transfer_buffer);
+	kfree(dma_q->p_left_data);
 
 	dev->video_mode.bulk_ctl.urb = NULL;
 	dev->video_mode.bulk_ctl.transfer_buffer = NULL;
 	dev->video_mode.bulk_ctl.num_bufs = 0;
+	dma_q->p_left_data = NULL;
 
 	if (dev->mode_tv == 0)
 		cx231xx_capture_start(dev, 0, Raw_Video);
@@ -1196,6 +1199,16 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 				  sb_size, cx231xx_bulk_irq_callback, dma_q);
 	}
 
+	/* clear halt */
+	rc = usb_clear_halt(dev->udev, dev->video_mode.bulk_ctl.urb[0]->pipe);
+	if (rc < 0) {
+		dev_err(dev->dev,
+			"failed to clear USB bulk endpoint stall/halt condition (error=%i)\n",
+			rc);
+		cx231xx_uninit_bulk(dev);
+		return rc;
+	}
+
 	init_waitqueue_head(&dma_q->wq);
 
 	/* submit urbs and enables IRQ */
-- 
2.6.0.rc0.131.gf624c3d

