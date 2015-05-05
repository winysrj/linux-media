Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58260 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbbEEV7A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/21] rtl28xxu: bind tua9001 using I2C binding
Date: Wed,  6 May 2015 00:58:32 +0300
Message-Id: <1430863122-9888-11-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change tua9001 driver from media binding to I2C client binding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index d5b1808..9a65291 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1018,10 +1018,6 @@ err:
 	return ret;
 }
 
-static struct tua9001_config rtl2832u_tua9001_config = {
-	.i2c_addr = 0x60,
-};
-
 static const struct fc0012_config rtl2832u_fc0012_config = {
 	.i2c_address = 0x63, /* 0xc6 >> 1 */
 	.xtal_freq = FC_XTAL_28_8_MHZ,
@@ -1121,7 +1117,12 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			dev->i2c_client_tuner = client;
 		}
 		break;
-	case TUNER_RTL2832_TUA9001:
+	case TUNER_RTL2832_TUA9001: {
+		struct tua9001_platform_data tua9001_pdata = {
+			.dvb_frontend = adap->fe[0],
+		};
+		struct i2c_board_info board_info = {};
+
 		/* enable GPIO1 and GPIO4 as output */
 		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x12);
 		if (ret)
@@ -1131,10 +1132,20 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		if (ret)
 			goto err;
 
-		fe = dvb_attach(tua9001_attach, adap->fe[0],
-				dev->demod_i2c_adapter,
-				&rtl2832u_tua9001_config);
+		strlcpy(board_info.type, "tua9001", I2C_NAME_SIZE);
+		board_info.addr = 0x60;
+		board_info.platform_data = &tua9001_pdata;
+		request_module("tua9001");
+		client = i2c_new_device(dev->demod_i2c_adapter, &board_info);
+		if (client == NULL || client->dev.driver == NULL)
+			break;
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			break;
+		}
+		dev->i2c_client_tuner = client;
 		break;
+	}
 	case TUNER_RTL2832_R820T:
 		fe = dvb_attach(r820t_attach, adap->fe[0],
 				dev->demod_i2c_adapter,
-- 
http://palosaari.fi/

