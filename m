Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:41994 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab3ILRLD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 13:11:03 -0400
Received: by mail-la0-f50.google.com with SMTP id lv10so82043lab.9
        for <linux-media@vger.kernel.org>; Thu, 12 Sep 2013 10:11:02 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] RFCv2: Support for multiple selections
Date: Thu, 12 Sep 2013 19:10:56 +0200
Message-Id: <1379005856-28585-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <CAPybu_3cOLztceJoNwyZQGuC8maNYKuunbxJRHt7X6nQHmCyhw@mail.gmail.com>
References: <CAPybu_3cOLztceJoNwyZQGuC8maNYKuunbxJRHt7X6nQHmCyhw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend v4l2 selection API to support multiple selection areas, this way
sensors that support multiple readout areas can work with multiple areas
of insterest.

The struct v4l2_selection and v4l2_subdev_selection has been extented
with a new field rectangles. If it is value is different than zero the
pr array is used instead of the r field.

A new structure v4l2_ext_rect has been defined, containing 4 reserved
fields for future improvements, as suggested by Hans.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 54 +++++++++++++++++++++++++++++++-----
 include/uapi/linux/v4l2-subdev.h     | 10 +++++--
 include/uapi/linux/videodev2.h       | 15 ++++++++--
 3 files changed, 68 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 68e6b5e..91d21a4 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -572,11 +572,22 @@ static void v4l_print_crop(const void *arg, bool write_only)
 static void v4l_print_selection(const void *arg, bool write_only)
 {
 	const struct v4l2_selection *p = arg;
+	int i;
 
-	pr_cont("type=%s, target=%d, flags=0x%x, wxh=%dx%d, x,y=%d,%d\n",
-		prt_names(p->type, v4l2_type_names),
-		p->target, p->flags,
-		p->r.width, p->r.height, p->r.left, p->r.top);
+	if (p->rectangles==0)
+		pr_cont("type=%s, target=%d, flags=0x%x, wxh=%dx%d"
+			", x,y=%d,%d\n",
+			prt_names(p->type, v4l2_type_names),
+			p->target, p->flags,
+			p->r.width, p->r.height, p->r.left, p->r.top);
+	else{
+		pr_cont("type=%s, target=%d, flags=0x%x\n",
+			prt_names(p->type, v4l2_type_names),
+			p->target, p->flags);
+		for (i=0; i<p->rectangles;i++)
+			pr_cont("rectangle %d: wxh=%dx%d, x,y=%d,%d\n",
+				i, p->r.width, p->r.height, p->r.left, p->r.top);
+	}
 }
 
 static void v4l_print_jpegcompression(const void *arg, bool write_only)
@@ -1645,6 +1656,7 @@ static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_crop *p = arg;
 	struct v4l2_selection s = {
 		.type = p->type,
+		.rectangles = 0,
 	};
 	int ret;
 
@@ -1673,6 +1685,7 @@ static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_selection s = {
 		.type = p->type,
 		.r = p->c,
+		.rectangles = 0,
 	};
 
 	if (ops->vidioc_s_crop)
@@ -1692,7 +1705,10 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_cropcap *p = arg;
-	struct v4l2_selection s = { .type = p->type };
+	struct v4l2_selection s = {
+		.type = p->type,
+		.rectangles = 0,
+	};
 	int ret;
 
 	if (ops->vidioc_cropcap)
@@ -1726,6 +1742,30 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 	return 0;
 }
 
+static int v4l_s_selection(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_selection *s = arg;
+
+	if (s->rectangles &&
+		!access_ok(VERIFY_READ, s->pr, s->rectangles * sizeof(*s->pr)))
+		return -EFAULT;
+
+	return ops->vidioc_s_selection(file, fh, s);
+}
+
+static int v4l_g_selection(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_selection *s = arg;
+
+	if (s->rectangles &&
+		!access_ok(VERIFY_WRITE, s->pr, s->rectangles * sizeof(*s->pr)))
+		return -EFAULT;
+
+	return ops->vidioc_g_selection(file, fh, s);
+}
+
 static int v4l_log_status(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -2018,8 +2058,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_CROPCAP, v4l_cropcap, v4l_print_cropcap, INFO_FL_CLEAR(v4l2_cropcap, type)),
 	IOCTL_INFO_FNC(VIDIOC_G_CROP, v4l_g_crop, v4l_print_crop, INFO_FL_CLEAR(v4l2_crop, type)),
 	IOCTL_INFO_FNC(VIDIOC_S_CROP, v4l_s_crop, v4l_print_crop, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_SELECTION, vidioc_g_selection, v4l_print_selection, 0),
-	IOCTL_INFO_STD(VIDIOC_S_SELECTION, vidioc_s_selection, v4l_print_selection, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_G_SELECTION, v4l_g_selection, v4l_print_selection, 0),
+	IOCTL_INFO_FNC(VIDIOC_S_SELECTION, v4l_s_selection, v4l_print_selection, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_G_JPEGCOMP, vidioc_g_jpegcomp, v4l_print_jpegcompression, 0),
 	IOCTL_INFO_STD(VIDIOC_S_JPEGCOMP, vidioc_s_jpegcomp, v4l_print_jpegcompression, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_QUERYSTD, v4l_querystd, v4l_print_std, 0),
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index a33c4da..b5ee08b 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -133,6 +133,8 @@ struct v4l2_subdev_frame_interval_enum {
  *	    defined in v4l2-common.h; V4L2_SEL_TGT_* .
  * @flags: constraint flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
  * @r: coordinates of the selection window
+ * @pr:		array of rectangles containing the selection windows
+ * @rectangles:	Number of rectangles in pr structure. If zero, r is used instead
  * @reserved: for future use, set to zero for now
  *
  * Hardware may use multiple helper windows to process a video stream.
@@ -144,8 +146,12 @@ struct v4l2_subdev_selection {
 	__u32 pad;
 	__u32 target;
 	__u32 flags;
-	struct v4l2_rect r;
-	__u32 reserved[8];
+	union{
+		struct v4l2_rect r;
+		struct v4l2_ext_rect        *pr;
+	};
+	__u32 rectangles;
+	__u32 reserved[7];
 };
 
 struct v4l2_subdev_edid {
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 0e80472..691f73b 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -211,6 +211,11 @@ struct v4l2_rect {
 	__s32   height;
 };
 
+struct v4l2_ext_rect {
+	struct v4l2_rect r;
+	__u32   reserved[4];
+};
+
 struct v4l2_fract {
 	__u32   numerator;
 	__u32   denominator;
@@ -807,6 +812,8 @@ struct v4l2_crop {
  *		defined in v4l2-common.h; V4L2_SEL_TGT_* .
  * @flags:	constraints flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
  * @r:		coordinates of selection window
+ * @pr:		array of rectangles containing the selection windows
+ * @rectangles:	Number of rectangles in pr structure. If zero, r is used instead
  * @reserved:	for future use, rounds structure size to 64 bytes, set to zero
  *
  * Hardware may use multiple helper windows to process a video stream.
@@ -817,8 +824,12 @@ struct v4l2_selection {
 	__u32			type;
 	__u32			target;
 	__u32                   flags;
-	struct v4l2_rect        r;
-	__u32                   reserved[9];
+	union{
+		struct v4l2_rect        r;
+		struct v4l2_ext_rect        *pr;
+	};
+	__u32                   rectangles;
+	__u32                   reserved[8];
 };
 
 
-- 
1.8.4.rc3

