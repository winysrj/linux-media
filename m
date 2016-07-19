Return-path: <linux-media-owner@vger.kernel.org>
Received: from 108-197-250-228.lightspeed.miamfl.sbcglobal.net ([108.197.250.228]:48762
	"EHLO usa.attlocal.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753532AbcGSPWK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 11:22:10 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] [media] cxd2841er: BER and SNR reading for ISDB-T
Date: Tue, 19 Jul 2016 11:22:03 -0400
Message-Id: <1468941723-19263-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added function to read BER for ISDB-T
Also SNR values fixed for ISDB-T

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb-frontends/cxd2841er.c | 48 ++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index d2e28ea..3df0604 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -206,6 +206,9 @@ static const struct cxd2841er_cnr_data s2_cn_data[] = {
 		(u32)(((iffreq)/48.0)*16777216.0 + 0.5) : \
 		(u32)(((iffreq)/41.0)*16777216.0 + 0.5))
 
+static int cxd2841er_freeze_regs(struct cxd2841er_priv *priv);
+static int cxd2841er_unfreeze_regs(struct cxd2841er_priv *priv);
+
 static void cxd2841er_i2c_debug(struct cxd2841er_priv *priv,
 				u8 addr, u8 reg, u8 write,
 				const u8 *data, u32 len)
@@ -1401,6 +1404,41 @@ static int cxd2841er_read_ber_c(struct cxd2841er_priv *priv,
 	return 0;
 }
 
+static int cxd2841er_read_ber_i(struct cxd2841er_priv *priv,
+		u32 *bit_error, u32 *bit_count)
+{
+	u8 data[3];
+	u8 pktnum[2];
+
+	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
+	if (priv->state != STATE_ACTIVE_TC) {
+		dev_dbg(&priv->i2c->dev, "%s(): invalid state %d\n",
+				__func__, priv->state);
+		return -EINVAL;
+	}
+
+	cxd2841er_freeze_regs(priv);
+	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x60);
+	cxd2841er_read_regs(priv, I2C_SLVT, 0x5B, pktnum, sizeof(pktnum));
+	cxd2841er_read_regs(priv, I2C_SLVT, 0x16, data, sizeof(data));
+
+	if (!pktnum[0] && !pktnum[1]) {
+		dev_dbg(&priv->i2c->dev,
+				"%s(): no valid BER data\n", __func__);
+		cxd2841er_unfreeze_regs(priv);
+		return -EINVAL;
+	}
+
+	*bit_error = ((u32)(data[0] & 0x7F) << 16) |
+		((u32)data[1] << 8) | data[2];
+	*bit_count = ((((u32)pktnum[0] << 8) | pktnum[1]) * 204 * 8);
+	dev_dbg(&priv->i2c->dev, "%s(): bit_error=%u bit_count=%u\n",
+			__func__, *bit_error, *bit_count);
+
+	cxd2841er_unfreeze_regs(priv);
+	return 0;
+}
+
 static int cxd2841er_mon_read_ber_s(struct cxd2841er_priv *priv,
 				    u32 *bit_error, u32 *bit_count)
 {
@@ -1798,9 +1836,7 @@ static int cxd2841er_read_snr_i(struct cxd2841er_priv *priv, u32 *snr)
 		cxd2841er_unfreeze_regs(priv);
 		return 0;
 	}
-	if (reg > 4996)
-		reg = 4996;
-	*snr = 100 * intlog10(reg) - 9031;
+	*snr = 10000 * (intlog10(reg) >> 24) - 9031;
 	cxd2841er_unfreeze_regs(priv);
 	return 0;
 }
@@ -1879,6 +1915,9 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
 	case SYS_DVBC_ANNEX_C:
 		ret = cxd2841er_read_ber_c(priv, &bit_error, &bit_count);
 		break;
+	case SYS_ISDBT:
+		ret = cxd2841er_read_ber_i(priv, &bit_error, &bit_count);
+		break;
 	case SYS_DVBS:
 		ret = cxd2841er_mon_read_ber_s(priv, &bit_error, &bit_count);
 		break;
@@ -1992,6 +2031,9 @@ static void cxd2841er_read_snr(struct dvb_frontend *fe)
 		return;
 	}
 
+	dev_dbg(&priv->i2c->dev, "%s(): snr=%d\n",
+			__func__, (int32_t)tmp);
+
 	if (!ret) {
 		p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 		p->cnr.stat[0].svalue = tmp;
-- 
2.7.4

