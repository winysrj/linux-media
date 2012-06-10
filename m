Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1460 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2FJK0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 13/32] v4l2-ioctl.c: use the new table for selection ioctls.
Date: Sun, 10 Jun 2012 12:25:35 +0200
Message-Id: <00063588044df01aadc420a08c842f1f662bd067.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  262 ++++++++++++++++++--------------------
 1 file changed, 127 insertions(+), 135 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 4fb113b..9e39b74 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -570,17 +570,45 @@ static void v4l_print_ext_controls(const void *arg)
 	pr_cont("\n");
 }
 
-static void v4l_print_u32(const void *arg)
+static void v4l_print_cropcap(const void *arg)
 {
-	pr_cont("value=%u\n", *(const u32 *)arg);
+	const struct v4l2_cropcap *p = arg;
+
+	pr_cont("type=%s, bounds wxh=%dx%d, x,y=%d,%d, "
+		"defrect wxh=%dx%d, x,y=%d,%d\n, "
+		"pixelaspect %d/%d\n",
+		prt_names(p->type, v4l2_type_names),
+		p->bounds.width, p->bounds.height,
+		p->bounds.left, p->bounds.top,
+		p->defrect.width, p->defrect.height,
+		p->defrect.left, p->defrect.top,
+		p->pixelaspect.numerator, p->pixelaspect.denominator);
 }
 
-static inline void dbgrect(struct video_device *vfd, char *s,
-							struct v4l2_rect *r)
+static void v4l_print_crop(const void *arg)
 {
-	dbgarg2("%sRect start at %dx%d, size=%dx%d\n", s, r->left, r->top,
-						r->width, r->height);
-};
+	const struct v4l2_crop *p = arg;
+
+	pr_cont("type=%s, wxh=%dx%d, x,y=%d,%d\n",
+		prt_names(p->type, v4l2_type_names),
+		p->c.width, p->c.height,
+		p->c.left, p->c.top);
+}
+
+static void v4l_print_selection(const void *arg)
+{
+	const struct v4l2_selection *p = arg;
+
+	pr_cont("type=%s, target=%d, flags=0x%x, wxh=%dx%d, x,y=%d,%d\n",
+		prt_names(p->type, v4l2_type_names),
+		p->target, p->flags,
+		p->r.width, p->r.height, p->r.left, p->r.top);
+}
+
+static void v4l_print_u32(const void *arg)
+{
+	pr_cont("value=%u\n", *(const u32 *)arg);
+}
 
 static void dbgtimings(struct video_device *vfd,
 			const struct v4l2_dv_timings *p)
@@ -1397,6 +1425,93 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 					-EINVAL;
 }
 
+static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_crop *p = arg;
+	struct v4l2_selection s = {
+		.type = p->type,
+	};
+	int ret;
+
+	if (ops->vidioc_g_crop)
+		return ops->vidioc_g_crop(file, fh, p);
+	/* simulate capture crop using selection api */
+
+	/* crop means compose for output devices */
+	if (V4L2_TYPE_IS_OUTPUT(p->type))
+		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+	else
+		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
+
+	ret = ops->vidioc_g_selection(file, fh, &s);
+
+	/* copying results to old structure on success */
+	if (!ret)
+		p->c = s.r;
+	return ret;
+}
+
+static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_crop *p = arg;
+	struct v4l2_selection s = {
+		.type = p->type,
+		.r = p->c,
+	};
+
+	if (ops->vidioc_s_crop)
+		return ops->vidioc_s_crop(file, fh, p);
+	/* simulate capture crop using selection api */
+
+	/* crop means compose for output devices */
+	if (V4L2_TYPE_IS_OUTPUT(p->type))
+		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+	else
+		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
+
+	return ops->vidioc_s_selection(file, fh, &s);
+}
+
+static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_cropcap *p = arg;
+	struct v4l2_selection s = { .type = p->type };
+	int ret;
+
+	if (ops->vidioc_cropcap)
+		return ops->vidioc_cropcap(file, fh, p);
+
+	/* obtaining bounds */
+	if (V4L2_TYPE_IS_OUTPUT(p->type))
+		s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
+	else
+		s.target = V4L2_SEL_TGT_CROP_BOUNDS;
+
+	ret = ops->vidioc_g_selection(file, fh, &s);
+	if (ret)
+		return ret;
+	p->bounds = s.r;
+
+	/* obtaining defrect */
+	if (V4L2_TYPE_IS_OUTPUT(p->type))
+		s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
+	else
+		s.target = V4L2_SEL_TGT_CROP_DEFAULT;
+
+	ret = ops->vidioc_g_selection(file, fh, &s);
+	if (ret)
+		return ret;
+	p->defrect = s.r;
+
+	/* setting trivial pixelaspect */
+	p->pixelaspect.numerator = 1;
+	p->pixelaspect.denominator = 1;
+	return 0;
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -1486,11 +1601,11 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_S_MODULATOR, vidioc_s_modulator, v4l_print_s_modulator, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_G_FREQUENCY, v4l_g_frequency, v4l_print_frequency, INFO_FL_CLEAR(v4l2_frequency, tuner)),
 	IOCTL_INFO_FNC(VIDIOC_S_FREQUENCY, v4l_s_frequency, v4l_print_frequency, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_CROPCAP, INFO_FL_CLEAR(v4l2_cropcap, type)),
-	IOCTL_INFO(VIDIOC_G_CROP, INFO_FL_CLEAR(v4l2_crop, type)),
-	IOCTL_INFO(VIDIOC_S_CROP, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_SELECTION, 0),
-	IOCTL_INFO(VIDIOC_S_SELECTION, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_CROPCAP, v4l_cropcap, v4l_print_cropcap, INFO_FL_CLEAR(v4l2_cropcap, type)),
+	IOCTL_INFO_FNC(VIDIOC_G_CROP, v4l_g_crop, v4l_print_crop, INFO_FL_CLEAR(v4l2_crop, type)),
+	IOCTL_INFO_FNC(VIDIOC_S_CROP, v4l_s_crop, v4l_print_crop, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_G_SELECTION, vidioc_g_selection, v4l_print_selection, 0),
+	IOCTL_INFO_STD(VIDIOC_S_SELECTION, vidioc_s_selection, v4l_print_selection, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_JPEGCOMP, 0),
 	IOCTL_INFO(VIDIOC_S_JPEGCOMP, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_QUERYSTD, v4l_querystd, v4l_print_std, 0),
@@ -1635,129 +1750,6 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 	switch (cmd) {
-	case VIDIOC_G_CROP:
-	{
-		struct v4l2_crop *p = arg;
-
-		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-
-		if (ops->vidioc_g_crop) {
-			ret = ops->vidioc_g_crop(file, fh, p);
-		} else {
-			/* simulate capture crop using selection api */
-			struct v4l2_selection s = {
-				.type = p->type,
-			};
-
-			/* crop means compose for output devices */
-			if (V4L2_TYPE_IS_OUTPUT(p->type))
-				s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
-			else
-				s.target = V4L2_SEL_TGT_CROP_ACTIVE;
-
-			ret = ops->vidioc_g_selection(file, fh, &s);
-
-			/* copying results to old structure on success */
-			if (!ret)
-				p->c = s.r;
-		}
-
-		if (!ret)
-			dbgrect(vfd, "", &p->c);
-		break;
-	}
-	case VIDIOC_S_CROP:
-	{
-		struct v4l2_crop *p = arg;
-
-		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-		dbgrect(vfd, "", &p->c);
-
-		if (ops->vidioc_s_crop) {
-			ret = ops->vidioc_s_crop(file, fh, p);
-		} else {
-			/* simulate capture crop using selection api */
-			struct v4l2_selection s = {
-				.type = p->type,
-				.r = p->c,
-			};
-
-			/* crop means compose for output devices */
-			if (V4L2_TYPE_IS_OUTPUT(p->type))
-				s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
-			else
-				s.target = V4L2_SEL_TGT_CROP_ACTIVE;
-
-			ret = ops->vidioc_s_selection(file, fh, &s);
-		}
-		break;
-	}
-	case VIDIOC_G_SELECTION:
-	{
-		struct v4l2_selection *p = arg;
-
-		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-
-		ret = ops->vidioc_g_selection(file, fh, p);
-		if (!ret)
-			dbgrect(vfd, "", &p->r);
-		break;
-	}
-	case VIDIOC_S_SELECTION:
-	{
-		struct v4l2_selection *p = arg;
-
-
-		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-		dbgrect(vfd, "", &p->r);
-
-		ret = ops->vidioc_s_selection(file, fh, p);
-		break;
-	}
-	case VIDIOC_CROPCAP:
-	{
-		struct v4l2_cropcap *p = arg;
-
-		/*FIXME: Should also show v4l2_fract pixelaspect */
-		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
-		if (ops->vidioc_cropcap) {
-			ret = ops->vidioc_cropcap(file, fh, p);
-		} else {
-			struct v4l2_selection s = { .type = p->type };
-
-			/* obtaining bounds */
-			if (V4L2_TYPE_IS_OUTPUT(p->type))
-				s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
-			else
-				s.target = V4L2_SEL_TGT_CROP_BOUNDS;
-
-			ret = ops->vidioc_g_selection(file, fh, &s);
-			if (ret)
-				break;
-			p->bounds = s.r;
-
-			/* obtaining defrect */
-			if (V4L2_TYPE_IS_OUTPUT(p->type))
-				s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
-			else
-				s.target = V4L2_SEL_TGT_CROP_DEFAULT;
-
-			ret = ops->vidioc_g_selection(file, fh, &s);
-			if (ret)
-				break;
-			p->defrect = s.r;
-
-			/* setting trivial pixelaspect */
-			p->pixelaspect.numerator = 1;
-			p->pixelaspect.denominator = 1;
-		}
-
-		if (!ret) {
-			dbgrect(vfd, "bounds ", &p->bounds);
-			dbgrect(vfd, "defrect ", &p->defrect);
-		}
-		break;
-	}
 	case VIDIOC_G_JPEGCOMP:
 	{
 		struct v4l2_jpegcompression *p = arg;
-- 
1.7.10

