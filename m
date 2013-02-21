Return-path: <linux-media-owner@vger.kernel.org>
Received: from hilbi.net ([176.9.8.243]:38220 "EHLO hilbi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab3BUMXO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Feb 2013 07:23:14 -0500
From: Stephan Hilb <stephan@ecshi.net>
To: linux-media@vger.kernel.org
Cc: "Igor M. Liplianin" <liplianin@me.by>
Subject: [PATCH] media: Terratec Cinergy S2 USB HD Rev.2
Date: Thu, 21 Feb 2013 13:11:41 +0100
Message-Id: <1361448701-1982-1-git-send-email-stephan@ecshi.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Igor M. Liplianin" <liplianin@me.by>

Terratec Cinergy S2 USB HD Rev.2 support.

This commit is a corrected cherry-pick of 03228792 which got reverted in
b7e38636 because it was rebased incorrectly and introduced compilation
errors.

Signed-off-by: Stephan Hilb <stephan@ecshi.net>
---
 drivers/media/usb/dvb-usb/dw2102.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 9578a67..24cfd4b 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1548,6 +1548,7 @@ enum dw2102_table_entry {
 	X3M_SPC1400HD,
 	TEVII_S421,
 	TEVII_S632,
+	TERRATEC_CINERGY_S2_R2,
 };
 
 static struct usb_device_id dw2102_table[] = {
@@ -1568,6 +1569,7 @@ static struct usb_device_id dw2102_table[] = {
 	[X3M_SPC1400HD] = {USB_DEVICE(0x1f4d, 0x3100)},
 	[TEVII_S421] = {USB_DEVICE(0x9022, USB_PID_TEVII_S421)},
 	[TEVII_S632] = {USB_DEVICE(0x9022, USB_PID_TEVII_S632)},
+	[TERRATEC_CINERGY_S2_R2] = {USB_DEVICE(USB_VID_TERRATEC, 0x00b0)},
 	{ }
 };
 
@@ -1968,7 +1970,7 @@ static struct dvb_usb_device_properties su3000_properties = {
 		}},
 		}
 	},
-	.num_device_descs = 3,
+	.num_device_descs = 4,
 	.devices = {
 		{ "SU3000HD DVB-S USB2.0",
 			{ &dw2102_table[GENIATECH_SU3000], NULL },
@@ -1982,6 +1984,10 @@ static struct dvb_usb_device_properties su3000_properties = {
 			{ &dw2102_table[X3M_SPC1400HD], NULL },
 			{ NULL },
 		},
+		{ "Terratec Cinergy S2 USB HD Rev.2",
+			{ &dw2102_table[TERRATEC_CINERGY_S2_R2], NULL },
+			{ NULL },
+		},
 	}
 };
 
-- 
1.8.1.4

