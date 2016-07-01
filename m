Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbcGAOD2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 10:03:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>
Subject: [PATCH 3/4] cxd2841er: fix BER report via DVBv5 stats API
Date: Fri,  1 Jul 2016 11:03:15 -0300
Message-Id: <a569d8b25151d6d30064d9fe4c02bd27911da059.1467381792.git.mchehab@s-opensource.com>
In-Reply-To: <75889448cdfcea311a0c0f5e1c8cc022915dd4fe.1467381792.git.mchehab@s-opensource.com>
References: <75889448cdfcea311a0c0f5e1c8cc022915dd4fe.1467381792.git.mchehab@s-opensource.com>
In-Reply-To: <75889448cdfcea311a0c0f5e1c8cc022915dd4fe.1467381792.git.mchehab@s-opensource.com>
References: <75889448cdfcea311a0c0f5e1c8cc022915dd4fe.1467381792.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What userspace expects is to receive both bit_error and bit_count
counters. So, instead of doing the division at the Kernel,
return the counters for userspace to handle it the way it
wants.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/cxd2841er.c | 137 +++++++++++++++-----------------
 1 file changed, 66 insertions(+), 71 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index e35f5d0d3f34..e2f3ea55897b 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -1330,11 +1330,10 @@ static int cxd2841er_read_packet_errors_i(
 	return 0;
 }
 
-static int cxd2841er_mon_read_ber_s(struct cxd2841er_priv *priv, u32 *ber)
+static int cxd2841er_mon_read_ber_s(struct cxd2841er_priv *priv,
+				    u32 *bit_error, u32 *bit_count)
 {
 	u8 data[11];
-	u32 bit_error, bit_count;
-	u32 temp_q, temp_r;
 
 	/* Set SLV-T Bank : 0xA0 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0xa0);
@@ -1350,28 +1349,18 @@ static int cxd2841er_mon_read_ber_s(struct cxd2841er_priv *priv, u32 *ber)
 	 */
 	cxd2841er_read_regs(priv, I2C_SLVT, 0x35, data, 11);
 	if (data[0] & 0x01) {
-		bit_error = ((u32)(data[1]  & 0x3F) << 16) |
-			((u32)(data[2]  & 0xFF) <<  8) |
-			(u32)(data[3]  & 0xFF);
-		bit_count = ((u32)(data[8]  & 0x3F) << 16) |
-			((u32)(data[9]  & 0xFF) <<  8) |
-			(u32)(data[10] & 0xFF);
-		/*
-		 *	BER = bitError / bitCount
-		 *	= (bitError * 10^7) / bitCount
-		 *	= ((bitError * 625 * 125 * 128) / bitCount
-		 */
-		if ((bit_count == 0) || (bit_error > bit_count)) {
+		*bit_error = ((u32)(data[1]  & 0x3F) << 16) |
+			     ((u32)(data[2]  & 0xFF) <<  8) |
+			     (u32)(data[3]  & 0xFF);
+		*bit_count = ((u32)(data[8]  & 0x3F) << 16) |
+			     ((u32)(data[9]  & 0xFF) <<  8) |
+			     (u32)(data[10] & 0xFF);
+		if ((*bit_count == 0) || (*bit_error > *bit_count)) {
 			dev_dbg(&priv->i2c->dev,
 				"%s(): invalid bit_error %d, bit_count %d\n",
-				__func__, bit_error, bit_count);
+				__func__, *bit_error, *bit_count);
 			return -EINVAL;
 		}
-		temp_q = div_u64_rem(10000000ULL * bit_error,
-						bit_count, &temp_r);
-		if (bit_count != 1 && temp_r >= bit_count / 2)
-			temp_q++;
-		*ber = temp_q;
 		return 0;
 	}
 	dev_dbg(&priv->i2c->dev, "%s(): no data available\n", __func__);
@@ -1379,11 +1368,11 @@ static int cxd2841er_mon_read_ber_s(struct cxd2841er_priv *priv, u32 *ber)
 }
 
 
-static int cxd2841er_mon_read_ber_s2(struct cxd2841er_priv *priv, u32 *ber)
+static int cxd2841er_mon_read_ber_s2(struct cxd2841er_priv *priv,
+				     u32 *bit_error, u32 *bit_count)
 {
 	u8 data[5];
-	u32 bit_error, period;
-	u32 temp_q, temp_r;
+	u32 period;
 
 	/* Set SLV-T Bank : 0xB2 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0xb2);
@@ -1398,10 +1387,10 @@ static int cxd2841er_mon_read_ber_s2(struct cxd2841er_priv *priv, u32 *ber)
 	cxd2841er_read_regs(priv, I2C_SLVT, 0x30, data, 5);
 	if (data[0] & 0x01) {
 		/* Bit error count */
-		bit_error = ((u32)(data[1] & 0x0F) << 24) |
-			((u32)(data[2] & 0xFF) << 16) |
-			((u32)(data[3] & 0xFF) <<  8) |
-			(u32)(data[4] & 0xFF);
+		*bit_error = ((u32)(data[1] & 0x0F) << 24) |
+			     ((u32)(data[2] & 0xFF) << 16) |
+			     ((u32)(data[3] & 0xFF) <<  8) |
+			     (u32)(data[4] & 0xFF);
 
 		/* Set SLV-T Bank : 0xA0 */
 		cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0xa0);
@@ -1413,24 +1402,14 @@ static int cxd2841er_mon_read_ber_s2(struct cxd2841er_priv *priv, u32 *ber)
 				"%s(): period is 0\n", __func__);
 			return -EINVAL;
 		}
-		if (bit_error > (period * 64800)) {
+		if (*bit_error > (period * 64800)) {
 			dev_dbg(&priv->i2c->dev,
 				"%s(): invalid bit_err 0x%x period 0x%x\n",
-				__func__, bit_error, period);
+				__func__, *bit_error, period);
 			return -EINVAL;
 		}
-		/*
-		 * BER = bitError / (period * 64800)
-		 *	= (bitError * 10^7) / (period * 64800)
-		 *	= (bitError * 10^5) / (period * 648)
-		 *	= (bitError * 12500) / (period * 81)
-		 *	= (bitError * 10) * 1250 / (period * 81)
-		 */
-		temp_q = div_u64_rem(12500ULL * bit_error,
-					period * 81, &temp_r);
-		if (temp_r >= period * 40)
-			temp_q++;
-		*ber = temp_q;
+		*bit_count = period * 64800;
+
 		return 0;
 	} else {
 		dev_dbg(&priv->i2c->dev,
@@ -1439,13 +1418,12 @@ static int cxd2841er_mon_read_ber_s2(struct cxd2841er_priv *priv, u32 *ber)
 	return -EINVAL;
 }
 
-static int cxd2841er_read_ber_t2(struct cxd2841er_priv *priv, u32 *ber)
+static int cxd2841er_read_ber_t2(struct cxd2841er_priv *priv,
+				 u32 *bit_error, u32 *bit_count)
 {
 	u8 data[4];
-	u32 div, q, r;
-	u32 bit_err, period_exp, n_ldpc;
+	u32 period_exp, n_ldpc;
 
-	*ber = 0;
 	if (priv->state != STATE_ACTIVE_TC) {
 		dev_dbg(&priv->i2c->dev,
 			"%s(): invalid state %d\n", __func__, priv->state);
@@ -1456,40 +1434,44 @@ static int cxd2841er_read_ber_t2(struct cxd2841er_priv *priv, u32 *ber)
 	if (!(data[0] & 0x10)) {
 		dev_dbg(&priv->i2c->dev,
 			"%s(): no valid BER data\n", __func__);
-		return 0;
+		return -EINVAL;
 	}
-	bit_err = ((u32)(data[0] & 0x0f) << 24) |
-		((u32)data[1] << 16) |
-		((u32)data[2] << 8) |
-		(u32)data[3];
+	*bit_error = ((u32)(data[0] & 0x0f) << 24) |
+		     ((u32)data[1] << 16) |
+		     ((u32)data[2] << 8) |
+		     (u32)data[3];
 	cxd2841er_read_reg(priv, I2C_SLVT, 0x6f, data);
 	period_exp = data[0] & 0x0f;
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x22);
 	cxd2841er_read_reg(priv, I2C_SLVT, 0x5e, data);
 	n_ldpc = ((data[0] & 0x03) == 0 ? 16200 : 64800);
-	if (bit_err > ((1U << period_exp) * n_ldpc)) {
+	if (*bit_error > ((1U << period_exp) * n_ldpc)) {
 		dev_dbg(&priv->i2c->dev,
 			"%s(): invalid BER value\n", __func__);
 		return -EINVAL;
 	}
+
+	/*
+	 * FIXME: the right thing would be to return bit_error untouched,
+	 * but, as we don't know the scale returned by the counters, let's
+	 * at least preserver BER = bit_error/bit_count.
+	 */
 	if (period_exp >= 4) {
-		div = (1U << (period_exp - 4)) * (n_ldpc / 200);
-		q = div_u64_rem(3125ULL * bit_err, div, &r);
+		*bit_count = (1U << (period_exp - 4)) * (n_ldpc / 200);
+		*bit_error *= 3125ULL;
 	} else {
-		div = (1U << period_exp) * (n_ldpc / 200);
-		q = div_u64_rem(50000ULL * bit_err, div, &r);
+		*bit_count = (1U << period_exp) * (n_ldpc / 200);
+		*bit_error *= 50000ULL;;
 	}
-	*ber = (r >= div / 2) ? q + 1 : q;
 	return 0;
 }
 
-static int cxd2841er_read_ber_t(struct cxd2841er_priv *priv, u32 *ber)
+static int cxd2841er_read_ber_t(struct cxd2841er_priv *priv,
+				u32 *bit_error, u32 *bit_count)
 {
 	u8 data[2];
-	u32 div, q, r;
-	u32 bit_err, period;
+	u32 period;
 
-	*ber = 0;
 	if (priv->state != STATE_ACTIVE_TC) {
 		dev_dbg(&priv->i2c->dev,
 			"%s(): invalid state %d\n", __func__, priv->state);
@@ -1503,12 +1485,17 @@ static int cxd2841er_read_ber_t(struct cxd2841er_priv *priv, u32 *ber)
 		return 0;
 	}
 	cxd2841er_read_regs(priv, I2C_SLVT, 0x22, data, sizeof(data));
-	bit_err = ((u32)data[0] << 8) | (u32)data[1];
+	*bit_error = ((u32)data[0] << 8) | (u32)data[1];
 	cxd2841er_read_reg(priv, I2C_SLVT, 0x6f, data);
 	period = ((data[0] & 0x07) == 0) ? 256 : (4096 << (data[0] & 0x07));
-	div = period / 128;
-	q = div_u64_rem(78125ULL * bit_err, div, &r);
-	*ber = (r >= div / 2) ? q + 1 : q;
+
+	/*
+	 * FIXME: the right thing would be to return bit_error untouched,
+	 * but, as we don't know the scale returned by the counters, let's
+	 * at least preserver BER = bit_error/bit_count.
+	 */
+	*bit_count = period / 128;
+	*bit_error *= 78125ULL;
 	return 0;
 }
 
@@ -1707,32 +1694,36 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
-	u32 ber = 0, ret;
+	u32 ret, bit_error = 0, bit_count = 0;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
 	case SYS_DVBS:
-		ret = cxd2841er_mon_read_ber_s(priv, &ber);
+		ret = cxd2841er_mon_read_ber_s(priv, &bit_error, &bit_count);
 		break;
 	case SYS_DVBS2:
-		ret = cxd2841er_mon_read_ber_s2(priv, &ber);
+		ret = cxd2841er_mon_read_ber_s2(priv, &bit_error, &bit_count);
 		break;
 	case SYS_DVBT:
-		ret = cxd2841er_read_ber_t(priv, &ber);
+		ret = cxd2841er_read_ber_t(priv, &bit_error, &bit_count);
 		break;
 	case SYS_DVBT2:
-		ret = cxd2841er_read_ber_t2(priv, &ber);
+		ret = cxd2841er_read_ber_t2(priv, &bit_error, &bit_count);
 		break;
 	default:
 		p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		return;
 	}
 
 	if (!ret) {
 		p->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		p->post_bit_error.stat[0].uvalue = ber;
+		p->post_bit_error.stat[0].uvalue = bit_error;
+		p->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		p->post_bit_count.stat[0].uvalue = bit_count;
 	} else {
 		p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 }
 
@@ -2971,6 +2962,7 @@ static int cxd2841er_get_frontend(struct dvb_frontend *fe,
 		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 	return 0;
 }
@@ -3035,6 +3027,7 @@ done:
 	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
 	return ret;
 }
@@ -3409,6 +3402,8 @@ static void cxd2841er_init_stats(struct dvb_frontend *fe)
 	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	p->post_bit_error.len = 1;
 	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_count.len = 1;
+	p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 }
 
 
-- 
2.7.4

