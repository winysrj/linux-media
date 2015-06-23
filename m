Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:34611 "EHLO
	bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbbFWF4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 01:56:16 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH v2 1/2] v4l2-ctl-modes: add support for reduced blanking version 2
Date: Tue, 23 Jun 2015 11:26:12 +0530
Message-Id: <1435038973-2076-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1435038973-2076-1-git-send-email-prladdha@cisco.com>
References: <1435038973-2076-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added support for reduced blanking version 2 (RB V2) in cvt
modeline calculations. Recently, RB V2 support was added to
v4l2-dv-timings. This patch follows up on that work.

Modified calc_cvt/gtf_modeline() api to capture the version of
reduced blanking. Instead of using a flag for reduced-blanking,
it now allows for passing a value to indicate version info.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 63 +++++++++++++++++++++++++++++----------
 utils/v4l2-ctl/v4l2-ctl-stds.cpp  | 12 +++-----
 utils/v4l2-ctl/v4l2-ctl.h         |  4 +--
 3 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
index 7768998..88f7b6a 100644
--- a/utils/v4l2-ctl/v4l2-ctl-modes.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
@@ -52,6 +52,7 @@ static bool valid_params(int width, int height, int refresh_rate)
  */
 
 #define CVT_PXL_CLK_GRAN    (250000)  /* pixel clock granularity */
+#define CVT_PXL_CLK_GRAN_RB_V2 (1000)	/* granularity for reduced blanking v2*/
 
 /* Normal blanking */
 #define CVT_MIN_V_BPORCH     (7)  /* lines */
@@ -77,6 +78,12 @@ static bool valid_params(int width, int height, int refresh_rate)
 #define CVT_RB_H_BPORCH       (80)       /* pixels */
 #define CVT_RB_H_BLANK       (160)       /* pixels */
 
+/* Reduce blanking Version 2 */
+#define CVT_RB_V2_H_BLANK     80       /* pixels */
+#define CVT_RB_MIN_V_FPORCH    3       /* lines  */
+#define CVT_RB_V2_MIN_V_FPORCH 1       /* lines  */
+#define CVT_RB_V_BPORCH        6       /* lines  */
+
 static int v_sync_from_aspect_ratio(int width, int height)
 {
 	if (((height * 4 / 3) / CVT_CELL_GRAN) * CVT_CELL_GRAN == width)
@@ -112,7 +119,8 @@ static int v_sync_from_aspect_ratio(int width, int height)
  * @image_width
  * @image_height
  * @refresh_rate
- * @reduced_blanking: whether to use reduced blanking
+ * @reduced_blanking: This value, if greater than 0, indicates that
+ * reduced blanking is to be used and value indicates the version.
  * @interlaced: whether to compute an interlaced mode
  * @cvt: stores results of cvt timing calculation
  *
@@ -122,7 +130,7 @@ static int v_sync_from_aspect_ratio(int width, int height)
  */
 
 bool calc_cvt_modeline(int image_width, int image_height,
-		       int refresh_rate, bool reduced_blanking,
+		       int refresh_rate, int reduced_blanking,
 		       bool interlaced, struct v4l2_bt_timings *cvt)
 {
 	int h_sync;
@@ -149,10 +157,18 @@ bool calc_cvt_modeline(int image_width, int image_height,
 	int interlace;
 	int v_refresh;
 	int pixel_clock;
+	int clk_gran;
+	bool use_rb = false;
+	bool rb_v2 = false;
 
 	if (!valid_params(image_width, image_height, refresh_rate))
 		return false;
 
+	use_rb = (reduced_blanking > 0) ? true : false;
+	rb_v2 = (reduced_blanking == 2) ? true : false;
+
+	clk_gran = rb_v2 ? CVT_PXL_CLK_GRAN_RB_V2 : CVT_PXL_CLK_GRAN;
+
 	h_pixel = image_width;
 	v_lines = image_height;
 
@@ -187,9 +203,9 @@ bool calc_cvt_modeline(int image_width, int image_height,
 	active_h_pixel = h_pixel_rnd;
 	active_v_lines = v_lines_rnd;
 
-	v_sync = v_sync_from_aspect_ratio(h_pixel, v_lines);
+	v_sync = rb_v2 ? 8 : v_sync_from_aspect_ratio(h_pixel, v_lines);
 
-	if (!reduced_blanking) {
+	if (!use_rb) {
 		int tmp1, tmp2;
 		int ideal_blank_duty_cycle;
 		int v_sync_bp;
@@ -233,12 +249,13 @@ bool calc_cvt_modeline(int image_width, int image_height,
 
 		pixel_clock =  ((long long)total_h_pixel * HV_FACTOR * 1000000)
 				/ h_period;
-		pixel_clock -= pixel_clock  % CVT_PXL_CLK_GRAN;
+		pixel_clock -= pixel_clock  % clk_gran;
 	} else {
 		/* Reduced blanking */
 
 		int vbi_lines;
 		int tmp1, tmp2;
+		int min_vbi_lines;
 
 		/* estimate horizontal period. */
 		tmp1 = HV_FACTOR * 1000000 -
@@ -249,10 +266,15 @@ bool calc_cvt_modeline(int image_width, int image_height,
 
 		vbi_lines = CVT_RB_MIN_V_BLANK * HV_FACTOR / h_period + 1;
 
-		if (vbi_lines < (CVT_RB_V_FPORCH + v_sync + CVT_MIN_V_BPORCH))
-			vbi_lines = CVT_RB_V_FPORCH + v_sync + CVT_MIN_V_BPORCH;
+		if (rb_v2)
+			min_vbi_lines = CVT_RB_V2_MIN_V_FPORCH + v_sync + CVT_RB_V_BPORCH;
+		else
+			min_vbi_lines = CVT_RB_V_FPORCH + v_sync + CVT_MIN_V_BPORCH;
+
+		if (vbi_lines < min_vbi_lines)
+			vbi_lines = min_vbi_lines;
 
-		h_blank = CVT_RB_H_BLANK;
+		h_blank = rb_v2 ? CVT_RB_V2_H_BLANK : CVT_RB_H_BLANK;
 		v_blank = vbi_lines;
 
 		total_h_pixel = active_h_pixel + h_blank;
@@ -263,12 +285,17 @@ bool calc_cvt_modeline(int image_width, int image_height,
 		h_bp = h_blank / 2;
 		h_fp = h_blank - h_bp - h_sync;
 
-		v_fp = CVT_RB_V_FPORCH;
-		v_bp = v_blank - v_fp - v_sync;
+		if (rb_v2) {
+			v_bp = CVT_RB_V_BPORCH;
+			v_fp = v_blank - v_bp - v_sync;
+		} else {
+			v_fp = CVT_RB_V_FPORCH;
+			v_bp = v_blank - v_fp - v_sync;
+		}
 
 		pixel_clock = v_refresh * total_h_pixel *
 			      (2 * total_v_lines + interlace) / 2;
-		pixel_clock -= pixel_clock  % CVT_PXL_CLK_GRAN;
+		pixel_clock -= pixel_clock  % clk_gran;
 	}
 
 	cvt->standards 	 = V4L2_DV_BT_STD_CVT;
@@ -300,7 +327,7 @@ bool calc_cvt_modeline(int image_width, int image_height,
 		cvt->flags |= V4L2_DV_FL_HALF_LINE;
 		cvt->il_vbackporch += 1;
 	}
-	if (reduced_blanking) {
+	if (use_rb) {
 		cvt->polarities = V4L2_DV_HSYNC_POS_POL;
 		cvt->flags |= V4L2_DV_FL_REDUCED_BLANKING;
 	} else
@@ -354,7 +381,8 @@ bool calc_cvt_modeline(int image_width, int image_height,
  * @image_width
  * @image_height
  * @refresh_rate
- * @reduced_blanking: whether to use reduced blanking
+ * @reduced_blanking: This value, if greater than 0, indicates that
+ * reduced blanking is to be used.
  * @interlaced: whether to compute an interlaced mode
  * @gtf: stores results of gtf timing calculation
  *
@@ -364,7 +392,7 @@ bool calc_cvt_modeline(int image_width, int image_height,
  */
 
 bool calc_gtf_modeline(int image_width, int image_height,
-		       int refresh_rate, bool reduced_blanking,
+		       int refresh_rate, int reduced_blanking,
 		       bool interlaced, struct v4l2_bt_timings *gtf)
 {
 	int h_sync;
@@ -397,6 +425,7 @@ bool calc_gtf_modeline(int image_width, int image_height,
 	int v_sync_bp;
 	int tmp1, tmp2;
 	int ideal_blank_duty_cycle;
+	bool use_rb = false;
 
 	if (!gtf) {
 		fprintf(stderr, "Null pointer to gtf modeline structure\n");
@@ -406,6 +435,8 @@ bool calc_gtf_modeline(int image_width, int image_height,
 	if (!valid_params(image_width, image_height, refresh_rate))
 		return false;
 
+	use_rb = (reduced_blanking > 0) ? true : false;
+
 	h_pixel = image_width;
 	v_lines = image_height;
 
@@ -452,7 +483,7 @@ bool calc_gtf_modeline(int image_width, int image_height,
 	h_period = ((long long)h_period_est * v_refresh_est) /
 		   (v_refresh * HV_FACTOR);
 
-	if (!reduced_blanking)
+	if (!use_rb)
 		ideal_blank_duty_cycle = (GTF_D_C_PRIME * HV_FACTOR) -
 				      GTF_D_M_PRIME * h_period / 1000;
 	else
@@ -507,7 +538,7 @@ bool calc_gtf_modeline(int image_width, int image_height,
 		gtf->flags |= V4L2_DV_FL_HALF_LINE;
 		gtf->il_vbackporch += 1;
 	}
-	if (reduced_blanking) {
+	if (use_rb) {
 		gtf->polarities = V4L2_DV_HSYNC_POS_POL;
 		gtf->flags |= V4L2_DV_FL_REDUCED_BLANKING;
 	} else
diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
index e725fa8..3e54ff6 100644
--- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
@@ -237,15 +237,11 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 	}
 
 	if (standard == V4L2_DV_BT_STD_CVT) {
-		timings_valid = calc_cvt_modeline(width, height, fps,
-			              r_blank == 1 ? true : false,
-			              interlaced == 1 ? true : false,
-			              bt);
+		timings_valid = calc_cvt_modeline(width, height, fps, r_blank,
+						  interlaced == 1 ? true : false, bt);
 	} else {
-		timings_valid = calc_gtf_modeline(width, height, fps,
-			              r_blank == 1 ? true : false,
-			              interlaced == 1 ? true : false,
-			              bt);
+		timings_valid = calc_gtf_modeline(width, height, fps, r_blank,
+						  interlaced == 1 ? true : false, bt);
 	}
 
 	if (!timings_valid) {
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index efb5eb3..de65900 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -350,10 +350,10 @@ void edid_get(int fd);
 
 /* v4l2-ctl-modes.cpp */
 bool calc_cvt_modeline(int image_width, int image_height,
-		       int refresh_rate, bool reduced_blanking,
+		       int refresh_rate, int reduced_blanking,
 		       bool interlaced, struct v4l2_bt_timings *cvt);
 
 bool calc_gtf_modeline(int image_width, int image_height,
-		       int refresh_rate, bool reduced_blanking,
+		       int refresh_rate, int reduced_blanking,
 		       bool interlaced, struct v4l2_bt_timings *gtf);
 #endif
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
