Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58267 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab1IQPeF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 11:34:05 -0400
Received: from localhost.localdomain (unknown [91.178.181.94])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id A88A935AA0
	for <linux-media@vger.kernel.org>; Sat, 17 Sep 2011 15:34:02 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] media: Fix a UVC performance problem on systems with non-coherent DMA.
Date: Sat, 17 Sep 2011 17:34:00 +0200
Message-Id: <1316273642-3624-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1316273642-3624-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1316273642-3624-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Al Cooper <alcooperx@gmail.com>

The UVC driver uses usb_alloc_coherent() to allocate DMA data buffers.
On systems without coherent DMA this ends up allocating buffers in
uncached memory. The subsequent memcpy's done to coalesce the DMA
chunks into contiguous buffers then run VERY slowly. On a MIPS test
system the memcpy is about 200 times slower. This issue prevents the
system from keeping up with 720p YUYV data at 10fps.

The following patch uses kmalloc to alloc the DMA buffers instead of
usb_alloc_coherent on systems without coherent DMA. With this patch
the system was easily able to keep up with 720p at 10fps.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_video.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index ffd1158..b015e8e 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -790,8 +790,12 @@ static void uvc_free_urb_buffers(struct uvc_streaming *stream)
 
 	for (i = 0; i < UVC_URBS; ++i) {
 		if (stream->urb_buffer[i]) {
+#ifndef CONFIG_DMA_NONCOHERENT
 			usb_free_coherent(stream->dev->udev, stream->urb_size,
 				stream->urb_buffer[i], stream->urb_dma[i]);
+#else
+			kfree(stream->urb_buffer[i]);
+#endif
 			stream->urb_buffer[i] = NULL;
 		}
 	}
@@ -831,9 +835,14 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 	for (; npackets > 1; npackets /= 2) {
 		for (i = 0; i < UVC_URBS; ++i) {
 			stream->urb_size = psize * npackets;
+#ifndef CONFIG_DMA_NONCOHERENT
 			stream->urb_buffer[i] = usb_alloc_coherent(
 				stream->dev->udev, stream->urb_size,
 				gfp_flags | __GFP_NOWARN, &stream->urb_dma[i]);
+#else
+			stream->urb_buffer[i] =
+			    kmalloc(stream->urb_size, gfp_flags | __GFP_NOWARN);
+#endif
 			if (!stream->urb_buffer[i]) {
 				uvc_free_urb_buffers(stream);
 				break;
@@ -908,10 +917,14 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 		urb->context = stream;
 		urb->pipe = usb_rcvisocpipe(stream->dev->udev,
 				ep->desc.bEndpointAddress);
+#ifndef CONFIG_DMA_NONCOHERENT
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_dma = stream->urb_dma[i];
+#else
+		urb->transfer_flags = URB_ISO_ASAP;
+#endif
 		urb->interval = ep->desc.bInterval;
 		urb->transfer_buffer = stream->urb_buffer[i];
-		urb->transfer_dma = stream->urb_dma[i];
 		urb->complete = uvc_video_complete;
 		urb->number_of_packets = npackets;
 		urb->transfer_buffer_length = size;
@@ -969,8 +982,10 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 		usb_fill_bulk_urb(urb, stream->dev->udev, pipe,
 			stream->urb_buffer[i], size, uvc_video_complete,
 			stream);
+#ifndef CONFIG_DMA_NONCOHERENT
 		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_dma = stream->urb_dma[i];
+#endif
 
 		stream->urb[i] = urb;
 	}
-- 
1.7.3.4

