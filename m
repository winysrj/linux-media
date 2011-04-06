Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15118 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab1DFIoc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 04:44:32 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LJ800K6C2Y5P5@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Apr 2011 09:44:30 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJ8005632Y4KT@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Apr 2011 09:44:29 +0100 (BST)
Date: Wed, 06 Apr 2011 10:44:18 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 1/2] v4l: add support for extended crop/compose API
In-reply-to: <1302079459-4018-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com
Message-id: <1302079459-4018-2-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1302079459-4018-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Four new ioctl for a precise control of cropping and composing:
VIDIOC_S_EXTCROP
VIDIOC_G_EXTCROP
VIDIOC_S_COMPOSE
VIDIOC_G_COMPOSE

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    4 ++
 drivers/media/video/v4l2-ioctl.c          |   56 +++++++++++++++++++++++++++++
 include/linux/videodev2.h                 |   44 ++++++++++++++++++++++
 include/media/v4l2-ioctl.h                |    8 ++++
 4 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 7c26947..81481bc 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -891,6 +891,10 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_CROPCAP:
 	case VIDIOC_G_CROP:
 	case VIDIOC_S_CROP:
+	case VIDIOC_G_EXTCROP:
+	case VIDIOC_S_EXTCROP:
+	case VIDIOC_G_COMPOSE:
+	case VIDIOC_S_COMPOSE:
 	case VIDIOC_G_JPEGCOMP:
 	case VIDIOC_S_JPEGCOMP:
 	case VIDIOC_QUERYSTD:
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 7a72074..3f69218 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -223,6 +223,10 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_CROPCAP)]          = "VIDIOC_CROPCAP",
 	[_IOC_NR(VIDIOC_G_CROP)]           = "VIDIOC_G_CROP",
 	[_IOC_NR(VIDIOC_S_CROP)]           = "VIDIOC_S_CROP",
+	[_IOC_NR(VIDIOC_G_EXTCROP)]        = "VIDIOC_G_EXTCROP",
+	[_IOC_NR(VIDIOC_S_EXTCROP)]        = "VIDIOC_S_EXTCROP",
+	[_IOC_NR(VIDIOC_G_COMPOSE)]        = "VIDIOC_G_COMPOSE",
+	[_IOC_NR(VIDIOC_S_COMPOSE)]        = "VIDIOC_S_COMPOSE",
 	[_IOC_NR(VIDIOC_G_JPEGCOMP)]       = "VIDIOC_G_JPEGCOMP",
 	[_IOC_NR(VIDIOC_S_JPEGCOMP)]       = "VIDIOC_S_JPEGCOMP",
 	[_IOC_NR(VIDIOC_QUERYSTD)]         = "VIDIOC_QUERYSTD",
@@ -1741,6 +1745,58 @@ static long __video_do_ioctl(struct file *file,
 		ret = ops->vidioc_s_crop(file, fh, p);
 		break;
 	}
+	case VIDIOC_G_EXTCROP:
+	{
+		struct v4l2_selection *p = arg;
+
+		if (!ops->vidioc_g_extcrop)
+			break;
+
+		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
+
+		ret = ops->vidioc_g_extcrop(file, fh, p);
+		if (!ret)
+			dbgrect(vfd, "", &p->r);
+		break;
+	}
+	case VIDIOC_S_EXTCROP:
+	{
+		struct v4l2_selection *p = arg;
+
+		if (!ops->vidioc_s_extcrop)
+			break;
+		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
+		dbgrect(vfd, "", &p->r);
+
+		ret = ops->vidioc_s_extcrop(file, fh, p);
+		break;
+	}
+	case VIDIOC_G_COMPOSE:
+	{
+		struct v4l2_selection *p = arg;
+
+		if (!ops->vidioc_g_compose)
+			break;
+
+		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
+
+		ret = ops->vidioc_g_compose(file, fh, p);
+		if (!ret)
+			dbgrect(vfd, "", &p->r);
+		break;
+	}
+	case VIDIOC_S_COMPOSE:
+	{
+		struct v4l2_selection *p = arg;
+
+		if (!ops->vidioc_s_compose)
+			break;
+		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
+		dbgrect(vfd, "", &p->r);
+
+		ret = ops->vidioc_s_compose(file, fh, p);
+		break;
+	}
 	case VIDIOC_CROPCAP:
 	{
 		struct v4l2_cropcap *p = arg;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index a94c4d5..50a9981 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -718,6 +718,44 @@ struct v4l2_crop {
 	struct v4l2_rect        c;
 };
 
+/* Hints for adjustments of selection rectangle */
+#define V4L2_SEL_WIDTH_GE	0x00000001
+#define V4L2_SEL_WIDTH_LE	0x00000002
+#define V4L2_SEL_HEIGHT_GE	0x00000004
+#define V4L2_SEL_HEIGHT_LE	0x00000008
+#define V4L2_SEL_LEFT_GE	0x00000010
+#define V4L2_SEL_LEFT_LE	0x00000020
+#define V4L2_SEL_TOP_GE		0x00000040
+#define V4L2_SEL_TOP_LE		0x00000080
+#define V4L2_SEL_RIGHT_GE	0x00000100
+#define V4L2_SEL_RIGHT_LE	0x00000200
+#define V4L2_SEL_BOTTOM_GE	0x00000400
+#define V4L2_SEL_BOTTOM_LE	0x00000800
+
+#define V4L2_SEL_WIDTH_FIXED	0x00000003
+#define V4L2_SEL_HEIGHT_FIXED	0x0000000c
+#define V4L2_SEL_LEFT_FIXED	0x00000030
+#define V4L2_SEL_TOP_FIXED	0x000000c0
+#define V4L2_SEL_RIGHT_FIXED	0x00000300
+#define V4L2_SEL_BOTTOM_FIXED	0x00000c00
+
+#define V4L2_SEL_FIXED		0x00000fff
+
+enum v4l2_sel_target {
+	V4L2_SEL_TARGET_ACTIVE  = 0,
+	V4L2_SEL_TARGET_DEFAULT = 1,
+	V4L2_SEL_TARGET_BOUNDS  = 2,
+};
+
+struct v4l2_selection {
+	enum v4l2_buf_type      type;
+	enum v4l2_sel_target	target;
+	struct v4l2_rect        r;
+	__u32                   flags;
+	__u32                   reserved[9];
+};
+
+
 /*
  *      A N A L O G   V I D E O   S T A N D A R D
  */
@@ -1932,6 +1970,12 @@ struct v4l2_dbg_chip_ident {
 #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
 #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
 
+/* New cropping/compose API */
+#define VIDIOC_G_EXTCROP	_IOWR('V', 92, struct v4l2_selection)
+#define VIDIOC_S_EXTCROP	_IOWR('V', 93, struct v4l2_selection)
+#define VIDIOC_G_COMPOSE	_IOWR('V', 94, struct v4l2_selection)
+#define VIDIOC_S_COMPOSE	_IOWR('V', 95, struct v4l2_selection)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 1572c7f..3174b88 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -194,6 +194,14 @@ struct v4l2_ioctl_ops {
 					struct v4l2_crop *a);
 	int (*vidioc_s_crop)           (struct file *file, void *fh,
 					struct v4l2_crop *a);
+	int (*vidioc_g_extcrop)        (struct file *file, void *fh,
+					struct v4l2_selection *a);
+	int (*vidioc_s_extcrop)        (struct file *file, void *fh,
+					struct v4l2_selection *a);
+	int (*vidioc_g_compose)        (struct file *file, void *fh,
+					struct v4l2_selection *a);
+	int (*vidioc_s_compose)        (struct file *file, void *fh,
+					struct v4l2_selection *a);
 	/* Compression ioctls */
 	int (*vidioc_g_jpegcomp)       (struct file *file, void *fh,
 					struct v4l2_jpegcompression *a);
-- 
1.7.4.2
