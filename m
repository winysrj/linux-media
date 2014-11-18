Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51919 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbaKRHVg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 02:21:36 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 3/6] rtl28xxu: add support for Panasonic MN88473 slave demod
Date: Tue, 18 Nov 2014 09:20:40 +0200
Message-Id: <1416295243-27300-3-git-send-email-crope@iki.fi>
In-Reply-To: <1416295243-27300-1-git-send-email-crope@iki.fi>
References: <1416295243-27300-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is RTL2832P devices having extra MN88473 demodulator. This
patch add support for such configuration. Logically MN88473 slave
demodulator is connected to RTL2832 master demodulator, both I2C
bus and TS input. RTL2832 is integrated to RTL2832U and RTL2832P
chips. Chip version RTL2832P has extra TS interface for connecting
slave demodulator.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 31 +++++++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |  3 ++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index d9ee1a9..cb54d2a 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -25,6 +25,7 @@
 #include "rtl2830.h"
 #include "rtl2832.h"
 #include "mn88472.h"
+#include "mn88473.h"
 
 #include "qt1010.h"
 #include "mt2060.h"
@@ -422,6 +423,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	struct rtl28xxu_req req_r820t = {0x0034, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_r828d = {0x0074, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_mn88472 = {0xff38, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_mn88473 = {0xff38, CMD_I2C_RD, 1, buf};
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -567,6 +569,13 @@ tuner_found:
 			priv->slave_demod = SLAVE_DEMOD_MN88472;
 			goto demod_found;
 		}
+
+		ret = rtl28xxu_ctrl_msg(d, &req_mn88473);
+		if (ret == 0 && buf[0] == 0x03) {
+			dev_dbg(&d->udev->dev, "%s: MN88473 found\n", __func__);
+			priv->slave_demod = SLAVE_DEMOD_MN88473;
+			goto demod_found;
+		}
 	}
 
 demod_found:
@@ -877,6 +886,28 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			}
 
 			priv->i2c_client_slave_demod = client;
+		} else {
+			struct mn88473_config mn88473_config = {};
+
+			mn88473_config.fe = &adap->fe[1];
+			mn88473_config.i2c_wr_max = 22,
+			strlcpy(info.type, "mn88473", I2C_NAME_SIZE);
+			info.addr = 0x18;
+			info.platform_data = &mn88473_config;
+			request_module(info.type);
+			client = i2c_new_device(priv->demod_i2c_adapter, &info);
+			if (client == NULL || client->dev.driver == NULL) {
+				priv->slave_demod = SLAVE_DEMOD_NONE;
+				goto err_slave_demod_failed;
+			}
+
+			if (!try_module_get(client->dev.driver->owner)) {
+				i2c_unregister_device(client);
+				priv->slave_demod = SLAVE_DEMOD_NONE;
+				goto err_slave_demod_failed;
+			}
+
+			priv->i2c_client_slave_demod = client;
 		}
 	}
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index c1b00b9..7f959ff 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -61,7 +61,8 @@ struct rtl28xxu_priv {
 	struct i2c_client *i2c_client_slave_demod;
 	#define SLAVE_DEMOD_NONE           0
 	#define SLAVE_DEMOD_MN88472        1
-	unsigned int slave_demod:1;
+	#define SLAVE_DEMOD_MN88473        2
+	unsigned int slave_demod:2;
 };
 
 enum rtl28xxu_chip_id {
-- 
http://palosaari.fi/

