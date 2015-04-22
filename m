Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:40961 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191AbbDWJ5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 05:57:03 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH v2 4/4] v4l2-dv-timings: replace hsync magic number with a macro
Date: Wed, 22 Apr 2015 23:02:37 +0530
Message-Id: <1429723957-8308-5-git-send-email-prladdha@cisco.com>
In-Reply-To: <1429723957-8308-1-git-send-email-prladdha@cisco.com>
References: <fix for rounding errors in cvt/gtf calculation>
 <1429723957-8308-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change will not change timing calculation. In CVT generator
spreadsheet the nominal value of hsync (as a percentage of line)
is 8 percent.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 4e09792..37f0d6f 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -313,6 +313,7 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
 #define CVT_MIN_V_BPORCH	7	/* lines */
 #define CVT_MIN_V_PORCH_RND	3	/* lines */
 #define CVT_MIN_VSYNC_BP	550	/* min time of vsync + back porch (us) */
+#define CVT_HSYNC_PERCENT       8       /* nominal hsync as percentage of line */
 
 /* Normal blanking for CVT uses GTF to calculate horizontal blanking */
 #define CVT_CELL_GRAN		8	/* character cell granularity */
@@ -442,7 +443,7 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 		h_bp = h_blank / 2;
 		frame_width = image_width + h_blank;
 
-		hsync = frame_width * 8 / 100;
+		hsync = frame_width * CVT_HSYNC_PERCENT / 100;
 		hsync = (hsync / CVT_CELL_GRAN) * CVT_CELL_GRAN;
 		h_fp = h_blank - hsync - h_bp;
 	}
-- 
1.9.1

