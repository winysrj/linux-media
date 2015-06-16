Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:59372 "EHLO
	bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbbFPJ0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 05:26:54 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 1/3] v4l2-utils: handle interlace fraction correctly in gtf
Date: Tue, 16 Jun 2015 14:47:50 +0530
Message-Id: <1434446272-21256-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1434446272-21256-1-git-send-email-prladdha@cisco.com>
References: <1434446272-21256-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For interlaced format, the standards equation use interlace = 0.5.
Modified the implementation to handle this fraction correctly.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
index 7422bc5..ef528c0 100644
--- a/utils/v4l2-ctl/v4l2-ctl-modes.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
@@ -229,7 +229,6 @@ bool calc_cvt_modeline(int image_width, int image_height,
 
 		h_bp = h_blank / 2;
 		h_fp = h_blank - h_bp - h_sync;
-
 	} else {
 		/* Reduced blanking */
 
@@ -424,12 +423,12 @@ bool calc_gtf_modeline(int image_width, int image_height,
 	active_h_pixel = h_pixel_rnd;
 	active_v_lines = v_lines_rnd;
 
-		/* estimate the horizontal period */
+	/* estimate the horizontal period */
 	tmp1 = HV_FACTOR * 1000000  -
 		   GTF_MIN_VSYNC_BP * HV_FACTOR * v_refresh;
-	tmp2 = active_v_lines + GTF_MIN_PORCH + interlace;
+	tmp2 = 2 * (active_v_lines + GTF_MIN_PORCH) + interlace;
 
-	h_period_est = tmp1 / (tmp2 * v_refresh);
+	h_period_est = 2 * tmp1 / (tmp2 * v_refresh);
 
 	v_sync_bp = GTF_MIN_VSYNC_BP * HV_FACTOR * 100 / h_period_est;
 	v_sync_bp = (v_sync_bp + 50) / 100;
@@ -439,10 +438,10 @@ bool calc_gtf_modeline(int image_width, int image_height,
 	v_fp = GTF_MIN_PORCH;
 
 	v_blank = v_sync + v_bp + v_fp;
-	total_v_lines = active_v_lines + v_blank + interlace;
+	total_v_lines = active_v_lines + v_blank;
 
-	v_refresh_est = (HV_FACTOR * (long long)1000000) /
-			(h_period_est * total_v_lines / HV_FACTOR);
+	v_refresh_est = (2 * HV_FACTOR * (long long)1000000) /
+			(h_period_est * (2 * total_v_lines + interlace) / HV_FACTOR);
 
 	h_period = ((long long)h_period_est * v_refresh_est) /
 		   (v_refresh * HV_FACTOR);
@@ -454,12 +453,10 @@ bool calc_gtf_modeline(int image_width, int image_height,
 		ideal_blank_duty_cycle = (GTF_S_C_PRIME * HV_FACTOR) -
 				      GTF_S_M_PRIME * h_period / 1000;
 
-
 	h_blank = active_h_pixel * (long long)ideal_blank_duty_cycle /
 			 (100 * HV_FACTOR - ideal_blank_duty_cycle);
 	h_blank = ((h_blank + GTF_CELL_GRAN) / (2 * GTF_CELL_GRAN))
 			  * (2 * GTF_CELL_GRAN);
-
 	total_h_pixel = active_h_pixel + h_blank;
 
 	h_sync = (total_h_pixel * GTF_HSYNC_PERCENT) / 100;
@@ -475,7 +472,6 @@ bool calc_gtf_modeline(int image_width, int image_height,
 	 * truncation
 	 * */
 	/*pixel_clock -= pixel_clock  % GTF_PXL_CLK_GRAN;*/
-
 	gtf->standards 	 = V4L2_DV_BT_STD_GTF;
 
 	gtf->width       = h_pixel;
-- 
1.9.1

