Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:53268 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3IPMyZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 08:54:25 -0400
Received: by mail-lb0-f169.google.com with SMTP id z5so4101695lbh.14
        for <linux-media@vger.kernel.org>; Mon, 16 Sep 2013 05:54:24 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Cc: Ricardo Ribalda <ricardo.ribalda@gmail.com>
Subject: [PATCH] v4l2: Support for multiple selections
Date: Mon, 16 Sep 2013 14:54:18 +0200
Message-Id: <1379336058-31178-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ricardo Ribalda <ricardo.ribalda@gmail.com>

Extend v4l2 selection API to support multiple selection areas, this way
sensors that support multiple readout areas can work with multiple areas
of insterest.

The struct v4l2_selection and v4l2_subdev_selection has been extented
with a new field rectangles. If it is value is different than zero the
pr array is used instead of the r field.

A new structure v4l2_ext_rect has been defined, containing 4 reserved
fields for future improvements, as suggested by Hans.

A new function in v4l2-comon (v4l2_selection_flat_struct) is in charge
of converting a pr pointer with one item to a flatten struct. This
function is used in all the old drivers that dont support multiple
selections.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c      |  6 +++
 drivers/media/platform/exynos4-is/fimc-capture.c |  6 +++
 drivers/media/platform/exynos4-is/fimc-lite.c    |  6 +++
 drivers/media/platform/s3c-camif/camif-capture.c |  6 +++
 drivers/media/platform/s5p-jpeg/jpeg-core.c      |  3 ++
 drivers/media/platform/s5p-tv/mixer_video.c      |  6 +++
 drivers/media/platform/soc_camera/soc_camera.c   |  6 +++
 drivers/media/v4l2-core/v4l2-common.c            | 13 ++++++
 drivers/media/v4l2-core/v4l2-ioctl.c             | 54 +++++++++++++++++++++---
 include/media/v4l2-common.h                      |  2 +
 include/uapi/linux/v4l2-subdev.h                 | 10 ++++-
 include/uapi/linux/videodev2.h                   | 15 ++++++-
 12 files changed, 122 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 40a73f7..599a907 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -452,6 +452,9 @@ static int gsc_m2m_g_selection(struct file *file, void *fh,
 	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	frame = ctx_get_frame(ctx, s->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
@@ -495,6 +498,9 @@ static int gsc_m2m_s_selection(struct file *file, void *fh,
 	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	ret = gsc_try_crop(ctx, &cr);
 	if (ret)
 		return ret;
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index fb27ff7..357ac81 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1283,6 +1283,9 @@ static int fimc_cap_g_selection(struct file *file, void *fh,
 	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	switch (s->target) {
 	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
@@ -1333,6 +1336,9 @@ static int fimc_cap_s_selection(struct file *file, void *fh,
 	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	if (s->target == V4L2_SEL_TGT_COMPOSE)
 		f = &ctx->d_frame;
 	else if (s->target == V4L2_SEL_TGT_CROP)
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 08fbfed..b895318 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -915,6 +915,9 @@ static int fimc_lite_g_selection(struct file *file, void *fh,
 	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	switch (sel->target) {
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
@@ -944,6 +947,9 @@ static int fimc_lite_s_selection(struct file *file, void *fh,
 	    sel->target != V4L2_SEL_TGT_COMPOSE)
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	fimc_lite_try_compose(fimc, &rect);
 
 	if ((sel->flags & V4L2_SEL_FLAG_LE) &&
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 40b298a..951dce4 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -1016,6 +1016,9 @@ static int s3c_camif_g_selection(struct file *file, void *priv,
 	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	switch (sel->target) {
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
@@ -1057,6 +1060,9 @@ static int s3c_camif_s_selection(struct file *file, void *priv,
 	    sel->target != V4L2_SEL_TGT_COMPOSE)
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	__camif_try_compose(camif, vp, &rect);
 
 	sel->r = rect;
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 15d2396..6f46869 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -848,6 +848,9 @@ static int s5p_jpeg_g_selection(struct file *file, void *priv,
 	    s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	/* For JPEG blob active == default == bounds */
 	switch (s->target) {
 	case V4L2_SEL_TGT_CROP:
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 641b1f0..52a8de9 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -368,6 +368,9 @@ static int mxr_g_selection(struct file *file, void *fh,
 		s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	switch (s->target) {
 	case V4L2_SEL_TGT_CROP:
 		s->r.left = geo->src.x_offset;
@@ -436,6 +439,9 @@ static int mxr_s_selection(struct file *file, void *fh,
 		s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	switch (s->target) {
 	/* ignore read-only targets */
 	case V4L2_SEL_TGT_CROP_DEFAULT:
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 2dd0e52..c84f4e3 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1061,6 +1061,9 @@ static int soc_camera_g_selection(struct file *file, void *fh,
 	if (!ici->ops->get_selection)
 		return -ENOTTY;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	return ici->ops->get_selection(icd, s);
 }
 
@@ -1077,6 +1080,9 @@ static int soc_camera_s_selection(struct file *file, void *fh,
 	     s->target != V4L2_SEL_TGT_CROP))
 		return -EINVAL;
 
+	if (v4l2_selection_flat_struct(s))
+		return -EINVAL;
+
 	if (s->target == V4L2_SEL_TGT_COMPOSE) {
 		/* No output size change during a running capture! */
 		if (is_streaming(ici, icd) &&
diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index a95e5e2..cd20567 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -886,3 +886,16 @@ void v4l2_get_timestamp(struct timeval *tv)
 	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 }
 EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
+
+int v4l2_selection_flat_struct(struct v4l2_selection *s)
+{
+	if (s->rectangles == 0)
+		return 0;
+
+	if (s->rectangles != 1)
+		return -EINVAL;
+
+	s->r = s->pr[0].r;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_selection_flat_struct);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 68e6b5e..fe92f6b 100644
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
+	if (p->rectangles == 0)
+		pr_cont("type=%s, target=%d, flags=0x%x, wxh=%dx%d, x,y=%d,%d\n",
+			prt_names(p->type, v4l2_type_names),
+			p->target, p->flags,
+			p->r.width, p->r.height, p->r.left, p->r.top);
+	else{
+		pr_cont("type=%s, target=%d, flags=0x%x rectangles=%d\n",
+			prt_names(p->type, v4l2_type_names),
+			p->target, p->flags, p->rectangles);
+		for (i = 0; i < p->rectangles; i++)
+			pr_cont("rectangle %d: wxh=%dx%d, x,y=%d,%d\n",
+				i, p->r.width, p->r.height,
+				p->r.left, p->r.top);
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
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 015ff82..b0a3d2b 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -216,4 +216,6 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
 
 void v4l2_get_timestamp(struct timeval *tv);
 
+int v4l2_selection_flat_struct(struct v4l2_selection *s);
+
 #endif /* V4L2_COMMON_H_ */
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
index 95ef455..db8b1a5 100644
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
@@ -804,6 +809,8 @@ struct v4l2_crop {
  *		defined in v4l2-common.h; V4L2_SEL_TGT_* .
  * @flags:	constraints flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
  * @r:		coordinates of selection window
+ * @pr:		array of rectangles containing the selection windows
+ * @rectangles:	Number of rectangles in pr structure. If zero, r is used instead
  * @reserved:	for future use, rounds structure size to 64 bytes, set to zero
  *
  * Hardware may use multiple helper windows to process a video stream.
@@ -814,8 +821,12 @@ struct v4l2_selection {
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

