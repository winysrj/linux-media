Return-path: <mchehab@pedra>
Received: from smtp28.orange.fr ([80.12.242.101]:59193 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab0JATzt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Oct 2010 15:55:49 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2827.orange.fr (SMTP Server) with ESMTP id 0506080002CE
	for <linux-media@vger.kernel.org>; Fri,  1 Oct 2010 21:55:48 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2827.orange.fr (SMTP Server) with ESMTP id ECDB8800028D
	for <linux-media@vger.kernel.org>; Fri,  1 Oct 2010 21:55:47 +0200 (CEST)
Received: from roazhon.bzh.lan (ARennes-256-1-120-172.w90-32.abo.wanadoo.fr [90.32.119.172])
	by mwinf2827.orange.fr (SMTP Server) with ESMTP id ACA9780002CE
	for <linux-media@vger.kernel.org>; Fri,  1 Oct 2010 21:55:47 +0200 (CEST)
From: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)
Date: Fri,  1 Oct 2010 21:55:43 +0200
Message-Id: <1285962943-20312-2-git-send-email-yann.morin.1998@anciens.enib.fr>
In-Reply-To: <1285962943-20312-1-git-send-email-yann.morin.1998@anciens.enib.fr>
References: <1285962943-20312-1-git-send-email-yann.morin.1998@anciens.enib.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The AVerTV Red HD+ (A850T) is basically the same as the existing
AVerTV Volar Black HD (A850), but is specific to the french market.
The A850T identifies itself as a A850, but has its own PID. It even
suffers from the same EEPROM deficiencies.

This is based off a collection of information gathered from the
french support forums for Ubuntu, which I tried to properly format
into this patch:
  http://forum.ubuntu-fr.org/viewtopic.php?pid=3322825

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
---
 drivers/media/dvb/dvb-usb/af9015.c      |   14 +++++++++++---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index f63cb18..8c073ab 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -966,9 +966,11 @@ error:
 		err("eeprom read failed:%d", ret);
 
 	/* AverMedia AVerTV Volar Black HD (A850) device have bad EEPROM
-	   content :-( Override some wrong values here. */
+	   content :-( Override some wrong values here. Ditto for the
+	   AVerTV Red HD+ (A850T) device. */
 	if (le16_to_cpu(udev->descriptor.idVendor) == USB_VID_AVERMEDIA &&
-	    le16_to_cpu(udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850) {
+	    ((le16_to_cpu(udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850) ||
+	     (le16_to_cpu(udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850T))) {
 		deb_info("%s: AverMedia A850: overriding config\n", __func__);
 		/* disable dual mode */
 		af9015_config.dual_mode = 0;
@@ -1299,6 +1301,7 @@ static struct usb_device_id af9015_usb_table[] = {
 	{USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_T_STICK_RC)},
 	{USB_DEVICE(USB_VID_TERRATEC,
 		USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC)},
+/* 35 */{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850T)},
 	{0},
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1361,7 +1364,7 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 
 		.i2c_algo = &af9015_i2c_algo,
 
-		.num_device_descs = 11, /* check max from dvb-usb.h */
+		.num_device_descs = 12, /* check max from dvb-usb.h */
 		.devices = {
 			{
 				.name = "Afatech AF9015 DVB-T USB2.0 stick",
@@ -1423,6 +1426,11 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 				.cold_ids = {&af9015_usb_table[34], NULL},
 				.warm_ids = {NULL},
 			},
+			{
+				.name = "AverMedia AVerTV Red HD+ (A850T)",
+				.cold_ids = {&af9015_usb_table[35], NULL},
+				.warm_ids = {NULL},
+			},
 		}
 	}, {
 		.caps = DVB_USB_IS_AN_I2C_ADAPTER,
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 436d53d..cc398ec 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -198,6 +198,7 @@
 #define USB_PID_AVERMEDIA_A309				0xa309
 #define USB_PID_AVERMEDIA_A310				0xa310
 #define USB_PID_AVERMEDIA_A850				0x850a
+#define USB_PID_AVERMEDIA_A850T				0x850b
 #define USB_PID_AVERMEDIA_A805				0xa805
 #define USB_PID_AVERMEDIA_A815M				0x815a
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
-- 
1.7.1



