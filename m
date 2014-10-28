Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46281 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaJ1PA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:00:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 01/13] [media] lgdt3306a: Use hexadecimal values in lowercase
Date: Tue, 28 Oct 2014 13:00:36 -0200
Message-Id: <aa896844a34c8689fd146e5b652b6acf15e178ad.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While this is not a mandatory rule at the CodingStyle, we prefer
hexadecimal values in lowercase. Currently, there's a mix of lowercase
and uppercase ons at lgdt3306a. So, convert all to lowercase with this
small script:

	perl -ne 'if (m,0x([\dA-F]+),) { $o=$1; $n=lc $1; s,0x($o),0x$n, } print $_'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 98d74f049201..99128d2afebb 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -80,7 +80,7 @@ struct lgdt3306a_state {
 enum lgdt3306a_lock_status {
 	LG3306_UNLOCK       = 0x00,
 	LG3306_LOCK         = 0x01,
-	LG3306_UNKNOWN_LOCK = 0xFF
+	LG3306_UNKNOWN_LOCK = 0xff
 };
 
 enum lgdt3306a_neverlock_status {
@@ -88,14 +88,14 @@ enum lgdt3306a_neverlock_status {
 	LG3306_NL_PROCESS = 0x01,
 	LG3306_NL_LOCK    = 0x02,
 	LG3306_NL_FAIL    = 0x03,
-	LG3306_NL_UNKNOWN = 0xFF
+	LG3306_NL_UNKNOWN = 0xff
 };
 
 enum lgdt3306a_modulation {
 	LG3306_VSB          = 0x00,
 	LG3306_QAM64        = 0x01,
 	LG3306_QAM256       = 0x02,
-	LG3306_UNKNOWN_MODE = 0xFF
+	LG3306_UNKNOWN_MODE = 0xff
 };
 
 enum lgdt3306a_lock_check {
@@ -284,7 +284,7 @@ static int lgdt3306a_mpeg_tristate(struct lgdt3306a_state *state,
 		ret = lgdt3306a_read_reg(state, 0x0070, &val);
 		if (lg_chkerr(ret))
 			goto fail;
-		val &= ~0xA8; /* Tristate bus; TPOUTEN=0x80, TPCLKOUTEN=0x20, TPDATAOUTEN=0x08 */
+		val &= ~0xa8; /* Tristate bus; TPOUTEN=0x80, TPCLKOUTEN=0x20, TPDATAOUTEN=0x08 */
 		ret = lgdt3306a_write_reg(state, 0x0070, val);
 		if (lg_chkerr(ret))
 			goto fail;
@@ -302,7 +302,7 @@ static int lgdt3306a_mpeg_tristate(struct lgdt3306a_state *state,
 		if (lg_chkerr(ret))
 			goto fail;
 
-		val |= 0xA8; /* enable bus */
+		val |= 0xa8; /* enable bus */
 		ret = lgdt3306a_write_reg(state, 0x0070, val);
 		if (lg_chkerr(ret))
 			goto fail;
@@ -365,7 +365,7 @@ static int lgdt3306a_set_vsb(struct lgdt3306a_state *state)
 
 	/* 0. Spectrum inversion detection manual; spectrum inverted */
 	ret = lgdt3306a_read_reg(state, 0x0002, &val);
-	val &= 0xF7; /* SPECINVAUTO Off */
+	val &= 0xf7; /* SPECINVAUTO Off */
 	val |= 0x04; /* SPECINV On */
 	ret = lgdt3306a_write_reg(state, 0x0002, val);
 	if (lg_chkerr(ret))
@@ -378,23 +378,23 @@ static int lgdt3306a_set_vsb(struct lgdt3306a_state *state)
 
 	/* 2. Bandwidth mode for VSB(6MHz) */
 	ret = lgdt3306a_read_reg(state, 0x0009, &val);
-	val &= 0xE3;
-	val |= 0x0C; /* STDOPDETTMODE[2:0]=3 */
+	val &= 0xe3;
+	val |= 0x0c; /* STDOPDETTMODE[2:0]=3 */
 	ret = lgdt3306a_write_reg(state, 0x0009, val);
 	if (lg_chkerr(ret))
 		goto fail;
 
 	/* 3. QAM mode detection mode(None) */
 	ret = lgdt3306a_read_reg(state, 0x0009, &val);
-	val &= 0xFC; /* STDOPDETCMODE[1:0]=0 */
+	val &= 0xfc; /* STDOPDETCMODE[1:0]=0 */
 	ret = lgdt3306a_write_reg(state, 0x0009, val);
 	if (lg_chkerr(ret))
 		goto fail;
 
 	/* 4. ADC sampling frequency rate(2x sampling) */
-	ret = lgdt3306a_read_reg(state, 0x000D, &val);
-	val &= 0xBF; /* SAMPLING4XFEN=0 */
-	ret = lgdt3306a_write_reg(state, 0x000D, val);
+	ret = lgdt3306a_read_reg(state, 0x000d, &val);
+	val &= 0xbf; /* SAMPLING4XFEN=0 */
+	ret = lgdt3306a_write_reg(state, 0x000d, val);
 	if (lg_chkerr(ret))
 		goto fail;
 
@@ -406,19 +406,19 @@ static int lgdt3306a_set_vsb(struct lgdt3306a_state *state)
 		goto fail;
 
 	/* AICCFIXFREQ0 NT N-1(Video rejection) */
-	ret = lgdt3306a_write_reg(state, 0x002E, 0x00);
-	ret = lgdt3306a_write_reg(state, 0x002F, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x002e, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x002f, 0x00);
 	ret = lgdt3306a_write_reg(state, 0x0030, 0x00);
 
 	/* AICCFIXFREQ1 NT N-1(Audio rejection) */
-	ret = lgdt3306a_write_reg(state, 0x002B, 0x00);
-	ret = lgdt3306a_write_reg(state, 0x002C, 0x00);
-	ret = lgdt3306a_write_reg(state, 0x002D, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x002b, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x002c, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x002d, 0x00);
 
 	/* AICCFIXFREQ2 NT Co-Channel(Video rejection) */
 	ret = lgdt3306a_write_reg(state, 0x0028, 0x00);
 	ret = lgdt3306a_write_reg(state, 0x0029, 0x00);
-	ret = lgdt3306a_write_reg(state, 0x002A, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x002a, 0x00);
 
 	/* AICCFIXFREQ3 NT Co-Channel(Audio rejection) */
 	ret = lgdt3306a_write_reg(state, 0x0025, 0x00);
@@ -434,19 +434,19 @@ static int lgdt3306a_set_vsb(struct lgdt3306a_state *state)
 		goto fail;
 
 	/* AICCFIXFREQ0 NT N-1(Video rejection) */
-	ret = lgdt3306a_write_reg(state, 0x002E, 0x5A);
-	ret = lgdt3306a_write_reg(state, 0x002F, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x002e, 0x5A);
+	ret = lgdt3306a_write_reg(state, 0x002f, 0x00);
 	ret = lgdt3306a_write_reg(state, 0x0030, 0x00);
 
 	/* AICCFIXFREQ1 NT N-1(Audio rejection) */
-	ret = lgdt3306a_write_reg(state, 0x002B, 0x36);
-	ret = lgdt3306a_write_reg(state, 0x002C, 0x00);
-	ret = lgdt3306a_write_reg(state, 0x002D, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x002b, 0x36);
+	ret = lgdt3306a_write_reg(state, 0x002c, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x002d, 0x00);
 
 	/* AICCFIXFREQ2 NT Co-Channel(Video rejection) */
 	ret = lgdt3306a_write_reg(state, 0x0028, 0x2A);
 	ret = lgdt3306a_write_reg(state, 0x0029, 0x00);
-	ret = lgdt3306a_write_reg(state, 0x002A, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x002a, 0x00);
 
 	/* AICCFIXFREQ3 NT Co-Channel(Audio rejection) */
 	ret = lgdt3306a_write_reg(state, 0x0025, 0x06);
@@ -454,57 +454,57 @@ static int lgdt3306a_set_vsb(struct lgdt3306a_state *state)
 	ret = lgdt3306a_write_reg(state, 0x0027, 0x00);
 #endif
 
-	ret = lgdt3306a_read_reg(state, 0x001E, &val);
-	val &= 0x0F;
-	val |= 0xA0;
-	ret = lgdt3306a_write_reg(state, 0x001E, val);
+	ret = lgdt3306a_read_reg(state, 0x001e, &val);
+	val &= 0x0f;
+	val |= 0xa0;
+	ret = lgdt3306a_write_reg(state, 0x001e, val);
 
 	ret = lgdt3306a_write_reg(state, 0x0022, 0x08);
 
 	ret = lgdt3306a_write_reg(state, 0x0023, 0xFF);
 
-	ret = lgdt3306a_read_reg(state, 0x211F, &val);
-	val &= 0xEF;
-	ret = lgdt3306a_write_reg(state, 0x211F, val);
+	ret = lgdt3306a_read_reg(state, 0x211f, &val);
+	val &= 0xef;
+	ret = lgdt3306a_write_reg(state, 0x211f, val);
 
 	ret = lgdt3306a_write_reg(state, 0x2173, 0x01);
 
 	ret = lgdt3306a_read_reg(state, 0x1061, &val);
-	val &= 0xF8;
+	val &= 0xf8;
 	val |= 0x04;
 	ret = lgdt3306a_write_reg(state, 0x1061, val);
 
-	ret = lgdt3306a_read_reg(state, 0x103D, &val);
-	val &= 0xCF;
-	ret = lgdt3306a_write_reg(state, 0x103D, val);
+	ret = lgdt3306a_read_reg(state, 0x103d, &val);
+	val &= 0xcf;
+	ret = lgdt3306a_write_reg(state, 0x103d, val);
 
 	ret = lgdt3306a_write_reg(state, 0x2122, 0x40);
 
 	ret = lgdt3306a_read_reg(state, 0x2141, &val);
-	val &= 0x3F;
+	val &= 0x3f;
 	ret = lgdt3306a_write_reg(state, 0x2141, val);
 
 	ret = lgdt3306a_read_reg(state, 0x2135, &val);
-	val &= 0x0F;
+	val &= 0x0f;
 	val |= 0x70;
 	ret = lgdt3306a_write_reg(state, 0x2135, val);
 
 	ret = lgdt3306a_read_reg(state, 0x0003, &val);
-	val &= 0xF7;
+	val &= 0xf7;
 	ret = lgdt3306a_write_reg(state, 0x0003, val);
 
-	ret = lgdt3306a_read_reg(state, 0x001C, &val);
-	val &= 0x7F;
-	ret = lgdt3306a_write_reg(state, 0x001C, val);
+	ret = lgdt3306a_read_reg(state, 0x001c, &val);
+	val &= 0x7f;
+	ret = lgdt3306a_write_reg(state, 0x001c, val);
 
 	/* 6. EQ step size */
 	ret = lgdt3306a_read_reg(state, 0x2179, &val);
-	val &= 0xF8;
+	val &= 0xf8;
 	ret = lgdt3306a_write_reg(state, 0x2179, val);
 
-	ret = lgdt3306a_read_reg(state, 0x217A, &val);
-	val &= 0xF8;
-	ret = lgdt3306a_write_reg(state, 0x217A, val);
+	ret = lgdt3306a_read_reg(state, 0x217a, &val);
+	val &= 0xf8;
+	ret = lgdt3306a_write_reg(state, 0x217a, val);
 
 	/* 7. Reset */
 	ret = lgdt3306a_soft_reset(state);
@@ -530,7 +530,7 @@ static int lgdt3306a_set_qam(struct lgdt3306a_state *state, int modulation)
 
 	/* 1a. Spectrum inversion detection to Auto */
 	ret = lgdt3306a_read_reg(state, 0x0002, &val);
-	val &= 0xFB; /* SPECINV Off */
+	val &= 0xfb; /* SPECINV Off */
 	val |= 0x08; /* SPECINVAUTO On */
 	ret = lgdt3306a_write_reg(state, 0x0002, val);
 	if (lg_chkerr(ret))
@@ -538,14 +538,14 @@ static int lgdt3306a_set_qam(struct lgdt3306a_state *state, int modulation)
 
 	/* 2. Bandwidth mode for QAM */
 	ret = lgdt3306a_read_reg(state, 0x0009, &val);
-	val &= 0xE3; /* STDOPDETTMODE[2:0]=0 VSB Off */
+	val &= 0xe3; /* STDOPDETTMODE[2:0]=0 VSB Off */
 	ret = lgdt3306a_write_reg(state, 0x0009, val);
 	if (lg_chkerr(ret))
 		goto fail;
 
 	/* 3. : 64QAM/256QAM detection(manual, auto) */
 	ret = lgdt3306a_read_reg(state, 0x0009, &val);
-	val &= 0xFC;
+	val &= 0xfc;
 	val |= 0x02; /* STDOPDETCMODE[1:0]=1=Manual 2=Auto */
 	ret = lgdt3306a_write_reg(state, 0x0009, val);
 	if (lg_chkerr(ret))
@@ -553,7 +553,7 @@ static int lgdt3306a_set_qam(struct lgdt3306a_state *state, int modulation)
 
 	/* 3a. : 64QAM/256QAM selection for manual */
 	ret = lgdt3306a_read_reg(state, 0x101a, &val);
-	val &= 0xF8;
+	val &= 0xf8;
 	if (modulation == QAM_64)
 		val |= 0x02; /* QMDQMODE[2:0]=2=QAM64 */
 	else
@@ -564,10 +564,10 @@ static int lgdt3306a_set_qam(struct lgdt3306a_state *state, int modulation)
 		goto fail;
 
 	/* 4. ADC sampling frequency rate(4x sampling) */
-	ret = lgdt3306a_read_reg(state, 0x000D, &val);
-	val &= 0xBF;
+	ret = lgdt3306a_read_reg(state, 0x000d, &val);
+	val &= 0xbf;
 	val |= 0x40; /* SAMPLING4XFEN=1 */
-	ret = lgdt3306a_write_reg(state, 0x000D, val);
+	ret = lgdt3306a_write_reg(state, 0x000d, val);
 	if (lg_chkerr(ret))
 		goto fail;
 
@@ -829,7 +829,7 @@ static int lgdt3306a_init(struct dvb_frontend *fe)
 		ret = lgdt3306a_read_reg(state, 0x0005, &val);
 		if (lg_chkerr(ret))
 			goto fail;
-		val &= 0xC0;
+		val &= 0xc0;
 		val |= 0x25;
 		ret = lgdt3306a_write_reg(state, 0x0005, val);
 		if (lg_chkerr(ret))
@@ -839,12 +839,12 @@ static int lgdt3306a_init(struct dvb_frontend *fe)
 			goto fail;
 
 		/* 8. ADC sampling frequency(0x180000 for 24MHz sampling) */
-		ret = lgdt3306a_read_reg(state, 0x000D, &val);
+		ret = lgdt3306a_read_reg(state, 0x000d, &val);
 		if (lg_chkerr(ret))
 			goto fail;
-		val &= 0xC0;
+		val &= 0xc0;
 		val |= 0x18;
-		ret = lgdt3306a_write_reg(state, 0x000D, val);
+		ret = lgdt3306a_write_reg(state, 0x000d, val);
 		if (lg_chkerr(ret))
 			goto fail;
 
@@ -853,7 +853,7 @@ static int lgdt3306a_init(struct dvb_frontend *fe)
 		ret = lgdt3306a_read_reg(state, 0x0005, &val);
 		if (lg_chkerr(ret))
 			goto fail;
-		val &= 0xC0;
+		val &= 0xc0;
 		val |= 0x25;
 		ret = lgdt3306a_write_reg(state, 0x0005, val);
 		if (lg_chkerr(ret))
@@ -863,20 +863,20 @@ static int lgdt3306a_init(struct dvb_frontend *fe)
 			goto fail;
 
 		/* 8. ADC sampling frequency(0x190000 for 25MHz sampling) */
-		ret = lgdt3306a_read_reg(state, 0x000D, &val);
+		ret = lgdt3306a_read_reg(state, 0x000d, &val);
 		if (lg_chkerr(ret))
 			goto fail;
-		val &= 0xC0;
+		val &= 0xc0;
 		val |= 0x19;
-		ret = lgdt3306a_write_reg(state, 0x000D, val);
+		ret = lgdt3306a_write_reg(state, 0x000d, val);
 		if (lg_chkerr(ret))
 			goto fail;
 	} else {
 		lg_err("Bad xtalMHz=%d\n", state->cfg->xtalMHz);
 	}
 #if 0
-	ret = lgdt3306a_write_reg(state, 0x000E, 0x00);
-	ret = lgdt3306a_write_reg(state, 0x000F, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x000e, 0x00);
+	ret = lgdt3306a_write_reg(state, 0x000f, 0x00);
 #endif
 
 	/* 9. Center frequency of input signal of ADC */
@@ -887,31 +887,31 @@ static int lgdt3306a_init(struct dvb_frontend *fe)
 	ret = lgdt3306a_write_reg(state, 0x0014, 0); /* gain error=0 */
 
 	/* 10a. VSB TR BW gear shift initial step */
-	ret = lgdt3306a_read_reg(state, 0x103C, &val);
-	val &= 0x0F;
+	ret = lgdt3306a_read_reg(state, 0x103c, &val);
+	val &= 0x0f;
 	val |= 0x20; /* SAMGSAUTOSTL_V[3:0] = 2 */
-	ret = lgdt3306a_write_reg(state, 0x103C, val);
+	ret = lgdt3306a_write_reg(state, 0x103c, val);
 
 	/* 10b. Timing offset calibration in low temperature for VSB */
-	ret = lgdt3306a_read_reg(state, 0x103D, &val);
-	val &= 0xFC;
+	ret = lgdt3306a_read_reg(state, 0x103d, &val);
+	val &= 0xfc;
 	val |= 0x03;
-	ret = lgdt3306a_write_reg(state, 0x103D, val);
+	ret = lgdt3306a_write_reg(state, 0x103d, val);
 
 	/* 10c. Timing offset calibration in low temperature for QAM */
 	ret = lgdt3306a_read_reg(state, 0x1036, &val);
-	val &= 0xF0;
-	val |= 0x0C;
+	val &= 0xf0;
+	val |= 0x0c;
 	ret = lgdt3306a_write_reg(state, 0x1036, val);
 
 	/* 11. Using the imaginary part of CIR in CIR loading */
-	ret = lgdt3306a_read_reg(state, 0x211F, &val);
-	val &= 0xEF; /* do not use imaginary of CIR */
-	ret = lgdt3306a_write_reg(state, 0x211F, val);
+	ret = lgdt3306a_read_reg(state, 0x211f, &val);
+	val &= 0xef; /* do not use imaginary of CIR */
+	ret = lgdt3306a_write_reg(state, 0x211f, val);
 
 	/* 12. Control of no signal detector function */
 	ret = lgdt3306a_read_reg(state, 0x2849, &val);
-	val &= 0xEF; /* NOUSENOSIGDET=0, enable no signal detector */
+	val &= 0xef; /* NOUSENOSIGDET=0, enable no signal detector */
 	ret = lgdt3306a_write_reg(state, 0x2849, val);
 
 	/* FGR - put demod in some known mode */
@@ -1034,8 +1034,8 @@ static void lgdt3306a_monitor_vsb(struct lgdt3306a_state *state)
 	u8 snrRef, maxPowerMan, nCombDet;
 	u16 fbDlyCir;
 
-	ret = lgdt3306a_read_reg(state, 0x21A1, &val);
-	snrRef = val & 0x3F;
+	ret = lgdt3306a_read_reg(state, 0x21a1, &val);
+	snrRef = val & 0x3f;
 
 	ret = lgdt3306a_read_reg(state, 0x2185, &maxPowerMan);
 
@@ -1052,7 +1052,7 @@ static void lgdt3306a_monitor_vsb(struct lgdt3306a_state *state)
 
 	/* Carrier offset sub loop bandwidth */
 	ret = lgdt3306a_read_reg(state, 0x1061, &val);
-	val &= 0xF8;
+	val &= 0xf8;
 	if ((snrRef > 18) && (maxPowerMan > 0x68) && (nCombDet == 0x01) && ((fbDlyCir == 0x03FF) || (fbDlyCir < 0x6C)))	{
 		/* SNR is over 18dB and no ghosting */
 		val |= 0x00; /* final bandwidth = 0 */
@@ -1063,17 +1063,17 @@ static void lgdt3306a_monitor_vsb(struct lgdt3306a_state *state)
 
 	/* Adjust Notch Filter */
 	ret = lgdt3306a_read_reg(state, 0x0024, &val);
-	val &= 0x0F;
+	val &= 0x0f;
 	if (nCombDet == 0) { /* Turn on the Notch Filter */
 		val |= 0x50;
 	}
 	ret = lgdt3306a_write_reg(state, 0x0024, val);
 
 	/* VSB Timing Recovery output normalization */
-	ret = lgdt3306a_read_reg(state, 0x103D, &val);
-	val &= 0xCF;
+	ret = lgdt3306a_read_reg(state, 0x103d, &val);
+	val &= 0xcf;
 	val |= 0x20;
-	ret = lgdt3306a_write_reg(state, 0x103D, val);
+	ret = lgdt3306a_write_reg(state, 0x103d, val);
 }
 
 static enum lgdt3306a_modulation lgdt3306a_check_oper_mode(struct lgdt3306a_state *state)
@@ -1088,7 +1088,7 @@ static enum lgdt3306a_modulation lgdt3306a_check_oper_mode(struct lgdt3306a_stat
 		return LG3306_VSB;
 	}
 	if (val & 0x08) {
-		ret = lgdt3306a_read_reg(state, 0x00A6, &val);
+		ret = lgdt3306a_read_reg(state, 0x00a6, &val);
 		val = val >> 2;
 		if (val & 0x01) {
 			lg_dbg("QAM256\n");
@@ -1115,7 +1115,7 @@ static enum lgdt3306a_lock_status lgdt3306a_check_lock_status(struct lgdt3306a_s
 	switch (whatLock) {
 	case LG3306_SYNC_LOCK:
 	{
-		ret = lgdt3306a_read_reg(state, 0x00A6, &val);
+		ret = lgdt3306a_read_reg(state, 0x00a6, &val);
 
 		if ((val & 0x80) == 0x80)
 			lockStatus = LG3306_LOCK;
@@ -1200,18 +1200,18 @@ static void lgdt3306a_pre_monitoring(struct lgdt3306a_state *state)
 	u8 currChDiffACQ, snrRef, mainStrong, aiccrejStatus;
 
 	/* Channel variation */
-	ret = lgdt3306a_read_reg(state, 0x21BC, &currChDiffACQ);
+	ret = lgdt3306a_read_reg(state, 0x21bc, &currChDiffACQ);
 
 	/* SNR of Frame sync */
-	ret = lgdt3306a_read_reg(state, 0x21A1, &val);
-	snrRef = val & 0x3F;
+	ret = lgdt3306a_read_reg(state, 0x21a1, &val);
+	snrRef = val & 0x3f;
 
 	/* Strong Main CIR */
 	ret = lgdt3306a_read_reg(state, 0x2199, &val);
 	mainStrong = (val & 0x40) >> 6;
 
 	ret = lgdt3306a_read_reg(state, 0x0090, &val);
-	aiccrejStatus = (val & 0xF0) >> 4;
+	aiccrejStatus = (val & 0xf0) >> 4;
 
 	lg_dbg("snrRef=%d mainStrong=%d aiccrejStatus=%d currChDiffACQ=0x%x\n",
 		snrRef, mainStrong, aiccrejStatus, currChDiffACQ);
@@ -1221,24 +1221,24 @@ static void lgdt3306a_pre_monitoring(struct lgdt3306a_state *state)
 #endif
 	if (mainStrong == 0) {
 		ret = lgdt3306a_read_reg(state, 0x2135, &val);
-		val &= 0x0F;
-		val |= 0xA0;
+		val &= 0x0f;
+		val |= 0xa0;
 		ret = lgdt3306a_write_reg(state, 0x2135, val);
 
 		ret = lgdt3306a_read_reg(state, 0x2141, &val);
-		val &= 0x3F;
+		val &= 0x3f;
 		val |= 0x80;
 		ret = lgdt3306a_write_reg(state, 0x2141, val);
 
 		ret = lgdt3306a_write_reg(state, 0x2122, 0x70);
 	} else { /* Weak ghost or static channel */
 		ret = lgdt3306a_read_reg(state, 0x2135, &val);
-		val &= 0x0F;
+		val &= 0x0f;
 		val |= 0x70;
 		ret = lgdt3306a_write_reg(state, 0x2135, val);
 
 		ret = lgdt3306a_read_reg(state, 0x2141, &val);
-		val &= 0x3F;
+		val &= 0x3f;
 		val |= 0x40;
 		ret = lgdt3306a_write_reg(state, 0x2141, val);
 
@@ -1309,7 +1309,7 @@ static u8 lgdt3306a_get_packet_error(struct lgdt3306a_state *state)
 	u8 val;
 	int ret;
 
-	ret = lgdt3306a_read_reg(state, 0x00FA, &val);
+	ret = lgdt3306a_read_reg(state, 0x00fa, &val);
 
 	return val;
 }
@@ -1365,10 +1365,10 @@ static u32 lgdt3306a_calculate_snr_x100(struct lgdt3306a_state *state)
 	u32 pwr; /* Constelation power */
 	u32 snr_x100;
 
-	mse = (read_reg(state, 0x00EC) << 8) |
-	      (read_reg(state, 0x00ED));
-	pwr = (read_reg(state, 0x00E8) << 8) |
-	      (read_reg(state, 0x00E9));
+	mse = (read_reg(state, 0x00ec) << 8) |
+	      (read_reg(state, 0x00ed));
+	pwr = (read_reg(state, 0x00e8) << 8) |
+	      (read_reg(state, 0x00e9));
 
 	if (mse == 0) /* no signal */
 		return 0;
@@ -1565,10 +1565,10 @@ static int lgdt3306a_read_ber(struct dvb_frontend *fe, u32 *ber)
 #if 1
 	/* FGR - BUGBUG - I don't know what value is expected by dvb_core
 	 * what is the scale of the value?? */
-	tmp =              read_reg(state, 0x00FC); /* NBERVALUE[24-31] */
-	tmp = (tmp << 8) | read_reg(state, 0x00FD); /* NBERVALUE[16-23] */
-	tmp = (tmp << 8) | read_reg(state, 0x00FE); /* NBERVALUE[8-15] */
-	tmp = (tmp << 8) | read_reg(state, 0x00FF); /* NBERVALUE[0-7] */
+	tmp =              read_reg(state, 0x00fc); /* NBERVALUE[24-31] */
+	tmp = (tmp << 8) | read_reg(state, 0x00fd); /* NBERVALUE[16-23] */
+	tmp = (tmp << 8) | read_reg(state, 0x00fe); /* NBERVALUE[8-15] */
+	tmp = (tmp << 8) | read_reg(state, 0x00ff); /* NBERVALUE[0-7] */
 	*ber = tmp;
 	lg_dbg("ber=%u\n", tmp);
 #endif
@@ -1583,7 +1583,7 @@ static int lgdt3306a_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 #if 1
 	/* FGR - BUGBUG - I don't know what value is expected by dvb_core
 	 * what happens when value wraps? */
-	*ucblocks = read_reg(state, 0x00F4); /* TPIFTPERRCNT[0-7] */
+	*ucblocks = read_reg(state, 0x00f4); /* TPIFTPERRCNT[0-7] */
 	lg_dbg("ucblocks=%u\n", *ucblocks);
 #endif
 
@@ -1698,8 +1698,8 @@ struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
 	ret = lgdt3306a_read_reg(state, 0x0001, &val);
 	if (lg_chkerr(ret))
 		goto fail;
-	if ((val & 0xF6) != 0xC6) {
-		lg_warn("expected 0xC6, got 0x%x\n", (val & 0xF6));
+	if ((val & 0xf6) != 0xc6) {
+		lg_warn("expected 0xc6, got 0x%x\n", (val & 0xf6));
 #if 0
 		goto fail;	/* BUGBUG - re-enable when we know this is right */
 #endif
@@ -1741,11 +1741,11 @@ static const short regtab[] = {
 	0x0007, /* SYSINITWAITTIME[7:0] (msec) 00001000 */
 	0x0008, /* STDOPMODE[7:0] 10000000 */
 	0x0009, /* 1'b0 1'b0 1'b0 STDOPDETTMODE[2:0] STDOPDETCMODE[1:0] 00011110 */
-	0x000A, /* DAFTEN 1'b1 x x SCSYSLOCK */
-	0x000B, /* SCSYSLOCKCHKTIME[7:0] (10msec) 01100100 */
-	0x000D, /* x SAMPLING4 */
-	0x000E, /* SAMFREQ[15:8] 00000000 */
-	0x000F, /* SAMFREQ[7:0] 00000000 */
+	0x000a, /* DAFTEN 1'b1 x x SCSYSLOCK */
+	0x000b, /* SCSYSLOCKCHKTIME[7:0] (10msec) 01100100 */
+	0x000d, /* x SAMPLING4 */
+	0x000e, /* SAMFREQ[15:8] 00000000 */
+	0x000f, /* SAMFREQ[7:0] 00000000 */
 	0x0010, /* IFFREQ[15:8] 01100000 */
 	0x0011, /* IFFREQ[7:0] 00000000 */
 	0x0012, /* AGCEN AGCREFMO */
@@ -1756,10 +1756,10 @@ static const short regtab[] = {
 	0x0017, /* AGCDELAY[7:0] 00100000 */
 	0x0018, /* AGCRFBW[3:0] AGCIFBW[3:0] 10001000 */
 	0x0019, /* AGCUDOUTMODE[1:0] AGCUDCTRLLEN[1:0] AGCUDCTRL */
-	0x001C, /* 1'b1 PFEN MFEN AICCVSYNC */
-	0x001D, /* 1'b0 1'b1 1'b0 1'b1 AICCVSYNC */
-	0x001E, /* AICCALPHA[3:0] 1'b1 1'b0 1'b1 1'b0 01111010 */
-	0x001F, /* AICCDETTH[19:16] AICCOFFTH[19:16] 00000000 */
+	0x001c, /* 1'b1 PFEN MFEN AICCVSYNC */
+	0x001d, /* 1'b0 1'b1 1'b0 1'b1 AICCVSYNC */
+	0x001e, /* AICCALPHA[3:0] 1'b1 1'b0 1'b1 1'b0 01111010 */
+	0x001f, /* AICCDETTH[19:16] AICCOFFTH[19:16] 00000000 */
 	0x0020, /* AICCDETTH[15:8] 01111100 */
 	0x0021, /* AICCDETTH[7:0] 00000000 */
 	0x0022, /* AICCOFFTH[15:8] 00000101 */
@@ -1770,12 +1770,12 @@ static const short regtab[] = {
 	0x0027, /* AICCFIXFREQ3[7:0] 00000000 */
 	0x0028, /* AICCFIXFREQ2[23:16] 00000000 */
 	0x0029, /* AICCFIXFREQ2[15:8] 00000000 */
-	0x002A, /* AICCFIXFREQ2[7:0] 00000000 */
-	0x002B, /* AICCFIXFREQ1[23:16] 00000000 */
-	0x002C, /* AICCFIXFREQ1[15:8] 00000000 */
-	0x002D, /* AICCFIXFREQ1[7:0] 00000000 */
-	0x002E, /* AICCFIXFREQ0[23:16] 00000000 */
-	0x002F, /* AICCFIXFREQ0[15:8] 00000000 */
+	0x002a, /* AICCFIXFREQ2[7:0] 00000000 */
+	0x002b, /* AICCFIXFREQ1[23:16] 00000000 */
+	0x002c, /* AICCFIXFREQ1[15:8] 00000000 */
+	0x002d, /* AICCFIXFREQ1[7:0] 00000000 */
+	0x002e, /* AICCFIXFREQ0[23:16] 00000000 */
+	0x002f, /* AICCFIXFREQ0[15:8] 00000000 */
 	0x0030, /* AICCFIXFREQ0[7:0] 00000000 */
 	0x0031, /* 1'b0 1'b1 1'b0 1'b0 x DAGC1STER */
 	0x0032, /* DAGC1STEN DAGC1STER */
@@ -1785,7 +1785,7 @@ static const short regtab[] = {
 	0x0036, /* DAGC2NDREF[15:8] 00001010 */
 	0x0037, /* DAGC2NDREF[7:0] 10000000 */
 	0x0038, /* DAGC2NDLOCKDETRNGSEL[1:0] */
-	0x003D, /* 1'b1 SAMGEARS */
+	0x003d, /* 1'b1 SAMGEARS */
 	0x0040, /* SAMLFGMA */
 	0x0041, /* SAMLFBWM */
 	0x0044, /* 1'b1 CRGEARSHE */
@@ -1794,7 +1794,7 @@ static const short regtab[] = {
 	0x0047, /* CRLFGMAN */
 	0x0048, /* x x x x CRLFGSTEP_VS[3:0] xxxx1001 */
 	0x0049, /* CRLFBWMA */
-	0x004A, /* CRLFBWMA */
+	0x004a, /* CRLFBWMA */
 	0x0050, /* 1'b0 1'b1 1'b1 1'b0 MSECALCDA */
 	0x0070, /* TPOUTEN TPIFEN TPCLKOUTE */
 	0x0071, /* TPSENB TPSSOPBITE */
@@ -1804,158 +1804,158 @@ static const short regtab[] = {
 	0x0077, /* x NBERLOSTTH[2:0] NBERACQTH[3:0] x0000000 */
 	0x0078, /* NBERPOLY[31:24] 00000000 */
 	0x0079, /* NBERPOLY[23:16] 00000000 */
-	0x007A, /* NBERPOLY[15:8] 00000000 */
-	0x007B, /* NBERPOLY[7:0] 00000000 */
-	0x007C, /* NBERPED[31:24] 00000000 */
-	0x007D, /* NBERPED[23:16] 00000000 */
-	0x007E, /* NBERPED[15:8] 00000000 */
-	0x007F, /* NBERPED[7:0] 00000000 */
+	0x007a, /* NBERPOLY[15:8] 00000000 */
+	0x007b, /* NBERPOLY[7:0] 00000000 */
+	0x007c, /* NBERPED[31:24] 00000000 */
+	0x007d, /* NBERPED[23:16] 00000000 */
+	0x007e, /* NBERPED[15:8] 00000000 */
+	0x007f, /* NBERPED[7:0] 00000000 */
 	0x0080, /* x AGCLOCK DAGCLOCK SYSLOCK x x NEVERLOCK[1:0] */
 	0x0085, /* SPECINVST */
 	0x0088, /* SYSLOCKTIME[15:8] */
 	0x0089, /* SYSLOCKTIME[7:0] */
-	0x008C, /* FECLOCKTIME[15:8] */
-	0x008D, /* FECLOCKTIME[7:0] */
-	0x008E, /* AGCACCOUT[15:8] */
-	0x008F, /* AGCACCOUT[7:0] */
+	0x008c, /* FECLOCKTIME[15:8] */
+	0x008d, /* FECLOCKTIME[7:0] */
+	0x008e, /* AGCACCOUT[15:8] */
+	0x008f, /* AGCACCOUT[7:0] */
 	0x0090, /* AICCREJSTATUS[3:0] AICCREJBUSY[3:0] */
 	0x0091, /* AICCVSYNC */
-	0x009C, /* CARRFREQOFFSET[15:8] */
-	0x009D, /* CARRFREQOFFSET[7:0] */
-	0x00A1, /* SAMFREQOFFSET[23:16] */
-	0x00A2, /* SAMFREQOFFSET[15:8] */
-	0x00A3, /* SAMFREQOFFSET[7:0] */
-	0x00A6, /* SYNCLOCK SYNCLOCKH */
+	0x009c, /* CARRFREQOFFSET[15:8] */
+	0x009d, /* CARRFREQOFFSET[7:0] */
+	0x00a1, /* SAMFREQOFFSET[23:16] */
+	0x00a2, /* SAMFREQOFFSET[15:8] */
+	0x00a3, /* SAMFREQOFFSET[7:0] */
+	0x00a6, /* SYNCLOCK SYNCLOCKH */
 #if 0 /* covered elsewhere */
-	0x00E8, /* CONSTPWR[15:8] */
-	0x00E9, /* CONSTPWR[7:0] */
-	0x00EA, /* BMSE[15:8] */
-	0x00EB, /* BMSE[7:0] */
-	0x00EC, /* MSE[15:8] */
-	0x00ED, /* MSE[7:0] */
-	0x00EE, /* CONSTI[7:0] */
-	0x00EF, /* CONSTQ[7:0] */
+	0x00e8, /* CONSTPWR[15:8] */
+	0x00e9, /* CONSTPWR[7:0] */
+	0x00ea, /* BMSE[15:8] */
+	0x00eb, /* BMSE[7:0] */
+	0x00ec, /* MSE[15:8] */
+	0x00ed, /* MSE[7:0] */
+	0x00ee, /* CONSTI[7:0] */
+	0x00ef, /* CONSTQ[7:0] */
 #endif
-	0x00F4, /* TPIFTPERRCNT[7:0] */
-	0x00F5, /* TPCORREC */
-	0x00F6, /* VBBER[15:8] */
-	0x00F7, /* VBBER[7:0] */
-	0x00F8, /* VABER[15:8] */
-	0x00F9, /* VABER[7:0] */
-	0x00FA, /* TPERRCNT[7:0] */
-	0x00FB, /* NBERLOCK x x x x x x x */
-	0x00FC, /* NBERVALUE[31:24] */
-	0x00FD, /* NBERVALUE[23:16] */
-	0x00FE, /* NBERVALUE[15:8] */
-	0x00FF, /* NBERVALUE[7:0] */
+	0x00f4, /* TPIFTPERRCNT[7:0] */
+	0x00f5, /* TPCORREC */
+	0x00f6, /* VBBER[15:8] */
+	0x00f7, /* VBBER[7:0] */
+	0x00f8, /* VABER[15:8] */
+	0x00f9, /* VABER[7:0] */
+	0x00fa, /* TPERRCNT[7:0] */
+	0x00fb, /* NBERLOCK x x x x x x x */
+	0x00fc, /* NBERVALUE[31:24] */
+	0x00fd, /* NBERVALUE[23:16] */
+	0x00fe, /* NBERVALUE[15:8] */
+	0x00ff, /* NBERVALUE[7:0] */
 	0x1000, /* 1'b0 WODAGCOU */
 	0x1005, /* x x 1'b1 1'b1 x SRD_Q_QM */
 	0x1009, /* SRDWAITTIME[7:0] (10msec) 00100011 */
-	0x100A, /* SRDWAITTIME_CQS[7:0] (msec) 01100100 */
-	0x101A, /* x 1'b1 1'b0 1'b0 x QMDQAMMODE[2:0] x100x010 */
+	0x100a, /* SRDWAITTIME_CQS[7:0] (msec) 01100100 */
+	0x101a, /* x 1'b1 1'b0 1'b0 x QMDQAMMODE[2:0] x100x010 */
 	0x1036, /* 1'b0 1'b1 1'b0 1'b0 SAMGSEND_CQS[3:0] 01001110 */
-	0x103C, /* SAMGSAUTOSTL_V[3:0] SAMGSAUTOEDL_V[3:0] 01000110 */
-	0x103D, /* 1'b1 1'b1 SAMCNORMBP_V[1:0] 1'b0 1'b0 SAMMODESEL_V[1:0] 11100001 */
-	0x103F, /* SAMZTEDSE */
-	0x105D, /* EQSTATUSE */
-	0x105F, /* x PMAPG2_V[2:0] x DMAPG2_V[2:0] x001x011 */
+	0x103c, /* SAMGSAUTOSTL_V[3:0] SAMGSAUTOEDL_V[3:0] 01000110 */
+	0x103d, /* 1'b1 1'b1 SAMCNORMBP_V[1:0] 1'b0 1'b0 SAMMODESEL_V[1:0] 11100001 */
+	0x103f, /* SAMZTEDSE */
+	0x105d, /* EQSTATUSE */
+	0x105f, /* x PMAPG2_V[2:0] x DMAPG2_V[2:0] x001x011 */
 	0x1060, /* 1'b1 EQSTATUSE */
 	0x1061, /* CRMAPBWSTL_V[3:0] CRMAPBWEDL_V[3:0] 00000100 */
 	0x1065, /* 1'b0 x CRMODE_V[1:0] 1'b1 x 1'b1 x 0x111x1x */
 	0x1066, /* 1'b0 1'b0 1'b1 1'b0 1'b1 PNBOOSTSE */
 	0x1068, /* CREPHNGAIN2_V[3:0] CREPHNPBW_V[3:0] 10010001 */
-	0x106E, /* x x x x x CREPHNEN_ */
-	0x106F, /* CREPHNTH_V[7:0] 00010101 */
+	0x106e, /* x x x x x CREPHNEN_ */
+	0x106f, /* CREPHNTH_V[7:0] 00010101 */
 	0x1072, /* CRSWEEPN */
 	0x1073, /* CRPGAIN_V[3:0] x x 1'b1 1'b1 1001xx11 */
 	0x1074, /* CRPBW_V[3:0] x x 1'b1 1'b1 0001xx11 */
 	0x1080, /* DAFTSTATUS[1:0] x x x x x x */
 	0x1081, /* SRDSTATUS[1:0] x x x x x SRDLOCK */
-	0x10A9, /* EQSTATUS_CQS[1:0] x x x x x x */
-	0x10B7, /* EQSTATUS_V[1:0] x x x x x x */
+	0x10a9, /* EQSTATUS_CQS[1:0] x x x x x x */
+	0x10b7, /* EQSTATUS_V[1:0] x x x x x x */
 #if 0 /* SMART_ANT */
-	0x1F00, /* MODEDETE */
-	0x1F01, /* x x x x x x x SFNRST xxxxxxx0 */
-	0x1F03, /* NUMOFANT[7:0] 10000000 */
-	0x1F04, /* x SELMASK[6:0] x0000000 */
-	0x1F05, /* x SETMASK[6:0] x0000000 */
-	0x1F06, /* x TXDATA[6:0] x0000000 */
-	0x1F07, /* x CHNUMBER[6:0] x0000000 */
-	0x1F09, /* AGCTIME[23:16] 10011000 */
-	0x1F0A, /* AGCTIME[15:8] 10010110 */
-	0x1F0B, /* AGCTIME[7:0] 10000000 */
-	0x1F0C, /* ANTTIME[31:24] 00000000 */
-	0x1F0D, /* ANTTIME[23:16] 00000011 */
-	0x1F0E, /* ANTTIME[15:8] 10010000 */
-	0x1F0F, /* ANTTIME[7:0] 10010000 */
-	0x1F11, /* SYNCTIME[23:16] 10011000 */
-	0x1F12, /* SYNCTIME[15:8] 10010110 */
-	0x1F13, /* SYNCTIME[7:0] 10000000 */
-	0x1F14, /* SNRTIME[31:24] 00000001 */
-	0x1F15, /* SNRTIME[23:16] 01111101 */
-	0x1F16, /* SNRTIME[15:8] 01111000 */
-	0x1F17, /* SNRTIME[7:0] 01000000 */
-	0x1F19, /* FECTIME[23:16] 00000000 */
-	0x1F1A, /* FECTIME[15:8] 01110010 */
-	0x1F1B, /* FECTIME[7:0] 01110000 */
-	0x1F1D, /* FECTHD[7:0] 00000011 */
-	0x1F1F, /* SNRTHD[23:16] 00001000 */
-	0x1F20, /* SNRTHD[15:8] 01111111 */
-	0x1F21, /* SNRTHD[7:0] 10000101 */
-	0x1F80, /* IRQFLG x x SFSDRFLG MODEBFLG SAVEFLG SCANFLG TRACKFLG */
-	0x1F81, /* x SYNCCON SNRCON FECCON x STDBUSY SYNCRST AGCFZCO */
-	0x1F82, /* x x x SCANOPCD[4:0] */
-	0x1F83, /* x x x x MAINOPCD[3:0] */
-	0x1F84, /* x x RXDATA[13:8] */
-	0x1F85, /* RXDATA[7:0] */
-	0x1F86, /* x x SDTDATA[13:8] */
-	0x1F87, /* SDTDATA[7:0] */
-	0x1F89, /* ANTSNR[23:16] */
-	0x1F8A, /* ANTSNR[15:8] */
-	0x1F8B, /* ANTSNR[7:0] */
-	0x1F8C, /* x x x x ANTFEC[13:8] */
-	0x1F8D, /* ANTFEC[7:0] */
-	0x1F8E, /* MAXCNT[7:0] */
-	0x1F8F, /* SCANCNT[7:0] */
-	0x1F91, /* MAXPW[23:16] */
-	0x1F92, /* MAXPW[15:8] */
-	0x1F93, /* MAXPW[7:0] */
-	0x1F95, /* CURPWMSE[23:16] */
-	0x1F96, /* CURPWMSE[15:8] */
-	0x1F97, /* CURPWMSE[7:0] */
+	0x1f00, /* MODEDETE */
+	0x1f01, /* x x x x x x x SFNRST xxxxxxx0 */
+	0x1f03, /* NUMOFANT[7:0] 10000000 */
+	0x1f04, /* x SELMASK[6:0] x0000000 */
+	0x1f05, /* x SETMASK[6:0] x0000000 */
+	0x1f06, /* x TXDATA[6:0] x0000000 */
+	0x1f07, /* x CHNUMBER[6:0] x0000000 */
+	0x1f09, /* AGCTIME[23:16] 10011000 */
+	0x1f0a, /* AGCTIME[15:8] 10010110 */
+	0x1f0b, /* AGCTIME[7:0] 10000000 */
+	0x1f0c, /* ANTTIME[31:24] 00000000 */
+	0x1f0d, /* ANTTIME[23:16] 00000011 */
+	0x1f0e, /* ANTTIME[15:8] 10010000 */
+	0x1f0f, /* ANTTIME[7:0] 10010000 */
+	0x1f11, /* SYNCTIME[23:16] 10011000 */
+	0x1f12, /* SYNCTIME[15:8] 10010110 */
+	0x1f13, /* SYNCTIME[7:0] 10000000 */
+	0x1f14, /* SNRTIME[31:24] 00000001 */
+	0x1f15, /* SNRTIME[23:16] 01111101 */
+	0x1f16, /* SNRTIME[15:8] 01111000 */
+	0x1f17, /* SNRTIME[7:0] 01000000 */
+	0x1f19, /* FECTIME[23:16] 00000000 */
+	0x1f1a, /* FECTIME[15:8] 01110010 */
+	0x1f1b, /* FECTIME[7:0] 01110000 */
+	0x1f1d, /* FECTHD[7:0] 00000011 */
+	0x1f1f, /* SNRTHD[23:16] 00001000 */
+	0x1f20, /* SNRTHD[15:8] 01111111 */
+	0x1f21, /* SNRTHD[7:0] 10000101 */
+	0x1f80, /* IRQFLG x x SFSDRFLG MODEBFLG SAVEFLG SCANFLG TRACKFLG */
+	0x1f81, /* x SYNCCON SNRCON FECCON x STDBUSY SYNCRST AGCFZCO */
+	0x1f82, /* x x x SCANOPCD[4:0] */
+	0x1f83, /* x x x x MAINOPCD[3:0] */
+	0x1f84, /* x x RXDATA[13:8] */
+	0x1f85, /* RXDATA[7:0] */
+	0x1f86, /* x x SDTDATA[13:8] */
+	0x1f87, /* SDTDATA[7:0] */
+	0x1f89, /* ANTSNR[23:16] */
+	0x1f8a, /* ANTSNR[15:8] */
+	0x1f8b, /* ANTSNR[7:0] */
+	0x1f8c, /* x x x x ANTFEC[13:8] */
+	0x1f8d, /* ANTFEC[7:0] */
+	0x1f8e, /* MAXCNT[7:0] */
+	0x1f8f, /* SCANCNT[7:0] */
+	0x1f91, /* MAXPW[23:16] */
+	0x1f92, /* MAXPW[15:8] */
+	0x1f93, /* MAXPW[7:0] */
+	0x1f95, /* CURPWMSE[23:16] */
+	0x1f96, /* CURPWMSE[15:8] */
+	0x1f97, /* CURPWMSE[7:0] */
 #endif /* SMART_ANT */
-	0x211F, /* 1'b1 1'b1 1'b1 CIRQEN x x 1'b0 1'b0 1111xx00 */
-	0x212A, /* EQAUTOST */
+	0x211f, /* 1'b1 1'b1 1'b1 CIRQEN x x 1'b0 1'b0 1111xx00 */
+	0x212a, /* EQAUTOST */
 	0x2122, /* CHFAST[7:0] 01100000 */
-	0x212B, /* FFFSTEP_V[3:0] x FBFSTEP_V[2:0] 0001x001 */
-	0x212C, /* PHDEROTBWSEL[3:0] 1'b1 1'b1 1'b1 1'b0 10001110 */
-	0x212D, /* 1'b1 1'b1 1'b1 1'b1 x x TPIFLOCKS */
+	0x212b, /* FFFSTEP_V[3:0] x FBFSTEP_V[2:0] 0001x001 */
+	0x212c, /* PHDEROTBWSEL[3:0] 1'b1 1'b1 1'b1 1'b0 10001110 */
+	0x212d, /* 1'b1 1'b1 1'b1 1'b1 x x TPIFLOCKS */
 	0x2135, /* DYNTRACKFDEQ[3:0] x 1'b0 1'b0 1'b0 1010x000 */
 	0x2141, /* TRMODE[1:0] 1'b1 1'b1 1'b0 1'b1 1'b1 1'b1 01110111 */
 	0x2162, /* AICCCTRLE */
 	0x2173, /* PHNCNFCNT[7:0] 00000100 */
 	0x2179, /* 1'b0 1'b0 1'b0 1'b1 x BADSINGLEDYNTRACKFBF[2:0] 0001x001 */
-	0x217A, /* 1'b0 1'b0 1'b0 1'b1 x BADSLOWSINGLEDYNTRACKFBF[2:0] 0001x001 */
-	0x217E, /* CNFCNTTPIF[7:0] 00001000 */
-	0x217F, /* TPERRCNTTPIF[7:0] 00000001 */
+	0x217a, /* 1'b0 1'b0 1'b0 1'b1 x BADSLOWSINGLEDYNTRACKFBF[2:0] 0001x001 */
+	0x217e, /* CNFCNTTPIF[7:0] 00001000 */
+	0x217f, /* TPERRCNTTPIF[7:0] 00000001 */
 	0x2180, /* x x x x x x FBDLYCIR[9:8] */
 	0x2181, /* FBDLYCIR[7:0] */
 	0x2185, /* MAXPWRMAIN[7:0] */
 	0x2191, /* NCOMBDET x x x x x x x */
 	0x2199, /* x MAINSTRON */
-	0x219A, /* FFFEQSTEPOUT_V[3:0] FBFSTEPOUT_V[2:0] */
-	0x21A1, /* x x SNRREF[5:0] */
+	0x219a, /* FFFEQSTEPOUT_V[3:0] FBFSTEPOUT_V[2:0] */
+	0x21a1, /* x x SNRREF[5:0] */
 	0x2845, /* 1'b0 1'b1 x x FFFSTEP_CQS[1:0] FFFCENTERTAP[1:0] 01xx1110 */
 	0x2846, /* 1'b0 x 1'b0 1'b1 FBFSTEP_CQS[1:0] 1'b1 1'b0 0x011110 */
 	0x2847, /* ENNOSIGDE */
 	0x2849, /* 1'b1 1'b1 NOUSENOSI */
-	0x284A, /* EQINITWAITTIME[7:0] 01100100 */
+	0x284a, /* EQINITWAITTIME[7:0] 01100100 */
 	0x3000, /* 1'b1 1'b1 1'b1 x x x 1'b0 RPTRSTM */
 	0x3001, /* RPTRSTWAITTIME[7:0] (100msec) 00110010 */
 	0x3031, /* FRAMELOC */
 	0x3032, /* 1'b1 1'b0 1'b0 1'b0 x x FRAMELOCKMODE_CQS[1:0] 1000xx11 */
-	0x30A9, /* VDLOCK_Q FRAMELOCK */
-	0x30AA, /* MPEGLOCK */
+	0x30a9, /* VDLOCK_Q FRAMELOCK */
+	0x30aa, /* MPEGLOCK */
 };
 
 #define numDumpRegs (sizeof(regtab)/sizeof(regtab[0]))
-- 
1.9.3

