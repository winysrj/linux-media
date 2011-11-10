Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20165 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab1KJLxq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 06:53:46 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LUG004EM11JPR@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Nov 2011 11:53:43 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LUG00BHZ11IHW@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Nov 2011 11:53:43 +0000 (GMT)
Date: Thu, 10 Nov 2011 12:53:31 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 1/5] v4l: add support for selection api
In-reply-to: <1320926015-5841-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	mchehab@redhat.com
Message-id: <1320926015-5841-2-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320926015-5841-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces new api for a precise control of cropping and composing
features for video devices. The new ioctls are VIDIOC_S_SELECTION and
VIDIOC_G_SELECTION.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    2 +
 drivers/media/video/v4l2-ioctl.c          |   34 +++++++++++++++++++++
 include/linux/videodev2.h                 |   46 +++++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h                |    4 ++
 4 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index c68531b..af4419e 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -985,6 +985,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_CROPCAP:
 	case VIDIOC_G_CROP:
 	case VIDIOC_S_CROP:
+	case VIDIOC_G_SELECTION:
+	case VIDIOC_S_SELECTION:
 	case VIDIOC_G_JPEGCOMP:
 	case VIDIOC_S_JPEGCOMP:
 	case VIDIOC_QUERYSTD:
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index e1da8fc..f3b0faf 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -238,6 +238,8 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_CROPCAP)]          = "VIDIOC_CROPCAP",
 	[_IOC_NR(VIDIOC_G_CROP)]           = "VIDIOC_G_CROP",
 	[_IOC_NR(VIDIOC_S_CROP)]           = "VIDIOC_S_CROP",
+	[_IOC_NR(VIDIOC_G_SELECTION)]      = "VIDIOC_G_SELECTION",
+	[_IOC_NR(VIDIOC_S_SELECTION)]      = "VIDIOC_S_SELECTION",
 	[_IOC_NR(VIDIOC_G_JPEGCOMP)]       = "VIDIOC_G_JPEGCOMP",
 	[_IOC_NR(VIDIOC_S_JPEGCOMP)]       = "VIDIOC_S_JPEGCOMP",
 	[_IOC_NR(VIDIOC_QUERYSTD)]         = "VIDIOC_QUERYSTD",
@@ -1571,6 +1573,38 @@ static long __video_do_ioctl(struct file *file,
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
+
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
+
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
index 4b752d5..df26f3c 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -742,6 +742,48 @@ struct v4l2_crop {
 	struct v4l2_rect        c;
 };
 
+/* Hints for adjustments of selection rectangle */
+#define V4L2_SEL_FLAG_GE	0x00000001
+#define V4L2_SEL_FLAG_LE	0x00000002
+
+/* Selection targets */
+
+/* current cropping area */
+#define V4L2_SEL_TGT_CROP_ACTIVE	0
+/* default cropping area */
+#define V4L2_SEL_TGT_CROP_DEFAULT	1
+/* cropping bounds */
+#define V4L2_SEL_TGT_CROP_BOUNDS	2
+/* current composing area */
+#define V4L2_SEL_TGT_COMPOSE_ACTIVE	256
+/* default composing area */
+#define V4L2_SEL_TGT_COMPOSE_DEFAULT	257
+/* composing bounds */
+#define V4L2_SEL_TGT_COMPOSE_BOUNDS	258
+/* current composing area plus all padding pixels */
+#define V4L2_SEL_TGT_COMPOSE_PADDED	259
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
@@ -2255,6 +2297,10 @@ struct v4l2_create_buffers {
 #define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
 #define VIDIOC_PREPARE_BUF	_IOWR('V', 93, struct v4l2_buffer)
 
+/* Experimental selection API */
+#define VIDIOC_G_SELECTION	_IOWR('V', 94, struct v4l2_selection)
+#define VIDIOC_S_SELECTION	_IOWR('V', 95, struct v4l2_selection)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 4d1c74a..3f5d60f 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -196,6 +196,10 @@ struct v4l2_ioctl_ops {
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
1.7.5.4

