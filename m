Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:30564 "EHLO
	bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaLOJTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 04:19:35 -0500
From: Prashant Laddha <prladdha@cisco.com>
To: <hverkuil@xs4all.nl>
Cc: Prashant Laddha <prladdha@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/6] Vivid sine gen: Optimization for sine LUT size
Date: Mon, 15 Dec 2014 14:49:18 +0530
Message-Id: <1418635162-8814-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1418635162-8814-1-git-send-email-prladdha@cisco.com>
References: <1418635162-8814-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exploiting the symmetry and repetitive nature of sine waveform
to reduce size of sine LUT. Values up to phase <= pi/4, can be
used to calculate sine for remaining phases.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-sin.c | 74 ++++++++++++++------------------
 1 file changed, 32 insertions(+), 42 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-sin.c b/drivers/media/platform/vivid/vivid-sin.c
index e3d6149..2ed9f7f 100644
--- a/drivers/media/platform/vivid/vivid-sin.c
+++ b/drivers/media/platform/vivid/vivid-sin.c
@@ -25,46 +25,38 @@
 
 #define SIN_TAB_SIZE 256
 
-	/*TODO- Reduce the size of the table */
-/* Since sinewave is symmetric, it can be represented using only quarter
-   of the samples compared to the number of samples used below  */
-
-static s32 sin[257] = {
-	     0,    31,    63,    94,   125,   156,   187,   218,
-	   249,   279,   310,   340,   370,   400,   430,   459,
-	   488,   517,   545,   573,   601,   628,   655,   682,
-	   708,   734,   760,   784,   809,   833,   856,   879,
-	   902,   923,   945,   965,   986,  1005,  1024,  1042,
-	  1060,  1077,  1094,  1109,  1124,  1139,  1153,  1166,
-	  1178,  1190,  1200,  1211,  1220,  1229,  1237,  1244,
-	  1251,  1256,  1261,  1265,  1269,  1272,  1273,  1275,
-	  1275,  1275,  1273,  1272,  1269,  1265,  1261,  1256,
-	  1251,  1244,  1237,  1229,  1220,  1211,  1200,  1190,
-	  1178,  1166,  1153,  1139,  1124,  1109,  1094,  1077,
-	  1060,  1042,  1024,  1005,   986,   965,   945,   923,
-	   902,   879,   856,   833,   809,   784,   760,   734,
-	   708,   682,   655,   628,   601,   573,   545,   517,
-	   488,   459,   430,   400,   370,   340,   310,   279,
-	   249,   218,   187,   156,   125,    94,    63,    31,
-	     0,   -31,   -63,   -94,  -125,   156,  -187,  -218,
-	  -249,  -279,  -310,  -340,  -370,  -400,  -430,  -459,
-	  -488,  -517,  -545,  -573,  -601,  -628,  -655,  -682,
-	  -708,  -734,  -760,  -784,  -809,  -833,  -856,  -879,
-	  -902,  -923,  -945,  -965,  -986, -1005, -1024, -1042,
-	 -1060, -1077, -1094, -1109, -1124, -1139, -1153, -1166,
-	 -1178, -1190, -1200, -1211, -1220, -1229, -1237, -1244,
-	 -1251, -1256, -1261, -1265, -1269, -1272, -1273, -1275,
-	 -1275, -1275, -1273, -1272, -1269, -1265, -1261, -1256,
-	 -1251, -1244, -1237, -1229, -1220, -1211, -1200, -1190,
-	 -1178, -1166, -1153, -1139, -1124, -1109, -1094, -1077,
-	 -1060, -1042, -1024, -1005,  -986,  -965,  -945,  -923,
-	  -902,  -879,  -856,  -833,  -809,  -784,  -760,  -734,
-	  -708,  -682,  -655,  -628,  -601,  -573,  -545,  -517,
-	  -488,  -459,  -430,  -400,  -370,  -340,  -310,  -279,
-	  -249,  -218,  -187,  -156,  -125,   -94,   -63,   -31,
-	     0
+static s32 sin[65] = {
+	   0,   31,   63,   94,  125,  156,  187,  218,  249,  279,  310,  340,
+	 370,  400,  430,  459,  488,  517,  545,  573,  601,  628,  655,  682,
+	 708,  734,  760,  784,  809,  833,  856,  879,  902,  923,  945,  965,
+	 986, 1005, 1024, 1042, 1060, 1077, 1094, 1109, 1124, 1139, 1153, 1166,
+	1178, 1190, 1200, 1211, 1220, 1229, 1237, 1244, 1251, 1256, 1261, 1265,
+	1269, 1272, 1273, 1275, 1275
 	};
 
+static s32 get_sin_val(u32 index)
+{
+	u32 tab_index;
+	u32 new_index;
+
+	if (index <= 64)
+		return sin[index];
+	else if (index > 64 && index <= 128) {
+		tab_index = 64 - (index - 64);
+		return sin[tab_index];
+	} else if (index > 128 && index <= 192) {
+		tab_index = index - 128;
+		return (-1) * sin[tab_index];
+	} else if (index > 192 && index <= 255) {
+		tab_index = 64 - (index - 192);
+		return (-1) * sin[tab_index];
+	}
+
+	new_index = index % 256;
+	return get_sin_val(new_index);
+
+}
+
 /*
  * Calculation of sine is implemented using a look up table for range of
  * phase values from 0 to 2*pi. Look table contains finite entries, say N.
@@ -142,8 +134,7 @@ s32 calc_sin(u32 phase)
 	d1 =  temp0 - temp1;
 	d0 = (1 << FIX_PT_PREC) - d1;
 
-	result = (d0 * sin[index % 256] + d1 * sin[(index+1)%256]);
-
+	result = d0 * get_sin_val(index) + d1 * get_sin_val(index+1);
 	return result >> FIX_PT_PREC;
 }
 
@@ -166,8 +157,7 @@ s32 calc_cos(u32 phase)
 	d0 = (1 << FIX_PT_PREC) - d1;
 
 	index += 64;
-	result = (d0 * sin[index % 256] + d1 * sin[(index+1)%256]);
-
+	result = d0 * get_sin_val(index) + d1 * get_sin_val(index+1);
 	return result >> FIX_PT_PREC;
 }
 
-- 
1.9.1

