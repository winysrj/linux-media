Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:47622 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757054AbdCULuA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 07:50:00 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] [media] v4l2-dv-timings: Introduce v4l2_calc_timeperframe helper
Date: Tue, 21 Mar 2017 11:49:17 +0000
Message-Id: <3d66ef1c377e68c208443b2aa11600e97b4ac50f.1490095965.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490095965.git.joabreu@synopsys.com>
References: <cover.1490095965.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490095965.git.joabreu@synopsys.com>
References: <cover.1490095965.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A new helper function was introduced to facilitate the calculation
of time per frame value whenever we have access to the full
v4l2_dv_timings structure.

This should be used only for receivers and only when there is
enough accuracy in the measured pixel clock value as well as in
the horizontal/vertical values.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 39 +++++++++++++++++++++++++++++++
 include/media/v4l2-dv-timings.h           | 11 +++++++++
 2 files changed, 50 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 5c8c49d..b7b39c2 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -814,3 +814,42 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
 	return aspect;
 }
 EXPORT_SYMBOL_GPL(v4l2_calc_aspect_ratio);
+
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
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 61a1889..c1eef08 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -203,6 +203,17 @@ bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
  */
 struct v4l2_fract v4l2_dv_timings_aspect_ratio(const struct v4l2_dv_timings *t);
 
+/**
+ * v4l2_calc_timeperframe - helper function to calculate timeperframe based
+ *	v4l2_dv_timings fields.
+ * @t - Timings for the video mode.
+ *
+ * Calculates the expected timeperframe using the pixel clock value and
+ * horizontal/vertical measures. This means that v4l2_dv_timings structure
+ * must be correctly and fully filled.
+ */
+struct v4l2_fract v4l2_calc_timeperframe(const struct v4l2_dv_timings *t);
+
 /*
  * reduce_fps - check if conditions for reduced fps are true.
  * bt - v4l2 timing structure
-- 
1.9.1
