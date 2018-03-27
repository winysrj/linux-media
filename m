Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51758 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbeC0QqL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 12:46:11 -0400
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
Subject: [PATCH v4 2/6] media: uvcvideo: Convert decode functions to use new context structure
Date: Tue, 27 Mar 2018 17:45:59 +0100
Message-Id: <9c19b485dafc12a57dccfb7b958ca2454238c759.1522168131.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
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

v3: (none)

v4:
 - Rebase on top of linux-media/master (v4.16-rc4, metadata additions)

 drivers/media/usb/uvc/uvc_isight.c |  6 ++++--
 drivers/media/usb/uvc/uvc_video.c  | 26 ++++++++++++++++++--------
 drivers/media/usb/uvc/uvcvideo.h   |  8 +++++---
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_isight.c b/drivers/media/usb/uvc/uvc_isight.c
index 81e6f2187bfb..39a4e4482b23 100644
--- a/drivers/media/usb/uvc/uvc_isight.c
+++ b/drivers/media/usb/uvc/uvc_isight.c
@@ -99,9 +99,11 @@ static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
 	return 0;
 }
 
-void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
-			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
+void uvc_video_decode_isight(struct uvc_urb *uvc_urb, struct uvc_buffer *buf,
+			struct uvc_buffer *meta_buf)
 {
+	struct urb *urb = uvc_urb->urb;
+	struct uvc_streaming *stream = uvc_urb->stream;
 	int ret, i;
 
 	for (i = 0; i < urb->number_of_packets; ++i) {
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 93048fbf4e82..0f6d488ab66b 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1237,9 +1237,11 @@ static void uvc_video_next_buffers(struct uvc_streaming *stream,
 	*video_buf = uvc_queue_next_buffer(&stream->queue, *video_buf);
 }
 
-static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
+static void uvc_video_decode_isoc(struct uvc_urb *uvc_urb,
 			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
 {
+	struct urb *urb = uvc_urb->urb;
+	struct uvc_streaming *stream = uvc_urb->stream;
 	u8 *mem;
 	int ret, i;
 
@@ -1284,9 +1286,11 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 	}
 }
 
-static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
+static void uvc_video_decode_bulk(struct uvc_urb *uvc_urb,
 			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
 {
+	struct urb *urb = uvc_urb->urb;
+	struct uvc_streaming *stream = uvc_urb->stream;
 	u8 *mem;
 	int len, ret;
 
@@ -1352,9 +1356,12 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 	}
 }
 
-static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
+static void uvc_video_encode_bulk(struct uvc_urb *uvc_urb,
 	struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
 {
+	struct urb *urb = uvc_urb->urb;
+	struct uvc_streaming *stream = uvc_urb->stream;
+
 	u8 *mem = urb->transfer_buffer;
 	int len = stream->urb_size, ret;
 
@@ -1397,7 +1404,8 @@ static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
 
 static void uvc_video_complete(struct urb *urb)
 {
-	struct uvc_streaming *stream = urb->context;
+	struct uvc_urb *uvc_urb = urb->context;
+	struct uvc_streaming *stream = uvc_urb->stream;
 	struct uvc_video_queue *queue = &stream->queue;
 	struct uvc_video_queue *qmeta = &stream->meta.queue;
 	struct vb2_queue *vb2_qmeta = stream->meta.vdev.queue;
@@ -1440,7 +1448,7 @@ static void uvc_video_complete(struct urb *urb)
 		spin_unlock_irqrestore(&qmeta->irqlock, flags);
 	}
 
-	stream->decode(urb, stream, buf, buf_meta);
+	stream->decode(uvc_urb, buf, buf_meta);
 
 	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
 		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
@@ -1518,6 +1526,8 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 				uvc_free_urb_buffers(stream);
 				break;
 			}
+
+			uvc_urb->stream = stream;
 		}
 
 		if (i == UVC_URBS) {
@@ -1616,7 +1626,7 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 		}
 
 		urb->dev = stream->dev->udev;
-		urb->context = stream;
+		urb->context = uvc_urb;
 		urb->pipe = usb_rcvisocpipe(stream->dev->udev,
 				ep->desc.bEndpointAddress);
 #ifndef CONFIG_DMA_NONCOHERENT
@@ -1683,8 +1693,8 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
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
index e056e5609068..fcf3b0fa1ca9 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -485,11 +485,13 @@ struct uvc_stats_stream {
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
@@ -525,8 +527,8 @@ struct uvc_streaming {
 	/* Buffers queue. */
 	unsigned int frozen : 1;
 	struct uvc_video_queue queue;
-	void (*decode) (struct urb *urb, struct uvc_streaming *video,
-			struct uvc_buffer *buf, struct uvc_buffer *meta_buf);
+	void (*decode)(struct uvc_urb *uvc_urb, struct uvc_buffer *buf,
+		       struct uvc_buffer *meta_buf);
 
 	struct {
 		struct video_device vdev;
@@ -795,7 +797,7 @@ struct usb_host_endpoint *uvc_find_endpoint(struct usb_host_interface *alts,
 					    u8 epaddr);
 
 /* Quirks support */
-void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
+void uvc_video_decode_isight(struct uvc_urb *uvc_urb,
 			     struct uvc_buffer *buf,
 			     struct uvc_buffer *meta_buf);
 
-- 
git-series 0.9.1
