Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:17642 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab2FMWkZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 18:40:25 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	snjw23@gmail.com, t.stanislaws@samsung.com
Subject: [PATCH v3 1/6] V4L: Remove "_ACTIVE" from the selection target name definitions
Date: Thu, 14 Jun 2012 01:39:36 +0300
Message-Id: <1339627181-8563-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4FD91697.9050100@iki.fi>
References: <4FD91697.9050100@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

This patch drops the _ACTIVE part from the selection target names
as a prerequisite to unify the selection target names across the subdev
and regular video node API.

The meaning of V4L2_SEL_TGT_*_ACTIVE and V4L2_SUBDEV_SEL_TGT_*_ACTUAL
selection targets is logically the same. Different names add to confusion
where both APIs are used in a single driver or an application. For some
system configurations different names may lead to interoperability issues.

For backwards compatibility V4L2_SEL_TGT_CROP_ACTIVE and
V4L2_SEL_TGT_COMPOSE_ACTIVE are defined as aliases to V4L2_SEL_TGT_CROP
and V4L2_SEL_TGT_COMPOSE. These aliases will be removed after deprecation
period, according to Documentation/feature-removal-schedule.txt.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/selection-api.xml  |   24 ++++++++++----------
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   15 ++++++-----
 drivers/media/video/s5p-fimc/fimc-capture.c        |   14 +++++-----
 drivers/media/video/s5p-fimc/fimc-lite.c           |    4 +-
 drivers/media/video/s5p-jpeg/jpeg-core.c           |    4 +-
 drivers/media/video/s5p-tv/mixer_video.c           |    8 +++---
 drivers/media/video/v4l2-ioctl.c                   |    8 +++---
 include/linux/videodev2.h                          |    8 +++++-
 8 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index b299e47..ac013e5 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -91,7 +91,7 @@ top/left corner at position <constant> (0,0) </constant>.  The rectangle's
 coordinates are expressed in pixels.</para>
 
 <para>The top left corner, width and height of the source rectangle, that is
-the area actually sampled, is given by the <constant> V4L2_SEL_TGT_CROP_ACTIVE
+the area actually sampled, is given by the <constant> V4L2_SEL_TGT_CROP
 </constant> target. It uses the same coordinate system as <constant>
 V4L2_SEL_TGT_CROP_BOUNDS </constant>. The active cropping area must lie
 completely inside the capture boundaries. The driver may further adjust the
@@ -111,7 +111,7 @@ height are equal to the image size set by <constant> VIDIOC_S_FMT </constant>.
 </para>
 
 <para>The part of a buffer into which the image is inserted by the hardware is
-controlled by the <constant> V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> target.
+controlled by the <constant> V4L2_SEL_TGT_COMPOSE </constant> target.
 The rectangle's coordinates are also expressed in the same coordinate system as
 the bounds rectangle. The composing rectangle must lie completely inside bounds
 rectangle. The driver must adjust the composing rectangle to fit to the
@@ -125,7 +125,7 @@ bounding rectangle.</para>
 
 <para>The part of a buffer that is modified by the hardware is given by
 <constant> V4L2_SEL_TGT_COMPOSE_PADDED </constant>. It contains all pixels
-defined using <constant> V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> plus all
+defined using <constant> V4L2_SEL_TGT_COMPOSE </constant> plus all
 padding data modified by hardware during insertion process. All pixels outside
 this rectangle <emphasis>must not</emphasis> be changed by the hardware. The
 content of pixels that lie inside the padded area but outside active area is
@@ -153,7 +153,7 @@ specified using <constant> VIDIOC_S_FMT </constant> ioctl.</para>
 
 <para>The top left corner, width and height of the source rectangle, that is
 the area from which image date are processed by the hardware, is given by the
-<constant> V4L2_SEL_TGT_CROP_ACTIVE </constant>. Its coordinates are expressed
+<constant> V4L2_SEL_TGT_CROP </constant>. Its coordinates are expressed
 in in the same coordinate system as the bounds rectangle. The active cropping
 area must lie completely inside the crop boundaries and the driver may further
 adjust the requested size and/or position according to hardware
@@ -165,7 +165,7 @@ bounding rectangle.</para>
 
 <para>The part of a video signal or graphics display where the image is
 inserted by the hardware is controlled by <constant>
-V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> target.  The rectangle's coordinates
+V4L2_SEL_TGT_COMPOSE </constant> target.  The rectangle's coordinates
 are expressed in pixels. The composing rectangle must lie completely inside the
 bounds rectangle.  The driver must adjust the area to fit to the bounding
 limits.  Moreover, the driver can perform other adjustments according to
@@ -184,7 +184,7 @@ such a padded area is driver-dependent feature not covered by this document.
 Driver developers are encouraged to keep padded rectangle equal to active one.
 The padded target is accessed by the <constant> V4L2_SEL_TGT_COMPOSE_PADDED
 </constant> identifier.  It must contain all pixels from the <constant>
-V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> target.</para>
+V4L2_SEL_TGT_COMPOSE </constant> target.</para>
 
    </section>
 
@@ -193,8 +193,8 @@ V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> target.</para>
      <title>Scaling control</title>
 
 <para>An application can detect if scaling is performed by comparing the width
-and the height of rectangles obtained using <constant> V4L2_SEL_TGT_CROP_ACTIVE
-</constant> and <constant> V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> targets. If
+and the height of rectangles obtained using <constant> V4L2_SEL_TGT_CROP
+</constant> and <constant> V4L2_SEL_TGT_COMPOSE </constant> targets. If
 these are not equal then the scaling is applied. The application can compute
 the scaling ratios using these values.</para>
 
@@ -252,7 +252,7 @@ area)</para>
 	ret = ioctl(fd, &VIDIOC-G-SELECTION;, &amp;sel);
 	if (ret)
 		exit(-1);
-	sel.target = V4L2_SEL_TGT_CROP_ACTIVE;
+	sel.target = V4L2_SEL_TGT_CROP;
 	ret = ioctl(fd, &VIDIOC-S-SELECTION;, &amp;sel);
 	if (ret)
 		exit(-1);
@@ -281,7 +281,7 @@ area)</para>
 	r.left = sel.r.width / 4;
 	r.top = sel.r.height / 4;
 	sel.r = r;
-	sel.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+	sel.target = V4L2_SEL_TGT_COMPOSE;
 	sel.flags = V4L2_SEL_FLAG_LE;
 	ret = ioctl(fd, &VIDIOC-S-SELECTION;, &amp;sel);
 	if (ret)
@@ -298,11 +298,11 @@ V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> for other devices</para>
 
 	&v4l2-selection; compose = {
 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
-		.target = V4L2_SEL_TGT_COMPOSE_ACTIVE,
+		.target = V4L2_SEL_TGT_COMPOSE,
 	};
 	&v4l2-selection; crop = {
 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
-		.target = V4L2_SEL_TGT_CROP_ACTIVE,
+		.target = V4L2_SEL_TGT_CROP,
 	};
 	double hscale, vscale;
 
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index bb04eff..6376e57 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -65,8 +65,8 @@ Do not use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
 </constant>.  Use <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> instead of
 <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE </constant>.  The next step is
 setting the value of &v4l2-selection; <structfield>target</structfield> field
-to <constant> V4L2_SEL_TGT_CROP_ACTIVE </constant> (<constant>
-V4L2_SEL_TGT_COMPOSE_ACTIVE </constant>).  Please refer to table <xref
+to <constant> V4L2_SEL_TGT_CROP </constant> (<constant>
+V4L2_SEL_TGT_COMPOSE </constant>).  Please refer to table <xref
 linkend="v4l2-sel-target" /> or <xref linkend="selection-api" /> for additional
 targets.  The <structfield>flags</structfield> and <structfield>reserved
 </structfield> fields of &v4l2-selection; are ignored and they must be filled
@@ -86,8 +86,8 @@ use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
 </constant>.  Use <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> instead of
 <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE </constant>.  The next step is
 setting the value of &v4l2-selection; <structfield>target</structfield> to
-<constant>V4L2_SEL_TGT_CROP_ACTIVE</constant> (<constant>
-V4L2_SEL_TGT_COMPOSE_ACTIVE </constant>). Please refer to table <xref
+<constant>V4L2_SEL_TGT_CROP</constant> (<constant>
+V4L2_SEL_TGT_COMPOSE </constant>). Please refer to table <xref
 linkend="v4l2-sel-target" /> or <xref linkend="selection-api" /> for additional
 targets.  The &v4l2-rect; <structfield>r</structfield> rectangle need to be
 set to the desired active area. Field &v4l2-selection; <structfield> reserved
@@ -161,7 +161,7 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 	&cs-def;
 	<tbody valign="top">
 	  <row>
-            <entry><constant>V4L2_SEL_TGT_CROP_ACTIVE</constant></entry>
+            <entry><constant>V4L2_SEL_TGT_CROP</constant></entry>
             <entry>0x0000</entry>
             <entry>The area that is currently cropped by hardware.</entry>
 	  </row>
@@ -176,7 +176,7 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
             <entry>Limits for the cropping rectangle.</entry>
 	  </row>
 	  <row>
-            <entry><constant>V4L2_SEL_TGT_COMPOSE_ACTIVE</constant></entry>
+            <entry><constant>V4L2_SEL_TGT_COMPOSE</constant></entry>
             <entry>0x0100</entry>
             <entry>The area to which data is composed by hardware.</entry>
 	  </row>
@@ -193,7 +193,8 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 	  <row>
             <entry><constant>V4L2_SEL_TGT_COMPOSE_PADDED</constant></entry>
             <entry>0x0103</entry>
-            <entry>The active area and all padding pixels that are inserted or modified by hardware.</entry>
+            <entry>The active area and all padding pixels that are inserted or
+	      modified by hardware.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 3545745..356cc5c 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -655,7 +655,7 @@ static void fimc_capture_try_selection(struct fimc_ctx *ctx,
 		r->left   = r->top = 0;
 		return;
 	}
-	if (target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
+	if (target == V4L2_SEL_TGT_COMPOSE) {
 		if (ctx->rotation != 90 && ctx->rotation != 270)
 			align_h = 1;
 		max_sc_h = min(SCALER_MAX_HRATIO, 1 << (ffs(sink->width) - 3));
@@ -682,7 +682,7 @@ static void fimc_capture_try_selection(struct fimc_ctx *ctx,
 		      rotate ? sink->f_height : sink->f_width);
 	max_h = min_t(u32, FIMC_CAMIF_MAX_HEIGHT, sink->f_height);
 
-	if (target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
+	if (target == V4L2_SEL_TGT_COMPOSE) {
 		min_w = min_t(u32, max_w, sink->f_width / max_sc_h);
 		min_h = min_t(u32, max_h, sink->f_height / max_sc_v);
 		if (rotate) {
@@ -1147,9 +1147,9 @@ static int fimc_cap_g_selection(struct file *file, void *fh,
 		s->r.height = f->o_height;
 		return 0;
 
-	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+	case V4L2_SEL_TGT_COMPOSE:
 		f = &ctx->d_frame;
-	case V4L2_SEL_TGT_CROP_ACTIVE:
+	case V4L2_SEL_TGT_CROP:
 		s->r.left = f->offs_h;
 		s->r.top = f->offs_v;
 		s->r.width = f->width;
@@ -1185,9 +1185,9 @@ static int fimc_cap_s_selection(struct file *file, void *fh,
 	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
-	if (s->target == V4L2_SEL_TGT_COMPOSE_ACTIVE)
+	if (s->target == V4L2_SEL_TGT_COMPOSE)
 		f = &ctx->d_frame;
-	else if (s->target == V4L2_SEL_TGT_CROP_ACTIVE)
+	else if (s->target == V4L2_SEL_TGT_CROP)
 		f = &ctx->s_frame;
 	else
 		return -EINVAL;
@@ -1483,7 +1483,7 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	mutex_lock(&fimc->lock);
-	fimc_capture_try_selection(ctx, r, V4L2_SEL_TGT_CROP_ACTIVE);
+	fimc_capture_try_selection(ctx, r, V4L2_SEL_TGT_CROP);
 
 	switch (sel->target) {
 	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index 400d701a..52ede56 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -871,7 +871,7 @@ static int fimc_lite_g_selection(struct file *file, void *fh,
 		sel->r.height = f->f_height;
 		return 0;
 
-	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+	case V4L2_SEL_TGT_COMPOSE:
 		sel->r = f->rect;
 		return 0;
 	}
@@ -888,7 +888,7 @@ static int fimc_lite_s_selection(struct file *file, void *fh,
 	unsigned long flags;
 
 	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ||
-	    sel->target != V4L2_SEL_TGT_COMPOSE_ACTIVE)
+	    sel->target != V4L2_SEL_TGT_COMPOSE)
 		return -EINVAL;
 
 	fimc_lite_try_compose(fimc, &rect);
diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index 28b5225d..fbb8e3d 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -824,10 +824,10 @@ static int s5p_jpeg_g_selection(struct file *file, void *priv,
 
 	/* For JPEG blob active == default == bounds */
 	switch (s->target) {
-	case V4L2_SEL_TGT_CROP_ACTIVE:
+	case V4L2_SEL_TGT_CROP:
 	case V4L2_SEL_TGT_CROP_BOUNDS:
 	case V4L2_SEL_TGT_CROP_DEFAULT:
-	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+	case V4L2_SEL_TGT_COMPOSE:
 	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
 		s->r.width = ctx->out_q.w;
 		s->r.height = ctx->out_q.h;
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 33fde2a..6c74b05 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -367,7 +367,7 @@ static int mxr_g_selection(struct file *file, void *fh,
 		return -EINVAL;
 
 	switch (s->target) {
-	case V4L2_SEL_TGT_CROP_ACTIVE:
+	case V4L2_SEL_TGT_CROP:
 		s->r.left = geo->src.x_offset;
 		s->r.top = geo->src.y_offset;
 		s->r.width = geo->src.width;
@@ -380,7 +380,7 @@ static int mxr_g_selection(struct file *file, void *fh,
 		s->r.width = geo->src.full_width;
 		s->r.height = geo->src.full_height;
 		break;
-	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+	case V4L2_SEL_TGT_COMPOSE:
 	case V4L2_SEL_TGT_COMPOSE_PADDED:
 		s->r.left = geo->dst.x_offset;
 		s->r.top = geo->dst.y_offset;
@@ -449,11 +449,11 @@ static int mxr_s_selection(struct file *file, void *fh,
 		res.height = geo->dst.full_height;
 		break;
 
-	case V4L2_SEL_TGT_CROP_ACTIVE:
+	case V4L2_SEL_TGT_CROP:
 		target = &geo->src;
 		stage = MXR_GEOMETRY_CROP;
 		break;
-	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+	case V4L2_SEL_TGT_COMPOSE:
 	case V4L2_SEL_TGT_COMPOSE_PADDED:
 		target = &geo->dst;
 		stage = MXR_GEOMETRY_COMPOSE;
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 91be4e8..f3eeea2 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1486,9 +1486,9 @@ static long __video_do_ioctl(struct file *file,
 
 			/* crop means compose for output devices */
 			if (V4L2_TYPE_IS_OUTPUT(p->type))
-				s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+				s.target = V4L2_SEL_TGT_COMPOSE;
 			else
-				s.target = V4L2_SEL_TGT_CROP_ACTIVE;
+				s.target = V4L2_SEL_TGT_CROP;
 
 			ret = ops->vidioc_g_selection(file, fh, &s);
 
@@ -1519,9 +1519,9 @@ static long __video_do_ioctl(struct file *file,
 
 			/* crop means compose for output devices */
 			if (V4L2_TYPE_IS_OUTPUT(p->type))
-				s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+				s.target = V4L2_SEL_TGT_COMPOSE;
 			else
-				s.target = V4L2_SEL_TGT_CROP_ACTIVE;
+				s.target = V4L2_SEL_TGT_CROP;
 
 			ret = ops->vidioc_s_selection(file, fh, &s);
 		}
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 370d111..7478e7e 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -768,13 +768,13 @@ struct v4l2_crop {
 /* Selection targets */
 
 /* Current cropping area */
-#define V4L2_SEL_TGT_CROP_ACTIVE	0x0000
+#define V4L2_SEL_TGT_CROP		0x0000
 /* Default cropping area */
 #define V4L2_SEL_TGT_CROP_DEFAULT	0x0001
 /* Cropping bounds */
 #define V4L2_SEL_TGT_CROP_BOUNDS	0x0002
 /* Current composing area */
-#define V4L2_SEL_TGT_COMPOSE_ACTIVE	0x0100
+#define V4L2_SEL_TGT_COMPOSE		0x0100
 /* Default composing area */
 #define V4L2_SEL_TGT_COMPOSE_DEFAULT	0x0101
 /* Composing bounds */
@@ -782,6 +782,10 @@ struct v4l2_crop {
 /* Current composing area plus all padding pixels */
 #define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
 
+/* Backward compatibility definitions */
+#define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
+#define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE
+
 /**
  * struct v4l2_selection - selection info
  * @type:	buffer type (do not use *_MPLANE types)
-- 
1.7.2.5

