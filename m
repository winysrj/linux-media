Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:54105 "EHLO
	rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbbEDKBX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 06:01:23 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH] v4l2-dv-timings: fix overflow in gtf timings calculation
Date: Sat,  2 May 2015 22:53:06 +0530
Message-Id: <1430587386-28409-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The intermediate calculation in the expression for hblank can exceed
32 bit signed range. This overflow can lead to negative values for
hblank. Typecasting intermediate variable to higher precision.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 86e11d1..9d27f05 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -573,15 +573,15 @@ bool v4l2_detect_gtf(unsigned frame_height,
 
 	/* Horizontal */
 	if (default_gtf)
-		h_blank = ((image_width * GTF_D_C_PRIME * hfreq) -
-					(image_width * GTF_D_M_PRIME * 1000) +
-			(hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000) / 2) /
-			(hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000);
+		h_blank = ((image_width * GTF_D_C_PRIME * (long long)hfreq) -
+			  ((long long)image_width * GTF_D_M_PRIME * 1000) +
+			  ((long long)hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000) / 2) /
+			  ((long long)hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000);
 	else
-		h_blank = ((image_width * GTF_S_C_PRIME * hfreq) -
-					(image_width * GTF_S_M_PRIME * 1000) +
-			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) / 2) /
-			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000);
+		h_blank = ((image_width * GTF_S_C_PRIME * (long long)hfreq) -
+			  ((long long)image_width * GTF_S_M_PRIME * 1000) +
+			  ((long long)hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) / 2) /
+			  ((long long)hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000);
 
 	h_blank = ((h_blank + GTF_CELL_GRAN) / (2 * GTF_CELL_GRAN)) *
 		  (2 * GTF_CELL_GRAN);
-- 
1.9.1

