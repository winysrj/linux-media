Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51748 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbeC0QqJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 12:46:09 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 1/6] media: uvcvideo: Refactor URB descriptors
Date: Tue, 27 Mar 2018 17:45:58 +0100
Message-Id: <232cb20d8301bac0480d24ce8c3caef245a7853e.1522168131.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
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
index aa0082fe5833..93048fbf4e82 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1456,14 +1456,16 @@ static void uvc_free_urb_buffers(struct uvc_streaming *stream)
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
 
@@ -1501,16 +1503,18 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
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
@@ -1540,13 +1544,15 @@ static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
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
@@ -1601,6 +1607,8 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 	size = npackets * psize;
 
 	for (i = 0; i < UVC_URBS; ++i) {
+		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
+
 		urb = usb_alloc_urb(npackets, gfp_flags);
 		if (urb == NULL) {
 			uvc_uninit_video(stream, 1);
@@ -1613,12 +1621,12 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
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
@@ -1628,7 +1636,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 			urb->iso_frame_desc[j].length = psize;
 		}
 
-		stream->urb[i] = urb;
+		uvc_urb->urb = urb;
 	}
 
 	return 0;
@@ -1667,21 +1675,22 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
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
@@ -1772,7 +1781,9 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 
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
index be5cf179228b..e056e5609068 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -481,6 +481,20 @@ struct uvc_stats_stream {
 
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
@@ -529,9 +543,7 @@ struct uvc_streaming {
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
