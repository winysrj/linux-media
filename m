Return-path: <linux-media-owner@vger.kernel.org>
Received: from 108-197-250-228.lightspeed.miamfl.sbcglobal.net ([108.197.250.228]:53278
	"EHLO usa.attlocal.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751709AbcGOUWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 16:22:08 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH 3/3] [media] cxd2841er: Reading SNR for DVB-C added
Date: Fri, 15 Jul 2016 16:21:46 -0400
Message-Id: <1468614106-2711-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

now driver returns correct values for DVB-C:
 SNR (in dB)

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb-frontends/cxd2841er.c | 89 ++++++++++++++++++++++++++++++---
 1 file changed, 81 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 623b04f3..99baccf 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -1570,7 +1570,8 @@ static int cxd2841er_read_ber_t(struct cxd2841er_priv *priv,
 	return 0;
 }
 
-static u32 cxd2841er_dvbs_read_snr(struct cxd2841er_priv *priv, u8 delsys)
+static u32 cxd2841er_dvbs_read_snr(struct cxd2841er_priv *priv,
+		u8 delsys, u32 *snr)
 {
 	u8 data[3];
 	u32 res = 0, value;
@@ -1628,9 +1629,71 @@ static u32 cxd2841er_dvbs_read_snr(struct cxd2841er_priv *priv, u8 delsys)
 	} else {
 		dev_dbg(&priv->i2c->dev,
 			"%s(): no data available\n", __func__);
+		return -EINVAL;
 	}
 done:
-	return res;
+	*snr = res;
+	return 0;
+}
+
+uint32_t sony_log(uint32_t x)
+{
+	return (((10000>>8)*(intlog2(x)>>16) + LOG2_E_100X/2)/LOG2_E_100X);
+}
+
+static int cxd2841er_read_snr_c(struct cxd2841er_priv *priv, u32 *snr)
+{
+	u32 reg;
+	u8 data[2];
+	enum sony_dvbc_constellation_t qam = SONY_DVBC_CONSTELLATION_16QAM;
+
+	*snr = 0;
+	if (priv->state != STATE_ACTIVE_TC) {
+		dev_dbg(&priv->i2c->dev,
+				"%s(): invalid state %d\n",
+				__func__, priv->state);
+		return -EINVAL;
+	}
+
+	/*
+	 * Freeze registers: ensure multiple separate register reads
+	 * are from the same snapshot
+	 */
+	cxd2841er_write_reg(priv, I2C_SLVT, 0x01, 0x01);
+
+	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x40);
+	cxd2841er_read_regs(priv, I2C_SLVT, 0x19, data, 1);
+	qam = (enum sony_dvbc_constellation_t) (data[0] & 0x07);
+	cxd2841er_read_regs(priv, I2C_SLVT, 0x4C, data, 2);
+
+	reg = ((u32)(data[0]&0x1f) << 8) | (u32)data[1];
+	if (reg == 0) {
+		dev_dbg(&priv->i2c->dev,
+				"%s(): reg value out of range\n", __func__);
+		return 0;
+	}
+
+	switch (qam) {
+	case SONY_DVBC_CONSTELLATION_16QAM:
+	case SONY_DVBC_CONSTELLATION_64QAM:
+	case SONY_DVBC_CONSTELLATION_256QAM:
+		/* SNR(dB) = -9.50 * ln(IREG_SNR_ESTIMATE / (24320)) */
+		if (reg < 126)
+			reg = 126;
+		*snr = -95 * (int32_t)sony_log(reg) + 95941;
+		break;
+	case SONY_DVBC_CONSTELLATION_32QAM:
+	case SONY_DVBC_CONSTELLATION_128QAM:
+		/* SNR(dB) = -8.75 * ln(IREG_SNR_ESTIMATE / (20800)) */
+		if (reg < 69)
+			reg = 69;
+		*snr = -88 * (int32_t)sony_log(reg) + 86999;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static int cxd2841er_read_snr_t(struct cxd2841er_priv *priv, u32 *snr)
@@ -1871,23 +1934,29 @@ static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
 static void cxd2841er_read_snr(struct dvb_frontend *fe)
 {
 	u32 tmp = 0;
+	int ret = 0;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_B:
+	case SYS_DVBC_ANNEX_C:
+		ret = cxd2841er_read_snr_c(priv, &tmp);
+		break;
 	case SYS_DVBT:
-		cxd2841er_read_snr_t(priv, &tmp);
+		ret = cxd2841er_read_snr_t(priv, &tmp);
 		break;
 	case SYS_DVBT2:
-		cxd2841er_read_snr_t2(priv, &tmp);
+		ret = cxd2841er_read_snr_t2(priv, &tmp);
 		break;
 	case SYS_ISDBT:
-		cxd2841er_read_snr_i(priv, &tmp);
+		ret = cxd2841er_read_snr_i(priv, &tmp);
 		break;
 	case SYS_DVBS:
 	case SYS_DVBS2:
-		tmp = cxd2841er_dvbs_read_snr(priv, p->delivery_system);
+		ret = cxd2841er_dvbs_read_snr(priv, p->delivery_system, &tmp);
 		break;
 	default:
 		dev_dbg(&priv->i2c->dev, "%s(): unknown delivery system %d\n",
@@ -1896,8 +1965,12 @@ static void cxd2841er_read_snr(struct dvb_frontend *fe)
 		return;
 	}
 
-	p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-	p->cnr.stat[0].svalue = tmp;
+	if (!ret) {
+		p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		p->cnr.stat[0].svalue = tmp;
+	} else {
+		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
 }
 
 static void cxd2841er_read_ucblocks(struct dvb_frontend *fe)
-- 
2.7.4

