Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:8420 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbbFEINe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 04:13:34 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH] v4l2-dv-timing: avoid rounding twice in gtf hblank calc
Date: Fri,  5 Jun 2015 13:43:31 +0530
Message-Id: <1433492011-28939-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, in gtf hblank calculations, the rounding is used twice,
one at intermediate division and one at final state where hblank
is rounded to nearest multiple of twice cell granularity. This
error got introduced in commit d7ed5a3, where it missed combining
the rounding step. Correcting the same in this patch.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 7e15749..0d849fc 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -586,20 +586,22 @@ bool v4l2_detect_gtf(unsigned frame_height,
 
 		num = ((image_width * GTF_D_C_PRIME * (u64)hfreq) -
 		      ((u64)image_width * GTF_D_M_PRIME * 1000));
-		den = hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000;
+		den = (hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000) *
+		      (2 * GTF_CELL_GRAN);
 		h_blank = div_u64((num + (den >> 1)), den);
+		h_blank *= (2 * GTF_CELL_GRAN);
 	} else {
 		u64 num;
 		u32 den;
 
 		num = ((image_width * GTF_S_C_PRIME * (u64)hfreq) -
 		      ((u64)image_width * GTF_S_M_PRIME * 1000));
-		den = hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000;
+		den = (hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) *
+		      (2 * GTF_CELL_GRAN);
 		h_blank = div_u64((num + (den >> 1)), den);
+		h_blank *= (2 * GTF_CELL_GRAN);
 	}
 
-	h_blank = ((h_blank + GTF_CELL_GRAN) / (2 * GTF_CELL_GRAN)) *
-		  (2 * GTF_CELL_GRAN);
 	frame_width = image_width + h_blank;
 
 	pix_clk = (image_width + h_blank) * hfreq;
-- 
1.9.1

