Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:8323 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbFEIwm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 04:52:42 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH] v4l2-dv-timings: add support for reduced blanking v2
Date: Fri,  5 Jun 2015 14:22:38 +0530
Message-Id: <1433494358-29050-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1433494358-29050-1-git-send-email-prladdha@cisco.com>
References: <1433494358-29050-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added support for reduced blanking version 2 (RB v2) in cvt timings.
Standard specifies a fixed vsync pulse of 8 lines to indicate RB v2
timings. Vertical back porch is fixed at 6 lines and vertical front
porch is remainder of vertical blanking time.

For Rb v2, horizontal blanking is fixed at 80 pixels. Horizontal sync
is fixed at 32. All horizontal timing counts (active pixels, front,
back porches) can be specified upto a precision of 1.

To Do: Pass aspect ratio information to v4l2_detect_cvt()
RB v2 allows for non standard aspect ratios. In RB v2 vsync does not
indicate aspect ratio. In the absence of aspect ratio information,
v4l2_detect_cvt() cannot calculate image width from image height.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 72 +++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 18 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 0d849fc..4efc6f6 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -309,6 +309,7 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
  */
 
 #define CVT_PXL_CLK_GRAN	250000	/* pixel clock granularity */
+#define CVT_PXL_CLK_GRAN_RB_V2 1000	/* granularity for reduced blanking v2*/
 
 /* Normal blanking */
 #define CVT_MIN_V_BPORCH	7	/* lines */
@@ -328,10 +329,14 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
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
@@ -356,9 +361,10 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 	int  v_fp, v_bp, h_fp, h_bp, hsync;
 	int  frame_width, image_height, image_width;
 	bool reduced_blanking;
+	bool rb_v2 = false;
 	unsigned pix_clk;
 
-	if (vsync < 4 || vsync > 7)
+	if (vsync < 4 || vsync > 8)
 		return false;
 
 	if (polarities == V4L2_DV_VSYNC_POS_POL)
@@ -368,17 +374,32 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 	else
 		return false;
 
+	if (reduced_blanking && vsync == 8)
+		rb_v2 = true;
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
@@ -415,22 +436,40 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 		else
 			return false;
 		break;
+	case 8:
+	/* To Do:
+	 * For Reduced Blanking v2, vsync does not indicate aspect ratio and
+	 * hence can not be used to derive image width. In such a case, either
+	 * aspect ratio information or image width should be supplied to
+	 * v4l2_detect_cvt(). This would need API change. As of now assuming
+	 * 16:9 as default aspect ratio.
+	 * */
+		image_width = (image_height * 16) / 9;
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
 
-		h_bp = CVT_RB_H_BPORCH;
+		if (rb_v2)
+			h_blank = CVT_RB_V2_H_BLANK;
+		else
+			h_blank = CVT_RB_H_BLANK;
+
+		pix_clk = (image_width + h_blank) * hfreq;
+		pix_clk = (pix_clk / CVT_PXL_CLK_GRAN_RB_V2) * CVT_PXL_CLK_GRAN_RB_V2;
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
@@ -438,11 +477,9 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 
 		if (ideal_duty_cycle_per_myriad < 2000)
 			ideal_duty_cycle_per_myriad = 2000;
-
 		h_blank = image_width * ideal_duty_cycle_per_myriad /
 					(10000 - ideal_duty_cycle_per_myriad);
 		h_blank = (h_blank / (2 * CVT_CELL_GRAN)) * 2 * CVT_CELL_GRAN;
-
 		pix_clk = (image_width + h_blank) * hfreq;
 		pix_clk = (pix_clk / CVT_PXL_CLK_GRAN) * CVT_PXL_CLK_GRAN;
 
@@ -483,7 +520,6 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 
 	if (reduced_blanking)
 		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
-
 	return true;
 }
 EXPORT_SYMBOL_GPL(v4l2_detect_cvt);
-- 
1.9.1

