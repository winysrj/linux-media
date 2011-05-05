Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38796 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1EEJkP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 05:40:15 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LKP00AZLUV1IG@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 May 2011 10:40:14 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LKP00MX3UUZU9@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 May 2011 10:40:12 +0100 (BST)
Date: Thu, 05 May 2011 11:39:55 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 1/2] v4l: add support for extended crop/compose API
In-reply-to: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Message-id: <1304588396-7557-2-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

New ioctl for a precise control of cropping and composing:
VIDIOC_S_SELECTION
VIDIOC_G_SELECTION

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    2 ++
 drivers/media/video/v4l2-ioctl.c          |   28 ++++++++++++++++++++++++++++
 include/linux/videodev2.h                 |   26 ++++++++++++++++++++++++++
 include/media/v4l2-ioctl.h                |    4 ++++
 4 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 7c26947..de108d4 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -891,6 +891,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_CROPCAP:
 	case VIDIOC_G_CROP:
 	case VIDIOC_S_CROP:
+	case VIDIOC_G_SELECTION:
+	case VIDIOC_S_SELECTION:
 	case VIDIOC_G_JPEGCOMP:
 	case VIDIOC_S_JPEGCOMP:
 	case VIDIOC_QUERYSTD:
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 7a72074..aeef966 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -223,6 +223,8 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_CROPCAP)]          = "VIDIOC_CROPCAP",
 	[_IOC_NR(VIDIOC_G_CROP)]           = "VIDIOC_G_CROP",
 	[_IOC_NR(VIDIOC_S_CROP)]           = "VIDIOC_S_CROP",
+	[_IOC_NR(VIDIOC_G_SELECTION)]      = "VIDIOC_G_SELECTION",
+	[_IOC_NR(VIDIOC_S_SELECTION)]      = "VIDIOC_S_SELECTION",
 	[_IOC_NR(VIDIOC_G_JPEGCOMP)]       = "VIDIOC_G_JPEGCOMP",
 	[_IOC_NR(VIDIOC_S_JPEGCOMP)]       = "VIDIOC_S_JPEGCOMP",
 	[_IOC_NR(VIDIOC_QUERYSTD)]         = "VIDIOC_QUERYSTD",
@@ -1741,6 +1743,32 @@ static long __video_do_ioctl(struct file *file,
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
index a94c4d5..e044311 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -718,6 +718,28 @@ struct v4l2_crop {
 	struct v4l2_rect        c;
 };
 
+/* Hints for adjustments of selection rectangle */
+#define V4L2_SEL_SIZE_GE	0x00000001
+#define V4L2_SEL_SIZE_LE	0x00000002
+
+enum v4l2_sel_target {
+	V4L2_SEL_CROP_ACTIVE  = 0,
+	V4L2_SEL_CROP_DEFAULT = 1,
+	V4L2_SEL_CROP_BOUNDS  = 2,
+	V4L2_SEL_COMPOSE_ACTIVE  = 16 + 0,
+	V4L2_SEL_COMPOSE_DEFAULT = 16 + 1,
+	V4L2_SEL_COMPOSE_BOUNDS  = 16 + 2,
+};
+
+struct v4l2_selection {
+	enum v4l2_buf_type      type;
+	enum v4l2_sel_target	target;
+	__u32                   flags;
+	struct v4l2_rect        r;
+	__u32                   reserved[9];
+};
+
+
 /*
  *      A N A L O G   V I D E O   S T A N D A R D
  */
@@ -1932,6 +1954,10 @@ struct v4l2_dbg_chip_ident {
 #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
 #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
 
+/* Experimental crop/compose API */
+#define VIDIOC_G_SELECTION	_IOWR('V', 92, struct v4l2_selection)
+#define VIDIOC_S_SELECTION	_IOWR('V', 93, struct v4l2_selection)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 1572c7f..e2ccef2 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -194,6 +194,10 @@ struct v4l2_ioctl_ops {
 					struct v4l2_crop *a);
 	int (*vidioc_s_crop)           (struct file *file, void *fh,
 					struct v4l2_crop *a);
+	int (*vidioc_g_selection)      (struct file *file, void *fh,
+					struct v4l2_selection *a);
+	int (*vidioc_s_selection)      (struct file *file, void *fh,
+					struct v4l2_selection *a);
 	/* Compression ioctls */
 	int (*vidioc_g_jpegcomp)       (struct file *file, void *fh,
 					struct v4l2_jpegcompression *a);
-- 
1.7.5
