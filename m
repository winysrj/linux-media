Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12156 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab1HaMas (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 08:30:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQS00FCTLD8R050@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 13:29:33 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQS00EL9LBYWK@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 13:28:47 +0100 (BST)
Date: Wed, 31 Aug 2011 14:28:20 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 1/4] v4l: add support for selection api
In-reply-to: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
Message-id: <1314793703-32345-2-git-send-email-t.stanislaws@samsung.com>
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces new api for a precise control of cropping and composing
features for video devices. The new ioctls are VIDIOC_S_SELECTION and
VIDIOC_G_SELECTION.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    2 +
 drivers/media/video/v4l2-ioctl.c          |   28 +++++++++++++++++
 include/linux/videodev2.h                 |   46 +++++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h                |    4 ++
 4 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 61979b7..f3b9d15 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -927,6 +927,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_CROPCAP:
 	case VIDIOC_G_CROP:
 	case VIDIOC_S_CROP:
+	case VIDIOC_G_SELECTION:
+	case VIDIOC_S_SELECTION:
 	case VIDIOC_G_JPEGCOMP:
 	case VIDIOC_S_JPEGCOMP:
 	case VIDIOC_QUERYSTD:
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 002ce13..6e02b45 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -225,6 +225,8 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_CROPCAP)]          = "VIDIOC_CROPCAP",
 	[_IOC_NR(VIDIOC_G_CROP)]           = "VIDIOC_G_CROP",
 	[_IOC_NR(VIDIOC_S_CROP)]           = "VIDIOC_S_CROP",
+	[_IOC_NR(VIDIOC_G_SELECTION)]      = "VIDIOC_G_SELECTION",
+	[_IOC_NR(VIDIOC_S_SELECTION)]      = "VIDIOC_S_SELECTION",
 	[_IOC_NR(VIDIOC_G_JPEGCOMP)]       = "VIDIOC_G_JPEGCOMP",
 	[_IOC_NR(VIDIOC_S_JPEGCOMP)]       = "VIDIOC_S_JPEGCOMP",
 	[_IOC_NR(VIDIOC_QUERYSTD)]         = "VIDIOC_QUERYSTD",
@@ -1714,6 +1716,32 @@ static long __video_do_ioctl(struct file *file,
 		ret = ops->vidioc_s_crop(file, fh, p);
 		break;
 	}
+	case VIDIOC_G_SELECTION:
+	{
+		struct v4l2_selection *p = arg;
+
+		if (!ops->vidioc_g_selection)
+			break;
+
+		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
+
+		ret = ops->vidioc_g_selection(file, fh, p);
+		if (!ret)
+			dbgrect(vfd, "", &p->r);
+		break;
+	}
+	case VIDIOC_S_SELECTION:
+	{
+		struct v4l2_selection *p = arg;
+
+		if (!ops->vidioc_s_selection)
+			break;
+		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
+		dbgrect(vfd, "", &p->r);
+
+		ret = ops->vidioc_s_selection(file, fh, p);
+		break;
+	}
 	case VIDIOC_CROPCAP:
 	{
 		struct v4l2_cropcap *p = arg;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index fca24cc..b7471fe 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -738,6 +738,48 @@ struct v4l2_crop {
 	struct v4l2_rect        c;
 };
 
+/* Hints for adjustments of selection rectangle */
+#define V4L2_SEL_SIZE_GE	0x00000001
+#define V4L2_SEL_SIZE_LE	0x00000002
+
+/* Selection targets */
+
+/* current cropping area */
+#define V4L2_SEL_CROP_ACTIVE		0
+/* default cropping area */
+#define V4L2_SEL_CROP_DEFAULT		1
+/* cropping bounds */
+#define V4L2_SEL_CROP_BOUNDS		2
+/* current composing area */
+#define V4L2_SEL_COMPOSE_ACTIVE		256
+/* default composing area */
+#define V4L2_SEL_COMPOSE_DEFAULT	257
+/* composing bounds */
+#define V4L2_SEL_COMPOSE_BOUNDS		258
+/* current composing area plus all padding pixels */
+#define V4L2_SEL_COMPOSE_PADDED		259
+
+/**
+ * struct v4l2_selection - selection info
+ * @type:	buffer type (do not use *_MPLANE types)
+ * @target:	selection target, used to choose one of possible rectangles
+ * @flags:	constraints flags
+ * @r:		coordinates of selection window
+ * @reserved:	for future use, rounds structure size to 64 bytes, set to zero
+ *
+ * Hardware may use multiple helper window to process a video stream.
+ * The structure is used to exchange this selection areas between
+ * an application and a driver.
+ */
+struct v4l2_selection {
+	__u32			type;
+	__u32			target;
+	__u32                   flags;
+	struct v4l2_rect        r;
+	__u32                   reserved[9];
+};
+
+
 /*
  *      A N A L O G   V I D E O   S T A N D A R D
  */
@@ -2182,6 +2224,10 @@ struct v4l2_dbg_chip_ident {
 #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
 #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
 
+/* Experimental crop/compose API */
+#define VIDIOC_G_SELECTION	_IOWR('V', 92, struct v4l2_selection)
+#define VIDIOC_S_SELECTION	_IOWR('V', 93, struct v4l2_selection)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index dd9f1e7..9dd6e18 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -194,6 +194,10 @@ struct v4l2_ioctl_ops {
 					struct v4l2_crop *a);
 	int (*vidioc_s_crop)           (struct file *file, void *fh,
 					struct v4l2_crop *a);
+	int (*vidioc_g_selection)      (struct file *file, void *fh,
+					struct v4l2_selection *s);
+	int (*vidioc_s_selection)      (struct file *file, void *fh,
+					struct v4l2_selection *s);
 	/* Compression ioctls */
 	int (*vidioc_g_jpegcomp)       (struct file *file, void *fh,
 					struct v4l2_jpegcompression *a);
-- 
1.7.6

