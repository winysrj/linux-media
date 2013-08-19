Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2165 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3HSOom (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 01/20] v4l2-dv-timings: fix CVT calculation
Date: Mon, 19 Aug 2013 16:44:10 +0200
Message-Id: <1376923469-30694-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

This patch fixes two errors that caused incorrect format detections:

The first bug is in the calculation of the vertical backporch: the combined
period of vsync and backporch must *exceed* a certain minimum value, and not
be equal to it.

The second bug is a rounding error in the reduced blanking calculation:
expand the ideal_duty_cylce to be in parts per ten thousand to avoid
rounding errors.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Cc: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index f20b316..72cf224 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -286,14 +286,14 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 	/* Vertical */
 	if (reduced_blanking) {
 		v_fp = CVT_RB_V_FPORCH;
-		v_bp = (CVT_RB_MIN_V_BLANK * hfreq + 999999) / 1000000;
+		v_bp = (CVT_RB_MIN_V_BLANK * hfreq + 1999999) / 1000000;
 		v_bp -= vsync + v_fp;
 
 		if (v_bp < CVT_RB_MIN_V_BPORCH)
 			v_bp = CVT_RB_MIN_V_BPORCH;
 	} else {
 		v_fp = CVT_MIN_V_PORCH_RND;
-		v_bp = (CVT_MIN_VSYNC_BP * hfreq + 999999) / 1000000 - vsync;
+		v_bp = (CVT_MIN_VSYNC_BP * hfreq + 1999999) / 1000000 - vsync;
 
 		if (v_bp < CVT_MIN_V_BPORCH)
 			v_bp = CVT_MIN_V_BPORCH;
@@ -337,17 +337,16 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 
 		frame_width = image_width + CVT_RB_H_BLANK;
 	} else {
+		unsigned ideal_duty_cycle_per_myriad =
+			100 * CVT_C_PRIME - (CVT_M_PRIME * 100000) / hfreq;
 		int h_blank;
-		unsigned ideal_duty_cycle = CVT_C_PRIME - (CVT_M_PRIME * 1000) / hfreq;
 
-		h_blank = (image_width * ideal_duty_cycle + (100 - ideal_duty_cycle) / 2) /
-						(100 - ideal_duty_cycle);
-		h_blank = h_blank - h_blank % (2 * CVT_CELL_GRAN);
+		if (ideal_duty_cycle_per_myriad < 2000)
+			ideal_duty_cycle_per_myriad = 2000;
 
-		if (h_blank * 100 / image_width < 20) {
-			h_blank = image_width / 5;
-			h_blank = (h_blank + 0x7) & ~0x7;
-		}
+		h_blank = image_width * ideal_duty_cycle_per_myriad /
+					(10000 - ideal_duty_cycle_per_myriad);
+		h_blank = (h_blank / (2 * CVT_CELL_GRAN)) * 2 * CVT_CELL_GRAN;
 
 		pix_clk = (image_width + h_blank) * hfreq;
 		pix_clk = (pix_clk / CVT_PXL_CLK_GRAN) * CVT_PXL_CLK_GRAN;
-- 
1.8.3.2

