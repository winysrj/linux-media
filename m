Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:44548 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030AbcGQJIc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 05:08:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/5] v4l2-dv-timings: add helpers to find vic and pixelaspect ratio
Date: Sun, 17 Jul 2016 11:08:15 +0200
Message-Id: <1468746497-46692-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468746497-46692-1-git-send-email-hverkuil@xs4all.nl>
References: <1468746497-46692-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a helper to find timings based on the CEA-861 VIC code. Also add a helper
that returns the pixel aspect ratio based on the v4l2_dv_timings struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/Kconfig           |  1 +
 drivers/media/v4l2-core/v4l2-dv-timings.c | 58 +++++++++++++++++++++++++++++--
 include/media/v4l2-dv-timings.h           | 18 ++++++++++
 3 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 29b3436..7d38db1 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -6,6 +6,7 @@
 config VIDEO_V4L2
 	tristate
 	depends on (I2C || I2C=n) && VIDEO_DEV
+	select RATIONAL
 	default (I2C || I2C=n) && VIDEO_DEV
 
 config VIDEO_ADV_DEBUG
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 889de0a..98aa2fa 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/rational.h>
 #include <linux/videodev2.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-dv-timings.h>
@@ -224,6 +225,24 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 }
 EXPORT_SYMBOL_GPL(v4l2_find_dv_timings_cap);
 
+bool v4l2_find_dv_timings_cea861_vic(struct v4l2_dv_timings *t, u8 vic)
+{
+	unsigned int i;
+
+	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
+		const struct v4l2_bt_timings *bt =
+			&v4l2_dv_timings_presets[i].bt;
+
+		if ((bt->flags & V4L2_DV_FL_HAS_CEA861_VIC) &&
+		    bt->cea861_vic == vic) {
+			*t = v4l2_dv_timings_presets[i];
+			return true;
+		}
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(v4l2_find_dv_timings_cea861_vic);
+
 /**
  * v4l2_match_dv_timings - check if two timings match
  * @t1 - compare this v4l2_dv_timings struct...
@@ -306,7 +325,7 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 			(bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
 			bt->il_vsync, bt->il_vbackporch);
 	pr_info("%s: pixelclock: %llu\n", dev_prefix, bt->pixelclock);
-	pr_info("%s: flags (0x%x):%s%s%s%s%s%s\n", dev_prefix, bt->flags,
+	pr_info("%s: flags (0x%x):%s%s%s%s%s%s%s%s%s\n", dev_prefix, bt->flags,
 			(bt->flags & V4L2_DV_FL_REDUCED_BLANKING) ?
 			" REDUCED_BLANKING" : "",
 			((bt->flags & V4L2_DV_FL_REDUCED_BLANKING) &&
@@ -318,15 +337,50 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 			(bt->flags & V4L2_DV_FL_HALF_LINE) ?
 			" HALF_LINE" : "",
 			(bt->flags & V4L2_DV_FL_IS_CE_VIDEO) ?
-			" CE_VIDEO" : "");
+			" CE_VIDEO" : "",
+			(bt->flags & V4L2_DV_FL_HAS_PICTURE_ASPECT) ?
+			" HAS_PICTURE_ASPECT" : "",
+			(bt->flags & V4L2_DV_FL_HAS_CEA861_VIC) ?
+			" HAS_CEA861_VIC" : "",
+			(bt->flags & V4L2_DV_FL_HAS_HDMI_VIC) ?
+			" HAS_HDMI_VIC" : "");
 	pr_info("%s: standards (0x%x):%s%s%s%s\n", dev_prefix, bt->standards,
 			(bt->standards & V4L2_DV_BT_STD_CEA861) ?  " CEA" : "",
 			(bt->standards & V4L2_DV_BT_STD_DMT) ?  " DMT" : "",
 			(bt->standards & V4L2_DV_BT_STD_CVT) ?  " CVT" : "",
 			(bt->standards & V4L2_DV_BT_STD_GTF) ?  " GTF" : "");
+	if (bt->flags & V4L2_DV_FL_HAS_PICTURE_ASPECT)
+		pr_info("%s: picture aspect (hor:vert): %u:%u\n", dev_prefix,
+			bt->picture_aspect.numerator,
+			bt->picture_aspect.denominator);
+	if (bt->flags & V4L2_DV_FL_HAS_CEA861_VIC)
+		pr_info("%s: CEA-861 VIC: %u\n", dev_prefix, bt->cea861_vic);
+	if (bt->flags & V4L2_DV_FL_HAS_HDMI_VIC)
+		pr_info("%s: HDMI VIC: %u\n", dev_prefix, bt->hdmi_vic);
 }
 EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
 
+struct v4l2_fract v4l2_dv_timings_aspect_ratio(const struct v4l2_dv_timings *t)
+{
+	struct v4l2_fract ratio = { 1, 1 };
+	unsigned long n, d;
+
+	if (t->type != V4L2_DV_BT_656_1120)
+		return ratio;
+	if (!(t->bt.flags & V4L2_DV_FL_HAS_PICTURE_ASPECT))
+		return ratio;
+
+	ratio.numerator = t->bt.width * t->bt.picture_aspect.denominator;
+	ratio.denominator = t->bt.height * t->bt.picture_aspect.numerator;
+
+	rational_best_approximation(ratio.numerator, ratio.denominator,
+				    ratio.numerator, ratio.denominator, &n, &d);
+	ratio.numerator = n;
+	ratio.denominator = d;
+	return ratio;
+}
+EXPORT_SYMBOL_GPL(v4l2_dv_timings_aspect_ratio);
+
 /*
  * CVT defines
  * Based on Coordinated Video Timings Standard
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 1113c88..c5a6a9c 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -101,6 +101,16 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 			      void *fnc_handle);
 
 /**
+ * v4l2_find_dv_timings_cea861_vic() - find timings based on CEA-861 VIC
+ * @t:		the timings data.
+ * @vic:	CEA-861 VIC code
+ *
+ * On success it will fill in @t with the found timings and it returns true.
+ * On failure it will return false.
+ */
+bool v4l2_find_dv_timings_cea861_vic(struct v4l2_dv_timings *t, u8 vic);
+
+/**
  * v4l2_match_dv_timings() - do two timings match?
  *
  * @measured:	  the measured timings data.
@@ -185,6 +195,14 @@ bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
  */
 struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
 
+/**
+ * v4l2_dv_timings_aspect_ratio - calculate the aspect ratio based on the
+ * 	v4l2_dv_timings information.
+ *
+ * @t: the timings data.
+ */
+struct v4l2_fract v4l2_dv_timings_aspect_ratio(const struct v4l2_dv_timings *t);
+
 /*
  * reduce_fps - check if conditions for reduced fps are true.
  * bt - v4l2 timing structure
-- 
2.8.1

