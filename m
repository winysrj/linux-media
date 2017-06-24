Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34026 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751369AbdFXQDK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 12:03:10 -0400
Received: by mail-wr0-f193.google.com with SMTP id k67so19936648wrc.1
        for <linux-media@vger.kernel.org>; Sat, 24 Jun 2017 09:03:09 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 4/9] [media] dvb-frontends/stv0910: Fix signal strength reporting
Date: Sat, 24 Jun 2017 18:02:56 +0200
Message-Id: <20170624160301.17710-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170624160301.17710-1-d.scheller.oss@gmail.com>
References: <20170624160301.17710-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Original code at least has some signed/unsigned issues, resulting in
values like 32dBm. Change signal strength readout to work without asking
the attached tuner, and use a lookup table instead of log calc. Values
reported appear plausible. Obsoletes the INTLOG10X100 calc macro.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 50 ++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 999ee6a8ea23..c1875be01631 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -31,8 +31,6 @@
 #include "stv0910.h"
 #include "stv0910_regs.h"
 
-#define INTLOG10X100(x) ((u32) (((u64) intlog10(x) * 100) >> 24))
-
 #define EXT_CLOCK   30000000
 #define TUNING_DELAY    200
 #define BER_SRC_S    0x20
@@ -140,7 +138,7 @@ struct SInitTable {
 
 struct SLookup {
 	s16  Value;
-	u16  RegValue;
+	u32  RegValue;
 };
 
 static inline int i2c_write(struct i2c_adapter *adap, u8 adr,
@@ -332,6 +330,25 @@ struct SLookup S2_SN_Lookup[] = {
 	{  510,    463  },  /*C/N=51.0dB*/
 };
 
+struct SLookup padc_lookup[] = {
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
@@ -572,7 +589,7 @@ static int TrackingOptimization(struct stv *state)
 }
 
 static s32 TableLookup(struct SLookup *Table,
-		       int TableSize, u16 RegValue)
+		       int TableSize, u32 RegValue)
 {
 	s32 Value;
 	int imin = 0;
@@ -1300,17 +1317,18 @@ static int read_ber(struct dvb_frontend *fe, u32 *ber, u32 *n, u32 *d)
 	return 0;
 }
 
-static int read_signal_strength(struct dvb_frontend *fe, u16 *strength)
+static int read_signal_strength(struct dvb_frontend *fe, s64 *strength)
 {
 	struct stv *state = fe->demodulator_priv;
 	u8 Reg[2];
-	s32 bbgain;
+	u16 agc;
+	s32 padc;
 	s32 Power = 0;
 	int i;
 
 	read_regs(state, RSTV0910_P2_AGCIQIN1 + state->regoff, Reg, 2);
 
-	*strength = (((u32) Reg[0]) << 8) | Reg[1];
+	agc = (((u32) Reg[0]) << 8) | Reg[1];
 
 	for (i = 0; i < 5; i += 1) {
 		read_regs(state, RSTV0910_P2_POWERI + state->regoff, Reg, 2);
@@ -1320,20 +1338,9 @@ static int read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	}
 	Power /= 5;
 
-	bbgain = (465 - INTLOG10X100(Power)) * 10;
-
-	if (fe->ops.tuner_ops.get_rf_strength)
-		fe->ops.tuner_ops.get_rf_strength(fe, strength);
-	else
-		*strength = 0;
-
-	if (bbgain < (s32) *strength)
-		*strength -= bbgain;
-	else
-		*strength = 0;
+	padc = TableLookup(padc_lookup, ARRAY_SIZE(padc_lookup), Power) + 352;
 
-	if (*strength > 0)
-		*strength = 10 * (s64) (s16) *strength - 108750;
+	*strength = (padc - agc);
 
 	return 0;
 }
@@ -1463,7 +1470,8 @@ static int get_frontend(struct dvb_frontend *fe,
 {
 	struct stv *state = fe->demodulator_priv;
 	enum fe_status status;
-	u16 snr = 0, strength = 0;
+	u16 snr = 0;
+	s64 strength = 0;
 	u32 ber = 0, bernom = 0, berdenom = 0;
 	u8 tmp;
 
-- 
2.13.0
