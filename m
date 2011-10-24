Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47231 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818Ab1JXPle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 11:41:34 -0400
Received: from localhost.localdomain (unknown [85.13.70.251])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 301EF35B76
	for <linux-media@vger.kernel.org>; Mon, 24 Oct 2011 15:41:33 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] uvcvideo: Move fields from uvc_buffer::buf to uvc_buffer
Date: Mon, 24 Oct 2011 17:42:03 +0200
Message-Id: <1319470924-15703-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1319470924-15703-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1319470924-15703-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add mem, length and bytesused fields to the uvc_buffer structure and use
them instead of accessing the uvc_buffer::buf m.offset, length and
bytesused fields directly. This prepares the driver to the conversion to
videobuf2.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_isight.c |   10 +++++-----
 drivers/media/video/uvc/uvc_queue.c  |   12 ++++++++----
 drivers/media/video/uvc/uvc_video.c  |   21 ++++++++++-----------
 drivers/media/video/uvc/uvcvideo.h   |    4 ++++
 4 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_isight.c b/drivers/media/video/uvc/uvc_isight.c
index 74bbe8f..8510e72 100644
--- a/drivers/media/video/uvc/uvc_isight.c
+++ b/drivers/media/video/uvc/uvc_isight.c
@@ -74,7 +74,7 @@ static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
 	 * Empty buffers (bytesused == 0) don't trigger end of frame detection
 	 * as it doesn't make sense to return an empty buffer.
 	 */
-	if (is_header && buf->buf.bytesused != 0) {
+	if (is_header && buf->bytesused != 0) {
 		buf->state = UVC_BUF_STATE_DONE;
 		return -EAGAIN;
 	}
@@ -83,13 +83,13 @@ static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
 	 * contain no data.
 	 */
 	if (!is_header) {
-		maxlen = buf->buf.length - buf->buf.bytesused;
-		mem = queue->mem + buf->buf.m.offset + buf->buf.bytesused;
+		maxlen = buf->length - buf->bytesused;
+		mem = buf->mem + buf->bytesused;
 		nbytes = min(len, maxlen);
 		memcpy(mem, data, nbytes);
-		buf->buf.bytesused += nbytes;
+		buf->bytesused += nbytes;
 
-		if (len > maxlen || buf->buf.bytesused == buf->buf.length) {
+		if (len > maxlen || buf->bytesused == buf->length) {
 			uvc_trace(UVC_TRACE_FRAME, "Frame complete "
 				  "(overflow).\n");
 			buf->state = UVC_BUF_STATE_DONE;
diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index 677691c..0fbb04b 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -173,6 +173,9 @@ int uvc_alloc_buffers(struct uvc_video_queue *queue, unsigned int nbuffers,
 		queue->buffer[i].buf.field = V4L2_FIELD_NONE;
 		queue->buffer[i].buf.memory = V4L2_MEMORY_MMAP;
 		queue->buffer[i].buf.flags = 0;
+
+		queue->buffer[i].mem = queue->mem + i * bufsize;
+		queue->buffer[i].length = buflength;
 		init_waitqueue_head(&queue->buffer[i].wait);
 	}
 
@@ -293,9 +296,9 @@ int uvc_queue_buffer(struct uvc_video_queue *queue,
 	}
 	buf->state = UVC_BUF_STATE_QUEUED;
 	if (v4l2_buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		buf->buf.bytesused = 0;
+		buf->bytesused = 0;
 	else
-		buf->buf.bytesused = v4l2_buf->bytesused;
+		buf->bytesused = v4l2_buf->bytesused;
 
 	list_add_tail(&buf->stream, &queue->mainqueue);
 	list_add_tail(&buf->queue, &queue->irqqueue);
@@ -437,7 +440,7 @@ int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 	 */
 	vma->vm_flags |= VM_IO;
 
-	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
+	addr = (unsigned long)buffer->mem;
 #ifdef CONFIG_MMU
 	while (size > 0) {
 		page = vmalloc_to_page((void *)addr);
@@ -515,7 +518,7 @@ unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
 		ret = -EINVAL;
 		goto done;
 	}
-	ret = (unsigned long)queue->mem + buffer->buf.m.offset;
+	ret = (unsigned long)buf->mem;
 done:
 	mutex_unlock(&queue->mutex);
 	return ret;
@@ -621,6 +624,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 	list_del(&buf->queue);
 	buf->error = 0;
 	buf->state = UVC_BUF_STATE_DONE;
+	buf->buf.bytesused = buf->bytesused;
 	if (!list_empty(&queue->irqqueue))
 		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
 					   queue);
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index b015e8e..00fe749 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -490,7 +490,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	 * avoids detecting end of frame conditions at FID toggling if the
 	 * previous payload had the EOF bit set.
 	 */
-	if (fid != stream->last_fid && buf->buf.bytesused != 0) {
+	if (fid != stream->last_fid && buf->bytesused != 0) {
 		uvc_trace(UVC_TRACE_FRAME, "Frame complete (FID bit "
 				"toggled).\n");
 		buf->state = UVC_BUF_STATE_READY;
@@ -505,7 +505,6 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 static void uvc_video_decode_data(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, const __u8 *data, int len)
 {
-	struct uvc_video_queue *queue = &stream->queue;
 	unsigned int maxlen, nbytes;
 	void *mem;
 
@@ -513,11 +512,11 @@ static void uvc_video_decode_data(struct uvc_streaming *stream,
 		return;
 
 	/* Copy the video data to the buffer. */
-	maxlen = buf->buf.length - buf->buf.bytesused;
-	mem = queue->mem + buf->buf.m.offset + buf->buf.bytesused;
+	maxlen = buf->length - buf->bytesused;
+	mem = buf->mem + buf->bytesused;
 	nbytes = min((unsigned int)len, maxlen);
 	memcpy(mem, data, nbytes);
-	buf->buf.bytesused += nbytes;
+	buf->bytesused += nbytes;
 
 	/* Complete the current frame if the buffer size was exceeded. */
 	if (len > maxlen) {
@@ -530,7 +529,7 @@ static void uvc_video_decode_end(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, const __u8 *data, int len)
 {
 	/* Mark the buffer as done if the EOF marker is set. */
-	if (data[1] & UVC_STREAM_EOF && buf->buf.bytesused != 0) {
+	if (data[1] & UVC_STREAM_EOF && buf->bytesused != 0) {
 		uvc_trace(UVC_TRACE_FRAME, "Frame complete (EOF found).\n");
 		if (data[0] == len)
 			uvc_trace(UVC_TRACE_FRAME, "EOF in empty payload.\n");
@@ -568,8 +567,8 @@ static int uvc_video_encode_data(struct uvc_streaming *stream,
 	void *mem;
 
 	/* Copy video data to the URB buffer. */
-	mem = queue->mem + buf->buf.m.offset + queue->buf_used;
-	nbytes = min((unsigned int)len, buf->buf.bytesused - queue->buf_used);
+	mem = buf->mem + queue->buf_used;
+	nbytes = min((unsigned int)len, buf->bytesused - queue->buf_used);
 	nbytes = min(stream->bulk.max_payload_size - stream->bulk.payload_size,
 			nbytes);
 	memcpy(data, mem, nbytes);
@@ -624,7 +623,7 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 			urb->iso_frame_desc[i].actual_length);
 
 		if (buf->state == UVC_BUF_STATE_READY) {
-			if (buf->buf.length != buf->buf.bytesused &&
+			if (buf->length != buf->bytesused &&
 			    !(stream->cur_format->flags &
 			      UVC_FMT_FLAG_COMPRESSED))
 				buf->error = 1;
@@ -724,9 +723,9 @@ static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
 	stream->bulk.payload_size += ret;
 	len -= ret;
 
-	if (buf->buf.bytesused == stream->queue.buf_used ||
+	if (buf->bytesused == stream->queue.buf_used ||
 	    stream->bulk.payload_size == stream->bulk.max_payload_size) {
-		if (buf->buf.bytesused == stream->queue.buf_used) {
+		if (buf->bytesused == stream->queue.buf_used) {
 			stream->queue.buf_used = 0;
 			buf->state = UVC_BUF_STATE_READY;
 			buf->buf.sequence = ++stream->sequence;
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 4c1392e..55f9171 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -328,6 +328,10 @@ struct uvc_buffer {
 	wait_queue_head_t wait;
 	enum uvc_buffer_state state;
 	unsigned int error;
+
+	void *mem;
+	unsigned int length;
+	unsigned int bytesused;
 };
 
 #define UVC_QUEUE_STREAMING		(1 << 0)
-- 
1.7.3.4

