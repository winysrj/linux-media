Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:54327 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729358AbeHOQdM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:33:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Carlos Palminha <palminha@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 3/5] v4l2-dv-timings: Introduce v4l2_calc_timeperframe helper
Date: Wed, 15 Aug 2018 15:40:54 +0200
Message-Id: <20180815134056.98830-4-hverkuil@xs4all.nl>
In-Reply-To: <20180815134056.98830-1-hverkuil@xs4all.nl>
References: <20180815134056.98830-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jose Abreu <Jose.Abreu@synopsys.com>

A new helper function was introduced to facilitate the calculation
of time per frame value whenever we have access to the full
v4l2_dv_timings structure.

This should be used only for receivers and only when there is
enough accuracy in the measured pixel clock value as well as in
the horizontal/vertical values.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 39 +++++++++++++++++++++++
 include/media/v4l2-dv-timings.h           | 11 +++++++
 2 files changed, 50 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index c81faea96fba..8f52353b0881 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -373,6 +373,45 @@ struct v4l2_fract v4l2_dv_timings_aspect_ratio(const struct v4l2_dv_timings *t)
 }
 EXPORT_SYMBOL_GPL(v4l2_dv_timings_aspect_ratio);
 
+/** v4l2_calc_timeperframe - helper function to calculate timeperframe based
+ *	v4l2_dv_timings fields.
+ * @t - Timings for the video mode.
+ *
+ * Calculates the expected timeperframe using the pixel clock value and
+ * horizontal/vertical measures. This means that v4l2_dv_timings structure
+ * must be correctly and fully filled.
+ */
+struct v4l2_fract v4l2_calc_timeperframe(const struct v4l2_dv_timings *t)
+{
+	const struct v4l2_bt_timings *bt = &t->bt;
+	struct v4l2_fract fps_fract = { 1, 1 };
+	unsigned long n, d;
+	u32 htot, vtot, fps;
+	u64 pclk;
+
+	if (t->type != V4L2_DV_BT_656_1120)
+		return fps_fract;
+
+	htot = V4L2_DV_BT_FRAME_WIDTH(bt);
+	vtot = V4L2_DV_BT_FRAME_HEIGHT(bt);
+	pclk = bt->pixelclock;
+
+	if ((bt->flags & V4L2_DV_FL_CAN_DETECT_REDUCED_FPS) &&
+	    (bt->flags & V4L2_DV_FL_REDUCED_FPS))
+		pclk = div_u64(pclk * 1000ULL, 1001);
+
+	fps = (htot * vtot) > 0 ? div_u64((100 * pclk), (htot * vtot)) : 0;
+	if (!fps)
+		return fps_fract;
+
+	rational_best_approximation(fps, 100, fps, 100, &n, &d);
+
+	fps_fract.numerator = d;
+	fps_fract.denominator = n;
+	return fps_fract;
+}
+EXPORT_SYMBOL_GPL(v4l2_calc_timeperframe);
+
 /*
  * CVT defines
  * Based on Coordinated Video Timings Standard
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 17cb27df1b81..fb355d9577a4 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -10,6 +10,17 @@
 
 #include <linux/videodev2.h>
 
+/**
+ * v4l2_calc_timeperframe - helper function to calculate timeperframe based
+ *	v4l2_dv_timings fields.
+ * @t: Timings for the video mode.
+ *
+ * Calculates the expected timeperframe using the pixel clock value and
+ * horizontal/vertical measures. This means that v4l2_dv_timings structure
+ * must be correctly and fully filled.
+ */
+struct v4l2_fract v4l2_calc_timeperframe(const struct v4l2_dv_timings *t);
+
 /*
  * v4l2_dv_timings_presets: list of all dv_timings presets.
  */
-- 
2.18.0
