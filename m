Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38047 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753080AbcIBWhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 18:37:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/9] cxd2820r: dvbv5 statistics for DVB-T
Date: Sat,  3 Sep 2016 01:37:17 +0300
Message-Id: <1472855844-8665-2-git-send-email-crope@iki.fi>
In-Reply-To: <1472855844-8665-1-git-send-email-crope@iki.fi>
References: <1472855844-8665-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement dvbv5 statistics for DVB-T.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r_priv.h |  2 +
 drivers/media/dvb-frontends/cxd2820r_t.c    | 88 +++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/drivers/media/dvb-frontends/cxd2820r_priv.h b/drivers/media/dvb-frontends/cxd2820r_priv.h
index acfae17..a97570b 100644
--- a/drivers/media/dvb-frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb-frontends/cxd2820r_priv.h
@@ -27,6 +27,7 @@
 #include "dvb_math.h"
 #include "cxd2820r.h"
 #include <linux/gpio.h>
+#include <linux/math64.h>
 
 struct reg_val_mask {
 	u32 reg;
@@ -40,6 +41,7 @@ struct cxd2820r_priv {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
 	struct cxd2820r_config cfg;
+	u64 post_bit_error;
 
 	bool ber_running;
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index 67cc33b..d402ab6 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -351,7 +351,9 @@ int cxd2820r_read_ucblocks_t(struct dvb_frontend *fe, u32 *ucblocks)
 int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
+	unsigned int utmp;
 	u8 buf[4];
 	*status = 0;
 
@@ -388,6 +390,92 @@ int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 
 	dev_dbg(&priv->i2c->dev, "%s: lock=%*ph\n", __func__, 4, buf);
 
+	/* Signal strength */
+	if (*status & FE_HAS_SIGNAL) {
+		unsigned int strength;
+
+		ret = cxd2820r_rd_regs(priv, 0x00026, buf, 2);
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
+		ret = cxd2820r_rd_regs(priv, 0x0002c, buf, 2);
+		if (ret)
+			goto error;
+
+		utmp = buf[0] << 8 | buf[1] << 0;
+		if (utmp)
+			cnr = div_u64((u64)(intlog10(utmp)
+				      - intlog10(32000 - utmp) + 55532585)
+				      * 10000, (1 << 24));
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
+			ret = cxd2820r_rd_regs(priv, 0x00076, buf, 3);
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
+			ret = cxd2820r_wr_reg(priv, 0x00079, 0x01);
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

