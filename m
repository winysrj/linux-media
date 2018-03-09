Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:44829 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932288AbeCIRuG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 12:50:06 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v8 08/13] [media] vb2: add explicit fence user API
Date: Fri,  9 Mar 2018 14:49:15 -0300
Message-Id: <20180309174920.22373-9-gustavo@padovan.org>
In-Reply-To: <20180309174920.22373-1-gustavo@padovan.org>
References: <20180309174920.22373-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Turn the reserved2 field into fence_fd that we will use to send
an in-fence to the kernel or return an out-fence from the kernel to
userspace.

Two new flags were added, V4L2_BUF_FLAG_IN_FENCE, that should be used
when sending a fence to the kernel to be waited on, and
V4L2_BUF_FLAG_OUT_FENCE, to ask the kernel to give back an out-fence.

v6:	- big improvement on doc (Hans Verkuil)

v5:
	- keep using reserved2 field for cpia2
	- set fence_fd to 0 for now, for compat with userspace(Mauro)

v4:
	- make it a union with reserved2 and fence_fd (Hans Verkuil)

v3:
	- make the out_fence refer to the current buffer (Hans Verkuil)

v2: add documentation

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 Documentation/media/uapi/v4l/buffer.rst         | 45 +++++++++++++++++++++++--
 drivers/media/common/videobuf2/videobuf2-v4l2.c |  2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c   |  4 +--
 include/uapi/linux/videodev2.h                  |  7 +++-
 4 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index e2c85ddc990b..49273026740f 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -301,10 +301,22 @@ struct v4l2_buffer
 	elements in the ``planes`` array. The driver will fill in the
 	actual number of valid elements in that array.
     * - __u32
-      - ``reserved2``
+      - ``fence_fd``
       -
-      - A place holder for future extensions. Drivers and applications
-	must set this to 0.
+      - Used to communicate fences file descriptors from userspace to kernel
+	and vice-versa. On :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` when sending
+	an in-fence for V4L2 to wait on, the ``V4L2_BUF_FLAG_IN_FENCE`` flag must
+	be used and this field set to the fence file descriptor of the in-fence
+	If the in-fence is not valid ` VIDIOC_QBUF`` returns an error.
+
+        To get an out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE``
+	must be set, the kernel will return the out-fence file descriptor on
+	this field. If it fails to create the out-fence ``VIDIOC_QBUF` returns
+        an error.
+
+	In all other ioctls V4L2 sets this field to -1 if
+	``V4L2_BUF_FLAG_IN_FENCE`` and/or ``V4L2_BUF_FLAG_OUT_FENCE`` are set,
+	otherwise this field is set to 0 for backward compatibility.
     * - __u32
       - ``reserved``
       -
@@ -648,6 +660,33 @@ Buffer Flags
       - Start Of Exposure. The buffer timestamp has been taken when the
 	exposure of the frame has begun. This is only valid for the
 	``V4L2_BUF_TYPE_VIDEO_CAPTURE`` buffer type.
+    * .. _`V4L2-BUF-FLAG-IN-FENCE`:
+
+      - ``V4L2_BUF_FLAG_IN_FENCE``
+      - 0x00200000
+      - Ask V4L2 to wait on the fence passed in the ``fence_fd`` field. The
+	buffer won't be queued to the driver until the fence signals. The order
+	in which buffers are queued is guaranteed to be preserved, so any
+	buffers queued after this buffer will also be blocked until this fence
+	signals. This flag must be set before calling ``VIDIOC_QBUF``. For
+	other ioctls the driver just report the value of the flag.
+
+        If the fence signals the flag is cleared and not reported anymore.
+	If the fence is not valid ``VIDIOC_QBUF`` returns an error.
+
+
+    * .. _`V4L2-BUF-FLAG-OUT-FENCE`:
+
+      - ``V4L2_BUF_FLAG_OUT_FENCE``
+      - 0x00400000
+      - Request for a fence to be attached to the buffer. The driver will fill
+	in the out-fence fd in the ``fence_fd`` field when :ref:`VIDIOC_QBUF
+	<VIDIOC_QBUF>` returns. This flag must be set before calling
+	``VIDIOC_QBUF``. For other ioctls the driver just report the value of
+	the flag.
+
+        If the creation of the  out-fence  fails ``VIDIOC_QBUF`` returns an
+	error.
 
 
 
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 68291ba8632d..ad1e032c3bf5 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -203,7 +203,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->timestamp = ns_to_timeval(vb->timestamp);
 	b->timecode = vbuf->timecode;
 	b->sequence = vbuf->sequence;
-	b->reserved2 = 0;
+	b->fence_fd = 0;
 	b->reserved = 0;
 
 	if (q->is_multiplanar) {
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 5198c9eeb348..3de2252e3632 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -386,7 +386,7 @@ struct v4l2_buffer32 {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__s32			fence_fd;
 	__u32			reserved;
 };
 
@@ -604,7 +604,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
 	    assign_in_user(&up->timestamp.tv_usec, &kp->timestamp.tv_usec) ||
 	    copy_in_user(&up->timecode, &kp->timecode, sizeof(kp->timecode)) ||
 	    assign_in_user(&up->sequence, &kp->sequence) ||
-	    assign_in_user(&up->reserved2, &kp->reserved2) ||
+	    assign_in_user(&up->fence_fd, &kp->fence_fd) ||
 	    assign_in_user(&up->reserved, &kp->reserved) ||
 	    get_user(length, &kp->length) ||
 	    put_user(length, &up->length))
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 58894cfe9479..2d424aebdd1e 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -933,7 +933,10 @@ struct v4l2_buffer {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	union {
+		__s32		fence_fd;
+		__u32		reserved2;
+	};
 	__u32			reserved;
 };
 
@@ -970,6 +973,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
 /* mem2mem encoder/decoder */
 #define V4L2_BUF_FLAG_LAST			0x00100000
+#define V4L2_BUF_FLAG_IN_FENCE			0x00200000
+#define V4L2_BUF_FLAG_OUT_FENCE			0x00400000
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-- 
2.14.3
