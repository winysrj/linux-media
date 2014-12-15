Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:9372 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaLOJTl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 04:19:41 -0500
From: Prashant Laddha <prladdha@cisco.com>
To: <hverkuil@xs4all.nl>
Cc: Prashant Laddha <prladdha@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/6] Vivid: Increased precision for (co)sine computation
Date: Mon, 15 Dec 2014 14:49:21 +0530
Message-Id: <1418635162-8814-6-git-send-email-prladdha@cisco.com>
In-Reply-To: <1418635162-8814-1-git-send-email-prladdha@cisco.com>
References: <1418635162-8814-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1.sin LUT is recomputed with precision of 16 bits to represent
fractional part. (lowest fraction that can be represented now
is 1/2^16, that is 0.000015).

2.Instead of using PI = 22/7 in intermediate calculation, use
precomputed value for 2PI

3 To avoid overflows, use 64 bit variables for intermediate
calculations

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.h    |  4 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c | 33 +++++-----
 drivers/media/platform/vivid/vivid-sin.c     | 94 ++++++++++++++++------------
 drivers/media/platform/vivid/vivid-sin.h     |  9 +--
 4 files changed, 78 insertions(+), 62 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 6f4445a..ea5c5c8 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -434,8 +434,8 @@ struct vivid_dev {
 	struct list_head		sdr_cap_active;
 	unsigned			sdr_adc_freq;
 	unsigned			sdr_fm_freq;
-	int				sdr_fixp_src_phase;
-	int				sdr_fixp_mod_phase;
+	s64				sdr_fixp_src_phase;
+	s64				sdr_fixp_mod_phase;
 
 	bool				tstamp_src_is_soe;
 	bool				has_crop_cap;
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 1f8b328..1e5abd7 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -429,12 +429,16 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
 	unsigned long i;
 	unsigned long plane_size = vb2_plane_size(&buf->vb, 0);
-	int fixp_i, fixp_q;
+	s64 fixp_i;
+	s64 fixp_q;
 
 	u32 adc_freq;
 	u32 sig_freq;
-	s32 src_phase_inc;
-	s32 mod_phase_inc;
+	s64 src_phase_inc;
+	s64 mod_phase_inc;
+	s64 signal_offset = 1275; /* 127.5 would be added modulated signal*/
+
+	signal_offset <<= FIX_PT_PREC;
 
 	/*
 	 * TODO: Generated beep tone goes very crackly when sample rate is
@@ -454,30 +458,27 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 		mod_phase_inc = calc_cos(dev->sdr_fixp_src_phase);
 		dev->sdr_fixp_src_phase += src_phase_inc;
 
-		while (dev->sdr_fixp_src_phase >= ((44 << FIX_PT_PREC)/7))
-			dev->sdr_fixp_src_phase -= ((44 << FIX_PT_PREC)/7);
-
-		mod_phase_inc <<= FIX_PT_PREC;
-		mod_phase_inc /= 1275;
+		while (dev->sdr_fixp_src_phase >= FIX_PT_2PI)
+			dev->sdr_fixp_src_phase -= FIX_PT_2PI;
 
 		dev->sdr_fixp_mod_phase += mod_phase_inc;
 
 		while (dev->sdr_fixp_mod_phase < 0)
-			dev->sdr_fixp_mod_phase += ((44 << FIX_PT_PREC) / 7);
+			dev->sdr_fixp_mod_phase += FIX_PT_2PI;
 
-		while (dev->sdr_fixp_mod_phase >= ((44 << FIX_PT_PREC) / 7))
-			dev->sdr_fixp_mod_phase -= ((44 << FIX_PT_PREC) / 7);
+		while (dev->sdr_fixp_mod_phase >= FIX_PT_2PI)
+			dev->sdr_fixp_mod_phase -= FIX_PT_2PI;
 
 		fixp_i = calc_sin(dev->sdr_fixp_mod_phase);
 		fixp_q = calc_cos(dev->sdr_fixp_mod_phase);
 
 		/* convert 'fixp float' to u8 */
-		/* u8 = X * 127.5f + 127.5f; where X is float [-1.0 / +1.0]
-		The values stored in sin look table are pre-multipied with 1275.
-		So, only do addition */
+		/* u8 = X * 127.5f + 127.5f; where X is float [-1.0 / +1.0] */
 
-		fixp_i += 1275;
-		fixp_q += 1275;
+		fixp_i = fixp_i * 1275 + signal_offset;
+		fixp_q = fixp_q * 1275 + signal_offset;
+		fixp_i >>= FIX_PT_PREC;
+		fixp_q >>= FIX_PT_PREC;
 		*vbuf++ = DIV_ROUND_CLOSEST(fixp_i, 10);
 		*vbuf++ = DIV_ROUND_CLOSEST(fixp_q, 10);
 	}
diff --git a/drivers/media/platform/vivid/vivid-sin.c b/drivers/media/platform/vivid/vivid-sin.c
index 1ba6df9..24680ea 100644
--- a/drivers/media/platform/vivid/vivid-sin.c
+++ b/drivers/media/platform/vivid/vivid-sin.c
@@ -26,19 +26,23 @@
 #define SIN_LUT_SIZE 256
 
 static s32 sin[65] = {
-	   0,   31,   63,   94,  125,  156,  187,  218,  249,  279,  310,  340,
-	 370,  400,  430,  459,  488,  517,  545,  573,  601,  628,  655,  682,
-	 708,  734,  760,  784,  809,  833,  856,  879,  902,  923,  945,  965,
-	 986, 1005, 1024, 1042, 1060, 1077, 1094, 1109, 1124, 1139, 1153, 1166,
-	1178, 1190, 1200, 1211, 1220, 1229, 1237, 1244, 1251, 1256, 1261, 1265,
-	1269, 1272, 1273, 1275, 1275
+	    0,   1608,  3216,  4821,  6424,  8022,  9616, 11204,
+	12785,  14359, 15924, 17479, 19024, 20557, 22078, 23586,
+	25080,  26558, 28020, 29466, 30893, 32303, 33692, 35062,
+	36410,  37736, 39040, 40320, 41576, 42806, 44011, 45190,
+	46341,	47464, 48559, 49624, 50660, 51665, 52639, 53581,
+	54491,	55368, 56212, 57022, 57798, 58538, 59244, 59914,
+	60547,	61145, 61705, 62228, 62714, 63162, 63572, 63944,
+	64277,	64571, 64827, 65043, 65220, 65358, 65457, 65516,
+	65536
 	};
 
-static s32 get_sin_val(u32 index)
+static s64 get_sin_val(u32 index)
 {
 	s32 sign = 1;
 	u32 tab_index;
 	u32 new_index;
+	s64 result;
 
 	new_index = index & 0xFF; /* new_index = index % 256*/
 
@@ -52,7 +56,12 @@ static s32 get_sin_val(u32 index)
 	else
 		tab_index = 64 - (new_index - 64);
 
-	return sign * sin[tab_index];
+	/* If fixed point precision is more than the precision used to compute
+	 * sin table (16 bit currently), then multiply sine values */
+
+	result = sin[tab_index] << (FIX_PT_PREC - 16);
+
+	return sign * result;
 }
 
 /*
@@ -111,62 +120,67 @@ static s32 get_sin_val(u32 index)
  * 4. To improve the precision of fixed point implementations, divisions
  *    in different calculations are delayed till last operations. Say,
  *    d0 = phi - n*(2*pi / N)
- *    d0 = phi - n * (2 * (22 / 7) / N) , substitute pi = 22 / 7
- *    d0 = phi - (n * 44 * N) / 7
  */
-s32 calc_sin(u32 phase)
+s64 calc_sin(u64 phase)
 {
-	u32 index;
-	u32 d0;
-	u32 d1;
-	s32 result;
+	u64 index;
+	u64 d0;
+	u64 d1;
+	s64 result;
 	u64 temp0;
 	u64 temp1;
 
 	temp0 = phase * SIN_LUT_SIZE;
-	index = (temp0 * 7) / (44 << FIX_PT_PREC);
+	index = temp0 / (u64)(FIX_PT_2PI);
 
-	temp0 = (temp0 * 7) / 44;
-	temp1 = index << FIX_PT_PREC;
+	temp1 = index * (u64)(FIX_PT_2PI);
+	temp1 /= SIN_LUT_SIZE;
 
-	d1 =  temp0 - temp1;
-	d0 = (1 << FIX_PT_PREC) - d1;
+	d1 =  phase - temp1;
+	d0 = (1ULL << FIX_PT_PREC) - d1;
 
 	result = d0 * get_sin_val(index) + d1 * get_sin_val(index+1);
 	return result >> FIX_PT_PREC;
 }
 
-s32 calc_cos(u32 phase)
+s64 calc_cos(u64 phase)
 {
-	u32 index;
-	u32 d0;
-	u32 d1;
-	s32 result;
+	u64 index;
+	u64 d0;
+	u64 d1;
+	s64 result;
 	u64 temp0;
 	u64 temp1;
 
 	temp0 = phase * SIN_LUT_SIZE;
-	index = (temp0 * 7) / (44 << FIX_PT_PREC);
+	index = temp0 / (u64)(FIX_PT_2PI);
 
-	temp0 = (temp0 * 7) / 44;
-	temp1 = index << FIX_PT_PREC;
+	temp1 = index * (u64)(FIX_PT_2PI);
+	temp1 /= SIN_LUT_SIZE;
 
-	d1 =  temp0 - temp1;
-	d0 = (1 << FIX_PT_PREC) - d1;
+	d1 =  phase - temp1;
+	d0 = (1ULL << FIX_PT_PREC) - d1;
+
+	index += (SIN_LUT_SIZE / 4); /* offset for cosine values */
 
-	index += 64;
 	result = d0 * get_sin_val(index) + d1 * get_sin_val(index+1);
+
 	return result >> FIX_PT_PREC;
 }
 
-u32 phase_per_sample(u32 signal_freq, u32 sampling_freq)
+/* phase increment or decrement per sample is calculated as
+ *
+ *		phase covered in 1 cycle = 2.pi
+ *		phase_per_sample = 2.pi / num_samples_per_cycle
+ *
+ *		num_samples_per_cycle = samples_per_sec
+ *		phase_per_sample = (2.pi x cycles_per_sec) / samples_per_sec
+ * */
+
+u64 phase_per_sample(u32 signal_freq, u32 sampling_freq)
 {
-	/* phase increment or decrement with each sample is given by
-	 *  (2 x Pi x signal frequency)/sampling frequency
-	 * To get a better accuracy with fixed point implementation we use
-	 *  Pi = 22/7
-	 * */
-	u64 temp = 44 * ((u64)signal_freq << FIX_PT_PREC);
-
-	return temp / (7*sampling_freq);
+	u64 cycles_per_sec = signal_freq;
+	u64 samples_per_sec = sampling_freq;
+
+	return (FIX_PT_2PI * cycles_per_sec) / samples_per_sec;
 }
diff --git a/drivers/media/platform/vivid/vivid-sin.h b/drivers/media/platform/vivid/vivid-sin.h
index 6c8bab2..b27a94e 100644
--- a/drivers/media/platform/vivid/vivid-sin.h
+++ b/drivers/media/platform/vivid/vivid-sin.h
@@ -22,10 +22,11 @@
 #ifndef _VIVID_SIN_H_
 #define _VIVID_SIN_H_
 
-#define FIX_PT_PREC 16
+#define FIX_PT_PREC (24)
+#define FIX_PT_2PI (0x6487ED5)
 
-s32 calc_sin(u32 phase);
-s32 calc_cos(u32 phase);
-u32 phase_per_sample(u32 signal_freq, u32 sampling_freq);
+s64 calc_sin(u64 phase);
+s64 calc_cos(u64 phase);
+u64 phase_per_sample(u32 signal_freq, u32 sampling_freq);
 
 #endif
-- 
1.9.1

