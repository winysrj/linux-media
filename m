Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:16424 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbbDHNU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 09:20:26 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 2/2] v4l2-dv-timings: fix rounding in hblank and hsync calculation
Date: Wed,  8 Apr 2015 18:39:29 +0530
Message-Id: <1428498569-6751-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1428498569-6751-1-git-send-email-prladdha@cisco.com>
References: <1428498569-6751-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changed the rounding calculation for hblank and hsync to match it
to equations in standards. Currently hblank and hsync are rounded
down. hblank needs to be rounded to nearest multiple of twice the
cell granularity. hsync needs to be rounded to nearest multiple of
cell granularity.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 5e114ee..4b8ec4e 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -570,14 +570,15 @@ bool v4l2_detect_gtf(unsigned frame_height,
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

