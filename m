Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:48470 "EHLO
	bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbbEDLSB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 07:18:01 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 2/2] v4l2-utils: fix overflow in cvt, gtf calculations
Date: Mon,  4 May 2015 16:18:59 +0530
Message-Id: <1430736539-28469-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1430736539-28469-1-git-send-email-prladdha@cisco.com>
References: <1430736539-28469-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some of the intermediate calculations can exceed 32 bit signed range,
especially for higher resolutions and refresh rates. Type casting the
intermediate values to higher precision to avoid overflow.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
index 4689006..072763a 100644
--- a/utils/v4l2-ctl/v4l2-ctl-modes.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
@@ -216,7 +216,7 @@ bool calc_cvt_modeline(int image_width, int image_height,
 		if (ideal_blank_duty_cycle < 20 * HV_FACTOR)
 			ideal_blank_duty_cycle = 20 * HV_FACTOR;
 
-		h_blank = active_h_pixel * ideal_blank_duty_cycle /
+		h_blank = active_h_pixel * (long long)ideal_blank_duty_cycle /
 			 (100 * HV_FACTOR - ideal_blank_duty_cycle);
 		h_blank -= h_blank % (2 * CVT_CELL_GRAN);
 
@@ -430,7 +430,6 @@ bool calc_gtf_modeline(int image_width, int image_height,
 	tmp2 = active_v_lines + GTF_MIN_PORCH + interlace;
 
 	h_period_est = tmp1 / (tmp2 * v_refresh);
-
 	v_sync_bp = GTF_MIN_VSYNC_BP * HV_FACTOR * 100 / h_period_est;
 	v_sync_bp = (v_sync_bp + 50) / 100;
 
@@ -444,7 +443,7 @@ bool calc_gtf_modeline(int image_width, int image_height,
 	v_refresh_est = (HV_FACTOR * (long long)1000000) /
 			(h_period_est * total_v_lines / HV_FACTOR);
 
-	h_period = (h_period_est * v_refresh_est) /
+	h_period = ((long long)h_period_est * v_refresh_est) /
 		   (v_refresh * HV_FACTOR);
 
 	if (!reduced_blanking)
@@ -455,7 +454,7 @@ bool calc_gtf_modeline(int image_width, int image_height,
 				      GTF_S_M_PRIME * h_period / 1000;
 
 
-	h_blank = active_h_pixel * ideal_blank_duty_cycle /
+	h_blank = active_h_pixel * (long long)ideal_blank_duty_cycle /
 			 (100 * HV_FACTOR - ideal_blank_duty_cycle);
 	h_blank = ((h_blank + GTF_CELL_GRAN) / (2 * GTF_CELL_GRAN))
 			  * (2 * GTF_CELL_GRAN);
@@ -467,7 +466,6 @@ bool calc_gtf_modeline(int image_width, int image_height,
 
 	h_fp = h_blank / 2 - h_sync;
 	h_bp = h_fp + h_sync;
-
 	pixel_clock = ((long long)total_h_pixel * HV_FACTOR * 1000000)
 					/ h_period;
 	/* Not sure if clock value needs to be truncated to multiple
-- 
1.9.1

