Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbcF3D6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 23:58:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] cxd2841er: Do some changes at the dvbv5 stats logic
Date: Thu, 30 Jun 2016 00:34:59 -0300
Message-Id: <601a6f40c550ae683100c1e5446712945740a7ab.1467257693.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is a good idea to measure the signal strength while
tuning, as this helps to identify if the antenna is ok.
Also, such measure helps to identify the quality of the
signal.

Do some changes to enable it before signal lock. While
here, optimize the code to only initialize the stats
length once, and make sure that, just after set_frontend,
any reading for the stats that depends on lock to return
FE_SCALE_NOT_AVAILABLE.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/cxd2841er.c | 45 ++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index d369a7567d18..3d39ae954fe2 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -2936,31 +2936,25 @@ static int cxd2841er_get_frontend(struct dvb_frontend *fe,
 	else if (priv->state == STATE_ACTIVE_TC)
 		cxd2841er_read_status_tc(fe, &status);
 
+	cxd2841er_read_signal_strength(fe, &strength);
+	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	p->strength.stat[0].uvalue = strength;
+
 	if (status & FE_HAS_LOCK) {
-		cxd2841er_read_signal_strength(fe, &strength);
-		p->strength.len = 1;
-		p->strength.stat[0].scale = FE_SCALE_RELATIVE;
-		p->strength.stat[0].uvalue = strength;
 		cxd2841er_read_snr(fe, &snr);
-		p->cnr.len = 1;
 		p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 		p->cnr.stat[0].svalue = snr;
+
 		cxd2841er_read_ucblocks(fe, &errors);
-		p->block_error.len = 1;
 		p->block_error.stat[0].scale = FE_SCALE_COUNTER;
 		p->block_error.stat[0].uvalue = errors;
+
 		cxd2841er_read_ber(fe, &ber);
-		p->post_bit_error.len = 1;
 		p->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
 		p->post_bit_error.stat[0].uvalue = ber;
 	} else {
-		p->strength.len = 1;
-		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-		p->cnr.len = 1;
 		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-		p->block_error.len = 1;
 		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-		p->post_bit_error.len = 1;
 		p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 	return 0;
@@ -3021,6 +3015,12 @@ static int cxd2841er_set_frontend_s(struct dvb_frontend *fe)
 			__func__, carr_offset);
 	}
 done:
+	/* Reset stats */
+	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	return ret;
 }
 
@@ -3382,6 +3382,21 @@ static enum dvbfe_algo cxd2841er_get_algo(struct dvb_frontend *fe)
 	return DVBFE_ALGO_HW;
 }
 
+static int cxd2841er_init_stats(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+
+	p->strength.len = 1;
+	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	p->cnr.len = 1;
+	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_error.len = 1;
+	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_error.len = 1;
+	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+}
+
+
 static int cxd2841er_init_s(struct dvb_frontend *fe)
 {
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
@@ -3403,6 +3418,9 @@ static int cxd2841er_init_s(struct dvb_frontend *fe)
 	/* SONY_DEMOD_CONFIG_SAT_IFAGCNEG set to 1 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0xa0);
 	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xb9, 0x01, 0x01);
+
+	cxd2841er_init_stats(fe);
+
 	return 0;
 }
 
@@ -3422,6 +3440,9 @@ static int cxd2841er_init_tc(struct dvb_frontend *fe)
 	/* SONY_DEMOD_CONFIG_PARALLEL_SEL = 1 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x00);
 	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xc4, 0x00, 0x80);
+
+	cxd2841er_init_stats(fe);
+
 	return 0;
 }
 
-- 
2.7.4

