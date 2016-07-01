Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbcGASlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 14:41:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] cxd2841er: fix signal strength scale for ISDB-T
Date: Fri,  1 Jul 2016 15:41:38 -0300
Message-Id: <fe00b81dd11d60a0c8b5b5e34f7d68e97d6f0cf6.1467398496.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The scale for ISDB-T was wrong too: it was inverted, and
on a relative scale.

Use a linear interpolation to make it look better.
The formula was empirically determined, using 3 frequencies
(175 MHz, 410 MHz and 800 MHz), measuring from -50dBm to
-12dBm in steps of 0.5dB.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/cxd2841er.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 6c660761563d..b706118903fa 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -1731,7 +1731,7 @@ static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
-	u32 strength;
+	s32 strength;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
@@ -1741,7 +1741,7 @@ static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
 							p->delivery_system);
 		p->strength.stat[0].scale = FE_SCALE_DECIBEL;
 		/* Formula was empirically determinated @ 410 MHz */
-		p->strength.stat[0].uvalue = ((s32)strength) * 366 / 100 - 89520;
+		p->strength.stat[0].uvalue = strength * 366 / 100 - 89520;
 		break;	/* Code moved out of the function */
 	case SYS_DVBC_ANNEX_A:
 		strength = cxd2841er_read_agc_gain_t_t2(priv,
@@ -1752,13 +1752,16 @@ static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
 		 * using frequencies: 175 MHz, 410 MHz and 800 MHz, and a
 		 * stream modulated with QAM64
 		 */
-		p->strength.stat[0].uvalue = ((s32)strength) * 4045 / 1000 - 85224;
+		p->strength.stat[0].uvalue = strength * 4045 / 1000 - 85224;
 		break;
 	case SYS_ISDBT:
-		strength = 65535 - cxd2841er_read_agc_gain_i(
-				priv, p->delivery_system);
-		p->strength.stat[0].scale = FE_SCALE_RELATIVE;
-		p->strength.stat[0].uvalue = strength;
+		strength = cxd2841er_read_agc_gain_i(priv, p->delivery_system);
+		p->strength.stat[0].scale = FE_SCALE_DECIBEL;
+		/*
+		 * Formula was empirically determinated via linear regression,
+		 * using frequencies: 175 MHz, 410 MHz and 800 MHz.
+		 */
+		p->strength.stat[0].uvalue = strength * 3775 / 1000 - 90185;
 		break;
 	case SYS_DVBS:
 	case SYS_DVBS2:
-- 
2.7.4

