Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:23398 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbbDWJ47 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 05:56:59 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH v2 1/4] v4l2-dv-timings: fix rounding error in vsync_bp calculation
Date: Wed, 22 Apr 2015 23:02:34 +0530
Message-Id: <1429723957-8308-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1429723957-8308-1-git-send-email-prladdha@cisco.com>
References: <fix for rounding errors in cvt/gtf calculation>
 <1429723957-8308-1-git-send-email-prladdha@cisco.com>
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
 drivers/media/v4l2-core/v4l2-dv-timings.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index c0e9638..32aa25f 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -368,14 +368,14 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
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
@@ -529,7 +529,8 @@ bool v4l2_detect_gtf(unsigned frame_height,
 
 	/* Vertical */
 	v_fp = GTF_V_FP;
-	v_bp = (GTF_MIN_VSYNC_BP * hfreq + 999999) / 1000000 - vsync;
+
+	v_bp = (GTF_MIN_VSYNC_BP * hfreq + 500000) / 1000000 - vsync;
 	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
 
 	if (aspect.numerator == 0 || aspect.denominator == 0) {
-- 
1.9.1

