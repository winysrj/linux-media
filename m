Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:50404 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2GRJHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 05:07:00 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, device-drivers-devel@blackfin.uclinux.org
Subject: [RFCv2 PATCH 5/7] v4l2-common: add CVT and GTF detection functions.
Date: Wed, 18 Jul 2012 11:06:18 +0200
Message-Id: <7fc1f7c19797e21849aa64be5c9bb88ed460fd98.1342601681.git.hans.verkuil@cisco.com>
In-Reply-To: <1342602380-5854-1-git-send-email-hans.verkuil@cisco.com>
References: <1342602380-5854-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <c9c25dde447e731e6f0925bd175550196c5612e0.1342601681.git.hans.verkuil@cisco.com>
References: <c9c25dde447e731e6f0925bd175550196c5612e0.1342601681.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two helper functions detect whether the analog video timings detected
by the video receiver match the VESA CVT or GTF standards.

They basically do the inverse of the CVT and GTF modeline calculations.

This patch also adds a helper function that will determine the aspect ratio
based on the provided EDID values. This aspect ratio can be given to the GTF
helper function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-common.c |  358 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-common.h       |   13 ++
 2 files changed, 371 insertions(+)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 1baec83..33e57d8 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -597,6 +597,364 @@ int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
 }
 EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
 
+/**
+ * v4l_match_dv_timings - check if two timings match
+ * @t1 - compare this v4l2_dv_timings struct...
+ * @t2 - with this struct.
+ * @pclock_delta - the allowed pixelclock deviation.
+ *
+ * Compare t1 with t2 with a given margin of error for the pixelclock.
+ */
+bool v4l_match_dv_timings(const struct v4l2_dv_timings *t1,
+			  const struct v4l2_dv_timings *t2,
+			  unsigned pclock_delta)
+{
+	if (t1->type != t2->type || t1->type != V4L2_DV_BT_656_1120)
+		return false;
+	if (t1->bt.width == t2->bt.width &&
+	    t1->bt.height == t2->bt.height &&
+	    t1->bt.interlaced == t2->bt.interlaced &&
+	    t1->bt.polarities == t2->bt.polarities &&
+	    t1->bt.pixelclock >= t2->bt.pixelclock - pclock_delta &&
+	    t1->bt.pixelclock <= t2->bt.pixelclock + pclock_delta &&
+	    t1->bt.hfrontporch == t2->bt.hfrontporch &&
+	    t1->bt.vfrontporch == t2->bt.vfrontporch &&
+	    t1->bt.vsync == t2->bt.vsync &&
+	    t1->bt.vbackporch == t2->bt.vbackporch &&
+	    (!t1->bt.interlaced ||
+		(t1->bt.il_vfrontporch == t2->bt.il_vfrontporch &&
+		 t1->bt.il_vsync == t2->bt.il_vsync &&
+		 t1->bt.il_vbackporch == t2->bt.il_vbackporch)))
+		return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(v4l_match_dv_timings);
+
+/*
+ * CVT defines
+ * Based on Coordinated Video Timings Standard
+ * version 1.1 September 10, 2003
+ */
+
+#define CVT_PXL_CLK_GRAN	250000	/* pixel clock granularity */
+
+/* Normal blanking */
+#define CVT_MIN_V_BPORCH	7	/* lines */
+#define CVT_MIN_V_PORCH_RND	3	/* lines */
+#define CVT_MIN_VSYNC_BP	550	/* min time of vsync + back porch (us) */
+
+/* Normal blanking for CVT uses GTF to calculate horizontal blanking */
+#define CVT_CELL_GRAN		8	/* character cell granularity */
+#define CVT_M			600	/* blanking formula gradient */
+#define CVT_C			40	/* blanking formula offset */
+#define CVT_K			128	/* blanking formula scaling factor */
+#define CVT_J			20	/* blanking formula scaling factor */
+#define CVT_C_PRIME (((CVT_C - CVT_J) * CVT_K / 256) + CVT_J)
+#define CVT_M_PRIME (CVT_K * CVT_M / 256)
+
+/* Reduced Blanking */
+#define CVT_RB_MIN_V_BPORCH    7       /* lines  */
+#define CVT_RB_V_FPORCH        3       /* lines  */
+#define CVT_RB_MIN_V_BLANK   460     /* us     */
+#define CVT_RB_H_SYNC         32       /* pixels */
+#define CVT_RB_H_BPORCH       80       /* pixels */
+#define CVT_RB_H_BLANK       160       /* pixels */
+
+/** v4l2_detect_cvt - detect if the given timings follow the CVT standard
+ * @frame_height - the total height of the frame (including blanking) in lines.
+ * @hfreq - the horizontal frequency in Hz.
+ * @vsync - the height of the vertical sync in lines.
+ * @polarities - the horizontal and vertical polarities (same as struct
+ *		v4l2_bt_timings polarities).
+ * @fmt - the resulting timings.
+ *
+ * This function will attempt to detect if the given values correspond to a
+ * valid CVT format. If so, then it will return true, and fmt will be filled
+ * in with the found CVT timings.
+ */
+bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
+		u32 polarities, struct v4l2_dv_timings *fmt)
+{
+	int  v_fp, v_bp, h_fp, h_bp, hsync;
+	int  frame_width, image_height, image_width;
+	bool reduced_blanking;
+	unsigned pix_clk;
+
+	if (vsync < 4 || vsync > 7)
+		return false;
+
+	if (polarities == V4L2_DV_VSYNC_POS_POL)
+		reduced_blanking = false;
+	else if (polarities == V4L2_DV_HSYNC_POS_POL)
+		reduced_blanking = true;
+	else
+		return false;
+
+	/* Vertical */
+	if (reduced_blanking) {
+		v_fp = CVT_RB_V_FPORCH;
+		v_bp = (CVT_RB_MIN_V_BLANK * hfreq + 999999) / 1000000;
+		v_bp -= vsync + v_fp;
+
+		if (v_bp < CVT_RB_MIN_V_BPORCH)
+			v_bp = CVT_RB_MIN_V_BPORCH;
+	} else {
+		v_fp = CVT_MIN_V_PORCH_RND;
+		v_bp = (CVT_MIN_VSYNC_BP * hfreq + 999999) / 1000000 - vsync;
+
+		if (v_bp < CVT_MIN_V_BPORCH)
+			v_bp = CVT_MIN_V_BPORCH;
+	}
+	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
+
+	/* Aspect ratio based on vsync */
+	switch (vsync) {
+	case 4:
+		image_width = (image_height * 4) / 3;
+		break;
+	case 5:
+		image_width = (image_height * 16) / 9;
+		break;
+	case 6:
+		image_width = (image_height * 16) / 10;
+		break;
+	case 7:
+		/* special case */
+		if (image_height == 1024)
+			image_width = (image_height * 5) / 4;
+		else if (image_height == 768)
+			image_width = (image_height * 15) / 9;
+		else
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	image_width = image_width & ~7;
+
+	/* Horizontal */
+	if (reduced_blanking) {
+		pix_clk = (image_width + CVT_RB_H_BLANK) * hfreq;
+		pix_clk = (pix_clk / CVT_PXL_CLK_GRAN) * CVT_PXL_CLK_GRAN;
+
+		h_bp = CVT_RB_H_BPORCH;
+		hsync = CVT_RB_H_SYNC;
+		h_fp = CVT_RB_H_BLANK - h_bp - hsync;
+
+		frame_width = image_width + CVT_RB_H_BLANK;
+	} else {
+		int h_blank;
+		unsigned ideal_duty_cycle = CVT_C_PRIME - (CVT_M_PRIME * 1000) / hfreq;
+
+		h_blank = (image_width * ideal_duty_cycle + (100 - ideal_duty_cycle) / 2) /
+						(100 - ideal_duty_cycle);
+		h_blank = h_blank - h_blank % (2 * CVT_CELL_GRAN);
+
+		if (h_blank * 100 / image_width < 20) {
+			h_blank = image_width / 5;
+			h_blank = (h_blank + 0x7) & ~0x7;
+		}
+
+		pix_clk = (image_width + h_blank) * hfreq;
+		pix_clk = (pix_clk / CVT_PXL_CLK_GRAN) * CVT_PXL_CLK_GRAN;
+
+		h_bp = h_blank / 2;
+		frame_width = image_width + h_blank;
+
+		hsync = (frame_width * 8 + 50) / 100;
+		hsync = hsync - hsync % CVT_CELL_GRAN;
+		h_fp = h_blank - hsync - h_bp;
+	}
+
+	fmt->bt.polarities = polarities;
+	fmt->bt.width = image_width;
+	fmt->bt.height = image_height;
+	fmt->bt.hfrontporch = h_fp;
+	fmt->bt.vfrontporch = v_fp;
+	fmt->bt.hsync = hsync;
+	fmt->bt.vsync = vsync;
+	fmt->bt.hbackporch = frame_width - image_width - h_fp - hsync;
+	fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
+	fmt->bt.pixelclock = pix_clk;
+	fmt->bt.standards = V4L2_DV_BT_STD_CVT;
+	if (reduced_blanking)
+		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
+	return true;
+}
+EXPORT_SYMBOL_GPL(v4l2_detect_cvt);
+
+/*
+ * GTF defines
+ * Based on Generalized Timing Formula Standard
+ * Version 1.1 September 2, 1999
+ */
+
+#define GTF_PXL_CLK_GRAN	250000	/* pixel clock granularity */
+
+#define GTF_MIN_VSYNC_BP	550	/* min time of vsync + back porch (us) */
+#define GTF_V_FP		1	/* vertical front porch (lines) */
+#define GTF_CELL_GRAN		8	/* character cell granularity */
+
+/* Default */
+#define GTF_D_M			600	/* blanking formula gradient */
+#define GTF_D_C			40	/* blanking formula offset */
+#define GTF_D_K			128	/* blanking formula scaling factor */
+#define GTF_D_J			20	/* blanking formula scaling factor */
+#define GTF_D_C_PRIME ((((GTF_D_C - GTF_D_J) * GTF_D_K) / 256) + GTF_D_J)
+#define GTF_D_M_PRIME ((GTF_D_K * GTF_D_M) / 256)
+
+/* Secondary */
+#define GTF_S_M			3600	/* blanking formula gradient */
+#define GTF_S_C			40	/* blanking formula offset */
+#define GTF_S_K			128	/* blanking formula scaling factor */
+#define GTF_S_J			35	/* blanking formula scaling factor */
+#define GTF_S_C_PRIME ((((GTF_S_C - GTF_S_J) * GTF_S_K) / 256) + GTF_S_J)
+#define GTF_S_M_PRIME ((GTF_S_K * GTF_S_M) / 256)
+
+/** v4l2_detect_gtf - detect if the given timings follow the GTF standard
+ * @frame_height - the total height of the frame (including blanking) in lines.
+ * @hfreq - the horizontal frequency in Hz.
+ * @vsync - the height of the vertical sync in lines.
+ * @polarities - the horizontal and vertical polarities (same as struct
+ *		v4l2_bt_timings polarities).
+ * @aspect - preferred aspect ratio. GTF has no method of determining the
+ *		aspect ratio in order to derive the image width from the
+ *		image height, so it has to be passed explicitly. Usually
+ *		the native screen aspect ratio is used for this. If it
+ *		is not filled in correctly, then 16:9 will be assumed.
+ * @fmt - the resulting timings.
+ *
+ * This function will attempt to detect if the given values correspond to a
+ * valid GTF format. If so, then it will return true, and fmt will be filled
+ * in with the found GTF timings.
+ */
+bool v4l2_detect_gtf(unsigned frame_height,
+		unsigned hfreq,
+		unsigned vsync,
+		u32 polarities,
+		struct v4l2_fract aspect,
+		struct v4l2_dv_timings *fmt)
+{
+	int pix_clk;
+	int  v_fp, v_bp, h_fp, h_bp, hsync;
+	int frame_width, image_height, image_width;
+	bool default_gtf;
+	int h_blank;
+
+	if (vsync != 3)
+		return false;
+
+	if (polarities == V4L2_DV_VSYNC_POS_POL)
+		default_gtf = true;
+	else if (polarities == V4L2_DV_HSYNC_POS_POL)
+		default_gtf = false;
+	else
+		return false;
+
+	/* Vertical */
+	v_fp = GTF_V_FP;
+	v_bp = (GTF_MIN_VSYNC_BP * hfreq + 999999) / 1000000 - vsync;
+	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
+
+	if (aspect.numerator == 0 || aspect.denominator == 0) {
+		aspect.numerator = 16;
+		aspect.denominator = 9;
+	}
+	image_width = ((image_height * aspect.numerator) / aspect.denominator);
+
+	/* Horizontal */
+	if (default_gtf)
+		h_blank = ((image_width * GTF_D_C_PRIME * hfreq) -
+					(image_width * GTF_D_M_PRIME * 1000) +
+			(hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000) / 2) /
+			(hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000);
+	else
+		h_blank = ((image_width * GTF_S_C_PRIME * hfreq) -
+					(image_width * GTF_S_M_PRIME * 1000) +
+			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) / 2) /
+			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000);
+
+	h_blank = h_blank - h_blank % (2 * GTF_CELL_GRAN);
+	frame_width = image_width + h_blank;
+
+	pix_clk = (image_width + h_blank) * hfreq;
+	pix_clk = pix_clk / GTF_PXL_CLK_GRAN * GTF_PXL_CLK_GRAN;
+
+	hsync = (frame_width * 8 + 50) / 100;
+	hsync = hsync - hsync % GTF_CELL_GRAN;
+
+	h_fp = h_blank / 2 - hsync;
+	h_bp = h_blank / 2;
+
+	fmt->bt.polarities = polarities;
+	fmt->bt.width = image_width;
+	fmt->bt.height = image_height;
+	fmt->bt.hfrontporch = h_fp;
+	fmt->bt.vfrontporch = v_fp;
+	fmt->bt.hsync = hsync;
+	fmt->bt.vsync = vsync;
+	fmt->bt.hbackporch = frame_width - image_width - h_fp - hsync;
+	fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
+	fmt->bt.pixelclock = pix_clk;
+	fmt->bt.standards = V4L2_DV_BT_STD_GTF;
+	if (!default_gtf)
+		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
+	return true;
+}
+EXPORT_SYMBOL_GPL(v4l2_detect_gtf);
+
+/** v4l2_calc_aspect_ratio - calculate the aspect ratio based on bytes
+ *	0x15 and 0x16 from the EDID.
+ * @hor_landscape - byte 0x15 from the EDID.
+ * @vert_portrait - byte 0x16 from the EDID.
+ *
+ * Determines the aspect ratio from the EDID.
+ * See VESA Enhanced EDID standard, release A, rev 2, section 3.6.2:
+ * "Horizontal and Vertical Screen Size or Aspect Ratio"
+ */
+struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
+{
+	struct v4l2_fract aspect = { 16, 9 };
+	u32 tmp;
+	u8 ratio;
+
+	/* Nothing filled in, fallback to 16:9 */
+	if (!hor_landscape && !vert_portrait)
+		return aspect;
+	/* Both filled in, so they are interpreted as the screen size in cm */
+	if (hor_landscape && vert_portrait) {
+		aspect.numerator = hor_landscape;
+		aspect.denominator = vert_portrait;
+		return aspect;
+	}
+	/* Only one is filled in, so interpret them as a ratio:
+	   (val + 99) / 100 */
+	ratio = hor_landscape | vert_portrait;
+	/* Change some rounded values into the exact aspect ratio */
+	if (ratio == 79) {
+		aspect.numerator = 16;
+		aspect.denominator = 9;
+	} else if (ratio == 34) {
+		aspect.numerator = 4;
+		aspect.numerator = 3;
+	} else if (ratio == 68) {
+		aspect.numerator = 15;
+		aspect.numerator = 9;
+	} else {
+		aspect.numerator = hor_landscape + 99;
+		aspect.denominator = 100;
+	}
+	if (hor_landscape)
+		return aspect;
+	/* The aspect ratio is for portrait, so swap numerator and denominator */
+	tmp = aspect.denominator;
+	aspect.denominator = aspect.numerator;
+	aspect.numerator = tmp;
+	return aspect;
+}
+EXPORT_SYMBOL_GPL(v4l2_calc_aspect_ratio);
+
 const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 		const struct v4l2_discrete_probe *probe,
 		s32 width, s32 height)
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index a298ec4..6df9554 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -212,4 +212,17 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 		const struct v4l2_discrete_probe *probe,
 		s32 width, s32 height);
 
+bool v4l_match_dv_timings(const struct v4l2_dv_timings *t1,
+			  const struct v4l2_dv_timings *t2,
+			  unsigned pclock_delta);
+
+bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
+		u32 polarities, struct v4l2_dv_timings *fmt);
+
+bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
+		u32 polarities, struct v4l2_fract aspect,
+		struct v4l2_dv_timings *fmt);
+
+struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
+
 #endif /* V4L2_COMMON_H_ */
-- 
1.7.10

