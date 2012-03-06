Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25078 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101Ab2CFLiU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 06:38:20 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0G00LFROBQ0I80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:15 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0G007L4OBQNT@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:14 +0000 (GMT)
Date: Tue, 06 Mar 2012 12:38:05 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv2 PATCH 4/9] v4l: add buffer exporting via dmabuf
In-reply-to: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com
Message-id: <1331033890-10350-5-git-send-email-t.stanislaws@samsung.com>
References: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds extension to V4L2 api. It allow to export a mmap buffer as file
descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset used by
mmap and return a file descriptor on success.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    1 +
 drivers/media/video/v4l2-ioctl.c          |   11 +++++++++++
 include/linux/videodev2.h                 |   20 ++++++++++++++++++++
 include/media/v4l2-ioctl.h                |    2 ++
 4 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index e6f67aa..fd157cb 100644
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
index 74cab51..a125016 100644
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
@@ -938,6 +939,16 @@ static long __video_do_ioctl(struct file *file,
 			dbgbuf(cmd, vfd, p);
 		break;
 	}
+	case VIDIOC_EXPBUF:
+	{
+		struct v4l2_exportbuffer *p = arg;
+
+		if (!ops->vidioc_expbuf)
+			break;
+
+		ret = ops->vidioc_expbuf(file, fh, p);
+		break;
+	}
 	case VIDIOC_DQBUF:
 	{
 		struct v4l2_buffer *p = arg;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index bb6844e..e71c787 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -680,6 +680,25 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
 #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
 
+/**
+ * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
+ *
+ * @fd:		file descriptor associated with DMABUF (set by driver)
+ * @mem_offset:	for non-multiplanar buffers with memory == V4L2_MEMORY_MMAP;
+ *		offset from the start of the device memory for this plane,
+ *		(or a "cookie" that should be passed to mmap() as offset)
+ *
+ * Contains data used for exporting a video buffer as DMABUF file
+ * descriptor. Uses the same 'cookie' as mmap() syscall. All reserved fields
+ * must be set to zero.
+ */
+struct v4l2_exportbuffer {
+	__u32		fd;
+	__u32		reserved0;
+	__u32		mem_offset;
+	__u32		reserved[13];
+};
+
 /*
  *	O V E R L A Y   P R E V I E W
  */
@@ -2303,6 +2322,7 @@ struct v4l2_create_buffers {
 #define VIDIOC_S_FBUF		 _IOW('V', 11, struct v4l2_framebuffer)
 #define VIDIOC_OVERLAY		 _IOW('V', 14, int)
 #define VIDIOC_QBUF		_IOWR('V', 15, struct v4l2_buffer)
+#define VIDIOC_EXPBUF		_IOWR('V', 16, struct v4l2_exportbuffer)
 #define VIDIOC_DQBUF		_IOWR('V', 17, struct v4l2_buffer)
 #define VIDIOC_STREAMON		 _IOW('V', 18, int)
 #define VIDIOC_STREAMOFF	 _IOW('V', 19, int)
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 4df031a..d8716c6f 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -120,6 +120,8 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
 	int (*vidioc_querybuf)(struct file *file, void *fh, struct v4l2_buffer *b);
 	int (*vidioc_qbuf)    (struct file *file, void *fh, struct v4l2_buffer *b);
+	int (*vidioc_expbuf)  (struct file *file, void *fh,
+				struct v4l2_exportbuffer *e);
 	int (*vidioc_dqbuf)   (struct file *file, void *fh, struct v4l2_buffer *b);
 
 	int (*vidioc_create_bufs)(struct file *file, void *fh, struct v4l2_create_buffers *b);
-- 
1.7.5.4

