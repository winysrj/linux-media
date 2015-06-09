Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:34791 "EHLO
	bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbbFIRRD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2015 13:17:03 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH] v4l2-ctl-modes: add support for reduced blanking v2
Date: Tue,  9 Jun 2015 22:46:58 +0530
Message-Id: <1433870218-18107-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, if reduced blanking flag is set to true, cvt timings are
calculated for reduced blanking version 2.

To Do: extend the cvt options to inlcude rb v2.

Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 40 +++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
index 7422bc5..cfe4086 100644
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
@@ -148,6 +155,11 @@ bool calc_cvt_modeline(int image_width, int image_height,
 	int interlace;
 	int v_refresh;
 	int pixel_clock;
+	int clk_gran;
+	bool rb_v2 = false;
+
+	rb_v2 = reduced_blanking ? true : false;
+	clk_gran = rb_v2 ? CVT_PXL_CLK_GRAN_RB_V2 : CVT_PXL_CLK_GRAN;
 
 	if (!valid_params(image_width, image_height, refresh_rate))
 		return false;
@@ -186,7 +198,7 @@ bool calc_cvt_modeline(int image_width, int image_height,
 	active_h_pixel = h_pixel_rnd;
 	active_v_lines = v_lines_rnd;
 
-	v_sync = v_sync_from_aspect_ratio(h_pixel, v_lines);
+	v_sync = rb_v2 ? 8 : v_sync_from_aspect_ratio(h_pixel, v_lines);
 
 	if (!reduced_blanking) {
 		int tmp1, tmp2;
@@ -235,6 +247,8 @@ bool calc_cvt_modeline(int image_width, int image_height,
 
 		int vbi_lines;
 		int tmp1, tmp2;
+		int min_vbi_lines;
+		int h_blank;
 
 		/* estimate horizontal period. */
 		tmp1 = HV_FACTOR * 1000000 -
@@ -245,26 +259,36 @@ bool calc_cvt_modeline(int image_width, int image_height,
 
 		vbi_lines = CVT_RB_MIN_V_BLANK * HV_FACTOR / h_period + 1;
 
-		if (vbi_lines < (CVT_RB_V_FPORCH + v_sync + CVT_MIN_V_BPORCH))
-			vbi_lines = CVT_RB_V_FPORCH + v_sync + CVT_MIN_V_BPORCH;
+		if (rb_v2)
+			min_vbi_lines = CVT_RB_V2_MIN_V_FPORCH + v_sync + CVT_RB_V_BPORCH;
+		else
+			min_vbi_lines = CVT_RB_V_FPORCH + v_sync + CVT_MIN_V_BPORCH;
 
-		total_h_pixel = active_h_pixel + CVT_RB_H_BLANK;
+		if (vbi_lines < min_vbi_lines)
+			vbi_lines = min_vbi_lines;
 
-		h_blank = CVT_RB_H_BLANK;
+		h_blank = rb_v2 ? CVT_RB_V2_H_BLANK : CVT_RB_H_BLANK;
 		v_blank = vbi_lines;
 
+		total_h_pixel = active_h_pixel + h_blank;
+
 		h_sync = CVT_RB_H_SYNC;
 
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
 	}
 
 	pixel_clock =  ((long long)total_h_pixel * HV_FACTOR * 1000000)
 			/ h_period;
-	pixel_clock -= pixel_clock  % CVT_PXL_CLK_GRAN;
+	pixel_clock -= pixel_clock  % clk_gran;
 
 	cvt->standards 	 = V4L2_DV_BT_STD_CVT;
 
-- 
1.9.1

