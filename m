Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33703 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755591AbdIGSml (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 14:42:41 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v3 02/15] [media] vb2: add explicit fence user API
Date: Thu,  7 Sep 2017 15:42:13 -0300
Message-Id: <20170907184226.27482-3-gustavo@padovan.org>
In-Reply-To: <20170907184226.27482-1-gustavo@padovan.org>
References: <20170907184226.27482-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Turn the reserved2 field into fence_fd that we will use to send
an in-fence to the kernel and return an out-fence from the kernel to
userspace.

Two new flags were added, V4L2_BUF_FLAG_IN_FENCE, that should be used
when sending a fence to the kernel to be waited on, and
V4L2_BUF_FLAG_OUT_FENCE, to ask the kernel to give back an out-fence.

v2: add documentation

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/buffer.rst       | 19 +++++++++++++++++++
 drivers/media/usb/cpia2/cpia2_v4l.c           |  2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  4 ++--
 drivers/media/v4l2-core/videobuf2-v4l2.c      |  2 +-
 include/uapi/linux/videodev2.h                |  4 +++-
 5 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index ae6ee73f151c..664507ad06c6 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -648,6 +648,25 @@ Buffer Flags
       - Start Of Exposure. The buffer timestamp has been taken when the
 	exposure of the frame has begun. This is only valid for the
 	``V4L2_BUF_TYPE_VIDEO_CAPTURE`` buffer type.
+    * .. _`V4L2-BUF-FLAG-IN-FENCE`:
+
+      - ``V4L2_BUF_FLAG_IN_FENCE``
+      - 0x00200000
+      - Ask V4L2 to wait on fence passed in ``fence_fd`` field. The buffer
+	won't be queued to the driver until the fence signals.
+
+    * .. _`V4L2-BUF-FLAG-OUT-FENCE`:
+
+      - ``V4L2_BUF_FLAG_OUT_FENCE``
+      - 0x00400000
+      - Request a fence for the next buffer to be queued to V4L2 driver.
+	The fence received back through the ``fence_fd`` field  doesn't
+	necessarily relate to the current buffer in the
+	:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl. Although, most of the time
+	the fence will relate to the current buffer it can't be guaranteed.
+	So to tell userspace which buffer is associated to the out_fence,
+	one should listen for the ``V4L2_EVENT_BUF_QUEUED`` event that
+	provide the id of the buffer when it is queued to the V4L2 driver.
 
 
 
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 3dedd83f0b19..6cde686bf44c 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -948,7 +948,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	buf->sequence = cam->buffers[buf->index].seq;
 	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
 	buf->length = cam->frame_size;
-	buf->reserved2 = 0;
+	buf->fence_fd = -1;
 	buf->reserved = 0;
 	memset(&buf->timecode, 0, sizeof(buf->timecode));
 
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 821f2aa299ae..d624fb5df130 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -370,7 +370,7 @@ struct v4l2_buffer32 {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__s32			fence_fd;
 	__u32			reserved;
 };
 
@@ -533,8 +533,8 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
 		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
 		put_user(kp->sequence, &up->sequence) ||
-		put_user(kp->reserved2, &up->reserved2) ||
 		put_user(kp->reserved, &up->reserved) ||
+		put_user(kp->fence_fd, &up->fence_fd) ||
 		put_user(kp->length, &up->length))
 			return -EFAULT;
 
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 0c0669976bdc..110fb45fef6f 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -203,7 +203,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->timestamp = ns_to_timeval(vb->timestamp);
 	b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
-	b->reserved2 = 0;
+	b->fence_fd = -1;
 	b->reserved = 0;
 
 	if (q->is_multiplanar) {
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 185d6a0acc06..e5abab9a908c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -924,7 +924,7 @@ struct v4l2_buffer {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__s32			fence_fd;
 	__u32			reserved;
 };
 
@@ -961,6 +961,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
 /* mem2mem encoder/decoder */
 #define V4L2_BUF_FLAG_LAST			0x00100000
+#define V4L2_BUF_FLAG_IN_FENCE			0x00200000
+#define V4L2_BUF_FLAG_OUT_FENCE			0x00400000
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-- 
2.13.5
