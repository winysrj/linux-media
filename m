Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:53391 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbbEVF1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 01:27:39 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH v2 1/4] v4l2-dv-timings: add interlace support in detect cvt/gtf
Date: Fri, 22 May 2015 10:57:34 +0530
Message-Id: <1432272457-709-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1432272457-709-1-git-send-email-prladdha@cisco.com>
References: <1432272457-709-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extended detect_cvt/gtf API to indicate the format type (interlaced
or progressive). In case of interlaced, the vertical front and back
porch and vsync values for both (odd,even) fields are considered to
derive image height. Populated vsync, verical front, back porch
values in bt timing structure for even and odd fields and updated
the flags appropriately.

Also modified the functions calling the detect_cvt/gtf(). As of now
these functions are calling detect_cvt/gtf() with interlaced flag
set to false.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Cc: Mats Randgaard <matrandg@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/i2c/adv7604.c                  |  4 +--
 drivers/media/i2c/adv7842.c                  |  4 +--
 drivers/media/platform/vivid/vivid-vid-cap.c |  5 +--
 drivers/media/v4l2-core/v4l2-dv-timings.c    | 53 ++++++++++++++++++++++++----
 include/media/v4l2-dv-timings.h              |  6 ++--
 5 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index aaa37b0..f4ecb73 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1323,12 +1323,12 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 	if (v4l2_detect_cvt(stdi->lcf + 1, hfreq, stdi->lcvs,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
-			timings))
+			false, timings))
 		return 0;
 	if (v4l2_detect_gtf(stdi->lcf + 1, hfreq, stdi->lcvs,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
-			state->aspect_ratio, timings))
+			false, state->aspect_ratio, timings))
 		return 0;
 
 	v4l2_dbg(2, debug, sd,
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index f5248ba..b9264f7 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1445,12 +1445,12 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 	if (v4l2_detect_cvt(stdi->lcf + 1, hfreq, stdi->lcvs,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
-			    timings))
+			false, timings))
 		return 0;
 	if (v4l2_detect_gtf(stdi->lcf + 1, hfreq, stdi->lcvs,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
-			    state->aspect_ratio, timings))
+			false, state->aspect_ratio, timings))
 		return 0;
 
 	v4l2_dbg(2, debug, sd,
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index fd7adc4..a99362d 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1619,7 +1619,7 @@ static bool valid_cvt_gtf_timings(struct v4l2_dv_timings *timings)
 
 	if (bt->standards == 0 || (bt->standards & V4L2_DV_BT_STD_CVT)) {
 		if (v4l2_detect_cvt(total_v_lines, h_freq, bt->vsync,
-				    bt->polarities, timings))
+				    bt->polarities, false, timings))
 			return true;
 	}
 
@@ -1630,7 +1630,8 @@ static bool valid_cvt_gtf_timings(struct v4l2_dv_timings *timings)
 				  &aspect_ratio.numerator,
 				  &aspect_ratio.denominator);
 		if (v4l2_detect_gtf(total_v_lines, h_freq, bt->vsync,
-				    bt->polarities, aspect_ratio, timings))
+				    bt->polarities, false,
+				    aspect_ratio, timings))
 			return true;
 	}
 	return false;
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 5792192..7e15749 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -339,6 +339,7 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
  * @vsync - the height of the vertical sync in lines.
  * @polarities - the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
+ * @interlaced - if this flag is true, it indicates interlaced format
  * @fmt - the resulting timings.
  *
  * This function will attempt to detect if the given values correspond to a
@@ -350,7 +351,7 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
  * detection function.
  */
 bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
-		u32 polarities, struct v4l2_dv_timings *fmt)
+		u32 polarities, bool interlaced, struct v4l2_dv_timings *fmt)
 {
 	int  v_fp, v_bp, h_fp, h_bp, hsync;
 	int  frame_width, image_height, image_width;
@@ -385,7 +386,11 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 		if (v_bp < CVT_MIN_V_BPORCH)
 			v_bp = CVT_MIN_V_BPORCH;
 	}
-	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
+
+	if (interlaced)
+		image_height = (frame_height - 2 * v_fp - 2 * vsync - 2 * v_bp) & ~0x1;
+	else
+		image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
 
 	if (image_height < 0)
 		return false;
@@ -458,11 +463,27 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 	fmt->bt.hsync = hsync;
 	fmt->bt.vsync = vsync;
 	fmt->bt.hbackporch = frame_width - image_width - h_fp - hsync;
-	fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
+
+	if (!interlaced) {
+		fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
+		fmt->bt.interlaced = V4L2_DV_PROGRESSIVE;
+	} else {
+		fmt->bt.vbackporch = (frame_height - image_height - 2 * v_fp -
+				      2 * vsync) / 2;
+		fmt->bt.il_vbackporch = frame_height - image_height - 2 * v_fp -
+					2 * vsync - fmt->bt.vbackporch;
+		fmt->bt.il_vfrontporch = v_fp;
+		fmt->bt.il_vsync = vsync;
+		fmt->bt.flags |= V4L2_DV_FL_HALF_LINE;
+		fmt->bt.interlaced = V4L2_DV_INTERLACED;
+	}
+
 	fmt->bt.pixelclock = pix_clk;
 	fmt->bt.standards = V4L2_DV_BT_STD_CVT;
+
 	if (reduced_blanking)
 		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
+
 	return true;
 }
 EXPORT_SYMBOL_GPL(v4l2_detect_cvt);
@@ -501,6 +522,7 @@ EXPORT_SYMBOL_GPL(v4l2_detect_cvt);
  * @vsync - the height of the vertical sync in lines.
  * @polarities - the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
+ * @interlaced - if this flag is true, it indicates interlaced format
  * @aspect - preferred aspect ratio. GTF has no method of determining the
  *		aspect ratio in order to derive the image width from the
  *		image height, so it has to be passed explicitly. Usually
@@ -516,6 +538,7 @@ bool v4l2_detect_gtf(unsigned frame_height,
 		unsigned hfreq,
 		unsigned vsync,
 		u32 polarities,
+		bool interlaced,
 		struct v4l2_fract aspect,
 		struct v4l2_dv_timings *fmt)
 {
@@ -540,9 +563,11 @@ bool v4l2_detect_gtf(unsigned frame_height,
 
 	/* Vertical */
 	v_fp = GTF_V_FP;
-
 	v_bp = (GTF_MIN_VSYNC_BP * hfreq + 500000) / 1000000 - vsync;
-	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
+	if (interlaced)
+		image_height = (frame_height - 2 * v_fp - 2 * vsync - 2 * v_bp) & ~0x1;
+	else
+		image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
 
 	if (image_height < 0)
 		return false;
@@ -594,11 +619,27 @@ bool v4l2_detect_gtf(unsigned frame_height,
 	fmt->bt.hsync = hsync;
 	fmt->bt.vsync = vsync;
 	fmt->bt.hbackporch = frame_width - image_width - h_fp - hsync;
-	fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
+
+	if (!interlaced) {
+		fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
+		fmt->bt.interlaced = V4L2_DV_PROGRESSIVE;
+	} else {
+		fmt->bt.vbackporch = (frame_height - image_height - 2 * v_fp -
+				      2 * vsync) / 2;
+		fmt->bt.il_vbackporch = frame_height - image_height - 2 * v_fp -
+					2 * vsync - fmt->bt.vbackporch;
+		fmt->bt.il_vfrontporch = v_fp;
+		fmt->bt.il_vsync = vsync;
+		fmt->bt.flags |= V4L2_DV_FL_HALF_LINE;
+		fmt->bt.interlaced = V4L2_DV_INTERLACED;
+	}
+
 	fmt->bt.pixelclock = pix_clk;
 	fmt->bt.standards = V4L2_DV_BT_STD_GTF;
+
 	if (!default_gtf)
 		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
+
 	return true;
 }
 EXPORT_SYMBOL_GPL(v4l2_detect_gtf);
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 4becc67..eecd310 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -117,6 +117,7 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
  * @vsync - the height of the vertical sync in lines.
  * @polarities - the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
+ * @interlaced - if this flag is true, it indicates interlaced format
  * @fmt - the resulting timings.
  *
  * This function will attempt to detect if the given values correspond to a
@@ -124,7 +125,7 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
  * in with the found CVT timings.
  */
 bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
-		u32 polarities, struct v4l2_dv_timings *fmt);
+		u32 polarities, bool interlaced, struct v4l2_dv_timings *fmt);
 
 /** v4l2_detect_gtf - detect if the given timings follow the GTF standard
  * @frame_height - the total height of the frame (including blanking) in lines.
@@ -132,6 +133,7 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
  * @vsync - the height of the vertical sync in lines.
  * @polarities - the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
+ * @interlaced - if this flag is true, it indicates interlaced format
  * @aspect - preferred aspect ratio. GTF has no method of determining the
  *		aspect ratio in order to derive the image width from the
  *		image height, so it has to be passed explicitly. Usually
@@ -144,7 +146,7 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
  * in with the found GTF timings.
  */
 bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
-		u32 polarities, struct v4l2_fract aspect,
+		u32 polarities, bool interlaced, struct v4l2_fract aspect,
 		struct v4l2_dv_timings *fmt);
 
 /** v4l2_calc_aspect_ratio - calculate the aspect ratio based on bytes
-- 
1.9.1

