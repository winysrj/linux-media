Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:47229 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755402AbdCGQ6G (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 11:58:06 -0500
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] v4l2-dv-timings: Introduce v4l2_calc_fps()
Date: Tue,  7 Mar 2017 16:48:27 +0000
Message-Id: <94397052765d1f6d84dc7edac65f906b09890871.1488905139.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HDMI Receivers receive video modes which, according to
CEA specification, can have different frames per second
(fps) values.

This patch introduces a helper function in the media core
which can calculate the expected video mode fps given the
pixel clock value and the horizontal/vertical values. HDMI
video receiver drivers are expected to use this helper so
that they can correctly fill the v4l2_streamparm structure
which is requested by vidioc_g_parm callback.

We could also use a lookup table for this but it wouldn't
correctly handle 60Hz vs 59.94Hz situations as this all
depends on the pixel clock value.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 29 +++++++++++++++++++++++++++++
 include/media/v4l2-dv-timings.h           |  8 ++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 5c8c49d..19946c6 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -814,3 +814,32 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
 	return aspect;
 }
 EXPORT_SYMBOL_GPL(v4l2_calc_aspect_ratio);
+
+struct v4l2_fract v4l2_calc_fps(const struct v4l2_dv_timings *t)
+{
+	const struct v4l2_bt_timings *bt = &t->bt;
+	struct v4l2_fract fps_fract = { 1, 1 };
+	unsigned long n, d;
+	unsigned long mask = GENMASK(BITS_PER_LONG - 1, 0);
+	u32 htot, vtot, fps;
+	u64 pclk;
+
+	if (t->type != V4L2_DV_BT_656_1120)
+		return fps_fract;
+
+	htot = V4L2_DV_BT_FRAME_WIDTH(bt);
+	vtot = V4L2_DV_BT_FRAME_HEIGHT(bt);
+	pclk = bt->pixelclock;
+	if (bt->interlaced)
+		htot /= 2;
+
+	fps = (htot * vtot) > 0 ? div_u64((100 * pclk), (htot * vtot)) : 0;
+
+	rational_best_approximation(fps, 100, mask, mask, &n, &d);
+
+	fps_fract.numerator = d;
+	fps_fract.denominator = n;
+	return fps_fract;
+}
+EXPORT_SYMBOL_GPL(v4l2_calc_fps);
+
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 61a1889..d23b168 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -196,6 +196,14 @@ bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
 struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
 
 /**
+ * v4l2_calc_fps - calculate the frames per seconds based on the
+ *	v4l2_dv_timings information.
+ *
+ * @t: the timings data.
+ */
+struct v4l2_fract v4l2_calc_fps(const struct v4l2_dv_timings *t);
+
+/**
  * v4l2_dv_timings_aspect_ratio - calculate the aspect ratio based on the
  *	v4l2_dv_timings information.
  *
-- 
1.9.1
