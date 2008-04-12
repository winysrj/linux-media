Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JkhIi-0003S4-95
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 17:05:56 +0200
Message-Id: <20080412150448.865523235@gentoo.org>
References: <20080412150444.987445669@gentoo.org>
Date: Sat, 12 Apr 2008 17:04:48 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Content-Disposition: inline; filename=03_mt312-changable-xtal.diff
Subject: [linux-dvb] [patch 3/5] mt312: Supports different xtal frequencies
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

Do not hardcode xtal frequency but allow different values
for future zl10313 support.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
@@ -43,7 +43,8 @@ struct mt312_state {
 	struct dvb_frontend frontend;
 
 	u8 id;
-	u8 frequency;
+	unsigned long xtal;
+	u8 freq_mult;
 };
 
 static int debug;
@@ -53,8 +54,6 @@ static int debug;
 			printk(KERN_DEBUG "mt312: " args); \
 	} while (0)
 
-#define MT312_SYS_CLK		90000000UL	/* 90 MHz */
-#define MT312_LPOWER_SYS_CLK	60000000UL	/* 60 MHz */
 #define MT312_PLL_CLK		10000000UL	/* 10 MHz */
 
 static int mt312_read(struct mt312_state *state, const enum mt312_reg_addr reg,
@@ -209,7 +208,7 @@ static int mt312_get_symbol_rate(struct 
 		dprintk("sym_rat_op=%d dec_ratio=%d\n",
 		       sym_rat_op, dec_ratio);
 		dprintk("*sr(manual) = %lu\n",
-		       (((MT312_PLL_CLK * 8192) / (sym_rat_op + 8192)) *
+		       (((state->xtal * 8192) / (sym_rat_op + 8192)) *
 			2) - dec_ratio);
 	}
 
@@ -242,7 +241,7 @@ static int mt312_initfe(struct dvb_front
 
 	/* wake up */
 	ret = mt312_writereg(state, CONFIG,
-			(state->frequency == 60 ? 0x88 : 0x8c));
+			(state->freq_mult == 6 ? 0x88 : 0x8c));
 	if (ret < 0)
 		return ret;
 
@@ -266,11 +265,10 @@ static int mt312_initfe(struct dvb_front
 	}
 
 	/* SYS_CLK */
-	buf[0] = mt312_div((state->frequency == 60 ? MT312_LPOWER_SYS_CLK :
-				MT312_SYS_CLK) * 2, 1000000);
+	buf[0] = mt312_div(state->xtal * state->freq_mult * 2, 1000000);
 
 	/* DISEQC_RATIO */
-	buf[1] = mt312_div(MT312_PLL_CLK, 22000 * 4);
+	buf[1] = mt312_div(state->xtal, 22000 * 4);
 
 	ret = mt312_write(state, SYS_CLK, buf, sizeof(buf));
 	if (ret < 0)
@@ -535,17 +533,17 @@ static int mt312_set_frontend(struct dvb
 			return ret;
 		if (p->u.qpsk.symbol_rate >= 30000000) {
 			/* Note that 30MS/s should use 90MHz */
-			if ((config_val & 0x0c) == 0x08) {
+			if (state->freq_mult == 6) {
 				/* We are running 60MHz */
-				state->frequency = 90;
+				state->freq_mult = 9;
 				ret = mt312_initfe(fe);
 				if (ret < 0)
 					return ret;
 			}
 		} else {
-			if ((config_val & 0x0c) == 0x0C) {
+			if (state->freq_mult == 9) {
 				/* We are running 90MHz */
-				state->frequency = 60;
+				state->freq_mult = 6;
 				ret = mt312_initfe(fe);
 				if (ret < 0)
 					return ret;
@@ -664,6 +662,7 @@ static void mt312_release(struct dvb_fro
 	kfree(state);
 }
 
+#define MT312_SYS_CLK		90000000UL	/* 90 MHz */
 static struct dvb_frontend_ops vp310_mt312_ops = {
 
 	.info = {
@@ -671,8 +670,8 @@ static struct dvb_frontend_ops vp310_mt3
 		.type = FE_QPSK,
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
-		.frequency_stepsize = (MT312_PLL_CLK / 1000) / 128,
-		.symbol_rate_min = MT312_SYS_CLK / 128,
+		.frequency_stepsize = (MT312_PLL_CLK / 1000) / 128, /* FIXME: adjust freq to real used xtal */
+		.symbol_rate_min = MT312_SYS_CLK / 128, /* FIXME as above */
 		.symbol_rate_max = MT312_SYS_CLK / 2,
 		.caps =
 		    FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
@@ -729,11 +728,13 @@ struct dvb_frontend *vp310_mt312_attach(
 	switch (state->id) {
 	case ID_VP310:
 		strcpy(state->frontend.ops.info.name, "Zarlink VP310 DVB-S");
-		state->frequency = 90;
+		state->xtal = MT312_PLL_CLK;
+		state->freq_mult = 9;
 		break;
 	case ID_MT312:
 		strcpy(state->frontend.ops.info.name, "Zarlink MT312 DVB-S");
-		state->frequency = 60;
+		state->xtal = MT312_PLL_CLK;
+		state->freq_mult = 6;
 		break;
 	default:
 		printk(KERN_WARNING "Only Zarlink VP310/MT312"

-- 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
