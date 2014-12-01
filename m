Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:50620 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaLAJN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 04:13:27 -0500
From: Prashant Laddha <prladdha@cisco.com>
To: <hverkuil@xs4all.nl>
Cc: Prashant Laddha <prladdha@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] Vivid sine gen: Use higher precision for sine LUT
Date: Mon,  1 Dec 2014 14:33:24 +0530
Message-Id: <1417424604-17340-5-git-send-email-prladdha@cisco.com>
In-Reply-To: <1417424604-17340-1-git-send-email-prladdha@cisco.com>
References: <1417424604-17340-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sin LUT is recalculated with precision of 16 bits to represent
fractional part. (lowest fraction that can be represented now
is 1/2^16, that is 0.000015)

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-sdr-cap.c | 11 +++--------
 drivers/media/platform/vivid/vivid-sin.c     | 17 ++++++++++-------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 99fc2c7..d58f329 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -457,9 +457,6 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 		while(dev->sdr_fixp_src_phase >= ((44 << FIX_PT_PREC)/7))
 			dev->sdr_fixp_src_phase -= ((44 << FIX_PT_PREC)/7);
 
-		mod_phase_inc <<= FIX_PT_PREC;
-		mod_phase_inc /= 1275;
-
 		dev->sdr_fixp_mod_phase += mod_phase_inc;
 
 		while(dev->sdr_fixp_mod_phase < 0)
@@ -472,12 +469,10 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 		fixp_q = calc_cos(dev->sdr_fixp_mod_phase);
 
 		/* convert 'fixp float' to u8 */
-		/* u8 = X * 127.5f + 127.5f; where X is float [-1.0 / +1.0]
-		The values stored in sin look table are pre-multipied with 1275.
-		So, only do addition */
+		/* u8 = X * 127.5f + 127.5f; where X is float [-1.0 / +1.0] */
 
-		fixp_i += 1275;
-		fixp_q += 1275;
+		fixp_i = fixp_i * 1275 + 1275;
+		fixp_q = fixp_p * 1275 + 1275;
 		*vbuf++ = DIV_ROUND_CLOSEST(fixp_i, 10);
 		*vbuf++ = DIV_ROUND_CLOSEST(fixp_q, 10);
 	}
diff --git a/drivers/media/platform/vivid/vivid-sin.c b/drivers/media/platform/vivid/vivid-sin.c
index 35bf495..81486ff 100644
--- a/drivers/media/platform/vivid/vivid-sin.c
+++ b/drivers/media/platform/vivid/vivid-sin.c
@@ -25,13 +25,16 @@
 #define SIN_LUT_SIZE 256
 
 static s32 sin[65] = {
-		 0,   31,   63,   94,  125,  156,  187,  218,  249,  279,  310,  340,
-       370,  400,  430,  459,  488,  517,  545,  573,  601,  628,  655,  682,
-       708,  734,  760,  784,  809,  833,  856,  879,  902,  923,  945,  965,
-       986, 1005, 1024, 1042, 1060, 1077, 1094, 1109, 1124, 1139, 1153, 1166,
-      1178, 1190, 1200, 1211, 1220, 1229, 1237, 1244, 1251, 1256, 1261, 1265,
-      1269, 1272, 1273, 1275, 1275
-      };
+	     0,  1608,  3216,  4821,  6424,  8022,  9616, 11204,
+	 12785, 14359, 15924, 17479, 19024, 20557, 22078, 23586,
+	 25080, 26558, 28020, 29466, 30893, 32303, 33692, 35062,
+	 36410, 37736, 39040, 40320, 41576, 42806, 44011, 45190,
+	 46341,	47464, 48559, 49624, 50660, 51665, 52639, 53581,
+	 54491,	55368, 56212, 57022, 57798, 58538, 59244, 59914,
+	 60547,	61145, 61705, 62228, 62714, 63162, 63572, 63944,
+	 64277,	64571, 64827, 65043, 65220, 65358, 65457, 65516,
+	 65536
+	};
 
 static s32 get_sin_val(u32 index)
 {
-- 
1.9.1

