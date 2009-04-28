Return-path: <linux-media-owner@vger.kernel.org>
Received: from 59-105-176-102.static.seed.net.tw ([59.105.176.102]:46001 "EHLO
	cola.voip.idv.tw" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZD1EV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 00:21:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by cola.voip.idv.tw (Postfix) with ESMTP id C114E280E6
	for <linux-media@vger.kernel.org>; Tue, 28 Apr 2009 12:13:04 +0800 (CST)
Received: from cola.voip.idv.tw ([127.0.0.1])
	by localhost (cola.voip.idv.tw [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KowC2bJaencA for <linux-media@vger.kernel.org>;
	Tue, 28 Apr 2009 12:12:46 +0800 (CST)
Received: from [192.168.200.163] (59-124-67-67.HINET-IP.hinet.net [59.124.67.67])
	by cola.voip.idv.tw (Postfix) with ESMTPSA id 5AD0C2803A
	for <linux-media@vger.kernel.org>; Tue, 28 Apr 2009 12:12:46 +0800 (CST)
Subject: [PATCH] af9015: support for KWorld MC810
From: Jesse Sung <jesse@cola.voip.idv.tw>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-50D5HYjkNFZ17J3rpwHu"
Date: Tue, 28 Apr 2009 12:11:22 +0800
Message-Id: <1240891882.8474.86.camel@jazz.tp.novell.net.tw>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-50D5HYjkNFZ17J3rpwHu
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



--=-50D5HYjkNFZ17J3rpwHu
Content-Disposition: attachment; filename="af9015-support-for-kworld-mc810.patch"
Content-Type: text/x-patch; name="af9015-support-for-kworld-mc810.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

# HG changeset patch
# User Wen-chien Jesse Sung <jesse@cola.voip.idv.tw>
# Date 1240830884 -28800
# Node ID 320b752733803ce674ddcd97645f4873bcae5e27
# Parent  2a6d95947fa1ab72a23c7aabe15dfef52e5b6d8c
af9015: support for KWorld MC810

From: Wen-chien Jesse Sung <jesse@cola.voip.idv.tw>

Add USB ID (1b80:c810) for Kworld MC810.

Priority: normal

Signed-off-by: Wen-chien Jesse Sung <jesse@cola.voip.idv.tw>

diff --git a/linux/drivers/media/dvb/dvb-usb/af9015.c b/linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c
@@ -1267,6 +1267,7 @@ static struct usb_device_id af9015_usb_t
 /* 20 */{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850)},
 	{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A805)},
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_CONCEPTRONIC_CTVDIGRCU)},
+	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_MC810)},
 	{0},
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1537,7 +1538,7 @@ static struct dvb_usb_device_properties 
 
 		.i2c_algo = &af9015_i2c_algo,
 
-		.num_device_descs = 2, /* max 9 */
+		.num_device_descs = 3, /* max 9 */
 		.devices = {
 			{
 				.name = "AverMedia AVerTV Volar GPS 805 (A805)",
@@ -1550,6 +1551,11 @@ static struct dvb_usb_device_properties 
 				.cold_ids = {&af9015_usb_table[22], NULL},
 				.warm_ids = {NULL},
 			},
+			{
+				.name = "KWorld Digial MC-810",
+				.cold_ids = {&af9015_usb_table[23], NULL},
+				.warm_ids = {NULL},
+			},
 		}
 	},
 };
diff --git a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -105,6 +105,7 @@
 #define USB_PID_KWORLD_395U				0xe396
 #define USB_PID_KWORLD_395U_2				0xe39b
 #define USB_PID_KWORLD_395U_3				0xe395
+#define USB_PID_KWORLD_MC810				0xc810
 #define USB_PID_KWORLD_PC160_2T				0xc160
 #define USB_PID_KWORLD_VSTREAM_COLD			0x17de
 #define USB_PID_KWORLD_VSTREAM_WARM			0x17df

--=-50D5HYjkNFZ17J3rpwHu--

