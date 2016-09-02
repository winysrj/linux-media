Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56567 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753958AbcIBWht (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 18:37:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/9] cxd2820r: wrap legacy DVBv3 statistics via DVBv5 statistics
Date: Sat,  3 Sep 2016 01:37:20 +0300
Message-Id: <1472855844-8665-5-git-send-email-crope@iki.fi>
In-Reply-To: <1472855844-8665-1-git-send-email-crope@iki.fi>
References: <1472855844-8665-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return DVBv5 statistics via legacy DVBv3 API.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r_c.c    | 108 ----------------------------
 drivers/media/dvb-frontends/cxd2820r_core.c |  85 ++++++----------------
 drivers/media/dvb-frontends/cxd2820r_priv.h |  25 +------
 drivers/media/dvb-frontends/cxd2820r_t.c    |  94 ------------------------
 drivers/media/dvb-frontends/cxd2820r_t2.c   |  87 ----------------------
 5 files changed, 22 insertions(+), 377 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index 7cdcd55..82df944 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -149,114 +149,6 @@ error:
 	return ret;
 }
 
-int cxd2820r_read_ber_c(struct dvb_frontend *fe, u32 *ber)
-{
-	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
-	u8 buf[3], start_ber = 0;
-	*ber = 0;
-
-	if (priv->ber_running) {
-		ret = cxd2820r_rd_regs(priv, 0x10076, buf, sizeof(buf));
-		if (ret)
-			goto error;
-
-		if ((buf[2] >> 7) & 0x01 || (buf[2] >> 4) & 0x01) {
-			*ber = (buf[2] & 0x0f) << 16 | buf[1] << 8 | buf[0];
-			start_ber = 1;
-		}
-	} else {
-		priv->ber_running = true;
-		start_ber = 1;
-	}
-
-	if (start_ber) {
-		/* (re)start BER */
-		ret = cxd2820r_wr_reg(priv, 0x10079, 0x01);
-		if (ret)
-			goto error;
-	}
-
-	return ret;
-error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-int cxd2820r_read_signal_strength_c(struct dvb_frontend *fe,
-	u16 *strength)
-{
-	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
-	u8 buf[2];
-	u16 tmp;
-
-	ret = cxd2820r_rd_regs(priv, 0x10049, buf, sizeof(buf));
-	if (ret)
-		goto error;
-
-	tmp = (buf[0] & 0x03) << 8 | buf[1];
-	tmp = (~tmp & 0x03ff);
-
-	if (tmp == 512)
-		/* ~no signal */
-		tmp = 0;
-	else if (tmp > 350)
-		tmp = 350;
-
-	/* scale value to 0x0000-0xffff */
-	*strength = tmp * 0xffff / (350-0);
-
-	return ret;
-error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-int cxd2820r_read_snr_c(struct dvb_frontend *fe, u16 *snr)
-{
-	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
-	u8 tmp;
-	unsigned int A, B;
-	/* report SNR in dB * 10 */
-
-	ret = cxd2820r_rd_reg(priv, 0x10019, &tmp);
-	if (ret)
-		goto error;
-
-	if (((tmp >> 0) & 0x03) % 2) {
-		A = 875;
-		B = 650;
-	} else {
-		A = 950;
-		B = 760;
-	}
-
-	ret = cxd2820r_rd_reg(priv, 0x1004d, &tmp);
-	if (ret)
-		goto error;
-
-	#define CXD2820R_LOG2_E_24 24204406 /* log2(e) << 24 */
-	if (tmp)
-		*snr = A * (intlog2(B / tmp) >> 5) / (CXD2820R_LOG2_E_24 >> 5)
-			/ 10;
-	else
-		*snr = 0;
-
-	return ret;
-error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-int cxd2820r_read_ucblocks_c(struct dvb_frontend *fe, u32 *ucblocks)
-{
-	*ucblocks = 0;
-	/* no way to read ? */
-	return 0;
-}
-
 int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 314d3b8..66da821 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -345,101 +345,58 @@ static int cxd2820r_get_frontend(struct dvb_frontend *fe,
 static int cxd2820r_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
 
 	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
 			fe->dtv_property_cache.delivery_system);
 
-	switch (fe->dtv_property_cache.delivery_system) {
-	case SYS_DVBT:
-		ret = cxd2820r_read_ber_t(fe, ber);
-		break;
-	case SYS_DVBT2:
-		ret = cxd2820r_read_ber_t2(fe, ber);
-		break;
-	case SYS_DVBC_ANNEX_A:
-		ret = cxd2820r_read_ber_c(fe, ber);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	return ret;
+	*ber = (priv->post_bit_error - priv->post_bit_error_prev_dvbv3);
+	priv->post_bit_error_prev_dvbv3 = priv->post_bit_error;
+
+	return 0;
 }
 
 static int cxd2820r_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
 	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
 			fe->dtv_property_cache.delivery_system);
 
-	switch (fe->dtv_property_cache.delivery_system) {
-	case SYS_DVBT:
-		ret = cxd2820r_read_signal_strength_t(fe, strength);
-		break;
-	case SYS_DVBT2:
-		ret = cxd2820r_read_signal_strength_t2(fe, strength);
-		break;
-	case SYS_DVBC_ANNEX_A:
-		ret = cxd2820r_read_signal_strength_c(fe, strength);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	return ret;
+	if (c->strength.stat[0].scale == FE_SCALE_RELATIVE)
+		*strength = c->strength.stat[0].uvalue;
+	else
+		*strength = 0;
+
+	return 0;
 }
 
 static int cxd2820r_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
 	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
 			fe->dtv_property_cache.delivery_system);
 
-	switch (fe->dtv_property_cache.delivery_system) {
-	case SYS_DVBT:
-		ret = cxd2820r_read_snr_t(fe, snr);
-		break;
-	case SYS_DVBT2:
-		ret = cxd2820r_read_snr_t2(fe, snr);
-		break;
-	case SYS_DVBC_ANNEX_A:
-		ret = cxd2820r_read_snr_c(fe, snr);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	return ret;
+	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
+		*snr = div_s64(c->cnr.stat[0].svalue, 100);
+	else
+		*snr = 0;
+
+	return 0;
 }
 
 static int cxd2820r_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
 
 	dev_dbg(&priv->i2c->dev, "%s: delsys=%d\n", __func__,
 			fe->dtv_property_cache.delivery_system);
 
-	switch (fe->dtv_property_cache.delivery_system) {
-	case SYS_DVBT:
-		ret = cxd2820r_read_ucblocks_t(fe, ucblocks);
-		break;
-	case SYS_DVBT2:
-		ret = cxd2820r_read_ucblocks_t2(fe, ucblocks);
-		break;
-	case SYS_DVBC_ANNEX_A:
-		ret = cxd2820r_read_ucblocks_c(fe, ucblocks);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	return ret;
+	*ucblocks = 0;
+
+	return 0;
 }
 
 static int cxd2820r_init(struct dvb_frontend *fe)
diff --git a/drivers/media/dvb-frontends/cxd2820r_priv.h b/drivers/media/dvb-frontends/cxd2820r_priv.h
index a97570b..66b19dd 100644
--- a/drivers/media/dvb-frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb-frontends/cxd2820r_priv.h
@@ -41,6 +41,7 @@ struct cxd2820r_priv {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
 	struct cxd2820r_config cfg;
+	u64 post_bit_error_prev_dvbv3;
 	u64 post_bit_error;
 
 	bool ber_running;
@@ -87,14 +88,6 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe);
 
 int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status);
 
-int cxd2820r_read_ber_c(struct dvb_frontend *fe, u32 *ber);
-
-int cxd2820r_read_signal_strength_c(struct dvb_frontend *fe, u16 *strength);
-
-int cxd2820r_read_snr_c(struct dvb_frontend *fe, u16 *snr);
-
-int cxd2820r_read_ucblocks_c(struct dvb_frontend *fe, u32 *ucblocks);
-
 int cxd2820r_init_c(struct dvb_frontend *fe);
 
 int cxd2820r_sleep_c(struct dvb_frontend *fe);
@@ -111,14 +104,6 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe);
 
 int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status);
 
-int cxd2820r_read_ber_t(struct dvb_frontend *fe, u32 *ber);
-
-int cxd2820r_read_signal_strength_t(struct dvb_frontend *fe, u16 *strength);
-
-int cxd2820r_read_snr_t(struct dvb_frontend *fe, u16 *snr);
-
-int cxd2820r_read_ucblocks_t(struct dvb_frontend *fe, u32 *ucblocks);
-
 int cxd2820r_init_t(struct dvb_frontend *fe);
 
 int cxd2820r_sleep_t(struct dvb_frontend *fe);
@@ -135,14 +120,6 @@ int cxd2820r_set_frontend_t2(struct dvb_frontend *fe);
 
 int cxd2820r_read_status_t2(struct dvb_frontend *fe, enum fe_status *status);
 
-int cxd2820r_read_ber_t2(struct dvb_frontend *fe, u32 *ber);
-
-int cxd2820r_read_signal_strength_t2(struct dvb_frontend *fe, u16 *strength);
-
-int cxd2820r_read_snr_t2(struct dvb_frontend *fe, u16 *snr);
-
-int cxd2820r_read_ucblocks_t2(struct dvb_frontend *fe, u32 *ucblocks);
-
 int cxd2820r_init_t2(struct dvb_frontend *fe);
 
 int cxd2820r_sleep_t2(struct dvb_frontend *fe);
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index d402ab6..ddd8e46 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -254,100 +254,6 @@ error:
 	return ret;
 }
 
-int cxd2820r_read_ber_t(struct dvb_frontend *fe, u32 *ber)
-{
-	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
-	u8 buf[3], start_ber = 0;
-	*ber = 0;
-
-	if (priv->ber_running) {
-		ret = cxd2820r_rd_regs(priv, 0x00076, buf, sizeof(buf));
-		if (ret)
-			goto error;
-
-		if ((buf[2] >> 7) & 0x01 || (buf[2] >> 4) & 0x01) {
-			*ber = (buf[2] & 0x0f) << 16 | buf[1] << 8 | buf[0];
-			start_ber = 1;
-		}
-	} else {
-		priv->ber_running = true;
-		start_ber = 1;
-	}
-
-	if (start_ber) {
-		/* (re)start BER */
-		ret = cxd2820r_wr_reg(priv, 0x00079, 0x01);
-		if (ret)
-			goto error;
-	}
-
-	return ret;
-error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-int cxd2820r_read_signal_strength_t(struct dvb_frontend *fe,
-	u16 *strength)
-{
-	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
-	u8 buf[2];
-	u16 tmp;
-
-	ret = cxd2820r_rd_regs(priv, 0x00026, buf, sizeof(buf));
-	if (ret)
-		goto error;
-
-	tmp = (buf[0] & 0x0f) << 8 | buf[1];
-	tmp = ~tmp & 0x0fff;
-
-	/* scale value to 0x0000-0xffff from 0x0000-0x0fff */
-	*strength = tmp * 0xffff / 0x0fff;
-
-	return ret;
-error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-int cxd2820r_read_snr_t(struct dvb_frontend *fe, u16 *snr)
-{
-	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
-	u8 buf[2];
-	u16 tmp;
-	/* report SNR in dB * 10 */
-
-	ret = cxd2820r_rd_regs(priv, 0x00028, buf, sizeof(buf));
-	if (ret)
-		goto error;
-
-	tmp = (buf[0] & 0x1f) << 8 | buf[1];
-	#define CXD2820R_LOG10_8_24 15151336 /* log10(8) << 24 */
-	if (tmp)
-		*snr = (intlog10(tmp) - CXD2820R_LOG10_8_24) / ((1 << 24)
-			/ 100);
-	else
-		*snr = 0;
-
-	dev_dbg(&priv->i2c->dev, "%s: dBx10=%d val=%04x\n", __func__, *snr,
-			tmp);
-
-	return ret;
-error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-int cxd2820r_read_ucblocks_t(struct dvb_frontend *fe, u32 *ucblocks)
-{
-	*ucblocks = 0;
-	/* no way to read ? */
-	return 0;
-}
-
 int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index e2875f2..e09f152 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -387,93 +387,6 @@ error:
 	return ret;
 }
 
-int cxd2820r_read_ber_t2(struct dvb_frontend *fe, u32 *ber)
-{
-	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
-	u8 buf[4];
-	unsigned int errbits;
-	*ber = 0;
-	/* FIXME: correct calculation */
-
-	ret = cxd2820r_rd_regs(priv, 0x02039, buf, sizeof(buf));
-	if (ret)
-		goto error;
-
-	if ((buf[0] >> 4) & 0x01) {
-		errbits = (buf[0] & 0x0f) << 24 | buf[1] << 16 |
-			buf[2] << 8 | buf[3];
-
-		if (errbits)
-			*ber = errbits * 64 / 16588800;
-	}
-
-	return ret;
-error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-int cxd2820r_read_signal_strength_t2(struct dvb_frontend *fe,
-	u16 *strength)
-{
-	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
-	u8 buf[2];
-	u16 tmp;
-
-	ret = cxd2820r_rd_regs(priv, 0x02026, buf, sizeof(buf));
-	if (ret)
-		goto error;
-
-	tmp = (buf[0] & 0x0f) << 8 | buf[1];
-	tmp = ~tmp & 0x0fff;
-
-	/* scale value to 0x0000-0xffff from 0x0000-0x0fff */
-	*strength = tmp * 0xffff / 0x0fff;
-
-	return ret;
-error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-int cxd2820r_read_snr_t2(struct dvb_frontend *fe, u16 *snr)
-{
-	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	int ret;
-	u8 buf[2];
-	u16 tmp;
-	/* report SNR in dB * 10 */
-
-	ret = cxd2820r_rd_regs(priv, 0x02028, buf, sizeof(buf));
-	if (ret)
-		goto error;
-
-	tmp = (buf[0] & 0x0f) << 8 | buf[1];
-	#define CXD2820R_LOG10_8_24 15151336 /* log10(8) << 24 */
-	if (tmp)
-		*snr = (intlog10(tmp) - CXD2820R_LOG10_8_24) / ((1 << 24)
-			/ 100);
-	else
-		*snr = 0;
-
-	dev_dbg(&priv->i2c->dev, "%s: dBx10=%d val=%04x\n", __func__, *snr,
-			tmp);
-
-	return ret;
-error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-int cxd2820r_read_ucblocks_t2(struct dvb_frontend *fe, u32 *ucblocks)
-{
-	*ucblocks = 0;
-	/* no way to read ? */
-	return 0;
-}
-
 int cxd2820r_sleep_t2(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-- 
http://palosaari.fi/

