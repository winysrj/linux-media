Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:21664 "EHLO
	bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbbDHNIk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 09:08:40 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH] Add support for interlaced format in detect cvt/gtf
Date: Wed,  8 Apr 2015 18:27:57 +0530
Message-Id: <1428497877-6593-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1428497877-6593-1-git-send-email-prladdha@cisco.com>
References: <1428497877-6593-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extended detect_cvt/gtf API to indicate the scan type (interlaced
or progressive). In case of interlaced, the vertical front and back
porch and vsync values for both (odd,even) fields are considered to
derive image height. Populated vsync, verical front, back porch
values in bt timing structure for even and odd fields and updated
the flags appropriately.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Cc: Mats Randgaard <matrandg@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/i2c/adv7604.c                  |  4 +++
 drivers/media/i2c/adv7842.c                  |  8 ++++--
 drivers/media/platform/vivid/vivid-vid-cap.c |  5 ++--
 drivers/media/v4l2-core/v4l2-dv-timings.c    | 39 ++++++++++++++++++++++++----
 include/media/v4l2-dv-timings.h              |  6 +++--
 5 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 1e58537..bdc1d6d 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1304,11 +1304,15 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 	if (v4l2_detect_cvt(stdi->lcf + 1, hfreq, stdi->lcvs,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
+			stdi->interlaced ? V4L2_DV_INTERLACED :
+					   V4L2_DV_PROGRESSIVE,
 			timings))
 		return 0;
 	if (v4l2_detect_gtf(stdi->lcf + 1, hfreq, stdi->lcvs,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
+			stdi->interlaced ? V4L2_DV_INTERLACED :
+					   V4L2_DV_PROGRESSIVE,
 			state->aspect_ratio, timings))
 		return 0;
 
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 7c215ee..b93ad27 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1333,12 +1333,16 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 	if (v4l2_detect_cvt(stdi->lcf + 1, hfreq, stdi->lcvs,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
-			    timings))
+			stdi->interlaced ? V4L2_DV_INTERLACED :
+					   V4L2_DV_PROGRESSIVE,
+			timings))
 		return 0;
 	if (v4l2_detect_gtf(stdi->lcf + 1, hfreq, stdi->lcvs,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
-			    state->aspect_ratio, timings))
+			stdi->interlaced ? V4L2_DV_INTERLACED :
+					   V4L2_DV_PROGRESSIVE,
+			state->aspect_ratio, timings))
 		return 0;
 
 	v4l2_dbg(2, debug, sd,
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index ede168a..5e2b712 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1620,7 +1620,7 @@ static bool valid_cvt_gtf_timings(struct v4l2_dv_timings *timings)
 
 	if (bt->standards == 0 || (bt->standards & V4L2_DV_BT_STD_CVT)) {
 		if (v4l2_detect_cvt(total_v_lines, h_freq, bt->vsync,
-				    bt->polarities, timings))
+				    bt->polarities, bt->interlaced, timings))
 			return true;
 	}
 
@@ -1631,7 +1631,8 @@ static bool valid_cvt_gtf_timings(struct v4l2_dv_timings *timings)
 				  &aspect_ratio.numerator,
 				  &aspect_ratio.denominator);
 		if (v4l2_detect_gtf(total_v_lines, h_freq, bt->vsync,
-				    bt->polarities, aspect_ratio, timings))
+				    bt->polarities, bt->interlaced,
+				    aspect_ratio, timings))
 			return true;
 	}
 	return false;
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index b1d8dbb..80e4722 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -335,6 +335,7 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
  * @vsync - the height of the vertical sync in lines.
  * @polarities - the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
+ * @scan - V4L2_DV_INTERLACED or V4L2_DV_PROGRESSIVE
  * @fmt - the resulting timings.
  *
  * This function will attempt to detect if the given values correspond to a
@@ -346,7 +347,7 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
  * detection function.
  */
 bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
-		u32 polarities, struct v4l2_dv_timings *fmt)
+		u32 polarities, u32 scan, struct v4l2_dv_timings *fmt)
 {
 	int  v_fp, v_bp, h_fp, h_bp, hsync;
 	int  frame_width, image_height, image_width;
@@ -378,7 +379,12 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 		if (v_bp < CVT_MIN_V_BPORCH)
 			v_bp = CVT_MIN_V_BPORCH;
 	}
-	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
+
+	if (scan == V4L2_DV_INTERLACED)
+		image_height = (frame_height - 2 * v_fp - 2 * vsync - 2 * v_bp)
+				& ~0x1;
+	else
+		image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
 
 	/* Aspect ratio based on vsync */
 	switch (vsync) {
@@ -448,11 +454,19 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 	fmt->bt.hsync = hsync;
 	fmt->bt.vsync = vsync;
 	fmt->bt.hbackporch = frame_width - image_width - h_fp - hsync;
-	fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
+	fmt->bt.vbackporch = v_bp;
 	fmt->bt.pixelclock = pix_clk;
 	fmt->bt.standards = V4L2_DV_BT_STD_CVT;
 	if (reduced_blanking)
 		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
+	if (scan == V4L2_DV_INTERLACED) {
+		fmt->bt.interlaced = V4L2_DV_INTERLACED;
+		fmt->bt.il_vfrontporch = v_fp;
+		fmt->bt.il_vsync = vsync;
+		fmt->bt.il_vbackporch = v_bp + 1;
+		fmt->bt.flags |= V4L2_DV_FL_HALF_LINE;
+	} else
+		fmt->bt.interlaced = V4L2_DV_PROGRESSIVE;
 	return true;
 }
 EXPORT_SYMBOL_GPL(v4l2_detect_cvt);
@@ -491,6 +505,7 @@ EXPORT_SYMBOL_GPL(v4l2_detect_cvt);
  * @vsync - the height of the vertical sync in lines.
  * @polarities - the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
+ * @scan - V4L2_DV_INTERLACED or V4L2_DV_PROGRESSIVE
  * @aspect - preferred aspect ratio. GTF has no method of determining the
  *		aspect ratio in order to derive the image width from the
  *		image height, so it has to be passed explicitly. Usually
@@ -506,6 +521,7 @@ bool v4l2_detect_gtf(unsigned frame_height,
 		unsigned hfreq,
 		unsigned vsync,
 		u32 polarities,
+		u32 scan,
 		struct v4l2_fract aspect,
 		struct v4l2_dv_timings *fmt)
 {
@@ -528,7 +544,12 @@ bool v4l2_detect_gtf(unsigned frame_height,
 	/* Vertical */
 	v_fp = GTF_V_FP;
 	v_bp = (GTF_MIN_VSYNC_BP * hfreq + 999999) / 1000000 - vsync;
-	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
+
+	if (scan == V4L2_DV_INTERLACED)
+		image_height = (frame_height - 2 * v_fp - 2 * vsync - 2 * v_bp)
+				& ~0x1;
+	else
+		image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
 
 	if (aspect.numerator == 0 || aspect.denominator == 0) {
 		aspect.numerator = 16;
@@ -569,11 +590,19 @@ bool v4l2_detect_gtf(unsigned frame_height,
 	fmt->bt.hsync = hsync;
 	fmt->bt.vsync = vsync;
 	fmt->bt.hbackporch = frame_width - image_width - h_fp - hsync;
-	fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
+	fmt->bt.vbackporch = v_bp;
 	fmt->bt.pixelclock = pix_clk;
 	fmt->bt.standards = V4L2_DV_BT_STD_GTF;
 	if (!default_gtf)
 		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
+	if (scan == V4L2_DV_INTERLACED) {
+		fmt->bt.interlaced = V4L2_DV_INTERLACED;
+		fmt->bt.il_vfrontporch = v_fp;
+		fmt->bt.il_vsync = vsync;
+		fmt->bt.il_vbackporch = v_bp + 1;
+		fmt->bt.flags |= V4L2_DV_FL_HALF_LINE;
+	} else
+		fmt->bt.interlaced = V4L2_DV_PROGRESSIVE;
 	return true;
 }
 EXPORT_SYMBOL_GPL(v4l2_detect_gtf);
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 4becc67..91a6871 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -117,6 +117,7 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
  * @vsync - the height of the vertical sync in lines.
  * @polarities - the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
+ * @scan - V4L2_DV_INTERLACED or V4L2_DV_PROGRESSIVE
  * @fmt - the resulting timings.
  *
  * This function will attempt to detect if the given values correspond to a
@@ -124,7 +125,7 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
  * in with the found CVT timings.
  */
 bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
-		u32 polarities, struct v4l2_dv_timings *fmt);
+		u32 polarities, u32 scan, struct v4l2_dv_timings *fmt);
 
 /** v4l2_detect_gtf - detect if the given timings follow the GTF standard
  * @frame_height - the total height of the frame (including blanking) in lines.
@@ -132,6 +133,7 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
  * @vsync - the height of the vertical sync in lines.
  * @polarities - the horizontal and vertical polarities (same as struct
  *		v4l2_bt_timings polarities).
+ * @scan - V4L2_DV_INTERLACED or V4L2_DV_PROGRESSIVE
  * @aspect - preferred aspect ratio. GTF has no method of determining the
  *		aspect ratio in order to derive the image width from the
  *		image height, so it has to be passed explicitly. Usually
@@ -144,7 +146,7 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
  * in with the found GTF timings.
  */
 bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
-		u32 polarities, struct v4l2_fract aspect,
+		u32 polarities, u32 scan, struct v4l2_fract aspect,
 		struct v4l2_dv_timings *fmt);
 
 /** v4l2_calc_aspect_ratio - calculate the aspect ratio based on bytes
-- 
1.9.1

