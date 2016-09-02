Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43541 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752415AbcIBWhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 18:37:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/9] cxd2820r: dvbv5 statistics for DVB-C
Date: Sat,  3 Sep 2016 01:37:19 +0300
Message-Id: <1472855844-8665-4-git-send-email-crope@iki.fi>
In-Reply-To: <1472855844-8665-1-git-send-email-crope@iki.fi>
References: <1472855844-8665-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement dvbv5 statistics for DVB-C.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r_c.c | 104 ++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index 957ec94..7cdcd55 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -260,11 +260,13 @@ int cxd2820r_read_ucblocks_c(struct dvb_frontend *fe, u32 *ucblocks)
 int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
-	u8 buf[2];
+	unsigned int utmp;
+	u8 buf[3];
 	*status = 0;
 
-	ret = cxd2820r_rd_regs(priv, 0x10088, buf, sizeof(buf));
+	ret = cxd2820r_rd_regs(priv, 0x10088, buf, 2);
 	if (ret)
 		goto error;
 
@@ -281,6 +283,104 @@ int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 	dev_dbg(&priv->i2c->dev, "%s: lock=%02x %02x\n", __func__, buf[0],
 			buf[1]);
 
+	/* Signal strength */
+	if (*status & FE_HAS_SIGNAL) {
+		unsigned int strength;
+
+		ret = cxd2820r_rd_regs(priv, 0x10049, buf, 2);
+		if (ret)
+			goto error;
+
+		utmp = buf[0] << 8 | buf[1] << 0;
+		utmp = 511 - sign_extend32(utmp, 9);
+		/* Scale value to 0x0000-0xffff */
+		strength = utmp << 6 | utmp >> 4;
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
+		unsigned int cnr, const_a, const_b;
+
+		ret = cxd2820r_rd_reg(priv, 0x10019, &buf[0]);
+		if (ret)
+			goto error;
+
+		if (((buf[0] >> 0) & 0x03) % 2) {
+			const_a = 8750;
+			const_b = 650;
+		} else {
+			const_a = 9500;
+			const_b = 760;
+		}
+
+		ret = cxd2820r_rd_reg(priv, 0x1004d, &buf[0]);
+		if (ret)
+			goto error;
+
+		utmp = buf[0] << 0;
+		#define CXD2820R_LOG2_E_24 24204406 /* log2(e) << 24 */
+		if (utmp)
+			cnr = div_u64((u64)(intlog2(const_b) - intlog2(utmp))
+				      * const_a, CXD2820R_LOG2_E_24);
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
+		bool start_ber;
+
+		if (priv->ber_running) {
+			ret = cxd2820r_rd_regs(priv, 0x10076, buf, 3);
+			if (ret)
+				goto error;
+
+			if ((buf[2] >> 7) & 0x01) {
+				post_bit_error = buf[2] << 16 | buf[1] << 8 |
+						 buf[0] << 0;
+				post_bit_error &= 0x0fffff;
+				start_ber = true;
+			} else {
+				post_bit_error = 0;
+				start_ber = false;
+			}
+		} else {
+			post_bit_error = 0;
+			start_ber = true;
+		}
+
+		if (start_ber) {
+			ret = cxd2820r_wr_reg(priv, 0x10079, 0x01);
+			if (ret)
+				goto error;
+			priv->ber_running = true;
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

