Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37609 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751089AbdAPXax (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 18:30:53 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Chris Rankin <rankincj@gmail.com>,
        =?UTF-8?q?H=C3=A5kan=20Lennest=C3=A5l?= <hakan.lennestal@gmail.com>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH] cxd2820r: fix gpio null pointer dereference
Date: Tue, 17 Jan 2017 01:29:34 +0200
Message-Id: <20170116232934.8230-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting GPIOs during probe causes null pointer deference when
GPIOLIB was not selected by Kconfig. Initialize driver private
field before calling set gpios.

It is regressing bug since 4.9.

Fixes: 07fdf7d9f19f ("[media] cxd2820r: add I2C driver bindings")
Reported-by: Chris Rankin <rankincj@gmail.com>
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 95267c6..f6ebbb4 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -615,6 +615,7 @@ static int cxd2820r_probe(struct i2c_client *client,
 	}
 
 	priv->client[0] = client;
+	priv->fe.demodulator_priv = priv;
 	priv->i2c = client->adapter;
 	priv->ts_mode = pdata->ts_mode;
 	priv->ts_clk_inv = pdata->ts_clk_inv;
@@ -697,7 +698,6 @@ static int cxd2820r_probe(struct i2c_client *client,
 	memcpy(&priv->fe.ops, &cxd2820r_ops, sizeof(priv->fe.ops));
 	if (!pdata->attach_in_use)
 		priv->fe.ops.release = NULL;
-	priv->fe.demodulator_priv = priv;
 	i2c_set_clientdata(client, priv);
 
 	/* Setup callbacks */
-- 
http://palosaari.fi/

