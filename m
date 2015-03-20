Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:19564 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbbCTOVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 10:21:46 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 1/3] v4l2-ctl: Add support for CVT, GTF modeline calculation
Date: Fri, 20 Mar 2015 19:42:43 +0530
Message-Id: <1426860763-10646-1-git-send-email-prladdha@cisco.com>
In-Reply-To: <[PATCH 1/3] v4l2-ctl: Add support for CVT, GTF modeline calculation>
References: <[PATCH 1/3] v4l2-ctl: Add support for CVT, GTF modeline calculation>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for calculating v4l2_bt_timings based on
CVT and GTF standards. The timings are calculated for a given
standard, CVT or GTF using a set of parameters- width, height,
refresh rate and flags like whether it is an interlaced format,
and whether to use reduced blanking.

CVT Modeline calculation -
Implements Coordinated Video Timings (CVT) Standard Ver 1.2 Feb 08,
2013. The timing calculations are based on VESA CVT Generator Rev 1.2
by Graham Loveridge May 28, 2013.

GTF modeline calculation -
Implements Generalized Timing Formula (GTF) Standard Ver 1.1 Sept 02,
1999. The timing calculations are based on GTF timing spreadsheet by
Andy Morrish. The default GTF timings are used if flag for reduced
blanking is false, otherwise secondary GTF timings are used.

Suggested by: Hans Verkuil <hans.verkuil@cisco.com>

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/Makefile.am        |   3 +-
 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 518 ++++++++++++++++++++++++++++++++++++++
 utils/v4l2-ctl/v4l2-ctl.h         |   8 +
 3 files changed, 528 insertions(+), 1 deletion(-)
 create mode 100644 utils/v4l2-ctl/v4l2-ctl-modes.cpp

diff --git a/utils/v4l2-ctl/Makefile.am b/utils/v4l2-ctl/Makefile.am
index 29dd6cb..bc3f746 100644
--- a/utils/v4l2-ctl/Makefile.am
+++ b/utils/v4l2-ctl/Makefile.am
@@ -9,7 +9,8 @@ ivtv_ctl_LDFLAGS = -lm
 v4l2_ctl_SOURCES = v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cpp \
 	v4l2-ctl-io.cpp v4l2-ctl-stds.cpp v4l2-ctl-vidcap.cpp v4l2-ctl-vidout.cpp \
 	v4l2-ctl-overlay.cpp v4l2-ctl-vbi.cpp v4l2-ctl-selection.cpp v4l2-ctl-misc.cpp \
-	v4l2-ctl-streaming.cpp v4l2-ctl-sdr.cpp v4l2-ctl-edid.cpp vivid-tpg-colors.c vivid-tpg.c
+	v4l2-ctl-streaming.cpp v4l2-ctl-sdr.cpp v4l2-ctl-edid.cpp v4l2-ctl-modes.cpp \
+	vivid-tpg-colors.c vivid-tpg.c
 v4l2_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
 v4l2_ctl_LDFLAGS = -lrt
 
diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
new file mode 100644
index 0000000..f8a3aea
--- /dev/null
+++ b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
@@ -0,0 +1,518 @@
+/*
+ * v4l2-ctl-modes.cpp - functions to calculate cvt and gtf mode timings.
+ *
+ * Copyright 2015 Cisco Systems, Inc. and/or its affiliates. All rights
+ * reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <stdio.h>
+#include <stdbool.h>
+#include "v4l2-ctl.h"
+
+static bool valid_params(int width, int height, int refresh_rate)
+{
+	if (width <= 0) {
+		fprintf(stderr, "Invalid value %d for width\n", width);
+		return false;
+	}
+
+	if (height <= 0) {
+		fprintf(stderr, "Invalid value %d for height\n", height);
+		return false;
+	}
+
+	if (refresh_rate <= 0) {
+		fprintf(stderr, "Invalid value %d for refresh rate\n",
+				refresh_rate);
+		return false;
+	}
+	return true;
+}
+
+#define HV_FACTOR		(1000)
+#define CVT_MARGIN_PERCENT	  (18)
+#define CVT_HSYNC_PERCENT	   (8)
+
+/*
+ * CVT defines Based on
+ * Coordinated Video Timings Standard Ver 1.2 Feb 08, 2013
+ */
+
+#define CVT_PXL_CLK_GRAN    (250000)  /* pixel clock granularity */
+
+/* Normal blanking */
+#define CVT_MIN_V_BPORCH     (7)  /* lines */
+#define CVT_MIN_V_PORCH_RND  (3)  /* lines */
+#define CVT_MIN_VSYNC_BP    (550) /* time v_sync + back porch (us)*/
+
+/* Normal blanking for CVT uses GTF
+ * to calculate horizontal blanking */
+#define CVT_CELL_GRAN	(8)	  /* character cell granularity */
+#define CVT_M	      (600)	  /* blanking formula gradient */
+#define CVT_C	       (40)	  /* blanking formula offset */
+#define CVT_K	      (128)	  /* blanking formula scale factor */
+#define CVT_J	       (20)	  /* blanking formula scale factor */
+
+#define CVT_C_PRIME (((CVT_C - CVT_J) * CVT_K / 256) + CVT_J)
+#define CVT_M_PRIME (CVT_K * CVT_M / 256)
+
+/* Reduced Blanking */
+#define CVT_RB_MIN_V_BPORCH    (7)       /* lines  */
+#define CVT_RB_V_FPORCH        (3)       /* lines  */
+#define CVT_RB_MIN_V_BLANK   (460)       /* us     */
+#define CVT_RB_H_SYNC         (32)       /* pixels */
+#define CVT_RB_H_BPORCH       (80)       /* pixels */
+#define CVT_RB_H_BLANK       (160)       /* pixels */
+
+static int v_sync_from_aspect_ratio(int width, int height)
+{
+	if (((height * 4 / 3) / CVT_CELL_GRAN) * CVT_CELL_GRAN == width)
+		return 4;
+
+	if (((height * 16 / 9) / CVT_CELL_GRAN) * CVT_CELL_GRAN == width)
+		return 5;
+
+	if (((height * 16 / 10) / CVT_CELL_GRAN) * CVT_CELL_GRAN == width)
+		return 6;
+
+	if (((height * 5 / 4) / CVT_CELL_GRAN) * CVT_CELL_GRAN == width)
+		return 7;
+
+	if (((height * 15 / 9) / CVT_CELL_GRAN) * CVT_CELL_GRAN == width)
+		return 7;
+
+	/* custom aspect ratio */
+	fprintf(stderr, "Warning!  Aspect ratio is not CVT Standard\n");
+	return 10;
+}
+
+/**
+ * calc_cvt_modeline - calculate modeline based on CVT algorithm
+ *
+ * This function is called to generate the timings according to CVT
+ * algorithm. Timing calculation is based on VESA(TM) Coordinated
+ * Video Timing Generator Rev 1.2 by  Graham Loveridge May 28, 2013
+ * which can be downloaded from -
+ * http://www.vesa.org/vesa-standards/free-standards/
+ *
+ * Input Parameters:
+ * @image_width
+ * @image_height
+ * @refresh_rate
+ * @reduced_blanking: whether to use reduced blanking
+ * @interlaced: whether to compute an interlaced mode
+ * @cvt: stores results of cvt timing calculation
+ *
+ * Returns:
+ * true, if cvt timings are calculated and filled in cvt modeline.
+ * false, for any error
+ */
+
+bool calc_cvt_modeline(int image_width, int image_height,
+		       int refresh_rate, bool reduced_blanking,
+		       bool interlaced, struct v4l2_bt_timings *cvt)
+{
+	int h_sync;
+	int v_sync;
+	int h_fp;
+	int h_bp;
+	int v_fp;
+	int v_bp;
+
+	int h_pixel;
+	int v_lines;
+	int h_pixel_rnd;
+	int v_lines_rnd;
+	int active_h_pixel;
+	int active_v_lines;
+	int total_h_pixel;
+	int total_v_lines;
+
+	int h_blank;
+	int v_blank;
+
+	int h_period;
+
+	int interlace;
+	int v_refresh;
+	int pixel_clock;
+
+	if (!valid_params(image_width, image_height, refresh_rate))
+		return false;
+
+	h_pixel = image_width;
+	v_lines = image_height;
+
+	if (!refresh_rate)
+		v_refresh = 60;
+	else
+		v_refresh = refresh_rate;
+
+	if (v_refresh != 50 && v_refresh != 60 &&
+		v_refresh != 75 && v_refresh != 85)
+		fprintf(stderr, "Warning!  Refresh rate is not CVT standard\n");
+
+	if (interlaced) {
+		interlace = 1;
+		v_lines_rnd = v_lines / 2;
+		v_refresh = v_refresh * 2;
+
+		if ((v_lines_rnd * 2) != v_lines)
+			fprintf(stderr,
+			"Warning!  Vertical lines rounded to nearest integer\n");
+	} else {
+		interlace = 0;
+		v_lines_rnd = v_lines;
+	}
+
+	h_pixel_rnd = h_pixel - (h_pixel % CVT_CELL_GRAN);
+
+	if (h_pixel_rnd != h_pixel)
+		fprintf(stderr,
+		"Warning!  Horizontal pixels rounded to nearest character cell\n");
+
+	active_h_pixel = h_pixel_rnd;
+	active_v_lines = v_lines_rnd;
+
+	v_sync = v_sync_from_aspect_ratio(h_pixel, v_lines);
+
+	if (!reduced_blanking) {
+		int tmp1, tmp2;
+		int ideal_blank_duty_cycle;
+		int v_sync_bp;
+
+		/* estimate the horizontal period */
+		tmp1 = HV_FACTOR * 1000000  -
+			   CVT_MIN_VSYNC_BP * HV_FACTOR * v_refresh;
+		tmp2 = (active_v_lines + CVT_MIN_V_PORCH_RND) * 2 + interlace;
+
+		h_period = tmp1 * 2 / (tmp2 * v_refresh);
+
+		tmp1 = CVT_MIN_VSYNC_BP * HV_FACTOR / h_period + 1;
+
+		if (tmp1 < (v_sync + CVT_MIN_V_PORCH_RND))
+			v_sync_bp = v_sync + CVT_MIN_V_PORCH_RND;
+		else
+			v_sync_bp = tmp1;
+
+		v_bp = v_sync_bp - v_sync;
+		v_fp = CVT_MIN_V_PORCH_RND;
+
+		ideal_blank_duty_cycle = (CVT_C_PRIME * HV_FACTOR) -
+					  CVT_M_PRIME * h_period / 1000;
+
+		if (ideal_blank_duty_cycle < 20 * HV_FACTOR)
+			ideal_blank_duty_cycle = 20 * HV_FACTOR;
+
+		h_blank = active_h_pixel * ideal_blank_duty_cycle /
+			 (100 * HV_FACTOR - ideal_blank_duty_cycle);
+		h_blank -= h_blank % (2 * CVT_CELL_GRAN);
+
+		v_blank = v_sync_bp + CVT_MIN_V_PORCH_RND;
+
+		total_v_lines = active_v_lines + v_blank + interlace;
+		total_h_pixel = active_h_pixel + h_blank;
+
+		h_sync  = (total_h_pixel * CVT_HSYNC_PERCENT) / 100;
+		h_sync -= h_sync % CVT_CELL_GRAN;
+
+		h_bp = h_blank / 2;
+		h_fp = h_blank - h_bp - h_sync;
+
+	} else {
+		/* Reduced blanking */
+
+		int vbi_lines;
+		int tmp1, tmp2;
+
+		/* estimate horizontal period. */
+		tmp1 = HV_FACTOR * 1000000 -
+			   CVT_RB_MIN_V_BLANK * HV_FACTOR * v_refresh;
+		tmp2 = active_v_lines;
+
+		h_period = tmp1 / (tmp2 * v_refresh);
+
+		vbi_lines = CVT_RB_MIN_V_BLANK * HV_FACTOR / h_period + 1;
+
+		if (vbi_lines < (CVT_RB_V_FPORCH + v_sync + CVT_MIN_V_BPORCH))
+			vbi_lines = CVT_RB_V_FPORCH + v_sync + CVT_MIN_V_BPORCH;
+
+		total_v_lines = active_v_lines + vbi_lines;
+
+		total_h_pixel = active_h_pixel + CVT_RB_H_BLANK;
+
+		h_blank = CVT_RB_H_BLANK;
+		v_blank = vbi_lines;
+
+		h_sync = CVT_RB_H_SYNC;
+
+		h_bp = h_blank / 2;
+		h_fp = h_blank - h_bp - h_sync;
+
+		v_fp = CVT_RB_V_FPORCH;
+		v_bp = v_blank - v_fp - v_sync;
+	}
+
+	pixel_clock =  ((long long)total_h_pixel * HV_FACTOR * 1000000)
+			/ h_period;
+	pixel_clock -= pixel_clock  % CVT_PXL_CLK_GRAN;
+
+	cvt->standards 	 = V4L2_DV_BT_STD_CVT;
+
+	cvt->width       = h_pixel;
+	cvt->hfrontporch = h_fp;
+	cvt->hsync       = h_sync;
+	cvt->hbackporch  = h_bp;
+
+	cvt->height      = v_lines;
+	cvt->vfrontporch = v_fp;
+	cvt->vsync       = v_sync;
+	cvt->vbackporch  = v_bp;
+
+	cvt->pixelclock = pixel_clock;
+	cvt->interlaced = interlaced == 1 ?
+			V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
+
+	if (cvt->interlaced == V4L2_DV_INTERLACED) {
+		cvt->il_vfrontporch = v_fp;
+		cvt->il_vsync = v_sync;
+		cvt->il_vbackporch = v_bp;
+		/* Add 1 to vbackporch of even field and set the half line
+		 * flag (V4L2_DV_FL_HALF_LINE)
+		 * For interlaced format, the half line flag indicates to the
+		 * driver to add a half-line to the vfrontporch of the odd
+		 * field and subtract a half-line from the vbackporch of the
+		 * even field */
+		cvt->flags |= V4L2_DV_FL_HALF_LINE;
+		cvt->il_vbackporch += 1;
+	}
+	if (reduced_blanking) {
+		cvt->polarities = V4L2_DV_HSYNC_POS_POL;
+		cvt->flags |= V4L2_DV_FL_REDUCED_BLANKING;
+	} else
+		cvt->polarities = V4L2_DV_VSYNC_POS_POL;
+
+	return true;
+}
+
+
+/*
+ * GTF defines Based on Generalized Timing Formula Standard
+ * Version 1.1 September 2, 1999
+ */
+
+#define GTF_MARGIN_PERCENT	  (18)
+#define GTF_HSYNC_PERCENT	   (8)
+
+#define GTF_PXL_CLK_GRAN (250000) /* pixel clock granularity */
+
+#define GTF_V_SYNC_RQD	   (3) /* v sync required (lines) */
+#define GTF_MIN_VSYNC_BP (550) /* min time vsync + back porch (us) */
+#define GTF_MIN_PORCH	   (1) /* vertical front porch (lines) */
+#define GTF_CELL_GRAN      (8) /* character cell granularity */
+
+/* Default */
+#define GTF_D_M		(600)	 /* blanking formula gradient */
+#define GTF_D_C		 (40)    /* blanking formula offset */
+#define GTF_D_K		(128)	 /* blanking formula scaling factor */
+#define GTF_D_J		 (20)	 /* blanking formula scaling factor */
+#define GTF_D_C_PRIME ((((GTF_D_C - GTF_D_J) * GTF_D_K) / 256) + GTF_D_J)
+#define GTF_D_M_PRIME ((GTF_D_K * GTF_D_M) / 256)
+
+/* Secondary */
+#define GTF_S_M		 (3600)	    /* blanking formula gradient */
+#define GTF_S_C		   (40)	    /* blanking formula offset */
+#define GTF_S_K		  (128)	    /* blanking formula scaling factor */
+#define GTF_S_J		   (35)	    /* blanking formula scaling factor */
+#define GTF_S_C_PRIME ((((GTF_S_C - GTF_S_J) * GTF_S_K) / 256) + GTF_S_J)
+#define GTF_S_M_PRIME ((GTF_S_K * GTF_S_M) / 256)
+
+/**
+ * calc_gtf_modeline - calculate modeline based on GTF algorithm
+ *
+ * This function is called to generate the timings according to GTF
+ * algorithm. Timing calculation is based on VESA(TM) Generalized
+ * Timing Formula Standard Version 1.1 September 2, 1999
+ * which can be downloaded from -
+ * http://www.vesa.org/vesa-standards/free-standards/
+ *
+ * Input Parameters:
+ * @image_width
+ * @image_height
+ * @refresh_rate
+ * @reduced_blanking: whether to use reduced blanking
+ * @interlaced: whether to compute an interlaced mode
+ * @gtf: stores results of gtf timing calculation
+ *
+ * Returns:
+ * true, if gtf timings are calculated and filled in gtf modeline.
+ * false, for any error.
+ */
+
+bool calc_gtf_modeline(int image_width, int image_height,
+		       int refresh_rate, bool reduced_blanking,
+		       bool interlaced, struct v4l2_bt_timings *gtf)
+{
+	int h_sync;
+	int v_sync;
+	int h_fp;
+	int h_bp;
+	int v_fp;
+	int v_bp;
+
+	int h_pixel;
+	int v_lines;
+	int h_pixel_rnd;
+	int v_lines_rnd;
+	int active_h_pixel;
+	int active_v_lines;
+	int total_h_pixel;
+	int total_v_lines;
+
+	int h_blank;
+	int v_blank;
+
+	int h_period;
+	int h_period_est;
+
+	int interlace;
+	int v_refresh;
+	int v_refresh_est;
+	int pixel_clock;
+
+	int v_sync_bp;
+	int tmp1, tmp2;
+	int ideal_blank_duty_cycle;
+
+	if (!gtf) {
+		fprintf(stderr, "Null pointer to gtf modeline structure\n");
+		return false;
+	}
+
+	if (!valid_params(image_width, image_height, refresh_rate))
+		return false;
+
+	h_pixel = image_width;
+	v_lines = image_height;
+
+	if (!refresh_rate)
+		v_refresh = 60;
+	else
+		v_refresh = refresh_rate;
+
+	if (interlaced) {
+		interlace = 1;
+		v_lines_rnd = v_lines / 2;
+		v_refresh = v_refresh * 2;
+	} else {
+		interlace = 0;
+		v_lines_rnd = v_lines;
+	}
+
+	h_pixel_rnd = (h_pixel + GTF_CELL_GRAN / 2);
+	h_pixel_rnd -= h_pixel_rnd % GTF_CELL_GRAN;
+
+	active_h_pixel = h_pixel_rnd;
+	active_v_lines = v_lines_rnd;
+
+		/* estimate the horizontal period */
+	tmp1 = HV_FACTOR * 1000000  -
+		   GTF_MIN_VSYNC_BP * HV_FACTOR * v_refresh;
+	tmp2 = active_v_lines + GTF_MIN_PORCH + interlace;
+
+	h_period_est = tmp1 / (tmp2 * v_refresh);
+
+	v_sync_bp = GTF_MIN_VSYNC_BP * HV_FACTOR * 100 / h_period_est;
+	v_sync_bp = (v_sync_bp + 50) / 100;
+
+	v_sync = GTF_V_SYNC_RQD;
+	v_bp = v_sync_bp - v_sync;
+	v_fp = GTF_MIN_PORCH;
+
+	v_blank = v_sync + v_bp + v_fp;
+	total_v_lines = active_v_lines + v_blank + interlace;
+
+	v_refresh_est = (HV_FACTOR * (long long)1000000) /
+			(h_period_est * total_v_lines / HV_FACTOR);
+
+	h_period = (h_period_est * v_refresh_est) /
+		   (v_refresh * HV_FACTOR);
+
+	if (!reduced_blanking)
+		ideal_blank_duty_cycle = (GTF_D_C_PRIME * HV_FACTOR) -
+				      GTF_D_M_PRIME * h_period / 1000;
+	else
+		ideal_blank_duty_cycle = (GTF_S_C_PRIME * HV_FACTOR) -
+				      GTF_S_M_PRIME * h_period / 1000;
+
+
+	h_blank = active_h_pixel * ideal_blank_duty_cycle /
+			 (100 * HV_FACTOR - ideal_blank_duty_cycle);
+	h_blank -= h_blank % (2 * GTF_CELL_GRAN);
+
+	total_h_pixel = active_h_pixel + h_blank;
+
+	h_sync  = (total_h_pixel * GTF_HSYNC_PERCENT) / 100;
+	h_sync -= h_sync % GTF_CELL_GRAN;
+
+	h_fp = h_blank / 2 - h_sync;
+	h_bp = h_fp + h_sync;
+
+	pixel_clock = ((long long)total_h_pixel * HV_FACTOR * 1000000)
+					/ h_period;
+	/* Not sure if clock value needs to be truncated to multiple
+	 * of 25000. The formula given in standard does not indicate
+	 * truncation
+	 * */
+	/*pixel_clock -= pixel_clock  % GTF_PXL_CLK_GRAN;*/
+
+	gtf->standards 	 = V4L2_DV_BT_STD_GTF;
+
+	gtf->width       = h_pixel;
+	gtf->hfrontporch = h_fp;
+	gtf->hsync       = h_sync;
+	gtf->hbackporch  = h_bp;
+
+	gtf->height      = v_lines;
+	gtf->vfrontporch = v_fp;
+	gtf->vsync       = v_sync;
+	gtf->vbackporch  = v_bp;
+
+	gtf->pixelclock = pixel_clock;
+	gtf->interlaced = interlaced == 1 ?
+			V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
+
+	if (gtf->interlaced == V4L2_DV_INTERLACED) {
+		gtf->il_vfrontporch = v_fp;
+		gtf->il_vsync = v_sync;
+		gtf->il_vbackporch = v_bp;
+		/* Add 1 to vbackporch of even field and set the half line
+		 * flag (V4L2_DV_FL_HALF_LINE)
+		 * For interlaced format, the half line flag indicates to the
+		 * driver to add a half-line to the vfrontporch of the odd
+		 * field and subtract a half-line from the vbackporch of the
+		 * even field */
+		gtf->flags |= V4L2_DV_FL_HALF_LINE;
+		gtf->il_vbackporch += 1;
+	}
+	if (reduced_blanking) {
+		gtf->polarities = V4L2_DV_HSYNC_POS_POL;
+		gtf->flags |= V4L2_DV_FL_REDUCED_BLANKING;
+	} else
+		gtf->polarities = V4L2_DV_VSYNC_POS_POL;
+
+	return true;
+}
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index f8b3df2..e47612f 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -347,4 +347,12 @@ void edid_cmd(int ch, char *optarg);
 void edid_set(int fd);
 void edid_get(int fd);
 
+/* v4l2-ctl-modes.cpp */
+bool calc_cvt_modeline(int image_width, int image_height,
+		       int refresh_rate, bool reduced_blanking,
+		       bool interlaced, struct v4l2_bt_timings *cvt);
+
+bool calc_gtf_modeline(int image_width, int image_height,
+		       int refresh_rate, bool reduced_blanking,
+		       bool interlaced, struct v4l2_bt_timings *gtf);
 #endif
-- 
1.9.1

