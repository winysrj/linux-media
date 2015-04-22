Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:44855 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125AbbDWJ5B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 05:57:01 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH v2 2/4] v4l2-dv-timings: fix rounding in hblank and hsync calculation
Date: Wed, 22 Apr 2015 23:02:35 +0530
Message-Id: <1429723957-8308-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1429723957-8308-1-git-send-email-prladdha@cisco.com>
References: <fix for rounding errors in cvt/gtf calculation>
 <1429723957-8308-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changed the rounding calculation for hblank and hsync to match it
to equations in cvt and gtf standards.

In cvt calculation, hsync needs to be rounded down.

In gtf calculations, hblank needs to be rounded to nearest multiple
of twice the cell granularity and hsync needs to be rounded to the
nearest multiple of cell granularity.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 32aa25f..16c8ac5 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -436,8 +436,8 @@ bool v4l2_detect_cvt(unsigned frame_height, unsigned hfreq, unsigned vsync,
 		h_bp = h_blank / 2;
 		frame_width = image_width + h_blank;
 
-		hsync = (frame_width * 8 + 50) / 100;
-		hsync = hsync - hsync % CVT_CELL_GRAN;
+		hsync = frame_width * 8 / 100;
+		hsync = (hsync / CVT_CELL_GRAN) * CVT_CELL_GRAN;
 		h_fp = h_blank - hsync - h_bp;
 	}
 
@@ -552,14 +552,15 @@ bool v4l2_detect_gtf(unsigned frame_height,
 			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) / 2) /
 			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000);
 
-	h_blank = h_blank - h_blank % (2 * GTF_CELL_GRAN);
+	h_blank = ((h_blank + GTF_CELL_GRAN) / (2 * GTF_CELL_GRAN)) *
+		  (2 * GTF_CELL_GRAN);
 	frame_width = image_width + h_blank;
 
 	pix_clk = (image_width + h_blank) * hfreq;
 	pix_clk = pix_clk / GTF_PXL_CLK_GRAN * GTF_PXL_CLK_GRAN;
 
 	hsync = (frame_width * 8 + 50) / 100;
-	hsync = hsync - hsync % GTF_CELL_GRAN;
+	hsync = ((hsync + GTF_CELL_GRAN / 2) / GTF_CELL_GRAN) * GTF_CELL_GRAN;
 
 	h_fp = h_blank / 2 - hsync;
 
-- 
1.9.1

