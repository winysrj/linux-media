Return-path: <linux-media-owner@vger.kernel.org>
Received: from cinke.fazekas.hu ([195.199.244.225]:36412 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbZCaWOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 18:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 3] cx88: Add support for stereo and sap detection for A2
Message-Id: <32593e0b3a9253e4f3d2.1238536911@roadrunner.athome>
In-Reply-To: <patchbomb.1238536910@roadrunner.athome>
Date: Wed, 01 Apr 2009 00:01:51 +0200
From: Marton Balint <cus@fazekas.hu>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Marton Balint <cus@fazekas.hu>
# Date 1238461695 -7200
# Node ID 32593e0b3a9253e4f3d2cb415cb3143136f61504
# Parent  ff5430b54ac291d69c1bbb35af1b80b5b7ec692e
cx88: Add support for stereo and sap detection for A2

From: Marton Balint <cus@fazekas.hu>

The patch implements reliable stereo and sap detection for the A2 sound
standard.  This is achieved by processing the samples of the audio RDS fifo of
the cx2388x chip. A2M, EIAJ and BTSC stereo/sap detection is also possible with
this new approach, but it's not implemented yet. Stereo detection when alsa
handles the sound also does not work yet.

Priority: normal

Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r ff5430b54ac2 -r 32593e0b3a92 linux/drivers/media/video/cx88/Makefile
--- a/linux/drivers/media/video/cx88/Makefile	Mon Mar 30 08:27:06 2009 -0300
+++ b/linux/drivers/media/video/cx88/Makefile	Tue Mar 31 03:08:15 2009 +0200
@@ -1,5 +1,5 @@
 cx88xx-objs	:= cx88-cards.o cx88-core.o cx88-i2c.o cx88-tvaudio.o \
-		   cx88-input.o
+		   cx88-dsp.o cx88-input.o
 cx8800-objs	:= cx88-video.o cx88-vbi.o
 cx8802-objs	:= cx88-mpeg.o
 
diff -r ff5430b54ac2 -r 32593e0b3a92 linux/drivers/media/video/cx88/cx88-core.c
--- a/linux/drivers/media/video/cx88/cx88-core.c	Mon Mar 30 08:27:06 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-core.c	Tue Mar 31 03:08:15 2009 +0200
@@ -232,7 +232,7 @@
  * can use the whole SDRAM for the DMA fifos.  To simplify things, we
  * use a static memory layout.  That surely will waste memory in case
  * we don't use all DMA channels at the same time (which will be the
- * case most of the time).  But that still gives us enougth FIFO space
+ * case most of the time).  But that still gives us enough FIFO space
  * to be able to deal with insane long pci latencies ...
  *
  * FIFO space allocations:
@@ -242,6 +242,7 @@
  *    channel  24    (vbi)      -  4.0k
  *    channels 25+26 (audio)    -  4.0k
  *    channel  28    (mpeg)     -  4.0k
+ *    channel  27    (audio rds)-  3.0k
  *    TOTAL                     = 29.0k
  *
  * Every channel has 160 bytes control data (64 bytes instruction
@@ -337,6 +338,18 @@
 		.ptr2_reg   = MO_DMA28_PTR2,
 		.cnt1_reg   = MO_DMA28_CNT1,
 		.cnt2_reg   = MO_DMA28_CNT2,
+	},
+	[SRAM_CH27] = {
+		.name       = "audio rds",
+		.cmds_start = 0x1801C0,
+		.ctrl_start = 0x180860,
+		.cdt        = 0x180860 + 64,
+		.fifo_start = 0x187400,
+		.fifo_size  = 0x000C00,
+		.ptr1_reg   = MO_DMA27_PTR1,
+		.ptr2_reg   = MO_DMA27_PTR2,
+		.cnt1_reg   = MO_DMA27_CNT1,
+		.cnt2_reg   = MO_DMA27_CNT2,
 	},
 };
 
@@ -623,6 +636,7 @@
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH25], 128, 0);
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH26], 128, 0);
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH28], 188*4, 0);
+	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH27], 128, 0);
 
 	/* misc init ... */
 	cx_write(MO_INPUT_FORMAT, ((1 << 13) |   // agc enable
@@ -821,6 +835,8 @@
 	/* constant 128 made buzz in analog Nicam-stereo for bigger fifo_size */
 	int bpl = cx88_sram_channels[SRAM_CH25].fifo_size/4;
 
+	int rds_bpl = cx88_sram_channels[SRAM_CH27].fifo_size/AUD_RDS_LINES;
+
 	/* If downstream RISC is enabled, bail out; ALSA is managing DMA */
 	if (cx_read(MO_AUD_DMACNTRL) & 0x10)
 		return 0;
@@ -828,12 +844,14 @@
 	/* setup fifo + format */
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH25], bpl, 0);
 	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH26], bpl, 0);
+	cx88_sram_channel_setup(core, &cx88_sram_channels[SRAM_CH27],
+				rds_bpl, 0);
 
 	cx_write(MO_AUDD_LNGTH, bpl); /* fifo bpl size */
-	cx_write(MO_AUDR_LNGTH, bpl); /* fifo bpl size */
+	cx_write(MO_AUDR_LNGTH, rds_bpl); /* fifo bpl size */
 
-	/* start dma */
-	cx_write(MO_AUD_DMACNTRL, 0x0003); /* Up and Down fifo enable */
+	/* enable Up, Down and Audio RDS fifo */
+	cx_write(MO_AUD_DMACNTRL, 0x0007);
 
 	return 0;
 }
diff -r ff5430b54ac2 -r 32593e0b3a92 linux/drivers/media/video/cx88/cx88-dsp.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/video/cx88/cx88-dsp.c	Tue Mar 31 03:08:15 2009 +0200
@@ -0,0 +1,301 @@
+/*
+ *
+ *  Stereo and SAP detection for cx88
+ *
+ *  Copyright (c) 2009 Marton Balint <cus@fazekas.hu>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/jiffies.h>
+
+#include "cx88.h"
+#include "cx88-reg.h"
+
+#define INT_PI			((s32)(3.141592653589 * 32768.0))
+
+#define baseband_freq(carrier, srate, tone) ((s32)( \
+	 (__builtin_remainder(carrier + tone, srate)) / srate * 2 * INT_PI))
+
+/* We calculate the baseband frequencies of the carrier and the pilot tones
+ * based on the the sampling rate of the audio rds fifo. */
+
+#define FREQ_A2_CARRIER         baseband_freq(54687.5, 2689.36, 0.0)
+#define FREQ_A2_DUAL            baseband_freq(54687.5, 2689.36, 274.1)
+#define FREQ_A2_STEREO          baseband_freq(54687.5, 2689.36, 117.5)
+
+/* The frequencies below are from the reference driver. They probably need
+ * further adjustments, because they are not tested at all. You may even need
+ * to play a bit with the registers of the chip to select the proper signal
+ * for the input of the audio rds fifo, and measure it's sampling rate to
+ * calculate the proper baseband frequencies... */
+
+#define FREQ_A2M_CARRIER	((s32)(2.114516 * 32768.0))
+#define FREQ_A2M_DUAL		((s32)(2.754916 * 32768.0))
+#define FREQ_A2M_STEREO		((s32)(2.462326 * 32768.0))
+
+#define FREQ_EIAJ_CARRIER	((s32)(1.963495 * 32768.0)) /* 5pi/8  */
+#define FREQ_EIAJ_DUAL		((s32)(2.562118 * 32768.0))
+#define FREQ_EIAJ_STEREO	((s32)(2.601053 * 32768.0))
+
+#define FREQ_BTSC_DUAL		((s32)(1.963495 * 32768.0)) /* 5pi/8  */
+#define FREQ_BTSC_DUAL_REF	((s32)(1.374446 * 32768.0)) /* 7pi/16 */
+
+#define FREQ_BTSC_SAP		((s32)(2.471532 * 32768.0))
+#define FREQ_BTSC_SAP_REF	((s32)(1.730072 * 32768.0))
+
+/* The spectrum of the signal should be empty between these frequencies. */
+#define FREQ_NOISE_START	((s32)(0.100000 * 32768.0))
+#define FREQ_NOISE_END		((s32)(1.200000 * 32768.0))
+
+static unsigned int dsp_debug;
+module_param(dsp_debug, int, 0644);
+MODULE_PARM_DESC(dsp_debug, "enable audio dsp debug messages");
+
+#define dprintk(level, fmt, arg...)	if (dsp_debug >= level) \
+	printk(KERN_DEBUG "%s/0: " fmt, core->name , ## arg)
+
+static s32 int_cos(u32 x)
+{
+	u32 t2, t4, t6, t8;
+	s32 ret;
+	u16 period = x / INT_PI;
+	if (period % 2)
+		return -int_cos(x - INT_PI);
+	x = x % INT_PI;
+	if (x > INT_PI/2)
+		return -int_cos(INT_PI/2 - (x % (INT_PI/2)));
+	/* Now x is between 0 and INT_PI/2.
+	 * To calculate cos(x) we use it's Taylor polinom. */
+	t2 = x*x/32768/2;
+	t4 = t2*x/32768*x/32768/3/4;
+	t6 = t4*x/32768*x/32768/5/6;
+	t8 = t6*x/32768*x/32768/7/8;
+	ret = 32768-t2+t4-t6+t8;
+	return ret;
+}
+
+static u32 int_goertzel(s16 x[], u32 N, u32 freq)
+{
+	/* We use the Goertzel algorithm to determine the power of the
+	 * given frequency in the signal */
+	s32 s_prev = 0;
+	s32 s_prev2 = 0;
+	s32 coeff = 2*int_cos(freq);
+	u32 i;
+	for (i = 0; i < N; i++) {
+		s32 s = x[i] + ((s64)coeff*s_prev/32768) - s_prev2;
+		s_prev2 = s_prev;
+		s_prev = s;
+	}
+	return (u32)(((s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
+		      (s64)coeff*s_prev2*s_prev/32768)/N/N);
+}
+
+static u32 freq_magnitude(s16 x[], u32 N, u32 freq)
+{
+	u32 sum = int_goertzel(x, N, freq);
+	return (u32)int_sqrt(sum);
+}
+
+static u32 noise_magnitude(s16 x[], u32 N, u32 freq_start, u32 freq_end)
+{
+	int i;
+	u32 sum = 0;
+	u32 freq_step;
+	int samples = 5;
+
+	if (N > 192) {
+		/* The last 192 samples are enough for noise detection */
+		x += (N-192);
+		N = 192;
+	}
+
+	freq_step = (freq_end - freq_start) / (samples - 1);
+
+	for (i = 0; i < samples; i++) {
+		sum += int_goertzel(x, N, freq_start);
+		freq_start += freq_step;
+	}
+
+	return (u32)int_sqrt(sum / samples);
+}
+
+static s32 detect_a2_a2m_eiaj(struct cx88_core *core, s16 x[], u32 N)
+{
+	s32 carrier, stereo, dual, noise;
+	s32 carrier_freq, stereo_freq, dual_freq;
+	s32 ret;
+
+	switch (core->tvaudio) {
+	case WW_BG:
+	case WW_DK:
+		carrier_freq = FREQ_A2_CARRIER;
+		stereo_freq = FREQ_A2_STEREO;
+		dual_freq = FREQ_A2_DUAL;
+		break;
+	case WW_M:
+		carrier_freq = FREQ_A2M_CARRIER;
+		stereo_freq = FREQ_A2M_STEREO;
+		dual_freq = FREQ_A2M_DUAL;
+		break;
+	case WW_EIAJ:
+		carrier_freq = FREQ_EIAJ_CARRIER;
+		stereo_freq = FREQ_EIAJ_STEREO;
+		dual_freq = FREQ_EIAJ_DUAL;
+		break;
+	default:
+		printk(KERN_WARNING "%s/0: unsupported audio mode %d for %s\n",
+		       core->name, core->tvaudio, __func__);
+		return UNSET;
+	}
+
+	carrier = freq_magnitude(x, N, carrier_freq);
+	stereo  = freq_magnitude(x, N, stereo_freq);
+	dual    = freq_magnitude(x, N, dual_freq);
+	noise   = noise_magnitude(x, N, FREQ_NOISE_START, FREQ_NOISE_END);
+
+	dprintk(1, "detect a2/a2m/eiaj: carrier=%d, stereo=%d, dual=%d, "
+		   "noise=%d\n", carrier, stereo, dual, noise);
+
+	if (stereo > dual)
+		ret = V4L2_TUNER_SUB_STEREO;
+	else
+		ret = V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
+
+	if (core->tvaudio == WW_EIAJ) {
+		/* EIAJ checks may need adjustments */
+		if ((carrier > max(stereo, dual)*2) &&
+		    (carrier < max(stereo, dual)*6) &&
+		    (carrier > 20 && carrier < 200) &&
+		    (max(stereo, dual) > min(stereo, dual))) {
+			/* For EIAJ the carrier is always present,
+			   so we probably don't need noise detection */
+			return ret;
+		}
+	} else {
+		if ((carrier > max(stereo, dual)*2) &&
+		    (carrier < max(stereo, dual)*8) &&
+		    (carrier > 20 && carrier < 200) &&
+		    (noise < 10) &&
+		    (max(stereo, dual) > min(stereo, dual)*2)) {
+			return ret;
+		}
+	}
+	return V4L2_TUNER_SUB_MONO;
+}
+
+static s32 detect_btsc(struct cx88_core *core, s16 x[], u32 N)
+{
+	s32 sap_ref = freq_magnitude(x, N, FREQ_BTSC_SAP_REF);
+	s32 sap = freq_magnitude(x, N, FREQ_BTSC_SAP);
+	s32 dual_ref = freq_magnitude(x, N, FREQ_BTSC_DUAL_REF);
+	s32 dual = freq_magnitude(x, N, FREQ_BTSC_DUAL);
+	dprintk(1, "detect btsc: dual_ref=%d, dual=%d, sap_ref=%d, sap=%d"
+		   "\n", dual_ref, dual, sap_ref, sap);
+	/* FIXME: Currently not supported */
+	return UNSET;
+}
+
+static s16 *read_rds_samples(struct cx88_core *core, u32 *N)
+{
+	struct sram_channel *srch = &cx88_sram_channels[SRAM_CH27];
+	s16 *samples;
+
+	unsigned int i;
+	unsigned int bpl = srch->fifo_size/AUD_RDS_LINES;
+	unsigned int spl = bpl/4;
+	unsigned int sample_count = spl*(AUD_RDS_LINES-1);
+
+	u32 current_address = cx_read(srch->ptr1_reg);
+	u32 offset = (current_address - srch->fifo_start + bpl);
+
+	dprintk(1, "read RDS samples: current_address=%08x (offset=%08x), "
+		"sample_count=%d, aud_intstat=%08x\n", current_address,
+		current_address - srch->fifo_start, sample_count,
+		cx_read(MO_AUD_INTSTAT));
+
+	samples = kmalloc(sizeof(s16)*sample_count, GFP_KERNEL);
+	if (!samples)
+		return NULL;
+
+	*N = sample_count;
+
+	for (i = 0; i < sample_count; i++)  {
+		offset = offset % (AUD_RDS_LINES*bpl);
+		samples[i] = cx_read(srch->fifo_start + offset);
+		offset += 4;
+	}
+
+	if (dsp_debug >= 2) {
+		dprintk(2, "RDS samples dump: ");
+		for (i = 0; i < sample_count; i++)
+			printk("%hd ", samples[i]);
+		printk(".\n");
+	}
+
+	return samples;
+}
+
+s32 cx88_dsp_detect_stereo_sap(struct cx88_core *core)
+{
+	s16 *samples;
+	u32 N = 0;
+	s32 ret = UNSET;
+
+	/* If audio RDS fifo is disabled, we can't read the samples */
+	if (!(cx_read(MO_AUD_DMACNTRL) & 0x04))
+		return ret;
+	if (!(cx_read(AUD_CTL) & EN_FMRADIO_EN_RDS))
+		return ret;
+
+	/* Wait at least 500 ms after an audio standard change */
+	if (time_before(jiffies, core->last_change + msecs_to_jiffies(500)))
+		return ret;
+
+	samples = read_rds_samples(core, &N);
+
+	if (!samples)
+		return ret;
+
+	switch (core->tvaudio) {
+	case WW_BG:
+	case WW_DK:
+#if 0
+	/* We should not detect these, until they are properly tested... */
+	case WW_EIAJ:
+	case WW_M:
+#endif
+		ret = detect_a2_a2m_eiaj(core, samples, N);
+		break;
+	case WW_BTSC:
+		ret = detect_btsc(core, samples, N);
+		break;
+	}
+
+	kfree(samples);
+
+	if (UNSET != ret)
+		dprintk(1, "stereo/sap detection result:%s%s%s\n",
+			   (ret & V4L2_TUNER_SUB_MONO) ? " mono" : "",
+			   (ret & V4L2_TUNER_SUB_STEREO) ? " stereo" : "",
+			   (ret & V4L2_TUNER_SUB_LANG2) ? " dual" : "");
+
+	return ret;
+}
+EXPORT_SYMBOL(cx88_dsp_detect_stereo_sap);
+
diff -r ff5430b54ac2 -r 32593e0b3a92 linux/drivers/media/video/cx88/cx88-tvaudio.c
--- a/linux/drivers/media/video/cx88/cx88-tvaudio.c	Mon Mar 30 08:27:06 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-tvaudio.c	Tue Mar 31 03:08:15 2009 +0200
@@ -167,6 +167,8 @@
 	/* unmute */
 	volume = cx_sread(SHADOW_AUD_VOL_CTL);
 	cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, volume);
+
+	core->last_change = jiffies;
 }
 
 /* ----------------------------------------------------------- */
@@ -749,6 +751,7 @@
 		break;
 	case WW_BG:
 	case WW_DK:
+	case WW_M:
 	case WW_I:
 	case WW_L:
 		/* prepare all dsp registers */
@@ -760,6 +763,7 @@
 		if (0 == cx88_detect_nicam(core)) {
 			/* fall back to fm / am mono */
 			set_audio_standard_A2(core, EN_A2_FORCE_MONO1);
+			core->audiomode_current = V4L2_TUNER_MODE_MONO;
 			core->use_nicam = 0;
 		} else {
 			core->use_nicam = 1;
@@ -791,6 +795,7 @@
 void cx88_newstation(struct cx88_core *core)
 {
 	core->audiomode_manual = UNSET;
+	core->last_change = jiffies;
 }
 
 void cx88_get_stereo(struct cx88_core *core, struct v4l2_tuner *t)
@@ -809,44 +814,42 @@
 			aud_ctl_names[cx_read(AUD_CTL) & 63]);
 	core->astat = reg;
 
-/* TODO
-	Reading from AUD_STATUS is not enough
-	for auto-detecting sap/dual-fm/nicam.
-	Add some code here later.
-*/
-
-# if 0
 	t->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_SAP |
 	    V4L2_TUNER_CAP_LANG1 | V4L2_TUNER_CAP_LANG2;
-	t->rxsubchans = V4L2_TUNER_SUB_MONO;
+	t->rxsubchans = UNSET;
 	t->audmode = V4L2_TUNER_MODE_MONO;
+
+	switch (mode) {
+	case 0:
+		t->audmode = V4L2_TUNER_MODE_STEREO;
+		break;
+	case 1:
+		t->audmode = V4L2_TUNER_MODE_LANG2;
+		break;
+	case 2:
+		t->audmode = V4L2_TUNER_MODE_MONO;
+		break;
+	case 3:
+		t->audmode = V4L2_TUNER_MODE_SAP;
+		break;
+	}
 
 	switch (core->tvaudio) {
 	case WW_BTSC:
-		t->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_SAP;
-		t->rxsubchans = V4L2_TUNER_SUB_STEREO;
-		if (1 == pilot) {
-			/* SAP */
-			t->rxsubchans |= V4L2_TUNER_SUB_SAP;
+	case WW_BG:
+	case WW_DK:
+	case WW_M:
+	case WW_EIAJ:
+		if (!core->use_nicam) {
+			t->rxsubchans = cx88_dsp_detect_stereo_sap(core);
+			break;
 		}
 		break;
-	case WW_A2_BG:
-	case WW_A2_DK:
-	case WW_A2_M:
-		if (1 == pilot) {
-			/* stereo */
-			t->rxsubchans =
-			    V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
-			if (0 == mode)
-				t->audmode = V4L2_TUNER_MODE_STEREO;
-		}
-		if (2 == pilot) {
-			/* dual language -- FIXME */
-			t->rxsubchans =
-			    V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
-			t->audmode = V4L2_TUNER_MODE_LANG1;
-		}
-		break;
+# if 0
+	/* TODO
+		Reading from AUD_STATUS is not enough
+		for auto-detecting sap/dual-fm/nicam.
+	*/
 	case WW_NICAM_BGDKL:
 		if (0 == mode) {
 			t->audmode = V4L2_TUNER_MODE_STEREO;
@@ -859,11 +862,20 @@
 			t->rxsubchans |= V4L2_TUNER_SUB_STEREO;
 		}
 		break;
+# endif
 	default:
 		/* nothing */
 		break;
 	}
-# endif
+
+	/* If software stereo detection is not supported... */
+	if (UNSET == t->rxsubchans) {
+		t->rxsubchans = V4L2_TUNER_SUB_MONO;
+		/* If the hardware itself detected stereo, also return
+		   stereo as an available subchannel */
+		if (V4L2_TUNER_MODE_STEREO == t->audmode)
+			t->rxsubchans |= V4L2_TUNER_SUB_STEREO;
+	}
 	return;
 }
 
@@ -900,6 +912,7 @@
 		break;
 	case WW_BG:
 	case WW_DK:
+	case WW_M:
 	case WW_I:
 	case WW_L:
 		if (1 == core->use_nicam) {
diff -r ff5430b54ac2 -r 32593e0b3a92 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Mon Mar 30 08:27:06 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88.h	Tue Mar 31 03:08:15 2009 +0200
@@ -66,6 +66,8 @@
 #define VBI_LINE_COUNT              17
 #define VBI_LINE_LENGTH           2048
 
+#define AUD_RDS_LINES		     4
+
 /* need "shadow" registers for some write-only ones ... */
 #define SHADOW_AUD_VOL_CTL           1
 #define SHADOW_AUD_BAL_CTL           2
@@ -133,6 +135,7 @@
 #define SRAM_CH25 4   /* audio */
 #define SRAM_CH26 5
 #define SRAM_CH28 6   /* mpeg */
+#define SRAM_CH27 7   /* audio rds */
 /* more */
 
 struct sram_channel {
@@ -354,6 +357,7 @@
 	u32                        input;
 	u32                        astat;
 	u32			   use_nicam;
+	unsigned long		   last_change;
 
 	/* IR remote control state */
 	struct cx88_IR             *ir;
@@ -673,6 +677,7 @@
 #define WW_I2SPT	 8
 #define WW_FM		 9
 #define WW_I2SADC	 10
+#define WW_M		 11
 
 void cx88_set_tvaudio(struct cx88_core *core);
 void cx88_newstation(struct cx88_core *core);
@@ -684,6 +689,11 @@
 int cx8802_unregister_driver(struct cx8802_driver *drv);
 struct cx8802_dev *cx8802_get_device(int minor);
 struct cx8802_driver * cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_type btype);
+
+/* ----------------------------------------------------------- */
+/* cx88-dsp.c                                                  */
+
+s32 cx88_dsp_detect_stereo_sap(struct cx88_core *core);
 
 /* ----------------------------------------------------------- */
 /* cx88-input.c                                                */
