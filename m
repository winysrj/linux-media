Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:55690 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbeKGGyt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 01:54:49 -0500
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v5 9/9] media: uvcvideo: Utilise for_each_uvc_urb iterator
Date: Tue,  6 Nov 2018 21:27:20 +0000
Message-Id: <8e669260c648ec44eefce9f554c5a871311832d9.1541534872.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

A new iterator is available for processing UVC URB structures. This
simplifies the processing of the internal stream data.

Convert the manual loop iterators to the new helper, adding an index
helper to keep the existing debug print.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

---
This patch converts to using the iterator which for most hunks makes
sense. The only one with uncertainty is in uvc_alloc_urb_buffers() where
the loop index is used to determine if all the buffers were successfully
allocated.

As the loop index is not incremented by the loops, we can obtain the
buffer index - but then we are offset and out-by-one.

Adjusting this in the code is fine - but at that point it feels like
it's not adding much value. I've left that hunk in for this patch - but
that part could be reverted if desired - unless anyone has a better
rework of the buffer check?

 drivers/media/usb/uvc/uvc_video.c | 51 ++++++++++++++++----------------
 drivers/media/usb/uvc/uvcvideo.h  |  3 ++-
 2 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 020022e6ade4..f6e5db7ea50e 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1556,20 +1556,19 @@ static void uvc_video_complete(struct urb *urb)
  */
 static void uvc_free_urb_buffers(struct uvc_streaming *stream)
 {
-	unsigned int i;
+	struct uvc_urb *uvc_urb;
 
-	for (i = 0; i < UVC_URBS; ++i) {
-		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
+	for_each_uvc_urb(uvc_urb, stream) {
+		if (!uvc_urb->buffer)
+			continue;
 
-		if (uvc_urb->buffer) {
 #ifndef CONFIG_DMA_NONCOHERENT
-			usb_free_coherent(stream->dev->udev, stream->urb_size,
-					uvc_urb->buffer, uvc_urb->dma);
+		usb_free_coherent(stream->dev->udev, stream->urb_size,
+				  uvc_urb->buffer, uvc_urb->dma);
 #else
-			kfree(uvc_urb->buffer);
+		kfree(uvc_urb->buffer);
 #endif
-			uvc_urb->buffer = NULL;
-		}
+		uvc_urb->buffer = NULL;
 	}
 
 	stream->urb_size = 0;
@@ -1589,8 +1588,9 @@ static void uvc_free_urb_buffers(struct uvc_streaming *stream)
 static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 	unsigned int size, unsigned int psize, gfp_t gfp_flags)
 {
+	struct uvc_urb *uvc_urb;
 	unsigned int npackets;
-	unsigned int i;
+	unsigned int i = 0;
 
 	/* Buffers are already allocated, bail out. */
 	if (stream->urb_size)
@@ -1605,8 +1605,12 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 
 	/* Retry allocations until one succeed. */
 	for (; npackets > 1; npackets /= 2) {
-		for (i = 0; i < UVC_URBS; ++i) {
-			struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
+		for_each_uvc_urb(uvc_urb, stream) {
+			/*
+			 * Track how many URBs we allocate, adding one to the
+			 * index to account for our zero index.
+			 */
+			i = uvc_urb_index(uvc_urb) + 1;
 
 			stream->urb_size = psize * npackets;
 #ifndef CONFIG_DMA_NONCOHERENT
@@ -1700,7 +1704,8 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 	struct usb_host_endpoint *ep, gfp_t gfp_flags)
 {
 	struct urb *urb;
-	unsigned int npackets, i, j;
+	struct uvc_urb *uvc_urb;
+	unsigned int npackets, j;
 	u16 psize;
 	u32 size;
 
@@ -1713,9 +1718,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 
 	size = npackets * psize;
 
-	for (i = 0; i < UVC_URBS; ++i) {
-		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
-
+	for_each_uvc_urb(uvc_urb, stream) {
 		urb = usb_alloc_urb(npackets, gfp_flags);
 		if (urb == NULL) {
 			uvc_video_stop(stream, 1);
@@ -1757,7 +1760,8 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 	struct usb_host_endpoint *ep, gfp_t gfp_flags)
 {
 	struct urb *urb;
-	unsigned int npackets, pipe, i;
+	struct uvc_urb *uvc_urb;
+	unsigned int npackets, pipe;
 	u16 psize;
 	u32 size;
 
@@ -1781,9 +1785,7 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		size = 0;
 
-	for (i = 0; i < UVC_URBS; ++i) {
-		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
-
+	for_each_uvc_urb(uvc_urb, stream) {
 		urb = usb_alloc_urb(0, gfp_flags);
 		if (urb == NULL) {
 			uvc_video_stop(stream, 1);
@@ -1810,6 +1812,7 @@ static int uvc_video_start(struct uvc_streaming *stream, gfp_t gfp_flags)
 {
 	struct usb_interface *intf = stream->intf;
 	struct usb_host_endpoint *ep;
+	struct uvc_urb *uvc_urb;
 	unsigned int i;
 	int ret;
 
@@ -1887,13 +1890,11 @@ static int uvc_video_start(struct uvc_streaming *stream, gfp_t gfp_flags)
 		return ret;
 
 	/* Submit the URBs. */
-	for (i = 0; i < UVC_URBS; ++i) {
-		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
-
+	for_each_uvc_urb(uvc_urb, stream) {
 		ret = usb_submit_urb(uvc_urb->urb, gfp_flags);
 		if (ret < 0) {
-			uvc_printk(KERN_ERR, "Failed to submit URB %u "
-					"(%d).\n", i, ret);
+			uvc_printk(KERN_ERR, "Failed to submit URB %u (%d).\n",
+				   uvc_urb_index(uvc_urb), ret);
 			uvc_video_stop(stream, 1);
 			return ret;
 		}
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index c0a120496a1f..6a0f1b59356c 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -617,6 +617,9 @@ struct uvc_streaming {
 	     (uvc_urb) < &(uvc_streaming)->uvc_urb[UVC_URBS]; \
 	     ++(uvc_urb))
 
+#define uvc_urb_index(uvc_urb) \
+	(unsigned int)((uvc_urb) - (&(uvc_urb)->stream->uvc_urb[0]))
+
 struct uvc_device_info {
 	u32	quirks;
 	u32	meta_format;
-- 
git-series 0.9.1
