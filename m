Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:60011 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934975AbcJHLtM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Oct 2016 07:49:12 -0400
Subject: [PATCH 2/2] [media] cx88-dsp: Add some spaces for better code
 readability
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <ebf6d2f7-eb50-d55b-e782-689af9ecda31@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <ada0edbb-81fe-aefe-1202-34e07e3b7a2b@users.sourceforge.net>
Date: Sat, 8 Oct 2016 13:49:00 +0200
MIME-Version: 1.0
In-Reply-To: <ebf6d2f7-eb50-d55b-e782-689af9ecda31@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 7 Oct 2016 22:30:40 +0200

Use space characters at some source code places according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/cx88/cx88-dsp.c | 40 +++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-dsp.c b/drivers/media/pci/cx88/cx88-dsp.c
index 9acda12..13f3a66 100644
--- a/drivers/media/pci/cx88/cx88-dsp.c
+++ b/drivers/media/pci/cx88/cx88-dsp.c
@@ -31,7 +31,7 @@
 #define INT_PI			((s32)(3.141592653589 * 32768.0))
 
 #define compat_remainder(a, b) \
-	 ((float)(((s32)((a)*100))%((s32)((b)*100)))/100.0)
+	 ((float)(((s32)((a) * 100)) % ((s32)((b) * 100))) / 100.0)
 
 #define baseband_freq(carrier, srate, tone) ((s32)( \
 	 (compat_remainder(carrier + tone, srate)) / srate * 2 * INT_PI))
@@ -82,15 +82,15 @@ static s32 int_cos(u32 x)
 	if (period % 2)
 		return -int_cos(x - INT_PI);
 	x = x % INT_PI;
-	if (x > INT_PI/2)
-		return -int_cos(INT_PI/2 - (x % (INT_PI/2)));
+	if (x > INT_PI / 2)
+		return -int_cos(INT_PI / 2 - (x % (INT_PI / 2)));
 	/* Now x is between 0 and INT_PI/2.
 	 * To calculate cos(x) we use it's Taylor polinom. */
-	t2 = x*x/32768/2;
-	t4 = t2*x/32768*x/32768/3/4;
-	t6 = t4*x/32768*x/32768/5/6;
-	t8 = t6*x/32768*x/32768/7/8;
-	ret = 32768-t2+t4-t6+t8;
+	t2 = x * x / 32768 / 2;
+	t4 = t2 * x / 32768 * x / 32768 / 3 / 4;
+	t6 = t4 * x / 32768 * x / 32768 / 5 / 6;
+	t8 = t6 * x / 32768 * x / 32768 / 7 / 8;
+	ret = 32768 - t2 + t4 - t6 + t8;
 	return ret;
 }
 
@@ -100,14 +100,14 @@ static u32 int_goertzel(s16 x[], u32 N, u32 freq)
 	 * given frequency in the signal */
 	s32 s_prev = 0;
 	s32 s_prev2 = 0;
-	s32 coeff = 2*int_cos(freq);
+	s32 coeff = 2 * int_cos(freq);
 	u32 i;
 
 	u64 tmp;
 	u32 divisor;
 
 	for (i = 0; i < N; i++) {
-		s32 s = x[i] + ((s64)coeff*s_prev/32768) - s_prev2;
+		s32 s = x[i] + ((s64)coeff * s_prev / 32768) - s_prev2;
 		s_prev2 = s_prev;
 		s_prev = s;
 	}
@@ -138,7 +138,7 @@ static u32 noise_magnitude(s16 x[], u32 N, u32 freq_start, u32 freq_end)
 
 	if (N > 192) {
 		/* The last 192 samples are enough for noise detection */
-		x += (N-192);
+		x += (N - 192);
 		N = 192;
 	}
 
@@ -196,8 +196,8 @@ static s32 detect_a2_a2m_eiaj(struct cx88_core *core, s16 x[], u32 N)
 
 	if (core->tvaudio == WW_EIAJ) {
 		/* EIAJ checks may need adjustments */
-		if ((carrier > max(stereo, dual)*2) &&
-		    (carrier < max(stereo, dual)*6) &&
+		if ((carrier > max(stereo, dual) * 2) &&
+		    (carrier < max(stereo, dual) * 6) &&
 		    (carrier > 20 && carrier < 200) &&
 		    (max(stereo, dual) > min(stereo, dual))) {
 			/* For EIAJ the carrier is always present,
@@ -205,11 +205,11 @@ static s32 detect_a2_a2m_eiaj(struct cx88_core *core, s16 x[], u32 N)
 			return ret;
 		}
 	} else {
-		if ((carrier > max(stereo, dual)*2) &&
-		    (carrier < max(stereo, dual)*8) &&
+		if ((carrier > max(stereo, dual) * 2) &&
+		    (carrier < max(stereo, dual) * 8) &&
 		    (carrier > 20 && carrier < 200) &&
 		    (noise < 10) &&
-		    (max(stereo, dual) > min(stereo, dual)*2)) {
+		    (max(stereo, dual) > min(stereo, dual) * 2)) {
 			return ret;
 		}
 	}
@@ -234,9 +234,9 @@ static s16 *read_rds_samples(struct cx88_core *core, u32 *N)
 	s16 *samples;
 
 	unsigned int i;
-	unsigned int bpl = srch->fifo_size/AUD_RDS_LINES;
-	unsigned int spl = bpl/4;
-	unsigned int sample_count = spl*(AUD_RDS_LINES-1);
+	unsigned int bpl = srch->fifo_size / AUD_RDS_LINES;
+	unsigned int spl = bpl / 4;
+	unsigned int sample_count = spl * (AUD_RDS_LINES - 1);
 
 	u32 current_address = cx_read(srch->ptr1_reg);
 	u32 offset = (current_address - srch->fifo_start + bpl);
@@ -252,7 +252,7 @@ static s16 *read_rds_samples(struct cx88_core *core, u32 *N)
 	*N = sample_count;
 
 	for (i = 0; i < sample_count; i++)  {
-		offset = offset % (AUD_RDS_LINES*bpl);
+		offset = offset % (AUD_RDS_LINES * bpl);
 		samples[i] = cx_read(srch->fifo_start + offset);
 		offset += 4;
 	}
-- 
2.10.1

