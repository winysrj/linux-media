Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:36606 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2JBOaD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 10:30:03 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MB900KCHSA0GZ70@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:30:01 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MB9005A7S65K790@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:30:01 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: [PATCHv9 18/25] v4l: add buffer exporting via dmabuf
Date: Tue, 02 Oct 2012 16:27:29 +0200
Message-id: <1349188056-4886-19-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
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
 drivers/media/video/v4l2-ioctl.c          |   10 ++++++++++
 include/linux/videodev2.h                 |   28 ++++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h                |    2 ++
 5 files changed, 42 insertions(+)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index f0b5aba..8788000 100644
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
index 07aeafc..c43127c 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -638,6 +638,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 	SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
 	SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
+	SET_VALID_IOCTL(ops, VIDIOC_EXPBUF, vidioc_expbuf);
 	SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
 	SET_VALID_IOCTL(ops, VIDIOC_OVERLAY, vidioc_overlay);
 	SET_VALID_IOCTL(ops, VIDIOC_G_FBUF, vidioc_g_fbuf);
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index dffd3c9..f3ec8c0 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -458,6 +458,15 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 			tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
 }
 
+static void v4l_print_exportbuffer(const void *arg, bool write_only)
+{
+	const struct v4l2_exportbuffer *p = arg;
+
+	pr_cont("fd=%d, type=%s, index=%u, plane=%u, flags=0x%08x\n",
+		p->fd, prt_names(p->type, v4l2_type_names),
+		p->index, p->plane, p->flags);
+}
+
 static void v4l_print_create_buffers(const void *arg, bool write_only)
 {
 	const struct v4l2_create_buffers *p = arg;
@@ -1947,6 +1956,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_S_FBUF, vidioc_s_fbuf, v4l_print_framebuffer, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_OVERLAY, vidioc_overlay, v4l_print_u32, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_QBUF, v4l_qbuf, v4l_print_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO_STD(VIDIOC_EXPBUF, vidioc_expbuf, v4l_print_exportbuffer, 0),
 	IOCTL_INFO_FNC(VIDIOC_DQBUF, v4l_dqbuf, v4l_print_buffer, INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_STREAMON, v4l_streamon, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index e04a73e..f429b6a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -688,6 +688,33 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
 #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
 
+/**
+ * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
+ *
+ * @fd:		file descriptor associated with DMABUF (set by driver)
+ * @flags:	flags for newly created file, currently only O_CLOEXEC is
+ *		supported, refer to manual of open syscall for more details
+ * @index:	id number of the buffer
+ * @type:	enum v4l2_buf_type; buffer type (type == *_MPLANE for
+ *		multiplanar buffers);
+ * @plane:	index of the plane to be exported, 0 for single plane queues
+ *
+ * Contains data used for exporting a video buffer as DMABUF file descriptor.
+ * The buffer is identified by a 'cookie' returned by VIDIOC_QUERYBUF
+ * (identical to the cookie used to mmap() the buffer to userspace). All
+ * reserved fields must be set to zero. The field reserved0 is expected to
+ * become a structure 'type' allowing an alternative layout of the structure
+ * content. Therefore this field should not be used for any other extensions.
+ */
+struct v4l2_exportbuffer {
+	__s32		fd;
+	__u32		flags;
+	__u32		type; /* enum v4l2_buf_type */
+	__u32		index;
+	__u32		plane;
+	__u32		reserved[11];
+};
+
 /*
  *	O V E R L A Y   P R E V I E W
  */
@@ -2558,6 +2585,7 @@ struct v4l2_create_buffers {
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

