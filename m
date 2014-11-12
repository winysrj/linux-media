Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33670 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbaKLEXX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:23:23 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/8] rtl2832: implement PIP mode
Date: Wed, 12 Nov 2014 06:23:04 +0200
Message-Id: <1415766190-24482-3-git-send-email-crope@iki.fi>
In-Reply-To: <1415766190-24482-1-git-send-email-crope@iki.fi>
References: <1415766190-24482-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement PIP mode to stream from slave demodulator. PIP mode is
enabled when .set_frontend is called with RF frequency 0, otherwise
normal demod mode is enabled.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 42 ++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index eb737cf..a58b456 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -258,13 +258,11 @@ static int rtl2832_rd_regs(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val,
 	return rtl2832_rd(priv, reg, val, len);
 }
 
-#if 0 /* currently not used */
 /* write single register */
 static int rtl2832_wr_reg(struct rtl2832_priv *priv, u8 reg, u8 page, u8 val)
 {
 	return rtl2832_wr_regs(priv, reg, page, &val, 1);
 }
-#endif
 
 /* read single register */
 static int rtl2832_rd_reg(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val)
@@ -595,6 +593,44 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 			"%s: frequency=%d bandwidth_hz=%d inversion=%d\n",
 			__func__, c->frequency, c->bandwidth_hz, c->inversion);
 
+	/* PIP mode */
+	if (c->frequency == 0) {
+		dev_dbg(&priv->i2c->dev, "%s: setting PIP mode\n", __func__);
+		ret = rtl2832_wr_regs(priv, 0x0c, 1, "\x5f\xff", 2);
+		if (ret)
+			goto err;
+
+		ret = rtl2832_wr_demod_reg(priv, DVBT_PIP_ON, 0x1);
+		if (ret)
+			goto err;
+
+		ret = rtl2832_wr_reg(priv, 0xbc, 0, 0x18);
+		if (ret)
+			goto err;
+
+		ret = rtl2832_wr_reg(priv, 0x22, 0, 0x01);
+		if (ret)
+			goto err;
+
+		ret = rtl2832_wr_reg(priv, 0x26, 0, 0x1f);
+		if (ret)
+			goto err;
+
+		ret = rtl2832_wr_reg(priv, 0x27, 0, 0xff);
+		if (ret)
+			goto err;
+
+		ret = rtl2832_wr_regs(priv, 0x92, 1, "\x7f\xf7\xff", 3);
+		if (ret)
+			goto err;
+
+		goto exit_soft_reset;
+	} else {
+		ret = rtl2832_wr_regs(priv, 0x92, 1, "\x00\x0f\xff", 3);
+		if (ret)
+			goto err;
+	}
+
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
@@ -661,7 +697,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-
+exit_soft_reset:
 	/* soft reset */
 	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x1);
 	if (ret)
-- 
http://palosaari.fi/

