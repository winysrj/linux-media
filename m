Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:21390 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab2F3RFh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 13:05:37 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: sylwester.nawrocki@gmail.com, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH 2/8] v4l: Remove "_ACTUAL" from subdev selection API target definition names
Date: Sat, 30 Jun 2012 20:03:53 +0300
Message-Id: <1341075839-18586-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120630170506.GE19384@valkosipuli.retiisi.org.uk>
References: <20120630170506.GE19384@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The string "_ACTUAL" does not say anything more about the target names. Drop
it. V4L2 selection API was changed by "V4L: Remove "_ACTIVE" from the
selection target name definitions" by Sylwester Nawrocki. This patch does
the same for the V4L2 subdev API.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   28 ++++++++++----------
 .../media/v4l/vidioc-subdev-g-selection.xml        |   12 ++++----
 drivers/media/video/omap3isp/ispccdc.c             |    4 +-
 drivers/media/video/omap3isp/isppreview.c          |    4 +-
 drivers/media/video/omap3isp/ispresizer.c          |    4 +-
 drivers/media/video/smiapp/smiapp-core.c           |   22 ++++++++--------
 drivers/media/video/v4l2-subdev.c                  |    4 +-
 include/linux/v4l2-subdev.h                        |    9 +++++-
 8 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index 4afcbbe..e88d5ea 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -289,9 +289,9 @@
       &v4l2-rect; by the coordinates of the top left corner and the rectangle
       size. Both the coordinates and sizes are expressed in pixels.</para>
 
-      <para>As for pad formats, drivers store try and active
-      rectangles for the selection targets of ACTUAL type <xref
-      linkend="v4l2-subdev-selection-targets">.</xref></para>
+      <para>As for pad formats, drivers store try and active rectangles for
+      the selection targets <xref
+      linkend="v4l2-subdev-selection-targets" />.</para>
 
       <para>On sink pads, cropping is applied relative to the
       current pad format. The pad format represents the image size as
@@ -308,7 +308,7 @@
       <para>Scaling support is optional. When supported by a subdev,
       the crop rectangle on the subdev's sink pad is scaled to the
       size configured using the &VIDIOC-SUBDEV-S-SELECTION; IOCTL
-      using <constant>V4L2_SUBDEV_SEL_COMPOSE_ACTUAL</constant>
+      using <constant>V4L2_SUBDEV_SEL_TGT_COMPOSE</constant>
       selection target on the same pad. If the subdev supports scaling
       but not composing, the top and left values are not used and must
       always be set to zero.</para>
@@ -333,22 +333,22 @@
       <title>Types of selection targets</title>
 
       <section>
-	<title>ACTUAL targets</title>
+	<title>Actual targets</title>
 
-	<para>ACTUAL targets reflect the actual hardware configuration
-	at any point of time. There is a BOUNDS target
-	corresponding to every ACTUAL.</para>
+	<para>Actual targets (without a postfix) reflect the actual
+	hardware configuration at any point of time. There is a BOUNDS
+	target corresponding to every actual target.</para>
       </section>
 
       <section>
 	<title>BOUNDS targets</title>
 
-	<para>BOUNDS targets is the smallest rectangle that contains
-	all valid ACTUAL rectangles. It may not be possible to set the
-	ACTUAL rectangle as large as the BOUNDS rectangle, however.
-	This may be because e.g. a sensor's pixel array is not
-	rectangular but cross-shaped or round. The maximum size may
-	also be smaller than the BOUNDS rectangle.</para>
+	<para>BOUNDS targets is the smallest rectangle that contains all
+	valid actual rectangles. It may not be possible to set the actual
+	rectangle as large as the BOUNDS rectangle, however. This may be
+	because e.g. a sensor's pixel array is not rectangular but
+	cross-shaped or round. The maximum size may also be smaller than the
+	BOUNDS rectangle.</para>
       </section>
 
     </section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
index 208e9f0..4c44808 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -72,10 +72,10 @@
     <section>
       <title>Types of selection targets</title>
 
-      <para>There are two types of selection targets: actual and bounds.
-      The ACTUAL targets are the targets which configure the hardware.
-      The BOUNDS target will return a rectangle that contain all
-      possible ACTUAL rectangles.</para>
+      <para>There are two types of selection targets: actual and bounds. The
+      actual targets are the targets which configure the hardware. The BOUNDS
+      target will return a rectangle that contain all possible actual
+      rectangles.</para>
     </section>
 
     <section>
@@ -93,7 +93,7 @@
         &cs-def;
 	<tbody valign="top">
 	  <row>
-	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL</constant></entry>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP</constant></entry>
 	    <entry>0x0000</entry>
 	    <entry>Actual crop. Defines the cropping
 	    performed by the processing step.</entry>
@@ -104,7 +104,7 @@
 	    <entry>Bounds of the crop rectangle.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL</constant></entry>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE</constant></entry>
 	    <entry>0x0100</entry>
 	    <entry>Actual compose rectangle. Used to configure scaling
 	    on sink pads and composition on source pads.</entry>
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 7e32331..f19774f 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -2024,7 +2024,7 @@ static int ccdc_get_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		ccdc_try_crop(ccdc, format, &sel->r);
 		break;
 
-	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_CROP:
 		sel->r = *__ccdc_get_crop(ccdc, fh, sel->which);
 		break;
 
@@ -2052,7 +2052,7 @@ static int ccdc_set_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL ||
+	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP ||
 	    sel->pad != CCDC_PAD_SOURCE_OF)
 		return -EINVAL;
 
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 8a4935e..1086f6a 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -1960,7 +1960,7 @@ static int preview_get_selection(struct v4l2_subdev *sd,
 		preview_try_crop(prev, format, &sel->r);
 		break;
 
-	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_CROP:
 		sel->r = *__preview_get_crop(prev, fh, sel->which);
 		break;
 
@@ -1988,7 +1988,7 @@ static int preview_set_selection(struct v4l2_subdev *sd,
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL ||
+	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP ||
 	    sel->pad != PREV_PAD_SINK)
 		return -EINVAL;
 
diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 14041c9..9456652 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -1259,7 +1259,7 @@ static int resizer_get_selection(struct v4l2_subdev *sd,
 		resizer_calc_ratios(res, &sel->r, format_source, &ratio);
 		break;
 
-	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_CROP:
 		sel->r = *__resizer_get_crop(res, fh, sel->which);
 		resizer_calc_ratios(res, &sel->r, format_source, &ratio);
 		break;
@@ -1293,7 +1293,7 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *format_sink, *format_source;
 	struct resizer_ratio ratio;
 
-	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL ||
+	if (sel->target != V4L2_SUBDEV_SEL_TGT_CROP ||
 	    sel->pad != RESZ_PAD_SINK)
 		return -EINVAL;
 
diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index e8c93c8..37622bb6 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -1630,7 +1630,7 @@ static void smiapp_propagate(struct v4l2_subdev *subdev,
 	smiapp_get_crop_compose(subdev, fh, crops, &comp, which);
 
 	switch (target) {
-	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_CROP:
 		comp->width = crops[SMIAPP_PAD_SINK]->width;
 		comp->height = crops[SMIAPP_PAD_SINK]->height;
 		if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
@@ -1646,7 +1646,7 @@ static void smiapp_propagate(struct v4l2_subdev *subdev,
 			}
 		}
 		/* Fall through */
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE:
 		*crops[SMIAPP_PAD_SRC] = *comp;
 		break;
 	default:
@@ -1722,7 +1722,7 @@ static int smiapp_set_format(struct v4l2_subdev *subdev,
 	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		ssd->sink_fmt = *crops[ssd->sink_pad];
 	smiapp_propagate(subdev, fh, fmt->which,
-			 V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL);
+			 V4L2_SUBDEV_SEL_TGT_CROP);
 
 	mutex_unlock(&sensor->mutex);
 
@@ -1957,7 +1957,7 @@ static int smiapp_set_compose(struct v4l2_subdev *subdev,
 
 	*comp = sel->r;
 	smiapp_propagate(subdev, fh, sel->which,
-			 V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL);
+			 V4L2_SUBDEV_SEL_TGT_COMPOSE);
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		return smiapp_update_mode(sensor);
@@ -1973,7 +1973,7 @@ static int __smiapp_sel_supported(struct v4l2_subdev *subdev,
 
 	/* We only implement crop in three places. */
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_CROP:
 	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
 		if (ssd == sensor->pixel_array
 		    && sel->pad == SMIAPP_PA_PAD_SRC)
@@ -1987,7 +1987,7 @@ static int __smiapp_sel_supported(struct v4l2_subdev *subdev,
 		    == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP)
 			return 0;
 		return -EINVAL;
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE:
 	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
 		if (sel->pad == ssd->source_pad)
 			return -EINVAL;
@@ -2050,7 +2050,7 @@ static int smiapp_set_crop(struct v4l2_subdev *subdev,
 
 	if (ssd != sensor->pixel_array && sel->pad == SMIAPP_PAD_SINK)
 		smiapp_propagate(subdev, fh, sel->which,
-				 V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL);
+				 V4L2_SUBDEV_SEL_TGT_CROP);
 
 	return 0;
 }
@@ -2096,11 +2096,11 @@ static int __smiapp_get_selection(struct v4l2_subdev *subdev,
 			sel->r = *comp;
 		}
 		break;
-	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_CROP:
 	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
 		sel->r = *crops[sel->pad];
 		break;
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE:
 		sel->r = *comp;
 		break;
 	}
@@ -2147,10 +2147,10 @@ static int smiapp_set_selection(struct v4l2_subdev *subdev,
 			      sel->r.height);
 
 	switch (sel->target) {
-	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_CROP:
 		ret = smiapp_set_crop(subdev, fh, sel);
 		break;
-	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE:
 		ret = smiapp_set_compose(subdev, fh, sel);
 		break;
 	default:
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index db6e859..cd86f0c 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -245,7 +245,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		memset(&sel, 0, sizeof(sel));
 		sel.which = crop->which;
 		sel.pad = crop->pad;
-		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL;
+		sel.target = V4L2_SUBDEV_SEL_TGT_CROP;
 
 		rval = v4l2_subdev_call(
 			sd, pad, get_selection, subdev_fh, &sel);
@@ -274,7 +274,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		memset(&sel, 0, sizeof(sel));
 		sel.which = crop->which;
 		sel.pad = crop->pad;
-		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL;
+		sel.target = V4L2_SUBDEV_SEL_TGT_CROP;
 		sel.r = crop->rect;
 
 		rval = v4l2_subdev_call(
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
index 812019e..3cbe688 100644
--- a/include/linux/v4l2-subdev.h
+++ b/include/linux/v4l2-subdev.h
@@ -128,14 +128,19 @@ struct v4l2_subdev_frame_interval_enum {
 #define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG		(1 << 2)
 
 /* active cropping area */
-#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL			0x0000
+#define V4L2_SUBDEV_SEL_TGT_CROP			0x0000
 /* cropping bounds */
 #define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			0x0002
 /* current composing area */
-#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL		0x0100
+#define V4L2_SUBDEV_SEL_TGT_COMPOSE			0x0100
 /* composing bounds */
 #define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS		0x0102
 
+/* backward compatibility definitions */
+#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL \
+	V4L2_SUBDEV_SEL_TGT_CROP
+#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL \
+	V4L2_SUBDEV_SEL_TGT_COMPOSE
 
 /**
  * struct v4l2_subdev_selection - selection info
-- 
1.7.2.5

