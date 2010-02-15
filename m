Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50570 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab0BOXAQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 18:00:16 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Nh9vJ-0006iC-EX
	for linux-media@vger.kernel.org; Tue, 16 Feb 2010 00:00:13 +0100
Received: from 80-218-69-65.dclient.hispeed.ch ([80.218.69.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 00:00:13 +0100
Received: from auslands-kv by 80-218-69-65.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 00:00:13 +0100
To: linux-media@vger.kernel.org
From: Michael <auslands-kv@gmx.de>
Subject: Re: cx23885
Date: Mon, 15 Feb 2010 23:58:04 +0100
Message-ID: <hlcjhq$unq$2@ger.gmane.org>
References: <hlbe6t$kc4$1@ger.gmane.org> <1266238446.3075.13.camel@palomino.walls.org> <hlbhck$uh9$1@ger.gmane.org> <4B795D1A.9040502@kernellabs.com> <hlbopr$v7s$1@ger.gmane.org> <4B79803B.4070302@kernellabs.com> <hlcbhu$4s3$1@ger.gmane.org> <4B79B437.5000004@kernellabs.com> <hlch5h$ogp$1@ger.gmane.org> <hlciur$tb0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1381761.v5GgRCHD5W"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1381761.v5GgRCHD5W
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit

And here the cx25840 diff, again commell versus 2.6.31.4.

P.S.: I will order a card now. Otherwise I can't test any patches...


--nextPart1381761.v5GgRCHD5W
Content-Type: text/x-patch; name="cx25840-commell.diff"
Content-Transfer-Encoding: 8Bit
Content-Disposition: attachment; filename="cx25840-commell.diff"

diff -u cx25840/cx25840-audio.c cx25840-commell/cx25840-audio.c
--- cx25840/cx25840-audio.c	2010-02-15 23:23:01.000000000 +0100
+++ cx25840-commell/cx25840-audio.c	2009-11-11 09:36:38.000000000 +0100
@@ -20,90 +20,141 @@
 #include <linux/i2c.h>
 #include <media/v4l2-common.h>
 #include <media/cx25840.h>
+#include "compat.h"
 
 #include "cx25840-core.h"
 
-static int set_audclk_freq(struct i2c_client *client, u32 freq)
+/*
+ * Note: The PLL and SRC parameters are based on a reference frequency that
+ * would ideally be:
+ *
+ * NTSC Color subcarrier freq * 8 = 4.5 MHz/286 * 455/2 * 8 = 28.63636363... MHz
+ *
+ * However, it's not the exact reference frequency that matters, only that the
+ * firmware and modules that comprise the driver for a particular board all
+ * use the same value (close to the ideal value).
+ *
+ * Comments below will note which reference frequency is assumed for various
+ * parameters.  They will usually be one of
+ *
+ *	ref_freq = 28.636360 MHz
+ *		or
+ *	ref_freq = 28.636363 MHz
+ */
+
+static int cx25840_set_audclk_freq(struct i2c_client *client, u32 freq)
 {
 	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
 
-	if (freq != 32000 && freq != 44100 && freq != 48000)
-		return -EINVAL;
-
-	/* common for all inputs and rates */
-	/* SA_MCLK_SEL=1, SA_MCLK_DIV=0x10 */
-	if (!state->is_cx23885 && !state->is_cx231xx)
-		cx25840_write(client, 0x127, 0x50);
-
 	if (state->aud_input != CX25840_AUDIO_SERIAL) {
 		switch (freq) {
 		case 32000:
-			if (state->is_cx23885) {
-				/* We don't have register values
-				 * so avoid destroying registers. */
-				break;
-			}
-
-			if (!state->is_cx231xx) {
-				/* VID_PLL and AUX_PLL */
-				cx25840_write4(client, 0x108, 0x1006040f);
+			/*
+			 * VID_PLL Integer = 0x0f, VID_PLL Post Divider = 0x04
+			 * AUX_PLL Integer = 0x06, AUX PLL Post Divider = 0x10
+			 */
+			cx25840_write4(client, 0x108, 0x1006040f);
+
+			/*
+			 * VID_PLL Fraction (register 0x10c) = 0x2be2fe
+			 * 28636360 * 0xf.15f17f0/4 = 108 MHz
+			 * 432 MHz pre-postdivide
+			 */
+
+			/*
+			 * AUX_PLL Fraction = 0x1bb39ee
+			 * 28636363 * 0x6.dd9cf70/0x10 = 32000 * 384
+			 * 196.6 MHz pre-postdivide
+			 * FIXME < 200 MHz is out of specified valid range
+			 * FIXME 28636363 ref_freq doesn't match VID PLL ref
+			 */
+			cx25840_write4(client, 0x110, 0x01bb39ee);
+
+			/*
+			 * SA_MCLK_SEL = 1
+			 * SA_MCLK_DIV = 0x10 = 384/384 * AUX_PLL post dvivider
+			 */
+			cx25840_write(client, 0x127, 0x50);
 
-				/* AUX_PLL_FRAC */
-				cx25840_write4(client, 0x110, 0x01bb39ee);
-			}
-
-			if (state->is_cx25836)
+			if (is_cx2583x(state))
 				break;
 
-			/* src3/4/6_ctl = 0x0801f77f */
+			/* src3/4/6_ctl */
+			/* 0x1.f77f = (4 * 28636360/8 * 2/455) / 32000 */
 			cx25840_write4(client, 0x900, 0x0801f77f);
 			cx25840_write4(client, 0x904, 0x0801f77f);
 			cx25840_write4(client, 0x90c, 0x0801f77f);
 			break;
 
 		case 44100:
-			if (state->is_cx23885) {
-				/* We don't have register values
-				 * so avoid destroying registers. */
-				break;
-			}
-
-			if (!state->is_cx231xx) {
-				/* VID_PLL and AUX_PLL */
-				cx25840_write4(client, 0x108, 0x1009040f);
-
-				/* AUX_PLL_FRAC */
-				cx25840_write4(client, 0x110, 0x00ec6bd6);
-			}
+			/*
+			 * VID_PLL Integer = 0x0f, VID_PLL Post Divider = 0x04
+			 * AUX_PLL Integer = 0x09, AUX PLL Post Divider = 0x10
+			 */
+			cx25840_write4(client, 0x108, 0x1009040f);
+
+			/*
+			 * VID_PLL Fraction (register 0x10c) = 0x2be2fe
+			 * 28636360 * 0xf.15f17f0/4 = 108 MHz
+			 * 432 MHz pre-postdivide
+			 */
+
+			/*
+			 * AUX_PLL Fraction = 0x0ec6bd6
+			 * 28636363 * 0x9.7635eb0/0x10 = 44100 * 384
+			 * 271 MHz pre-postdivide
+			 * FIXME 28636363 ref_freq doesn't match VID PLL ref
+			 */
+			cx25840_write4(client, 0x110, 0x00ec6bd6);
+
+			/*
+			 * SA_MCLK_SEL = 1
+			 * SA_MCLK_DIV = 0x10 = 384/384 * AUX_PLL post dvivider
+			 */
+			cx25840_write(client, 0x127, 0x50);
 
-			if (state->is_cx25836)
+			if (is_cx2583x(state))
 				break;
 
-			/* src3/4/6_ctl = 0x08016d59 */
+			/* src3/4/6_ctl */
+			/* 0x1.6d59 = (4 * 28636360/8 * 2/455) / 44100 */
 			cx25840_write4(client, 0x900, 0x08016d59);
 			cx25840_write4(client, 0x904, 0x08016d59);
 			cx25840_write4(client, 0x90c, 0x08016d59);
 			break;
 
 		case 48000:
-			if (state->is_cx23885) {
-				/* We don't have register values
-				 * so avoid destroying registers. */
-				break;
-			}
-
-			if (!state->is_cx231xx) {
-				/* VID_PLL and AUX_PLL */
-				cx25840_write4(client, 0x108, 0x100a040f);
-
-				/* AUX_PLL_FRAC */
-				cx25840_write4(client, 0x110, 0x0098d6e5);
-			}
+			/*
+			 * VID_PLL Integer = 0x0f, VID_PLL Post Divider = 0x04
+			 * AUX_PLL Integer = 0x0a, AUX PLL Post Divider = 0x10
+			 */
+			cx25840_write4(client, 0x108, 0x100a040f);
+
+			/*
+			 * VID_PLL Fraction (register 0x10c) = 0x2be2fe
+			 * 28636360 * 0xf.15f17f0/4 = 108 MHz
+			 * 432 MHz pre-postdivide
+			 */
+
+			/*
+			 * AUX_PLL Fraction = 0x098d6e5
+			 * 28636363 * 0xa.4c6b728/0x10 = 48000 * 384
+			 * 295 MHz pre-postdivide
+			 * FIXME 28636363 ref_freq doesn't match VID PLL ref
+			 */
+			cx25840_write4(client, 0x110, 0x0098d6e5);
+
+			/*
+			 * SA_MCLK_SEL = 1
+			 * SA_MCLK_DIV = 0x10 = 384/384 * AUX_PLL post dvivider
+			 */
+			cx25840_write(client, 0x127, 0x50);
 
-			if (state->is_cx25836)
+			if (is_cx2583x(state))
 				break;
 
-			/* src3/4/6_ctl = 0x08014faa */
+			/* src3/4/6_ctl */
+			/* 0x1.4faa = (4 * 28636360/8 * 2/455) / 48000 */
 			cx25840_write4(client, 0x900, 0x08014faa);
 			cx25840_write4(client, 0x904, 0x08014faa);
 			cx25840_write4(client, 0x90c, 0x08014faa);
@@ -112,91 +163,249 @@
 	} else {
 		switch (freq) {
 		case 32000:
-			if (state->is_cx23885) {
-				/* We don't have register values
-				 * so avoid destroying registers. */
-				break;
-			}
-
-			if (!state->is_cx231xx) {
-				/* VID_PLL and AUX_PLL */
-				cx25840_write4(client, 0x108, 0x1e08040f);
-
-				/* AUX_PLL_FRAC */
-				cx25840_write4(client, 0x110, 0x012a0869);
-			}
+			/*
+			 * VID_PLL Integer = 0x0f, VID_PLL Post Divider = 0x04
+			 * AUX_PLL Integer = 0x08, AUX PLL Post Divider = 0x1e
+			 */
+			cx25840_write4(client, 0x108, 0x1e08040f);
+
+			/*
+			 * VID_PLL Fraction (register 0x10c) = 0x2be2fe
+			 * 28636360 * 0xf.15f17f0/4 = 108 MHz
+			 * 432 MHz pre-postdivide
+			 */
+
+			/*
+			 * AUX_PLL Fraction = 0x12a0869
+			 * 28636363 * 0x8.9504348/0x1e = 32000 * 256
+			 * 246 MHz pre-postdivide
+			 * FIXME 28636363 ref_freq doesn't match VID PLL ref
+			 */
+			cx25840_write4(client, 0x110, 0x012a0869);
+
+			/*
+			 * SA_MCLK_SEL = 1
+			 * SA_MCLK_DIV = 0x14 = 256/384 * AUX_PLL post dvivider
+			 */
+			cx25840_write(client, 0x127, 0x54);
 
-			if (state->is_cx25836)
+			if (is_cx2583x(state))
 				break;
 
-			/* src1_ctl = 0x08010000 */
+			/* src1_ctl */
+			/* 0x1.0000 = 32000/32000 */
 			cx25840_write4(client, 0x8f8, 0x08010000);
 
-			/* src3/4/6_ctl = 0x08020000 */
+			/* src3/4/6_ctl */
+			/* 0x2.0000 = 2 * (32000/32000) */
 			cx25840_write4(client, 0x900, 0x08020000);
 			cx25840_write4(client, 0x904, 0x08020000);
 			cx25840_write4(client, 0x90c, 0x08020000);
-
-			/* SA_MCLK_SEL=1, SA_MCLK_DIV=0x14 */
-			cx25840_write(client, 0x127, 0x54);
 			break;
 
 		case 44100:
-			if (state->is_cx23885) {
-				/* We don't have register values
-				 * so avoid destroying registers. */
+			/*
+			 * VID_PLL Integer = 0x0f, VID_PLL Post Divider = 0x04
+			 * AUX_PLL Integer = 0x09, AUX PLL Post Divider = 0x18
+			 */
+			cx25840_write4(client, 0x108, 0x1809040f);
+
+			/*
+			 * VID_PLL Fraction (register 0x10c) = 0x2be2fe
+			 * 28636360 * 0xf.15f17f0/4 = 108 MHz
+			 * 432 MHz pre-postdivide
+			 */
+
+			/*
+			 * AUX_PLL Fraction = 0x0ec6bd6
+			 * 28636363 * 0x9.7635eb0/0x18 = 44100 * 256
+			 * 271 MHz pre-postdivide
+			 * FIXME 28636363 ref_freq doesn't match VID PLL ref
+			 */
+			cx25840_write4(client, 0x110, 0x00ec6bd6);
+
+			/*
+			 * SA_MCLK_SEL = 1
+			 * SA_MCLK_DIV = 0x10 = 256/384 * AUX_PLL post dvivider
+			 */
+			cx25840_write(client, 0x127, 0x50);
+
+			if (is_cx2583x(state))
 				break;
-			}
 
+			/* src1_ctl */
+			/* 0x1.60cd = 44100/32000 */
+			cx25840_write4(client, 0x8f8, 0x080160cd);
+
+			/* src3/4/6_ctl */
+			/* 0x1.7385 = 2 * (32000/44100) */
+			cx25840_write4(client, 0x900, 0x08017385);
+			cx25840_write4(client, 0x904, 0x08017385);
+			cx25840_write4(client, 0x90c, 0x08017385);
+			break;
+
+		case 48000:
+			/*
+			 * VID_PLL Integer = 0x0f, VID_PLL Post Divider = 0x04
+			 * AUX_PLL Integer = 0x0a, AUX PLL Post Divider = 0x18
+			 */
+			cx25840_write4(client, 0x108, 0x180a040f);
+
+			/*
+			 * VID_PLL Fraction (register 0x10c) = 0x2be2fe
+			 * 28636360 * 0xf.15f17f0/4 = 108 MHz
+			 * 432 MHz pre-postdivide
+			 */
+
+			/*
+			 * AUX_PLL Fraction = 0x098d6e5
+			 * 28636363 * 0xa.4c6b728/0x18 = 48000 * 256
+			 * 295 MHz pre-postdivide
+			 * FIXME 28636363 ref_freq doesn't match VID PLL ref
+			 */
+			cx25840_write4(client, 0x110, 0x0098d6e5);
+
+			/*
+			 * SA_MCLK_SEL = 1
+			 * SA_MCLK_DIV = 0x10 = 256/384 * AUX_PLL post dvivider
+			 */
+			cx25840_write(client, 0x127, 0x50);
+
+			if (is_cx2583x(state))
+				break;
+
+			/* src1_ctl */
+			/* 0x1.8000 = 48000/32000 */
+			cx25840_write4(client, 0x8f8, 0x08018000);
+
+			/* src3/4/6_ctl */
+			/* 0x1.5555 = 2 * (32000/48000) */
+			cx25840_write4(client, 0x900, 0x08015555);
+			cx25840_write4(client, 0x904, 0x08015555);
+			cx25840_write4(client, 0x90c, 0x08015555);
+			break;
+		}
+	}
+
+	state->audclk_freq = freq;
 
-			if (!state->is_cx231xx) {
-				/* VID_PLL and AUX_PLL */
-				cx25840_write4(client, 0x108, 0x1809040f);
+	return 0;
+}
 
-				/* AUX_PLL_FRAC */
-				cx25840_write4(client, 0x110, 0x00ec6bd6);
-			}
+static inline int cx25836_set_audclk_freq(struct i2c_client *client, u32 freq)
+{
+	return cx25840_set_audclk_freq(client, freq);
+}
 
-			if (state->is_cx25836)
-				break;
+static int cx23885_set_audclk_freq(struct i2c_client *client, u32 freq)
+{
+	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
+
+	if (state->aud_input != CX25840_AUDIO_SERIAL) {
+		switch (freq) {
+		case 32000:
+		case 44100:
+		case 48000:
+			/* We don't have register values
+			 * so avoid destroying registers. */
+			/* FIXME return -EINVAL; */
+			break;
+		}
+	} else {
+		switch (freq) {
+		case 32000:
+		case 44100:
+			/* We don't have register values
+			 * so avoid destroying registers. */
+			/* FIXME return -EINVAL; */
+			break;
+
+		case 48000:
+			/* src1_ctl */
+			/* 0x1.867c = 48000 / (2 * 28636360/8 * 2/455) */
+			cx25840_write4(client, 0x8f8, 0x0801867c);
+
+			/* src3/4/6_ctl */
+			/* 0x1.4faa = (4 * 28636360/8 * 2/455) / 48000 */
+			cx25840_write4(client, 0x900, 0x08014faa);
+			cx25840_write4(client, 0x904, 0x08014faa);
+			cx25840_write4(client, 0x90c, 0x08014faa);
+			break;
+		}
+	}
+
+	state->audclk_freq = freq;
+
+	return 0;
+}
+
+static int cx231xx_set_audclk_freq(struct i2c_client *client, u32 freq)
+{
+	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
+
+	if (state->aud_input != CX25840_AUDIO_SERIAL) {
+		switch (freq) {
+		case 32000:
+			/* src3/4/6_ctl */
+			/* 0x1.f77f = (4 * 28636360/8 * 2/455) / 32000 */
+			cx25840_write4(client, 0x900, 0x0801f77f);
+			cx25840_write4(client, 0x904, 0x0801f77f);
+			cx25840_write4(client, 0x90c, 0x0801f77f);
+			break;
+
+		case 44100:
+			/* src3/4/6_ctl */
+			/* 0x1.6d59 = (4 * 28636360/8 * 2/455) / 44100 */
+			cx25840_write4(client, 0x900, 0x08016d59);
+			cx25840_write4(client, 0x904, 0x08016d59);
+			cx25840_write4(client, 0x90c, 0x08016d59);
+			break;
+
+		case 48000:
+			/* src3/4/6_ctl */
+			/* 0x1.4faa = (4 * 28636360/8 * 2/455) / 48000 */
+			cx25840_write4(client, 0x900, 0x08014faa);
+			cx25840_write4(client, 0x904, 0x08014faa);
+			cx25840_write4(client, 0x90c, 0x08014faa);
+			break;
+		}
+	} else {
+		switch (freq) {
+		/* FIXME These cases make different assumptions about audclk */
+		case 32000:
+			/* src1_ctl */
+			/* 0x1.0000 = 32000/32000 */
+			cx25840_write4(client, 0x8f8, 0x08010000);
 
-			/* src1_ctl = 0x08010000 */
+			/* src3/4/6_ctl */
+			/* 0x2.0000 = 2 * (32000/32000) */
+			cx25840_write4(client, 0x900, 0x08020000);
+			cx25840_write4(client, 0x904, 0x08020000);
+			cx25840_write4(client, 0x90c, 0x08020000);
+			break;
+
+		case 44100:
+			/* src1_ctl */
+			/* 0x1.60cd = 44100/32000 */
 			cx25840_write4(client, 0x8f8, 0x080160cd);
 
-			/* src3/4/6_ctl = 0x08020000 */
+			/* src3/4/6_ctl */
+			/* 0x1.7385 = 2 * (32000/44100) */
 			cx25840_write4(client, 0x900, 0x08017385);
 			cx25840_write4(client, 0x904, 0x08017385);
 			cx25840_write4(client, 0x90c, 0x08017385);
 			break;
 
 		case 48000:
-			if (!state->is_cx23885 && !state->is_cx231xx) {
-				/* VID_PLL and AUX_PLL */
-				cx25840_write4(client, 0x108, 0x180a040f);
-
-				/* AUX_PLL_FRAC */
-				cx25840_write4(client, 0x110, 0x0098d6e5);
-			}
-
-			if (state->is_cx25836)
-				break;
+			/* src1_ctl */
+			/* 0x1.867c = 48000 / (2 * 28636360/8 * 2/455) */
+			cx25840_write4(client, 0x8f8, 0x0801867c);
 
-			if (!state->is_cx23885 && !state->is_cx231xx) {
-				/* src1_ctl */
-				cx25840_write4(client, 0x8f8, 0x08018000);
-
-				/* src3/4/6_ctl */
-				cx25840_write4(client, 0x900, 0x08015555);
-				cx25840_write4(client, 0x904, 0x08015555);
-				cx25840_write4(client, 0x90c, 0x08015555);
-			} else {
-
-				cx25840_write4(client, 0x8f8, 0x0801867c);
-
-				cx25840_write4(client, 0x900, 0x08014faa);
-				cx25840_write4(client, 0x904, 0x08014faa);
-				cx25840_write4(client, 0x90c, 0x08014faa);
-			}
+			/* src3/4/6_ctl */
+			/* 0x1.4faa = (4 * 28636360/8 * 2/455) / 48000 */
+			cx25840_write4(client, 0x900, 0x08014faa);
+			cx25840_write4(client, 0x904, 0x08014faa);
+			cx25840_write4(client, 0x90c, 0x08014faa);
 			break;
 		}
 	}
@@ -206,6 +415,25 @@
 	return 0;
 }
 
+static int set_audclk_freq(struct i2c_client *client, u32 freq)
+{
+	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
+
+	if (freq != 32000 && freq != 44100 && freq != 48000)
+		return -EINVAL;
+
+	if (is_cx231xx(state))
+		return cx231xx_set_audclk_freq(client, freq);
+
+	if (is_cx2388x(state))
+		return cx23885_set_audclk_freq(client, freq);
+
+	if (is_cx2583x(state))
+		return cx25836_set_audclk_freq(client, freq);
+
+	return cx25840_set_audclk_freq(client, freq);
+}
+
 void cx25840_audio_set_path(struct i2c_client *client)
 {
 	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
@@ -243,7 +471,7 @@
 	cx25840_and_or(client, 0x810, ~0x1, 0x00);
 
 	/* Ensure the controller is running when we exit */
-	if (state->is_cx23885 || state->is_cx231xx)
+	if (is_cx2388x(state) || is_cx231xx(state))
 		cx25840_and_or(client, 0x803, ~0x10, 0x10);
 }
 
@@ -383,7 +611,7 @@
 	struct cx25840_state *state = to_state(sd);
 	int retval;
 
-	if (!state->is_cx25836)
+	if (!is_cx2583x(state))
 		cx25840_and_or(client, 0x810, ~0x1, 1);
 	if (state->aud_input != CX25840_AUDIO_SERIAL) {
 		cx25840_and_or(client, 0x803, ~0x10, 0);
@@ -392,7 +620,7 @@
 	retval = set_audclk_freq(client, freq);
 	if (state->aud_input != CX25840_AUDIO_SERIAL)
 		cx25840_and_or(client, 0x803, ~0x10, 0x10);
-	if (!state->is_cx25836)
+	if (!is_cx2583x(state))
 		cx25840_and_or(client, 0x810, ~0x1, 0);
 	return retval;
 }
diff -u cx25840/cx25840-core.c cx25840-commell/cx25840-core.c
--- cx25840/cx25840-core.c	2010-02-15 23:23:00.000000000 +0100
+++ cx25840-commell/cx25840-core.c	2011-10-13 00:03:10.000000000 +0200
@@ -41,6 +41,7 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
 #include <media/cx25840.h>
+#include "compat.h"
 
 #include "cx25840-core.h"
 
@@ -54,6 +55,11 @@
 
 MODULE_PARM_DESC(debug, "Debugging messages [0=Off (default) 1=On]");
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 26)
+static unsigned short normal_i2c[] = { 0x88 >> 1, I2C_CLIENT_END };
+
+I2C_CLIENT_INSMOD;
+#endif
 
 /* ----------------------------------------------------------------------- */
 
@@ -178,10 +184,16 @@
 	cx25840_and_or(client, 0x15b, ~0x1e, 0x10);
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
 static void cx25840_work_handler(struct work_struct *work)
 {
 	struct cx25840_state *state = container_of(work, struct cx25840_state, fw_work);
-	cx25840_loadfw(state->c);
+#else
+static void cx25840_work_handler(void *arg)
+{
+	struct cx25840_state *state = arg;
+#endif
+//	cx25840_loadfw(state->c);
 	wake_up(&state->fw_wait);
 }
 
@@ -209,7 +221,11 @@
 	   Otherwise the kernel is blocked waiting for the
 	   bit-banging i2c interface to finish uploading the
 	   firmware. */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
 	INIT_WORK(&state->fw_work, cx25840_work_handler);
+#else
+	INIT_WORK(&state->fw_work, cx25840_work_handler, state);
+#endif
 	init_waitqueue_head(&state->fw_wait);
 	q = create_singlethread_workqueue("cx25840_fw");
 	prepare_to_wait(&state->fw_wait, &wait, TASK_UNINTERRUPTIBLE);
@@ -258,29 +274,237 @@
 	DEFINE_WAIT(wait);
 	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
 	struct workqueue_struct *q;
+    int value;
+    int orig_3d_comb;
 
-	/* Internal Reset */
-	cx25840_and_or(client, 0x102, ~0x01, 0x01);
-	cx25840_and_or(client, 0x102, ~0x01, 0x00);
-
-	/* Stop microcontroller */
-	cx25840_and_or(client, 0x803, ~0x10, 0x00);
+    orig_3d_comb = cx25840_read4(client, 0x478);
+    orig_3d_comb &= 0x11000000;
 
-	/* DIF in reset? */
-	cx25840_write(client, 0x398, 0);
+      cx25840_write(client, 0x000, 0);
+    
+      /* Internal Reset */
+      cx25840_and_or(client, 0x102, ~0x01, 0x01);
+      cx25840_and_or(client, 0x102, ~0x01, 0x00);
+      /* Stop microcontroller */
+    cx25840_and_or(client, 0x803, ~0x10, 0x00);
+    
+      /* DIF in reset? */
+      cx25840_write(client, 0x398, 0);
+    
+// autodetect
+    value = cx25840_read4(client, 0x15c);
+    value &= 0xffffc7ff;
+    value |= 0x00001000;
+    cx25840_write4(client, 0x15c, value);
+
+    value = cx25840_read4(client, 0x13c);
+    value |= 0x00000001;
+    cx25840_write4(client, 0x13c, value);
+    value &= 0xfffffffe;
+    cx25840_write4(client, 0x13c, value);
+    //reset thresher
+    cx25840_write4(client, 0x4a4, 0x8000);
+    cx25840_write4(client, 0x4a4, 0x0);
+    //restore video muted
+    cx25840_write(client, 0x414, 0x0);
+    cx25840_write(client, 0x420, 0x0);
+    cx25840_write(client, 0x421, 0x0);
+    cx25840_write(client, 0x415, 0x0);
+    
+    value = cx25840_read4(client, 0x498);
+    value &= 0xfff00000;
+    value |= 0x00000802;
+    cx25840_write4(client, 0x498, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffffdf;
+    value |= 0x00000020;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffe7ff;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x494);
+    value &= 0xffff0000;
+    value |= 0x00001000;
+    cx25840_write4(client, 0x494, value);
+
+    value = cx25840_read4(client, 0x420);
+    value &= 0xdfffffff;
+    cx25840_write4(client, 0x420, value);
+
+    value = cx25840_read4(client, 0x404);
+    value &= 0xfffffffc;
+    value |= 0x00000003;
+    cx25840_write4(client, 0x404, value);
+
+    value = cx25840_read4(client, 0x404);
+    value &= 0xfffffff7;
+    value |= 0x00000008;
+    cx25840_write4(client, 0x404, value);
+
+//set input mux 0x0502 channel 0x0201
+    value = cx25840_read4(client, 0x100);
+    value &= 0x00E9FFFF;
+	value |= 0x11100000;
+    cx25840_write4(client, 0x100, value);
+    value = cx25840_read4(client, 0x100);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffffdf;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xfffffff0;
+    value |= 0x00000005;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffffdf;
+    value |= 0x00000020;
+    cx25840_write4(client, 0x400, value);
+
+    //3d comb
+    cx25840_write4(client, 0x490, 0xcd3f0288);  
+
+//do mode ctrl[S]
+    value = cx25840_read4(client, 0x474);
+    value &= 0xfffffc00;
+    value |= 0x00000024;
+    cx25840_write4(client, 0x474, value);
+/*    value = cx25840_read4(client, 0x474);
+    value &= 0xffc00fff;
+    value |= 0x001e6000;
+    cx25840_write4(client, 0x474, value);
+    value = cx25840_read4(client, 0x474);
+    value &= 0x00ffffff;
+    value |= 0x1e000000;
+    cx25840_write4(client, 0x474, value);
+*/
+    value = cx25840_read4(client, 0x470);
+    value &= 0xfffffc00;
+    value |= 0x00000089;
+    cx25840_write4(client, 0x470, value);
+//do mode ctrl[E]
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffffdf;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xfffffff0;
+    value |= 0x00000004;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffffdf;
+    value |= 0x00000020;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x478);
+    value &= 0x3fffffff;
+    value |= orig_3d_comb;    
+    cx25840_write4(client, 0x478, value);
+
+    //do mode ctrl   
+    value = cx25840_read4(client, 0x490);
+    value &= 0xfffffffc;
+    cx25840_write4(client, 0x490, value);
+
+    value = cx25840_read4(client, 0x474);
+    value &= 0xfffffc00;
+    value |= 0x00000024;
+    cx25840_write4(client, 0x474, value);
+/*    value = cx25840_read4(client, 0x474);
+    value &= 0xffc00fff;
+    value |= 0x001e6000;
+    cx25840_write4(client, 0x474, value);
+    value = cx25840_read4(client, 0x474);
+    value &= 0x00ffffff;
+    value |= 0x1e000000;
+    cx25840_write4(client, 0x474, value);
+*/
+    value = cx25840_read4(client, 0x470);
+    value &= 0xfffffc00;
+    value |= 0x00000089;
+    cx25840_write4(client, 0x470, value);
+    
+    //brightness
+	cx25840_write(client, 0x414, 0);
+    //contrast
+	cx25840_write(client, 0x415, 0x80);
+    //sharpness
+	cx25840_write(client, 0x416, 0);
+    //saturation
+	cx25840_write(client, 0x420, 0x80);
+	cx25840_write(client, 0x421, 0x80);
+    //hue
+	cx25840_write(client, 0x422, 0);
+	cx25840_write4(client, 0x418, 0);
+	cx25840_write4(client, 0x41c, 0);
+	cx25840_write4(client, 0x100, 0x11100000);
+    cx25840_write4(client, 0x400, 0xe021);
+    cx25840_write4(client, 0x400, 0xe021);
+    cx25840_write4(client, 0x104, 0x704dd80);
+/*     cx25840_write4(client, 0x490, 0xcd3f0288);
+//do mode ctrl 
+   cx25840_write4(client, 0x474, 0x1e1e601a);
+    cx25840_write4(client, 0x474, 0x1e1e601a);
+    cx25840_write4(client, 0x474, 0x1e1e601a);
+    cx25840_write4(client, 0x470, 0x5b2d007f);
+    cx25840_write4(client, 0x49c, 0x20504014);
+    cx25840_write4(client, 0x498, 0x802);
+    cx25840_write4(client, 0x498, 0x802);
+*/
+    cx25840_write4(client, 0x160, 0x1d);
+    cx25840_write4(client, 0x164, 0x2);
+#if 1 //wpwp
+	/*
+	 * Come out of digital power down
+	 * The CX23888, at least, needs this, otherwise registers aside from
+	 * 0x0-0x2 can't be read or written.
+	 */
 
-	/* Trust the default xtal, no division */
-	/* This changes for the cx23888 products */
-	cx25840_write(client, 0x2, 0x76);
+	/*
+	 * Trust the default xtal, no division
+	 * '885: 28.636363... MHz
+	 * '887: 25.000000 MHz
+	 * '888: 50.000000 MHz
+	 */
+	cx25840_write(client, 0x2, 0x77);
 
-	/* Bring down the regulator for AUX clk */
+	/* Power up all the PLL's and DLL */
 	cx25840_write(client, 0x1, 0x40);
 
-	/* Sys PLL frac */
-	cx25840_write4(client, 0x11c, 0x01d1744c);
-
-	/* Sys PLL int */
-	cx25840_write4(client, 0x118, 0x00000416);
+	/* Sys PLL */
+	switch (state->id) {
+	case V4L2_IDENT_CX23888_AV:
+		/*
+		 * 50.0 MHz * (0xb + 0xe8ba26/0x2000000)/4 = 5 * 28.636363 MHz
+		 * 572.73 MHz before post divide
+		 */
+		cx25840_write4(client, 0x11c, 0x00e8ba26);
+		cx25840_write4(client, 0x118, 0x0000040b);
+		break;
+	case V4L2_IDENT_CX23887_AV:
+		/*
+		 * 25.0 MHz * (0x16 + 0x1d1744c/0x2000000)/4 = 5 * 28.636363 MHz
+		 * 572.73 MHz before post divide
+		 */
+		cx25840_write4(client, 0x11c, 0x01d1744c);
+		cx25840_write4(client, 0x118, 0x00000416);
+		break;
+	case V4L2_IDENT_CX23885_AV:
+	default:
+		/*
+		 * 28.636363 MHz * (0x14 + 0x0/0x2000000)/4 = 5 * 28.636363 MHz
+		 * 572.73 MHz before post divide
+		 */
+		cx25840_write4(client, 0x11c, 0x00CCCCCC);
+		cx25840_write4(client, 0x118, 0x00000414);
+		break;
+	}
 
 	/* Disable DIF bypass */
 	cx25840_write4(client, 0x33c, 0x00000001);
@@ -288,11 +512,17 @@
 	/* DIF Src phase inc */
 	cx25840_write4(client, 0x340, 0x0df7df83);
 
-	/* Vid PLL frac */
-	cx25840_write4(client, 0x10c, 0x01b6db7b);
-
-	/* Vid PLL int */
-	cx25840_write4(client, 0x108, 0x00000512);
+	/*
+	 * Vid PLL
+	 * Setup for a BT.656 pixel clock of 13.5 Mpixels/second
+	 *
+	 * 28.636363 MHz * (0xf + 0x02be2c9/0x2000000)/4 = 8 * 13.5 MHz
+	 * 432.0 MHz before post divide
+	 */
+	cx25840_write4(client, 0x10c, 0x002be2c9);
+	cx25840_write4(client, 0x108, 0x0000040f);
+    cx25840_write4(client, 0x10c, 0x01B6DB7B);
+    cx25840_write4(client, 0x108, 0x00000512);
 
 	/* Luma */
 	cx25840_write4(client, 0x414, 0x00107d12);
@@ -300,11 +530,43 @@
 	/* Chroma */
 	cx25840_write4(client, 0x420, 0x3d008282);
 
-	/* Aux PLL frac */
-	cx25840_write4(client, 0x114, 0x017dbf48);
-
-	/* Aux PLL int */
-	cx25840_write4(client, 0x110, 0x000a030e);
+	/*
+	 * Aux PLL
+	 * Initial setup for audio sample clock:
+	 * 48 ksps, 16 bits/sample, x160 multiplier = 122.88 MHz
+	 * Intial I2S output/master clock(?):
+	 * 48 ksps, 16 bits/sample, x16 multiplier = 12.288 MHz
+	 */
+	switch (state->id) {
+	case V4L2_IDENT_CX23888_AV:
+		/*
+		 * 50.0 MHz * (0x7 + 0x0bedfa4/0x2000000)/3 = 122.88 MHz
+		 * 368.64 MHz before post divide
+		 * 122.88 MHz / 0xa = 12.288 MHz
+		 */
+		cx25840_write4(client, 0x114, 0x00bedfa4);
+		cx25840_write4(client, 0x110, 0x000a0307);
+		break;
+	case V4L2_IDENT_CX23887_AV:
+		/*
+		 * 25.0 MHz * (0xe + 0x17dbf48/0x2000000)/3 = 122.88 MHz
+		 * 368.64 MHz before post divide
+		 * 122.88 MHz / 0xa = 12.288 MHz
+		 */
+		cx25840_write4(client, 0x114, 0x017dbf48);
+		cx25840_write4(client, 0x110, 0x000a030e);
+		break;
+	case V4L2_IDENT_CX23885_AV:
+	default:
+		/*
+		 * 28.636363 MHz * (0xc + 0x1bf0c9e/0x2000000)/3 = 122.88 MHz
+		 * 368.64 MHz before post divide
+		 * 122.88 MHz / 0xa = 12.288 MHz
+		 */
+		cx25840_write4(client, 0x114, 0x01bf0c9e);
+		cx25840_write4(client, 0x110, 0x000a030c);
+		break;
+	};
 
 	/* ADC2 input select */
 	cx25840_write(client, 0x102, 0x10);
@@ -314,6 +576,10 @@
 
 	/* Enable format auto detect */
 	cx25840_write(client, 0x400, 0);
+#if 0
+	/* Force to NTSC-M and Disable autoconf regs */
+	cx25840_write(client, 0x400, 0x21);
+#endif
 	/* Fast subchroma lock */
 	/* White crush, Chroma AGC & Chroma Killer enabled */
 	cx25840_write(client, 0x401, 0xe8);
@@ -321,11 +587,25 @@
 	/* Select AFE clock pad output source */
 	cx25840_write(client, 0x144, 0x05);
 
+	/* Drive GPIO2 direction and values for HVR1700
+	 * where an onboard mux selects the output of demodulator
+	 * vs the 417. Failure to set this results in no DTV.
+	 * It's safe to set this across all Hauppauge boards
+	 * currently, regardless of the board type.
+	 */
+	cx25840_write(client, 0x160, 0x1d);
+
+	cx25840_write(client, 0x164, 0x02);
+#endif
 	/* Do the firmware load in a work handler to prevent.
 	   Otherwise the kernel is blocked waiting for the
 	   bit-banging i2c interface to finish uploading the
 	   firmware. */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
 	INIT_WORK(&state->fw_work, cx25840_work_handler);
+#else
+	INIT_WORK(&state->fw_work, cx25840_work_handler, state);
+#endif
 	init_waitqueue_head(&state->fw_wait);
 	q = create_singlethread_workqueue("cx25840_fw");
 	prepare_to_wait(&state->fw_wait, &wait, TASK_UNINTERRUPTIBLE);
@@ -334,10 +614,10 @@
 	finish_wait(&state->fw_wait, &wait);
 	destroy_workqueue(q);
 
-	cx25840_std_setup(client);
+//	cx25840_std_setup(client);
 
 	/* (re)set input */
-	set_input(client, state->vid_input, state->aud_input);
+//	set_input(client, state->vid_input, state->aud_input);
 
 	/* start microcontroller */
 	cx25840_and_or(client, 0x803, ~0x10, 0x10);
@@ -388,6 +668,10 @@
 
 	/* Enable format auto detect */
 	cx25840_write(client, 0x400, 0);
+#if 0
+	/* Force to NTSC-M and Disable autoconf regs */
+	cx25840_write(client, 0x400, 0x21);
+#endif
 	/* Fast subchroma lock */
 	/* White crush, Chroma AGC & Chroma Killer enabled */
 	cx25840_write(client, 0x401, 0xe8);
@@ -396,7 +680,11 @@
 	   Otherwise the kernel is blocked waiting for the
 	   bit-banging i2c interface to finish uploading the
 	   firmware. */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
 	INIT_WORK(&state->fw_work, cx25840_work_handler);
+#else
+	INIT_WORK(&state->fw_work, cx25840_work_handler, state);
+#endif
 	init_waitqueue_head(&state->fw_wait);
 	q = create_singlethread_workqueue("cx25840_fw");
 	prepare_to_wait(&state->fw_wait, &wait, TASK_UNINTERRUPTIBLE);
@@ -405,7 +693,7 @@
 	finish_wait(&state->fw_wait, &wait);
 	destroy_workqueue(q);
 
-	cx25840_std_setup(client);
+//	cx25840_std_setup(client);
 
 	/* (re)set input */
 	set_input(client, state->vid_input, state->aud_input);
@@ -485,13 +773,10 @@
 	}
 
 	/* DEBUG: Displays configured PLL frequency */
-	if (!state->is_cx231xx) {
+	if (!is_cx231xx(state)) {
 		pll_int = cx25840_read(client, 0x108);
 		pll_frac = cx25840_read4(client, 0x10c) & 0x1ffffff;
 		pll_post = cx25840_read(client, 0x109);
-		v4l_dbg(1, cx25840_debug, client,
-			"PLL regs = int: %u, frac: %u, post: %u\n",
-			pll_int, pll_frac, pll_post);
 
 		if (pll_post) {
 			int fin, fsc;
@@ -629,7 +914,7 @@
 	v4l_dbg(1, cx25840_debug, client,
 		"decoder set video input %d, audio input %d\n",
 		vid_input, aud_input);
-
+#if 1 //wpwp
 	if (vid_input >= CX25840_VIN1_CH1) {
 		v4l_dbg(1, cx25840_debug, client, "vid_input 0x%x\n",
 			vid_input);
@@ -669,7 +954,7 @@
 	 * configuration in reg (for the cx23885) so we have no
 	 * need to attempt to flip bits for earlier av decoders.
 	 */
-	if (!state->is_cx23885 && !state->is_cx231xx) {
+	if (!is_cx2388x(state) && !is_cx231xx(state)) {
 		switch (aud_input) {
 		case CX25840_AUDIO_SERIAL:
 			/* do nothing, use serial audio input */
@@ -692,31 +977,38 @@
 	/* Set INPUT_MODE to Composite (0) or S-Video (1) */
 	cx25840_and_or(client, 0x401, ~0x6, is_composite ? 0 : 0x02);
 
-	if (!state->is_cx23885 && !state->is_cx231xx) {
+	if (!is_cx2388x(state) && !is_cx231xx(state)) {
 		/* Set CH_SEL_ADC2 to 1 if input comes from CH3 */
-		cx25840_and_or(client, 0x102, ~0x2, (reg & 0x80) == 0 ? 2 : 0);
+		cx25840_and_or(client, 0x102, ~0x2, (reg & 0x80) == 0 ? 0x12 : 0x10);
 		/* Set DUAL_MODE_ADC2 to 1 if input comes from both CH2&CH3 */
 		if ((reg & 0xc0) != 0xc0 && (reg & 0x30) != 0x30)
-			cx25840_and_or(client, 0x102, ~0x4, 4);
+			cx25840_and_or(client, 0x102, ~0x4, 0x14);
 		else
-			cx25840_and_or(client, 0x102, ~0x4, 0);
+			cx25840_and_or(client, 0x102, ~0x4, 0x10);
 	} else {
 		if (is_composite)
 			/* ADC2 input select channel 2 */
-			cx25840_and_or(client, 0x102, ~0x2, 0);
+			cx25840_and_or(client, 0x102, ~0x2, 0x10);
 		else
 			/* ADC2 input select channel 3 */
-			cx25840_and_or(client, 0x102, ~0x2, 2);
+			cx25840_and_or(client, 0x102, ~0x2, 0x12);
 	}
 
+//	cx25840_and_or(client, 0x400, 0xffffffdf, 0x20);
+//	cx25840_and_or(client, 0x400, 0xfffff9ff, 0);
+
+    
+//	cx25840_and_or(client, 0x490, 0xfffffffc, 0);
+//	cx25840_and_or(client, 0x474, 0xfffffc00, 0x24);
+//	cx25840_and_or(client, 0x470, 0xfffffc00, 0x89);
 	state->vid_input = vid_input;
 	state->aud_input = aud_input;
-	if (!state->is_cx25836) {
+	if (!is_cx2583x(state)) {
 		cx25840_audio_set_path(client);
 		input_change(client);
 	}
 
-	if (state->is_cx23885) {
+	if (is_cx2388x(state)) {
 		/* Audio channel 1 src : Parallel 1 */
 		cx25840_write(client, 0x124, 0x03);
 
@@ -732,7 +1024,7 @@
 		 */
 		cx25840_write(client, 0x918, 0xa0);
 		cx25840_write(client, 0x919, 0x01);
-	} else if (state->is_cx231xx) {
+	} else if (is_cx231xx(state)) {
 		/* Audio channel 1 src : Parallel 1 */
 		cx25840_write(client, 0x124, 0x03);
 
@@ -746,7 +1038,7 @@
 		cx25840_write(client, 0x918, 0xa0);
 		cx25840_write(client, 0x919, 0x01);
 	}
-
+#endif
 	return 0;
 }
 
@@ -757,7 +1049,7 @@
 	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
 	u8 fmt = 0; 	/* zero is autodetect */
 	u8 pal_m = 0;
-
+#if 1
 	/* First tests should be against specific std */
 	if (state->std == V4L2_STD_NTSC_M_JP) {
 		fmt = 0x2;
@@ -796,8 +1088,9 @@
 	cx25840_and_or(client, 0x400, ~0xf, fmt);
 	cx25840_and_or(client, 0x403, ~0x3, pal_m);
 	cx25840_std_setup(client);
-	if (!state->is_cx25836)
+	if (!is_cx2583x(state))
 		input_change(client);
+#endif    
 	return 0;
 }
 
@@ -846,12 +1139,12 @@
 		break;
 
 	case V4L2_CID_HUE:
-		if (ctrl->value < -128 || ctrl->value > 127) {
+		if (ctrl->value < 0 || ctrl->value > 255) {
 			v4l_err(client, "invalid hue setting %d\n", ctrl->value);
 			return -ERANGE;
 		}
 
-		cx25840_write(client, 0x422, ctrl->value);
+		cx25840_write(client, 0x422, ctrl->value - 128 );
 		break;
 
 	case V4L2_CID_AUDIO_VOLUME:
@@ -859,7 +1152,7 @@
 	case V4L2_CID_AUDIO_TREBLE:
 	case V4L2_CID_AUDIO_BALANCE:
 	case V4L2_CID_AUDIO_MUTE:
-		if (state->is_cx25836)
+		if (is_cx2583x(state))
 			return -EINVAL;
 		return cx25840_audio_s_ctrl(sd, ctrl);
 
@@ -889,14 +1182,14 @@
 		ctrl->value = cx25840_read(client, 0x420) >> 1;
 		break;
 	case V4L2_CID_HUE:
-		ctrl->value = (s8)cx25840_read(client, 0x422);
+		ctrl->value = (s8)cx25840_read(client, 0x422) + 128;
 		break;
 	case V4L2_CID_AUDIO_VOLUME:
 	case V4L2_CID_AUDIO_BASS:
 	case V4L2_CID_AUDIO_TREBLE:
 	case V4L2_CID_AUDIO_BALANCE:
 	case V4L2_CID_AUDIO_MUTE:
-		if (state->is_cx25836)
+		if (is_cx2583x(state))
 			return -EINVAL;
 		return cx25840_audio_g_ctrl(sd, ctrl);
 	default:
@@ -1200,11 +1493,11 @@
 	if (!state->is_initialized) {
 		/* initialize and load firmware */
 		state->is_initialized = 1;
-		if (state->is_cx25836)
+		if (is_cx2583x(state))
 			cx25836_initialize(client);
-		else if (state->is_cx23885)
+		else if (is_cx2388x(state))
 			cx23885_initialize(client);
-		else if (state->is_cx231xx)
+		else if (is_cx231xx(state))
 			cx231xx_initialize(client);
 		else
 			cx25840_initialize(client);
@@ -1247,17 +1540,17 @@
 	v4l_dbg(1, cx25840_debug, client, "%s output\n",
 			enable ? "enable" : "disable");
 	if (enable) {
-		if (state->is_cx23885 || state->is_cx231xx) {
+		if (is_cx2388x(state) || is_cx231xx(state)) {
 			u8 v = (cx25840_read(client, 0x421) | 0x0b);
 			cx25840_write(client, 0x421, v);
 		} else {
 			cx25840_write(client, 0x115,
-					state->is_cx25836 ? 0x0c : 0x8c);
+					is_cx2583x(state) ? 0x0c : 0x8c);
 			cx25840_write(client, 0x116,
-					state->is_cx25836 ? 0x04 : 0x07);
+					is_cx2583x(state) ? 0x04 : 0x07);
 		}
 	} else {
-		if (state->is_cx23885 || state->is_cx231xx) {
+		if (is_cx2388x(state) || is_cx231xx(state)) {
 			u8 v = cx25840_read(client, 0x421) & ~(0x0b);
 			cx25840_write(client, 0x421, v);
 		} else {
@@ -1283,7 +1576,7 @@
 	default:
 		break;
 	}
-	if (state->is_cx25836)
+	if (is_cx2583x(state))
 		return -EINVAL;
 
 	switch (qc->id) {
@@ -1337,7 +1630,7 @@
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (state->is_cx25836)
+	if (is_cx2583x(state))
 		return -EINVAL;
 	return set_input(client, state->vid_input, input);
 }
@@ -1347,7 +1640,7 @@
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (!state->is_cx25836)
+	if (!is_cx2583x(state))
 		input_change(client);
 	return 0;
 }
@@ -1364,7 +1657,7 @@
 		return 0;
 
 	vt->signal = vpres ? 0xffff : 0x0;
-	if (state->is_cx25836)
+	if (is_cx2583x(state))
 		return 0;
 
 	vt->capability |=
@@ -1395,7 +1688,7 @@
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (state->radio || state->is_cx25836)
+	if (state->radio || is_cx2583x(state))
 		return 0;
 
 	switch (vt->audmode) {
@@ -1436,11 +1729,11 @@
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (state->is_cx25836)
+	if (is_cx2583x(state))
 		cx25836_initialize(client);
-	else if (state->is_cx23885)
+	else if (is_cx2388x(state))
 		cx23885_initialize(client);
-	else if (state->is_cx231xx)
+	else if (is_cx231xx(state))
 		cx231xx_initialize(client);
 	else
 		cx25840_initialize(client);
@@ -1461,7 +1754,7 @@
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	log_video_status(client);
-	if (!state->is_cx25836)
+	if (!is_cx2583x(state))
 		log_audio_status(client);
 	return 0;
 }
@@ -1512,12 +1805,50 @@
 
 /* ----------------------------------------------------------------------- */
 
+static u32 get_cx2388x_ident(struct i2c_client *client)
+{
+	u32 ret;
+
+	/* Come out of digital power down */
+	cx25840_write(client, 0x000, 0);
+
+	/* Detecting whether the part is cx23885/7/8 is more
+	 * difficult than it needs to be. No ID register. Instead we
+	 * probe certain registers indicated in the datasheets to look
+	 * for specific defaults that differ between the silicon designs. */
+
+	/* It's either 885/7 if the IR Tx Clk Divider register exists */
+	if (cx25840_read4(client, 0x204) & 0xffff) {
+		/* CX23885 returns bogus repetitive byte values for the DIF,
+		 * which doesn't exist for it. (Ex. 8a8a8a8a or 31313131) */
+		ret = cx25840_read4(client, 0x300);
+		if (((ret & 0xffff0000) >> 16) == (ret & 0xffff)) {
+			/* No DIF */
+			ret = V4L2_IDENT_CX23885_AV;
+		} else {
+			/* CX23887 has a broken DIF, but the registers
+			 * appear valid (but unsed), good enough to detect. */
+			ret = V4L2_IDENT_CX23887_AV;
+		}
+	} else if (cx25840_read4(client, 0x300) & 0x0fffffff) {
+		/* DIF PLL Freq Word reg exists; chip must be a CX23888 */
+		ret = V4L2_IDENT_CX23888_AV;
+	} else {
+		v4l_err(client, "Unable to detect h/w, assuming cx23887\n");
+		ret = V4L2_IDENT_CX23887_AV;
+	}
+
+	/* Back into digital power down */
+	cx25840_write(client, 0x000, 2);
+	return ret;
+}
+
 static int cx25840_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct cx25840_state *state;
 	struct v4l2_subdev *sd;
-	u32 id;
+	u32 id = V4L2_IDENT_NONE;
 	u16 device_id;
 
 	/* Check if the adapter supports the needed features */
@@ -1534,17 +1865,22 @@
 	 * 0x83 for the cx2583x and 0x84 for the cx2584x */
 	if ((device_id & 0xff00) == 0x8300) {
 		id = V4L2_IDENT_CX25836 + ((device_id >> 4) & 0xf) - 6;
-	}
-	else if ((device_id & 0xff00) == 0x8400) {
+	} else if ((device_id & 0xff00) == 0x8400) {
 		id = V4L2_IDENT_CX25840 + ((device_id >> 4) & 0xf);
 	} else if (device_id == 0x0000) {
-		id = V4L2_IDENT_CX25836 + ((device_id >> 4) & 0xf) - 6;
-	} else if (device_id == 0x1313) {
-		id = V4L2_IDENT_CX25836 + ((device_id >> 4) & 0xf) - 6;
+		id = get_cx2388x_ident(client);
 	} else if ((device_id & 0xfff0) == 0x5A30) {
-		id = V4L2_IDENT_CX25840 + ((device_id >> 4) & 0xf);
-	}
-	else {
+		/* The CX23100 (0x5A3C = 23100) doesn't have an A/V decoder */
+		id = V4L2_IDENT_CX2310X_AV;
+	} else if ((device_id & 0xff) == (device_id >> 8)) {
+		v4l_err(client,
+			"likely a confused/unresponsive cx2388[578] A/V decoder"
+			" found @ 0x%x (%s)\n",
+			client->addr << 1, client->adapter->name);
+		v4l_err(client, "A method to reset it from the cx25840 driver"
+			" software is not known at this time\n");
+		return -ENODEV;
+	} else {
 		v4l_dbg(1, cx25840_debug, client, "cx25840 not found\n");
 		return -ENODEV;
 	}
@@ -1555,18 +1891,46 @@
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &cx25840_ops);
-	/* Note: revision '(device_id & 0x0f) == 2' was never built. The
-	   marking skips from 0x1 == 22 to 0x3 == 23. */
-	v4l_info(client, "cx25%3x-2%x found @ 0x%x (%s)\n",
-		    (device_id & 0xfff0) >> 4,
-		    (device_id & 0x0f) < 3 ? (device_id & 0x0f) + 1 : (device_id & 0x0f),
-		    client->addr << 1, client->adapter->name);
+	switch (id) {
+	case V4L2_IDENT_CX23885_AV:
+		v4l_info(client, "cx23885 A/V decoder found @ 0x%x (%s)\n",
+			 client->addr << 1, client->adapter->name);
+		break;
+	case V4L2_IDENT_CX23887_AV:
+		v4l_info(client, "cx23887 A/V decoder found @ 0x%x (%s)\n",
+			 client->addr << 1, client->adapter->name);
+		break;
+	case V4L2_IDENT_CX23888_AV:
+		v4l_info(client, "cx23888 A/V decoder found @ 0x%x (%s)\n",
+			 client->addr << 1, client->adapter->name);
+		break;
+	case V4L2_IDENT_CX2310X_AV:
+		v4l_info(client, "cx%d A/V decoder found @ 0x%x (%s)\n",
+			 device_id, client->addr << 1, client->adapter->name);
+		break;
+	case V4L2_IDENT_CX25840:
+	case V4L2_IDENT_CX25841:
+	case V4L2_IDENT_CX25842:
+	case V4L2_IDENT_CX25843:
+		/* Note: revision '(device_id & 0x0f) == 2' was never built. The
+		   marking skips from 0x1 == 22 to 0x3 == 23. */
+		v4l_info(client, "cx25%3x-2%x found @ 0x%x (%s)\n",
+			 (device_id & 0xfff0) >> 4,
+			 (device_id & 0x0f) < 3 ? (device_id & 0x0f) + 1
+						: (device_id & 0x0f),
+			 client->addr << 1, client->adapter->name);
+		break;
+	case V4L2_IDENT_CX25836:
+	case V4L2_IDENT_CX25837:
+	default:
+		v4l_info(client, "cx25%3x-%x found @ 0x%x (%s)\n",
+			 (device_id & 0xfff0) >> 4, device_id & 0x0f,
+			 client->addr << 1, client->adapter->name);
+		break;
+	}
 
 	state->c = client;
-	state->is_cx25836 = ((device_id & 0xff00) == 0x8300);
-	state->is_cx23885 = (device_id == 0x0000) || (device_id == 0x1313);
-	state->is_cx231xx = (device_id == 0x5a3e);
-	state->vid_input = CX25840_COMPOSITE7;
+	state->vid_input = CX25840_COMPOSITE1;
 	state->aud_input = CX25840_AUDIO8;
 	state->audclk_freq = 48000;
 	state->pvr150_workaround = 0;
@@ -1578,12 +1942,6 @@
 	state->id = id;
 	state->rev = device_id;
 
-	if (state->is_cx23885) {
-		/* Drive GPIO2 direction and values */
-		cx25840_write(client, 0x160, 0x1d);
-		cx25840_write(client, 0x164, 0x00);
-	}
-
 	return 0;
 }
 
@@ -1596,15 +1954,19 @@
 	return 0;
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
 static const struct i2c_device_id cx25840_id[] = {
 	{ "cx25840", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, cx25840_id);
 
+#endif
 static struct v4l2_i2c_driver_data v4l2_i2c_data = {
 	.name = "cx25840",
 	.probe = cx25840_probe,
 	.remove = cx25840_remove,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
 	.id_table = cx25840_id,
+#endif
 };
diff -u cx25840/cx25840-core.h cx25840-commell/cx25840-core.h
--- cx25840/cx25840-core.h	2010-02-15 23:23:00.000000000 +0100
+++ cx25840-commell/cx25840-core.h	2009-11-11 09:36:36.000000000 +0100
@@ -20,9 +20,11 @@
 #ifndef _CX25840_CORE_H_
 #define _CX25840_CORE_H_
 
+#include "compat.h"
 
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
 #include <linux/i2c.h>
 
 /* ENABLE_PVR150_WORKAROUND activates a workaround for a hardware bug that is
@@ -48,9 +50,6 @@
 	int vbi_line_offset;
 	u32 id;
 	u32 rev;
-	int is_cx25836;
-	int is_cx23885;
-	int is_cx231xx;
 	int is_initialized;
 	wait_queue_head_t fw_wait;    /* wake up when the fw load is finished */
 	struct work_struct fw_work;   /* work entry for fw load */
@@ -61,6 +60,24 @@
 	return container_of(sd, struct cx25840_state, sd);
 }
 
+static inline bool is_cx2583x(struct cx25840_state *state)
+{
+	return state->id == V4L2_IDENT_CX25836 ||
+	       state->id == V4L2_IDENT_CX25837;
+}
+
+static inline bool is_cx231xx(struct cx25840_state *state)
+{
+	return state->id == V4L2_IDENT_CX2310X_AV;
+}
+
+static inline bool is_cx2388x(struct cx25840_state *state)
+{
+	return state->id == V4L2_IDENT_CX23885_AV ||
+	       state->id == V4L2_IDENT_CX23887_AV ||
+	       state->id == V4L2_IDENT_CX23888_AV;
+}
+
 /* ----------------------------------------------------------------------- */
 /* cx25850-core.c 							   */
 int cx25840_write(struct i2c_client *client, u16 addr, u8 value);
diff -u cx25840/cx25840-firmware.c cx25840-commell/cx25840-firmware.c
--- cx25840/cx25840-firmware.c	2010-02-15 23:23:01.000000000 +0100
+++ cx25840-commell/cx25840-firmware.c	2009-11-11 09:36:38.000000000 +0100
@@ -20,13 +20,10 @@
 #include <linux/firmware.h>
 #include <media/v4l2-common.h>
 #include <media/cx25840.h>
+#include "compat.h"
 
 #include "cx25840-core.h"
 
-#define FWFILE "v4l-cx25840.fw"
-#define FWFILE_CX23885 "v4l-cx23885-avcore-01.fw"
-#define FWFILE_CX231XX "v4l-cx231xx-avcore-01.fw"
-
 /*
  * Mike Isely <isely@pobox.com> - The FWSEND parameter controls the
  * size of the firmware chunks sent down the I2C bus to the chip.
@@ -40,11 +37,11 @@
 
 #define FWDEV(x) &((x)->dev)
 
-static char *firmware = FWFILE;
+static char *firmware = "";
 
 module_param(firmware, charp, 0444);
 
-MODULE_PARM_DESC(firmware, "Firmware image [default: " FWFILE "]");
+MODULE_PARM_DESC(firmware, "Firmware image to load");
 
 static void start_fw_load(struct i2c_client *client)
 {
@@ -65,6 +62,19 @@
 	cx25840_write(client, 0x803, 0x03);
 }
 
+static const char *get_fw_name(struct i2c_client *client)
+{
+	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
+
+	if (firmware[0])
+		return firmware;
+	if (is_cx2388x(state))
+		return "v4l-cx23885-avcore-01.fw";
+	if (is_cx231xx(state))
+		return "v4l-cx231xx-avcore-01.fw";
+	return "v4l-cx25840.fw";
+}
+
 static int check_fw_load(struct i2c_client *client, int size)
 {
 	/* DL_ADDR_HB DL_ADDR_LB */
@@ -72,11 +82,13 @@
 	s |= cx25840_read(client, 0x800);
 
 	if (size != s) {
-		v4l_err(client, "firmware %s load failed\n", firmware);
+		v4l_err(client, "firmware %s load failed\n",
+				get_fw_name(client));
 		return -EINVAL;
 	}
 
-	v4l_info(client, "loaded %s firmware (%d bytes)\n", firmware, size);
+	v4l_info(client, "loaded %s firmware (%d bytes)\n",
+			get_fw_name(client), size);
 	return 0;
 }
 
@@ -96,26 +108,29 @@
 	const struct firmware *fw = NULL;
 	u8 buffer[FWSEND];
 	const u8 *ptr;
+	const char *fwname = get_fw_name(client);
 	int size, retval;
 	int MAX_BUF_SIZE = FWSEND;
+	u32 gpio_oe = 0, gpio_da = 0;
 
-	if (state->is_cx23885)
-		firmware = FWFILE_CX23885;
-	else if (state->is_cx231xx)
-		firmware = FWFILE_CX231XX;
+	if (is_cx2388x(state)) {
+		/* Preserve the GPIO OE and output bits */
+		gpio_oe = cx25840_read(client, 0x160);
+		gpio_da = cx25840_read(client, 0x164);
+	}
 
-	if ((state->is_cx231xx) && MAX_BUF_SIZE > 16) {
+	if (is_cx231xx(state) && MAX_BUF_SIZE > 16) {
 		v4l_err(client, " Firmware download size changed to 16 bytes max length\n");
 		MAX_BUF_SIZE = 16;  /* cx231xx cannot accept more than 16 bytes at a time */
 	}
 
-	if (request_firmware(&fw, firmware, FWDEV(client)) != 0) {
-		v4l_err(client, "unable to open firmware %s\n", firmware);
+	if (request_firmware(&fw, fwname, FWDEV(client)) != 0) {
+		v4l_err(client, "unable to open firmware %s\n", fwname);
 		return -EINVAL;
 	}
 
 	start_fw_load(client);
-
+#if 0
 	buffer[0] = 0x08;
 	buffer[1] = 0x02;
 
@@ -136,11 +151,17 @@
 		size -= len;
 		ptr += len;
 	}
-
+#endif
 	end_fw_load(client);
 
 	size = fw->size;
 	release_firmware(fw);
 
+	if (is_cx2388x(state)) {
+		/* Restore GPIO configuration after f/w load */
+		cx25840_write(client, 0x160, gpio_oe);
+		cx25840_write(client, 0x164, gpio_da);
+	}
+
 	return check_fw_load(client, size);
 }
Nur in cx25840: cx25840.mod.c.
diff -u cx25840/cx25840-vbi.c cx25840-commell/cx25840-vbi.c
--- cx25840/cx25840-vbi.c	2010-02-15 23:23:01.000000000 +0100
+++ cx25840-commell/cx25840-vbi.c	2009-11-11 09:36:38.000000000 +0100
@@ -20,6 +20,7 @@
 #include <linux/i2c.h>
 #include <media/v4l2-common.h>
 #include <media/cx25840.h>
+#include "compat.h"
 
 #include "cx25840-core.h"
 
Nur in cx25840: modules.order.


--nextPart1381761.v5GgRCHD5W--


