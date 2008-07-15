Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KIr2l-0006jK-1g
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 22:22:40 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <20080715105147.7b661467@bk.ru>
References: <36ADB82E-9B62-4847-BB60-0AD1AB572391@krastelcom.ru>
	<1216091871.5048.11.camel@pc10.localdom.local>
	<20080715105147.7b661467@bk.ru>
Date: Tue, 15 Jul 2008 22:18:16 +0200
Message-Id: <1216153096.3009.27.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Express AM2 11044 H 45 MSps
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Am Dienstag, den 15.07.2008, 10:51 +0400 schrieb Goga777:
> Hi
> 
> I have the same problem as Vladimir. I have the hvr4000 and tt2300 SS1 cards and I couldn't lock this package with
> extremely high SR . My dreambox 7000 can lock this package without any problem. 
> 
> > > I have recently realized that none of the available cards are able to  
> > > properly lock on Express AM2 11044H 45 MSps . The only one that can is  
> > > TT-S1401 with buf[5] register corrections.
> > > 
> > > I have tried:
> > > 
> > > TT S-1500
> > > TT S2-3200
> > > Skystar 2.6
> > > TT S-1401 with non-modified drivers.
> > > 
> > > Regards,
> > > Vladimir
> > > 
> > 
> > do you mean that, what Hartmut, Manu and Oliver worked out for it for
> > dynamic bandwidth cutoff adjustment, 
> 
> sorry, what do you mean ? 
> 
> Goga

there was a patch for Philips tda826x silicon tuners on cards like
TT S-1401 with tda10086 demod for baseband cut-off according to the
bandwidth in use, which should have fixed high SR troubles.

http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025370.html

I had nothing with high SR to test, but I do expect Vladimir means this
one, which is since then over Hartmut in v4l-dvb and 2.6.26.

> >which is in mercurial v4l-dvb, or
> > do you still try something different with better results?
> > 
> > Can you make that clear please?
> 

The patch to get high SR on Philips SU1278 TT from Andrey Pridvorov, who
thinks his patch is not applied, is here and was scrubbed. The
attachment.obj is budget-ci.diff.bz2.
http://www.linuxtv.org/pipermail/linux-dvb/2007-September/020334.html

Here is a copy.
That patch is fully applied including the two new white lines ;)

Cheers,
Hermann

--- budget-ci.c	2007-09-09 01:57:56.000000000 +1100
+++ budget-ci.c.old	2007-09-02 17:56:18.000000000 +1100
@@ -618,10 +618,10 @@
 }
 
 static u8 philips_su1278_tt_inittab[] = {
-        0x01, 0x15,
+	0x01, 0x0f,
 	0x02, 0x30,
 	0x03, 0x00,
-	0x04, 0x7d,
+	0x04, 0x5b,
 	0x05, 0x85,
 	0x06, 0x02,
 	0x07, 0x00,
@@ -629,12 +629,12 @@
 	0x09, 0x00,
 	0x0C, 0x01,
 	0x0D, 0x81,
-	0x0E, 0x23,
-	0x0f, 0x94,
-	0x10, 0x39,
+	0x0E, 0x44,
+	0x0f, 0x14,
+	0x10, 0x3c,
 	0x11, 0x84,
-	0x12, 0xb9,
-	0x13, 0xb5,
+	0x12, 0xda,
+	0x13, 0x97,
 	0x14, 0x95,
 	0x15, 0xc9,
 	0x16, 0x19,
@@ -655,35 +655,45 @@
 	0x2a, 0x14,
 	0x2b, 0x0f,
 	0x2c, 0x09,
-	0x2d, 0x05,
+	0x2d, 0x09,
 	0x31, 0x1f,
 	0x32, 0x19,
 	0x33, 0xfc,
 	0x34, 0x93,
 	0xff, 0xff
-}; 
+};
 
 static int philips_su1278_tt_set_symbol_rate(struct dvb_frontend *fe, u32 srate, u32 ratio)
 {
-        u8 aclk = 0;
-	u8 bclk = 0;
-	u8 m1;
-	
-	aclk = 0xb5;
-	if (srate < 2000000) bclk = 0x86;
-	else if (srate < 5000000) bclk = 0x89;
-	else if (srate < 15000000) bclk = 0x8f;
-	else if (srate < 45000000) bclk = 0x95;
-	m1 = 0x94;
-	if (srate < 4000000) m1 = 0x90;
-	stv0299_writereg (fe, 0x13, aclk);
-	stv0299_writereg (fe, 0x14, bclk);
-	stv0299_writereg (fe, 0x1f, (ratio >> 16) & 0xff);
-	stv0299_writereg (fe, 0x20, (ratio >>  8) & 0xff);
-	stv0299_writereg (fe, 0x21, (ratio      ) & 0xf0);
-	stv0299_writereg (fe, 0x0f, m1);
+	stv0299_writereg(fe, 0x0e, 0x44);
+	if (srate >= 10000000) {
+		stv0299_writereg(fe, 0x13, 0x97);
+		stv0299_writereg(fe, 0x14, 0x95);
+		stv0299_writereg(fe, 0x15, 0xc9);
+		stv0299_writereg(fe, 0x17, 0x8c);
+		stv0299_writereg(fe, 0x1a, 0xfe);
+		stv0299_writereg(fe, 0x1c, 0x7f);
+		stv0299_writereg(fe, 0x2d, 0x09);
+	} else {
+		stv0299_writereg(fe, 0x13, 0x99);
+		stv0299_writereg(fe, 0x14, 0x8d);
+		stv0299_writereg(fe, 0x15, 0xce);
+		stv0299_writereg(fe, 0x17, 0x43);
+		stv0299_writereg(fe, 0x1a, 0x1d);
+		stv0299_writereg(fe, 0x1c, 0x12);
+		stv0299_writereg(fe, 0x2d, 0x05);
+	}
+	stv0299_writereg(fe, 0x0e, 0x23);
+	stv0299_writereg(fe, 0x0f, 0x94);
+	stv0299_writereg(fe, 0x10, 0x39);
+	stv0299_writereg(fe, 0x15, 0xc9);
+
+	stv0299_writereg(fe, 0x1f, (ratio >> 16) & 0xff);
+	stv0299_writereg(fe, 0x20, (ratio >> 8) & 0xff);
+	stv0299_writereg(fe, 0x21, (ratio) & 0xf0);
+
 	return 0;
-} 
+}
 
 static int philips_su1278_tt_tuner_set_params(struct dvb_frontend *fe,
 					   struct dvb_frontend_parameters *params)
@@ -725,14 +735,16 @@
 
 	.demod_address = 0x68,
 	.inittab = philips_su1278_tt_inittab,
-	.mclk = 88000000UL,
+	.mclk = 64000000UL,
 	.invert = 0,
 	.skip_reinit = 1,
 	.lock_output = STV0229_LOCKOUTPUT_1,
 	.volt13_op0_op1 = STV0299_VOLT13_OP1,
 	.min_delay_ms = 50,
 	.set_symbol_rate = philips_su1278_tt_set_symbol_rate,
-}; 
+};
+
+
 
 static int philips_tdm1316l_tuner_init(struct dvb_frontend *fe)
 {


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
