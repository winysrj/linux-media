Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22500 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab2FNOcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 10:32:39 -0400
Received: from euspt1 (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5M005WD33IMH70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 15:33:18 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M5M00L2W32CFX@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 15:32:37 +0100 (BST)
Date: Thu, 14 Jun 2012 16:32:23 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
In-reply-to: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1339684349-28882-4-git-send-email-t.stanislaws@samsung.com>
Content-transfer-encoding: 7BIT
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds extension to V4L2 api. It allow to export a mmap buffer as file
descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset used by
mmap and return a file descriptor on success.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    1 +
 drivers/media/video/v4l2-dev.c            |    1 +
 drivers/media/video/v4l2-ioctl.c          |    6 ++++++
 include/linux/videodev2.h                 |   26 ++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h                |    2 ++
 5 files changed, 36 insertions(+)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index d33ab18..141e745 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -970,6 +970,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_S_FBUF32:
 	case VIDIOC_OVERLAY32:
 	case VIDIOC_QBUF32:
+	case VIDIOC_EXPBUF:
 	case VIDIOC_DQBUF32:
 	case VIDIOC_STREAMON32:
 	case VIDIOC_STREAMOFF32:
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 5ccbd46..6bf6307 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -597,6 +597,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 	SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
 	SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
+	SET_VALID_IOCTL(ops, VIDIOC_EXPBUF, vidioc_expbuf);
 	SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
 	SET_VALID_IOCTL(ops, VIDIOC_OVERLAY, vidioc_overlay);
 	SET_VALID_IOCTL(ops, VIDIOC_G_FBUF, vidioc_g_fbuf);
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 31fc2ad..a73b14e 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -212,6 +212,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_S_FBUF, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_OVERLAY, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_QBUF, 0),
+	IOCTL_INFO(VIDIOC_EXPBUF, 0),
 	IOCTL_INFO(VIDIOC_DQBUF, 0),
 	IOCTL_INFO(VIDIOC_STREAMON, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_STREAMOFF, INFO_FL_PRIO),
@@ -957,6 +958,11 @@ static long __video_do_ioctl(struct file *file,
 			dbgbuf(cmd, vfd, p);
 		break;
 	}
+	case VIDIOC_EXPBUF:
+	{
+		ret = ops->vidioc_expbuf(file, fh, arg);
+		break;
+	}
 	case VIDIOC_DQBUF:
 	{
 		struct v4l2_buffer *p = arg;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 51b20f4..e8893a5 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -684,6 +684,31 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
 #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
 
+/**
+ * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
+ *
+ * @fd:		file descriptor associated with DMABUF (set by driver)
+ * @mem_offset:	buffer memory offset as returned by VIDIOC_QUERYBUF in struct
+ *		v4l2_buffer::m.offset (for single-plane formats) or
+ *		v4l2_plane::m.offset (for multi-planar formats)
+ * @flags:	flags for newly created file, currently only O_CLOEXEC is
+ *		supported, refer to manual of open syscall for more details
+ *
+ * Contains data used for exporting a video buffer as DMABUF file descriptor.
+ * The buffer is identified by a 'cookie' returned by VIDIOC_QUERYBUF
+ * (identical to the cookie used to mmap() the buffer to userspace). All
+ * reserved fields must be set to zero. The field reserved0 is expected to
+ * become a structure 'type' allowing an alternative layout of the structure
+ * content. Therefore this field should not be used for any other extensions.
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
@@ -2553,6 +2578,7 @@ struct v4l2_create_buffers {
 #define VIDIOC_S_FBUF		 _IOW('V', 11, struct v4l2_framebuffer)
 #define VIDIOC_OVERLAY		 _IOW('V', 14, int)
 #define VIDIOC_QBUF		_IOWR('V', 15, struct v4l2_buffer)
+#define VIDIOC_EXPBUF		_IOWR('V', 16, struct v4l2_exportbuffer)
 #define VIDIOC_DQBUF		_IOWR('V', 17, struct v4l2_buffer)
 #define VIDIOC_STREAMON		 _IOW('V', 18, int)
 #define VIDIOC_STREAMOFF	 _IOW('V', 19, int)
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index d8b76f7..ccd1faa 100644
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
1.7.9.5

