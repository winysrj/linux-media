Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44652 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbbLQIlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:05 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 25/48] videodev2.h: Add request field to v4l2_buffer
Date: Thu, 17 Dec 2015 10:40:03 +0200
Message-Id: <1450341626-6695-26-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When queuing buffers allow for passing the request ID that
should be associated with this buffer. Split the u32 reserved2 field
into two u16 fields, one for request, one with the old reserved2 name.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cpia2/cpia2_v4l.c           | 1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 +++-
 drivers/media/v4l2-core/v4l2-ioctl.c          | 4 ++--
 drivers/media/v4l2-core/videobuf2-v4l2.c      | 2 ++
 include/media/videobuf2-v4l2.h                | 2 ++
 include/uapi/linux/videodev2.h                | 4 +++-
 6 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 9caea8344547..01c596a4a760 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -952,6 +952,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	buf->sequence = cam->buffers[buf->index].seq;
 	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
 	buf->length = cam->frame_size;
+	buf->request = 0;
 	buf->reserved2 = 0;
 	buf->reserved = 0;
 	memset(&buf->timecode, 0, sizeof(buf->timecode));
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8fd84a67478a..ebd3cd4dee73 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -347,7 +347,8 @@ struct v4l2_buffer32 {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__u16			request;
+	__u16			reserved2;
 	__u32			reserved;
 };
 
@@ -512,6 +513,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
 		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
 		put_user(kp->sequence, &up->sequence) ||
+		put_user(kp->request, &up->request) ||
 		put_user(kp->reserved2, &up->reserved2) ||
 		put_user(kp->reserved, &up->reserved))
 			return -EFAULT;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 8a018c6dd16a..67a4aa760aa3 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -441,14 +441,14 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 	const struct v4l2_plane *plane;
 	int i;
 
-	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, "
+	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, request=%u, "
 		"flags=0x%08x, field=%s, sequence=%d, memory=%s",
 			p->timestamp.tv_sec / 3600,
 			(int)(p->timestamp.tv_sec / 60) % 60,
 			(int)(p->timestamp.tv_sec % 60),
 			(long)p->timestamp.tv_usec,
 			p->index,
-			prt_names(p->type, v4l2_type_names),
+			prt_names(p->type, v4l2_type_names), p->request,
 			p->flags, prt_names(p->field, v4l2_field_names),
 			p->sequence, prt_names(p->memory, v4l2_memory_names));
 
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 2d1e5b7d85a2..f6a2800e5f66 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -194,6 +194,7 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->timestamp = vbuf->timestamp;
 	b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
+	b->request = vbuf->request;
 	b->reserved2 = 0;
 	b->reserved = 0;
 
@@ -311,6 +312,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 	vbuf->timestamp.tv_sec = 0;
 	vbuf->timestamp.tv_usec = 0;
 	vbuf->sequence = 0;
+	vbuf->request = b->request;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		if (b->memory == VB2_MEMORY_USERPTR) {
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 5abab1e7c7e8..48d6a34dcdb4 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -31,6 +31,7 @@
  * @timestamp:	frame timestamp
  * @timecode:	frame timecode
  * @sequence:	sequence count of this frame
+ * @request:	request used by the buffer
  * Should contain enough information to be able to cover all the fields
  * of struct v4l2_buffer at videodev2.h
  */
@@ -42,6 +43,7 @@ struct vb2_v4l2_buffer {
 	struct timeval		timestamp;
 	struct v4l2_timecode	timecode;
 	__u32			sequence;
+	__u32			request;
 };
 
 /*
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 14cd5ebfee6d..5af1d2d87558 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -844,6 +844,7 @@ struct v4l2_plane {
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
  *		buffers (when type != *_MPLANE); number of elements in the
  *		planes array for multi-plane buffers
+ * @request: this buffer should use this request
  *
  * Contains data exchanged by application and driver using one of the Streaming
  * I/O methods.
@@ -867,7 +868,8 @@ struct v4l2_buffer {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__u16			request;
+	__u16			reserved2;
 	__u32			reserved;
 };
 
-- 
2.4.10

