Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:60993 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaLAJNZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 04:13:25 -0500
From: Prashant Laddha <prladdha@cisco.com>
To: <hverkuil@xs4all.nl>
Cc: Prashant Laddha <prladdha@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/5] Use LUT based implementation for (co)sine functions
Date: Mon,  1 Dec 2014 14:33:20 +0530
Message-Id: <1417424604-17340-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replaced Taylor series calculation with a look up table based
calculation of (co)sine values. Also reworked fixed point
implementation to reduce rounding errors.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Antti Palosaari <crope@iki.fi>

Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/Makefile        |   2 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c |  87 ++++++--------
 drivers/media/platform/vivid/vivid-sin.c     | 171 +++++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-sin.h     |  30 +++++
 4 files changed, 238 insertions(+), 52 deletions(-)
 create mode 100644 drivers/media/platform/vivid/vivid-sin.c
 create mode 100644 drivers/media/platform/vivid/vivid-sin.h

diff --git a/drivers/media/platform/vivid/Makefile b/drivers/media/platform/vivid/Makefile
index 756fc12..9d5fe1c 100644
--- a/drivers/media/platform/vivid/Makefile
+++ b/drivers/media/platform/vivid/Makefile
@@ -2,5 +2,5 @@ vivid-objs := vivid-core.o vivid-ctrls.o vivid-vid-common.o vivid-vbi-gen.o \
 		vivid-vid-cap.o vivid-vid-out.o vivid-kthread-cap.o vivid-kthread-out.o \
 		vivid-radio-rx.o vivid-radio-tx.o vivid-radio-common.o \
 		vivid-rds-gen.o vivid-sdr-cap.o vivid-vbi-cap.o vivid-vbi-out.o \
-		vivid-osd.o vivid-tpg.o vivid-tpg-colors.o
+		vivid-osd.o vivid-tpg.o vivid-tpg-colors.o vivid-sin.o
 obj-$(CONFIG_VIDEO_VIVID) += vivid.o
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 4af55f1..99fc2c7 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -31,6 +31,7 @@
 #include "vivid-core.h"
 #include "vivid-ctrls.h"
 #include "vivid-sdr-cap.h"
+#include "vivid-sin.h"
 
 static const struct v4l2_frequency_band bands_adc[] = {
 	{
@@ -423,40 +424,17 @@ int vidioc_g_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_format *f)
 	return 0;
 }
 
-#define FIXP_FRAC    (1 << 15)
-#define FIXP_PI      ((int)(FIXP_FRAC * 3.141592653589))
-
-/* cos() from cx88 driver: cx88-dsp.c */
-static s32 fixp_cos(unsigned int x)
-{
-	u32 t2, t4, t6, t8;
-	u16 period = x / FIXP_PI;
-
-	if (period % 2)
-		return -fixp_cos(x - FIXP_PI);
-	x = x % FIXP_PI;
-	if (x > FIXP_PI/2)
-		return -fixp_cos(FIXP_PI/2 - (x % (FIXP_PI/2)));
-	/* Now x is between 0 and FIXP_PI/2.
-	 * To calculate cos(x) we use it's Taylor polinom. */
-	t2 = x*x/FIXP_FRAC/2;
-	t4 = t2*x/FIXP_FRAC*x/FIXP_FRAC/3/4;
-	t6 = t4*x/FIXP_FRAC*x/FIXP_FRAC/5/6;
-	t8 = t6*x/FIXP_FRAC*x/FIXP_FRAC/7/8;
-	return FIXP_FRAC-t2+t4-t6+t8;
-}
-
-static inline s32 fixp_sin(unsigned int x)
-{
-	return -fixp_cos(x + (FIXP_PI / 2));
-}
-
 void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
 	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
 	unsigned long i;
 	unsigned long plane_size = vb2_plane_size(&buf->vb, 0);
-	int fixp_src_phase_step, fixp_i, fixp_q;
+	int fixp_i, fixp_q;
+
+	u32 adc_freq;
+	u32 sig_freq;
+	u32 src_phase_inc;
+	u32 mod_phase_inc;
 
 	/*
 	 * TODO: Generated beep tone goes very crackly when sample rate is
@@ -466,34 +444,41 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 
 	/* calculate phase step */
 	#define BEEP_FREQ 1000 /* 1kHz beep */
-	fixp_src_phase_step = DIV_ROUND_CLOSEST(2 * FIXP_PI * BEEP_FREQ,
-			dev->sdr_adc_freq);
+
+	adc_freq = dev->sdr_adc_freq;   /* samples per sec*/
+	sig_freq = BEEP_FREQ;           /* cycles per sec */
+	src_phase_inc = phase_per_sample(sig_freq, adc_freq);
 
 	for (i = 0; i < plane_size; i += 2) {
-		dev->sdr_fixp_mod_phase += fixp_cos(dev->sdr_fixp_src_phase);
-		dev->sdr_fixp_src_phase += fixp_src_phase_step;
 
-		/*
-		 * Transfer phases to [0 / 2xPI] in order to avoid variable
-		 * overflow and make it suitable for cosine implementation
-		 * used, which does not support negative angles.
-		 */
-		while (dev->sdr_fixp_mod_phase < (0 * FIXP_PI))
-			dev->sdr_fixp_mod_phase += (2 * FIXP_PI);
-		while (dev->sdr_fixp_mod_phase > (2 * FIXP_PI))
-			dev->sdr_fixp_mod_phase -= (2 * FIXP_PI);
+		mod_phase_inc = calc_cos(dev->sdr_fixp_src_phase);
+		dev->sdr_fixp_src_phase += src_phase_inc;
+
+		while(dev->sdr_fixp_src_phase >= ((44 << FIX_PT_PREC)/7))
+			dev->sdr_fixp_src_phase -= ((44 << FIX_PT_PREC)/7);
+
+		mod_phase_inc <<= FIX_PT_PREC;
+		mod_phase_inc /= 1275;
+
+		dev->sdr_fixp_mod_phase += mod_phase_inc;
+
+		while(dev->sdr_fixp_mod_phase < 0)
+			dev->sdr_fixp_mod_phase += ((44 << FIX_PT_PREC)/7);
 
-		while (dev->sdr_fixp_src_phase > (2 * FIXP_PI))
-			dev->sdr_fixp_src_phase -= (2 * FIXP_PI);
+		while(dev->sdr_fixp_mod_phase >= ((44 << FIX_PT_PREC)/7))
+			dev->sdr_fixp_mod_phase -= ((44 << FIX_PT_PREC)/7);
 
-		fixp_i = fixp_cos(dev->sdr_fixp_mod_phase);
-		fixp_q = fixp_sin(dev->sdr_fixp_mod_phase);
+		fixp_i = calc_sin(dev->sdr_fixp_mod_phase);
+		fixp_q = calc_cos(dev->sdr_fixp_mod_phase);
 
 		/* convert 'fixp float' to u8 */
-		/* u8 = X * 127.5f + 127.5f; where X is float [-1.0 / +1.0] */
-		fixp_i = fixp_i * 1275 + FIXP_FRAC * 1275;
-		fixp_q = fixp_q * 1275 + FIXP_FRAC * 1275;
-		*vbuf++ = DIV_ROUND_CLOSEST(fixp_i, FIXP_FRAC * 10);
-		*vbuf++ = DIV_ROUND_CLOSEST(fixp_q, FIXP_FRAC * 10);
+		/* u8 = X * 127.5f + 127.5f; where X is float [-1.0 / +1.0]
+		The values stored in sin look table are pre-multipied with 1275.
+		So, only do addition */
+
+		fixp_i += 1275;
+		fixp_q += 1275;
+		*vbuf++ = DIV_ROUND_CLOSEST(fixp_i, 10);
+		*vbuf++ = DIV_ROUND_CLOSEST(fixp_q, 10);
 	}
 }
diff --git a/drivers/media/platform/vivid/vivid-sin.c b/drivers/media/platform/vivid/vivid-sin.c
new file mode 100644
index 0000000..5bd6677
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-sin.c
@@ -0,0 +1,171 @@
+/*
+ * vivid-sin.c - software defined radio support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+
+#include "vivid-sin.h"
+
+#define SIN_TAB_SIZE 256
+
+    /*TODO- Reduce the size of the table */
+/* Since sinewave is symmetric, it can be represented using only quarter
+   of the samples compared to the number of samples used below  */
+
+static s32 sin[257] = {
+	 0,   31,   63,   94,  125,  156,  187,  218,  249,  279,  310,  340,
+       370,  400,  430,  459,  488,  517,  545,  573,  601,  628,  655,  682,
+       708,  734,  760,  784,  809,  833,  856,  879,  902,  923,  945,  965,
+       986, 1005, 1024, 1042, 1060, 1077, 1094, 1109, 1124, 1139, 1153, 1166,
+      1178, 1190, 1200, 1211, 1220, 1229, 1237, 1244, 1251, 1256, 1261, 1265,
+      1269, 1272, 1273, 1275, 1275, 1275, 1273, 1272, 1269, 1265, 1261, 1256,
+      1251, 1244, 1237, 1229, 1220, 1211, 1200, 1190, 1178, 1166, 1153, 1139,
+      1124, 1109, 1094, 1077, 1060, 1042, 1024, 1005,  986,  965,  945,  923,
+       902,  879,  856,  833,  809,  784,  760,  734,  708,  682,  655,  628,
+       601,  573,  545,  517,  488,  459,  430,  400,  370,  340,  310,  279,
+       249,  218,  187,  156,  125,   94,   63,   31,    0,  -31,  -63,  -94,
+      -125, -156, -187, -218, -249, -279, -310, -340, -370, -400, -430, -459,
+      -488, -517, -545, -573, -601, -628, -655, -682, -708, -734, -760, -784,
+      -809, -833, -856, -879, -902, -923, -945, -965, -986,-1005,-1024,-1042,
+     -1060,-1077,-1094,-1109,-1124,-1139,-1153,-1166,-1178,-1190,-1200,-1211,
+     -1220,-1229,-1237,-1244,-1251,-1256,-1261,-1265,-1269,-1272,-1273,-1275,
+     -1275,-1275,-1273,-1272,-1269,-1265,-1261,-1256,-1251,-1244,-1237,-1229,
+     -1220,-1211,-1200,-1190,-1178,-1166,-1153,-1139,-1124,-1109,-1094,-1077,
+     -1060,-1042,-1024,-1005, -986, -965, -945, -923, -902, -879, -856, -833,
+      -809, -784, -760, -734, -708, -682, -655, -628, -601, -573, -545, -517,
+      -488, -459, -430, -400, -370, -340, -310, -279, -249, -218, -187, -156,
+      -125,  -94,  -63,  -31,    0
+      };
+
+/*
+ * Calculation of sine is implemented using a look up table for range of
+ * phase values from 0 to 2*pi. Look table contains finite entries, say N.
+ *
+ * Since sinusoid are periodic with period 2*pi, look table stores entries
+ * for phase values from 0 to 2*pi.
+ *
+ * The interval [0,2*pi] is divided into N equal intervals, each representing
+ * a phase increment of (2*pi/N)
+ *
+ * The index 'n' in look up table stores sine value for phase (2*pi*n/N) as -
+ * sin_tab[N] = {sin(0), sin(1*(2*pi/N)),sin(2*(2*pi/N)), ..., sin(N*(2*pi/N))}
+ *
+   |---------|---------|---------|---- . . . .|---------| . . . . |---------|
+   0    (2*pi/N)  (2*2*pi/N) (3*2*pi/N)   (n*2*pi/N)                       2*pi
+ *
+ * Generation of sine waveform with different frequencies -
+ *
+ * Consider a sine tone with frequency 'f', so,
+ *      num_cycles_per_sec = f
+ * Let sampling frequency be 'Fs' so,
+ *     num_samples_per_sec = Fs
+ * So, num_samples_per_cycle = Fs/f
+ * Let Nc = Fs/f
+ *
+ * That is, number of samples during one interval of 0 tp 2*pi = Nc, each
+ * sample represents a phase increment of (2*pi/Nc = 2*pi*f/Fs).
+ *
+ * So, for "k" th sample the phase, phi =  k*(2*pi/Nc)
+ *
+ * The sine value at phase increments of (2*pi/Nc) is calculated by interpolating
+ * two adjecent samples from sine look table
+ *
+ * As an example, sine value for phase (phi) is calculated below
+ *
+ * 1. Find the interval [(n*2*pi/N), ((n+1)*2*pi/N)] to which phi belongs
+
+   0    (2*pi/N)      (n*2*pi/N) ((n+1)*2*pi/N)                     2*pi
+   |---------| . . . . . |---------|---------|  . . . . .  |---------|
+			       ^
+			d0---->|<--d1
+			       |
+			      phi = k*(2*pi/Nc)
+
+ * For phase (phi) the index n in sine table is given by (phi)/(2*pi/N)
+ *        n = integer part of ( phi / (2*pi/N) )
+ *
+ * 2. Find distance d0 and d1 using fractional arithmatic.
+ *        d0 =  phi - n*(2*pi/N),
+ *        d1 =  2*pi/N - d0
+ *
+ * 3. The calculations of fractions are done using fixed point implementation
+ *
+ * 4. To improve the precision of fixed point implementations, divisions
+ *    in different calculations are delayed till last operations. Say,
+ *    d0 = phi - n*(2*pi/N)
+ *    d0 = phi - n * (2 * (22/7)/N) , substitute pi = 22/7
+ *    d0 = phi - (n * 44 * N)/7
+ */
+s32 calc_sin(u32 phase)
+{
+    u32 index;
+    u32 d0;
+    u32 d1;
+    s32 result;
+    u64 temp0;
+    u64 temp1;
+
+    temp0 = phase * SIN_TAB_SIZE;
+    index = (temp0 * 7) /(44 << FIX_PT_PREC);
+
+    temp0 = (temp0 * 7) /44;
+    temp1 = index << FIX_PT_PREC;
+
+    d1 =  temp0 - temp1;
+    d0 = (1 << FIX_PT_PREC) - d1;
+
+    result = (d0 * sin[index % 256] + d1 * sin[(index+1)%256]);
+
+    return result >> FIX_PT_PREC;
+}
+
+s32 calc_cos(u32 phase)
+{
+    u32 index;
+    u32 d0;
+    u32 d1;
+    s32 result;
+    u64 temp0;
+    u64 temp1;
+
+    temp0 = phase * SIN_TAB_SIZE;
+    index = (temp0 * 7) /(44 << FIX_PT_PREC);
+
+    temp0 = (temp0 * 7) /44;
+    temp1 = index << FIX_PT_PREC;
+
+    d1 =  temp0 - temp1;
+    d0 = (1 << FIX_PT_PREC) - d1;
+
+    index += 64;
+    result = (d0 * sin[index % 256] + d1 * sin[(index+1)%256]);
+
+    return result >> FIX_PT_PREC;
+}
+
+u32 phase_per_sample(u32 signal_freq, u32 sampling_freq)
+{
+    /* phase increment or decrement with each sample is given by
+     *  (2 x Pi x signal frequency)/sampling frequency
+     * To get a better accuracy with fixed point implementation we use
+     *  Pi = 22/7
+     * */
+    u64 temp = 44 * ((u64)signal_freq << FIX_PT_PREC);
+    return temp / (7*sampling_freq);
+}
diff --git a/drivers/media/platform/vivid/vivid-sin.h b/drivers/media/platform/vivid/vivid-sin.h
new file mode 100644
index 0000000..2f77d64
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-sin.h
@@ -0,0 +1,30 @@
+/*
+ * vivid-sin.h - support functions used to generate (co)sine waveforms for
+ *               software defined radio.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _VIVID_SIN_H_
+#define _VIVID_SIN_H_
+
+#define FIX_PT_PREC 16
+
+s32 calc_sin(u32 phase);
+s32 calc_cos(u32 phase);
+u32 phase_per_sample(u32 signal_freq, u32 sampling_freq);
+
+#endif
-- 
1.9.1

