Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:11187 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202AbbFPJ0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 05:26:48 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 3/3] v4l2-utils: fix pixel clock calc for cvt reduced blanking
Date: Tue, 16 Jun 2015 14:47:52 +0530
Message-Id: <1434446272-21256-4-git-send-email-prladdha@cisco.com>
In-Reply-To: <1434446272-21256-1-git-send-email-prladdha@cisco.com>
References: <1434446272-21256-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case of CVT reduced blanking, pixel clock calculation does not
use h period estimates, it rather directly uses refresh rate and
total vertical lines. This difference can lead to a minor mismatch
between the pixel clocks calculated by v4l2-utils and the standards
spreadsheet.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
index d65cd75..7768998 100644
--- a/utils/v4l2-ctl/v4l2-ctl-modes.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
@@ -139,6 +139,7 @@ bool calc_cvt_modeline(int image_width, int image_height,
 	int active_h_pixel;
 	int active_v_lines;
 	int total_h_pixel;
+	int total_v_lines;
 
 	int h_blank;
 	int v_blank;
@@ -229,6 +230,10 @@ bool calc_cvt_modeline(int image_width, int image_height,
 
 		h_bp = h_blank / 2;
 		h_fp = h_blank - h_bp - h_sync;
+
+		pixel_clock =  ((long long)total_h_pixel * HV_FACTOR * 1000000)
+				/ h_period;
+		pixel_clock -= pixel_clock  % CVT_PXL_CLK_GRAN;
 	} else {
 		/* Reduced blanking */
 
@@ -247,11 +252,12 @@ bool calc_cvt_modeline(int image_width, int image_height,
 		if (vbi_lines < (CVT_RB_V_FPORCH + v_sync + CVT_MIN_V_BPORCH))
 			vbi_lines = CVT_RB_V_FPORCH + v_sync + CVT_MIN_V_BPORCH;
 
-		total_h_pixel = active_h_pixel + CVT_RB_H_BLANK;
-
 		h_blank = CVT_RB_H_BLANK;
 		v_blank = vbi_lines;
 
+		total_h_pixel = active_h_pixel + h_blank;
+		total_v_lines = active_v_lines + v_blank;
+
 		h_sync = CVT_RB_H_SYNC;
 
 		h_bp = h_blank / 2;
@@ -259,11 +265,11 @@ bool calc_cvt_modeline(int image_width, int image_height,
 
 		v_fp = CVT_RB_V_FPORCH;
 		v_bp = v_blank - v_fp - v_sync;
-	}
 
-	pixel_clock =  ((long long)total_h_pixel * HV_FACTOR * 1000000)
-			/ h_period;
-	pixel_clock -= pixel_clock  % CVT_PXL_CLK_GRAN;
+		pixel_clock = v_refresh * total_h_pixel *
+			      (2 * total_v_lines + interlace) / 2;
+		pixel_clock -= pixel_clock  % CVT_PXL_CLK_GRAN;
+	}
 
 	cvt->standards 	 = V4L2_DV_BT_STD_CVT;
 
-- 
1.9.1

