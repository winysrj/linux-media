Return-path: <linux-media-owner@vger.kernel.org>
Received: from 108-197-250-228.lightspeed.miamfl.sbcglobal.net ([108.197.250.228]:53272
	"EHLO usa.attlocal.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751610AbcGOUVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 16:21:49 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH 2/3] [media] cxd2841er: Reading BER and UCB for DVB-C added
Date: Fri, 15 Jul 2016 16:21:40 -0400
Message-Id: <1468614100-2664-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

now driver returns correct values for DVB-C:
 BER (post_bit_count and post_bit_error values)
 UCB (count of uncorrected errors)
also, some code cleanup was done - checkpatch.pl now is happy

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb-frontends/cxd2841er.c | 87 +++++++++++++++++++++++++++++++--
 1 file changed, 84 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index b2bfbaa..623b04f3 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -36,6 +36,16 @@
 #include "cxd2841er_priv.h"
 
 #define MAX_WRITE_REGSIZE	16
+#define LOG2_E_100X 144
+
+/* DVB-C constellation */
+enum sony_dvbc_constellation_t {
+	SONY_DVBC_CONSTELLATION_16QAM,
+	SONY_DVBC_CONSTELLATION_32QAM,
+	SONY_DVBC_CONSTELLATION_64QAM,
+	SONY_DVBC_CONSTELLATION_128QAM,
+	SONY_DVBC_CONSTELLATION_256QAM
+};
 
 enum cxd2841er_state {
 	STATE_SHUTDOWN = 0,
@@ -1262,6 +1272,24 @@ static int cxd2841er_get_carrier_offset_c(struct cxd2841er_priv *priv,
 	return 0;
 }
 
+static int cxd2841er_read_packet_errors_c(
+		struct cxd2841er_priv *priv, u32 *penum)
+{
+	u8 data[3];
+
+	*penum = 0;
+	if (priv->state != STATE_ACTIVE_TC) {
+		dev_dbg(&priv->i2c->dev, "%s(): invalid state %d\n",
+				__func__, priv->state);
+		return -EINVAL;
+	}
+	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x40);
+	cxd2841er_read_regs(priv, I2C_SLVT, 0xea, data, sizeof(data));
+	if (data[2] & 0x01)
+		*penum = ((u32)data[0] << 8) | (u32)data[1];
+	return 0;
+}
+
 static int cxd2841er_read_packet_errors_t(
 		struct cxd2841er_priv *priv, u32 *penum)
 {
@@ -1330,6 +1358,49 @@ static int cxd2841er_read_packet_errors_i(
 	return 0;
 }
 
+static int cxd2841er_read_ber_c(struct cxd2841er_priv *priv,
+		u32 *bit_error, u32 *bit_count)
+{
+	u8 data[3];
+	u32 bit_err, period_exp;
+
+	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
+	if (priv->state != STATE_ACTIVE_TC) {
+		dev_dbg(&priv->i2c->dev, "%s(): invalid state %d\n",
+				__func__, priv->state);
+		return -EINVAL;
+	}
+	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x40);
+	cxd2841er_read_regs(priv, I2C_SLVT, 0x62, data, sizeof(data));
+	if (!(data[0] & 0x80)) {
+		dev_dbg(&priv->i2c->dev,
+				"%s(): no valid BER data\n", __func__);
+		return -EINVAL;
+	}
+	bit_err = ((u32)(data[0] & 0x3f) << 16) |
+		((u32)data[1] << 8) |
+		(u32)data[2];
+	cxd2841er_read_reg(priv, I2C_SLVT, 0x60, data);
+	period_exp = data[0] & 0x1f;
+
+	if ((period_exp <= 11) && (bit_err > (1 << period_exp) * 204 * 8)) {
+		dev_dbg(&priv->i2c->dev,
+				"%s(): period_exp(%u) or bit_err(%u)  not in range. no valid BER data\n",
+				__func__, period_exp, bit_err);
+		return -EINVAL;
+	}
+
+	dev_dbg(&priv->i2c->dev,
+			"%s(): period_exp(%u) or bit_err(%u) count=%d\n",
+			__func__, period_exp, bit_err,
+			((1 << period_exp) * 204 * 8));
+
+	*bit_error = bit_err;
+	*bit_count = ((1 << period_exp) * 204 * 8);
+
+	return 0;
+}
+
 static int cxd2841er_mon_read_ber_s(struct cxd2841er_priv *priv,
 				    u32 *bit_error, u32 *bit_count)
 {
@@ -1461,7 +1532,7 @@ static int cxd2841er_read_ber_t2(struct cxd2841er_priv *priv,
 		*bit_error *= 3125ULL;
 	} else {
 		*bit_count = (1U << period_exp) * (n_ldpc / 200);
-		*bit_error *= 50000ULL;;
+		*bit_error *= 50000ULL;
 	}
 	return 0;
 }
@@ -1713,6 +1784,11 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_B:
+	case SYS_DVBC_ANNEX_C:
+		ret = cxd2841er_read_ber_c(priv, &bit_error, &bit_count);
+		break;
 	case SYS_DVBS:
 		ret = cxd2841er_mon_read_ber_s(priv, &bit_error, &bit_count);
 		break;
@@ -1733,9 +1809,9 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
 
 	if (!ret) {
 		p->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		p->post_bit_error.stat[0].uvalue = bit_error;
+		p->post_bit_error.stat[0].uvalue += bit_error;
 		p->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-		p->post_bit_count.stat[0].uvalue = bit_count;
+		p->post_bit_count.stat[0].uvalue += bit_count;
 	} else {
 		p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
@@ -1832,6 +1908,11 @@ static void cxd2841er_read_ucblocks(struct dvb_frontend *fe)
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	switch (p->delivery_system) {
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_B:
+	case SYS_DVBC_ANNEX_C:
+		cxd2841er_read_packet_errors_c(priv, &ucblocks);
+		break;
 	case SYS_DVBT:
 		cxd2841er_read_packet_errors_t(priv, &ucblocks);
 		break;
-- 
2.7.4

