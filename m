Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:59675 "EHLO
	bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbbDHNUa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 09:20:30 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 1/2] v4l2-dv-timings: fix rounding error in vsync_bp calculation
Date: Wed,  8 Apr 2015 18:39:28 +0530
Message-Id: <1428498569-6751-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1428498569-6751-1-git-send-email-prladdha@cisco.com>
References: <1428498569-6751-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changed the rounding offsets used in vsync_bp calculation in cvt and
gtf timings. The results for vsync_bp should now match with results
from timing generator spreadsheets for cvt and gtf standards.

In the vsync_bp calculation for cvt, always round down the value of
(CVT_MIN_VSYNC_BP / h_period_est) and then add 1. It thus, reflects
the equation used in timing generator spreadsheet. Using 1999999 as
rounding offset, could pontentially lead to bumping up the vsync_bp
value by extra 1.

In the vsync_bp calculations for gtf, instead of round up or round
down, round the (CVT_MIN_VSYNC_BP / h_period_est) to the nearest
integer.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>

Thanks to Martin Bugge <marbugge@cisco.com> for validating with
standards and suggestions on equations.

Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 80e4722..5e114ee 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -367,14 +367,14 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 	/* Vertical */
 	if (reduced_blanking) {
 		v_fp = CVT_RB_V_FPORCH;
-		v_bp = (CVT_RB_MIN_V_BLANK * hfreq + 1999999) / 1000000;
+		v_bp = (CVT_RB_MIN_V_BLANK * hfreq) / 1000000 + 1;
 		v_bp -= vsync + v_fp;
 
 		if (v_bp < CVT_RB_MIN_V_BPORCH)
 			v_bp = CVT_RB_MIN_V_BPORCH;
 	} else {
 		v_fp = CVT_MIN_V_PORCH_RND;
-		v_bp = (CVT_MIN_VSYNC_BP * hfreq + 1999999) / 1000000 - vsync;
+		v_bp = (CVT_MIN_VSYNC_BP * hfreq) / 1000000 + 1 - vsync;
 
 		if (v_bp < CVT_MIN_V_BPORCH)
 			v_bp = CVT_MIN_V_BPORCH;
@@ -543,7 +543,7 @@ bool v4l2_detect_gtf(unsigned frame_height,
 
 	/* Vertical */
 	v_fp = GTF_V_FP;
-	v_bp = (GTF_MIN_VSYNC_BP * hfreq + 999999) / 1000000 - vsync;
+	v_bp = (GTF_MIN_VSYNC_BP * hfreq + 500000) / 1000000 - vsync;
 
 	if (scan == V4L2_DV_INTERLACED)
 		image_height = (frame_height - 2 * v_fp - 2 * vsync - 2 * v_bp)
-- 
1.9.1

