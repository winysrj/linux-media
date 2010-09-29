Return-path: <mchehab@pedra>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:23355 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab0I2V0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 17:26:43 -0400
From: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)
Date: Wed, 29 Sep 2010 23:18:43 +0200
Message-Id: <1285795123-11046-2-git-send-email-yann.morin.1998@anciens.enib.fr>
In-Reply-To: <1285795123-11046-1-git-send-email-yann.morin.1998@anciens.enib.fr>
References: <1285795123-11046-1-git-send-email-yann.morin.1998@anciens.enib.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The AVerTV Red HD+ (A850T) is basically the same as the existing
AVerTV Volar Black HD 9A850), but is specific to the french market.

This is a collection of information gathered from the french support
forums for Ubuntu, which I tried to properly format:
  http://forum.ubuntu-fr.org/viewtopic.php?pid=3322825

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
---
 drivers/media/dvb/dvb-usb/af9015.c      |   12 ++++++++----
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index ea1ed3b..17faeb2 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1020,9 +1020,11 @@ error:
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
@@ -1300,6 +1302,7 @@ static struct usb_device_id af9015_usb_table[] = {
 /* 30 */{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_UB383_T)},
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_395U_4)},
 	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A815M)},
+	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850T)},
 	{0},
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1518,8 +1521,9 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 			},
 			{
 				.name = "AverMedia AVerTV Volar Black HD " \
-					"(A850)",
-				.cold_ids = {&af9015_usb_table[20], NULL},
+					"(A850) / AVerTV Volar Red HD+ (A850T)",
+				.cold_ids = {&af9015_usb_table[20],
+					     &af9015_usb_table[33], NULL},
 				.warm_ids = {NULL},
 			},
 		}
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 1a774d5..f52714c 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -196,6 +196,7 @@
 #define USB_PID_AVERMEDIA_A309				0xa309
 #define USB_PID_AVERMEDIA_A310				0xa310
 #define USB_PID_AVERMEDIA_A850				0x850a
+#define USB_PID_AVERMEDIA_A850T				0x850b
 #define USB_PID_AVERMEDIA_A805				0xa805
 #define USB_PID_AVERMEDIA_A815M				0x815a
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
-- 
1.7.1

