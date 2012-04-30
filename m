Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:46217 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab2D3Mke (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 08:40:34 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
Date: Mon, 30 Apr 2012 15:40:24 +0300
Message-Id: <1335789624-15940-1-git-send-email-sakari.ailus@iki.fi>
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

 drivers/media/video/v4l2-compat-ioctl32.c |    8 +++-----
 drivers/media/video/videobuf-core.c       |   16 ----------------
 drivers/media/video/videobuf2-core.c      |    4 +---
 include/linux/videodev2.h                 |    4 +---
 include/media/videobuf-core.h             |    2 --
 5 files changed, 5 insertions(+), 29 deletions(-)

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
index 3786d88..0daaec7 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -338,8 +338,7 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 
 	/* Copy back data such as timestamp, flags, input, etc. */
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
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index 90ed895..4511d75 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -19,8 +19,6 @@
 #include <linux/poll.h>
 #include <linux/videodev2.h>
 
-#define UNSET (-1U)
-
 
 struct videobuf_buffer;
 struct videobuf_queue;
-- 
1.7.2.5

