Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:41629 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731528AbeKMTkB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 14:40:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/9] vb2: add tag support
Date: Tue, 13 Nov 2018 10:42:31 +0100
Message-Id: <20181113094238.48253-3-hverkuil@xs4all.nl>
In-Reply-To: <20181113094238.48253-1-hverkuil@xs4all.nl>
References: <20181113094238.48253-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for tags to vb2. Besides just storing and setting
the tag this patch also adds the vb2_find_tag() function that
can be used to find a buffer with the given tag.

This function will only look at DEQUEUED and DONE buffers, i.e.
buffers that are already processed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/common/videobuf2/videobuf2-v4l2.c   | 43 ++++++++++++++++---
 include/media/videobuf2-v4l2.h                | 21 ++++++++-
 2 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index a17033ab2c22..36781d2367a9 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -50,7 +50,8 @@ module_param(debug, int, 0644);
 				 V4L2_BUF_FLAG_TIMESTAMP_MASK)
 /* Output buffer flags that should be passed on to the driver */
 #define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME | \
-				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
+				 V4L2_BUF_FLAG_KEYFRAME | \
+				 V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_TAG)
 
 /*
  * __verify_planes_array() - verify that the planes array passed in struct
@@ -144,8 +145,11 @@ static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
 		 */
 		if (q->copy_timestamp)
 			vb->timestamp = timeval_to_ns(&b->timestamp);
-		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
-		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
+		vbuf->flags |= b->flags &
+			(V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_TAG);
+		if (b->flags & V4L2_BUF_FLAG_TAG)
+			vbuf->tag = v4l2_buffer_get_tag(b);
+		else if (b->flags & V4L2_BUF_FLAG_TIMECODE)
 			vbuf->timecode = b->timecode;
 	}
 };
@@ -195,6 +199,7 @@ static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b
 	}
 	vbuf->sequence = 0;
 	vbuf->request_fd = -1;
+	vbuf->tag = 0;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		switch (b->memory) {
@@ -314,13 +319,19 @@ static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b
 	}
 
 	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
+		if ((b->flags & V4L2_BUF_FLAG_TIMECODE) &&
+		    (b->flags & V4L2_BUF_FLAG_TAG)) {
+			dprintk(1, "buffer flag TIMECODE cannot be combined with flag TAG\n");
+			return -EINVAL;
+		}
+
 		/*
 		 * For output buffers mask out the timecode flag:
 		 * this will be handled later in vb2_qbuf().
 		 * The 'field' is valid metadata for this output buffer
 		 * and so that needs to be copied here.
 		 */
-		vbuf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
+		vbuf->flags &= ~(V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_TAG);
 		vbuf->field = b->field;
 	} else {
 		/* Zero any output buffer flags as this is a capture buffer */
@@ -461,7 +472,10 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->flags = vbuf->flags;
 	b->field = vbuf->field;
 	b->timestamp = ns_to_timeval(vb->timestamp);
-	b->timecode = vbuf->timecode;
+	if (b->flags & V4L2_BUF_FLAG_TAG)
+		v4l2_buffer_set_tag(b, vbuf->tag);
+	else
+		b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
 	b->reserved2 = 0;
 	b->request_fd = 0;
@@ -587,6 +601,25 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
 	.copy_timestamp		= __copy_timestamp,
 };
 
+int vb2_find_tag(const struct vb2_queue *q, u64 tag,
+		 unsigned int start_idx)
+{
+	unsigned int i;
+
+	for (i = start_idx; i < q->num_buffers; i++) {
+		struct vb2_buffer *vb = q->bufs[i];
+		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+		if ((vb->state == VB2_BUF_STATE_DEQUEUED ||
+		     vb->state == VB2_BUF_STATE_DONE) &&
+		    (vbuf->flags & V4L2_BUF_FLAG_TAG) &&
+		    vbuf->tag == tag)
+			return i;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(vb2_find_tag);
+
 /*
  * vb2_querybuf() - query video buffer information
  * @q:		videobuf queue
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 727855463838..60ff7348a2b6 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -31,8 +31,9 @@
  * @field:	field order of the image in the buffer, as defined by
  *		&enum v4l2_field.
  * @timecode:	frame timecode.
+ * @tag:	user specified buffer tag value.
  * @sequence:	sequence count of this frame.
- * @request_fd:	the request_fd associated with this buffer
+ * @request_fd:	the request_fd associated with this buffer.
  * @planes:	plane information (userptr/fd, length, bytesused, data_offset).
  *
  * Should contain enough information to be able to cover all the fields
@@ -44,6 +45,7 @@ struct vb2_v4l2_buffer {
 	__u32			flags;
 	__u32			field;
 	struct v4l2_timecode	timecode;
+	__u64			tag;
 	__u32			sequence;
 	__s32			request_fd;
 	struct vb2_plane	planes[VB2_MAX_PLANES];
@@ -55,6 +57,23 @@ struct vb2_v4l2_buffer {
 #define to_vb2_v4l2_buffer(vb) \
 	container_of(vb, struct vb2_v4l2_buffer, vb2_buf)
 
+/**
+ * vb2_find_tag() - Find buffer with given tag in the queue
+ *
+ * @q:		pointer to &struct vb2_queue with videobuf2 queue.
+ * @tag:	the tag to find. Only buffers in state DEQUEUED or DONE
+ *		are considered.
+ * @start_idx:	the start index (usually 0) in the buffer array to start
+ *		searching from. Note that there may be multiple buffers
+ *		with the same tag value, so you can restart the search
+ *		by setting @start_idx to the previously found index + 1.
+ *
+ * Returns the buffer index of the buffer with the given @tag, or
+ * -1 if no buffer with @tag was found.
+ */
+int vb2_find_tag(const struct vb2_queue *q, u64 tag,
+		    unsigned int start_idx);
+
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
 
 /**
-- 
2.19.1
