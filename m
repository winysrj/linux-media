Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49847 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab2EEMeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 08:34:22 -0400
Received: by werb10 with SMTP id b10so419809wer.19
        for <linux-media@vger.kernel.org>; Sat, 05 May 2012 05:34:21 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, sakari.ailus@iki.fi,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [RFC] V4L: Rename V4L2_SEL_TGT_*_ACTIVE to V4L2_SEL_TGT_*_ACTUAL
Date: Sat,  5 May 2012 14:34:07 +0200
Message-Id: <1336221247-6543-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After introduction of the selection API on subdevs we have following sets
of selection targets:

    /dev/v4l-subdev?               |   /dev/video?
-------------------------------------------------------------------------
V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL    | V4L2_SEL_TGT_CROP_ACTIVE
V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS    | V4L2_SEL_TGT_CROP_BOUNDS
                                   | V4L2_SEL_TGT_CROP_DEFAULT
                                   | V4L2_SEL_TGT_CROP_PADDED
V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL | V4L2_SEL_TGT_COMPOSE_ACTIVE
V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS | V4L2_SEL_TGT_COMPOSE_BOUNDS
                                   | V4L2_SEL_TGT_COMPOSE_DEFAULT
                                   | V4L2_SEL_TGT_COMPOSE_PADDED

Although not exactly the same, the meaning of V4L2_SEL_TGT_*_ACTIVE
and V4L2_SUBDEV_SEL_TGT_*_ACTUAL selection targets is logically the
same. Different names add to confusion where both APIs are used in
a single driver or an application.
Then, rename the V4l2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
V4l2_SEL_TGT_[CROP/COMPOSE]_ACTUAL to avoid the API inconsistencies.
The selections API is experimental, so no any compatibility layer
is added. The ABI remains unchanged.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/DocBook/media/v4l/selection-api.xml  |   24 ++++++++++----------
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   12 +++++-----
 drivers/media/video/s5p-fimc/fimc-capture.c        |    8 +++---
 drivers/media/video/s5p-jpeg/jpeg-core.c           |    4 +-
 drivers/media/video/s5p-tv/mixer_video.c           |    8 +++---
 drivers/media/video/v4l2-ioctl.c                   |    8 +++---
 include/linux/videodev2.h                          |    4 +-
 7 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index b299e47..5a02067 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -91,7 +91,7 @@ top/left corner at position <constant> (0,0) </constant>.  The rectangle's
 coordinates are expressed in pixels.</para>

 <para>The top left corner, width and height of the source rectangle, that is
-the area actually sampled, is given by the <constant> V4L2_SEL_TGT_CROP_ACTIVE
+the area actually sampled, is given by the <constant> V4L2_SEL_TGT_CROP_ACTUAL
 </constant> target. It uses the same coordinate system as <constant>
 V4L2_SEL_TGT_CROP_BOUNDS </constant>. The active cropping area must lie
 completely inside the capture boundaries. The driver may further adjust the
@@ -111,7 +111,7 @@ height are equal to the image size set by <constant> VIDIOC_S_FMT </constant>.
 </para>

 <para>The part of a buffer into which the image is inserted by the hardware is
-controlled by the <constant> V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> target.
+controlled by the <constant> V4L2_SEL_TGT_COMPOSE_ACTUAL </constant> target.
 The rectangle's coordinates are also expressed in the same coordinate system as
 the bounds rectangle. The composing rectangle must lie completely inside bounds
 rectangle. The driver must adjust the composing rectangle to fit to the
@@ -125,7 +125,7 @@ bounding rectangle.</para>

 <para>The part of a buffer that is modified by the hardware is given by
 <constant> V4L2_SEL_TGT_COMPOSE_PADDED </constant>. It contains all pixels
-defined using <constant> V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> plus all
+defined using <constant> V4L2_SEL_TGT_COMPOSE_ACTUAL </constant> plus all
 padding data modified by hardware during insertion process. All pixels outside
 this rectangle <emphasis>must not</emphasis> be changed by the hardware. The
 content of pixels that lie inside the padded area but outside active area is
@@ -153,7 +153,7 @@ specified using <constant> VIDIOC_S_FMT </constant> ioctl.</para>

 <para>The top left corner, width and height of the source rectangle, that is
 the area from which image date are processed by the hardware, is given by the
-<constant> V4L2_SEL_TGT_CROP_ACTIVE </constant>. Its coordinates are expressed
+<constant> V4L2_SEL_TGT_CROP_ACTUAL </constant>. Its coordinates are expressed
 in in the same coordinate system as the bounds rectangle. The active cropping
 area must lie completely inside the crop boundaries and the driver may further
 adjust the requested size and/or position according to hardware
@@ -165,7 +165,7 @@ bounding rectangle.</para>

 <para>The part of a video signal or graphics display where the image is
 inserted by the hardware is controlled by <constant>
-V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> target.  The rectangle's coordinates
+V4L2_SEL_TGT_COMPOSE_ACTUAL </constant> target.  The rectangle's coordinates
 are expressed in pixels. The composing rectangle must lie completely inside the
 bounds rectangle.  The driver must adjust the area to fit to the bounding
 limits.  Moreover, the driver can perform other adjustments according to
@@ -184,7 +184,7 @@ such a padded area is driver-dependent feature not covered by this document.
 Driver developers are encouraged to keep padded rectangle equal to active one.
 The padded target is accessed by the <constant> V4L2_SEL_TGT_COMPOSE_PADDED
 </constant> identifier.  It must contain all pixels from the <constant>
-V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> target.</para>
+V4L2_SEL_TGT_COMPOSE_ACTUAL </constant> target.</para>

    </section>

@@ -193,8 +193,8 @@ V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> target.</para>
      <title>Scaling control</title>

 <para>An application can detect if scaling is performed by comparing the width
-and the height of rectangles obtained using <constant> V4L2_SEL_TGT_CROP_ACTIVE
-</constant> and <constant> V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> targets. If
+and the height of rectangles obtained using <constant> V4L2_SEL_TGT_CROP_ACTUAL
+</constant> and <constant> V4L2_SEL_TGT_COMPOSE_ACTUAL </constant> targets. If
 these are not equal then the scaling is applied. The application can compute
 the scaling ratios using these values.</para>

@@ -252,7 +252,7 @@ area)</para>
 	ret = ioctl(fd, &VIDIOC-G-SELECTION;, &amp;sel);
 	if (ret)
 		exit(-1);
-	sel.target = V4L2_SEL_TGT_CROP_ACTIVE;
+	sel.target = V4L2_SEL_TGT_CROP_ACTUAL;
 	ret = ioctl(fd, &VIDIOC-S-SELECTION;, &amp;sel);
 	if (ret)
 		exit(-1);
@@ -281,7 +281,7 @@ area)</para>
 	r.left = sel.r.width / 4;
 	r.top = sel.r.height / 4;
 	sel.r = r;
-	sel.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+	sel.target = V4L2_SEL_TGT_COMPOSE_ACTUAL;
 	sel.flags = V4L2_SEL_FLAG_LE;
 	ret = ioctl(fd, &VIDIOC-S-SELECTION;, &amp;sel);
 	if (ret)
@@ -298,11 +298,11 @@ V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> for other devices</para>

 	&v4l2-selection; compose = {
 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
-		.target = V4L2_SEL_TGT_COMPOSE_ACTIVE,
+		.target = V4L2_SEL_TGT_COMPOSE_ACTUAL,
 	};
 	&v4l2-selection; crop = {
 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
-		.target = V4L2_SEL_TGT_CROP_ACTIVE,
+		.target = V4L2_SEL_TGT_CROP_ACTUAL,
 	};
 	double hscale, vscale;

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index bb04eff..8df737b 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -65,8 +65,8 @@ Do not use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
 </constant>.  Use <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> instead of
 <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE </constant>.  The next step is
 setting the value of &v4l2-selection; <structfield>target</structfield> field
-to <constant> V4L2_SEL_TGT_CROP_ACTIVE </constant> (<constant>
-V4L2_SEL_TGT_COMPOSE_ACTIVE </constant>).  Please refer to table <xref
+to <constant> V4L2_SEL_TGT_CROP_ACTUAL </constant> (<constant>
+V4L2_SEL_TGT_COMPOSE_ACTUAL </constant>).  Please refer to table <xref
 linkend="v4l2-sel-target" /> or <xref linkend="selection-api" /> for additional
 targets.  The <structfield>flags</structfield> and <structfield>reserved
 </structfield> fields of &v4l2-selection; are ignored and they must be filled
@@ -86,8 +86,8 @@ use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
 </constant>.  Use <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> instead of
 <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE </constant>.  The next step is
 setting the value of &v4l2-selection; <structfield>target</structfield> to
-<constant>V4L2_SEL_TGT_CROP_ACTIVE</constant> (<constant>
-V4L2_SEL_TGT_COMPOSE_ACTIVE </constant>). Please refer to table <xref
+<constant>V4L2_SEL_TGT_CROP_ACTUAL</constant> (<constant>
+V4L2_SEL_TGT_COMPOSE_ACTUAL </constant>). Please refer to table <xref
 linkend="v4l2-sel-target" /> or <xref linkend="selection-api" /> for additional
 targets.  The &v4l2-rect; <structfield>r</structfield> rectangle need to be
 set to the desired active area. Field &v4l2-selection; <structfield> reserved
@@ -161,7 +161,7 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 	&cs-def;
 	<tbody valign="top">
 	  <row>
-            <entry><constant>V4L2_SEL_TGT_CROP_ACTIVE</constant></entry>
+            <entry><constant>V4L2_SEL_TGT_CROP_ACTUAL</constant></entry>
             <entry>0x0000</entry>
             <entry>The area that is currently cropped by hardware.</entry>
 	  </row>
@@ -176,7 +176,7 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
             <entry>Limits for the cropping rectangle.</entry>
 	  </row>
 	  <row>
-            <entry><constant>V4L2_SEL_TGT_COMPOSE_ACTIVE</constant></entry>
+            <entry><constant>V4L2_SEL_TGT_COMPOSE_ACTUAL</constant></entry>
             <entry>0x0100</entry>
             <entry>The area to which data is composed by hardware.</entry>
 	  </row>
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index dc18ba5..e3a88db 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1059,9 +1059,9 @@ static int fimc_cap_g_selection(struct file *file, void *fh,
 		s->r.height = f->o_height;
 		return 0;

-	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+	case V4L2_SEL_TGT_COMPOSE_ACTUAL:
 		f = &ctx->d_frame;
-	case V4L2_SEL_TGT_CROP_ACTIVE:
+	case V4L2_SEL_TGT_CROP_ACTUAL:
 		s->r.left = f->offs_h;
 		s->r.top = f->offs_v;
 		s->r.width = f->width;
@@ -1101,13 +1101,13 @@ static int fimc_cap_s_selection(struct file *file, void *fh,
 	switch (s->target) {
 	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
-	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+	case V4L2_SEL_TGT_COMPOSE_ACTUAL:
 		f = &ctx->d_frame;
 		pad = FIMC_SD_PAD_SOURCE;
 		break;
 	case V4L2_SEL_TGT_CROP_BOUNDS:
 	case V4L2_SEL_TGT_CROP_DEFAULT:
-	case V4L2_SEL_TGT_CROP_ACTIVE:
+	case V4L2_SEL_TGT_CROP_ACTUAL:
 		f = &ctx->s_frame;
 		pad = FIMC_SD_PAD_SINK;
 		break;
diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index 5a49c30..944184a 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -824,10 +824,10 @@ int s5p_jpeg_g_selection(struct file *file, void *priv,

 	/* For JPEG blob active == default == bounds */
 	switch (s->target) {
-	case V4L2_SEL_TGT_CROP_ACTIVE:
+	case V4L2_SEL_TGT_CROP_ACTUAL:
 	case V4L2_SEL_TGT_CROP_BOUNDS:
 	case V4L2_SEL_TGT_CROP_DEFAULT:
-	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+	case V4L2_SEL_TGT_COMPOSE_ACTUAL:
 	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
 		s->r.width = ctx->out_q.w;
 		s->r.height = ctx->out_q.h;
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index f7ca5cc..9e6da34 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -367,7 +367,7 @@ static int mxr_g_selection(struct file *file, void *fh,
 		return -EINVAL;

 	switch (s->target) {
-	case V4L2_SEL_TGT_CROP_ACTIVE:
+	case V4L2_SEL_TGT_CROP_ACTUAL:
 		s->r.left = geo->src.x_offset;
 		s->r.top = geo->src.y_offset;
 		s->r.width = geo->src.width;
@@ -380,7 +380,7 @@ static int mxr_g_selection(struct file *file, void *fh,
 		s->r.width = geo->src.full_width;
 		s->r.height = geo->src.full_height;
 		break;
-	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+	case V4L2_SEL_TGT_COMPOSE_ACTUAL:
 	case V4L2_SEL_TGT_COMPOSE_PADDED:
 		s->r.left = geo->dst.x_offset;
 		s->r.top = geo->dst.y_offset;
@@ -449,11 +449,11 @@ static int mxr_s_selection(struct file *file, void *fh,
 		res.height = geo->dst.full_height;
 		break;

-	case V4L2_SEL_TGT_CROP_ACTIVE:
+	case V4L2_SEL_TGT_CROP_ACTUAL:
 		target = &geo->src;
 		stage = MXR_GEOMETRY_CROP;
 		break;
-	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+	case V4L2_SEL_TGT_COMPOSE_ACTUAL:
 	case V4L2_SEL_TGT_COMPOSE_PADDED:
 		target = &geo->dst;
 		stage = MXR_GEOMETRY_COMPOSE;
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 5b2ec1f..07bd01c 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1568,9 +1568,9 @@ static long __video_do_ioctl(struct file *file,

 			/* crop means compose for output devices */
 			if (V4L2_TYPE_IS_OUTPUT(p->type))
-				s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+				s.target = V4L2_SEL_TGT_COMPOSE_ACTUAL;
 			else
-				s.target = V4L2_SEL_TGT_CROP_ACTIVE;
+				s.target = V4L2_SEL_TGT_CROP_ACTUAL;

 			ret = ops->vidioc_g_selection(file, fh, &s);

@@ -1608,9 +1608,9 @@ static long __video_do_ioctl(struct file *file,

 			/* crop means compose for output devices */
 			if (V4L2_TYPE_IS_OUTPUT(p->type))
-				s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+				s.target = V4L2_SEL_TGT_COMPOSE_ACTUAL;
 			else
-				s.target = V4L2_SEL_TGT_CROP_ACTIVE;
+				s.target = V4L2_SEL_TGT_CROP_ACTUAL;

 			ret = ops->vidioc_s_selection(file, fh, &s);
 		}
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5a09ac3..681f87a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -763,13 +763,13 @@ struct v4l2_crop {
 /* Selection targets */

 /* Current cropping area */
-#define V4L2_SEL_TGT_CROP_ACTIVE	0x0000
+#define V4L2_SEL_TGT_CROP_ACTUAL	0x0000
 /* Default cropping area */
 #define V4L2_SEL_TGT_CROP_DEFAULT	0x0001
 /* Cropping bounds */
 #define V4L2_SEL_TGT_CROP_BOUNDS	0x0002
 /* Current composing area */
-#define V4L2_SEL_TGT_COMPOSE_ACTIVE	0x0100
+#define V4L2_SEL_TGT_COMPOSE_ACTUAL	0x0100
 /* Default composing area */
 #define V4L2_SEL_TGT_COMPOSE_DEFAULT	0x0101
 /* Composing bounds */
--
1.7.4.1

