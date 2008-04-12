Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JkUIa-0004pB-9C
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 03:12:57 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 12 Apr 2008 03:11:59 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_gxAAIT/nxcbcar6"
Message-Id: <200804120312.00264@orion.escape-edv.de>
Subject: [linux-dvb] [ALPS BSBE1] Improve tuning
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_gxAAIT/nxcbcar6
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I have reworked the BSBE1 tuner support in bsbe1.h to follow the ALPS-
recommended parameters more closely.

Tests with BSBE1-based Activy cards showed reduced BER.

Cards affected:
- driver dvb-ttpci(av7110): Hauppauge/TT Nexus-S rev 2.3
- driver budget-ci: TT S-1500 PCI

Please test and report any problems. Thanks!

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

--Boundary-00=_gxAAIT/nxcbcar6
Content-Type: text/x-diff;
  charset="us-ascii";
  name="bsbe1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="bsbe1.diff"

diff -r f24051885fe9 linux/drivers/media/dvb/frontends/bsbe1.h
--- a/linux/drivers/media/dvb/frontends/bsbe1.h	Tue Mar 18 18:10:06 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/bsbe1.h	Wed Apr 09 02:35:53 2008 +0200
@@ -1,5 +1,5 @@
 /*
- * bsbe1.h - ALPS BSBE1 tuner support (moved from av7110.c)
+ * bsbe1.h - ALPS BSBE1 tuner support
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -30,40 +30,20 @@ static u8 alps_bsbe1_inittab[] = {
 	0x02, 0x30,
 	0x03, 0x00,
 	0x04, 0x7d,   /* F22FR = 0x7d, F22 = f_VCO / 128 / 0x7d = 22 kHz */
-	0x05, 0x35,   /* I2CT = 0, SCLT = 1, SDAT = 1 */
-	0x06, 0x40,   /* DAC not used, set to high impendance mode */
-	0x07, 0x00,   /* DAC LSB */
+	0x05, 0x05,   /* I2CT = 0, SCLT = 1, SDAT = 1 */
+	0x06, 0x00,   /* DAC not used */
 	0x08, 0x40,   /* DiSEqC off, LNB power on OP2/LOCK pin on */
 	0x09, 0x00,   /* FIFO */
 	0x0c, 0x51,   /* OP1 ctl = Normal, OP1 val = 1 (LNB Power ON) */
 	0x0d, 0x82,   /* DC offset compensation = ON, beta_agc1 = 2 */
-	0x0e, 0x23,   /* alpha_tmg = 2, beta_tmg = 3 */
-	0x10, 0x3f,   // AGC2  0x3d
+	0x0f, 0x92,
+	0x10, 0x34,   /* AGC2 */
 	0x11, 0x84,
 	0x12, 0xb9,
-	0x15, 0xc9,   // lock detector threshold
-	0x16, 0x00,
-	0x17, 0x00,
-	0x18, 0x00,
-	0x19, 0x00,
-	0x1a, 0x00,
-	0x1f, 0x50,
-	0x20, 0x00,
-	0x21, 0x00,
-	0x22, 0x00,
-	0x23, 0x00,
-	0x28, 0x00,  // out imp: normal  out type: parallel FEC mode:0
-	0x29, 0x1e,  // 1/2 threshold
-	0x2a, 0x14,  // 2/3 threshold
-	0x2b, 0x0f,  // 3/4 threshold
-	0x2c, 0x09,  // 5/6 threshold
-	0x2d, 0x05,  // 7/8 threshold
-	0x2e, 0x01,
-	0x31, 0x1f,  // test all FECs
-	0x32, 0x19,  // viterbi and synchro search
-	0x33, 0xfc,  // rs control
-	0x34, 0x93,  // error control
-	0x0f, 0x92,
+	0x15, 0xc9,   /* lock detector threshold */
+	0x28, 0x00,   /* out imp: normal  out type: parallel FEC mode:0 */
+	0x33, 0xfc,   /* rs control */
+	0x34, 0x93,   /* error control */
 	0xff, 0xff
 };
 
@@ -100,11 +80,11 @@ static int alps_bsbe1_tuner_set_params(s
 	if ((params->frequency < 950000) || (params->frequency > 2150000))
 		return -EINVAL;
 
-	div = (params->frequency + (125 - 1)) / 125; // round correctly
+	div = params->frequency / 1000;
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
-	data[2] = 0x80 | ((div & 0x18000) >> 10) | 4;
-	data[3] = (params->frequency > 1530000) ? 0xE0 : 0xE4;
+	data[2] = 0x80 | ((div & 0x18000) >> 10) | 1;
+	data[3] = 0xe0;
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);

--Boundary-00=_gxAAIT/nxcbcar6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_gxAAIT/nxcbcar6--
