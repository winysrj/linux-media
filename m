Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JkhIi-0003S4-P5
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 17:05:57 +0200
Message-Id: <20080412150449.915773002@gentoo.org>
References: <20080412150444.987445669@gentoo.org>
Date: Sat, 12 Apr 2008 17:04:49 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Content-Disposition: inline; filename=04_mt312-add-zl10313-support.diff
Subject: [linux-dvb] [patch 4/5] mt312: Add support for zl10313 demod
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Add zl10313 support to mt312 driver.
zl10313 uses 10.111MHz xtal.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
@@ -1,7 +1,8 @@
 /*
-    Driver for Zarlink VP310/MT312 Satellite Channel Decoder
+    Driver for Zarlink VP310/MT312/ZL10313 Satellite Channel Decoder
 
     Copyright (C) 2003 Andreas Oberritter <obi@linuxtv.org>
+    Copyright (C) 2008 Matthias Schwarzott <zzam@gentoo.org>
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
@@ -55,6 +56,7 @@ static int debug;
 	} while (0)
 
 #define MT312_PLL_CLK		10000000UL	/* 10 MHz */
+#define MT312_PLL_CLK_10_111	10111000UL	/* 10.111 MHz */
 
 static int mt312_read(struct mt312_state *state, const enum mt312_reg_addr reg,
 		      u8 *buf, const size_t count)
@@ -264,6 +266,32 @@ static int mt312_initfe(struct dvb_front
 			return ret;
 	}
 
+	switch (state->id) {
+	case ID_ZL10313:
+		/* enable ADC */
+		ret = mt312_writereg(state, GPP_CTRL, 0x80);
+		if (ret < 0)
+			return ret;
+
+		/* configure ZL10313 for optimal ADC performance */
+		buf[0] = 0x80;
+		buf[1] = 0xB0;
+		ret = mt312_write(state, HW_CTRL, buf, 2);
+		if (ret < 0)
+			return ret;
+
+		/* enable MPEG output and ADCs */
+		ret = mt312_writereg(state, HW_CTRL, 0x00);
+		if (ret < 0)
+			return ret;
+
+		ret = mt312_writereg(state, MPEG_CTRL, 0x00);
+		if (ret < 0)
+			return ret;
+
+		break;
+	}
+
 	/* SYS_CLK */
 	buf[0] = mt312_div(state->xtal * state->freq_mult * 2, 1000000);
 
@@ -278,7 +306,17 @@ static int mt312_initfe(struct dvb_front
 	if (ret < 0)
 		return ret;
 
-	ret = mt312_writereg(state, OP_CTRL, 0x53);
+	/* different MOCLK polarity */
+	switch (state->id) {
+	case ID_ZL10313:
+		buf[0] = 0x33;
+		break;
+	default:
+		buf[0] = 0x53;
+		break;
+	}
+
+	ret = mt312_writereg(state, OP_CTRL, buf[0]);
 	if (ret < 0)
 		return ret;
 
@@ -552,6 +590,7 @@ static int mt312_set_frontend(struct dvb
 		break;
 
 	case ID_MT312:
+	case ID_ZL10313:
 		break;
 
 	default:
@@ -617,11 +656,29 @@ static int mt312_i2c_gate_ctrl(struct dv
 {
 	struct mt312_state *state = fe->demodulator_priv;
 
-	if (enable) {
-		return mt312_writereg(state, GPP_CTRL, 0x40);
-	} else {
-		return mt312_writereg(state, GPP_CTRL, 0x00);
+	u8 val = 0x00;
+	int ret;
+
+	switch (state->id) {
+	case ID_ZL10313:
+		ret = mt312_readreg(state, GPP_CTRL, &val);
+		if (ret < 0)
+			goto error;
+
+		/* preserve this bit to not accidently shutdown ADC */
+		val &= 0x80;
+		break;
 	}
+
+	if (enable)
+		val |= 0x40;
+	else
+		val &= ~0x40;
+
+	ret = mt312_writereg(state, GPP_CTRL, val);
+
+error:
+	return ret;
 }
 
 static int mt312_sleep(struct dvb_frontend *fe)
@@ -635,6 +692,18 @@ static int mt312_sleep(struct dvb_fronte
 	if (ret < 0)
 		return ret;
 
+	if (state->id == ID_ZL10313) {
+		/* reset ADC */
+		ret = mt312_writereg(state, GPP_CTRL, 0x00);
+		if (ret < 0)
+			return ret;
+
+		/* full shutdown of ADCs, mpeg bus tristated */
+		ret = mt312_writereg(state, HW_CTRL, 0x0d);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = mt312_readreg(state, CONFIG, &config);
 	if (ret < 0)
 		return ret;
@@ -736,8 +805,13 @@ struct dvb_frontend *vp310_mt312_attach(
 		state->xtal = MT312_PLL_CLK;
 		state->freq_mult = 6;
 		break;
+	case ID_ZL10313:
+		strcpy(state->frontend.ops.info.name, "Zarlink ZL10313 DVB-S");
+		state->xtal = MT312_PLL_CLK_10_111;
+		state->freq_mult = 9;
+		break;
 	default:
-		printk(KERN_WARNING "Only Zarlink VP310/MT312"
+		printk(KERN_WARNING "Only Zarlink VP310/MT312/ZL10313"
 			" are supported chips.\n");
 		goto error;
 	}
@@ -753,7 +827,7 @@ EXPORT_SYMBOL(vp310_mt312_attach);
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 
-MODULE_DESCRIPTION("Zarlink VP310/MT312 DVB-S Demodulator driver");
+MODULE_DESCRIPTION("Zarlink VP310/MT312/ZL10313 DVB-S Demodulator driver");
 MODULE_AUTHOR("Andreas Oberritter <obi@linuxtv.org>");
 MODULE_LICENSE("GPL");
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312_priv.h
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312_priv.h
+++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312_priv.h
@@ -110,6 +110,8 @@ enum mt312_reg_addr {
 	VIT_ERRPER_H = 83,
 	VIT_ERRPER_M = 84,
 	VIT_ERRPER_L = 85,
+	HW_CTRL = 84,	/* ZL10313 only */
+	MPEG_CTRL = 85,	/* ZL10313 only */
 	VIT_SETUP = 86,
 	VIT_REF0 = 87,
 	VIT_REF1 = 88,
@@ -156,7 +158,8 @@ enum mt312_reg_addr {
 
 enum mt312_model_id {
 	ID_VP310 = 1,
-	ID_MT312 = 3
+	ID_MT312 = 3,
+	ID_ZL10313 = 5,
 };
 
 #endif				/* DVB_FRONTENDS_MT312_PRIV */

-- 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
