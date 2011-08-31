Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:56453 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab1HaSDE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 14:03:04 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/9 v6] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Wed, 31 Aug 2011 20:02:41 +0200
Message-Id: <1314813768-27752-3-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A possibility to preallocate and initialise buffers of different sizes
in V4L2 is required for an efficient implementation of a snapshot
mode. This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
VIDIOC_PREPARE_BUF and defines respective data structures.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |   67 +++++++++++++++++++++++++---
 drivers/media/video/v4l2-ioctl.c          |   29 ++++++++++++
 include/linux/videodev2.h                 |   15 ++++++
 include/media/v4l2-ioctl.h                |    2 +
 4 files changed, 105 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 61979b7..85758d2 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -159,11 +159,16 @@ struct v4l2_format32 {
 	} fmt;
 };
 
-static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
+struct v4l2_create_buffers32 {
+	__u32			index;		/* output: buffers index...index + count - 1 have been created */
+	__u32			count;
+	enum v4l2_memory        memory;
+	struct v4l2_format32	format;		/* filled in by the user, plane sizes calculated by the driver */
+	__u32			reserved[8];
+};
+
+static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
 {
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_format32)) ||
-			get_user(kp->type, &up->type))
-			return -EFAULT;
 	switch (kp->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
@@ -192,11 +197,24 @@ static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user
 	}
 }
 
-static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
+static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
+{
+	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_format32)) ||
+			get_user(kp->type, &up->type))
+			return -EFAULT;
+	return __get_v4l2_format32(kp, up);
+}
+
+static int get_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
+{
+	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_create_buffers32)) ||
+	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32, format.fmt)))
+			return -EFAULT;
+	return __get_v4l2_format32(&kp->format, &up->format);
+}
+
+static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
 {
-	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)) ||
-		put_user(kp->type, &up->type))
-		return -EFAULT;
 	switch (kp->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
@@ -225,6 +243,22 @@ static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user
 	}
 }
 
+static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
+{
+	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)) ||
+		put_user(kp->type, &up->type))
+		return -EFAULT;
+	return __put_v4l2_format32(kp, up);
+}
+
+static int put_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
+{
+	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_create_buffers32)) ||
+	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32, format.fmt)))
+			return -EFAULT;
+	return __put_v4l2_format32(&kp->format, &up->format);
+}
+
 struct v4l2_standard32 {
 	__u32		     index;
 	__u32		     id[2]; /* __u64 would get the alignment wrong */
@@ -702,6 +736,8 @@ static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *u
 #define VIDIOC_S_EXT_CTRLS32    _IOWR('V', 72, struct v4l2_ext_controls32)
 #define VIDIOC_TRY_EXT_CTRLS32  _IOWR('V', 73, struct v4l2_ext_controls32)
 #define	VIDIOC_DQEVENT32	_IOR ('V', 89, struct v4l2_event32)
+#define VIDIOC_CREATE_BUFS32	_IOWR('V', 92, struct v4l2_create_buffers32)
+#define VIDIOC_PREPARE_BUF32	_IOW ('V', 93, struct v4l2_buffer32)
 
 #define VIDIOC_OVERLAY32	_IOW ('V', 14, s32)
 #define VIDIOC_STREAMON32	_IOW ('V', 18, s32)
@@ -721,6 +757,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		struct v4l2_standard v2s;
 		struct v4l2_ext_controls v2ecs;
 		struct v4l2_event v2ev;
+		struct v4l2_create_buffers v2crt;
 		unsigned long vx;
 		int vi;
 	} karg;
@@ -751,6 +788,8 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_S_INPUT32: cmd = VIDIOC_S_INPUT; break;
 	case VIDIOC_G_OUTPUT32: cmd = VIDIOC_G_OUTPUT; break;
 	case VIDIOC_S_OUTPUT32: cmd = VIDIOC_S_OUTPUT; break;
+	case VIDIOC_CREATE_BUFS32: cmd = VIDIOC_CREATE_BUFS; break;
+	case VIDIOC_PREPARE_BUF32: cmd = VIDIOC_PREPARE_BUF; break;
 	}
 
 	switch (cmd) {
@@ -775,6 +814,12 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		compatible_arg = 0;
 		break;
 
+	case VIDIOC_CREATE_BUFS:
+		err = get_v4l2_create32(&karg.v2crt, up);
+		compatible_arg = 0;
+		break;
+
+	case VIDIOC_PREPARE_BUF:
 	case VIDIOC_QUERYBUF:
 	case VIDIOC_QBUF:
 	case VIDIOC_DQBUF:
@@ -860,6 +905,10 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		err = put_v4l2_format32(&karg.v2f, up);
 		break;
 
+	case VIDIOC_CREATE_BUFS:
+		err = put_v4l2_create32(&karg.v2crt, up);
+		break;
+
 	case VIDIOC_QUERYBUF:
 	case VIDIOC_QBUF:
 	case VIDIOC_DQBUF:
@@ -959,6 +1008,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_DQEVENT32:
 	case VIDIOC_SUBSCRIBE_EVENT:
 	case VIDIOC_UNSUBSCRIBE_EVENT:
+	case VIDIOC_CREATE_BUFS32:
+	case VIDIOC_PREPARE_BUF32:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 002ce13..6fa8e04 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -260,6 +260,8 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
 	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
 	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
+	[_IOC_NR(VIDIOC_CREATE_BUFS)]      = "VIDIOC_CREATE_BUFS",
+	[_IOC_NR(VIDIOC_PREPARE_BUF)]      = "VIDIOC_PREPARE_BUF",
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
@@ -2216,6 +2218,33 @@ static long __video_do_ioctl(struct file *file,
 		dbgarg(cmd, "type=0x%8.8x", sub->type);
 		break;
 	}
+	case VIDIOC_CREATE_BUFS:
+	{
+		struct v4l2_create_buffers *create = arg;
+
+		if (!ops->vidioc_create_bufs)
+			break;
+		ret = check_fmt(ops, create->format.type);
+		if (ret)
+			break;
+
+		ret = ops->vidioc_create_bufs(file, fh, create);
+
+		dbgarg(cmd, "count=%d @ %d\n", create->count, create->index);
+		break;
+	}
+	case VIDIOC_PREPARE_BUF:
+	{
+		struct v4l2_buffer *b = arg;
+
+		if (!ops->vidioc_prepare_buf)
+			break;
+
+		ret = ops->vidioc_prepare_buf(file, fh, b);
+
+		dbgarg(cmd, "index=%d", b->index);
+		break;
+	}
 	default:
 	{
 		bool valid_prio = true;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index fca24cc..988e1be 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -653,6 +653,9 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_ERROR	0x0040
 #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
 #define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
+/* Cache handling flags */
+#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0400
+#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x0800
 
 /*
  *	O V E R L A Y   P R E V I E W
@@ -2092,6 +2095,15 @@ struct v4l2_dbg_chip_ident {
 	__u32 revision;    /* chip revision, chip specific */
 } __attribute__ ((packed));
 
+/* VIDIOC_CREATE_BUFS */
+struct v4l2_create_buffers {
+	__u32			index;		/* output: buffers index...index + count - 1 have been created */
+	__u32			count;
+	enum v4l2_memory        memory;
+	struct v4l2_format	format;		/* "type" is used always, the rest if sizeimage == 0 */
+	__u32			reserved[8];
+};
+
 /*
  *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
  *
@@ -2182,6 +2194,9 @@ struct v4l2_dbg_chip_ident {
 #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
 #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
 
+#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
+#define VIDIOC_PREPARE_BUF	 _IOW('V', 93, struct v4l2_buffer)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index dd9f1e7..55cf8ae 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -122,6 +122,8 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_qbuf)    (struct file *file, void *fh, struct v4l2_buffer *b);
 	int (*vidioc_dqbuf)   (struct file *file, void *fh, struct v4l2_buffer *b);
 
+	int (*vidioc_create_bufs)(struct file *file, void *fh, struct v4l2_create_buffers *b);
+	int (*vidioc_prepare_buf)(struct file *file, void *fh, const struct v4l2_buffer *b);
 
 	int (*vidioc_overlay) (struct file *file, void *fh, unsigned int i);
 	int (*vidioc_g_fbuf)   (struct file *file, void *fh,
-- 
1.7.2.5

