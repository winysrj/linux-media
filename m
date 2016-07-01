Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48612 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbcGAOdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 10:33:44 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>
Subject: [PATCH 1/4] cxd2841er: don't expose a dvbv5 stats to userspace if not available
Date: Fri,  1 Jul 2016 11:03:13 -0300
Message-Id: <75889448cdfcea311a0c0f5e1c8cc022915dd4fe.1467381792.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code will expose a zero value if one of the stats is
not available, but this is not what userspace expects. Instead,
if something goes wrong on providing some stats, it should be
changing the scale to FE_SCALE_NOT_AVAILABLE.

So, change the logic to do the right thing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/cxd2841er.c | 92 +++++++++++++++++----------------
 1 file changed, 48 insertions(+), 44 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index c960e8a725cc..543b20155efc 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -1330,7 +1330,7 @@ static int cxd2841er_read_packet_errors_i(
 	return 0;
 }
 
-static u32 cxd2841er_mon_read_ber_s(struct cxd2841er_priv *priv)
+static int cxd2841er_mon_read_ber_s(struct cxd2841er_priv *priv, u32 *ber)
 {
 	u8 data[11];
 	u32 bit_error, bit_count;
@@ -1365,25 +1365,25 @@ static u32 cxd2841er_mon_read_ber_s(struct cxd2841er_priv *priv)
 			dev_dbg(&priv->i2c->dev,
 				"%s(): invalid bit_error %d, bit_count %d\n",
 				__func__, bit_error, bit_count);
-			return 0;
+			return -EINVAL;
 		}
 		temp_q = div_u64_rem(10000000ULL * bit_error,
 						bit_count, &temp_r);
 		if (bit_count != 1 && temp_r >= bit_count / 2)
 			temp_q++;
-		return temp_q;
+		*ber = temp_q;
+		return 0;
 	}
 	dev_dbg(&priv->i2c->dev, "%s(): no data available\n", __func__);
-	return 0;
+	return -EINVAL;
 }
 
 
-static u32 cxd2841er_mon_read_ber_s2(struct cxd2841er_priv *priv)
+static int cxd2841er_mon_read_ber_s2(struct cxd2841er_priv *priv, u32 *ber)
 {
 	u8 data[5];
 	u32 bit_error, period;
 	u32 temp_q, temp_r;
-	u32 result = 0;
 
 	/* Set SLV-T Bank : 0xB2 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0xb2);
@@ -1411,13 +1411,13 @@ static u32 cxd2841er_mon_read_ber_s2(struct cxd2841er_priv *priv)
 		if (period == 0) {
 			dev_dbg(&priv->i2c->dev,
 				"%s(): period is 0\n", __func__);
-			return 0;
+			return -EINVAL;
 		}
 		if (bit_error > (period * 64800)) {
 			dev_dbg(&priv->i2c->dev,
 				"%s(): invalid bit_err 0x%x period 0x%x\n",
 				__func__, bit_error, period);
-			return 0;
+			return -EINVAL;
 		}
 		/*
 		 * BER = bitError / (period * 64800)
@@ -1430,12 +1430,13 @@ static u32 cxd2841er_mon_read_ber_s2(struct cxd2841er_priv *priv)
 					period * 81, &temp_r);
 		if (temp_r >= period * 40)
 			temp_q++;
-		result = temp_q;
+		*ber = temp_q;
+		return 0;
 	} else {
 		dev_dbg(&priv->i2c->dev,
 			"%s(): no data available\n", __func__);
 	}
-	return result;
+	return -EINVAL;
 }
 
 static int cxd2841er_read_ber_t2(struct cxd2841er_priv *priv, u32 *ber)
@@ -1702,29 +1703,37 @@ static u16 cxd2841er_read_agc_gain_s(struct cxd2841er_priv *priv)
 	return ((((u16)data[0] & 0x1F) << 8) | (u16)(data[1] & 0xFF)) << 3;
 }
 
-static int cxd2841er_read_ber(struct dvb_frontend *fe, u32 *ber)
+static void cxd2841er_read_ber(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
+	u32 ber = 0, ret;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
-	*ber = 0;
 	switch (p->delivery_system) {
 	case SYS_DVBS:
-		*ber = cxd2841er_mon_read_ber_s(priv);
+		ret = cxd2841er_mon_read_ber_s(priv, &ber);
 		break;
 	case SYS_DVBS2:
-		*ber = cxd2841er_mon_read_ber_s2(priv);
+		ret = cxd2841er_mon_read_ber_s2(priv, &ber);
 		break;
 	case SYS_DVBT:
-		return cxd2841er_read_ber_t(priv, ber);
+		ret = cxd2841er_read_ber_t(priv, &ber);
+		break;
 	case SYS_DVBT2:
-		return cxd2841er_read_ber_t2(priv, ber);
+		ret = cxd2841er_read_ber_t2(priv, &ber);
+		break;
 	default:
-		*ber = 0;
-		break;
+		p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return;
+	}
+
+	if (!ret) {
+		p->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		p->post_bit_error.stat[0].uvalue = ber;
+	} else {
+		p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
-	return 0;
 }
 
 static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
@@ -1756,13 +1765,12 @@ static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
 		p->strength.stat[0].uvalue = strength;
 		break;
 	default:
-		p->strength.stat[0].scale = FE_SCALE_RELATIVE;
-		p->strength.stat[0].uvalue = 0;
+		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		break;
 	}
 }
 
-static int cxd2841er_read_snr(struct dvb_frontend *fe, u16 *snr)
+static void cxd2841er_read_snr(struct dvb_frontend *fe)
 {
 	u32 tmp = 0;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
@@ -1786,34 +1794,39 @@ static int cxd2841er_read_snr(struct dvb_frontend *fe, u16 *snr)
 	default:
 		dev_dbg(&priv->i2c->dev, "%s(): unknown delivery system %d\n",
 			__func__, p->delivery_system);
-		break;
+		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return;
 	}
-	*snr = tmp & 0xffff;
-	return 0;
+
+	p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	p->cnr.stat[0].svalue = tmp;
 }
 
-static int cxd2841er_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+static void cxd2841er_read_ucblocks(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
+	u32 ucblocks;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
 	case SYS_DVBT:
-		cxd2841er_read_packet_errors_t(priv, ucblocks);
+		cxd2841er_read_packet_errors_t(priv, &ucblocks);
 		break;
 	case SYS_DVBT2:
-		cxd2841er_read_packet_errors_t2(priv, ucblocks);
+		cxd2841er_read_packet_errors_t2(priv, &ucblocks);
 		break;
 	case SYS_ISDBT:
-		cxd2841er_read_packet_errors_i(priv, ucblocks);
+		cxd2841er_read_packet_errors_i(priv, &ucblocks);
 		break;
 	default:
-		*ucblocks = 0;
-		break;
+		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return;
 	}
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
-	return 0;
+
+	p->block_error.stat[0].scale = FE_SCALE_COUNTER;
+	p->block_error.stat[0].uvalue = ucblocks;
 }
 
 static int cxd2841er_dvbt2_set_profile(
@@ -2933,8 +2946,6 @@ static int cxd2841er_get_frontend(struct dvb_frontend *fe,
 				  struct dtv_frontend_properties *p)
 {
 	enum fe_status status = 0;
-	u16 snr = 0;
-	u32 errors = 0, ber = 0;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
@@ -2946,17 +2957,10 @@ static int cxd2841er_get_frontend(struct dvb_frontend *fe,
 	cxd2841er_read_signal_strength(fe);
 
 	if (status & FE_HAS_LOCK) {
-		cxd2841er_read_snr(fe, &snr);
-		p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-		p->cnr.stat[0].svalue = snr;
+		cxd2841er_read_snr(fe);
+		cxd2841er_read_ucblocks(fe);
 
-		cxd2841er_read_ucblocks(fe, &errors);
-		p->block_error.stat[0].scale = FE_SCALE_COUNTER;
-		p->block_error.stat[0].uvalue = errors;
-
-		cxd2841er_read_ber(fe, &ber);
-		p->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		p->post_bit_error.stat[0].uvalue = ber;
+		cxd2841er_read_ber(fe);
 	} else {
 		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-- 
2.7.4

