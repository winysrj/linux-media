Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42834 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752253AbcIBWhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 18:37:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/9] cxd2820r: dvbv5 statistics for DVB-T2
Date: Sat,  3 Sep 2016 01:37:18 +0300
Message-Id: <1472855844-8665-3-git-send-email-crope@iki.fi>
In-Reply-To: <1472855844-8665-1-git-send-email-crope@iki.fi>
References: <1472855844-8665-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement dvbv5 statistics for DVB-T2.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r_t2.c | 77 ++++++++++++++++++++++++++++++-
 1 file changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index 14c9a26..e2875f2 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -286,8 +286,10 @@ error:
 int cxd2820r_read_status_t2(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
-	u8 buf[1];
+	unsigned int utmp;
+	u8 buf[4];
 	*status = 0;
 
 	ret = cxd2820r_rd_reg(priv, 0x02010 , &buf[0]);
@@ -306,6 +308,79 @@ int cxd2820r_read_status_t2(struct dvb_frontend *fe, enum fe_status *status)
 
 	dev_dbg(&priv->i2c->dev, "%s: lock=%02x\n", __func__, buf[0]);
 
+	/* Signal strength */
+	if (*status & FE_HAS_SIGNAL) {
+		unsigned int strength;
+
+		ret = cxd2820r_rd_regs(priv, 0x02026, buf, 2);
+		if (ret)
+			goto error;
+
+		utmp = buf[0] << 8 | buf[1] << 0;
+		utmp = ~utmp & 0x0fff;
+		/* Scale value to 0x0000-0xffff */
+		strength = utmp << 4 | utmp >> 8;
+
+		c->strength.len = 1;
+		c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		c->strength.stat[0].uvalue = strength;
+	} else {
+		c->strength.len = 1;
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	/* CNR */
+	if (*status & FE_HAS_VITERBI) {
+		unsigned int cnr;
+
+		ret = cxd2820r_rd_regs(priv, 0x02028, buf, 2);
+		if (ret)
+			goto error;
+
+		utmp = buf[0] << 8 | buf[1] << 0;
+		utmp = utmp & 0x0fff;
+		#define CXD2820R_LOG10_8_24 15151336 /* log10(8) << 24 */
+		if (utmp)
+			cnr = div_u64((u64)(intlog10(utmp)
+				      - CXD2820R_LOG10_8_24) * 10000,
+				      (1 << 24));
+		else
+			cnr = 0;
+
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[0].svalue = cnr;
+	} else {
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	/* BER */
+	if (*status & FE_HAS_SYNC) {
+		unsigned int post_bit_error;
+
+		ret = cxd2820r_rd_regs(priv, 0x02039, buf, 4);
+		if (ret)
+			goto error;
+
+		if ((buf[0] >> 4) & 0x01) {
+			post_bit_error = buf[0] << 24 | buf[1] << 16 |
+					 buf[2] << 8 | buf[3] << 0;
+			post_bit_error &= 0x0fffffff;
+		} else {
+			post_bit_error = 0;
+		}
+
+		priv->post_bit_error += post_bit_error;
+
+		c->post_bit_error.len = 1;
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue = priv->post_bit_error;
+	} else {
+		c->post_bit_error.len = 1;
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return ret;
 error:
 	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-- 
http://palosaari.fi/

