Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:62885 "EHLO
	bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988AbbDWJ47 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 05:56:59 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH v2 3/4] v4l2-dv-timings: add sanity checks in cvt,gtf calculations
Date: Wed, 22 Apr 2015 23:02:36 +0530
Message-Id: <1429723957-8308-4-git-send-email-prladdha@cisco.com>
In-Reply-To: <1429723957-8308-1-git-send-email-prladdha@cisco.com>
References: <fix for rounding errors in cvt/gtf calculation>
 <1429723957-8308-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wrong values of hfreq and image height can lead to strange timings.
Avoid timing calculations for such values.

Suggested By: Martin Bugge <marbugge@cisco.com>

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 16c8ac5..4e09792 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -365,6 +365,9 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 	else
 		return false;
 
+	if (hfreq == 0)
+		return false;
+
 	/* Vertical */
 	if (reduced_blanking) {
 		v_fp = CVT_RB_V_FPORCH;
@@ -382,6 +385,9 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 	}
 	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
 
+	if (image_height < 0)
+		return false;
+
 	/* Aspect ratio based on vsync */
 	switch (vsync) {
 	case 4:
@@ -527,12 +533,18 @@ bool v4l2_detect_gtf(unsigned frame_height,
 	else
 		return false;
 
+	if (hfreq == 0)
+		return false;
+
 	/* Vertical */
 	v_fp = GTF_V_FP;
 
 	v_bp = (GTF_MIN_VSYNC_BP * hfreq + 500000) / 1000000 - vsync;
 	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
 
+	if (image_height < 0)
+		return false;
+
 	if (aspect.numerator == 0 || aspect.denominator == 0) {
 		aspect.numerator = 16;
 		aspect.denominator = 9;
-- 
1.9.1

