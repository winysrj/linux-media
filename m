Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60184 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaHVAeA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 20:34:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/6] m88ts2022: fix coding style issues
Date: Fri, 22 Aug 2014 03:33:36 +0300
Message-Id: <1408667621-12072-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix coding style issues pointed out by checkpatch.pl.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/m88ts2022.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index 7a62097..f51b107 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -176,6 +176,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	unsigned int f_ref_khz, f_vco_khz, div_ref, div_out, pll_n, gdiv28;
 	u8 buf[3], u8tmp, cap_code, lpf_gm, lpf_mxdiv, div_max, div_min;
 	u16 u16tmp;
+
 	dev_dbg(&priv->client->dev,
 			"%s: frequency=%d symbol_rate=%d rolloff=%d\n",
 			__func__, c->frequency, c->symbol_rate, c->rolloff);
@@ -393,6 +394,7 @@ static int m88ts2022_init(struct dvb_frontend *fe)
 		{0x24, 0x02},
 		{0x12, 0xa0},
 	};
+
 	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	ret = m88ts2022_wr_reg(priv, 0x00, 0x01);
@@ -448,6 +450,7 @@ static int m88ts2022_sleep(struct dvb_frontend *fe)
 {
 	struct m88ts2022_priv *priv = fe->tuner_priv;
 	int ret;
+
 	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	ret = m88ts2022_wr_reg(priv, 0x00, 0x00);
@@ -462,6 +465,7 @@ err:
 static int m88ts2022_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct m88ts2022_priv *priv = fe->tuner_priv;
+
 	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	*frequency = priv->frequency_khz;
@@ -471,6 +475,7 @@ static int m88ts2022_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static int m88ts2022_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct m88ts2022_priv *priv = fe->tuner_priv;
+
 	dev_dbg(&priv->client->dev, "%s:\n", __func__);
 
 	*frequency = 0; /* Zero-IF */
@@ -642,6 +647,7 @@ static int m88ts2022_remove(struct i2c_client *client)
 {
 	struct m88ts2022_priv *priv = i2c_get_clientdata(client);
 	struct dvb_frontend *fe = priv->cfg.fe;
+
 	dev_dbg(&client->dev, "%s:\n", __func__);
 
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
-- 
http://palosaari.fi/

