Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38074 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbeH3VYV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 17:24:21 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Matwey V . Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, kernel@collabora.com,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [RFC 3/3] stk1160: Use non-coherent buffers for USB transfers
Date: Thu, 30 Aug 2018 14:20:30 -0300
Message-Id: <20180830172030.23344-4-ezequiel@collabora.com>
In-Reply-To: <20180830172030.23344-1-ezequiel@collabora.com>
References: <20180830172030.23344-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Platforms without hardware coherency can benefit a lot
from using non-coherent buffers. Moreover, platforms
with hardware coherency aren't impacted by this change.

For instance, on AM335x, while it's still not possible
to capture full resolution frames, this patch enables
half-resolution frame streams to work.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/usb/stk1160/stk1160-video.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 2811f612820f..aeb4264d1998 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -240,6 +240,9 @@ static void stk1160_process_isoc(struct stk1160 *dev, struct urb *urb)
 		return;
 	}
 
+	dma_sync_single_for_cpu(&urb->dev->dev, urb->transfer_dma,
+		urb->transfer_buffer_length, DMA_FROM_DEVICE);
+
 	for (i = 0; i < urb->number_of_packets; i++) {
 		status = urb->iso_frame_desc[i].status;
 		if (status < 0) {
@@ -379,16 +382,11 @@ void stk1160_free_isoc(struct stk1160 *dev)
 		urb = dev->isoc_ctl.urb[i];
 		if (urb) {
 
-			if (dev->isoc_ctl.transfer_buffer[i]) {
-#ifndef CONFIG_DMA_NONCOHERENT
-				usb_free_coherent(dev->udev,
+			if (dev->isoc_ctl.transfer_buffer[i])
+				usb_free_noncoherent(dev->udev,
 					urb->transfer_buffer_length,
 					dev->isoc_ctl.transfer_buffer[i],
 					urb->transfer_dma);
-#else
-				kfree(dev->isoc_ctl.transfer_buffer[i]);
-#endif
-			}
 			usb_free_urb(urb);
 			dev->isoc_ctl.urb[i] = NULL;
 		}
@@ -461,12 +459,8 @@ int stk1160_alloc_isoc(struct stk1160 *dev)
 			goto free_i_bufs;
 		dev->isoc_ctl.urb[i] = urb;
 
-#ifndef CONFIG_DMA_NONCOHERENT
-		dev->isoc_ctl.transfer_buffer[i] = usb_alloc_coherent(dev->udev,
+		dev->isoc_ctl.transfer_buffer[i] = usb_alloc_noncoherent(dev->udev,
 			sb_size, GFP_KERNEL, &urb->transfer_dma);
-#else
-		dev->isoc_ctl.transfer_buffer[i] = kmalloc(sb_size, GFP_KERNEL);
-#endif
 		if (!dev->isoc_ctl.transfer_buffer[i]) {
 			stk1160_err("cannot alloc %d bytes for tx[%d] buffer\n",
 				sb_size, i);
@@ -490,11 +484,7 @@ int stk1160_alloc_isoc(struct stk1160 *dev)
 		urb->interval = 1;
 		urb->start_frame = 0;
 		urb->number_of_packets = max_packets;
-#ifndef CONFIG_DMA_NONCOHERENT
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-#else
-		urb->transfer_flags = URB_ISO_ASAP;
-#endif
 
 		k = 0;
 		for (j = 0; j < max_packets; j++) {
-- 
2.18.0
