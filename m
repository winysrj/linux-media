Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41394 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752748AbcLSRff (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 12:35:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2] af9035: register it9133 tuner using platform binding
Date: Mon, 19 Dec 2016 19:35:24 +0200
Message-Id: <1482168924-29719-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

it913x tuner driver is changed to platform model so we need bind it
using platform_device_register_data().

Also remove hacks from I2C adapter where fake tuner driver address
(addr >> 1) were used as those are no longer needed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 124 ++++++++++++++++------------------
 drivers/media/usb/dvb-usb-v2/af9035.h |   2 +
 2 files changed, 62 insertions(+), 64 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 61dac6a..a6ecd52 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -335,14 +335,12 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_i2c_addr[0]) ||
-			   (msg[0].addr == state->af9033_i2c_addr[1]) ||
-			   (state->chip_type == 0x9135)) {
+			   (msg[0].addr == state->af9033_i2c_addr[1])) {
 			/* demod access via firmware interface */
 			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
 
-			if (msg[0].addr == state->af9033_i2c_addr[1] ||
-			    msg[0].addr == (state->af9033_i2c_addr[1] >> 1))
+			if (msg[0].addr == state->af9033_i2c_addr[1])
 				reg |= 0x100000;
 
 			ret = af9035_rd_regs(d, reg, &msg[1].buf[0],
@@ -396,14 +394,12 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_i2c_addr[0]) ||
-			   (msg[0].addr == state->af9033_i2c_addr[1]) ||
-			   (state->chip_type == 0x9135)) {
+			   (msg[0].addr == state->af9033_i2c_addr[1])) {
 			/* demod access via firmware interface */
 			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
 
-			if (msg[0].addr == state->af9033_i2c_addr[1] ||
-			    msg[0].addr == (state->af9033_i2c_addr[1] >> 1))
+			if (msg[0].addr == state->af9033_i2c_addr[1])
 				reg |= 0x100000;
 
 			ret = af9035_wr_regs(d, reg, &msg[0].buf[3],
@@ -1250,30 +1246,11 @@ static int af9035_frontend_detach(struct dvb_usb_adapter *adap)
 	struct state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct usb_interface *intf = d->intf;
-	int demod2;
 
 	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
 
-	/*
-	 * For dual tuner devices we have to resolve 2nd demod client, as there
-	 * is two different kind of tuner drivers; one is using I2C binding
-	 * and the other is using DVB attach/detach binding.
-	 */
-	switch (state->af9033_config[adap->id].tuner) {
-	case AF9033_TUNER_IT9135_38:
-	case AF9033_TUNER_IT9135_51:
-	case AF9033_TUNER_IT9135_52:
-	case AF9033_TUNER_IT9135_60:
-	case AF9033_TUNER_IT9135_61:
-	case AF9033_TUNER_IT9135_62:
-		demod2 = 2;
-		break;
-	default:
-		demod2 = 1;
-	}
-
 	if (adap->id == 1) {
-		if (state->i2c_client[demod2])
+		if (state->i2c_client[1])
 			af9035_del_i2c_dev(d);
 	} else if (adap->id == 0) {
 		if (state->i2c_client[0])
@@ -1513,50 +1490,58 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
 	case AF9033_TUNER_IT9135_52:
-	{
-		struct it913x_config it913x_config = {
-			.fe = adap->fe[0],
-			.chip_ver = 1,
-		};
-
-		if (state->dual_mode) {
-			if (adap->id == 0)
-				it913x_config.role = IT913X_ROLE_DUAL_MASTER;
-			else
-				it913x_config.role = IT913X_ROLE_DUAL_SLAVE;
-		}
-
-		ret = af9035_add_i2c_dev(d, "it913x",
-				state->af9033_i2c_addr[adap->id] >> 1,
-				&it913x_config, &d->i2c_adap);
-		if (ret)
-			goto err;
-
-		fe = adap->fe[0];
-		break;
-	}
 	case AF9033_TUNER_IT9135_60:
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
 	{
-		struct it913x_config it913x_config = {
+		struct platform_device *pdev;
+		struct it913x_platform_data it913x_pdata = {
+			.regmap = state->af9033_config[adap->id].regmap,
 			.fe = adap->fe[0],
-			.chip_ver = 2,
 		};
 
+		switch (state->af9033_config[adap->id].tuner) {
+		case AF9033_TUNER_IT9135_38:
+		case AF9033_TUNER_IT9135_51:
+		case AF9033_TUNER_IT9135_52:
+			it913x_pdata.chip_ver = 1;
+			break;
+		case AF9033_TUNER_IT9135_60:
+		case AF9033_TUNER_IT9135_61:
+		case AF9033_TUNER_IT9135_62:
+			it913x_pdata.chip_ver = 2;
+			break;
+		default:
+			ret = -ENODEV;
+			goto err;
+		}
+
 		if (state->dual_mode) {
 			if (adap->id == 0)
-				it913x_config.role = IT913X_ROLE_DUAL_MASTER;
+				it913x_pdata.role = IT913X_ROLE_DUAL_MASTER;
 			else
-				it913x_config.role = IT913X_ROLE_DUAL_SLAVE;
+				it913x_pdata.role = IT913X_ROLE_DUAL_SLAVE;
+		} else {
+			it913x_pdata.role = IT913X_ROLE_SINGLE;
 		}
 
-		ret = af9035_add_i2c_dev(d, "it913x",
-				state->af9033_i2c_addr[adap->id] >> 1,
-				&it913x_config, &d->i2c_adap);
-		if (ret)
+		request_module("%s", "it913x");
+		pdev = platform_device_register_data(&d->intf->dev,
+						     "it913x",
+						     PLATFORM_DEVID_AUTO,
+						     &it913x_pdata,
+						     sizeof(it913x_pdata));
+		if (IS_ERR(pdev) || !pdev->dev.driver) {
+			ret = -ENODEV;
+			goto err;
+		}
+		if (!try_module_get(pdev->dev.driver->owner)) {
+			platform_device_unregister(pdev);
+			ret = -ENODEV;
 			goto err;
+		}
 
+		state->platform_device_tuner[adap->id] = pdev;
 		fe = adap->fe[0];
 		break;
 	}
@@ -1678,12 +1663,6 @@ static int af9035_tuner_detach(struct dvb_usb_adapter *adap)
 	switch (state->af9033_config[adap->id].tuner) {
 	case AF9033_TUNER_TUA9001:
 	case AF9033_TUNER_FC2580:
-	case AF9033_TUNER_IT9135_38:
-	case AF9033_TUNER_IT9135_51:
-	case AF9033_TUNER_IT9135_52:
-	case AF9033_TUNER_IT9135_60:
-	case AF9033_TUNER_IT9135_61:
-	case AF9033_TUNER_IT9135_62:
 		if (adap->id == 1) {
 			if (state->i2c_client[3])
 				af9035_del_i2c_dev(d);
@@ -1691,6 +1670,23 @@ static int af9035_tuner_detach(struct dvb_usb_adapter *adap)
 			if (state->i2c_client[1])
 				af9035_del_i2c_dev(d);
 		}
+		break;
+	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
+	{
+		struct platform_device *pdev;
+
+		pdev = state->platform_device_tuner[adap->id];
+		if (pdev) {
+			module_put(pdev->dev.driver->owner);
+			platform_device_unregister(pdev);
+		}
+		break;
+	}
 	}
 
 	return 0;
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 89a08a4..a76e6bf 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -22,6 +22,7 @@
 #ifndef AF9035_H
 #define AF9035_H
 
+#include <linux/platform_device.h>
 #include "dvb_usb.h"
 #include "af9033.h"
 #include "tua9001.h"
@@ -73,6 +74,7 @@ struct state {
 	#define AF9035_I2C_CLIENT_MAX 4
 	struct i2c_client *i2c_client[AF9035_I2C_CLIENT_MAX];
 	struct i2c_adapter *i2c_adapter_demod;
+	struct platform_device *platform_device_tuner[2];
 };
 
 static const u32 clock_lut_af9035[] = {
-- 
http://palosaari.fi/

