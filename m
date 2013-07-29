Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1346 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3G2MlY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:41:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/8] v4l2: move dv-timings related code to v4l2-dv-timings.c
Date: Mon, 29 Jul 2013 14:40:56 +0200
Message-Id: <1375101661-6493-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l2-common.c contained a bunch of dv-timings related functions.
Move that to the new v4l2-dv-timings.c which is a more appropriate
place for them.

There aren't many drivers that do HDTV, so it is a good idea to separate
common code related to that into a module of its own.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c               |   1 +
 drivers/media/i2c/adv7604.c               |   1 +
 drivers/media/i2c/ths8200.c               |   1 +
 drivers/media/usb/hdpvr/hdpvr-video.c     |   1 +
 drivers/media/v4l2-core/v4l2-common.c     | 357 -----------------------------
 drivers/media/v4l2-core/v4l2-dv-timings.c | 358 +++++++++++++++++++++++++++++-
 include/media/v4l2-common.h               |  13 --
 include/media/v4l2-dv-timings.h           |  59 +++++
 8 files changed, 420 insertions(+), 371 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index ba4364d..2fa8d72 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -33,6 +33,7 @@
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-dv-timings.h>
 #include <media/v4l2-ctrls.h>
 #include <media/ad9389b.h>
 
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 1d675b5..181a6c3 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -38,6 +38,7 @@
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-dv-timings.h>
 #include <media/adv7604.h>
 
 static int debug;
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 8a29810..aef7c0e 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/v4l2-dv-timings.h>
 
+#include <media/v4l2-dv-timings.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 4f8567a..9c67b6e 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -24,6 +24,7 @@
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-dv-timings.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
 #include "hdpvr.h"
diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index a95e5e2..037d7a5 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -495,363 +495,6 @@ void v4l_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
 }
 EXPORT_SYMBOL_GPL(v4l_bound_align_image);
 
-/**
- * v4l_match_dv_timings - check if two timings match
- * @t1 - compare this v4l2_dv_timings struct...
- * @t2 - with this struct.
- * @pclock_delta - the allowed pixelclock deviation.
- *
- * Compare t1 with t2 with a given margin of error for the pixelclock.
- */
-bool v4l_match_dv_timings(const struct v4l2_dv_timings *t1,
-			  const struct v4l2_dv_timings *t2,
-			  unsigned pclock_delta)
-{
-	if (t1->type != t2->type || t1->type != V4L2_DV_BT_656_1120)
-		return false;
-	if (t1->bt.width == t2->bt.width &&
-	    t1->bt.height == t2->bt.height &&
-	    t1->bt.interlaced == t2->bt.interlaced &&
-	    t1->bt.polarities == t2->bt.polarities &&
-	    t1->bt.pixelclock >= t2->bt.pixelclock - pclock_delta &&
-	    t1->bt.pixelclock <= t2->bt.pixelclock + pclock_delta &&
-	    t1->bt.hfrontporch == t2->bt.hfrontporch &&
-	    t1->bt.vfrontporch == t2->bt.vfrontporch &&
-	    t1->bt.vsync == t2->bt.vsync &&
-	    t1->bt.vbackporch == t2->bt.vbackporch &&
-	    (!t1->bt.interlaced ||
-		(t1->bt.il_vfrontporch == t2->bt.il_vfrontporch &&
-		 t1->bt.il_vsync == t2->bt.il_vsync &&
-		 t1->bt.il_vbackporch == t2->bt.il_vbackporch)))
-		return true;
-	return false;
-}
-EXPORT_SYMBOL_GPL(v4l_match_dv_timings);
-
-/*
- * CVT defines
- * Based on Coordinated Video Timings Standard
- * version 1.1 September 10, 2003
- */
-
-#define CVT_PXL_CLK_GRAN	250000	/* pixel clock granularity */
-
-/* Normal blanking */
-#define CVT_MIN_V_BPORCH	7	/* lines */
-#define CVT_MIN_V_PORCH_RND	3	/* lines */
-#define CVT_MIN_VSYNC_BP	550	/* min time of vsync + back porch (us) */
-
-/* Normal blanking for CVT uses GTF to calculate horizontal blanking */
-#define CVT_CELL_GRAN		8	/* character cell granularity */
-#define CVT_M			600	/* blanking formula gradient */
-#define CVT_C			40	/* blanking formula offset */
-#define CVT_K			128	/* blanking formula scaling factor */
-#define CVT_J			20	/* blanking formula scaling factor */
-#define CVT_C_PRIME (((CVT_C - CVT_J) * CVT_K / 256) + CVT_J)
-#define CVT_M_PRIME (CVT_K * CVT_M / 256)
-
-/* Reduced Blanking */
-#define CVT_RB_MIN_V_BPORCH    7       /* lines  */
-#define CVT_RB_V_FPORCH        3       /* lines  */
-#define CVT_RB_MIN_V_BLANK   460     /* us     */
-#define CVT_RB_H_SYNC         32       /* pixels */
-#define CVT_RB_H_BPORCH       80       /* pixels */
-#define CVT_RB_H_BLANK       160       /* pixels */
-
-/** v4l2_detect_cvt - detect if the given timings follow the CVT standard
- * @frame_height - the total height of the frame (including blanking) in lines.
- * @hfreq - the horizontal frequency in Hz.
- * @vsync - the height of the vertical sync in lines.
- * @polarities - the horizontal and vertical polarities (same as struct
- *		v4l2_bt_timings polarities).
- * @fmt - the resulting timings.
- *
- * This function will attempt to detect if the given values correspond to a
- * valid CVT format. If so, then it will return true, and fmt will be filled
- * in with the found CVT timings.
- */
-bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
-		u32 polarities, struct v4l2_dv_timings *fmt)
-{
-	int  v_fp, v_bp, h_fp, h_bp, hsync;
-	int  frame_width, image_height, image_width;
-	bool reduced_blanking;
-	unsigned pix_clk;
-
-	if (vsync < 4 || vsync > 7)
-		return false;
-
-	if (polarities == V4L2_DV_VSYNC_POS_POL)
-		reduced_blanking = false;
-	else if (polarities == V4L2_DV_HSYNC_POS_POL)
-		reduced_blanking = true;
-	else
-		return false;
-
-	/* Vertical */
-	if (reduced_blanking) {
-		v_fp = CVT_RB_V_FPORCH;
-		v_bp = (CVT_RB_MIN_V_BLANK * hfreq + 999999) / 1000000;
-		v_bp -= vsync + v_fp;
-
-		if (v_bp < CVT_RB_MIN_V_BPORCH)
-			v_bp = CVT_RB_MIN_V_BPORCH;
-	} else {
-		v_fp = CVT_MIN_V_PORCH_RND;
-		v_bp = (CVT_MIN_VSYNC_BP * hfreq + 999999) / 1000000 - vsync;
-
-		if (v_bp < CVT_MIN_V_BPORCH)
-			v_bp = CVT_MIN_V_BPORCH;
-	}
-	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
-
-	/* Aspect ratio based on vsync */
-	switch (vsync) {
-	case 4:
-		image_width = (image_height * 4) / 3;
-		break;
-	case 5:
-		image_width = (image_height * 16) / 9;
-		break;
-	case 6:
-		image_width = (image_height * 16) / 10;
-		break;
-	case 7:
-		/* special case */
-		if (image_height == 1024)
-			image_width = (image_height * 5) / 4;
-		else if (image_height == 768)
-			image_width = (image_height * 15) / 9;
-		else
-			return false;
-		break;
-	default:
-		return false;
-	}
-
-	image_width = image_width & ~7;
-
-	/* Horizontal */
-	if (reduced_blanking) {
-		pix_clk = (image_width + CVT_RB_H_BLANK) * hfreq;
-		pix_clk = (pix_clk / CVT_PXL_CLK_GRAN) * CVT_PXL_CLK_GRAN;
-
-		h_bp = CVT_RB_H_BPORCH;
-		hsync = CVT_RB_H_SYNC;
-		h_fp = CVT_RB_H_BLANK - h_bp - hsync;
-
-		frame_width = image_width + CVT_RB_H_BLANK;
-	} else {
-		int h_blank;
-		unsigned ideal_duty_cycle = CVT_C_PRIME - (CVT_M_PRIME * 1000) / hfreq;
-
-		h_blank = (image_width * ideal_duty_cycle + (100 - ideal_duty_cycle) / 2) /
-						(100 - ideal_duty_cycle);
-		h_blank = h_blank - h_blank % (2 * CVT_CELL_GRAN);
-
-		if (h_blank * 100 / image_width < 20) {
-			h_blank = image_width / 5;
-			h_blank = (h_blank + 0x7) & ~0x7;
-		}
-
-		pix_clk = (image_width + h_blank) * hfreq;
-		pix_clk = (pix_clk / CVT_PXL_CLK_GRAN) * CVT_PXL_CLK_GRAN;
-
-		h_bp = h_blank / 2;
-		frame_width = image_width + h_blank;
-
-		hsync = (frame_width * 8 + 50) / 100;
-		hsync = hsync - hsync % CVT_CELL_GRAN;
-		h_fp = h_blank - hsync - h_bp;
-	}
-
-	fmt->bt.polarities = polarities;
-	fmt->bt.width = image_width;
-	fmt->bt.height = image_height;
-	fmt->bt.hfrontporch = h_fp;
-	fmt->bt.vfrontporch = v_fp;
-	fmt->bt.hsync = hsync;
-	fmt->bt.vsync = vsync;
-	fmt->bt.hbackporch = frame_width - image_width - h_fp - hsync;
-	fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
-	fmt->bt.pixelclock = pix_clk;
-	fmt->bt.standards = V4L2_DV_BT_STD_CVT;
-	if (reduced_blanking)
-		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
-	return true;
-}
-EXPORT_SYMBOL_GPL(v4l2_detect_cvt);
-
-/*
- * GTF defines
- * Based on Generalized Timing Formula Standard
- * Version 1.1 September 2, 1999
- */
-
-#define GTF_PXL_CLK_GRAN	250000	/* pixel clock granularity */
-
-#define GTF_MIN_VSYNC_BP	550	/* min time of vsync + back porch (us) */
-#define GTF_V_FP		1	/* vertical front porch (lines) */
-#define GTF_CELL_GRAN		8	/* character cell granularity */
-
-/* Default */
-#define GTF_D_M			600	/* blanking formula gradient */
-#define GTF_D_C			40	/* blanking formula offset */
-#define GTF_D_K			128	/* blanking formula scaling factor */
-#define GTF_D_J			20	/* blanking formula scaling factor */
-#define GTF_D_C_PRIME ((((GTF_D_C - GTF_D_J) * GTF_D_K) / 256) + GTF_D_J)
-#define GTF_D_M_PRIME ((GTF_D_K * GTF_D_M) / 256)
-
-/* Secondary */
-#define GTF_S_M			3600	/* blanking formula gradient */
-#define GTF_S_C			40	/* blanking formula offset */
-#define GTF_S_K			128	/* blanking formula scaling factor */
-#define GTF_S_J			35	/* blanking formula scaling factor */
-#define GTF_S_C_PRIME ((((GTF_S_C - GTF_S_J) * GTF_S_K) / 256) + GTF_S_J)
-#define GTF_S_M_PRIME ((GTF_S_K * GTF_S_M) / 256)
-
-/** v4l2_detect_gtf - detect if the given timings follow the GTF standard
- * @frame_height - the total height of the frame (including blanking) in lines.
- * @hfreq - the horizontal frequency in Hz.
- * @vsync - the height of the vertical sync in lines.
- * @polarities - the horizontal and vertical polarities (same as struct
- *		v4l2_bt_timings polarities).
- * @aspect - preferred aspect ratio. GTF has no method of determining the
- *		aspect ratio in order to derive the image width from the
- *		image height, so it has to be passed explicitly. Usually
- *		the native screen aspect ratio is used for this. If it
- *		is not filled in correctly, then 16:9 will be assumed.
- * @fmt - the resulting timings.
- *
- * This function will attempt to detect if the given values correspond to a
- * valid GTF format. If so, then it will return true, and fmt will be filled
- * in with the found GTF timings.
- */
-bool v4l2_detect_gtf(unsigned frame_height,
-		unsigned hfreq,
-		unsigned vsync,
-		u32 polarities,
-		struct v4l2_fract aspect,
-		struct v4l2_dv_timings *fmt)
-{
-	int pix_clk;
-	int  v_fp, v_bp, h_fp, hsync;
-	int frame_width, image_height, image_width;
-	bool default_gtf;
-	int h_blank;
-
-	if (vsync != 3)
-		return false;
-
-	if (polarities == V4L2_DV_VSYNC_POS_POL)
-		default_gtf = true;
-	else if (polarities == V4L2_DV_HSYNC_POS_POL)
-		default_gtf = false;
-	else
-		return false;
-
-	/* Vertical */
-	v_fp = GTF_V_FP;
-	v_bp = (GTF_MIN_VSYNC_BP * hfreq + 999999) / 1000000 - vsync;
-	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
-
-	if (aspect.numerator == 0 || aspect.denominator == 0) {
-		aspect.numerator = 16;
-		aspect.denominator = 9;
-	}
-	image_width = ((image_height * aspect.numerator) / aspect.denominator);
-
-	/* Horizontal */
-	if (default_gtf)
-		h_blank = ((image_width * GTF_D_C_PRIME * hfreq) -
-					(image_width * GTF_D_M_PRIME * 1000) +
-			(hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000) / 2) /
-			(hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000);
-	else
-		h_blank = ((image_width * GTF_S_C_PRIME * hfreq) -
-					(image_width * GTF_S_M_PRIME * 1000) +
-			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) / 2) /
-			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000);
-
-	h_blank = h_blank - h_blank % (2 * GTF_CELL_GRAN);
-	frame_width = image_width + h_blank;
-
-	pix_clk = (image_width + h_blank) * hfreq;
-	pix_clk = pix_clk / GTF_PXL_CLK_GRAN * GTF_PXL_CLK_GRAN;
-
-	hsync = (frame_width * 8 + 50) / 100;
-	hsync = hsync - hsync % GTF_CELL_GRAN;
-
-	h_fp = h_blank / 2 - hsync;
-
-	fmt->bt.polarities = polarities;
-	fmt->bt.width = image_width;
-	fmt->bt.height = image_height;
-	fmt->bt.hfrontporch = h_fp;
-	fmt->bt.vfrontporch = v_fp;
-	fmt->bt.hsync = hsync;
-	fmt->bt.vsync = vsync;
-	fmt->bt.hbackporch = frame_width - image_width - h_fp - hsync;
-	fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
-	fmt->bt.pixelclock = pix_clk;
-	fmt->bt.standards = V4L2_DV_BT_STD_GTF;
-	if (!default_gtf)
-		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
-	return true;
-}
-EXPORT_SYMBOL_GPL(v4l2_detect_gtf);
-
-/** v4l2_calc_aspect_ratio - calculate the aspect ratio based on bytes
- *	0x15 and 0x16 from the EDID.
- * @hor_landscape - byte 0x15 from the EDID.
- * @vert_portrait - byte 0x16 from the EDID.
- *
- * Determines the aspect ratio from the EDID.
- * See VESA Enhanced EDID standard, release A, rev 2, section 3.6.2:
- * "Horizontal and Vertical Screen Size or Aspect Ratio"
- */
-struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
-{
-	struct v4l2_fract aspect = { 16, 9 };
-	u32 tmp;
-	u8 ratio;
-
-	/* Nothing filled in, fallback to 16:9 */
-	if (!hor_landscape && !vert_portrait)
-		return aspect;
-	/* Both filled in, so they are interpreted as the screen size in cm */
-	if (hor_landscape && vert_portrait) {
-		aspect.numerator = hor_landscape;
-		aspect.denominator = vert_portrait;
-		return aspect;
-	}
-	/* Only one is filled in, so interpret them as a ratio:
-	   (val + 99) / 100 */
-	ratio = hor_landscape | vert_portrait;
-	/* Change some rounded values into the exact aspect ratio */
-	if (ratio == 79) {
-		aspect.numerator = 16;
-		aspect.denominator = 9;
-	} else if (ratio == 34) {
-		aspect.numerator = 4;
-		aspect.numerator = 3;
-	} else if (ratio == 68) {
-		aspect.numerator = 15;
-		aspect.numerator = 9;
-	} else {
-		aspect.numerator = hor_landscape + 99;
-		aspect.denominator = 100;
-	}
-	if (hor_landscape)
-		return aspect;
-	/* The aspect ratio is for portrait, so swap numerator and denominator */
-	tmp = aspect.denominator;
-	aspect.denominator = aspect.numerator;
-	aspect.numerator = tmp;
-	return aspect;
-}
-EXPORT_SYMBOL_GPL(v4l2_calc_aspect_ratio);
-
 const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 		const struct v4l2_discrete_probe *probe,
 		s32 width, s32 height)
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 5827946..f20b316 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -24,7 +24,6 @@
 #include <linux/errno.h>
 #include <linux/videodev2.h>
 #include <linux/v4l2-dv-timings.h>
-#include <media/v4l2-common.h>
 #include <media/v4l2-dv-timings.h>
 
 static const struct v4l2_dv_timings timings[] = {
@@ -190,3 +189,360 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 	return false;
 }
 EXPORT_SYMBOL_GPL(v4l2_find_dv_timings_cap);
+
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
+	int  v_fp, v_bp, h_fp, hsync;
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
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 015ff82..0e1d010 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -201,19 +201,6 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 		const struct v4l2_discrete_probe *probe,
 		s32 width, s32 height);
 
-bool v4l_match_dv_timings(const struct v4l2_dv_timings *t1,
-			  const struct v4l2_dv_timings *t2,
-			  unsigned pclock_delta);
-
-bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
-		u32 polarities, struct v4l2_dv_timings *fmt);
-
-bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
-		u32 polarities, struct v4l2_fract aspect,
-		struct v4l2_dv_timings *fmt);
-
-struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
-
 void v4l2_get_timestamp(struct timeval *tv);
 
 #endif /* V4L2_COMMON_H_ */
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 41075fa..4c7bb54 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -64,4 +64,63 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 			      const struct v4l2_dv_timings_cap *cap,
 			      unsigned pclock_delta);
 
+/** v4l_match_dv_timings() - do two timings match?
+  * @measured:	  the measured timings data.
+  * @standard:	  the timings according to the standard.
+  * @pclock_delta: maximum delta in Hz between standard->pixelclock and
+  * 		the measured timings.
+  *
+  * Returns true if the two timings match, returns false otherwise.
+  */
+bool v4l_match_dv_timings(const struct v4l2_dv_timings *measured,
+			  const struct v4l2_dv_timings *standard,
+			  unsigned pclock_delta);
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
+		u32 polarities, struct v4l2_dv_timings *fmt);
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
+bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
+		u32 polarities, struct v4l2_fract aspect,
+		struct v4l2_dv_timings *fmt);
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
+struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
+
 #endif
-- 
1.8.3.2

