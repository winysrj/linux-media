Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48874 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab0JFI7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:43 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id ED21E35CA5
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:39 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 08/14] uvcvideo: Generate discontinuous sequence numbers when frames are lost
Date: Wed,  6 Oct 2010 10:59:46 +0200
Message-Id: <1286355592-13603-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Increase the sequence number of the v4l2_buffer structure regardless of
any buffer states, so that discontinuous sequence numbers allow
applications to detect lost video frames.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_queue.c |    7 +------
 drivers/media/video/uvc/uvc_video.c |    9 +++++++++
 drivers/media/video/uvc/uvcvideo.h  |    2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index d27a315..ed6d544 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -135,7 +135,6 @@ int uvc_alloc_buffers(struct uvc_video_queue *queue, unsigned int nbuffers,
 		queue->buffer[i].buf.m.offset = i * bufsize;
 		queue->buffer[i].buf.length = buflength;
 		queue->buffer[i].buf.type = queue->type;
-		queue->buffer[i].buf.sequence = 0;
 		queue->buffer[i].buf.field = V4L2_FIELD_NONE;
 		queue->buffer[i].buf.memory = V4L2_MEMORY_MMAP;
 		queue->buffer[i].buf.flags = 0;
@@ -410,8 +409,7 @@ done:
  * state can be properly initialized before buffers are accessed from the
  * interrupt handler.
  *
- * Enabling the video queue initializes parameters (such as sequence number,
- * sync pattern, ...). If the queue is already enabled, return -EBUSY.
+ * Enabling the video queue returns -EBUSY if the queue is already enabled.
  *
  * Disabling the video queue cancels the queue and removes all buffers from
  * the main queue.
@@ -430,7 +428,6 @@ int uvc_queue_enable(struct uvc_video_queue *queue, int enable)
 			ret = -EBUSY;
 			goto done;
 		}
-		queue->sequence = 0;
 		queue->flags |= UVC_QUEUE_STREAMING;
 		queue->buf_used = 0;
 	} else {
@@ -510,8 +507,6 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 		nextbuf = NULL;
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
-	buf->buf.sequence = queue->sequence++;
-
 	wake_up(&buf->wait);
 	return nextbuf;
 }
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 5a2022c..39d4e70 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -427,6 +427,12 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 
 	fid = data[1] & UVC_STREAM_FID;
 
+	/* Increase the sequence number regardless of any buffer states, so
+	 * that discontinuous sequence numbers always indicate lost frames.
+	 */
+	if (stream->last_fid != fid)
+		stream->sequence++;
+
 	/* Store the payload FID bit and return immediately when the buffer is
 	 * NULL.
 	 */
@@ -460,6 +466,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 		else
 			ktime_get_real_ts(&ts);
 
+		buf->buf.sequence = stream->sequence;
 		buf->buf.timestamp.tv_sec = ts.tv_sec;
 		buf->buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 
@@ -721,6 +728,7 @@ static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
 		if (buf->buf.bytesused == stream->queue.buf_used) {
 			stream->queue.buf_used = 0;
 			buf->state = UVC_BUF_STATE_READY;
+			buf->buf.sequence = stream->sequence++;
 			uvc_queue_next_buffer(&stream->queue, buf);
 			stream->last_fid ^= UVC_STREAM_FID;
 		}
@@ -979,6 +987,7 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 	unsigned int i;
 	int ret;
 
+	stream->sequence = 0;
 	stream->last_fid = -1;
 	stream->bulk.header_size = 0;
 	stream->bulk.skip_payload = 0;
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 892e0e5..f890133 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -392,7 +392,6 @@ struct uvc_video_queue {
 
 	void *mem;
 	unsigned int flags;
-	__u32 sequence;
 
 	unsigned int count;
 	unsigned int buf_size;
@@ -458,6 +457,7 @@ struct uvc_streaming {
 	dma_addr_t urb_dma[UVC_URBS];
 	unsigned int urb_size;
 
+	__u32 sequence;
 	__u8 last_fid;
 };
 
-- 
1.7.2.2

