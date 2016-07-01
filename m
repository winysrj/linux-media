Return-path: <linux-media-owner@vger.kernel.org>
Received: from 108-197-250-228.lightspeed.miamfl.sbcglobal.net ([108.197.250.228]:41962
	"EHLO usa.attlocal.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751959AbcGACT3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 22:19:29 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] [media][cxd2841er] DVB-C read signal strength added for Sony demod
Date: Thu, 30 Jun 2016 22:09:48 -0400
Message-Id: <1467338988-2911-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cxd2841er_read_agc_gain_c added to obtain signal strength.
signal strength now relay on AGC value.

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb-frontends/cxd2841er.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index ef6421c..8705b0a 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -1656,6 +1656,21 @@ static int cxd2841er_read_snr_i(struct cxd2841er_priv *priv, u32 *snr)
 	return 0;
 }
 
+static u16 cxd2841er_read_agc_gain_c(struct cxd2841er_priv *priv,
+					u8 delsys)
+{
+	u8 data[2];
+
+	cxd2841er_write_reg(
+		priv, I2C_SLVT, 0x00, 0x40);
+	cxd2841er_read_regs(priv, I2C_SLVT, 0x49, data, 2);
+	dev_dbg(&priv->i2c->dev,
+			"%s(): AGC value=%u\n",
+			__func__, (((u16)data[0] & 0x0F) << 8) |
+			(u16)(data[1] & 0xFF));
+	return ((((u16)data[0] & 0x0F) << 8) | (u16)(data[1] & 0xFF)) << 4;
+}
+
 static u16 cxd2841er_read_agc_gain_t_t2(struct cxd2841er_priv *priv,
 					u8 delsys)
 {
@@ -1735,6 +1750,14 @@ static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_B:
+	case SYS_DVBC_ANNEX_C:
+		strength = 65535 - cxd2841er_read_agc_gain_c(
+				priv, p->delivery_system);
+		p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		p->strength.stat[0].uvalue = strength;
+		break;
 	case SYS_DVBT:
 	case SYS_DVBT2:
 		strength = cxd2841er_read_agc_gain_t_t2(priv,
-- 
2.7.4

