Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54666 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaGJLSQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 07:18:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] m88ds3103: implement BER
Date: Thu, 10 Jul 2014 14:17:59 +0300
Message-Id: <1404991079-3027-2-git-send-email-crope@iki.fi>
In-Reply-To: <1404991079-3027-1-git-send-email-crope@iki.fi>
References: <1404991079-3027-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement read_ber for BER estimate.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c      | 81 ++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/m88ds3103_priv.h |  1 +
 2 files changed, 82 insertions(+)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 4176edf..dfe0c2f 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -926,6 +926,86 @@ err:
 	return ret;
 }
 
+static int m88ds3103_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	unsigned int utmp;
+	u8 buf[3], u8tmp;
+	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+
+	switch (c->delivery_system) {
+	case SYS_DVBS:
+		ret = m88ds3103_wr_reg(priv, 0xf9, 0x04);
+		if (ret)
+			goto err;
+
+		ret = m88ds3103_rd_reg(priv, 0xf8, &u8tmp);
+		if (ret)
+			goto err;
+
+		if (!(u8tmp & 0x10)) {
+			u8tmp |= 0x10;
+
+			ret = m88ds3103_rd_regs(priv, 0xf6, buf, 2);
+			if (ret)
+				goto err;
+
+			priv->ber = (buf[1] << 8) | (buf[0] << 0);
+
+			/* restart counters */
+			ret = m88ds3103_wr_reg(priv, 0xf8, u8tmp);
+			if (ret)
+				goto err;
+		}
+		break;
+	case SYS_DVBS2:
+		ret = m88ds3103_rd_regs(priv, 0xd5, buf, 3);
+		if (ret)
+			goto err;
+
+		utmp = (buf[2] << 16) | (buf[1] << 8) | (buf[0] << 0);
+
+		if (utmp > 3000) {
+			ret = m88ds3103_rd_regs(priv, 0xf7, buf, 2);
+			if (ret)
+				goto err;
+
+			priv->ber = (buf[1] << 8) | (buf[0] << 0);
+
+			/* restart counters */
+			ret = m88ds3103_wr_reg(priv, 0xd1, 0x01);
+			if (ret)
+				goto err;
+
+			ret = m88ds3103_wr_reg(priv, 0xf9, 0x01);
+			if (ret)
+				goto err;
+
+			ret = m88ds3103_wr_reg(priv, 0xf9, 0x00);
+			if (ret)
+				goto err;
+
+			ret = m88ds3103_wr_reg(priv, 0xd1, 0x00);
+			if (ret)
+				goto err;
+		}
+		break;
+	default:
+		dev_dbg(&priv->i2c->dev, "%s: invalid delivery_system\n",
+				__func__);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	*ber = priv->ber;
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
 
 static int m88ds3103_set_tone(struct dvb_frontend *fe,
 	fe_sec_tone_mode_t fe_sec_tone_mode)
@@ -1284,6 +1364,7 @@ static struct dvb_frontend_ops m88ds3103_ops = {
 
 	.read_status = m88ds3103_read_status,
 	.read_snr = m88ds3103_read_snr,
+	.read_ber = m88ds3103_read_ber,
 
 	.diseqc_send_master_cmd = m88ds3103_diseqc_send_master_cmd,
 	.diseqc_send_burst = m88ds3103_diseqc_send_burst,
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index e73db5c..9169fdd 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -35,6 +35,7 @@ struct m88ds3103_priv {
 	struct dvb_frontend fe;
 	fe_delivery_system_t delivery_system;
 	fe_status_t fe_status;
+	u32 ber;
 	bool warm; /* FW running */
 	struct i2c_adapter *i2c_adapter;
 };
-- 
1.9.3

