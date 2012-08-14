Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:9517 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab2HNPhl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:37:41 -0400
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R00BPV4QJGBC0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:37:32 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8R004J44MBC810@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:37:31 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de, dmitriyz@google.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
Subject: [PATCHv8 18/26] v4l: add buffer exporting via dmabuf
Date: Tue, 14 Aug 2012 17:34:48 +0200
Message-id: <1344958496-9373-19-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
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
 drivers/media/video/v4l2-ioctl.c          |   15 +++++++++++++++
 include/linux/videodev2.h                 |   26 ++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h                |    2 ++
 5 files changed, 45 insertions(+)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index a2e0549..7689c4a 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -971,6 +971,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_S_FBUF32:
 	case VIDIOC_OVERLAY32:
 	case VIDIOC_QBUF32:
+	case VIDIOC_EXPBUF:
 	case VIDIOC_DQBUF32:
 	case VIDIOC_STREAMON32:
 	case VIDIOC_STREAMOFF32:
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 71237f5..f6e7ea5 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -607,6 +607,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 	SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
 	SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
+	SET_VALID_IOCTL(ops, VIDIOC_EXPBUF, vidioc_expbuf);
 	SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
 	SET_VALID_IOCTL(ops, VIDIOC_OVERLAY, vidioc_overlay);
 	SET_VALID_IOCTL(ops, VIDIOC_G_FBUF, vidioc_g_fbuf);
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index dffd3c9..c4e8c7e 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -458,6 +458,14 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 			tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
 }
 
+static void v4l_print_exportbuffer(const void *arg, bool write_only)
+{
+	const struct v4l2_exportbuffer *p = arg;
+
+	pr_cont("fd=%d, mem_offset=%lx, flags=%lx\n",
+		p->fd, (unsigned long)p->mem_offset, (unsigned long)p->flags);
+}
+
 static void v4l_print_create_buffers(const void *arg, bool write_only)
 {
 	const struct v4l2_create_buffers *p = arg;
@@ -1254,6 +1262,12 @@ static int v4l_streamoff(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_streamoff(file, fh, *(unsigned int *)arg);
 }
 
+static int v4l_expbuf(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	return ops->vidioc_expbuf(file, fh, arg);
+}
+
 static int v4l_g_tuner(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -1947,6 +1961,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_S_FBUF, vidioc_s_fbuf, v4l_print_framebuffer, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_OVERLAY, vidioc_overlay, v4l_print_u32, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_QBUF, v4l_qbuf, v4l_print_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO_FNC(VIDIOC_EXPBUF, v4l_expbuf, v4l_print_exportbuffer, INFO_FL_CLEAR(v4l2_exportbuffer, flags)),
 	IOCTL_INFO_FNC(VIDIOC_DQBUF, v4l_dqbuf, v4l_print_buffer, INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_STREAMON, v4l_streamon, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 7f918dc..b5d058b 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -688,6 +688,31 @@ struct v4l2_buffer {
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
@@ -2558,6 +2583,7 @@ struct v4l2_create_buffers {
 #define VIDIOC_S_FBUF		 _IOW('V', 11, struct v4l2_framebuffer)
 #define VIDIOC_OVERLAY		 _IOW('V', 14, int)
 #define VIDIOC_QBUF		_IOWR('V', 15, struct v4l2_buffer)
+#define VIDIOC_EXPBUF		_IOWR('V', 16, struct v4l2_exportbuffer)
 #define VIDIOC_DQBUF		_IOWR('V', 17, struct v4l2_buffer)
 #define VIDIOC_STREAMON		 _IOW('V', 18, int)
 #define VIDIOC_STREAMOFF	 _IOW('V', 19, int)
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index e614c9c..38fb139 100644
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

