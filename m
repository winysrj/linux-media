Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:45903 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab2IIUqs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 16:46:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by 7of9.schinagl.nl (Postfix) with ESMTP id 3E4C624428
	for <linux-media@vger.kernel.org>; Sun,  9 Sep 2012 22:50:35 +0200 (CEST)
From: oliver@schinagl.nl
To: linux-media@vger.kernel.org
Cc: Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH] Support for Asus MyCinema U3100Mini Plus
Date: Sun,  9 Sep 2012 22:47:27 +0200
Message-Id: <1347223647-645-1-git-send-email-oliver+list@schinagl.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oliver Schinagl <oliver@schinagl.nl>

Initial support for the Asus MyCinema U3100Mini Plus. This currently
does not work however. It uses teh af9033/5 demodulater with an
FCI FC2580 tuner.

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 drivers/media/dvb-core/dvb-usb-ids.h      |  1 +
 drivers/media/dvb-frontends/af9033.c      |  4 ++++
 drivers/media/dvb-frontends/af9033.h      |  1 +
 drivers/media/dvb-frontends/af9033_priv.h | 36 +++++++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/Kconfig      |  1 +
 drivers/media/usb/dvb-usb-v2/af9035.c     | 12 +++++++++++
 drivers/media/usb/dvb-usb-v2/af9035.h     |  1 +
 7 files changed, 56 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index d572307..58e0220 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -329,6 +329,7 @@
 #define USB_PID_ASUS_U3000				0x171f
 #define USB_PID_ASUS_U3000H				0x1736
 #define USB_PID_ASUS_U3100				0x173f
+#define USB_PID_ASUS_U3100MINI_PLUS			0x1779
 #define USB_PID_YUAN_EC372S				0x1edc
 #define USB_PID_YUAN_STK7700PH				0x1f08
 #define USB_PID_YUAN_PD378S				0x2edc
diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index cd8c883..1568c6a 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -318,6 +318,10 @@ static int af9033_init(struct dvb_frontend *fe)
 		len = ARRAY_SIZE(tuner_init_tda18218);
 		init = tuner_init_tda18218;
 		break;
+	case AF9033_TUNER_FC2580:
+		len = ARRAY_SIZE(tuner_init_fc2580);
+		init = tuner_init_fc2580;
+		break;
 	default:
 		pr_debug("%s: unsupported tuner ID=%d\n", __func__,
 				state->cfg.tuner);
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index 9e302c3..3dd6edd 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -42,6 +42,7 @@ struct af9033_config {
 #define AF9033_TUNER_FC0011      0x28 /* Fitipower FC0011 */
 #define AF9033_TUNER_MXL5007T    0xa0 /* MaxLinear MxL5007T */
 #define AF9033_TUNER_TDA18218    0xa1 /* NXP TDA 18218HN */
+#define AF9033_TUNER_FC2580      0x32 /* FCI FC2580 */
 	u8 tuner;
 
 	/*
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index 0b783b9..4126255 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -466,5 +466,41 @@ static const struct reg_val tuner_init_tda18218[] = {
 	{0x80f1e6, 0x00},
 };
 
+static const struct reg_val tuner_init_fc2580[] = {
+	{ 0x800046, AF9033_TUNER_FC2580 },
+	{ 0x800057, 0x01 },
+	{ 0x800058, 0x00 },
+	{ 0x80005f, 0x00 },
+	{ 0x800060, 0x00 },
+	{ 0x800071, 0x05 },
+	{ 0x800072, 0x02 },
+	{ 0x800074, 0x01 },
+	{ 0x800079, 0x01 },
+	{ 0x800093, 0x00 },
+	{ 0x800094, 0x00 },
+	{ 0x800095, 0x00 },
+	{ 0x800096, 0x05 },
+	{ 0x8000b3, 0x01 },
+	{ 0x8000c3, 0x01 },
+	{ 0x8000c4, 0x00 },
+	{ 0x80f007, 0x00 },
+	{ 0x80f00c, 0x19 },
+	{ 0x80f00d, 0x1A },
+	{ 0x80f00e, 0x00 },
+	{ 0x80f00f, 0x02 },
+	{ 0x80f010, 0x00 },
+	{ 0x80f011, 0x02 },
+	{ 0x80f012, 0x00 },
+	{ 0x80f013, 0x02 },
+	{ 0x80f014, 0x00 },
+	{ 0x80f015, 0x02 },
+	{ 0x80f01f, 0x96 },
+	{ 0x80f020, 0x00 },
+	{ 0x80f029, 0x96 },
+	{ 0x80f02a, 0x00 },
+	{ 0x80f077, 0x01 },
+	{ 0x80f1e6, 0x01 },
+};
+
 #endif /* AF9033_PRIV_H */
 
diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index e09930c..834bfec 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -40,6 +40,7 @@ config DVB_USB_AF9035
 	select MEDIA_TUNER_FC0011 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18218 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_FC2580 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Afatech AF9035 based DVB USB receiver.
 
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 9e5bbf9..952fbdb 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -546,6 +546,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		case AF9033_TUNER_FC0011:
 		case AF9033_TUNER_MXL5007T:
 		case AF9033_TUNER_TDA18218:
+		case AF9033_TUNER_FC2580:
 			state->af9033_config[i].spec_inv = 1;
 			break;
 		default:
@@ -798,6 +799,11 @@ static struct tda18218_config af9035_tda18218_config = {
 	.i2c_wr_max = 21,
 };
 
+static struct fc2580_config af9035_fc2580_config = {
+	.i2c_addr = 0xac,
+	.clock = 16384000,
+};
+
 static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
@@ -903,6 +909,10 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		fe = dvb_attach(tda18218_attach, adap->fe[0],
 				&d->i2c_adap, &af9035_tda18218_config);
 		break;
+	case AF9033_TUNER_FC2580:
+		fe = dvb_attach(fc2580_attach, adap->fe[0],
+				&d->i2c_adap, &af9035_fc2580_config);
+		break;
 	default:
 		fe = NULL;
 	}
@@ -1126,6 +1136,8 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "AVerMedia HD Volar (A867)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_TWINSTAR,
 		&af9035_props, "AVerMedia Twinstar (A825)", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_ASUS, USB_PID_ASUS_U3100MINI_PLUS,
+		&af9035_props, "Asus U3100Mini Plus", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index bb7bc7a..4864d9a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -28,6 +28,7 @@
 #include "fc0011.h"
 #include "mxl5007t.h"
 #include "tda18218.h"
+#include "fc2580.h"
 
 struct reg_val {
 	u32 reg;
-- 
1.7.12

