Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34898 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbbEEV67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:58:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/21] rtl28xxu: bind fc2580 using I2C binding
Date: Wed,  6 May 2015 00:58:23 +0300
Message-Id: <1430863122-9888-2-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change fc2580 driver from media binding to I2C client binding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 895441f..d5b1808 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1018,11 +1018,6 @@ err:
 	return ret;
 }
 
-static const struct fc2580_config rtl2832u_fc2580_config = {
-	.i2c_addr = 0x56,
-	.clock = 16384000,
-};
-
 static struct tua9001_config rtl2832u_tua9001_config = {
 	.i2c_addr = 0x60,
 };
@@ -1105,10 +1100,26 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			subdev = i2c_get_clientdata(client);
 		}
 		break;
-	case TUNER_RTL2832_FC2580:
-		fe = dvb_attach(fc2580_attach, adap->fe[0],
-				dev->demod_i2c_adapter,
-				&rtl2832u_fc2580_config);
+	case TUNER_RTL2832_FC2580: {
+			struct fc2580_platform_data fc2580_pdata = {
+				.dvb_frontend = adap->fe[0],
+			};
+			struct i2c_board_info board_info = {};
+
+			strlcpy(board_info.type, "fc2580", I2C_NAME_SIZE);
+			board_info.addr = 0x56;
+			board_info.platform_data = &fc2580_pdata;
+			request_module("fc2580");
+			client = i2c_new_device(dev->demod_i2c_adapter,
+						&board_info);
+			if (client == NULL || client->dev.driver == NULL)
+				break;
+			if (!try_module_get(client->dev.driver->owner)) {
+				i2c_unregister_device(client);
+				break;
+			}
+			dev->i2c_client_tuner = client;
+		}
 		break;
 	case TUNER_RTL2832_TUA9001:
 		/* enable GPIO1 and GPIO4 as output */
-- 
http://palosaari.fi/

