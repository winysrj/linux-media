Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60845 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753078AbcKLKey (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 05:34:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 8/9] it913x: add chip device ids for binding
Date: Sat, 12 Nov 2016 12:34:00 +0200
Message-Id: <1478946841-2807-8-git-send-email-crope@iki.fi>
In-Reply-To: <1478946841-2807-1-git-send-email-crope@iki.fi>
References: <1478946841-2807-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver supports 2 different device versions, AX and BX. Use device
IDs to pass chip version information to driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c         | 11 ++++++++++-
 drivers/media/tuners/it913x.h         |  5 -----
 drivers/media/usb/dvb-usb-v2/af9035.c |  8 ++++----
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 085e33c..66d77df 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -394,6 +394,7 @@ static int it913x_probe(struct platform_device *pdev)
 	struct it913x_platform_data *pdata = pdev->dev.platform_data;
 	struct dvb_frontend *fe = pdata->fe;
 	struct it913x_dev *dev;
+	const struct platform_device_id *id = platform_get_device_id(pdev);
 	int ret;
 	char *chip_ver_str;
 
@@ -407,7 +408,7 @@ static int it913x_probe(struct platform_device *pdev)
 	dev->pdev = pdev;
 	dev->regmap = pdata->regmap;
 	dev->fe = pdata->fe;
-	dev->chip_ver = pdata->chip_ver;
+	dev->chip_ver = id->driver_data;
 	dev->role = pdata->role;
 
 	fe->tuner_priv = dev;
@@ -445,6 +446,13 @@ static int it913x_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id it913x_id_table[] = {
+	{"it9133ax-tuner", 1},
+	{"it9133bx-tuner", 2},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, it913x_id_table);
+
 static struct platform_driver it913x_driver = {
 	.driver = {
 		.name	= "it913x",
@@ -452,6 +460,7 @@ static struct platform_driver it913x_driver = {
 	},
 	.probe		= it913x_probe,
 	.remove		= it913x_remove,
+	.id_table	= it913x_id_table,
 };
 
 module_platform_driver(it913x_driver);
diff --git a/drivers/media/tuners/it913x.h b/drivers/media/tuners/it913x.h
index aa18862..5df7653 100644
--- a/drivers/media/tuners/it913x.h
+++ b/drivers/media/tuners/it913x.h
@@ -29,21 +29,16 @@
  * struct it913x_platform_data - Platform data for the it913x driver
  * @regmap: af9033 demod driver regmap.
  * @dvb_frontend: af9033 demod driver DVB frontend.
- * @chip_ver: Used chip version. 1=IT9133 AX, 2=IT9133 BX.
  * @role: Chip role, single or dual configuration.
  */
 
 struct it913x_platform_data {
 	struct regmap *regmap;
 	struct dvb_frontend *fe;
-	unsigned int chip_ver:2;
 #define IT913X_ROLE_SINGLE         0
 #define IT913X_ROLE_DUAL_MASTER    1
 #define IT913X_ROLE_DUAL_SLAVE     2
 	unsigned int role:2;
 };
 
-/* Backwards compatibility */
-#define it913x_config it913x_platform_data
-
 #endif
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index d89d0d6..da29b6f 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1495,6 +1495,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	case AF9033_TUNER_IT9135_62:
 	{
 		struct platform_device *pdev;
+		const char *name;
 		struct it913x_platform_data it913x_pdata = {
 			.regmap = state->af9033_config[adap->id].regmap,
 			.fe = adap->fe[0],
@@ -1504,12 +1505,12 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		case AF9033_TUNER_IT9135_38:
 		case AF9033_TUNER_IT9135_51:
 		case AF9033_TUNER_IT9135_52:
-			it913x_pdata.chip_ver = 1;
+			name = "it9133ax-tuner";
 			break;
 		case AF9033_TUNER_IT9135_60:
 		case AF9033_TUNER_IT9135_61:
 		case AF9033_TUNER_IT9135_62:
-			it913x_pdata.chip_ver = 2;
+			name = "it9133bx-tuner";
 			break;
 		}
 
@@ -1523,8 +1524,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		}
 
 		request_module("%s", "it913x");
-		pdev = platform_device_register_data(&d->intf->dev,
-						     "it913x",
+		pdev = platform_device_register_data(&d->intf->dev, name,
 						     PLATFORM_DEVID_AUTO,
 						     &it913x_pdata,
 						     sizeof(it913x_pdata));
-- 
http://palosaari.fi/

