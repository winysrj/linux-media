Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38860 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728229AbeKJCrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 21:47:06 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Tomasz Figa <tfiga@google.com>,
        Keiichi Watanabe <keiichiw@chromium.org>
Subject: [PATCH v6 01/10] media: uvcvideo: Refactor URB descriptors
Date: Fri,  9 Nov 2018 17:05:24 +0000
Message-Id: <2e493b14cfd5f570fa6b4f1089bada32d85eb509.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We currently store three separate arrays for each URB reference we hold.

Objectify the data needed to track URBs into a single uvc_urb structure,
allowing better object management and tracking of the URB.

All accesses to the data pointers through stream, are converted to use a
uvc_urb pointer for consistency.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---
v2:
 - Re-describe URB context structure
 - Re-name uvc_urb->{urb_buffer,urb_dma}{buffer,dma}

v3:
 - No change

v4:
 - Rebase on top of linux-media/master (v4.16-rc4, metadata additions)

 drivers/media/usb/uvc/uvc_video.c | 49 +++++++++++++++++++-------------
 drivers/media/usb/uvc/uvcvideo.h  | 18 ++++++++++--
 2 files changed, 45 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 86a99f461fd8..113881bed2a4 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1506,14 +1506,16 @@ static void uvc_free_urb_buffers(struct uvc_streaming *stream)
 	unsigned int i;
 
 	for (i = 0; i < UVC_URBS; ++i) {
-		if (stream->urb_buffer[i]) {
+		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
+
+		if (uvc_urb->buffer) {
 #ifndef CONFIG_DMA_NONCOHERENT
 			usb_free_coherent(stream->dev->udev, stream->urb_size,
-				stream->urb_buffer[i], stream->urb_dma[i]);
+					uvc_urb->buffer, uvc_urb->dma);
 #else
-			kfree(stream->urb_buffer[i]);
+			kfree(uvc_urb->buffer);
 #endif
-			stream->urb_buffer[i] = NULL;
+			uvc_urb->buffer = NULL;
 		}
 	}
 
@@ -1551,16 +1553,18 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 	/* Retry allocations until one succeed. */
 	for (; npackets > 1; npackets /= 2) {
 		for (i = 0; i < UVC_URBS; ++i) {
+			struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
+
 			stream->urb_size = psize * npackets;
 #ifndef CONFIG_DMA_NONCOHERENT
-			stream->urb_buffer[i] = usb_alloc_coherent(
+			uvc_urb->buffer = usb_alloc_coherent(
 				stream->dev->udev, stream->urb_size,
-				gfp_flags | __GFP_NOWARN, &stream->urb_dma[i]);
+				gfp_flags | __GFP_NOWARN, &uvc_urb->dma);
 #else
-			stream->urb_buffer[i] =
+			uvc_urb->buffer =
 			    kmalloc(stream->urb_size, gfp_flags | __GFP_NOWARN);
 #endif
-			if (!stream->urb_buffer[i]) {
+			if (!uvc_urb->buffer) {
 				uvc_free_urb_buffers(stream);
 				break;
 			}
@@ -1590,13 +1594,15 @@ static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
 	uvc_video_stats_stop(stream);
 
 	for (i = 0; i < UVC_URBS; ++i) {
-		urb = stream->urb[i];
+		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
+
+		urb = uvc_urb->urb;
 		if (urb == NULL)
 			continue;
 
 		usb_kill_urb(urb);
 		usb_free_urb(urb);
-		stream->urb[i] = NULL;
+		uvc_urb->urb = NULL;
 	}
 
 	if (free_buffers)
@@ -1651,6 +1657,8 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 	size = npackets * psize;
 
 	for (i = 0; i < UVC_URBS; ++i) {
+		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
+
 		urb = usb_alloc_urb(npackets, gfp_flags);
 		if (urb == NULL) {
 			uvc_uninit_video(stream, 1);
@@ -1663,12 +1671,12 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 				ep->desc.bEndpointAddress);
 #ifndef CONFIG_DMA_NONCOHERENT
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_dma = stream->urb_dma[i];
+		urb->transfer_dma = uvc_urb->dma;
 #else
 		urb->transfer_flags = URB_ISO_ASAP;
 #endif
 		urb->interval = ep->desc.bInterval;
-		urb->transfer_buffer = stream->urb_buffer[i];
+		urb->transfer_buffer = uvc_urb->buffer;
 		urb->complete = uvc_video_complete;
 		urb->number_of_packets = npackets;
 		urb->transfer_buffer_length = size;
@@ -1678,7 +1686,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 			urb->iso_frame_desc[j].length = psize;
 		}
 
-		stream->urb[i] = urb;
+		uvc_urb->urb = urb;
 	}
 
 	return 0;
@@ -1717,21 +1725,22 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 		size = 0;
 
 	for (i = 0; i < UVC_URBS; ++i) {
+		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
+
 		urb = usb_alloc_urb(0, gfp_flags);
 		if (urb == NULL) {
 			uvc_uninit_video(stream, 1);
 			return -ENOMEM;
 		}
 
-		usb_fill_bulk_urb(urb, stream->dev->udev, pipe,
-			stream->urb_buffer[i], size, uvc_video_complete,
-			stream);
+		usb_fill_bulk_urb(urb, stream->dev->udev, pipe, uvc_urb->buffer,
+				  size, uvc_video_complete, stream);
 #ifndef CONFIG_DMA_NONCOHERENT
 		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_dma = stream->urb_dma[i];
+		urb->transfer_dma = uvc_urb->dma;
 #endif
 
-		stream->urb[i] = urb;
+		uvc_urb->urb = urb;
 	}
 
 	return 0;
@@ -1822,7 +1831,9 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 
 	/* Submit the URBs. */
 	for (i = 0; i < UVC_URBS; ++i) {
-		ret = usb_submit_urb(stream->urb[i], gfp_flags);
+		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
+
+		ret = usb_submit_urb(uvc_urb->urb, gfp_flags);
 		if (ret < 0) {
 			uvc_printk(KERN_ERR, "Failed to submit URB %u "
 					"(%d).\n", i, ret);
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index facf77192b19..7233249b59f5 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -490,6 +490,20 @@ struct uvc_stats_stream {
 
 #define UVC_METATADA_BUF_SIZE 1024
 
+/**
+ * struct uvc_urb - URB context management structure
+ *
+ * @urb: the URB described by this context structure
+ * @buffer: memory storage for the URB
+ * @dma: DMA coherent addressing for the urb_buffer
+ */
+struct uvc_urb {
+	struct urb *urb;
+
+	char *buffer;
+	dma_addr_t dma;
+};
+
 struct uvc_streaming {
 	struct list_head list;
 	struct uvc_device *dev;
@@ -538,9 +552,7 @@ struct uvc_streaming {
 		u32 max_payload_size;
 	} bulk;
 
-	struct urb *urb[UVC_URBS];
-	char *urb_buffer[UVC_URBS];
-	dma_addr_t urb_dma[UVC_URBS];
+	struct uvc_urb uvc_urb[UVC_URBS];
 	unsigned int urb_size;
 
 	u32 sequence;
-- 
git-series 0.9.1
