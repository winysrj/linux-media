Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2376 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaBYKE7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 16/20] vb2: fix timecode and flags handling for output buffers
Date: Tue, 25 Feb 2014 11:04:21 +0100
Message-Id: <1393322665-29889-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When sending a buffer to a video output device some of the fields need
to be copied so they arrive in the driver. These are the KEY/P/BFRAME
flags and the TIMECODE flag, and, if that flag is set, the timecode field
itself.

There are a number of functions involved in this: the __fill_vb2_buffer()
is called while preparing a buffer. For output buffers the buffer contains
the video data, so any meta data associated with that (KEY/P/BFRAME and
the field information) should be stored at that point.

The timecode, timecode flag and timestamp information is not part of that,
that information will have to be set when vb2_internal_qbuf() is called to
actually queue the buffer to the driver. Usually VIDIOC_QBUF will do the
prepare as well, but you can call PREPARE_BUF first and only later VIDIOC_QBUF.
You most likely will want to set the timestamp and timecode when you actually
queue the buffer, not when you prepare it.

Finally, in buf_prepare() make sure the timestamp and sequence fields are
actually cleared so that when you do a QUERYBUF of a prepared-but-not-yet-queued
buffer you will not see stale timestamp/sequence data.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 35 ++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index b0d1ed9..2ac98ff 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -91,10 +91,14 @@ module_param(debug, int, 0644);
 
 #endif
 
+/* Flags that are set by the vb2 core */
 #define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED | \
 				 V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR | \
 				 V4L2_BUF_FLAG_PREPARED | \
 				 V4L2_BUF_FLAG_TIMESTAMP_MASK)
+/* Output buffer flags that should be passed on to the driver */
+#define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME | \
+				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
 
 /**
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
@@ -1204,9 +1208,21 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		}
 	}
 
-	vb->v4l2_buf.field = b->field;
-	vb->v4l2_buf.timestamp = b->timestamp;
+	/* Zero flags that the vb2 core handles */
 	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
+	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
+		/*
+		 * For output buffers mask out the timecode flag:
+		 * this will be handled later in vb2_internal_qbuf().
+		 * The 'field' is valid metadata for this output buffer
+		 * and so that needs to be copied here.
+		 */
+		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TIMECODE;
+		vb->v4l2_buf.field = b->field;
+	} else {
+		/* Zero any output buffer flags as this is a capture buffer */
+		vb->v4l2_buf.flags &= ~V4L2_BUFFER_OUT_FLAGS;
+	}
 }
 
 /*
@@ -1540,6 +1556,10 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	}
 
 	vb->state = VB2_BUF_STATE_PREPARING;
+	vb->v4l2_buf.timestamp.tv_sec = 0;
+	vb->v4l2_buf.timestamp.tv_usec = 0;
+	vb->v4l2_buf.sequence = 0;
+
 	switch (q->memory) {
 	case V4L2_MEMORY_MMAP:
 		ret = __qbuf_mmap(vb, b);
@@ -1739,6 +1759,17 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	list_add_tail(&vb->queued_entry, &q->queued_list);
 	q->queued_count++;
 	vb->state = VB2_BUF_STATE_QUEUED;
+	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		/*
+		 * For output buffers copy the timestamp if needed,
+		 * and the timecode field and flag if needed.
+		 */
+		if (q->timestamp_type == V4L2_BUF_FLAG_TIMESTAMP_COPY)
+			vb->v4l2_buf.timestamp = b->timestamp;
+		vb->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
+		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
+			vb->v4l2_buf.timecode = b->timecode;
+	}
 
 	/*
 	 * If already streaming, give the buffer to driver for processing.
-- 
1.9.0

