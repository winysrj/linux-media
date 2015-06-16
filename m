Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:43385 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221AbbFPJhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 05:37:38 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH 1/2] v4l2-ctl-modes: add support for reduced blanking version 2
Date: Tue, 16 Jun 2015 15:00:30 +0530
Message-Id: <1434447031-21434-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1434447031-21434-1-git-send-email-prladdha@cisco.com>
References: <1434447031-21434-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added support for reduced blanking version 2 (RB V2) in cvt
modeline calculations. Recently, RB V2 support was added to
v4l2-dv-timings. This patch follows up on that work.

Extended calc_cvt_modeline() api to pass an additional flag to
indicate the version of reduced blanking. This flag takes effect
only when reduced blanking is set to true. By default, timings
are calculated for reduced blanking version 1.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 44 +++++++++++++++++++++++++++++++--------
 utils/v4l2-ctl/v4l2-ctl-stds.cpp  |  2 +-
 utils/v4l2-ctl/v4l2-ctl.h         |  3 ++-
 3 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
index 7768998..b008f06 100644
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
@@ -113,6 +120,7 @@ static int v_sync_from_aspect_ratio(int width, int height)
  * @image_height
  * @refresh_rate
  * @reduced_blanking: whether to use reduced blanking
+ * @use_rb_v2: whether to use reduced blanking version 2
  * @interlaced: whether to compute an interlaced mode
  * @cvt: stores results of cvt timing calculation
  *
@@ -123,7 +131,8 @@ static int v_sync_from_aspect_ratio(int width, int height)
 
 bool calc_cvt_modeline(int image_width, int image_height,
 		       int refresh_rate, bool reduced_blanking,
-		       bool interlaced, struct v4l2_bt_timings *cvt)
+		       bool interlaced, bool use_rb_v2,
+		       struct v4l2_bt_timings *cvt)
 {
 	int h_sync;
 	int v_sync;
@@ -149,6 +158,12 @@ bool calc_cvt_modeline(int image_width, int image_height,
 	int interlace;
 	int v_refresh;
 	int pixel_clock;
+	int clk_gran;
+	bool rb_v2 = false;
+
+	rb_v2 = (reduced_blanking && use_rb_v2) ? true : false;
+
+	clk_gran = rb_v2 ? CVT_PXL_CLK_GRAN_RB_V2 : CVT_PXL_CLK_GRAN;
 
 	if (!valid_params(image_width, image_height, refresh_rate))
 		return false;
@@ -187,7 +202,7 @@ bool calc_cvt_modeline(int image_width, int image_height,
 	active_h_pixel = h_pixel_rnd;
 	active_v_lines = v_lines_rnd;
 
-	v_sync = v_sync_from_aspect_ratio(h_pixel, v_lines);
+	v_sync = rb_v2 ? 8 : v_sync_from_aspect_ratio(h_pixel, v_lines);
 
 	if (!reduced_blanking) {
 		int tmp1, tmp2;
@@ -233,12 +248,13 @@ bool calc_cvt_modeline(int image_width, int image_height,
 
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
@@ -249,10 +265,15 @@ bool calc_cvt_modeline(int image_width, int image_height,
 
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
@@ -263,12 +284,17 @@ bool calc_cvt_modeline(int image_width, int image_height,
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
diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
index e725fa8..c0e919b 100644
--- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
@@ -240,7 +240,7 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 		timings_valid = calc_cvt_modeline(width, height, fps,
 			              r_blank == 1 ? true : false,
 			              interlaced == 1 ? true : false,
-			              bt);
+			              false, bt);
 	} else {
 		timings_valid = calc_gtf_modeline(width, height, fps,
 			              r_blank == 1 ? true : false,
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index efb5eb3..8bf1610 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -351,7 +351,8 @@ void edid_get(int fd);
 /* v4l2-ctl-modes.cpp */
 bool calc_cvt_modeline(int image_width, int image_height,
 		       int refresh_rate, bool reduced_blanking,
-		       bool interlaced, struct v4l2_bt_timings *cvt);
+		       bool interlaced, bool use_rb_v2,
+		       struct v4l2_bt_timings *cvt);
 
 bool calc_gtf_modeline(int image_width, int image_height,
 		       int refresh_rate, bool reduced_blanking,
-- 
1.9.1

