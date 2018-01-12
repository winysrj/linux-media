Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1.7nn.fshared.sendgrid.net ([167.89.55.65]:45954 "EHLO
        o1.7nn.fshared.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754584AbeALJT2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 04:19:28 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [RFT PATCH v3 6/6] uvcvideo: Move decode processing to process context
Date: Fri, 12 Jan 2018 09:19:27 +0000 (UTC)
Message-Id: <c857652f179fbc083a16029affefbde83a8932dc.1515748369.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Newer high definition cameras, and cameras with multiple lenses such as
the range of stereo-vision cameras now available have ever increasing
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
v2:
 - Lock full critical section of usb_submit_urb()

v3:
 - Fix race on submitting uvc_video_decode_data_work() to work queue.
 - Rename uvc_decode_op -> uvc_copy_op (Generic to encode/decode)
 - Rename decodes -> copy_operations
 - Don't queue work if there is no async task
 - obtain copy op structure directly in uvc_video_decode_data()
 - uvc_video_decode_data_work() -> uvc_video_copy_data_work()
---
 drivers/media/usb/uvc/uvc_queue.c |  12 +++-
 drivers/media/usb/uvc/uvc_video.c | 116 +++++++++++++++++++++++++++----
 drivers/media/usb/uvc/uvcvideo.h  |  24 ++++++-
 3 files changed, 138 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 5a9987e547d3..598087eeb5c2 100644
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
index 3878bec3276e..fb6b5af17380 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1058,21 +1058,74 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	return data[0];
 }
 
-static void uvc_video_decode_data(struct uvc_streaming *stream,
+static void uvc_video_copy_packets(struct uvc_urb *uvc_urb)
+{
+	unsigned int i;
+
+	for (i = 0; i < uvc_urb->async_operations; i++) {
+		struct uvc_copy_op *op = &uvc_urb->copy_operations[i];
+
+		memcpy(op->dst, op->src, op->len);
+
+		/* Release reference taken on this buffer */
+		uvc_queue_buffer_release(op->buf);
+	}
+}
+
+/*
+ * uvc_video_decode_data_work: Asynchronous memcpy processing
+ *
+ * Perform memcpy tasks in process context, with completion handlers
+ * to return the URB, and buffer handles.
+ *
+ * The work submitter must pre-determine that the work is safe
+ */
+static void uvc_video_copy_data_work(struct work_struct *work)
+{
+	struct uvc_urb *uvc_urb = container_of(work, struct uvc_urb, work);
+	struct uvc_streaming *stream = uvc_urb->stream;
+	struct uvc_video_queue *queue = &stream->queue;
+	int ret;
+
+	uvc_video_copy_packets(uvc_urb);
+
+	/*
+	 * Prevent resubmitting URBs when shutting down to ensure that no new
+	 * work item will be scheduled after uvc_stop_streaming() flushes the
+	 * work queue.
+	 */
+	spin_lock_irq(&queue->irqlock);
+	if (!(queue->flags & UVC_QUEUE_STOPPING)) {
+		ret = usb_submit_urb(uvc_urb->urb, GFP_ATOMIC);
+		if (ret < 0)
+			uvc_printk(KERN_ERR,
+				   "Failed to resubmit video URB (%d).\n",
+				   ret);
+	}
+	spin_unlock_irq(&queue->irqlock);
+}
+
+static void uvc_video_decode_data(struct uvc_urb *uvc_urb,
 		struct uvc_buffer *buf, const __u8 *data, int len)
 {
-	unsigned int maxlen, nbytes;
-	void *mem;
+	unsigned int active_op = uvc_urb->async_operations;
+	struct uvc_copy_op *decode = &uvc_urb->copy_operations[active_op];
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
@@ -1080,6 +1133,8 @@ static void uvc_video_decode_data(struct uvc_streaming *stream,
 		buf->error = 1;
 		buf->state = UVC_BUF_STATE_READY;
 	}
+
+	uvc_urb->async_operations++;
 }
 
 static void uvc_video_decode_end(struct uvc_streaming *stream,
@@ -1187,7 +1242,7 @@ static void uvc_video_decode_isoc(struct uvc_urb *uvc_urb,
 			continue;
 
 		/* Decode the payload data. */
-		uvc_video_decode_data(stream, buf, mem + ret,
+		uvc_video_decode_data(uvc_urb, buf, mem + ret,
 			urb->iso_frame_desc[i].actual_length - ret);
 
 		/* Process the header again. */
@@ -1248,9 +1303,9 @@ static void uvc_video_decode_bulk(struct uvc_urb *uvc_urb,
 	 * sure buf is never dereferenced if NULL.
 	 */
 
-	/* Process video data. */
+	/* Prepare video data for processing. */
 	if (!stream->bulk.skip_payload && buf != NULL)
-		uvc_video_decode_data(stream, buf, mem, len);
+		uvc_video_decode_data(uvc_urb, buf, mem, len);
 
 	/* Detect the payload end by a URB smaller than the maximum size (or
 	 * a payload size equal to the maximum) and process the header again.
@@ -1322,6 +1377,7 @@ static void uvc_video_complete(struct urb *urb)
 	struct uvc_streaming *stream = uvc_urb->stream;
 	struct uvc_video_queue *queue = &stream->queue;
 	struct uvc_buffer *buf = NULL;
+	unsigned long flags;
 	int ret;
 
 	switch (urb->status) {
@@ -1344,12 +1400,39 @@ static void uvc_video_complete(struct urb *urb)
 
 	buf = uvc_queue_get_current_buffer(queue);
 
+	/* Re-initialise the URB async work. */
+	uvc_urb->async_operations = 0;
+
+	/*
+	 * Process the URB headers, and optionally queue expensive memcpy tasks
+	 * to be deferred to a work queue.
+	 */
 	stream->decode(uvc_urb, buf);
 
-	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
-		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
-			ret);
+	/* Without any queued work, we must submit the URB. */
+	if (!uvc_urb->async_operations) {
+		ret = usb_submit_urb(uvc_urb->urb, GFP_ATOMIC);
+		if (ret < 0)
+			uvc_printk(KERN_ERR,
+				   "Failed to resubmit video URB (%d).\n",
+				   ret);
+		return;
+	}
+
+	/*
+	 * When the stream is stopped, all URBs are freed as part of the call to
+	 * uvc_stop_streaming() and must not be handled asynchronously. In that
+	 * event we can safely complete the packet work directly in this
+	 * context, without resubmitting the URB.
+	 */
+	spin_lock_irqsave(&queue->irqlock, flags);
+	if (!(queue->flags & UVC_QUEUE_STOPPING)) {
+		INIT_WORK(&uvc_urb->work, uvc_video_copy_data_work);
+		queue_work(stream->async_wq, &uvc_urb->work);
+	} else {
+		uvc_video_copy_packets(uvc_urb);
 	}
+	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
 /*
@@ -1620,6 +1703,11 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 
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
index 6a18dbfc3e5b..4a814da03913 100644
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
+ * struct uvc_copy_op: Context structure to schedule asynchronous memcpy
+ *
+ * @buf: active buf object for this operation
+ * @dst: copy destination address
+ * @src: copy source address
+ * @len: copy length
+ */
+struct uvc_copy_op {
+	struct uvc_buffer *buf;
+	void *dst;
+	const __u8 *src;
+	int len;
+};
+
+/**
  * struct uvc_urb - URB context management structure
  *
  * @urb: the URB described by this context structure
  * @stream: UVC streaming context
  * @buffer: memory storage for the URB
  * @dma: DMA coherent addressing for the urb_buffer
+ * @async_operations: counter to indicate the number of copy operations
+ * @copy_operations: work descriptors for asynchronous copy operations
+ * @work: work queue entry for asynchronous decode
  */
 struct uvc_urb {
 	struct urb *urb;
@@ -496,6 +515,10 @@ struct uvc_urb {
 
 	char *buffer;
 	dma_addr_t dma;
+
+	unsigned int async_operations;
+	struct uvc_copy_op copy_operations[UVC_MAX_PACKETS];
+	struct work_struct work;
 };
 
 struct uvc_streaming {
@@ -528,6 +551,7 @@ struct uvc_streaming {
 	/* Buffers queue. */
 	unsigned int frozen : 1;
 	struct uvc_video_queue queue;
+	struct workqueue_struct *async_wq;
 	void (*decode)(struct uvc_urb *uvc_urb, struct uvc_buffer *buf);
 
 	/* Context data used by the bulk completion handler. */
-- 
git-series 0.9.1
