Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47469 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750905AbdFSNt2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 09:49:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 1/2] v4l2-ioctl/exynos: fix G/S_SELECTION's type handling
Date: Mon, 19 Jun 2017 15:49:09 +0200
Message-Id: <20170619134910.10138-2-hverkuil@xs4all.nl>
In-Reply-To: <20170619134910.10138-1-hverkuil@xs4all.nl>
References: <20170619134910.10138-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The type field in struct v4l2_selection is supposed to never use the
_MPLANE variants. E.g. if the driver supports V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
then userspace should still pass V4L2_BUF_TYPE_VIDEO_CAPTURE.

The reasons for this are lost in the mists of time, but it is really
annoying. In addition, the exynos drivers didn't follow this rule and
instead expected the _MPLANE type.

To fix that code is added to the v4l2 core that maps the _MPLANE buffer
types to their regular equivalents before calling the driver.

Effectively this allows for userspace to use either _MPLANE or the regular
buffer type. This keeps backwards compatibility while making things easier
for userspace.

Since drivers now never see the _MPLANE buffer types the exynos drivers
had to be adapted as well.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c     |  4 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c      |  8 ++--
 drivers/media/platform/exynos4-is/fimc-capture.c |  4 +-
 drivers/media/platform/exynos4-is/fimc-lite.c    |  4 +-
 drivers/media/v4l2-core/v4l2-ioctl.c             | 53 +++++++++++++++++++++---
 5 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 0241168c85af..43801509dabb 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -568,9 +568,9 @@ int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
 	}
 	pr_debug("user put w: %d, h: %d", cr->c.width, cr->c.height);
 
-	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		f = &ctx->d_frame;
-	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		f = &ctx->s_frame;
 	else
 		return -EINVAL;
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 82505025d96c..33611a46ce35 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -460,8 +460,8 @@ static int gsc_m2m_g_selection(struct file *file, void *fh,
 	struct gsc_frame *frame;
 	struct gsc_ctx *ctx = fh_to_ctx(fh);
 
-	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
-	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
+	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
+	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
 		return -EINVAL;
 
 	frame = ctx_get_frame(ctx, s->type);
@@ -503,8 +503,8 @@ static int gsc_m2m_s_selection(struct file *file, void *fh,
 	cr.type = s->type;
 	cr.c = s->r;
 
-	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
-	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
+	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
+	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
 		return -EINVAL;
 
 	ret = gsc_try_crop(ctx, &cr);
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index db60a63c0768..948fe01f6c96 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1270,7 +1270,7 @@ static int fimc_cap_g_selection(struct file *file, void *fh,
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct fimc_frame *f = &ctx->s_frame;
 
-	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
 	switch (s->target) {
@@ -1322,7 +1322,7 @@ static int fimc_cap_s_selection(struct file *file, void *fh,
 	struct fimc_frame *f;
 	unsigned long flags;
 
-	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
 	if (s->target == V4L2_SEL_TGT_COMPOSE)
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index b4c4a33784c4..7d3ec5cc6608 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -901,7 +901,7 @@ static int fimc_lite_g_selection(struct file *file, void *fh,
 	struct fimc_lite *fimc = video_drvdata(file);
 	struct flite_frame *f = &fimc->out_frame;
 
-	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
 	switch (sel->target) {
@@ -929,7 +929,7 @@ static int fimc_lite_s_selection(struct file *file, void *fh,
 	struct v4l2_rect rect = sel->r;
 	unsigned long flags;
 
-	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ||
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
 	    sel->target != V4L2_SEL_TGT_COMPOSE)
 		return -EINVAL;
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 4f27cfa134a1..f27e8d089f9e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2141,6 +2141,47 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 					-EINVAL;
 }
 
+/*
+ * The selection API specified originally that the _MPLANE buffer types
+ * shouldn't be used. The reasons for this are lost in the mists of time
+ * (or just really crappy memories). Regardless, this is really annoying
+ * for userspace. So to keep things simple we map _MPLANE buffer types
+ * to their 'regular' counterparts before calling the driver. And we
+ * restore it afterwards. This way applications can use either buffer
+ * type and drivers don't need to check for both.
+ */
+static int v4l_g_selection(const struct v4l2_ioctl_ops *ops,
+			   struct file *file, void *fh, void *arg)
+{
+	struct v4l2_selection *p = arg;
+	u32 old_type = p->type;
+	int ret;
+
+	if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		p->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	else if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		p->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	ret = ops->vidioc_g_selection(file, fh, p);
+	p->type = old_type;
+	return ret;
+}
+
+static int v4l_s_selection(const struct v4l2_ioctl_ops *ops,
+			   struct file *file, void *fh, void *arg)
+{
+	struct v4l2_selection *p = arg;
+	u32 old_type = p->type;
+	int ret;
+
+	if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		p->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	else if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		p->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	ret = ops->vidioc_s_selection(file, fh, p);
+	p->type = old_type;
+	return ret;
+}
+
 static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -2160,7 +2201,7 @@ static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
 	else
 		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
 
-	ret = ops->vidioc_g_selection(file, fh, &s);
+	ret = v4l_g_selection(ops, file, fh, &s);
 
 	/* copying results to old structure on success */
 	if (!ret)
@@ -2187,7 +2228,7 @@ static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
 	else
 		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
 
-	return ops->vidioc_s_selection(file, fh, &s);
+	return v4l_s_selection(ops, file, fh, &s);
 }
 
 static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
@@ -2229,7 +2270,7 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 	else
 		s.target = V4L2_SEL_TGT_CROP_BOUNDS;
 
-	ret = ops->vidioc_g_selection(file, fh, &s);
+	ret = v4l_g_selection(ops, file, fh, &s);
 	if (ret)
 		return ret;
 	p->bounds = s.r;
@@ -2240,7 +2281,7 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 	else
 		s.target = V4L2_SEL_TGT_CROP_DEFAULT;
 
-	ret = ops->vidioc_g_selection(file, fh, &s);
+	ret = v4l_g_selection(ops, file, fh, &s);
 	if (ret)
 		return ret;
 	p->defrect = s.r;
@@ -2552,8 +2593,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_CROPCAP, v4l_cropcap, v4l_print_cropcap, INFO_FL_CLEAR(v4l2_cropcap, type)),
 	IOCTL_INFO_FNC(VIDIOC_G_CROP, v4l_g_crop, v4l_print_crop, INFO_FL_CLEAR(v4l2_crop, type)),
 	IOCTL_INFO_FNC(VIDIOC_S_CROP, v4l_s_crop, v4l_print_crop, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_SELECTION, vidioc_g_selection, v4l_print_selection, INFO_FL_CLEAR(v4l2_selection, r)),
-	IOCTL_INFO_STD(VIDIOC_S_SELECTION, vidioc_s_selection, v4l_print_selection, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_selection, r)),
+	IOCTL_INFO_FNC(VIDIOC_G_SELECTION, v4l_g_selection, v4l_print_selection, INFO_FL_CLEAR(v4l2_selection, r)),
+	IOCTL_INFO_FNC(VIDIOC_S_SELECTION, v4l_s_selection, v4l_print_selection, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_selection, r)),
 	IOCTL_INFO_STD(VIDIOC_G_JPEGCOMP, vidioc_g_jpegcomp, v4l_print_jpegcompression, 0),
 	IOCTL_INFO_STD(VIDIOC_S_JPEGCOMP, vidioc_s_jpegcomp, v4l_print_jpegcompression, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_QUERYSTD, v4l_querystd, v4l_print_std, 0),
-- 
2.11.0
