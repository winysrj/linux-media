Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:26755 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbbFJQvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 12:51:46 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH v2] v4l2-dv-timings: add support for reduced blanking v2
Date: Wed, 10 Jun 2015 22:21:42 +0530
Message-Id: <1433955102-7841-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1433955102-7841-1-git-send-email-prladdha@cisco.com>
References: <1433955102-7841-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added support for reduced blanking version 2 (RB v2) in cvt timings.
Standard specifies a fixed vsync pulse of 8 lines to indicate RB v2
timings. Vertical back porch is fixed at 6 lines and vertical front
porch is remainder of vertical blanking time.

For RB v2, horizontal blanking is fixed at 80 pixels. Horizontal sync
is fixed at 32. All horizontal timing counts (active pixels, front,
back porches) can be specified upto a precision of 1.

RB v2 allows for non standard aspect ratios. In RB v2 vsync does not
indicate aspect ratio. In absence of aspect ratio v4l2_detect_cvt()
cannot calculate image width from image height. Hence extending the
v4l2_detect_cvt() to pass image width in case of RB v2.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/i2c/adv7604.c                  |  2 +-
 drivers/media/i2c/adv7842.c                  |  2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c |  2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c    | 80 ++++++++++++++++++++--------
 include/media/v4l2-dv-timings.h              |  6 ++-
 5 files changed, 67 insertions(+), 25 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d290f7a..6e44549 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1320,7 +1320,7 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 		}
 	}
 
-	if (v4l2_detect_cvt(stdi->lcf + 1, hfreq, stdi->lcvs,
+	if (v4l2_detect_cvt(stdi->lcf + 1, hfreq, stdi->lcvs, 0,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
 			stdi->interlaced, timings))
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 8a7c9bd..a8be58a 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1442,7 +1442,7 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 		}
 	}
 
-	if (v4l2_detect_cvt(stdi->lcf + 1, hfreq, stdi->lcvs,
+	if (v4l2_detect_cvt(stdi->lcf + 1, hfreq, stdi->lcvs, 0,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
 			stdi->interlaced, timings))
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index c4268d1..ed0b878 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1627,7 +1627,7 @@ static bool valid_cvt_gtf_timings(struct v4l2_dv_timings *timings)
 	h_freq = (u32)bt->pixelclock / total_h_pixel;
 
 	if (bt->standards == 0 || (bt->standards & V4L2_DV_BT_STD_CVT)) {
-		if (v4l2_detect_cvt(total_v_lines, h_freq, bt->vsync,
+		if (v4l2_detect_cvt(total_v_lines, h_freq, bt->vsync, bt->width,
 				    bt->polarities, bt->interlaced, timings))
 			return true;
 	}
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 0d849fc..186f76e 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -309,6 +309,7 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
  */
 
 #define CVT_PXL_CLK_GRAN	250000	/* pixel clock granularity */
+#define CVT_PXL_CLK_GRAN_RB_V2 1000	/* granularity for reduced blanking v2*/
 
 /* Normal blanking */
 #define CVT_MIN_V_BPORCH	7	/* lines */
@@ -328,15 +329,22 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
 /* Reduced Blanking */
 #define CVT_RB_MIN_V_BPORCH    7       /* lines  */
 #define CVT_RB_V_FPORCH        3       /* lines  */
-#define CVT_RB_MIN_V_BLANK   460     /* us     */
+#define CVT_RB_MIN_V_BLANK   460       /* us     */
 #define CVT_RB_H_SYNC         32       /* pixels */
-#define CVT_RB_H_BPORCH       80       /* pixels */
 #define CVT_RB_H_BLANK       160       /* pixels */
+/* Reduce blanking Version 2 */
+#define CVT_RB_V2_H_BLANK     80       /* pixels */
+#define CVT_RB_MIN_V_FPORCH    3       /* lines  */
+#define CVT_RB_V2_MIN_V_FPORCH 1       /* lines  */
+#define CVT_RB_V_BPORCH        6       /* lines  */
 
 /** v4l2_detect_cvt - detect if the given timings follow the CVT standard
  * @frame_height - the total height of the frame (including blanking) in lines.
  * @hfreq - the horizontal frequency in Hz.
  * @vsync - the height of the vertical sync in lines.
+ * @active_width - active width of image (does not include blanking). This
+ * information is needed only in case of version 2 of reduced blanking.
+ * In other cases, this parameter does not have any effect on timings.
  * @polarities - the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
  * @interlaced - if this flag is true, it indicates interlaced format
@@ -345,20 +353,22 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
  * This function will attempt to detect if the given values correspond to a
  * valid CVT format. If so, then it will return true, and fmt will be filled
  * in with the found CVT timings.
- *
- * TODO: VESA defined a new version 2 of their reduced blanking
- * formula. Support for that is currently missing in this CVT
- * detection function.
  */
-bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
-		u32 polarities, bool interlaced, struct v4l2_dv_timings *fmt)
+bool v4l2_detect_cvt(unsigned frame_height,
+		     unsigned hfreq,
+		     unsigned vsync,
+		     unsigned active_width,
+		     u32 polarities,
+		     bool interlaced,
+		     struct v4l2_dv_timings *fmt)
 {
 	int  v_fp, v_bp, h_fp, h_bp, hsync;
 	int  frame_width, image_height, image_width;
 	bool reduced_blanking;
+	bool rb_v2 = false;
 	unsigned pix_clk;
 
-	if (vsync < 4 || vsync > 7)
+	if (vsync < 4 || vsync > 8)
 		return false;
 
 	if (polarities == V4L2_DV_VSYNC_POS_POL)
@@ -368,17 +378,35 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 	else
 		return false;
 
+	if (reduced_blanking && vsync == 8)
+		rb_v2 = true;
+
+	if (rb_v2 && active_width == 0)
+		return false;
+
+	if (!rb_v2 && vsync > 7)
+		return false;
+
 	if (hfreq == 0)
 		return false;
 
 	/* Vertical */
 	if (reduced_blanking) {
-		v_fp = CVT_RB_V_FPORCH;
-		v_bp = (CVT_RB_MIN_V_BLANK * hfreq) / 1000000 + 1;
-		v_bp -= vsync + v_fp;
-
-		if (v_bp < CVT_RB_MIN_V_BPORCH)
-			v_bp = CVT_RB_MIN_V_BPORCH;
+		if (rb_v2) {
+			v_bp = CVT_RB_V_BPORCH;
+			v_fp = (CVT_RB_MIN_V_BLANK * hfreq) / 1000000 + 1;
+			v_fp -= vsync + v_bp;
+
+			if (v_fp < CVT_RB_V2_MIN_V_FPORCH)
+				v_fp = CVT_RB_V2_MIN_V_FPORCH;
+		} else {
+			v_fp = CVT_RB_V_FPORCH;
+			v_bp = (CVT_RB_MIN_V_BLANK * hfreq) / 1000000 + 1;
+			v_bp -= vsync + v_fp;
+
+			if (v_bp < CVT_RB_MIN_V_BPORCH)
+				v_bp = CVT_RB_MIN_V_BPORCH;
+		}
 	} else {
 		v_fp = CVT_MIN_V_PORCH_RND;
 		v_bp = (CVT_MIN_VSYNC_BP * hfreq) / 1000000 + 1 - vsync;
@@ -415,22 +443,32 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 		else
 			return false;
 		break;
+	case 8:
+		image_width = active_width;
+		break;
 	default:
 		return false;
 	}
 
-	image_width = image_width & ~7;
+	if (!rb_v2)
+		image_width = image_width & ~7;
 
 	/* Horizontal */
 	if (reduced_blanking) {
-		pix_clk = (image_width + CVT_RB_H_BLANK) * hfreq;
-		pix_clk = (pix_clk / CVT_PXL_CLK_GRAN) * CVT_PXL_CLK_GRAN;
+		int h_blank;
+		int clk_gran;
+
+		h_blank = rb_v2 ? CVT_RB_V2_H_BLANK : CVT_RB_H_BLANK;
+		clk_gran = rb_v2 ? CVT_PXL_CLK_GRAN_RB_V2 : CVT_PXL_CLK_GRAN;
 
-		h_bp = CVT_RB_H_BPORCH;
+		pix_clk = (image_width + h_blank) * hfreq;
+		pix_clk = (pix_clk / clk_gran) * clk_gran;
+
+		h_bp  = h_blank / 2;
 		hsync = CVT_RB_H_SYNC;
-		h_fp = CVT_RB_H_BLANK - h_bp - hsync;
+		h_fp  = h_blank - h_bp - hsync;
 
-		frame_width = image_width + CVT_RB_H_BLANK;
+		frame_width = image_width + h_blank;
 	} else {
 		unsigned ideal_duty_cycle_per_myriad =
 			100 * CVT_C_PRIME - (CVT_M_PRIME * 100000) / hfreq;
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index eecd310..e18a653 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -115,6 +115,9 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
  * @frame_height - the total height of the frame (including blanking) in lines.
  * @hfreq - the horizontal frequency in Hz.
  * @vsync - the height of the vertical sync in lines.
+ * @active_width - active width of image (does not include blanking). This
+ * information is needed only in case of version 2 of reduced blanking.
+ * In other cases, this parameter does not have any effect on timings.
  * @polarities - the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
  * @interlaced - if this flag is true, it indicates interlaced format
@@ -125,7 +128,8 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
  * in with the found CVT timings.
  */
 bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
-		u32 polarities, bool interlaced, struct v4l2_dv_timings *fmt);
+		unsigned active_width, u32 polarities, bool interlaced,
+		struct v4l2_dv_timings *fmt);
 
 /** v4l2_detect_gtf - detect if the given timings follow the GTF standard
  * @frame_height - the total height of the frame (including blanking) in lines.
-- 
1.9.1

