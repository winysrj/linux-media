Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45700 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752388AbaCANN7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 08:13:59 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: [PATH v6 01/10] vb2: fix timecode and flags handling for output buffers
Date: Sat,  1 Mar 2014 15:16:58 +0200
Message-Id: <1393679828-25878-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi>
References: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi>
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
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/v4l2-core/videobuf2-core.c |   35 ++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5a5fb7f..edab3af 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -40,10 +40,14 @@ module_param(debug, int, 0644);
 #define call_qop(q, op, args...)					\
 	(((q)->ops->op) ? ((q)->ops->op(args)) : 0)
 
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
@@ -1025,9 +1029,21 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 
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
 
 /**
@@ -1261,6 +1277,10 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	}
 
 	vb->state = VB2_BUF_STATE_PREPARING;
+	vb->v4l2_buf.timestamp.tv_sec = 0;
+	vb->v4l2_buf.timestamp.tv_usec = 0;
+	vb->v4l2_buf.sequence = 0;
+
 	switch (q->memory) {
 	case V4L2_MEMORY_MMAP:
 		ret = __qbuf_mmap(vb, b);
@@ -1448,6 +1468,17 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 */
 	list_add_tail(&vb->queued_entry, &q->queued_list);
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
1.7.10.4

