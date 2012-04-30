Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:43076 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab2D3NfD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 09:35:03 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
Date: Mon, 30 Apr 2012 16:34:58 +0300
Message-Id: <1335792898-28620-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120430130413.GL7913@valkosipuli.localdomain>
References: <20120430130413.GL7913@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove input field in struct v4l2_buffer and flag V4L2_BUF_FLAG_INPUT which
tells the former is valid. The flag is used by no driver currently.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
Hi all,

I thought this would be a good time to get rid of the input field in
v4l2_buffer to avoid writing more useless compat code for it --- the enum
compat code.

Comments are welcome. This patch is compile tested on videobuf and
videobuf2.

Update: Fixes according to Laurent's comments. All drivers available on x86
and arm (N9) have been compile tested. Changes to the previous patch:

- videobuf2 comment fix (the input field is no longer there).
- cpia driver still contained a reference to input field and also needed
  changes to handling of the reserved field.
- Bring back UNSET. While this is no longer used in videobuf as the result
  of the removal of the input field, it is quite widely misused outside
  videobuf, and removing it should be a separate patch.

 drivers/media/video/cpia2/cpia2_v4l.c     |    3 +--
 drivers/media/video/v4l2-compat-ioctl32.c |    8 +++-----
 drivers/media/video/videobuf-core.c       |   16 ----------------
 drivers/media/video/videobuf2-core.c      |    6 ++----
 include/linux/videodev2.h                 |    4 +---
 5 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index 077eb1d..1ed633f 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -1289,8 +1289,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	buf->sequence = cam->buffers[buf->index].seq;
 	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
 	buf->length = cam->frame_size;
-	buf->input = 0;
-	buf->reserved = 0;
+	memset(buf->reserved, 0, sizeof(buf->reserved));
 	memset(&buf->timecode, 0, sizeof(buf->timecode));
 
 	DBG("DQBUF #%d status:%d seq:%d length:%d\n", buf->index,
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 2829d25..a2ddc37 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -387,8 +387,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		get_user(kp->index, &up->index) ||
 		get_user(kp->type, &up->type) ||
 		get_user(kp->flags, &up->flags) ||
-		get_user(kp->memory, &up->memory) ||
-		get_user(kp->input, &up->input))
+		get_user(kp->memory, &up->memory)
 			return -EFAULT;
 
 	if (V4L2_TYPE_IS_OUTPUT(kp->type))
@@ -472,8 +471,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->index, &up->index) ||
 		put_user(kp->type, &up->type) ||
 		put_user(kp->flags, &up->flags) ||
-		put_user(kp->memory, &up->memory) ||
-		put_user(kp->input, &up->input))
+		put_user(kp->memory, &up->memory)
 			return -EFAULT;
 
 	if (put_user(kp->bytesused, &up->bytesused) ||
@@ -482,7 +480,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
 		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
 		put_user(kp->sequence, &up->sequence) ||
-		put_user(kp->reserved, &up->reserved))
+		copy_to_user(&kp->reserved, &up->reserved, sizeof(kp->reserved))
 			return -EFAULT;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index ffdf59c..bf7a326 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -359,11 +359,6 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 		break;
 	}
 
-	if (vb->input != UNSET) {
-		b->flags |= V4L2_BUF_FLAG_INPUT;
-		b->input  = vb->input;
-	}
-
 	b->field     = vb->field;
 	b->timestamp = vb->ts;
 	b->bytesused = vb->size;
@@ -402,7 +397,6 @@ int __videobuf_mmap_setup(struct videobuf_queue *q,
 			break;
 
 		q->bufs[i]->i      = i;
-		q->bufs[i]->input  = UNSET;
 		q->bufs[i]->memory = memory;
 		q->bufs[i]->bsize  = bsize;
 		switch (memory) {
@@ -566,16 +560,6 @@ int videobuf_qbuf(struct videobuf_queue *q, struct v4l2_buffer *b)
 		goto done;
 	}
 
-	if (b->flags & V4L2_BUF_FLAG_INPUT) {
-		if (b->input >= q->inputs) {
-			dprintk(1, "qbuf: wrong input.\n");
-			goto done;
-		}
-		buf->input = b->input;
-	} else {
-		buf->input = UNSET;
-	}
-
 	switch (b->memory) {
 	case V4L2_MEMORY_MMAP:
 		if (0 == buf->baddr) {
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 3786d88..61a89fb 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -336,10 +336,9 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	struct vb2_queue *q = vb->vb2_queue;
 	int ret;
 
-	/* Copy back data such as timestamp, flags, input, etc. */
+	/* Copy back data such as timestamp, flags, etc. */
 	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
-	b->input = vb->v4l2_buf.input;
-	b->reserved = vb->v4l2_buf.reserved;
+	memcpy(b->reserved, vb->v4l2_buf.reserved, sizeof(b->reserved));
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
 		ret = __verify_planes_array(vb, b);
@@ -860,7 +859,6 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 
 	vb->v4l2_buf.field = b->field;
 	vb->v4l2_buf.timestamp = b->timestamp;
-	vb->v4l2_buf.input = b->input;
 	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_STATE_FLAGS;
 
 	return 0;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5a09ac3..ae3062d 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -652,8 +652,7 @@ struct v4l2_buffer {
 		struct v4l2_plane *planes;
 	} m;
 	__u32			length;
-	__u32			input;
-	__u32			reserved;
+	__u32			reserved[2];
 };
 
 /*  Flags for 'flags' field */
@@ -666,7 +665,6 @@ struct v4l2_buffer {
 /* Buffer is ready, but the data contained within is corrupted. */
 #define V4L2_BUF_FLAG_ERROR	0x0040
 #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
-#define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
 #define V4L2_BUF_FLAG_PREPARED	0x0400	/* Buffer is prepared for queuing */
 /* Cache handling flags */
 #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
-- 
1.7.2.5

