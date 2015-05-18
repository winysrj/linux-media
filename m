Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37103 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbbERFJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 01:09:30 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/8] m88ds3103: implement DVBv5 BER
Date: Mon, 18 May 2015 08:08:47 +0300
Message-Id: <1431925731-7499-4-git-send-email-crope@iki.fi>
In-Reply-To: <1431925731-7499-1-git-send-email-crope@iki.fi>
References: <1431925731-7499-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVBv5 BER statistics.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c      | 88 ++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/m88ds3103_priv.h |  2 +
 2 files changed, 90 insertions(+)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 381a8ad..3cf89b6 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -305,6 +305,90 @@ static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
+	/* BER */
+	if (priv->fe_status & FE_HAS_LOCK) {
+		unsigned int utmp, post_bit_error, post_bit_count;
+
+		switch (c->delivery_system) {
+		case SYS_DVBS:
+			ret = m88ds3103_wr_reg(priv, 0xf9, 0x04);
+			if (ret)
+				goto err;
+
+			ret = m88ds3103_rd_reg(priv, 0xf8, &u8tmp);
+			if (ret)
+				goto err;
+
+			/* measurement ready? */
+			if (!(u8tmp & 0x10)) {
+				ret = m88ds3103_rd_regs(priv, 0xf6, buf, 2);
+				if (ret)
+					goto err;
+
+				post_bit_error = buf[1] << 8 | buf[0] << 0;
+				post_bit_count = 0x800000;
+				priv->post_bit_error += post_bit_error;
+				priv->post_bit_count += post_bit_count;
+
+				/* restart measurement */
+				u8tmp |= 0x10;
+				ret = m88ds3103_wr_reg(priv, 0xf8, u8tmp);
+				if (ret)
+					goto err;
+			}
+			break;
+		case SYS_DVBS2:
+			ret = m88ds3103_rd_regs(priv, 0xd5, buf, 3);
+			if (ret)
+				goto err;
+
+			utmp = buf[2] << 16 | buf[1] << 8 | buf[0] << 0;
+
+			/* enough data? */
+			if (utmp > 4000) {
+				ret = m88ds3103_rd_regs(priv, 0xf7, buf, 2);
+				if (ret)
+					goto err;
+
+				post_bit_error = buf[1] << 8 | buf[0] << 0;
+				post_bit_count = 32 * utmp; /* TODO: FEC */
+				priv->post_bit_error += post_bit_error;
+				priv->post_bit_count += post_bit_count;
+
+				/* restart measurement */
+				ret = m88ds3103_wr_reg(priv, 0xd1, 0x01);
+				if (ret)
+					goto err;
+
+				ret = m88ds3103_wr_reg(priv, 0xf9, 0x01);
+				if (ret)
+					goto err;
+
+				ret = m88ds3103_wr_reg(priv, 0xf9, 0x00);
+				if (ret)
+					goto err;
+
+				ret = m88ds3103_wr_reg(priv, 0xd1, 0x00);
+				if (ret)
+					goto err;
+			}
+			break;
+		default:
+			dev_dbg(&priv->i2c->dev,
+				"%s: invalid delivery_system\n", __func__);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue = priv->post_bit_error;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue = priv->post_bit_count;
+	} else {
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 err:
 	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
@@ -760,6 +844,10 @@ skip_fw_download:
 	/* init stats here in order signal app which stats are supported */
 	c->cnr.len = 1;
 	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_error.len = 1;
+	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_count.len = 1;
+	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	return 0;
 
 error_fw_release:
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index a2c0958..aafa28c 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -45,6 +45,8 @@ struct m88ds3103_priv {
 	u8 chip_id;
 	/* main mclk is calculated for M88RS6000 dynamically */
 	u32 mclk_khz;
+	u64 post_bit_error;
+	u64 post_bit_count;
 };
 
 struct m88ds3103_reg_val {
-- 
http://palosaari.fi/

