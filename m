Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57691 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaIUKxk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 06:53:40 -0400
Received: by mail-lb0-f171.google.com with SMTP id l4so5314850lbv.30
        for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 03:53:39 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, crope@iki.fi
Subject: [PATCH 2/3] af9035: Add possibility to define which I2C adapter to use
Date: Sun, 21 Sep 2014 13:53:18 +0300
Message-Id: <1411296799-3525-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1411296799-3525-1-git-send-email-olli.salonen@iki.fi>
References: <1411296799-3525-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some I2C tuner drivers require that the I2C device of the tuner is added to the I2C adapter of the demodulator (Si2168+Si2157 for example). Add possibility to tell af9035_add_i2c_dev which I2C adapter should be used.

Cc: crope@iki.fi
Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 440ecb4..c50d27d 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -194,12 +194,11 @@ static int af9035_wr_reg_mask(struct dvb_usb_device *d, u32 reg, u8 val,
 }
 
 static int af9035_add_i2c_dev(struct dvb_usb_device *d, char *type, u8 addr,
-		void *platform_data)
+		void *platform_data, struct i2c_adapter *adapter)
 {
 	int ret, num;
 	struct state *state = d_to_priv(d);
 	struct i2c_client *client;
-	struct i2c_adapter *adapter = &d->i2c_adap;
 	struct i2c_board_info board_info = {
 		.addr = addr,
 		.platform_data = platform_data,
@@ -1091,7 +1090,7 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 	state->af9033_config[adap->id].fe = &adap->fe[0];
 	state->af9033_config[adap->id].ops = &state->ops;
 	ret = af9035_add_i2c_dev(d, "af9033", state->af9033_i2c_addr[adap->id],
-			&state->af9033_config[adap->id]);
+			&state->af9033_config[adap->id], &d->i2c_adap);
 	if (ret)
 		goto err;
 
@@ -1382,7 +1381,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 
 		ret = af9035_add_i2c_dev(d, "it913x",
 				state->af9033_i2c_addr[adap->id] >> 1,
-				&it913x_config);
+				&it913x_config, &d->i2c_adap);
 		if (ret)
 			goto err;
 
@@ -1407,7 +1406,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 
 		ret = af9035_add_i2c_dev(d, "it913x",
 				state->af9033_i2c_addr[adap->id] >> 1,
-				&it913x_config);
+				&it913x_config, &d->i2c_adap);
 		if (ret)
 			goto err;
 
-- 
1.9.1

