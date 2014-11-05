Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17102 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbaKEQOK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 11:14:10 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: pj.assis@gmail.com
Cc: remi@remlab.net, notasas@gmail.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com
Subject: [RFC 1/2] uvc: Add a quirk flag for cameras that do not produce correct timestamps
Date: Wed,  5 Nov 2014 18:12:33 +0200
Message-Id: <1415203954-16718-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <20141105161147.GW3136@valkosipuli.retiisi.org.uk>
References: <20141105161147.GW3136@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The UVC devices do produce hardware timestamps according to the spec, but
not all cameras implement it or implement it correctly. Add a quirk flag for
such devices, and use monotonic timestamp from the end of the frame instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/usb/uvc/uvc_queue.c |  6 ++++--
 drivers/media/usb/uvc/uvc_video.c | 14 +++++++++++++-
 drivers/media/usb/uvc/uvcvideo.h  |  4 +++-
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 6e92d20..3f6432f 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -141,7 +141,7 @@ static struct vb2_ops uvc_queue_qops = {
 };
 
 int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
-		    int drop_corrupted)
+		   bool drop_corrupted, bool tstamp_eof)
 {
 	int ret;
 
@@ -152,7 +152,9 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 	queue->queue.ops = &uvc_queue_qops;
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
 	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
-		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
+		| (tstamp_eof ? V4L2_BUF_FLAG_TSTAMP_SRC_EOF
+		   : V4L2_BUF_FLAG_TSTAMP_SRC_SOE);
+
 	ret = vb2_queue_init(&queue->queue);
 	if (ret)
 		return ret;
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index df81b9c..f599112 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -382,6 +382,9 @@ uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
 	u16 host_sof;
 	u16 dev_sof;
 
+	if (stream->dev->quirks & UVC_QUIRK_BAD_TIMESTAMP)
+		return;
+
 	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
 	case UVC_STREAM_PTS | UVC_STREAM_SCR:
 		header_size = 12;
@@ -490,6 +493,9 @@ static int uvc_video_clock_init(struct uvc_streaming *stream)
 {
 	struct uvc_clock *clock = &stream->clock;
 
+	if (stream->dev->quirks & UVC_QUIRK_BAD_TIMESTAMP)
+		return 0;
+
 	spin_lock_init(&clock->lock);
 	clock->size = 32;
 
@@ -615,6 +621,11 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 	u32 rem;
 	u64 y;
 
+	if (stream->dev->quirks & UVC_QUIRK_BAD_TIMESTAMP) {
+		v4l2_get_timestamp(&v4l2_buf->timestamp);
+		return;
+	}
+
 	spin_lock_irqsave(&clock->lock, flags);
 
 	if (clock->count < clock->size)
@@ -1779,7 +1790,8 @@ int uvc_video_init(struct uvc_streaming *stream)
 	atomic_set(&stream->active, 0);
 
 	/* Initialize the video buffers queue. */
-	ret = uvc_queue_init(&stream->queue, stream->type, !uvc_no_drop_param);
+	ret = uvc_queue_init(&stream->queue, stream->type, !uvc_no_drop_param,
+			     stream->dev->quirks & UVC_QUIRK_BAD_TIMESTAMP);
 	if (ret)
 		return ret;
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 864ada7..89a638c 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -148,6 +148,7 @@
 #define UVC_QUIRK_PROBE_DEF		0x00000100
 #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
 #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
+#define UVC_QUIRK_BAD_TIMESTAMP		0x00000800
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
@@ -622,7 +623,8 @@ extern struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id);
 
 /* Video buffers queue management. */
 extern int uvc_queue_init(struct uvc_video_queue *queue,
-		enum v4l2_buf_type type, int drop_corrupted);
+		enum v4l2_buf_type type, bool drop_corrupted,
+		bool tstamp_eof);
 extern int uvc_alloc_buffers(struct uvc_video_queue *queue,
 		struct v4l2_requestbuffers *rb);
 extern void uvc_free_buffers(struct uvc_video_queue *queue);
-- 
2.1.0.231.g7484e3b

