Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33139 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755472AbdGCRVN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 13:21:13 -0400
Received: by mail-wm0-f66.google.com with SMTP id j85so21729207wmj.0
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 10:21:12 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH v3 04/10] [media] dvb-frontends/stv0910: Add demod-only signal strength reporting
Date: Mon,  3 Jul 2017 19:20:57 +0200
Message-Id: <20170703172104.27283-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170703172104.27283-1-d.scheller.oss@gmail.com>
References: <20170703172104.27283-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Original code at least has some signed/unsigned issues, resulting in
values like 32dBm. Implement signal strength readout to work without
asking the attached tuner, and use a lookup table instead of log calc.
Values reported appear plausible, gathered from feedback from several
testers.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
---
 drivers/media/dvb-frontends/stv0910.c | 48 ++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index dc848ebe1a44..dc4d829bb47a 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -135,7 +135,7 @@ struct sinit_table {
 
 struct slookup {
 	s16  value;
-	u16  reg_value;
+	u32  reg_value;
 };
 
 static inline int i2c_write(struct i2c_adapter *adap, u8 adr,
@@ -327,6 +327,25 @@ struct slookup s2_sn_lookup[] = {
 	{  510,    463  },  /*C/N=51.0dB*/
 };
 
+struct slookup padc_lookup[] = {
+	{    0,  118000 }, /* PADC=+0dBm  */
+	{ -100,  93600  }, /* PADC=-1dBm  */
+	{ -200,  74500  }, /* PADC=-2dBm  */
+	{ -300,  59100  }, /* PADC=-3dBm  */
+	{ -400,  47000  }, /* PADC=-4dBm  */
+	{ -500,  37300  }, /* PADC=-5dBm  */
+	{ -600,  29650  }, /* PADC=-6dBm  */
+	{ -700,  23520  }, /* PADC=-7dBm  */
+	{ -900,  14850  }, /* PADC=-9dBm  */
+	{ -1100, 9380   }, /* PADC=-11dBm */
+	{ -1300, 5910   }, /* PADC=-13dBm */
+	{ -1500, 3730   }, /* PADC=-15dBm */
+	{ -1700, 2354   }, /* PADC=-17dBm */
+	{ -1900, 1485   }, /* PADC=-19dBm */
+	{ -2000, 1179   }, /* PADC=-20dBm */
+	{ -2100, 1000   }, /* PADC=-21dBm */
+};
+
 /*********************************************************************
  * Tracking carrier loop carrier QPSK 1/4 to 8PSK 9/10 long Frame
  *********************************************************************/
@@ -567,7 +586,7 @@ static int tracking_optimization(struct stv *state)
 }
 
 static s32 table_lookup(struct slookup *table,
-		       int table_size, u16 reg_value)
+		       int table_size, u32 reg_value)
 {
 	s32 value;
 	int imin = 0;
@@ -1300,11 +1319,32 @@ static int read_ber(struct dvb_frontend *fe)
 
 static void read_signal_strength(struct dvb_frontend *fe)
 {
-	/* FIXME: add signal strength algo */
 	struct stv *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *p = &state->fe.dtv_property_cache;
+	s64 strength;
+	u8 reg[2];
+	u16 agc;
+	s32 padc, power = 0;
+	int i;
 
-	p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	read_regs(state, RSTV0910_P2_AGCIQIN1 + state->regoff, reg, 2);
+
+	agc = (((u32) reg[0]) << 8) | reg[1];
+
+	for (i = 0; i < 5; i += 1) {
+		read_regs(state, RSTV0910_P2_POWERI + state->regoff, reg, 2);
+		power += (u32) reg[0] * (u32) reg[0]
+			+ (u32) reg[1] * (u32) reg[1];
+		usleep_range(3000, 4000);
+	}
+	power /= 5;
+
+	padc = table_lookup(padc_lookup, ARRAY_SIZE(padc_lookup), power) + 352;
+
+	strength = (padc - agc);
+
+	p->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	p->strength.stat[0].uvalue = strength;
 }
 
 static int read_status(struct dvb_frontend *fe, enum fe_status *status)
-- 
2.13.0
