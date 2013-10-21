Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48271 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab3JUUMq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 16:12:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] rtl2830: add parent for I2C adapter
Date: Mon, 21 Oct 2013 23:12:15 +0300
Message-Id: <1382386335-3879-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c i2c-6: adapter [RTL2830 tuner I2C adapter] registered
BUG: unable to handle kernel NULL pointer dereference at 0000000000000220
IP: [<ffffffffa0002900>] i2c_register_adapter+0x130/0x390 [i2c_core]

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 362d26d..68ee70b 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -700,6 +700,7 @@ struct dvb_frontend *rtl2830_attach(const struct rtl2830_config *cfg,
 		sizeof(priv->tuner_i2c_adapter.name));
 	priv->tuner_i2c_adapter.algo = &rtl2830_tuner_i2c_algo;
 	priv->tuner_i2c_adapter.algo_data = NULL;
+	priv->tuner_i2c_adapter.dev.parent = &i2c->dev;
 	i2c_set_adapdata(&priv->tuner_i2c_adapter, priv);
 	if (i2c_add_adapter(&priv->tuner_i2c_adapter) < 0) {
 		dev_err(&i2c->dev,
-- 
1.8.3.1

