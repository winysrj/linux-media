Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51689 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab2EHQ2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 12:28:41 -0400
Received: by bkcji2 with SMTP id ji2so4793758bkc.19
        for <linux-media@vger.kernel.org>; Tue, 08 May 2012 09:28:40 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Terratec Cinergy S2 USB HD Rev.2
Date: Tue, 08 May 2012 19:28:47 +0300
Message-ID: <4473281.HKDuWdYvZs@useri>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart58111857.oOTXLxZvOp"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart58111857.oOTXLxZvOp
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Terratec Cinergy S2 USB HD Rev.2 support.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
--nextPart58111857.oOTXLxZvOp
Content-Disposition: inline; filename="TERR_S2_R2.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="TERR_S2_R2.patch"

diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index 7ced62d..9a7a333 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -1243,6 +1243,13 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
 {
 	u8 obuf[3] = { 0xe, 0x80, 0 };
 	u8 ibuf[] = { 0 };
+	
+	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
+		err("command 0x0e transfer failed.");
+
+	obuf[0] = 0xe;
+	obuf[1] = 0x02;
+	obuf[2] = 1;
 
 	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
 		err("command 0x0e transfer failed.");
@@ -1536,6 +1543,7 @@ enum dw2102_table_entry {
 	X3M_SPC1400HD,
 	TEVII_S421,
 	TEVII_S632,
+	TERRATEC_CINERGY_S2_R2,
 };
 
 static struct usb_device_id dw2102_table[] = {
@@ -1556,6 +1564,7 @@ static struct usb_device_id dw2102_table[] = {
 	[X3M_SPC1400HD] = {USB_DEVICE(0x1f4d, 0x3100)},
 	[TEVII_S421] = {USB_DEVICE(0x9022, USB_PID_TEVII_S421)},
 	[TEVII_S632] = {USB_DEVICE(0x9022, USB_PID_TEVII_S632)},
+	[TERRATEC_CINERGY_S2_R2] = {USB_DEVICE(USB_VID_TERRATEC, 0x00b0)},
 	{ }
 };
 
@@ -1957,7 +1966,7 @@ static struct dvb_usb_device_properties su3000_properties = {
 		}},
 		}
 	},
-	.num_device_descs = 3,
+	.num_device_descs = 4,
 	.devices = {
 		{ "SU3000HD DVB-S USB2.0",
 			{ &dw2102_table[GENIATECH_SU3000], NULL },
@@ -1971,6 +1980,10 @@ static struct dvb_usb_device_properties su3000_properties = {
 			{ &dw2102_table[X3M_SPC1400HD], NULL },
 			{ NULL },
 		},
+		{ "Terratec Cinergy S2 USB HD Rev.2",
+			{ &dw2102_table[TERRATEC_CINERGY_S2_R2], NULL },
+			{ NULL },
+		},
 	}
 };
 
--nextPart58111857.oOTXLxZvOp--

