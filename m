Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1682455182.outbound-mail.sendgrid.net ([168.245.5.182]:4159
        "EHLO o1682455182.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752994AbeAINJy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 08:09:54 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        laurent@vger.kernel.org,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [RFT PATCH v2 1/6] uvcvideo: Refactor URB descriptors
Date: Tue, 09 Jan 2018 13:09:53 +0000 (UTC)
Message-Id: <38bb2b10b9d4db1d44cf22d345c064955ddb379e.1515501206.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.99b809a1c1f6238bb8c0a2c8b0bc7b49dd777d94.1515501206.git-series.kieran.bingham@ideasonboard.com>
References: <cover.99b809a1c1f6238bb8c0a2c8b0bc7b49dd777d94.1515501206.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.99b809a1c1f6238bb8c0a2c8b0bc7b49dd777d94.1515501206.git-series.kieran.bingham@ideasonboard.com>
References: <cover.99b809a1c1f6238bb8c0a2c8b0bc7b49dd777d94.1515501206.git-series.kieran.bingham@ideasonboard.com>
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

 drivers/media/usb/uvc/uvc_video.c | 49 +++++++++++++++++++-------------
 drivers/media/usb/uvc/uvcvideo.h  | 18 ++++++++++--
 2 files changed, 45 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 73cd44e8bd81..e57c5f52c73b 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1357,14 +1357,16 @@ static void uvc_free_urb_buffers(struct uvc_streaming *stream)
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
 
@@ -1402,16 +1404,18 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
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
@@ -1441,13 +1445,15 @@ static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
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
@@ -1502,6 +1508,8 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 	size = npackets * psize;
 
 	for (i = 0; i < UVC_URBS; ++i) {
+		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
+
 		urb = usb_alloc_urb(npackets, gfp_flags);
 		if (urb == NULL) {
 			uvc_uninit_video(stream, 1);
@@ -1514,12 +1522,12 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
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
@@ -1529,7 +1537,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 			urb->iso_frame_desc[j].length = psize;
 		}
 
-		stream->urb[i] = urb;
+		uvc_urb->urb = urb;
 	}
 
 	return 0;
@@ -1568,21 +1576,22 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
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
@@ -1673,7 +1682,9 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 
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
index 19e725e2bda5..2a5dc7f09463 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -479,6 +479,20 @@ struct uvc_stats_stream {
 	unsigned int max_sof;		/* Maximum STC.SOF value */
 };
 
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
@@ -521,9 +535,7 @@ struct uvc_streaming {
 		__u32 max_payload_size;
 	} bulk;
 
-	struct urb *urb[UVC_URBS];
-	char *urb_buffer[UVC_URBS];
-	dma_addr_t urb_dma[UVC_URBS];
+	struct uvc_urb uvc_urb[UVC_URBS];
 	unsigned int urb_size;
 
 	__u32 sequence;
-- 
git-series 0.9.1
