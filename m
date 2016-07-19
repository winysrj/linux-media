Return-path: <linux-media-owner@vger.kernel.org>
Received: from 108-197-250-228.lightspeed.miamfl.sbcglobal.net ([108.197.250.228]:48752
	"EHLO usa.attlocal.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751244AbcGSDK0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 23:10:26 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] [media] cxd2841er: freeze/unfreeze registers when reading stats
Date: Mon, 18 Jul 2016 23:10:20 -0400
Message-Id: <1468897820-28556-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ensure multiple separate register reads are from the same snapshot

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb-frontends/cxd2841er.c | 52 +++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 09c3934..d2e28ea 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -1570,6 +1570,25 @@ static int cxd2841er_read_ber_t(struct cxd2841er_priv *priv,
 	return 0;
 }
 
+static int cxd2841er_freeze_regs(struct cxd2841er_priv *priv)
+{
+	/*
+	 * Freeze registers: ensure multiple separate register reads
+	 * are from the same snapshot
+	 */
+	cxd2841er_write_reg(priv, I2C_SLVT, 0x01, 0x01);
+	return 0;
+}
+
+static int cxd2841er_unfreeze_regs(struct cxd2841er_priv *priv)
+{
+	/*
+	 * un-freeze registers
+	 */
+	cxd2841er_write_reg(priv, I2C_SLVT, 0x01, 0x00);
+	return 0;
+}
+
 static u32 cxd2841er_dvbs_read_snr(struct cxd2841er_priv *priv,
 		u8 delsys, u32 *snr)
 {
@@ -1578,6 +1597,7 @@ static u32 cxd2841er_dvbs_read_snr(struct cxd2841er_priv *priv,
 	int min_index, max_index, index;
 	static const struct cxd2841er_cnr_data *cn_data;
 
+	cxd2841er_freeze_regs(priv);
 	/* Set SLV-T Bank : 0xA1 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0xa1);
 	/*
@@ -1629,9 +1649,11 @@ static u32 cxd2841er_dvbs_read_snr(struct cxd2841er_priv *priv,
 	} else {
 		dev_dbg(&priv->i2c->dev,
 			"%s(): no data available\n", __func__);
+		cxd2841er_unfreeze_regs(priv);
 		return -EINVAL;
 	}
 done:
+	cxd2841er_unfreeze_regs(priv);
 	*snr = res;
 	return 0;
 }
@@ -1655,12 +1677,7 @@ static int cxd2841er_read_snr_c(struct cxd2841er_priv *priv, u32 *snr)
 		return -EINVAL;
 	}
 
-	/*
-	 * Freeze registers: ensure multiple separate register reads
-	 * are from the same snapshot
-	 */
-	cxd2841er_write_reg(priv, I2C_SLVT, 0x01, 0x01);
-
+	cxd2841er_freeze_regs(priv);
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x40);
 	cxd2841er_read_regs(priv, I2C_SLVT, 0x19, data, 1);
 	qam = (enum sony_dvbc_constellation_t) (data[0] & 0x07);
@@ -1670,6 +1687,7 @@ static int cxd2841er_read_snr_c(struct cxd2841er_priv *priv, u32 *snr)
 	if (reg == 0) {
 		dev_dbg(&priv->i2c->dev,
 				"%s(): reg value out of range\n", __func__);
+		cxd2841er_unfreeze_regs(priv);
 		return 0;
 	}
 
@@ -1690,9 +1708,11 @@ static int cxd2841er_read_snr_c(struct cxd2841er_priv *priv, u32 *snr)
 		*snr = -88 * (int32_t)sony_log(reg) + 86999;
 		break;
 	default:
+		cxd2841er_unfreeze_regs(priv);
 		return -EINVAL;
 	}
 
+	cxd2841er_unfreeze_regs(priv);
 	return 0;
 }
 
@@ -1707,17 +1727,21 @@ static int cxd2841er_read_snr_t(struct cxd2841er_priv *priv, u32 *snr)
 			"%s(): invalid state %d\n", __func__, priv->state);
 		return -EINVAL;
 	}
+
+	cxd2841er_freeze_regs(priv);
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x10);
 	cxd2841er_read_regs(priv, I2C_SLVT, 0x28, data, sizeof(data));
 	reg = ((u32)data[0] << 8) | (u32)data[1];
 	if (reg == 0) {
 		dev_dbg(&priv->i2c->dev,
 			"%s(): reg value out of range\n", __func__);
+		cxd2841er_unfreeze_regs(priv);
 		return 0;
 	}
 	if (reg > 4996)
 		reg = 4996;
 	*snr = 10000 * ((intlog10(reg) - intlog10(5350 - reg)) >> 24) + 28500;
+	cxd2841er_unfreeze_regs(priv);
 	return 0;
 }
 
@@ -1732,18 +1756,22 @@ static int cxd2841er_read_snr_t2(struct cxd2841er_priv *priv, u32 *snr)
 			"%s(): invalid state %d\n", __func__, priv->state);
 		return -EINVAL;
 	}
+
+	cxd2841er_freeze_regs(priv);
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x20);
 	cxd2841er_read_regs(priv, I2C_SLVT, 0x28, data, sizeof(data));
 	reg = ((u32)data[0] << 8) | (u32)data[1];
 	if (reg == 0) {
 		dev_dbg(&priv->i2c->dev,
 			"%s(): reg value out of range\n", __func__);
+		cxd2841er_unfreeze_regs(priv);
 		return 0;
 	}
 	if (reg > 10876)
 		reg = 10876;
 	*snr = 10000 * ((intlog10(reg) -
 		intlog10(12600 - reg)) >> 24) + 32000;
+	cxd2841er_unfreeze_regs(priv);
 	return 0;
 }
 
@@ -1760,21 +1788,20 @@ static int cxd2841er_read_snr_i(struct cxd2841er_priv *priv, u32 *snr)
 		return -EINVAL;
 	}
 
-	/* Freeze all registers */
-	cxd2841er_write_reg(priv, I2C_SLVT, 0x01, 0x01);
-
-
+	cxd2841er_freeze_regs(priv);
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x60);
 	cxd2841er_read_regs(priv, I2C_SLVT, 0x28, data, sizeof(data));
 	reg = ((u32)data[0] << 8) | (u32)data[1];
 	if (reg == 0) {
 		dev_dbg(&priv->i2c->dev,
 				"%s(): reg value out of range\n", __func__);
+		cxd2841er_unfreeze_regs(priv);
 		return 0;
 	}
 	if (reg > 4996)
 		reg = 4996;
 	*snr = 100 * intlog10(reg) - 9031;
+	cxd2841er_unfreeze_regs(priv);
 	return 0;
 }
 
@@ -1977,7 +2004,7 @@ static void cxd2841er_read_ucblocks(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
-	u32 ucblocks;
+	u32 ucblocks = 0;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
@@ -1999,7 +2026,7 @@ static void cxd2841er_read_ucblocks(struct dvb_frontend *fe)
 		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		return;
 	}
-	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
+	dev_dbg(&priv->i2c->dev, "%s() ucblocks=%u\n", __func__, ucblocks);
 
 	p->block_error.stat[0].scale = FE_SCALE_COUNTER;
 	p->block_error.stat[0].uvalue = ucblocks;
@@ -3076,6 +3103,7 @@ static int cxd2841er_sleep_tc_to_active_c(struct cxd2841er_priv *priv,
 	/* Enable demod clock */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x2c, 0x01);
 	/* Disable RF level monitor */
+	cxd2841er_write_reg(priv, I2C_SLVT, 0x59, 0x00);
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x2f, 0x00);
 	/* Enable ADC clock */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x30, 0x00);
-- 
2.7.4

