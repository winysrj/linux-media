Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:34880 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423270AbbEENQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 09:16:31 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH v2] v4l2-dv-timings: fix overflow in gtf timings calculation
Date: Tue,  5 May 2015 18:46:27 +0530
Message-Id: <1430831787-16714-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1430831787-16714-1-git-send-email-prladdha@cisco.com>
References: <1430831787-16714-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The intermediate calculation in the expression for hblank can exceed
32 bit signed range. This overflow can lead to negative values for
hblank. Typecasting intermediate variable to higher precision.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 86e11d1..3e14dc4 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -25,6 +25,7 @@
 #include <linux/videodev2.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-dv-timings.h>
+#include <linux/math64.h>
 
 MODULE_AUTHOR("Hans Verkuil");
 MODULE_DESCRIPTION("V4L2 DV Timings Helper Functions");
@@ -572,16 +573,25 @@ bool v4l2_detect_gtf(unsigned frame_height,
 	image_width = (image_width + GTF_CELL_GRAN/2) & ~(GTF_CELL_GRAN - 1);
 
 	/* Horizontal */
-	if (default_gtf)
-		h_blank = ((image_width * GTF_D_C_PRIME * hfreq) -
-					(image_width * GTF_D_M_PRIME * 1000) +
-			(hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000) / 2) /
-			(hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000);
-	else
-		h_blank = ((image_width * GTF_S_C_PRIME * hfreq) -
-					(image_width * GTF_S_M_PRIME * 1000) +
-			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) / 2) /
-			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000);
+	if (default_gtf) {
+		u64 num;
+		u64 den;
+
+		num = ((image_width * GTF_D_C_PRIME * (u64)hfreq) -
+		      ((u64)image_width * GTF_D_M_PRIME * 1000));
+		den = ((u64)hfreq * (100 - GTF_D_C_PRIME) +
+		      GTF_D_M_PRIME * 1000);
+		h_blank = div_u64((num + (den >> 1)), den);
+	} else {
+		u64 num;
+		u64 den;
+
+		num = ((image_width * GTF_S_C_PRIME * (u64)hfreq) -
+		      ((u64)image_width * GTF_S_M_PRIME * 1000));
+		den = ((u64)hfreq * (100 - GTF_S_C_PRIME) +
+		      GTF_S_M_PRIME * 1000);
+		h_blank = div_u64((num + (den >> 1)), den);
+	}
 
 	h_blank = ((h_blank + GTF_CELL_GRAN) / (2 * GTF_CELL_GRAN)) *
 		  (2 * GTF_CELL_GRAN);
-- 
1.9.1

