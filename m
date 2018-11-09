Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38886 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbeKJCrO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 21:47:14 -0500
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
Subject: [PATCH v6 10/10] media: uvcvideo: Utilise for_each_uvc_urb iterator
Date: Fri,  9 Nov 2018 17:05:33 +0000
Message-Id: <21b69ca874528bf3f5985086c37d641fba95aaf4.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A new iterator is available for processing UVC URB structures. This
simplifies the processing of the internal stream data.

Convert the manual loop iterators to the new helper, adding an index
helper to keep the existing debug print.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

---

v6:
 - rename lone 'j' iterator to 'i'
 - Remove conversion which doesn't make sense due to needing the
   iterator value.

 drivers/media/usb/uvc/uvc_video.c | 46 ++++++++++++++------------------
 drivers/media/usb/uvc/uvcvideo.h  |  3 ++-
 2 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index a81012c65280..8d6d2fd8c74c 100644
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
@@ -1701,7 +1700,8 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 	struct usb_host_endpoint *ep, gfp_t gfp_flags)
 {
 	struct urb *urb;
-	unsigned int npackets, i, j;
+	struct uvc_urb *uvc_urb;
+	unsigned int npackets, i;
 	u16 psize;
 	u32 size;
 
@@ -1714,9 +1714,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 
 	size = npackets * psize;
 
-	for (i = 0; i < UVC_URBS; ++i) {
-		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
-
+	for_each_uvc_urb(uvc_urb, stream) {
 		urb = usb_alloc_urb(npackets, gfp_flags);
 		if (urb == NULL) {
 			uvc_video_stop_transfer(stream, 1);
@@ -1739,9 +1737,9 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 		urb->number_of_packets = npackets;
 		urb->transfer_buffer_length = size;
 
-		for (j = 0; j < npackets; ++j) {
-			urb->iso_frame_desc[j].offset = j * psize;
-			urb->iso_frame_desc[j].length = psize;
+		for (i = 0; i < npackets; ++i) {
+			urb->iso_frame_desc[i].offset = i * psize;
+			urb->iso_frame_desc[i].length = psize;
 		}
 
 		uvc_urb->urb = urb;
@@ -1758,7 +1756,8 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 	struct usb_host_endpoint *ep, gfp_t gfp_flags)
 {
 	struct urb *urb;
-	unsigned int npackets, pipe, i;
+	struct uvc_urb *uvc_urb;
+	unsigned int npackets, pipe;
 	u16 psize;
 	u32 size;
 
@@ -1782,9 +1781,7 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		size = 0;
 
-	for (i = 0; i < UVC_URBS; ++i) {
-		struct uvc_urb *uvc_urb = &stream->uvc_urb[i];
-
+	for_each_uvc_urb(uvc_urb, stream) {
 		urb = usb_alloc_urb(0, gfp_flags);
 		if (urb == NULL) {
 			uvc_video_stop_transfer(stream, 1);
@@ -1812,6 +1809,7 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
 {
 	struct usb_interface *intf = stream->intf;
 	struct usb_host_endpoint *ep;
+	struct uvc_urb *uvc_urb;
 	unsigned int i;
 	int ret;
 
@@ -1889,13 +1887,11 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
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
 			uvc_video_stop_transfer(stream, 1);
 			return ret;
 		}
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index b1b895c67122..24bf1a934c59 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -620,6 +620,9 @@ struct uvc_streaming {
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
