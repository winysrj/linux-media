Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17798 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702Ab2DJNKx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 09:10:53 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M29008KKLXYGK@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:47 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900EMKLY2XY@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:50 +0100 (BST)
Date: Tue, 10 Apr 2012 15:10:35 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 01/13] v4l: add buffer exporting via dmabuf
In-reply-to: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334063447-16824-2-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds extension to V4L2 api. It allow to export a mmap buffer as file
descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset used by
mmap and return a file descriptor on success.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    1 +
 drivers/media/video/v4l2-ioctl.c          |    7 +++++++
 include/linux/videodev2.h                 |   23 +++++++++++++++++++++++
 include/media/v4l2-ioctl.h                |    2 ++
 4 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 2829d25..f32b291 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -954,6 +954,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_S_FBUF32:
 	case VIDIOC_OVERLAY32:
 	case VIDIOC_QBUF32:
+	case VIDIOC_EXPBUF:
 	case VIDIOC_DQBUF32:
 	case VIDIOC_STREAMON32:
 	case VIDIOC_STREAMOFF32:
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 5b2ec1f..3ca9d68 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -207,6 +207,7 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_S_FBUF)]           = "VIDIOC_S_FBUF",
 	[_IOC_NR(VIDIOC_OVERLAY)]          = "VIDIOC_OVERLAY",
 	[_IOC_NR(VIDIOC_QBUF)]             = "VIDIOC_QBUF",
+	[_IOC_NR(VIDIOC_EXPBUF)]           = "VIDIOC_EXPBUF",
 	[_IOC_NR(VIDIOC_DQBUF)]            = "VIDIOC_DQBUF",
 	[_IOC_NR(VIDIOC_STREAMON)]         = "VIDIOC_STREAMON",
 	[_IOC_NR(VIDIOC_STREAMOFF)]        = "VIDIOC_STREAMOFF",
@@ -938,6 +939,12 @@ static long __video_do_ioctl(struct file *file,
 			dbgbuf(cmd, vfd, p);
 		break;
 	}
+	case VIDIOC_EXPBUF:
+	{
+		if (ops->vidioc_expbuf)
+			ret = ops->vidioc_expbuf(file, fh, arg);
+		break;
+	}
 	case VIDIOC_DQBUF:
 	{
 		struct v4l2_buffer *p = arg;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 38259bf..627e235 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -680,6 +680,28 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
 #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
 
+/**
+ * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
+ *
+ * @fd:		file descriptor associated with DMABUF (set by driver)
+ * @mem_offset:	a "cookie" that is passed to mmap() as offset
+ * @flags:	flags for newly created file, currently only O_CLOEXEC is
+ *		supported, refer to manual of open syscall for more details
+ *
+ * Contains data used for exporting a video buffer as DMABUF file
+ * descriptor. Uses the same 'cookie' as mmap() syscall. All reserved fields
+ * must be set to zero. The field reserved0 is expected to become a structure
+ * 'type' allowing an alternative layout of the structure content. Therefore
+ * this field should not be used for any other extensions.
+ */
+struct v4l2_exportbuffer {
+	__u32		fd;
+	__u32		reserved0;
+	__u32		mem_offset;
+	__u32		flags;
+	__u32		reserved[12];
+};
+
 /*
  *	O V E R L A Y   P R E V I E W
  */
@@ -2327,6 +2349,7 @@ struct v4l2_create_buffers {
 #define VIDIOC_S_FBUF		 _IOW('V', 11, struct v4l2_framebuffer)
 #define VIDIOC_OVERLAY		 _IOW('V', 14, int)
 #define VIDIOC_QBUF		_IOWR('V', 15, struct v4l2_buffer)
+#define VIDIOC_EXPBUF		_IOWR('V', 16, struct v4l2_exportbuffer)
 #define VIDIOC_DQBUF		_IOWR('V', 17, struct v4l2_buffer)
 #define VIDIOC_STREAMON		 _IOW('V', 18, int)
 #define VIDIOC_STREAMOFF	 _IOW('V', 19, int)
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 3cb939c..c161ec3 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -119,6 +119,8 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
 	int (*vidioc_querybuf)(struct file *file, void *fh, struct v4l2_buffer *b);
 	int (*vidioc_qbuf)    (struct file *file, void *fh, struct v4l2_buffer *b);
+	int (*vidioc_expbuf)  (struct file *file, void *fh,
+				struct v4l2_exportbuffer *e);
 	int (*vidioc_dqbuf)   (struct file *file, void *fh, struct v4l2_buffer *b);
 
 	int (*vidioc_create_bufs)(struct file *file, void *fh, struct v4l2_create_buffers *b);
-- 
1.7.5.4

