Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:7253 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752176AbeCWVS1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 17:18:27 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, acourbot@chromium.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC v2 03/10] videodev2.h: Add request_fd field to v4l2_buffer
Date: Fri, 23 Mar 2018 23:17:37 +0200
Message-Id: <1521839864-10146-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When queuing buffers allow for passing the request that should
be associated with this buffer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[acourbot@chromium.org: make request ID 32-bit]
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
[Sakari Ailus: requests fds are int; use assign_in_user in get_v4l2_buffer]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c             | 2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c   | 7 ++++---
 drivers/media/v4l2-core/v4l2-ioctl.c            | 4 ++--
 include/uapi/linux/videodev2.h                  | 3 ++-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 886a2d8..6d4d184 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -203,7 +203,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->timestamp = ns_to_timeval(vb->timestamp);
 	b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
-	b->reserved2 = 0;
+	b->request_fd = 0;
 	b->reserved = 0;
 
 	if (q->is_multiplanar) {
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 99f106b..af42ce3 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -948,7 +948,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	buf->sequence = cam->buffers[buf->index].seq;
 	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
 	buf->length = cam->frame_size;
-	buf->reserved2 = 0;
+	buf->request_fd = 0;
 	buf->reserved = 0;
 	memset(&buf->timecode, 0, sizeof(buf->timecode));
 
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 5198c9e..61a8bd4 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -386,7 +386,7 @@ struct v4l2_buffer32 {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__s32			request_fd;
 	__u32			reserved;
 };
 
@@ -500,7 +500,8 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *kp,
 	    get_user(memory, &up->memory) ||
 	    put_user(memory, &kp->memory) ||
 	    get_user(length, &up->length) ||
-	    put_user(length, &kp->length))
+	    put_user(length, &kp->length) ||
+	    assign_in_user(&kp->request_fd, &up->request_fd))
 		return -EFAULT;
 
 	if (V4L2_TYPE_IS_OUTPUT(type))
@@ -604,7 +605,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
 	    assign_in_user(&up->timestamp.tv_usec, &kp->timestamp.tv_usec) ||
 	    copy_in_user(&up->timecode, &kp->timecode, sizeof(kp->timecode)) ||
 	    assign_in_user(&up->sequence, &kp->sequence) ||
-	    assign_in_user(&up->reserved2, &kp->reserved2) ||
+	    assign_in_user(&up->request_fd, &kp->request_fd) ||
 	    assign_in_user(&up->reserved, &kp->reserved) ||
 	    get_user(length, &kp->length) ||
 	    put_user(length, &up->length))
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 672ab22..c2671de 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -437,13 +437,13 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 	const struct v4l2_plane *plane;
 	int i;
 
-	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, flags=0x%08x, field=%s, sequence=%d, memory=%s",
+	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, request_fd=%d, flags=0x%08x, field=%s, sequence=%d, memory=%s",
 			p->timestamp.tv_sec / 3600,
 			(int)(p->timestamp.tv_sec / 60) % 60,
 			(int)(p->timestamp.tv_sec % 60),
 			(long)p->timestamp.tv_usec,
 			p->index,
-			prt_names(p->type, v4l2_type_names),
+			prt_names(p->type, v4l2_type_names), p->request_fd,
 			p->flags, prt_names(p->field, v4l2_field_names),
 			p->sequence, prt_names(p->memory, v4l2_memory_names));
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 600877b..d39932d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -910,6 +910,7 @@ struct v4l2_plane {
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
  *		buffers (when type != *_MPLANE); number of elements in the
  *		planes array for multi-plane buffers
+ * @request_fd: fd of the request that this buffer should use
  *
  * Contains data exchanged by application and driver using one of the Streaming
  * I/O methods.
@@ -933,7 +934,7 @@ struct v4l2_buffer {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__s32			request_fd;
 	__u32			reserved;
 };
 
-- 
2.7.4
