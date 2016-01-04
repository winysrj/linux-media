Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:52717 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbcADTcx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 14:32:53 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] dw2102: Add support for Terratec Cinergy S2 USB BOX
Date: Mon,  4 Jan 2016 20:32:51 +0100
Message-Id: <1451935971-31402-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Terratec Cinergy S2 USB BOX uses a Montage M88TS2022 tuner
and a M88DS3103 demodulator, same as Technotrend TT-connect S2-4600.
This patch adds the missing USB Product ID to make it work.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/usb/dvb-usb/dw2102.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 14ef25d..9d18801 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1688,6 +1688,7 @@ enum dw2102_table_entry {
 	TECHNOTREND_S2_4600,
 	TEVII_S482_1,
 	TEVII_S482_2,
+	TERRATEC_CINERGY_S2_BOX,
 };
 
 static struct usb_device_id dw2102_table[] = {
@@ -1715,6 +1716,7 @@ static struct usb_device_id dw2102_table[] = {
 		USB_PID_TECHNOTREND_CONNECT_S2_4600)},
 	[TEVII_S482_1] = {USB_DEVICE(0x9022, 0xd483)},
 	[TEVII_S482_2] = {USB_DEVICE(0x9022, 0xd484)},
+	[TERRATEC_CINERGY_S2_BOX] = {USB_DEVICE(USB_VID_TERRATEC, 0x0105)},
 	{ }
 };
 
@@ -2232,7 +2234,7 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
 		} },
 		}
 	},
-	.num_device_descs = 3,
+	.num_device_descs = 4,
 	.devices = {
 		{ "TechnoTrend TT-connect S2-4600",
 			{ &dw2102_table[TECHNOTREND_S2_4600], NULL },
@@ -2246,6 +2248,10 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
 			{ &dw2102_table[TEVII_S482_2], NULL },
 			{ NULL },
 		},
+		{ "Terratec Cinergy S2 USB BOX",
+			{ &dw2102_table[TERRATEC_CINERGY_S2_BOX], NULL },
+			{ NULL },
+		},
 	}
 };
 
-- 
2.6.2

