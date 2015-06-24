Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:60938 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbbFXOAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 10:00:00 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH v2 1/2] v4l2-utils: add support for reduced fps in cvt modeline
Date: Wed, 24 Jun 2015 19:29:55 +0530
Message-Id: <1435154396-11548-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1435154396-11548-1-git-send-email-prladdha@cisco.com>
References: <1435154396-11548-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added reduced fps option in cvt timings calculation. In this case,
pixel clock is slowed down by a factor of 1000 / 1001 and all other
timing parameters are unchanged. With reduced fps option one could
generate timings for refresh rates like 29.97 or 59.94. Pixel clock
in this case needs better precision, in the order of 0.001 Khz and
hence reduced fps option can be supported only when reduced blanking
V2 is enabled. Reduced fps is applicable only to nominal refresh
rates which are integer multiple of 6, say 24, 30, 60 etc.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 7 ++++++-
 utils/v4l2-ctl/v4l2-ctl-stds.cpp  | 2 +-
 utils/v4l2-ctl/v4l2-ctl.h         | 3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
index 88f7b6a..9439b51 100644
--- a/utils/v4l2-ctl/v4l2-ctl-modes.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
@@ -122,6 +122,7 @@ static int v_sync_from_aspect_ratio(int width, int height)
  * @reduced_blanking: This value, if greater than 0, indicates that
  * reduced blanking is to be used and value indicates the version.
  * @interlaced: whether to compute an interlaced mode
+ * @reduced_fps: reduce fps by factor of 1000 / 1001
  * @cvt: stores results of cvt timing calculation
  *
  * Returns:
@@ -131,7 +132,8 @@ static int v_sync_from_aspect_ratio(int width, int height)
 
 bool calc_cvt_modeline(int image_width, int image_height,
 		       int refresh_rate, int reduced_blanking,
-		       bool interlaced, struct v4l2_bt_timings *cvt)
+		       bool interlaced, bool reduced_fps,
+		       struct v4l2_bt_timings *cvt)
 {
 	int h_sync;
 	int v_sync;
@@ -295,6 +297,9 @@ bool calc_cvt_modeline(int image_width, int image_height,
 
 		pixel_clock = v_refresh * total_h_pixel *
 			      (2 * total_v_lines + interlace) / 2;
+		if (reduced_fps && v_refresh % 6 == 0)
+			pixel_clock = ((long long)pixel_clock * 1000) / 1001;
+
 		pixel_clock -= pixel_clock  % clk_gran;
 	}
 
diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
index aea46c9..e969d08 100644
--- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
@@ -241,7 +241,7 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 
 	if (standard == V4L2_DV_BT_STD_CVT) {
 		timings_valid = calc_cvt_modeline(width, height, fps, r_blank,
-						  interlaced == 1 ? true : false, bt);
+						  interlaced == 1 ? true : false, false, bt);
 	} else {
 		timings_valid = calc_gtf_modeline(width, height, fps, r_blank,
 						  interlaced == 1 ? true : false, bt);
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index de65900..113f348 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -351,7 +351,8 @@ void edid_get(int fd);
 /* v4l2-ctl-modes.cpp */
 bool calc_cvt_modeline(int image_width, int image_height,
 		       int refresh_rate, int reduced_blanking,
-		       bool interlaced, struct v4l2_bt_timings *cvt);
+		       bool interlaced, bool reduced_fps,
+		       struct v4l2_bt_timings *cvt);
 
 bool calc_gtf_modeline(int image_width, int image_height,
 		       int refresh_rate, int reduced_blanking,
-- 
1.9.1

