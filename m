Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60026 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565AbbEUUEb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 16:04:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9035: add USB ID 07ca:0337 AVerMedia HD Volar (A867)
Date: Thu, 21 May 2015 23:04:20 +0300
Message-Id: <1432238660-10228-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is AF9035 + MxL5007T.
Driver reports:
prechip_version=00 chip_version=03 chip_type=3802

Not sure if that USB ID is reserved only for HP brand or if it is
common, but the stick I have is branded as HP part no. 580715-001
rmn A867.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index be077f2..6e02a15 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -2035,6 +2035,8 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "Asus U3100Mini Plus", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
 		&af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, 0x0337,
+		&af9035_props, "AVerMedia HD Volar (A867)", NULL) },
 
 	/* IT9135 devices */
 	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135,
-- 
http://palosaari.fi/

