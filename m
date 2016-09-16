Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60839 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932985AbcIPK5f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 06:57:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 8/8] v4l2-dv-timings: add v4l2_dv_timings_cea861_aspect_ratio
Date: Fri, 16 Sep 2016 12:57:11 +0200
Message-Id: <1474023431-32533-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1474023431-32533-1-git-send-email-hverkuil@xs4all.nl>
References: <1474023431-32533-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This new function determines the picture aspect ratio from the
DV timings and returns it in CEA-861 AVI InfoFrame format.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 18 ++++++++++++++++++
 include/media/v4l2-dv-timings.h           |  8 ++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 98aa2fa..43203e9 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/rational.h>
+#include <linux/hdmi.h>
 #include <linux/videodev2.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-dv-timings.h>
@@ -381,6 +382,23 @@ struct v4l2_fract v4l2_dv_timings_aspect_ratio(const struct v4l2_dv_timings *t)
 }
 EXPORT_SYMBOL_GPL(v4l2_dv_timings_aspect_ratio);
 
+u8 v4l2_dv_timings_cea861_aspect_ratio(const struct v4l2_dv_timings *t)
+{
+	unsigned int w = t->bt.width;
+	unsigned int h = t->bt.height;
+
+	if (t->bt.flags & V4L2_DV_FL_HAS_PICTURE_ASPECT) {
+		w = t->bt.picture_aspect.numerator;
+		h = t->bt.picture_aspect.denominator;
+	}
+	if (w * 3 == h * 4)
+		return HDMI_PICTURE_ASPECT_4_3;
+	if (w * 9 == h * 16)
+		return HDMI_PICTURE_ASPECT_16_9;
+	return HDMI_PICTURE_ASPECT_NONE;
+}
+EXPORT_SYMBOL_GPL(v4l2_dv_timings_cea861_aspect_ratio);
+
 /*
  * CVT defines
  * Based on Coordinated Video Timings Standard
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 3722ce8..efae7b1 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -203,6 +203,14 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
  */
 struct v4l2_fract v4l2_dv_timings_aspect_ratio(const struct v4l2_dv_timings *t);
 
+/**
+ * v4l2_dv_timings_cea861_aspect_ratio() - return CEA-861 picture aspect ratio
+ * @t:		the timings data.
+ *
+ * Returns the CEA-861 picture aspect ratio value (AVI InfoFrame bits M0+M1)
+ */
+u8 v4l2_dv_timings_cea861_aspect_ratio(const struct v4l2_dv_timings *t);
+
 /*
  * reduce_fps - check if conditions for reduced fps are true.
  * bt - v4l2 timing structure
-- 
2.8.1

