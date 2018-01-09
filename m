Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1678950229.outbound-mail.sendgrid.net ([167.89.50.229]:31150
        "EHLO o1678950229.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752016AbeAINJy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 08:09:54 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        laurent@vger.kernel.org,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [RFT PATCH v2 2/6] uvcvideo: Convert decode functions to use new context structure
Date: Tue, 09 Jan 2018 13:09:53 +0000 (UTC)
Message-Id: <8c5d36e2260dff89105cf6ffc783abb53a014359.1515501206.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.99b809a1c1f6238bb8c0a2c8b0bc7b49dd777d94.1515501206.git-series.kieran.bingham@ideasonboard.com>
References: <cover.99b809a1c1f6238bb8c0a2c8b0bc7b49dd777d94.1515501206.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.99b809a1c1f6238bb8c0a2c8b0bc7b49dd777d94.1515501206.git-series.kieran.bingham@ideasonboard.com>
References: <cover.99b809a1c1f6238bb8c0a2c8b0bc7b49dd777d94.1515501206.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The URB completion handlers currently reference the stream context.

Now that each URB has its own context structure, convert the decode (and
one encode) functions to utilise this context for URB management.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---
v2:
 - fix checkpatch warning (pre-existing in code)

 drivers/media/usb/uvc/uvc_isight.c |  4 +++-
 drivers/media/usb/uvc/uvc_video.c  | 32 ++++++++++++++++++++-----------
 drivers/media/usb/uvc/uvcvideo.h   |  8 ++++----
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_isight.c b/drivers/media/usb/uvc/uvc_isight.c
index 8510e7259e76..433b8b4f96e2 100644
--- a/drivers/media/usb/uvc/uvc_isight.c
+++ b/drivers/media/usb/uvc/uvc_isight.c
@@ -99,9 +99,11 @@ static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
 	return 0;
 }
 
-void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
+void uvc_video_decode_isight(struct uvc_urb *uvc_urb,
 		struct uvc_buffer *buf)
 {
+	struct urb *urb = uvc_urb->urb;
+	struct uvc_streaming *stream = uvc_urb->stream;
 	int ret, i;
 
 	for (i = 0; i < urb->number_of_packets; ++i) {
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index e57c5f52c73b..92bd0952a66e 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1153,9 +1153,11 @@ static void uvc_video_validate_buffer(const struct uvc_streaming *stream,
 /*
  * Completion handler for video URBs.
  */
-static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+static void uvc_video_decode_isoc(struct uvc_urb *uvc_urb,
+		struct uvc_buffer *buf)
 {
+	struct urb *urb = uvc_urb->urb;
+	struct uvc_streaming *stream = uvc_urb->stream;
 	u8 *mem;
 	int ret, i;
 
@@ -1199,9 +1201,11 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 	}
 }
 
-static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+static void uvc_video_decode_bulk(struct uvc_urb *uvc_urb,
+		struct uvc_buffer *buf)
 {
+	struct urb *urb = uvc_urb->urb;
+	struct uvc_streaming *stream = uvc_urb->stream;
 	u8 *mem;
 	int len, ret;
 
@@ -1266,9 +1270,12 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 	}
 }
 
-static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+static void uvc_video_encode_bulk(struct uvc_urb *uvc_urb,
+		struct uvc_buffer *buf)
 {
+	struct urb *urb = uvc_urb->urb;
+	struct uvc_streaming *stream = uvc_urb->stream;
+
 	u8 *mem = urb->transfer_buffer;
 	int len = stream->urb_size, ret;
 
@@ -1311,7 +1318,8 @@ static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
 
 static void uvc_video_complete(struct urb *urb)
 {
-	struct uvc_streaming *stream = urb->context;
+	struct uvc_urb *uvc_urb = urb->context;
+	struct uvc_streaming *stream = uvc_urb->stream;
 	struct uvc_video_queue *queue = &stream->queue;
 	struct uvc_buffer *buf = NULL;
 	unsigned long flags;
@@ -1341,7 +1349,7 @@ static void uvc_video_complete(struct urb *urb)
 				       queue);
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
-	stream->decode(urb, stream, buf);
+	stream->decode(uvc_urb, buf);
 
 	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
 		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
@@ -1419,6 +1427,8 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 				uvc_free_urb_buffers(stream);
 				break;
 			}
+
+			uvc_urb->stream = stream;
 		}
 
 		if (i == UVC_URBS) {
@@ -1517,7 +1527,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 		}
 
 		urb->dev = stream->dev->udev;
-		urb->context = stream;
+		urb->context = uvc_urb;
 		urb->pipe = usb_rcvisocpipe(stream->dev->udev,
 				ep->desc.bEndpointAddress);
 #ifndef CONFIG_DMA_NONCOHERENT
@@ -1584,8 +1594,8 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 			return -ENOMEM;
 		}
 
-		usb_fill_bulk_urb(urb, stream->dev->udev, pipe, uvc_urb->buffer,
-				  size, uvc_video_complete, stream);
+		usb_fill_bulk_urb(urb, stream->dev->udev, pipe,	uvc_urb->buffer,
+				  size, uvc_video_complete, uvc_urb);
 #ifndef CONFIG_DMA_NONCOHERENT
 		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_dma = uvc_urb->dma;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 2a5dc7f09463..81a9a419a423 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -483,11 +483,13 @@ struct uvc_stats_stream {
  * struct uvc_urb - URB context management structure
  *
  * @urb: the URB described by this context structure
+ * @stream: UVC streaming context
  * @buffer: memory storage for the URB
  * @dma: DMA coherent addressing for the urb_buffer
  */
 struct uvc_urb {
 	struct urb *urb;
+	struct uvc_streaming *stream;
 
 	char *buffer;
 	dma_addr_t dma;
@@ -523,8 +525,7 @@ struct uvc_streaming {
 	/* Buffers queue. */
 	unsigned int frozen : 1;
 	struct uvc_video_queue queue;
-	void (*decode) (struct urb *urb, struct uvc_streaming *video,
-			struct uvc_buffer *buf);
+	void (*decode)(struct uvc_urb *uvc_urb, struct uvc_buffer *buf);
 
 	/* Context data used by the bulk completion handler. */
 	struct {
@@ -780,8 +781,7 @@ extern struct usb_host_endpoint *uvc_find_endpoint(
 		struct usb_host_interface *alts, __u8 epaddr);
 
 /* Quirks support */
-void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
-		struct uvc_buffer *buf);
+void uvc_video_decode_isight(struct uvc_urb *uvc_urb, struct uvc_buffer *buf);
 
 /* debugfs and statistics */
 void uvc_debugfs_init(void);
-- 
git-series 0.9.1
