Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbeACUds (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 15:33:48 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: Olivier BRAUN <olivier.braun@stereolabs.com>,
        kieran.bingham@ideasonboard.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Baoyou Xie <baoyou.xie@linaro.org>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Patrick Johnson <teknotus@teknot.us>,
        Jim Lin <jilin@nvidia.com>
Subject: [RFC/RFT PATCH 6/6] uvcvideo: Move decode processing to process context
Date: Wed,  3 Jan 2018 20:32:56 +0000
Message-Id: <48e2716d3902214a89aa30f3d1672512f8ea8773.1515010476.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

Newer high definition cameras, and cameras with multiple lenses such as
the range of stereovision cameras now available have ever increasing
data rates.

The inclusion of a variable length packet header in URB packets mean
that we must memcpy the frame data out to our destination 'manually'.
This can result in data rates of up to 2 gigabits per second being
processed.

To improve efficiency, and maximise throughput, handle the URB decode
processing through a work queue to move it from interrupt context, and
allow multiple processors to work on URBs in parallel.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c |  12 +++-
 drivers/media/usb/uvc/uvc_video.c | 114 ++++++++++++++++++++++++++-----
 drivers/media/usb/uvc/uvcvideo.h  |  24 +++++++-
 3 files changed, 132 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 204dd91a8526..07fcbfc132c9 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -179,10 +179,22 @@ static void uvc_stop_streaming(struct vb2_queue *vq)
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
 
+	/* Prevent new buffers coming in. */
+	spin_lock_irq(&queue->irqlock);
+	queue->flags |= UVC_QUEUE_STOPPING;
+	spin_unlock_irq(&queue->irqlock);
+
+	/*
+	 * All pending work should be completed before disabling the stream, as
+	 * all URBs will be free'd during uvc_video_enable(s, 0).
+	 */
+	flush_workqueue(stream->async_wq);
+
 	uvc_video_enable(stream, 0);
 
 	spin_lock_irq(&queue->irqlock);
 	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
+	queue->flags &= ~UVC_QUEUE_STOPPING;
 	spin_unlock_irq(&queue->irqlock);
 }
 
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 045ac655313c..b7b32a6bc2dc 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1058,21 +1058,70 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	return data[0];
 }
 
-static void uvc_video_decode_data(struct uvc_streaming *stream,
-		struct uvc_buffer *buf, const __u8 *data, int len)
+/*
+ * uvc_video_decode_data_work: Asynchronous memcpy processing
+ *
+ * Perform memcpy tasks in process context, with completion handlers
+ * to return the URB, and buffer handles.
+ *
+ * The work submitter must pre-determine that the work is safe
+ */
+static void uvc_video_decode_data_work(struct work_struct *work)
 {
-	unsigned int maxlen, nbytes;
-	void *mem;
+	struct uvc_urb *uvc_urb = container_of(work, struct uvc_urb, work);
+	struct uvc_streaming *stream = uvc_urb->stream;
+	struct uvc_video_queue *queue = &stream->queue;
+	unsigned int i;
+	bool stopping;
+	int ret;
+
+	for (i = 0; i < uvc_urb->packets; i++) {
+		struct uvc_decode_op *op = &uvc_urb->decodes[i];
+
+		memcpy(op->dst, op->src, op->len);
+
+		/* Release reference taken on this buffer */
+		uvc_queue_buffer_release(op->buf);
+	}
+
+	/*
+	 * Prevent resubmitting URBs when shutting down to ensure that no new
+	 * work item will be scheduled after uvc_stop_streaming() flushes the
+	 * work queue.
+	 */
+	spin_lock_irq(&queue->irqlock);
+	stopping = queue->flags & UVC_QUEUE_STOPPING;
+	spin_unlock_irq(&queue->irqlock);
+
+	if (stopping)
+		return;
+
+	ret = usb_submit_urb(uvc_urb->urb, GFP_ATOMIC);
+	if (ret < 0)
+		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
+			   ret);
+}
+
+static void uvc_video_decode_data(struct uvc_decode_op *decode,
+		struct uvc_urb *uvc_urb, struct uvc_buffer *buf,
+		const __u8 *data, int len)
+{
+	unsigned int maxlen;
 
 	if (len <= 0)
 		return;
 
-	/* Copy the video data to the buffer. */
 	maxlen = buf->length - buf->bytesused;
-	mem = buf->mem + buf->bytesused;
-	nbytes = min((unsigned int)len, maxlen);
-	memcpy(mem, data, nbytes);
-	buf->bytesused += nbytes;
+
+	/* Take a buffer reference for async work */
+	kref_get(&buf->ref);
+
+	decode->buf = buf;
+	decode->src = data;
+	decode->dst = buf->mem + buf->bytesused;
+	decode->len = min_t(unsigned int, len, maxlen);
+
+	buf->bytesused += decode->len;
 
 	/* Complete the current frame if the buffer size was exceeded. */
 	if (len > maxlen) {
@@ -1080,6 +1129,8 @@ static void uvc_video_decode_data(struct uvc_streaming *stream,
 		buf->error = 1;
 		buf->state = UVC_BUF_STATE_READY;
 	}
+
+	uvc_urb->packets++;
 }
 
 static void uvc_video_decode_end(struct uvc_streaming *stream,
@@ -1162,6 +1213,8 @@ static void uvc_video_decode_isoc(struct uvc_urb *uvc_urb,
 	int ret, i;
 
 	for (i = 0; i < urb->number_of_packets; ++i) {
+		struct uvc_decode_op *op = &uvc_urb->decodes[uvc_urb->packets];
+
 		if (urb->iso_frame_desc[i].status < 0) {
 			uvc_trace(UVC_TRACE_FRAME, "USB isochronous frame "
 				"lost (%d).\n", urb->iso_frame_desc[i].status);
@@ -1187,7 +1240,7 @@ static void uvc_video_decode_isoc(struct uvc_urb *uvc_urb,
 			continue;
 
 		/* Decode the payload data. */
-		uvc_video_decode_data(stream, buf, mem + ret,
+		uvc_video_decode_data(op, uvc_urb, buf, mem + ret,
 			urb->iso_frame_desc[i].actual_length - ret);
 
 		/* Process the header again. */
@@ -1248,9 +1301,12 @@ static void uvc_video_decode_bulk(struct uvc_urb *uvc_urb,
 	 * sure buf is never dereferenced if NULL.
 	 */
 
-	/* Process video data. */
-	if (!stream->bulk.skip_payload && buf != NULL)
-		uvc_video_decode_data(stream, buf, mem, len);
+	/* Prepare video data for processing. */
+	if (!stream->bulk.skip_payload && buf != NULL) {
+		struct uvc_decode_op *op = &uvc_urb->decodes[0];
+
+		uvc_video_decode_data(op, uvc_urb, buf, mem, len);
+	}
 
 	/* Detect the payload end by a URB smaller than the maximum size (or
 	 * a payload size equal to the maximum) and process the header again.
@@ -1322,7 +1378,8 @@ static void uvc_video_complete(struct urb *urb)
 	struct uvc_streaming *stream = uvc_urb->stream;
 	struct uvc_video_queue *queue = &stream->queue;
 	struct uvc_buffer *buf = NULL;
-	int ret;
+	unsigned long flags;
+	bool stopping;
 
 	switch (urb->status) {
 	case 0:
@@ -1342,14 +1399,30 @@ static void uvc_video_complete(struct urb *urb)
 		return;
 	}
 
+	/*
+	 * Simply accept and discard completed URBs without processing when the
+	 * stream is being shutdown. URBs will be freed as part of the
+	 * uvc_video_enable(s, 0) action, so we must not queue asynchronous
+	 * work based upon them.
+	 */
+	spin_lock_irqsave(&queue->irqlock, flags);
+	stopping = queue->flags & UVC_QUEUE_STOPPING;
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+
+	if (stopping)
+		return;
+
 	buf = uvc_queue_get_current_buffer(queue);
 
+	/* Re-initialise the URB packet work */
+	uvc_urb->packets = 0;
+
+	/* Process the URB headers, but work is deferred to a work queue */
 	stream->decode(uvc_urb, buf);
 
-	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
-		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
-			ret);
-	}
+	/* Handle any heavy lifting required */
+	INIT_WORK(&uvc_urb->work, uvc_video_decode_data_work);
+	queue_work(stream->async_wq, &uvc_urb->work);
 }
 
 /*
@@ -1621,6 +1694,11 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 
 	uvc_video_stats_start(stream);
 
+	stream->async_wq = alloc_workqueue("uvcvideo", WQ_UNBOUND | WQ_HIGHPRI,
+			0);
+	if (!stream->async_wq)
+		return -ENOMEM;
+
 	if (intf->num_altsetting > 1) {
 		struct usb_host_endpoint *best_ep = NULL;
 		unsigned int best_psize = UINT_MAX;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 2e51bbdf5dac..1f7399cb66e1 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -411,6 +411,7 @@ struct uvc_buffer {
 
 #define UVC_QUEUE_DISCONNECTED		(1 << 0)
 #define UVC_QUEUE_DROP_CORRUPTED	(1 << 1)
+#define UVC_QUEUE_STOPPING		(1 << 2)
 
 struct uvc_video_queue {
 	struct vb2_queue queue;
@@ -483,12 +484,30 @@ struct uvc_stats_stream {
 };
 
 /**
+ * struct uvc_decode_op: Context structure to schedule asynchronous memcpy
+ *
+ * @buf: active buf object for this decode
+ * @dst: copy destination address
+ * @src: copy source address
+ * @len: copy length
+ */
+struct uvc_decode_op {
+	struct uvc_buffer *buf;
+	void *dst;
+	const __u8 *src;
+	int len;
+};
+
+/**
  * struct uvc_urb - URB context management structure
  *
  * @urb: described URB. Must be allocated with usb_alloc_urb()
  * @stream: UVC streaming context
  * @urb_buffer: memory storage for the URB
  * @urb_dma: DMA coherent addressing for the urb_buffer
+ * @packets: counter to indicate the number of copy operations
+ * @decodes: work descriptors for asynchronous copy operations
+ * @work: work queue entry for asynchronous decode
  */
 struct uvc_urb {
 	struct urb *urb;
@@ -496,6 +515,10 @@ struct uvc_urb {
 
 	char *urb_buffer;
 	dma_addr_t urb_dma;
+
+	unsigned int packets;
+	struct uvc_decode_op decodes[UVC_MAX_PACKETS];
+	struct work_struct work;
 };
 
 struct uvc_streaming {
@@ -528,6 +551,7 @@ struct uvc_streaming {
 	/* Buffers queue. */
 	unsigned int frozen : 1;
 	struct uvc_video_queue queue;
+	struct workqueue_struct *async_wq;
 	void (*decode) (struct uvc_urb *uvc_urb, struct uvc_buffer *buf);
 
 	/* Context data used by the bulk completion handler. */
-- 
git-series 0.9.1
