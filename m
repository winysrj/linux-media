Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33222 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753640AbdLOH5A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 02:57:00 -0500
Received: by mail-pf0-f195.google.com with SMTP id y89so5633400pfk.0
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 23:57:00 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 4/9] videodev2.h: Add request field to v4l2_buffer
Date: Fri, 15 Dec 2017 16:56:20 +0900
Message-Id: <20171215075625.27028-5-acourbot@chromium.org>
In-Reply-To: <20171215075625.27028-1-acourbot@chromium.org>
References: <20171215075625.27028-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When queuing buffers allow for passing the request ID that
should be associated with this buffer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[acourbot@chromium.org: make request ID 32-bit]
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/usb/cpia2/cpia2_v4l.c           | 2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 7 ++++---
 drivers/media/v4l2-core/v4l2-ioctl.c          | 4 ++--
 drivers/media/v4l2-core/videobuf2-v4l2.c      | 3 ++-
 include/media/videobuf2-v4l2.h                | 2 ++
 include/uapi/linux/videodev2.h                | 3 ++-
 6 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 3dedd83f0b19..7217dde95a8a 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -948,7 +948,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	buf->sequence = cam->buffers[buf->index].seq;
 	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
 	buf->length = cam->frame_size;
-	buf->reserved2 = 0;
+	buf->request = 0;
 	buf->reserved = 0;
 	memset(&buf->timecode, 0, sizeof(buf->timecode));
 
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 821f2aa299ae..94f07c3b0b53 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -370,7 +370,7 @@ struct v4l2_buffer32 {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__u32			request;
 	__u32			reserved;
 };
 
@@ -438,7 +438,8 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		get_user(kp->type, &up->type) ||
 		get_user(kp->flags, &up->flags) ||
 		get_user(kp->memory, &up->memory) ||
-		get_user(kp->length, &up->length))
+		get_user(kp->length, &up->length) ||
+		get_user(kp->request, &up->request))
 			return -EFAULT;
 
 	if (V4L2_TYPE_IS_OUTPUT(kp->type))
@@ -533,7 +534,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
 		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
 		put_user(kp->sequence, &up->sequence) ||
-		put_user(kp->reserved2, &up->reserved2) ||
+		put_user(kp->request, &up->request) ||
 		put_user(kp->reserved, &up->reserved) ||
 		put_user(kp->length, &up->length))
 			return -EFAULT;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index ec4ecd5aa8bf..8d041247e97f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -437,13 +437,13 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 	const struct v4l2_plane *plane;
 	int i;
 
-	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, flags=0x%08x, field=%s, sequence=%d, memory=%s",
+	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, request=%u, flags=0x%08x, field=%s, sequence=%d, memory=%s",
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
index 0c0669976bdc..bde7b8a3a303 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -203,7 +203,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->timestamp = ns_to_timeval(vb->timestamp);
 	b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
-	b->reserved2 = 0;
+	b->request = vbuf->request;
 	b->reserved = 0;
 
 	if (q->is_multiplanar) {
@@ -320,6 +320,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 	}
 	vb->timestamp = 0;
 	vbuf->sequence = 0;
+	vbuf->request = b->request;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		if (b->memory == VB2_MEMORY_USERPTR) {
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 036127c54bbf..ef2be0ccff14 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -31,6 +31,7 @@
  * @field:	enum v4l2_field; field order of the image in the buffer
  * @timecode:	frame timecode
  * @sequence:	sequence count of this frame
+ * @request:	request used by the buffer
  *
  * Should contain enough information to be able to cover all the fields
  * of struct v4l2_buffer at videodev2.h
@@ -42,6 +43,7 @@ struct vb2_v4l2_buffer {
 	__u32			field;
 	struct v4l2_timecode	timecode;
 	__u32			sequence;
+	__u32			request;
 };
 
 /*
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 1c095b5a99c5..0650e8d14971 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -902,6 +902,7 @@ struct v4l2_plane {
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
  *		buffers (when type != *_MPLANE); number of elements in the
  *		planes array for multi-plane buffers
+ * @request: this buffer should use this request
  *
  * Contains data exchanged by application and driver using one of the Streaming
  * I/O methods.
@@ -925,7 +926,7 @@ struct v4l2_buffer {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__u32			request;
 	__u32			reserved;
 };
 
-- 
2.15.1.504.g5279b80103-goog
