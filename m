Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:58127 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbbDUM75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 08:59:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 03/15] videodev2.h: add request field to v4l2_buffer.
Date: Tue, 21 Apr 2015 14:58:46 +0200
Message-Id: <1429621138-17213-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
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
 drivers/media/v4l2-core/videobuf2-core.c      | 3 +++
 include/uapi/linux/videodev2.h                | 4 +++-
 5 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 9caea83..01c596a 100644
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
index af63543..9d5c380 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -326,7 +326,8 @@ struct v4l2_buffer32 {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__u16			request;
+	__u16			reserved2;
 	__u32			reserved;
 };
 
@@ -491,6 +492,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
 		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
 		put_user(kp->sequence, &up->sequence) ||
+		put_user(kp->request, &up->request) ||
 		put_user(kp->reserved2, &up->reserved2) ||
 		put_user(kp->reserved, &up->reserved))
 			return -EFAULT;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 74af586..d2d1fb1 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -438,14 +438,14 @@ static void v4l_print_buffer(const void *arg, bool write_only)
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
 
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 1329dcc..a0e4e84 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -657,6 +657,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 
 	/* Copy back data such as timestamp, flags, etc. */
 	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
+	b->request = vb->v4l2_buf.request;
 	b->reserved2 = vb->v4l2_buf.reserved2;
 	b->reserved = vb->v4l2_buf.reserved;
 
@@ -682,6 +683,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 		else if (q->memory == V4L2_MEMORY_DMABUF)
 			b->m.fd = vb->v4l2_planes[0].m.fd;
 	}
+	b->request = vb->v4l2_buf.request;
 
 	/*
 	 * Clear any buffer state related flags.
@@ -1352,6 +1354,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		 */
 		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	}
+	vb->v4l2_buf.request = b->request;
 
 	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 388e376..e59a5e3 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -752,6 +752,7 @@ struct v4l2_plane {
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
  *		buffers (when type != *_MPLANE); number of elements in the
  *		planes array for multi-plane buffers
+ * @request: this buffer should use this request
  *
  * Contains data exchanged by application and driver using one of the Streaming
  * I/O methods.
@@ -775,7 +776,8 @@ struct v4l2_buffer {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__u16			request;
+	__u16			reserved2;
 	__u32			reserved;
 };
 
-- 
2.1.4

