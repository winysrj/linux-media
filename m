Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40963 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655AbaLWUuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 48/66] rtl28xxu: use master I2C adapter for slave demods
Date: Tue, 23 Dec 2014 22:49:41 +0200
Message-Id: <1419367799-14263-48-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both mn88472 and mn88473 slave demods are connected to master I2C
bus, not the bus behind master demod I2C gate like tuners. Use
correct bus.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c2d377f..0d37d0c 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -841,7 +841,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			info.addr = 0x18;
 			info.platform_data = &mn88472_config;
 			request_module(info.type);
-			client = i2c_new_device(priv->demod_i2c_adapter, &info);
+			client = i2c_new_device(&d->i2c_adap, &info);
 			if (client == NULL || client->dev.driver == NULL) {
 				priv->slave_demod = SLAVE_DEMOD_NONE;
 				goto err_slave_demod_failed;
@@ -863,7 +863,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			info.addr = 0x18;
 			info.platform_data = &mn88473_config;
 			request_module(info.type);
-			client = i2c_new_device(priv->demod_i2c_adapter, &info);
+			client = i2c_new_device(&d->i2c_adap, &info);
 			if (client == NULL || client->dev.driver == NULL) {
 				priv->slave_demod = SLAVE_DEMOD_NONE;
 				goto err_slave_demod_failed;
-- 
http://palosaari.fi/

