Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56574 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab3KFR5s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 12:57:48 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/8] m88ds3103: add parent for I2C adapter
Date: Wed,  6 Nov 2013 19:57:33 +0200
Message-Id: <1383760655-11388-7-git-send-email-crope@iki.fi>
In-Reply-To: <1383760655-11388-1-git-send-email-crope@iki.fi>
References: <1383760655-11388-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Every I2C adapter should have a parent.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 91b3729..fe4a67e 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1227,6 +1227,7 @@ struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
 			sizeof(priv->i2c_adapter.name));
 	priv->i2c_adapter.algo = &m88ds3103_tuner_i2c_algo;
 	priv->i2c_adapter.algo_data = NULL;
+	priv->i2c_adapter.dev.parent = &i2c->dev;
 	i2c_set_adapdata(&priv->i2c_adapter, priv);
 	ret = i2c_add_adapter(&priv->i2c_adapter);
 	if (ret) {
-- 
1.8.4.2

