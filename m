Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33605 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdFUTpt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 15:45:49 -0400
Received: by mail-wr0-f193.google.com with SMTP id x23so29319705wrb.0
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 12:45:48 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v2 2/4] [media] dvb-frontends/stv0367: split SNR determination into functions
Date: Wed, 21 Jun 2017 21:45:42 +0200
Message-Id: <20170621194544.16949-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170621194544.16949-1-d.scheller.oss@gmail.com>
References: <20170621194544.16949-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The read_snr() functions currently do some magic to return relative scale
values when called. Split out register readouts into separate functions
so the functionality can be reused in some other way.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 68 +++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 26 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 8ba15dc339f8..f8e9cceed04e 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -1437,7 +1437,7 @@ static int stv0367ter_get_frontend(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int stv0367ter_read_snr(struct dvb_frontend *fe, u16 *snr)
+static u32 stv0367ter_snr_readreg(struct dvb_frontend *fe)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
 	u32 snru32 = 0;
@@ -1453,10 +1453,16 @@ static int stv0367ter_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 		cpt++;
 	}
-
 	snru32 /= 10;/*average on 10 values*/
 
-	*snr = snru32 / 1000;
+	return snru32;
+}
+
+static int stv0367ter_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	u32 snrval = stv0367ter_snr_readreg(fe);
+
+	*snr = snrval / 1000;
 
 	return 0;
 }
@@ -2702,51 +2708,61 @@ static int stv0367cab_read_strength(struct dvb_frontend *fe, u16 *strength)
 	return 0;
 }
 
-static int stv0367cab_read_snr(struct dvb_frontend *fe, u16 *snr)
+static int stv0367cab_snr_power(struct dvb_frontend *fe)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
-	u32 noisepercentage;
 	enum stv0367cab_mod QAMSize;
-	u32 regval = 0, temp = 0;
-	int power, i;
 
 	QAMSize = stv0367_readbits(state, F367CAB_QAM_MODE);
 	switch (QAMSize) {
 	case FE_CAB_MOD_QAM4:
-		power = 21904;
-		break;
+		return 21904;
 	case FE_CAB_MOD_QAM16:
-		power = 20480;
-		break;
+		return 20480;
 	case FE_CAB_MOD_QAM32:
-		power = 23040;
-		break;
+		return 23040;
 	case FE_CAB_MOD_QAM64:
-		power = 21504;
-		break;
+		return 21504;
 	case FE_CAB_MOD_QAM128:
-		power = 23616;
-		break;
+		return 23616;
 	case FE_CAB_MOD_QAM256:
-		power = 21760;
-		break;
-	case FE_CAB_MOD_QAM512:
-		power = 1;
-		break;
+		return 21760;
 	case FE_CAB_MOD_QAM1024:
-		power = 21280;
-		break;
+		return 21280;
 	default:
-		power = 1;
 		break;
 	}
 
+	return 1;
+}
+
+static int stv0367cab_snr_readreg(struct dvb_frontend *fe, int avgdiv)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	u32 regval = 0;
+	int i;
+
 	for (i = 0; i < 10; i++) {
 		regval += (stv0367_readbits(state, F367CAB_SNR_LO)
 			+ 256 * stv0367_readbits(state, F367CAB_SNR_HI));
 	}
 
-	regval /= 10; /*for average over 10 times in for loop above*/
+	if (avgdiv)
+		regval /= 10;
+
+	return regval;
+}
+
+static int stv0367cab_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	u32 noisepercentage;
+	u32 regval = 0, temp = 0;
+	int power;
+
+	power = stv0367cab_snr_power(fe);
+	regval = stv0367cab_snr_readreg(fe, 1);
+
 	if (regval != 0) {
 		temp = power
 			* (1 << (3 + stv0367_readbits(state, F367CAB_SNR_PER)));
-- 
2.13.0
