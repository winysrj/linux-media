Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33180 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbcF3Wlw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 18:41:52 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] cxd2841er: Fix signal strengh for DVB-T/T2 and show it in dBm
Date: Thu, 30 Jun 2016 19:41:45 -0300
Message-Id: <d3e86a2b40700206e71ad016ea069011c35da143.1467326502.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The signal strength value is reversed: the bigger the number,
the weaker is the signal.

Fix the logic and present it in dBm. Please notice that the
dBm measure is actually an estimation, as the ratio is not
fully linear. It also varies with the frequency.

Yet, the estimation should be good enough for programs like
Kaffeine to indicate when the signal is good or bad.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/cxd2841er.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index c1b77a6268d4..c960e8a725cc 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -1727,32 +1727,39 @@ static int cxd2841er_read_ber(struct dvb_frontend *fe, u32 *ber)
 	return 0;
 }
 
-static int cxd2841er_read_signal_strength(struct dvb_frontend *fe,
-					  u16 *strength)
+static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
+	u32 strength;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
 	case SYS_DVBT:
 	case SYS_DVBT2:
-		*strength = 65535 - cxd2841er_read_agc_gain_t_t2(
-			priv, p->delivery_system);
-		break;
+		strength = cxd2841er_read_agc_gain_t_t2(priv,
+							p->delivery_system);
+		p->strength.stat[0].scale = FE_SCALE_DECIBEL;
+		/* Formula was empirically determinated @ 410 MHz */
+		p->strength.stat[0].uvalue = ((s32)strength) * 366 / 100 - 89520;
+		break;	/* Code moved out of the function */
 	case SYS_ISDBT:
-		*strength = 65535 - cxd2841er_read_agc_gain_i(
+		strength = 65535 - cxd2841er_read_agc_gain_i(
 				priv, p->delivery_system);
+		p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		p->strength.stat[0].uvalue = strength;
 		break;
 	case SYS_DVBS:
 	case SYS_DVBS2:
-		*strength = 65535 - cxd2841er_read_agc_gain_s(priv);
+		strength = 65535 - cxd2841er_read_agc_gain_s(priv);
+		p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		p->strength.stat[0].uvalue = strength;
 		break;
 	default:
-		*strength = 0;
+		p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		p->strength.stat[0].uvalue = 0;
 		break;
 	}
-	return 0;
 }
 
 static int cxd2841er_read_snr(struct dvb_frontend *fe, u16 *snr)
@@ -2926,7 +2933,7 @@ static int cxd2841er_get_frontend(struct dvb_frontend *fe,
 				  struct dtv_frontend_properties *p)
 {
 	enum fe_status status = 0;
-	u16 strength = 0, snr = 0;
+	u16 snr = 0;
 	u32 errors = 0, ber = 0;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
 
@@ -2936,9 +2943,7 @@ static int cxd2841er_get_frontend(struct dvb_frontend *fe,
 	else if (priv->state == STATE_ACTIVE_TC)
 		cxd2841er_read_status_tc(fe, &status);
 
-	cxd2841er_read_signal_strength(fe, &strength);
-	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
-	p->strength.stat[0].uvalue = strength;
+	cxd2841er_read_signal_strength(fe);
 
 	if (status & FE_HAS_LOCK) {
 		cxd2841er_read_snr(fe, &snr);
-- 
2.7.4

