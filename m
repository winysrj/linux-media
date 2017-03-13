Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36380 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdCMTUr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 15:20:47 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC 01/10] [media] vb2: add explicit fence user API
Date: Mon, 13 Mar 2017 16:20:26 -0300
Message-Id: <20170313192035.29859-2-gustavo@padovan.org>
In-Reply-To: <20170313192035.29859-1-gustavo@padovan.org>
References: <20170313192035.29859-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Turn the reserved2 field into fence_fd that we will use to send
an in-fence to the kernel return an out-fence from the kernel to
userspace.

Two new flags were added, V4L2_BUF_FLAG_IN_FENCE and
V4L2_BUF_FLAG_OUT_FENCE. They should be used when setting in-fence and
out-fence, respectively.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 ++--
 drivers/media/v4l2-core/videobuf2-v4l2.c      | 2 +-
 include/uapi/linux/videodev2.h                | 6 ++++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index eac9565..0a522cb 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -348,7 +348,7 @@ struct v4l2_buffer32 {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__s32			fence_fd;
 	__u32			reserved;
 };
 
@@ -511,7 +511,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
 		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
 		put_user(kp->sequence, &up->sequence) ||
-		put_user(kp->reserved2, &up->reserved2) ||
+		put_user(kp->fence_fd, &up->fence_fd) ||
 		put_user(kp->reserved, &up->reserved) ||
 		put_user(kp->length, &up->length))
 			return -EFAULT;
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 3529849..d23c1bf 100644
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
index 45184a2..3b6cfa6 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -911,7 +911,7 @@ struct v4l2_buffer {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__s32			fence_fd;
 	__u32			reserved;
 };
 
@@ -946,8 +946,10 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TSTAMP_SRC_MASK		0x00070000
 #define V4L2_BUF_FLAG_TSTAMP_SRC_EOF		0x00000000
 #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
+#define V4L2_BUF_FLAG_IN_FENCE			0x00100000
+#define V4L2_BUF_FLAG_OUT_FENCE			0x00200000
 /* mem2mem encoder/decoder */
-#define V4L2_BUF_FLAG_LAST			0x00100000
+#define V4L2_BUF_FLAG_LAST			0x00400000
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-- 
2.9.3
